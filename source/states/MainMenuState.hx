package states;

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
import flixel.input.keyboard.FlxKey;
import haxe.Json;

using StringTools;

typedef MenuData = 
{
	bgP:Array<Int>,
	bgS:Array<Int>,
	bgA:Float,
	logoP:Array<Int>,
	logoS:Array<Float>,
    storyP:Array<Int>,
    freeplayP:Array<Int>,
    creditsP:Array<Int>,
    optionsP:Array<Int>,
    storyS:Array<Float>,
    freeplayS:Array<Float>,
    creditsS:Array<Float>,
    optionsS:Array<Float>,
    centerX:Bool
}
class MainMenuState extends MusicBeatState
{
	var MainJSON:MenuData;

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
				MusicBeatState.switchState(new states.StoryMenuState());
			case 'freeplay':
				MusicBeatState.switchState(new states.FreeplayState());
			case 'credits':
				MusicBeatState.switchState(new states.CreditsState());
			case 'options':
				MusicBeatState.switchState(new options.OptionsMenu());
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

		MainJSON = Json.parse(Paths.getTextFromFile('images/mainmenu/MainMenuJSON.json'));

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
		var bgItems:FlxSprite = new FlxSprite(MainJSON.bgP[0], MainJSON.bgP[1]).makeGraphic(MainJSON.bgS[0], MainJSON.bgS[1], FlxColor.BLACK);
		bgItems.updateHitbox();
		bgItems.angle = MainJSON.bgA;
		bgItems.antialiasing = ClientPrefs.globalAntialiasing;
		add(bgItems);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		logoBl = new FlxSprite(MainJSON.logoP[0], MainJSON.logoP[1]);
		logoBl.scale.set(MainJSON.logoS[0], MainJSON.logoS[1]);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.updateHitbox();
		logoBl.scrollFactor.set();
		add(logoBl);

		/*if(options.length > 6) {
			scale = 6 / options.length;
		}*/
		//StoryMenu
		var menuItem:FlxSprite = new FlxSprite(MainJSON.storyP[0],MainJSON.storyP[1]);
		menuItem.scale.x = MainJSON.storyS[0];
		menuItem.scale.y = MainJSON.storyS[1];
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + options[0]);
		menuItem.animation.addByPrefix('idle', options[0] + " basic", 24);
		menuItem.animation.addByPrefix('selected', options[0] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = 0;
		// menuItem.screenCenter(X)
		if(MainJSON.centerX == true) {
			menuItem.screenCenter(X);
		}
		menuItems.add(menuItem);
		var scr:Float = (options.length - 4) * 0.135;
		if(options.length < 6) scr = 0;
		menuItem.scrollFactor.set(0,scr);
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
		menuItem.updateHitbox();

		//freeplay
		var menuItem:FlxSprite = new FlxSprite(MainJSON.freeplayP[0],MainJSON.freeplayP[1]);
		menuItem.scale.x = MainJSON.freeplayS[0];
		menuItem.scale.y = MainJSON.freeplayS[1];
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + options[1]);
		menuItem.animation.addByPrefix('idle', options[1] + " basic", 24);
		menuItem.animation.addByPrefix('selected', options[1] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = 1;
					// menuItem.screenCenter(X);
		if(MainJSON.centerX == true) {
			menuItem.screenCenter(X);
		}
		menuItems.add(menuItem);
					var scr:Float = (options.length - 4) * 0.135;
		if(options.length < 6) scr = 0;
		menuItem.scrollFactor.set(0,scr);
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
		menuItem.updateHitbox();

		//credits
		var menuItem:FlxSprite = new FlxSprite(MainJSON.creditsP[0],MainJSON.creditsP[1]);
		menuItem.scale.x = MainJSON.creditsS[0];
		menuItem.scale.y = MainJSON.creditsS[1];
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + options[2]);
		menuItem.animation.addByPrefix('idle', options[2] + " basic", 24);
		menuItem.animation.addByPrefix('selected', options[2] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = 2;
					// menuItem.screenCenter(X);
		if(MainJSON.centerX == true) {
			menuItem.screenCenter(X);
		}
		menuItems.add(menuItem);
					var scr:Float = (options.length - 4) * 0.135;
		if(options.length < 6) scr = 0;
		menuItem.scrollFactor.set(0,scr);
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
		menuItem.updateHitbox();

		//options
		var menuItem:FlxSprite = new FlxSprite(MainJSON.optionsP[0],MainJSON.optionsP[1]);
		menuItem.scale.x = MainJSON.optionsS[0];
		menuItem.scale.y = MainJSON.optionsS[1];
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + options[3]);
		menuItem.animation.addByPrefix('idle', options[3] + " basic", 24);
		menuItem.animation.addByPrefix('selected', options[3] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.ID = 3;
		// menuItem.screenCenter(X);
		if(MainJSON.centerX == true) {
			menuItem.screenCenter(X);
		}
		menuItems.add(menuItem);
		var scr:Float = (options.length - 4) * 0.135;
		if(options.length < 6) scr = 0;
		menuItem.scrollFactor.set(0,scr);
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
		menuItem.updateHitbox();

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + VersionStuff.psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 64, 0, "Alt Engine v" + VersionStuff.altEngineVersion + VersionStuff.stage, 12);
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
		AppUtil.setAppData(VersionStuff.appName, VersionStuff.altEngineVersion + VersionStuff.stage, "In The Main Menu.");

		logoBl.animation.play('bump');
		var shiftMult:Int = 1;

		if (!selectedSomethin)
		{
			if(FlxG.keys.pressed.SHIFT #if android || _virtualpad.buttonZ.justPressed #end)
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

			if (controls.BACK) 
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new states.TitleState());
				AppUtil.setAppData(VersionStuff.appName, VersionStuff.altEngineVersion + VersionStuff.stage, "In The Title Menu.");

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
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
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
				MusicBeatState.switchState(new states.editors.MasterEditorMenu());

			}
            #end
            #if android
            if (_virtualpad.buttonC.justPressed)
            {
                selectedSomethin = true;
                MusicBeatState.switchState(new android.AndroidControlsMenu());
            }
			#end
            
            if (FlxG.keys.justPressed.CONTROL #if android || _virtualpad.buttonY.justPressed #end)
            {
                selectedSomethin = true;
                MusicBeatState.switchState(new states.ModsMenuState());
            }
			
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
			{
			   //spr.screenCenter(X)
				if(MainJSON.centerX == true){
				spr.screenCenter(X);
				}
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
					spr.centerOffsets();
				}
			});
		}
}
