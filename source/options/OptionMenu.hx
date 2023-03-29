package;

import flixel.input.gamepad.FlxGamepad;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import OptionData;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import options.OptionData.OptionCategory;

class OptionsMenu extends MusicBeatState
{
	public static var instance:OptionsMenu;

	var selector:FlxText;
	var curSelected:Int = 0;

	var options:Array<OptionCategory> = [
		new OptionCategory("Gameplay", [
			#if android
			new CustomControls("Edit a mobile controls..."),
			#end
			new CustomControlsKeys(controls),
			new DownscrollOption("Change the strumline to the TOP/BOTTOM of the screen."),
			new MiddlescrollOption("Change the strumline to the RIGHT/MIDDLE of the screen."),
			#if android
			new FastValue("Switch speed of changing value in bottom. (e.g. offset)"),
			#end
		],false)
	];

	public var acceptInput:Bool = true;

	private var currentDescription:String = "";
	private var grpControls:FlxTypedGroup<Alphabet>;
	public static var versionShit:FlxText;

	var currentSelectedCat:OptionCategory;
	var blackBorder:FlxSprite;
	override function create()
	{
		instance = this;
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuDesat"));

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...options.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false, true);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		currentDescription = "none";

		versionShit = new FlxText(5, FlxG.height + 40, 0, #if android "Offset (Left, Right" + (FlxG.save.data.fastValue == 0 ? "" : (FlxG.save.data.fastValue == 1 ? ", Fast value" : ", Fastest value")) + "): " #else "Offset (Left, Right, Shift for slow): " #end + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		
		blackBorder = new FlxSprite(-30,FlxG.height + 40).makeGraphic((Std.int(versionShit.width + 900)),Std.int(versionShit.height + 600),FlxColor.BLACK);
		blackBorder.alpha = 0.5;

		add(blackBorder);

		add(versionShit);

		FlxTween.tween(versionShit,{y: FlxG.height - 18},2,{ease: FlxEase.elasticInOut});
		FlxTween.tween(blackBorder,{y: FlxG.height - 18},2, {ease: FlxEase.elasticInOut});

		#if android
		addVirtualPad(FULL, A_B);
		#end

		super.create();
	}

	var isCat:Bool = false;
	

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (acceptInput)
		{
			if (controls.BACK && !isCat)
				FlxG.switchState(new MainMenuState());
			else if (controls.BACK)
			{
				isCat = false;
				grpControls.clear();
				for (i in 0...options.length)
				{
					var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false);
					controlLabel.isMenuItem = true;
					controlLabel.targetY = i;
					grpControls.add(controlLabel);
					// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
				}
				
				curSelected = 0;
				
				changeSelection(curSelected);
			}

			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeSelection(-1);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeSelection(1);
				}
			}
			
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			
			if (isCat)
			{
				if (currentSelectedCat.getOptions()[curSelected].getAccept())
				{
					if (FlxG.keys.pressed.SHIFT #if android || FlxG.save.data.fastValue != 0 #end)
					{
						if (controls.RIGHT)
							currentSelectedCat.getOptions()[curSelected].right();
						if (controls.LEFT)
							currentSelectedCat.getOptions()[curSelected].left();
					}
					else //fastvalue == 0
						{
							if (controls.RIGHT_P)
								currentSelectedCat.getOptions()[curSelected].right();
							if (controls.LEFT_P)
								currentSelectedCat.getOptions()[curSelected].left();
						}
				}
				else
				{
					if (FlxG.keys.pressed.SHIFT #if android || FlxG.save.data.fastValue == 0 #end)
					{
						if (controls.RIGHT_P)
							FlxG.save.data.offset += 0.1;
						else if (controls.LEFT_P)
							FlxG.save.data.offset -= 0.1;
					}
					#if android
					else if (FlxG.save.data.fastValue == 2)
					{
						if (controls.RIGHT)
							FlxG.save.data.offset += 1;
						else if (controls.LEFT)
							FlxG.save.data.offset -= 1;
					}
					#end
					//fastvalue == 1
					else if (controls.RIGHT)
						FlxG.save.data.offset += 0.1;
					else if (controls.LEFT)
						FlxG.save.data.offset -= 0.1;
					
					versionShit.text = #if android "Offset (Left, Right" + (FlxG.save.data.fastValue == 0 ? "" : (FlxG.save.data.fastValue == 1 ? ", Fast value" : ", Fastest value")) + "): " #else "Offset (Left, Right, Shift for slow): " #end + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
				}
				if (currentSelectedCat.getOptions()[curSelected].getAccept())
					versionShit.text =  currentSelectedCat.getOptions()[curSelected].getValue() + " - Description - " + currentDescription;
				else
					versionShit.text = #if android "Offset (Left, Right" + (FlxG.save.data.fastValue == 0 ? "" : (FlxG.save.data.fastValue == 1 ? ", Fast value" : ", Fastest value")) + "): " #else "Offset (Left, Right, Shift for slow): " #end + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
			}
			else
			{
				if (FlxG.keys.pressed.SHIFT #if android || FlxG.save.data.fastValue == 0 #end)
				{
					if (controls.RIGHT_P)
						FlxG.save.data.offset += 0.1;
					else if (controls.LEFT_P)
						FlxG.save.data.offset -= 0.1;
				}
				#if android
				else if (FlxG.save.data.fastValue == 2)
				{
					if (controls.RIGHT)
						FlxG.save.data.offset += 1;
					else if (controls.LEFT)
						FlxG.save.data.offset -= 1;
				}
				#end
				//fastvalue == 1
				else if (controls.RIGHT)
					FlxG.save.data.offset += 0.1;
				else if (controls.LEFT)
					FlxG.save.data.offset -= 0.1;
				
				versionShit.text = #if android "Offset (Left, Right" + (FlxG.save.data.fastValue == 0 ? "" : (FlxG.save.data.fastValue == 1 ? ", Fast value" : ", Fastest value")) + "): " #else "Offset (Left, Right, Shift for slow): " #end + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
			}
		
			#if !android
			if (controls.RESET)
					FlxG.save.data.offset = 0;
			#end

			if (controls.ACCEPT)
			{
				if (isCat)
				{
					if (currentSelectedCat.getOptions()[curSelected].press()) {
						grpControls.members[curSelected].reType(currentSelectedCat.getOptions()[curSelected].getDisplay());
						trace(currentSelectedCat.getOptions()[curSelected].getDisplay());
					}
				}
				else
				{
					currentSelectedCat = options[curSelected];
					isCat = true;
					grpControls.clear();
					for (i in 0...currentSelectedCat.getOptions().length)
						{
							var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getDisplay(), true, false);
							controlLabel.isMenuItem = true;
							controlLabel.targetY = i;
							grpControls.add(controlLabel);
							// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
						}
					curSelected = 0;
				}
				
				changeSelection();
			}
		}
		FlxG.save.flush();
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{		
		FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		if (isCat)
			currentDescription = currentSelectedCat.getOptions()[curSelected].getDescription();
		else
			currentDescription = "Please select a category";
		if (isCat)
		{
			if (currentSelectedCat.getOptions()[curSelected].getAccept())
				versionShit.text =  currentSelectedCat.getOptions()[curSelected].getValue() + " - Description - " + currentDescription;
			else
				versionShit.text = #if android "Offset (Left, Right" + (FlxG.save.data.fastValue == 0 ? "" : (FlxG.save.data.fastValue == 1 ? ", Fast value" : ", Fastest value")) + "): " #else "Offset (Left, Right, Shift for slow): " #end + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
		}
		else
			versionShit.text = #if android "Offset (Left, Right" + (FlxG.save.data.fastValue == 0 ? "" : (FlxG.save.data.fastValue == 1 ? ", Fast value" : ", Fastest value")) + "): " #else "Offset (Left, Right, Shift for slow): " #end + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
