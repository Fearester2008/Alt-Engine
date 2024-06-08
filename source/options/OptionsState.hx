package options;

import states.MainMenuState;
import backend.StageData;
import flixel.addons.transition.FlxTransitionableState;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Note Colors', 'Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;
	var tipText:FlxText;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Note Colors':
				openSubState(new options.NotesSubState());
			  #if android
				removeVirtualPad();
				#end
			case 'Controls':
				openSubState(new options.ControlsSubState());
			  #if android
				removeVirtualPad();
				#end
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			  #if android
				removeVirtualPad();
				#end
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
		    #if android
				removeVirtualPad();
				#end
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				MusicBeatState.switchState(new options.NoteOffsetState());
			  #if android
				removeVirtualPad();
				#end
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = EnginePreferences.data.antialiasing;
		bg.color = 0xFFea71fd;
		bg.updateHitbox();

		bg.screenCenter();
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		add(selectorRight);

		changeSelection();
		EnginePreferences.saveSettings();

		#if android
		addVirtualPad(UP_DOWN, A_B_X_Y);

		tipText = new FlxText(150, FlxG.height - 24, 0, 'Press X to Go In Android Controls Menu', 16);
			tipText.setFormat("VCR OSD Mono", 17, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			tipText.borderSize = 1.25;
			tipText.scrollFactor.set();
			tipText.antialiasing = EnginePreferences.data.antialiasing;
			add(tipText);
			tipText = new FlxText(150, FlxG.height - 44, 0, 'Press Y to Go In Hitbox Settings Menu', 16);
			tipText.setFormat("VCR OSD Mono", 17, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			tipText.borderSize = 1.25;
			tipText.scrollFactor.set();
			tipText.antialiasing = EnginePreferences.data.antialiasing;
			add(tipText);
	  	#end

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		EnginePreferences.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		AppUtil.setAppData(AppController.appName, AppController.altEngineVersion + AppController.stage, "In Options Menu: " + options[curSelected]);

		#if android
		if (MusicBeatState._virtualpad.buttonX.justPressed) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new android.AndroidControlsMenu());
		}
		if (MusicBeatState._virtualpad.buttonY.justPressed) {
			removeVirtualPad();
			openSubState(new android.HitboxSettingsSubState());
		}
		#end

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if(onPlayState)
			{
				StageData.loadDirectory(PlayState.SONG);
				MusicBeatState.switchState(new LoadingScreenState());
				LoadingScreenState.inPlayState = true;
				FlxG.sound.music.volume = 0;
			}
			else MusicBeatState.switchState(new MainMenuState());
		}
		else if (controls.ACCEPT) openSelectedSubstate(options[curSelected]);
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	override function destroy()
	{
		EnginePreferences.loadPrefs();
		super.destroy();
	}
}