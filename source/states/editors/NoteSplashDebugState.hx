package states.editors;

import objects.Note;
import objects.StrumNote;
import objects.NoteSplash;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUINumericStepper;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

class NoteSplashDebugState extends MusicBeatState
{
	var config:NoteSplashConfig;
	var forceFrame:Int = -1;
	var curSelected:Int = 0;
	var maxNotes:Int = 4;

	var selection:FlxSprite;
	var notes:FlxTypedGroup<StrumNote>;
	var splashes:FlxTypedGroup<FlxSprite>;
	
	var nameInputText:FlxInputText;
	var stepperMinFps:FlxUINumericStepper;
	var stepperMaxFps:FlxUINumericStepper;

	var offsetsText:FlxText;
	var curFrameText:FlxText;
	var curAnimText:FlxText;
	var savedText:FlxText;
	var selecArr:Array<Float> = null;

	override function create()
	{
		FlxG.camera.bgColor = FlxColor.fromHSL(0, 0, 0.5);
		selection = new FlxSprite(0, 270).makeGraphic(150, 150, FlxColor.BLACK);
		selection.alpha = 0.4;
		add(selection);

		notes = new FlxTypedGroup<StrumNote>();
		add(notes);

		splashes = new FlxTypedGroup<FlxSprite>();
		add(splashes);

		for (i in 0...maxNotes)
		{
			var x = i * 220 + 240;
			var y = 290;
			var note:StrumNote = new StrumNote(x, y, i, 0);
			note.alpha = 0.75;
			note.playAnim('static');
			notes.add(note);

			var splash:FlxSprite = new FlxSprite(x, y);
			splash.antialiasing = EnginePreferences.data.antialiasing;
			splash.setPosition(splash.x - Note.swagWidth * 0.95, splash.y - Note.swagWidth);
			splash.shader = note.rgbShader.parent.shader;
			splashes.add(splash);
		}

		//
		var txtx = 60;
		var txty = 640;
		var animName:FlxText = new FlxText(txtx, txty, 'Animation name:', 16);
		add(animName);

		nameInputText = new FlxInputText(txtx, txty + 20, 360, '', 16);
		nameInputText.callback = function(text:String, action:String)
		{
			switch(action)
			{
				case 'enter':
					nameInputText.hasFocus = false;
				
				default:
					trace('changed anim name to $text');
					config.anim = text;
					curAnim = 1;
					reloadAnims();
			}
		};
		nameInputText.focusGained = () -> FlxG.stage.window.textInputEnabled = true;
		add(nameInputText);
		
		add(new FlxText(txtx, txty - 84, 0, 'Min/Max Framerate:', 16));
		stepperMinFps = new FlxUINumericStepper(txtx, txty - 60, 1, 22, 1, 60, 0);
		stepperMinFps.name = 'min_fps';
		add(stepperMinFps);

		stepperMaxFps = new FlxUINumericStepper(txtx + 60, txty - 60, 1, 26, 1, 60, 0);
		stepperMaxFps.name = 'max_fps';
		add(stepperMaxFps);

		//
		offsetsText = new FlxText(300, 150, 680, '', 16);
		offsetsText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		offsetsText.scrollFactor.set();
		add(offsetsText);

		curFrameText = new FlxText(300, 100, 680, '', 16);
		curFrameText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		curFrameText.scrollFactor.set();
		add(curFrameText);

		curAnimText = new FlxText(300, 50, 680, '', 16);
		curAnimText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		curAnimText.scrollFactor.set();
		add(curAnimText);
		
		#if android
		var text:FlxText = new FlxText(0, 520, FlxG.width,
			"Press B to Reset animation\n
			Press A twice to save to the loaded Note Splash PNG's folder\n
			Left/Right change selected note - Arrow Keys(right) to change offset (Hold C for 10x)\n
			Z + C/X - Copy & Paste", 16);
		#else
		var text:FlxText = new FlxText(0, 520, FlxG.width,
			"Press SPACE to Reset animation\n
			Press ENTER twice to save to the loaded Note Splash PNG's folder\n
			A/D change selected note - Arrow Keys to change offset (Hold shift for 10x)\n
			Ctrl + C/Y - Copy & Paste", 16);
		#end
		text.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.scrollFactor.set();
		add(text);

		savedText = new FlxText(0, 340, FlxG.width, '', 24);
		savedText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		savedText.scrollFactor.set();
		add(savedText);

		loadFrames();
		changeSelection();
		super.create();
		FlxG.mouse.visible = true;

		#if android
		addVirtualPad(NoteSplashDebugState, NoteSplashDebugState);
		#end
	}

	var curAnim:Int = 1;
	var visibleTime:Float = 0;
	var pressEnterToSave:Float = 0;
	override function update(elapsed:Float)
	{
		AppUtil.setAppData(AppController.appName, AppController.altEngineVersion + AppController.stage, "In Note Splash Editor.");

		@:privateAccess
		cast(stepperMinFps.text_field, FlxInputText).hasFocus = cast(stepperMaxFps.text_field, FlxInputText).hasFocus = false;

		var notTyping:Bool = !nameInputText.hasFocus;
		if(FlxG.keys.justPressed.ESCAPE #if android || FlxG.android.justReleased.BACK #end && notTyping)
		{
			MusicBeatState.switchState(new MasterEditorMenu());
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			FlxG.mouse.visible = false;
		}
		super.update(elapsed);

		if(!notTyping) return;
		
		if (FlxG.keys.justPressed.A #if android || MusicBeatState._virtualpad.buttonLeft.justPressed #end) changeSelection(-1);
		else if (FlxG.keys.justPressed.D #if android || MusicBeatState._virtualpad.buttonRight.justPressed #end) changeSelection(1);

		if(maxAnims < 1) return;

		if(selecArr != null)
		{
			var movex = 0;
			var movey = 0;
			if(FlxG.keys.justPressed.LEFT #if android || MusicBeatState._virtualpad.buttonLeft2.justPressed #end) movex = -1;
			else if(FlxG.keys.justPressed.RIGHT #if android || MusicBeatState._virtualpad.buttonRight2.justPressed #end) movex = 1;

			if(FlxG.keys.justPressed.UP #if android || MusicBeatState._virtualpad.buttonUp2.justPressed #end) movey = 1;
			else if(FlxG.keys.justPressed.DOWN #if android || MusicBeatState._virtualpad.buttonDown2.justPressed #end) movey = -1;
			
			if(FlxG.keys.pressed.SHIFT #if android || MusicBeatState._virtualpad.buttonC.pressed #end)
			{
				movex *= 10;
				movey *= 10;
			}

			if(movex != 0 || movey != 0)
			{
				selecArr[0] -= movex;
				selecArr[1] += movey;
				updateOffsetText();
				splashes.members[curSelected].offset.set(10 + selecArr[0], 10 + selecArr[1]);
			}
		}

		// Copy & Paste
		if(FlxG.keys.pressed.CONTROL #if android || MusicBeatState._virtualpad.buttonZ.pressed #end)
		{
			if(FlxG.keys.justPressed.C #if android || MusicBeatState._virtualpad.buttonC.justPressed #end)
			{
				var arr:Array<Float> = selectedArray();
				if(copiedArray == null) copiedArray = [0, 0];
				copiedArray[0] = arr[0];
				copiedArray[1] = arr[1];
			}
			else if((FlxG.keys.justPressed.Y #if android || MusicBeatState._virtualpad.buttonX.justPressed #end) && copiedArray != null)
			{
				var offs:Array<Float> = selectedArray();
				offs[0] = copiedArray[0];
				offs[1] = copiedArray[1];
				splashes.members[curSelected].offset.set(10 + offs[0], 10 + offs[1]);
				updateOffsetText();
			}
		}

		// Saving
		pressEnterToSave -= elapsed;
		if(visibleTime >= 0)
		{
			visibleTime -= elapsed;
			if(visibleTime <= 0)
				savedText.visible = false;
		}

		if(FlxG.keys.justPressed.ENTER #if android || MusicBeatState._virtualpad.buttonA.justPressed #end)
		{
			savedText.text = 'Press ENTER again to save.';
			if(pressEnterToSave > 0) //save
			{
				saveFile();
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
				pressEnterToSave = 0;
				visibleTime = 3;
			}
			else
			{
				pressEnterToSave = 0.5;
				visibleTime = 0.5;
			}
			savedText.visible = true;
		}

		// Reset anim & change anim
		if (FlxG.keys.justPressed.SPACE #if android || MusicBeatState._virtualpad.buttonB.justPressed #end) changeAnim();
		else if (FlxG.keys.justPressed.S #if android || MusicBeatState._virtualpad.buttonDown.justPressed #end) changeAnim(-1);
		else if (FlxG.keys.justPressed.W #if android || MusicBeatState._virtualpad.buttonUp.justPressed #end) changeAnim(1);

		// Force frame
		var updatedFrame:Bool = false;
		if(updatedFrame = FlxG.keys.justPressed.Q #if android || MusicBeatState._virtualpad.buttonV.justPressed #end) forceFrame--;
		else if(updatedFrame = FlxG.keys.justPressed.E #if android || MusicBeatState._virtualpad.buttonD.justPressed #end) forceFrame++;

		if(updatedFrame)
		{
			if(forceFrame < 0) forceFrame = 0;
			else if(forceFrame >= maxFrame) forceFrame = maxFrame - 1;
			//trace('curFrame: $forceFrame');
			
			curFrameText.text = 'Force Frame: ${forceFrame+1} / $maxFrame\n(Press V/D to change)';
			splashes.forEachAlive(function(spr:FlxSprite) {
				spr.animation.curAnim.paused = true;
				spr.animation.curAnim.curFrame = forceFrame;
			});
		}
	}

	function updateOffsetText()
	{
		selecArr = selectedArray();
		offsetsText.text = selecArr.toString();
	}

	var texturePath:String = '';
	var copiedArray:Array<Float> = null;
	function loadFrames()
	{
		texturePath = NoteSplash.defaultNoteSplash + NoteSplash.getSplashSkinPostfix();
		splashes.forEachAlive(function(spr:FlxSprite) {
			spr.frames = Paths.getSparrowAtlas(texturePath);
		});
	
		// Initialize config
		NoteSplash.configs.clear();
		config = NoteSplash.precacheConfig(texturePath);
		if(config == null) config = NoteSplash.precacheConfig(NoteSplash.defaultNoteSplash);
		nameInputText.text = config.anim;
		stepperMinFps.value = config.minFps;
		stepperMaxFps.value = config.maxFps;
		//

		reloadAnims();
	}

	function saveFile()
	{
		#if sys
		var maxLen:Int = maxAnims * Note.colArray.length;
		var curLen:Int = config.offsets.length;
		while(curLen > maxLen)
		{
			config.offsets.pop();
			curLen = config.offsets.length;
		}

		var strToSave = config.anim + '\n' + config.minFps + ' ' + config.maxFps;
		for (offGroup in config.offsets)
			strToSave += '\n' + offGroup[0] + ' ' + offGroup[1];

		var pathSplit:Array<String> = (Paths.getPath('images/$texturePath.png', IMAGE, true).split('.png')[0] + '.txt').split(':');
		var path:String = pathSplit[pathSplit.length-1].trim();
		savedText.text = 'Saved to: $path';
		//sys.io.File.saveContent(path, strToSave);
		//var path:String = SUtil.getPath() + 'modsList.txt';
		File.saveContent(SUtil.getPath() + path, strToSave);
		#else
		savedText.text = 'Can\'t save on this platform, too bad.';  //'
		#end
	}
	
	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
	{
		if (id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper))
		{
			var nums:FlxUINumericStepper = cast sender;
			var wname = nums.name;
			switch(wname)
			{
				case 'min_fps':
					if(nums.value > stepperMaxFps.value)
						stepperMaxFps.value = nums.value;
				case 'max_fps':
					if(nums.value < stepperMinFps.value)
						stepperMinFps.value = nums.value;
			}
			config.minFps = Std.int(stepperMinFps.value);
			config.maxFps = Std.int(stepperMaxFps.value);
		}
	}

	var maxAnims:Int = 0;
	function reloadAnims()
	{
		var loopContinue:Bool = true;
		splashes.forEachAlive(function(spr:FlxSprite)
		{
			spr.animation.destroyAnimations();
		});

		maxAnims = 0;
		while(loopContinue)
		{
			var animID:Int = maxAnims + 1;
			splashes.forEachAlive(function(spr:FlxSprite)
			{
				for (i in 0...Note.colArray.length) {
					var animName = 'note$i-$animID';
					if (!addAnimAndCheck(spr, animName, '${config.anim} ${Note.colArray[i]} $animID', 24, false)) {
						loopContinue = false;
						return;
					}
					spr.animation.play(animName, true);
				}
			});
			if(loopContinue) maxAnims++;
		}
		trace('maxAnims: $maxAnims');
		changeAnim();
	}

	var maxFrame:Int = 0;
	function changeAnim(change:Int = 0)
	{
		maxFrame = 0;
		forceFrame = -1;
		if (maxAnims > 0)
		{
			curAnim += change;
			if(curAnim > maxAnims) curAnim = 1;
			else if(curAnim < 1) curAnim = maxAnims;

			curAnimText.text = 'Current Animation: $curAnim / $maxAnims\n(Press UP/DOWN(left side) to change)';
			curFrameText.text = 'Force Frame Disabled\n(Press V/D to change)';

			for (i in 0...maxNotes)
			{
				var spr:FlxSprite = splashes.members[i];
				spr.animation.play('note$i-$curAnim', true);
				
				if(maxFrame < spr.animation.curAnim.numFrames)
					maxFrame = spr.animation.curAnim.numFrames;
				
				spr.animation.curAnim.frameRate = FlxG.random.int(config.minFps, config.maxFps);
				var offs:Array<Float> = selectedArray(i);
				spr.offset.set(10 + offs[0], 10 + offs[1]);
			}
		}
		else
		{
			curAnimText.text = 'INVALID ANIMATION NAME';
			curFrameText.text = '';
		}
		updateOffsetText();
	}

	function changeSelection(change:Int = 0)
	{
		var max:Int = Note.colArray.length;
		curSelected += change;
		if(curSelected < 0) curSelected = max - 1;
		else if(curSelected >= max) curSelected = 0;

		selection.x = curSelected * 220 + 220;
		updateOffsetText();
	}

	function selectedArray(sel:Int = -1)
	{
		if(sel < 0) sel = curSelected;
		var animID:Int = sel + ((curAnim - 1) * Note.colArray.length);
		if(config.offsets[animID] == null)
		{
			while(config.offsets[animID] == null)
				config.offsets.push(config.offsets[FlxMath.wrap(animID, 0, config.offsets.length-1)].copy());
		}
		return config.offsets[FlxMath.wrap(animID, 0, config.offsets.length-1)];
	}

	function addAnimAndCheck(spr:FlxSprite, name:String, anim:String, ?framerate:Int = 24, ?loop:Bool = false)
	{
		spr.animation.addByPrefix(name, anim, framerate, loop);
		return spr.animation.getByName(name) != null;
	}

	override function destroy()
	{
		super.destroy();
	}
}