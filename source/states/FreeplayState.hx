package states;

import flixel.effects.FlxFlicker;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flash.text.TextField;
import flixel.util.FlxStringUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import openfl.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
    var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';
	
    private var updateTime:Bool = true;

	var timeTxt:FlxText;
    var songLength:Float = 0;
	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var rateTxt:FlxText;
	var timeBar:FlxBar;

	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;
	var curSong:String = "";

	var selectedThing:Bool = false;
    public static var playOnOtherState:Bool = false;
	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconOpponentArray:Array<HealthIcon> = [];

	var songPercent:Float = 0;

	public static var rate:Float = 1;
	public static var rateLerp:Float = 1;

	public static var switched:Bool = false;
	
	var songPlay:Bool = false;

	var song:String = '';

	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;
	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		
		AppUtil.setAppData(VersionStuff.appName, VersionStuff.altEngineVersion + VersionStuff.stage, "In the Freeplay Menu");
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the freeplay", null);
		#end
		
		for (i in 0...WeekData.weeksList.length) {
			if(weekIsLocked(WeekData.weeksList[i])) continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);

			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}

				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		WeekData.loadTheFirstEnabledMod();

		/*		//KIND OF BROKEN NOW AND ALSO PRETTY USELESS//

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...initSonglist.length)
		{
			if(initSonglist[i] != null && initSonglist[i].length > 0) {
				var songArray:Array<String> = initSonglist[i].split(":");
				addSong(songArray[0], 0, songArray[1], Std.parseInt(songArray[2]));
			}
		}*/

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);
		
		for (i in 0...songs.length)
		{ 
			var songText:Alphabet = new Alphabet(0, 320, songs[i].songName, true);
			songText.isMenuItem = true;
			songText.changeX = false;
			songText.targetY = i - curSelected;
			grpSongs.add(songText);
			
			Paths.currentModDirectory = songs[i].folder;

		    var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;
			// using a FlxGroup is too much fuss!
			iconOpponentArray.push(icon);
			add(icon);
	    	
			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new FlixText() !!
			// songText.screenCenter(X);
		}
		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(0, 0, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr-rus.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(0, 0).makeGraphic(FlxG.width, 116, 0xFF000000);
		scoreBG.alpha = 0.8;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

        timeTxt = new FlxText(scoreText.x, scoreText.y + 66, 0, "", 24);
		timeTxt.scrollFactor.set();
		timeTxt.setFormat(Paths.font("vcr-rus.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = true;
        add(timeTxt);

		timeBar = new FlxBar(timeTxt.x * 1.2, 75, LEFT_TO_RIGHT, 400, 19, this, 'songPercent', 0, 1);
		timeBar.createImageBar(Paths.image('bars/psych/timeBarBG'),Paths.image('bars/psych/timeBar'), FlxColor.BLACK, FlxColor.WHITE);
		timeBar.numDivisions = 9800;
		timeBar.scrollFactor.set();
		timeBar.alpha = 0;
		timeBar.visible = true;
		add(timeBar);

		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		changeSelection();
		changeDiff();
		
		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 106).makeGraphic(FlxG.width, 106, 0xFF000000);
		textBG.alpha = 0.8;
		add(textBG);

		var leText:String;
		#if android
		if(ClientPrefs.language == 'English')
		leText = "Press C to open the Gameplay Changers Menu. \nPress Y to Reset your Score and Accuracy.\nHold Z and press X to reset song speed.\nHold Z and press LEFT/RIGHT for change song speed. Press X for listen or stop song.";
		else
		leText = "Нажмите C для открытия меню изменения игрового геймплея.\nНажмите Y для сброса счета и рейтинга.\nУдерживайте Z и нажмите X для сброса скорости песни.\nУдерживайте Z и нажимайте LEFT/RIGHT для изменения скорости песни. Нажмите X для прослушивания или остановки песни.";
		var size:Int = 16;
		#else
		if(ClientPrefs.language == 'English')
		leText = "Press CTRL to open the Gameplay Changers Menu.\nPress RESET to Reset your Score and Accuracy.\nHold SHIFT and press ALT to reset song speed.\nHold SHIFT and press LEFT/RIGHT for change song speed. Press P for listen or stop song.";
		else
		leText = "Нажмите CTRL для открытия меню изменения игрового геймплея.\nНажмите RESET для сброса счета и рейтинга.\nУдерживайте SHIFT и нажмите ALT для сброса скорости песни.\nУдерживайте SHIFT и нажимайте LEFT/RIGHT для изменения скорости песни. Нажмите P для прослушивания или остановки песни.";
		var size:Int = 16;
		#end
		var text:FlxText = new FlxText(0, FlxG.height - 65, FlxG.width, leText, size);
		text.setFormat(Paths.font("vcr-rus.ttf"), size, FlxColor.WHITE, LEFT);
		text.scrollFactor.set();
		add(text);

		rateTxt = new FlxText(0, text.y - 35, 0, "", 32);
        rateTxt.setFormat(Paths.font("vcr-rus.ttf"), 32, FlxColor.WHITE, FlxTextAlign.LEFT);
		rateTxt.scrollFactor.set();
		add(rateTxt);

                #if android
                addVirtualPad(FULL, A_B_C_X_Y_Z);
                addPadCamera();
                #end

		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}
	function start()
	{
		if(songPlay)
		FlxG.sound.music.fadeIn(1.2, 0, 1);
		else {
		FlxG.sound.music.fadeOut(0, 1.2);
		FlxG.sound.playMusic(Paths.music('freakyMenu'), 1);
		}
	}
	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	/*public function addWeek(songs:Array<String>, weekNum:Int, weekColor:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);
			this.songs[this.songs.length-1].color = weekColor;

			if (songCharacters.length != 1)
				num++;
		}
	}*/

	var instPlaying:Int = -1;
	var holdTime:Float = 0;
	var timeString:String;
	override function update(elapsed:Float)
	{
        timeTxt.text = timeString;
		song = songs[curSelected].songName;

		rateLerp = FlxMath.lerp(rate, rateLerp, CoolUtil.boundTo(1 - (elapsed * 15), 0, 1));

		if(song != 'freakyMenu')
		{
	   	songLength = FlxG.sound.music.length;
	   	Conductor.songPosition = FlxG.sound.music.time;
		}
	   		if(updateTime) {
			var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
			if(curTime < 0) curTime = 0;
			songPercent = (curTime / songLength);

			var songCalc:Float = (songLength - curTime);
			if(ClientPrefs.timeBarType == 'Time Elapsed' || ClientPrefs.timeBarType == 'Time Length' || ClientPrefs.timeBarType == 'Time Length Percent') songCalc = curTime;

			var secondsTotal:Int = Math.floor((songCalc / 1000) / rate);
			if(secondsTotal < 0 && ClientPrefs.timeBarType == 'Time Length') secondsTotal = 0;
			if (secondsTotal >= Math.floor(songLength / 1000))
			secondsTotal = Math.floor((songLength / 1000) / rate);

			if(ClientPrefs.timeBarType != 'Song Name') {
				timeString = TimeUtil.formativeTime(secondsTotal, false) + '(' + HelperFunctions.truncateFloat(rateLerp, 2) + 'x)';
			}
			if(ClientPrefs.timeBarType == 'Time Length') {
				timeString = '${TimeUtil.formativeTime(secondsTotal, false)} - ${TimeUtil.formativeTime(Math.floor((songLength / 1000) / rate), false)}' + '(' + HelperFunctions.truncateFloat(rateLerp, 2) + 'x)';
			}
	    	if (ClientPrefs.timeBarType == 'Song Name'){
	    	    timeString = '(' + HelperFunctions.truncateFloat(rateLerp, 2) + 'x)';
	    	}
		}
	    for (icon in iconOpponentArray)
	    {
		    var mult:Float = FlxMath.lerp(1, icon.scale.x, (CoolUtil.boundTo(1 - (elapsed * 9), 0, 1)));
		    icon.scale.set(mult, mult);
	    }

		if(ClientPrefs.language == 'English')
			diffText.text = CoolUtil.difficultyString() + ' MODE <';
			else
			diffText.text = CoolUtil.difficultyString() + ' РЕЖИМ <';

		if (FlxG.sound.music != null)
	    Conductor.songPosition = FlxG.sound.music.time;

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		FlxG.sound.music.pitch = rateLerp;

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		if(ClientPrefs.language == 'English')
			{
			scoreText.text = 'Best Score: ' + lerpScore;
			rateTxt.text = 'Rating: ' + ratingSplit.join('.') + ' %';
			}
			else
			{
			scoreText.text = 'Лучший Счёт: ' + lerpScore;
			rateTxt.text = 'Рейтинг: ' + ratingSplit.join('.') + ' %';
			}

		positionBar();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var ctrl = FlxG.keys.justPressed.CONTROL #if android || _virtualpad.buttonC.justPressed #end;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT #if android || _virtualpad.buttonZ.pressed #end) shiftMult = 3;

		if(songs.length > 1)
		{
			if (upP)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (downP)
			{
				changeSelection(shiftMult);
				holdTime = 0;
			}

			if(controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					changeDiff();
				}
			}

			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				changeDiff();
			}
		}

		if (FlxG.keys.pressed.SHIFT #if android || _virtualpad.buttonZ.pressed #end && songPlay)
			{
				if (controls.UI_LEFT_P)
				{
					rate -= 0.05;
				}
				if (controls.UI_RIGHT_P)
				{
					rate += 0.05;
				}
	
				if (FlxG.keys.justPressed.ALT #if android || _virtualpad.buttonY.justPressed #end)
				{
					rate = 1;
				}
	
				if (rate > 3)
				{
					rate = 3;
				}
				else if (rate < 0.5)
				{
					rate = 0.5;
				}
			}
			else
			{
				if (controls.UI_LEFT_P)
					changeDiff(-1);
				else if (controls.UI_RIGHT_P)
					changeDiff(1);
			}
		
		if (upP || downP) changeDiff();

		if (controls.BACK)
		{
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new states.MainMenuState());
		}

		if(ctrl)
		{
			#if android
			removeVirtualPad();
			#end
			persistentUpdate = false;
			openSubState(new substates.GameplayChangersSubstate());
			substates.GameplayChangersSubstate.fromFreeplay = true;
		}
		if(FlxG.keys.justPressed.P #if android || _virtualpad.buttonX.justPressed #end)
			{
			if(instPlaying != curSelected)
			{
				#if PRELOAD_ALL
				try
				{
				songPlay = true;
				FlxG.sound.music.volume = 0;
				Paths.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				if(song != null || song != "freakyMenu" && songPlay)
				{
				FlxG.sound.playMusic(Paths.inst(song), 0);
				Conductor.changeBPM(PlayState.SONG.bpm);
				curSong = song;
				start();
				AppUtil.setAppData(VersionStuff.appName, VersionStuff.altEngineVersion + VersionStuff.stage, "Listening - " + songs[curSelected].songName);
				}
				instPlaying = curSelected;
				persistentUpdate = true;
				persistentDraw = true;
				playOnOtherState = true;
				if(song != '' || song != "freakyMenu")
				{
				FlxTween.tween(timeBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
				FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
				}
				}
				catch(e:Dynamic)
				{
					songPlay = false;
					trace('ERROR! $e');
					var errorStr:String = e.toString();
					if(errorStr.startsWith('[file_contents,assets/data/')) errorStr = 'Missing file: ' + errorStr.substring(27, errorStr.length-1); //Missing song
					if(!switched)
					{
					MusicBeatState.switchState(new MissingFileSubState('ERROR WHILE LOADING SONG.', errorStr));
					}
					playOnOtherState = false;

					super.update(elapsed);
					return;
				}
				#end
			}
		}
		else if (accepted)
		{
			persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);

			trace(poop);

			try
				{
					FlxG.sound.play(Paths.sound('confirmMenu'),0.7);
					PlayState.SONG = Song.loadFromJson(poop, songLowercase);
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = curDifficulty;
	
					trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
					if(colorTween != null) {
						colorTween.cancel();
					}

					for (item in grpSongs.members)
					{
					if(item.targetY != 0)
					{
					FlxTween.tween(item, {alpha: 0}, 0.8, {ease: FlxEase.cubeInOut});
					for (i in 0...iconOpponentArray.length)
					{
						if(i != curSelected)
						FlxTween.tween(iconOpponentArray[i], {alpha: 0}, 0.8, {ease: FlxEase.cubeInOut});
					}
					}
					else
					{
						item.alpha = 1;
						iconOpponentArray[curSelected].alpha = 1;
					}
				}
			}
				catch(e:Dynamic)
				{
					trace('ERROR! $e');
	
					var errorStr:String = e.toString();
					if(errorStr.startsWith('[file_contents,assets/data/')) errorStr = 'Missing file: ' + errorStr.substring(27, errorStr.length-1); //Missing chart
					if(!switched)
					{
					MusicBeatState.switchState(new MissingFileSubState('ERROR WHILE LOADING CHART.', errorStr));
					}
					FlxG.sound.play(Paths.sound('cancelMenu'));
	
					super.update(elapsed);
					return;
				}

			        FlxG.sound.music.stop();
                    
		            new FlxTimer().start(1.3, function(tmr:FlxTimer)
		            {
			        if (FlxG.keys.pressed.SHIFT #if android || _virtualpad.buttonZ.pressed #end){
	                    	LoadingState.loadAndSwitchState(new ChartingState());
	                    } else {
	                    	MusicBeatState.switchState(new LoadingScreenState());
							LoadingScreenState.inPlayState = true;
	                    }
	                     
                    });
		}
		else if((controls.RESET) #if android || _virtualpad.buttonY.justPressed #end)
		{
			#if android
			removeVirtualPad();
			#end
			persistentUpdate = false;
			openSubState(new substates.ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		super.update(elapsed);
	}
	override function sectionHit()
	{
		super.sectionHit();
		
		if (PlayState.SONG.notes[curSection] != null && PlayState.SONG.notes[curSection].changeBPM)
			Conductor.changeBPM(PlayState.SONG.notes[curSection].bpm);
	}

	override function beatHit()
	{
		if(songPlay)
		{
			iconOpponentArray[curSelected].scale.set(1.2,1.2);
		}
		else {
			iconOpponentArray[curSelected].scale.set(1,1);
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;

	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
			
		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconOpponentArray.length)
		{
		    iconOpponentArray[i].alpha = 0.6;
		}

		iconOpponentArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
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
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
	}
	private function positionBar()
	{
		timeBar.x = 0 + timeTxt.width + 12;
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
} 