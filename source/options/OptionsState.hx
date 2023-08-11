package options;

import utils.*;
#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import text.*;
import Controls;

using StringTools;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Note Colors', 'Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay'];
	private var grpOptions:FlxTypedGroup<FlixText>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	public static var fromPlayState:Bool = false;

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
				#if android
				removeVirtualPad();
				#end
			case 'Adjust Delay and Combo':
				LoadingState.loadAndSwitchState(new options.NoteOffsetState());
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

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpOptions = new FlxTypedGroup<FlixText>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:FlixText = new FlixText(0, 0, options[i], 45, FlxColor.WHITE, LEFT);
			optionText.screenCenter();
			optionText.y += (50 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		//add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		//add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();
                #if android
                addVirtualPad(UP_DOWN, A_B);
		addPadCamera();
                #end
		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		AppUtil.setAppData("FNF' Alt Engine", VersionStuff.altEngineVersion, "In The Options Menu.");


		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if(PlayState.instance != null && OptionsState.fromPlayState)
			{
				FlxG.sound.music.volume = 0;
				MusicBeatState.switchState(new PlayState());
				OptionsState.fromPlayState = false;
			}
			else
			{
				MusicBeatState.switchState(new MainMenuState());
			}
		}

		if (controls.ACCEPT) {
			openSelectedSubstate(options[curSelected]);
		}
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
}
