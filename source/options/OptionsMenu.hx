package options;

import flixel.FlxCamera;
import flixel.FlxSubState;
import flixel.input.gamepad.FlxGamepad;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import options.Option;
import backend.Controls;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OptionCata extends FlxSprite
{
	public var title:String;
	public var options:Array<Option>;

	public var optionObjects:FlxTypedGroup<FlxText>;

	public var titleObject:FlxText;

	public var middle:Bool = false;

	public function new(x:Float, y:Float, _title:String, _options:Array<Option>, middleType:Bool = false)
	{
		super(x, y);
		title = _title;
		middle = middleType;
		if (!middleType)
			makeGraphic(295, 64, FlxColor.BLACK);
		alpha = 0.4;

		options = _options;

		optionObjects = new FlxTypedGroup();

		titleObject = new FlxText((middleType ? 1180 / 2 : x), y + (middleType ? 0 : 16), 0, title);
		titleObject.setFormat(Paths.font("vcr.ttf"), 35, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		titleObject.borderSize = 3;

		if (middleType)
		{
			titleObject.x = 50 + ((1180 / 2) - (titleObject.fieldWidth / 2));
		}
		else
			titleObject.x += (width / 2) - (titleObject.fieldWidth / 2);

		titleObject.scrollFactor.set();

		scrollFactor.set();

		for (i in 0...options.length)
		{
			var opt = options[i];
			var text:FlxText = new FlxText((middleType ? 1180 / 2 : 72), titleObject.y + 54 + (46 * i), 0, opt.getValue());
			if (middleType)
			{
				text.screenCenter(X);
			}
			text.setFormat(Paths.font("vcr.ttf"), 35, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			text.borderSize = 3;
			text.borderQuality = 1;
			text.scrollFactor.set();
			optionObjects.add(text);
		}
	}

	public function changeColor(color:FlxColor)
	{
		makeGraphic(295, 64, color);
	}
}

class OptionsMenu extends MusicBeatSubstate
{
	public static var instance:OptionsMenu;

	public var background:FlxSprite;

	public var selectedCat:OptionCata;

	public var selectedOption:Option;

	public var selectedCatIndex = 0;
	public var selectedOptionIndex = 0;

	public var isInCat:Bool = false;

	public var options:Array<OptionCata>;

	public static var isInPause = false;

	public var shownStuff:FlxTypedGroup<FlxText>;

	public static var visibleRange = [114, 640];

	public function new(pauseMenu:Bool = false)
	{
		super();

		isInPause = pauseMenu;
	}

	public var menu:FlxTypedGroup<FlxSprite>;

	public var descText:FlxText;
	public var descBack:FlxSprite;

	override function create()
	{
        FlxG.mouse.visible = true;
		options = [
			new OptionCata(50, 40, "Notes Settings", [
				new NotesSettings(),
				new AdjustOption(),
			]),
			new OptionCata(345, 40, "Controls", [
				new KeyBindingsOption(),
			]),
			new OptionCata(640, 40, "Graphics", [
				new LowQualityOption("If checked, disables some background details, decreases loading times and improves performance."),
				new AntiAliasingOption("If unchecked, disables anti-aliasing, increases performance at the cost of sharper visuals."),
				new ShadersOption("If unchecked, disables shaders.\nIt\'s used for some visual effects, and also CPU intensive for weaker PCs."),
				new FPSCapOption("Change Framerate for game."),
				new ScreenResolution("Choose your preffered screen resolution.")
        	]),
			new OptionCata(935, 40, "Visuals", [
				new ShowSplashes("If unchecked, hitting \"Sick!\" notes won't show particles."),
				new HideHUD("If checked, hides most HUD elements."),
				new TimeBarTypeOption("What should the Time Bar display?"),
				new LanguageOption("What should be the language?"),
				new CamZoomOption("If unchecked, the camera won't zoom in on a beat hit."),
				new ScoreZoom("If unchecked, disables the Score text zooming\neverytime you hit a note."),
				new HealthBarAlpha("How much transparent should the health bar and icons be."),
				new FPSOption("If unchecked, hides FPS Counter."),
				new FPSinfo("What should be FPS counter?"),
				new HudStyle("What should be HUD?"),
				new ToggleVolumeKeys("If unchecked, volume keys has not been actived."),
				new WinningIcons("If unchecked, icons not be have winning animations."),
				new DiscordRPC("If unchecked, hides \"Playing Box\" in Discord.")
			]),
			new OptionCata(50, 105, "Gameplay", [
				new ControllerMode("Check this if you want to play with a controller instead of using your keyboard."),
				new Stacking("if checked, ratings and numbers sprites will be stacking, and memory will be much loading."),
				new DownScrollOption("If checked, notes go Down instead of Up, simple enough."), 
				new MiddleScrollOption("If checked, your notes get centered."),
				new OpponentStrumsOption("If unchecked, opponent notes get hidden."),
				new GhostTappingOption("If checked, you won't get misses from pressing keys while there are no notes able to be hit."),
				new BlurNotes("If checked, your notes going to be lighting. [WITH BOTPLAY OR WHEN OPPONENT GOING TO BE ON NOTES!]."),
				new NoReset("If checked, pressing Reset won't do anything."),
				new IconBop("What should be the icon bop?"),
				new CameraBop("What should be the camera mode?"),
				new JudgementCounter("If checked, Judgement counter should be visible."),
				new JudgementCounterType("What should be the judgement counter?"),
				new ResultsScreen("If checked, Results should be visible."),
				new HitSoundOption("Funny notes does \"Tick!\" when you hit them."),
			]),
			new OptionCata(345, 105, "Judgements", [
				new RatingOffset("Changes how late/early you have to hit for a \"Sick!\" Higher values mean you have to hit later."),
				new SickOffsetOption("Changes the amount of time you have for hitting a \"Sick!\" in milliseconds."),
				new GoodOffsetOption("Changes the amount of time you have for hitting a \"Good\" in milliseconds."),
				new BadOffsetOption("Changes the amount of time you have for hitting a \"Bad\" in milliseconds."),
				new SafeFrames("Changes how many frames you have for hitting a note earlier or late.")
			])
		];

		instance = this;

		#if debug
		FlxG.watch.add(selectedCatIndex, 'SelectedCatIndex');
		FlxG.watch.add(selectedOptionIndex, 'SelectedOptionIndex');
		#end

		menu = new FlxTypedGroup<FlxSprite>();

		shownStuff = new FlxTypedGroup<FlxText>();

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		background = new FlxSprite(50, 40).makeGraphic(1180, 640, FlxColor.BLACK);
		background.alpha = 0.5;
		background.scrollFactor.set();
		menu.add(background);

		descBack = new FlxSprite(50, 640).makeGraphic(1180, 38, FlxColor.BLACK);
		descBack.alpha = 0.3;
		descBack.scrollFactor.set();
		menu.add(descBack);

		if (isInPause)
		{
			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			bg.alpha = 0;
			bg.scrollFactor.set();
			menu.add(bg);

			background.alpha = 0.5;
			bg.alpha = 0.6;

			cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		}

		selectedCat = options[0];

		selectedOption = selectedCat.options[0];

		add(menu);

		add(shownStuff);

		for (i in 0...options.length)
		{
			var cat = options[i];
			add(cat);
			add(cat.titleObject);
		}

		descText = new FlxText(62, 648);
		descText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.borderSize = 2;

		add(descBack);
		add(descText);

		isInCat = true;

		switchCat(selectedCat);

		selectedOption = selectedCat.options[0];

        #if android
        addVirtualPad(FULL,A_B);
        #end

		super.create();
	}

	public function switchCat(cat:OptionCata, checkForOutOfBounds:Bool = true)
	{
		try
		{
			visibleRange = [114, 640];
			if (cat.middle)
				visibleRange = [Std.int(cat.titleObject.y), 640];
			if (selectedOption != null)
			{
				var object = selectedCat.optionObjects.members[selectedOptionIndex];
				object.text = selectedOption.getValue();
			}

			if (selectedCatIndex >= options.length && checkForOutOfBounds)
				selectedCatIndex = 0;

			if (selectedCat.middle)
				remove(selectedCat.titleObject);

			selectedCat.changeColor(FlxColor.BLACK);
			selectedCat.alpha = 0.3;

			for (i in 0...selectedCat.options.length)
			{
				var opt = selectedCat.optionObjects.members[i];
				opt.y = selectedCat.titleObject.y + 54 + (46 * i);
			}

			while (shownStuff.members.length != 0)
			{
				shownStuff.members.remove(shownStuff.members[0]);
			}
			selectedCat = cat;
			selectedCat.alpha = 0.2;
			selectedCat.changeColor(FlxColor.WHITE);

			if (selectedCat.middle)
				add(selectedCat.titleObject);

			for (i in selectedCat.optionObjects)
				shownStuff.add(i);

			selectedOption = selectedCat.options[0];

			if (selectedOptionIndex >= options[selectedCatIndex].options.length)
			{
				for (i in 0...selectedCat.options.length)
				{
					var opt = selectedCat.optionObjects.members[i];
					opt.y = selectedCat.titleObject.y + 54 + (46 * i);
				}
			}

			selectedOptionIndex = 0;

			if (!isInCat)
				selectOption(selectedOption);

			for (i in selectedCat.optionObjects.members)
			{
				if (i.y < visibleRange[0] - 24)
					i.alpha = 0;
				else if (i.y > visibleRange[1] - 24)
					i.alpha = 0;
				else
				{
					i.alpha = 0.4;
				}
			}
		}
		catch (e)
		{
			
			selectedCatIndex = 0;
		}

	}

	public function selectOption(option:Option)
	{
		var object = selectedCat.optionObjects.members[selectedOptionIndex];

		selectedOption = option;

		if (!isInCat)
		{
			object.text = "> " + option.getValue();

			descText.text = option.getDescription();
		}
	}
	public static function openControlsState()
		{
			MusicBeatState.switchState(new options.ControlsSubState());
			ClientPrefs.saveSettings();
		}

	public static function openNotesState()
		{
			MusicBeatState.switchState(new options.NotesSubState());
			ClientPrefs.saveSettings();
		}

    public static function openAjustState()
		{
			LoadingState.loadAndSwitchState(new options.NoteOffsetState());
			ClientPrefs.saveSettings();
		}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		var accept = false;
		var right = true;
		var left = true;
		var up = false;
		var down = false;
		var escape = false;

		accept = controls.ACCEPT;
		right = controls.UI_RIGHT_P;
		left = controls.UI_LEFT_P;
		up = controls.UI_UP_P;
		down = controls.UI_DOWN_P;
		escape = controls.BACK;

		if (selectedCat != null && !isInCat)
		{
			for (i in selectedCat.optionObjects.members)
			{
				if (selectedCat.middle)
				{
					i.screenCenter(X);
				}

				// I wanna die!!!
				if (i.y < visibleRange[0] - 24)
					i.alpha = 0;
				else if (i.y > visibleRange[1] - 24)
					i.alpha = 0;
				else
				{
					if (selectedCat.optionObjects.members[selectedOptionIndex].text != i.text)
						i.alpha = 0.4;
					else
						i.alpha = 1;
				}
			}
		}

		try
		{
			if (isInCat)
			{
				descText.text = "Please select a category";
				if (right)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
					selectedCatIndex++;

					if (selectedCatIndex >= options.length)
						selectedCatIndex = 0;
					if (selectedCatIndex < 0)
						selectedCatIndex = options.length - 1;

					switchCat(options[selectedCatIndex]);
				}
				else if (left)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
					selectedCatIndex--;

					if (selectedCatIndex >= options.length)
						selectedCatIndex = 0;
					if (selectedCatIndex < 0)
						selectedCatIndex = options.length - 1;

					switchCat(options[selectedCatIndex]);
				}

				if (accept)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					selectedOptionIndex = 0;
					isInCat = false;
					selectOption(selectedCat.options[0]);
				}

				if (escape)
				{
					if (!isInPause)
					{
					ClientPrefs.saveSettings();
						FlxG.switchState(new MainMenuState());
					}
					else
					{
					    ClientPrefs.saveSettings();
						PauseSubState.goBack = true;
						close();
					}
				}
			}
			else
			{
				if (selectedOption != null)
					if (selectedOption.acceptType)
					{
						if (escape && selectedOption.waitingType)
						{
							FlxG.sound.play(Paths.sound('scrollMenu'));
							selectedOption.waitingType = false;
							var object = selectedCat.optionObjects.members[selectedOptionIndex];
							object.text = "> " + selectedOption.getValue();
							return;
						}
					}
				if (selectedOption.acceptType || !selectedOption.acceptType)
				{
					if (accept)
					{
						var prev = selectedOptionIndex;
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.press();

						if (selectedOptionIndex == prev)
						{
							ClientPrefs.saveSettings();

							object.text = "> " + selectedOption.getValue();
						}
					}

					if (down)
					{
						if (selectedOption.acceptType)
							selectedOption.waitingType = false;
						FlxG.sound.play(Paths.sound('scrollMenu'));
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
						selectedOptionIndex++;

						// just kinda ignore this math lol

						if (selectedOptionIndex >= options[selectedCatIndex].options.length)
						{
							for (i in 0...selectedCat.options.length)
							{
								var opt = selectedCat.optionObjects.members[i];
								opt.y = selectedCat.titleObject.y + 54 + (46 * i);
							}
							selectedOptionIndex = 0;
						}

						if (selectedOptionIndex != 0
							&& options[selectedCatIndex].options.length > 6)
						{
							if (selectedOptionIndex >= (options[selectedCatIndex].options.length - 1) / 2)
								for (i in selectedCat.optionObjects.members)
								{
									i.y -= 46;
								}
						}
						selectOption(options[selectedCatIndex].options[selectedOptionIndex]);
					}
					else if (up)
					{
						if (selectedOption.acceptType)
							selectedOption.waitingType = false;
						FlxG.sound.play(Paths.sound('scrollMenu'));
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
						selectedOptionIndex--;

						// just kinda ignore this math lol

						if (selectedOptionIndex < 0)
						{
							selectedOptionIndex = options[selectedCatIndex].options.length - 1;

							if (options[selectedCatIndex].options.length > 6)
								for (i in selectedCat.optionObjects.members)
								{
									i.y -= (46 * ((options[selectedCatIndex].options.length - 1) / 2));
								}
						}

						if (selectedOptionIndex != 0 && options[selectedCatIndex].options.length > 6)
						{
							if (selectedOptionIndex >= (options[selectedCatIndex].options.length - 1) / 2)
								for (i in selectedCat.optionObjects.members)
								{
									i.y += 46;
								}
						}

						if (selectedOptionIndex < (options[selectedCatIndex].options.length - 1) / 2)
						{
							for (i in 0...selectedCat.options.length)
							{
								var opt = selectedCat.optionObjects.members[i];
								opt.y = selectedCat.titleObject.y + 54 + (46 * i);
							}
						}

						selectOption(options[selectedCatIndex].options[selectedOptionIndex]);
					}

					if (right)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.right();

						ClientPrefs.saveSettings();

						object.text = "> " + selectedOption.getValue();
					}
					else if (left)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.left();

						ClientPrefs.saveSettings();

						object.text = "> " + selectedOption.getValue();
					}

					if (escape)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));

						if (selectedCatIndex >= 4)
							selectedCatIndex = 0;

						for (i in 0...selectedCat.options.length)
						{
							var opt = selectedCat.optionObjects.members[i];
							opt.y = selectedCat.titleObject.y + 54 + (46 * i);
						}
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
						isInCat = true;
						if (selectedCat.optionObjects != null)
							for (i in selectedCat.optionObjects.members)
							{
								if (i != null)
								{
									if (i.y < visibleRange[0] - 24)
										i.alpha = 0;
									else if (i.y > visibleRange[1] - 24)
										i.alpha = 0;
									else
									{
										i.alpha = 0.4;
									}
								}
							}
						if (selectedCat.middle)
							switchCat(options[0]);
					}
				}
			}
		}
		catch (e)
		{
			selectedCatIndex = 0;
			selectedOptionIndex = 0;
			FlxG.sound.play(Paths.sound('scrollMenu'));
			if (selectedCat != null)
			{
				for (i in 0...selectedCat.options.length)
				{
					var opt = selectedCat.optionObjects.members[i];
					opt.y = selectedCat.titleObject.y + 54 + (46 * i);
				}
				selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
				isInCat = true;
			}
		}
	}
	public static function resetOptions()
	{
        FlxG.save.data.hitsound = null;
        FlxG.save.data.downScroll = null;
		FlxG.save.data.middleScroll = null;
		FlxG.save.data.showFPS = null;
		FlxG.save.data.globalAntialiasing = null;
		FlxG.save.data.noteSplashes = null;
		FlxG.save.data.lowQuality = null;
		FlxG.save.data.framerate = null;
		FlxG.save.data.camZooms = null;
		FlxG.save.data.noteOffset = null;
		FlxG.save.data.hideHud = null;
		FlxG.save.data.arrowHSV = null;
		FlxG.save.data.ghostTapping = null;
		FlxG.save.data.timeBarType = null;
		FlxG.save.data.scoreZoom = null;
		FlxG.save.data.noReset = null;
		FlxG.save.data.opponentStrums = null;
		FlxG.save.data.healthBarAlpha = 1;
		FlxG.save.data.comboOffset = null;
		FlxG.save.data.ratingOffset = null;
		FlxG.save.data.sickWindow = null;
		FlxG.save.data.goodWindow = null;
		FlxG.save.data.badWindow = null;
		FlxG.save.data.safeFrames = null;
		FlxG.save.data.gameplaySettings = null;
		FlxG.save.data.controllerMode = null;
		FlxG.save.data.customControls = ClientPrefs.keyBinds;
		FlxG.save.data.shaders = null;

        ClientPrefs.loadPrefs();

	}
}
