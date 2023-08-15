package;

import utils.*;


#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	
    public static var curSelected:Int = 0;
	public static var firstStart:Bool = true;
	public static var finishedAnim:Bool = true;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var logoBl:FlxSprite;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var options:Array<String> = [
		'story_mode',
		'freeplay',
		'credits',
		'options'
	];

	var magenta:FlxSprite;

	var debugKeys:Array<FlxKey>;

    function openSelectedSubstate(label:String)
	{
		switch (label)
		{
			case 'story_mode':
				MusicBeatState.switchState(new StoryMenuState());
			case 'freeplay':
				MusicBeatState.switchState(new FreeplayState());
			case 'credits':
				MusicBeatState.switchState(new CreditsState());
			case 'options':
				MusicBeatState.switchState(new options.OptionsState());
		}
	}
	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (options.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		
		// magenta.scrollFactor.set();
		var bgItems:FlxSprite = new FlxSprite(-80).makeGraphic(600, 1360, FlxColor.BLACK);
		bgItems.updateHitbox();
		bgItems.angle = 10;
		bgItems.screenCenter(Y);
		bgItems.antialiasing = ClientPrefs.globalAntialiasing;
		add(bgItems);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		logoBl = new FlxSprite(585, 0);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.setGraphicSize(Std.int(logoBl.width * 0.8));
		logoBl.screenCenter(Y);
		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.updateHitbox();
		logoBl.scrollFactor.set();
		add(logoBl);

		var scale:Float = 0.7;
		/*if(options.length > 6) {
			scale = 6 / options.length;
		}*/

		for (i in 0...options.length)
		{
			var offset:Float = 108 - (Math.max(options.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(90, (i * 140)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + options[i]);
			menuItem.animation.addByPrefix('idle', options[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', options[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			//menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (options.length - 4) * 0.135;
			if(options.length < 5) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();

			if(firstStart)
			{
				FlxTween.tween(menuItem, {y: 60 + (i * 160)}, 1 + (i * 0.25), {
					ease: FlxEase.expoInOut, 
					onComplete: function(tween:FlxTween)
					{
						finishedAnim = true;
						changeItem();
					}
				});
			}
			else
			{
				menuItem.y = 60 + (i * 160);
			}
		}

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Alt Engine v" + VersionStuff.altEngineVersion + VersionStuff.stage, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" +  Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if android
		addVirtualPad(UP_DOWN, A_B_C_X_Y_Z);
		#end

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		AppUtil.setAppData("FNF' Alt Engine", VersionStuff.altEngineVersion + VersionStuff.stage, "In The Main Menu.");
		logoBl.animation.play('bump');
		var shiftMult:Int = 1;

		if (!selectedSomethin)
		{
			if(FlxG.keys.pressed.SHIFT)
			{
				shiftMult = 3;
			}
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1 * shiftMult);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1 * shiftMult);
			}

			if (#if android FlxG.android.justReleased.BACK || #end FlxG.keys.pressed.BACKSPACE) 
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
				AppUtil.setAppData("FNF' Alt Engine", VersionStuff.altEngineVersion + VersionStuff.stage, "In The Title Menu.");

			}
			if(FlxG.mouse.wheel != 0)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
					changeItem(FlxG.mouse.wheel);
				}

			if (controls.ACCEPT)
			{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {x: -900 , alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								openSelectedSubstate(options[curSelected]);
							});
						}
					});
			}
			#if (desktop || android)
			else if (FlxG.keys.anyJustPressed(debugKeys) #if android || _virtualpad.buttonX.justPressed #end)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());

			}
            #end
            #if android
            if (_virtualpad.buttonC.justPressed)
            {
                selectedSomethin = true;
                MusicBeatState.switchState(new android.AndroidControlsMenu());
            }
			#end
            
            if (FlxG.keys.justPressed.CONTROL #if android || _virtualpad.buttonZ.justPressed #end)
            {
                selectedSomethin = true;
                MusicBeatState.switchState(new ModsMenuState());
            }
			
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				FlxTween.tween(spr, {x: 130}, 0.3, {
					ease: FlxEase.circInOut
				});
				spr.centerOffsets();
			}
			else
			{
				FlxTween.tween(spr, {x: 90}, 0.3, {
					ease: FlxEase.circInOut
				});
			}
		});
	}
}
