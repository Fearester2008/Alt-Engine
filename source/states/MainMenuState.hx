package states;

import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import haxe.Json;
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
	var logoBl:FlxSprite;
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var options:Array<String> = [
		'story_mode',
		'freeplay',
		'credits',
		'options'
	];

	var magenta:FlxSprite;

	override function create()
	{
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		MainJSON = Json.parse(Paths.getTextFromFile('images/mainmenu/MainMenuJSON.json'));

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, 1);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, 1);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		logoBl = new FlxSprite(MainJSON.logoP[0], MainJSON.logoP[1]);
		logoBl.scale.set(MainJSON.logoS[0], MainJSON.logoS[1]);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = ClientPrefs.data.antialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.updateHitbox();
		logoBl.scrollFactor.set();
		add(logoBl);

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
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
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
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
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
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
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
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
		menuItem.updateHitbox();

		var psychVer:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + AppController.psychEngineVersion, 12);
		psychVer.scrollFactor.set();
		psychVer.screenCenter(X);
		psychVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(psychVer);
		var altVer:FlxText = new FlxText(12, FlxG.height - 64, 0, "Alt Engine v" + AppController.altEngineVersion + AppController.stage, 12);
		altVer.scrollFactor.set();
		altVer.screenCenter(X);
		altVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(altVer);
		var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" +  Application.current.meta.get('version'), 12);
		fnfVer.scrollFactor.set();
		fnfVer.screenCenter(X);
		fnfVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(fnfVer);

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end

		addVirtualPad(UP_DOWN, A_B_C_X_Y);
		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		AppUtil.setAppData(AppController.appName, AppController.altEngineVersion + AppController.stage, "In The Main Menu.");

		logoBl.animation.play('bump');
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
					selectedSomethin = true;

					if (ClientPrefs.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						openOption(options[curSelected]);
					});

					for (i in 0...menuItems.members.length)
					{
						if (i == curSelected)
							continue;
						FlxTween.tween(menuItems.members[i], {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								menuItems.members[i].kill();
							}
						});
					}
			}
			#if MODS_ALLOWED
			else if (controls.justPressed('debug_1') || virtualPad.buttonC.justPressed)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			else if (FlxG.keys.justPressed.M #if android || virtualPad.buttonX.justPressed#end)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new ModsMenuState());
			}
			#end
			#if ACHIEVEMENTS_ALLOWED
			else if (FlxG.keys.justPressed.A #if android || virtualPad.buttonY.justPressed#end)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new AchievementsMenuState());
			}
			#end
			else if (FlxG.keys.justPressed.T)
				{
					selectedSomethin = true;
					MusicBeatState.switchState(new TerminalState());
				}
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));
		menuItems.members[curSelected].animation.play('idle');
		menuItems.members[curSelected].updateHitbox();
		if(MainJSON.centerX)
		menuItems.members[curSelected].screenCenter(X);

		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.members[curSelected].animation.play('selected');
		menuItems.members[curSelected].centerOffsets();
		if(MainJSON.centerX)
		menuItems.members[curSelected].screenCenter(X);
	}
	function openOption(option:String)
	{
		switch (option)
						{
							case 'story_mode':
								MusicBeatState.switchState(new StoryMenuState());
							case 'freeplay':
								MusicBeatState.switchState(new FreeplayState());
/*
							#if MODS_ALLOWED
							case 'mods':
								MusicBeatState.switchState(new ModsMenuState());
							#end

							#if ACHIEVEMENTS_ALLOWED
							case 'awards':
								MusicBeatState.switchState(new AchievementsMenuState());
							#end
*/
							case 'credits':
								MusicBeatState.switchState(new CreditsState());
							case 'options':
								MusicBeatState.switchState(new OptionsState());
								OptionsState.onPlayState = false;
								if (PlayState.SONG != null)
								{
									PlayState.SONG.arrowSkin = null;
									PlayState.SONG.splashSkin = null;
									PlayState.stageUI = 'normal';
								}
						}
	}
}
