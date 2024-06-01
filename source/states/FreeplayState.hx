package states;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;

import flixel.FlxSubState;

import objects.HealthIcon;
import states.editors.ChartingState;

import substates.GameplayChangersSubstate;
import substates.ResetScoreSubState;

import objects.MusicPlayer;

#if MODS_ALLOWED
import sys.FileSystem;
#end

class FreeplayState extends MusicBeatState
{
	public var musicPlay:Bool = false;
	public var loading:Bool = false;
	public var loadValue:Float = 0;

	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var lerpSelected:Float = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = Difficulty.getDefault();

	var scoreBG:FlxSprite;
	var scoreText:FlxText;

	var diffBG:FlxSprite;
	var diffText:FlxText;

	var ratingBG:FlxSprite;
	var ratingText:FlxText;

	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconOpponentGroup:FlxTypedGroup<HealthIcon>;
	private var iconBoyfriendGroup:FlxTypedGroup<HealthIcon>;

	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

	var missingTextBG:FlxSprite;
	var missingText:FlxText;

	var player:MusicPlayer;

	public var camGame:FlxCamera;
	public var camHUD:FlxCamera;
	public var camPlayer:FlxCamera;
	public var camError:FlxCamera;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camPlayer = new FlxCamera();
		camError = new FlxCamera();

		camHUD.bgColor.alpha = 0;
		camPlayer.bgColor.alpha = 0;
		camError.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camPlayer, false);
		FlxG.cameras.add(camError, false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
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
				addSong(song[0], i, song[1], song[2], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		Mods.loadTopMod();

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = EnginePreferences.data.antialiasing;
		add(bg);
		bg.screenCenter();

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		iconOpponentGroup = new FlxTypedGroup<HealthIcon>();
		add(iconOpponentGroup);

		iconBoyfriendGroup = new FlxTypedGroup<HealthIcon>();
		add(iconBoyfriendGroup);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, 320, songs[i].songName, true);
			songText.targetY = i;
			grpSongs.add(songText);

			songText.scaleX = Math.min(1, 980 / songText.width);
			songText.snapToPosition();

			Mods.currentModDirectory = songs[i].folder;
			var opponentIcon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			
			// using a FlxGroup is too much fuss!
			iconOpponentGroup.add(opponentIcon);

			var boyfriendIcon:HealthIcon = new HealthIcon(songs[i].songBoyfriendCharacter);
			boyfriendIcon.sprTracker = songText;

			// too laggy with a lot of songs, so i had to recode the logic for it
			songText.visible = songText.active = songText.isMenuItem = songText.isItemCenter = false;
			opponentIcon.visible = opponentIcon.active = false;
			boyfriendIcon.visible = boyfriendIcon.active = false;

			// using a FlxGroup is too much fuss!
			iconBoyfriendGroup.add(boyfriendIcon);
		}

		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(FlxG.width * 0.7, 0, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 35, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);
		add(scoreText);

		diffText = new FlxText(FlxG.width * 0.7, scoreText.y + 40, 0, "", 32);
		diffText.font = scoreText.font;
		diffText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		diffBG = new FlxSprite(diffText.x - 6, scoreBG.y + 40).makeGraphic(1, 35, 0xFF000000);
		diffBG.alpha = 0.6;
		add(diffBG);
		add(diffText);

		ratingText = new FlxText(FlxG.width * 0.7, scoreText.y + 80, 0, "", 32);
		ratingText.font = scoreText.font;
		ratingText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		ratingBG = new FlxSprite(diffText.x - 6, scoreBG.y + 80).makeGraphic(1, 35, 0xFF000000);
		ratingBG.alpha = 0.6;
		add(ratingBG);
		add(ratingText);

		missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		missingTextBG.alpha = 0.6;
		missingTextBG.visible = false;
		add(missingTextBG);
		
		missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
		missingText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missingText.scrollFactor.set();
		missingText.visible = false;
		add(missingText);

		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;
		lerpSelected = curSelected;

		curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));
		
		player = new MusicPlayer(this);
		add(player);

		changeSelection();
		updateTexts();
		
		bg.cameras = [camGame];
		
		grpSongs.cameras = [camHUD];
		iconOpponentGroup.cameras = [camHUD];
		iconBoyfriendGroup.cameras = [camHUD];

		scoreBG.cameras = [camHUD];
		scoreText.cameras = [camHUD];

		diffBG.cameras = [camHUD];
		diffText.cameras = [camHUD];

		ratingBG.cameras = [camHUD];
		ratingText.cameras = [camHUD];

		player.cameras = [camPlayer];
		//player.buttonsGrp.cameras = [camPlayer];

		missingTextBG.cameras = [camError];
		missingText.cameras = [camError];

		#if android
                addVirtualPad(FULL, A_B_C_X_Y_Z);
                #end
                
		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, songBoyfriendCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, songBoyfriendCharacter, color));
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
	public static var inst:FlxSound = null;
	public static var vocals:FlxSound = null;
	public static var opponentVocals:FlxSound = null;
	
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7 && !musicPlay)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(loading)
			{
				if(loadValue < 1)
				{
				loadValue += 0.0065;
				//bottomText.text = "Loading...";
				}
				else 
				{
					//bottomText.text = "Loaded! Switching To Level...";
					loadValue = 1;
				}
				//bottomBGLoad.scale.set(loadValue, 1);
			}

		if(musicPlay)
			Conductor.songPosition = inst.time;
	
		if(musicPlay)
			AppUtil.setAppData(AppController.appName, AppController.altEngineVersion + AppController.stage, "In Freeplay. Listening: " + songs[curSelected].songName);
		else
			AppUtil.setAppData(AppController.appName, AppController.altEngineVersion + AppController.stage, "In Freeplay.");
	
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, FlxMath.bound(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, FlxMath.bound(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(CoolUtil.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'PERSONAL BEST: ' + lerpScore;
		ratingText.text = "CLEARED: " + ratingSplit.join('.') + '%';
		positionHighscore();

		var shiftMult:Int = 1;
        if((FlxG.keys.pressed.SHIFT #if android || MusicBeatState._virtualpad.buttonZ.pressed #end) && !player.playingMusic) shiftMult = 3;

		if (!player.playingMusic)
		{
		if(songs.length > 1)
		{
			if(FlxG.keys.justPressed.HOME)
			{
				curSelected = 0;
				changeSelection();
				holdTime = 0;	
			}
			else if(FlxG.keys.justPressed.END)
			{
				curSelected = songs.length - 1;
				changeSelection();
				holdTime = 0;	
			}
			if (controls.UI_UP_P)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (controls.UI_DOWN_P)
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
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
			}

			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeSelection(-shiftMult * FlxG.mouse.wheel, false);
			}
		}

		if (controls.UI_LEFT_P)
		{
			changeDiff(-1);
			_updateSongLastDifficulty();
		}
		else if (controls.UI_RIGHT_P)
		{
			changeDiff(1);
			_updateSongLastDifficulty();
		}
	}
		if (controls.BACK)
		{
			if (player.playingMusic)
				{
					FlxG.sound.music.stop();
					destroyFreeplayVocals();
					FlxG.sound.music.volume = 0;
					inst.volume = 0;
					instPlaying = -1;
	
					player.playingMusic = false;
					player.switchPlayMusic();
					FlxG.mouse.visible = false;
					musicPlay = false;
	
					iconOpponentGroup.members[curSelected].scale.set(1, 1);
					iconBoyfriendGroup.members[curSelected].scale.set(1, 1);
					bg.scale.set(1, 1);
	
					FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
					FlxTween.tween(FlxG.sound.music, {volume: 1}, 1);
				}
			else {
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
	}

		if((FlxG.keys.justPressed.CONTROL #if android || MusicBeatState._virtualpad.buttonC.justPressed #end) && !player.playingMusic)
		{
			persistentUpdate = false;
			var gpChangeSubState:FlxSubState = new GameplayChangersSubstate();
			gpChangeSubState.camera = camPlayer;
			openSubState(gpChangeSubState);
		}
		else if((FlxG.keys.justPressed.SPACE #if android || MusicBeatState._virtualpad.buttonX.justPressed #end) )
		{
			if(instPlaying != curSelected && !player.playingMusic)
				{
					loadSong(curSelected);
				}
				else if (instPlaying == curSelected && player.playingMusic)
				{
					player.pauseOrResume(player.paused);
				}
		}

		else if (controls.ACCEPT && !player.playingMusic)
		{
			loading = true;
			persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
			/*#if MODS_ALLOWED
			if(!FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
			#else
			if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
			#end
				poop = songLowercase;
				curDifficulty = 1;
				trace('Couldnt find file');
			}*/
			trace(poop);

			try
			{
				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;

				trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
				if(colorTween != null) {
					colorTween.cancel();
				}
			}
			catch(e:Dynamic)
			{
				trace('ERROR! $e');

				var errorStr:String = e.toString();
				if(errorStr.startsWith('[file_contents,assets/data/')) errorStr = 'Missing file: ' + errorStr.substring(34, errorStr.length-1); //Missing chart
				missingText.text = 'ERROR WHILE LOADING CHART:\n$errorStr';
				missingText.screenCenter(Y);
				missingText.visible = true;
				missingTextBG.visible = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));

				updateTexts(elapsed);
				super.update(elapsed);
				return;
			}
			for (item in grpSongs.members)
				{
				if(item.targetY != curSelected)
				{
				FlxTween.tween(item, {alpha: 0}, 0.8, {ease: FlxEase.cubeInOut});

				for (i in 0...iconOpponentGroup.length)
				{
					if(i != curSelected)
					FlxTween.tween(iconOpponentGroup.members[i], {alpha: 0}, 0.8, {ease: FlxEase.cubeInOut});
				}

				for (i in 0...iconBoyfriendGroup.length)
				{
					if(i != curSelected)
					FlxTween.tween(iconBoyfriendGroup.members[i], {alpha: 0}, 0.8, {ease: FlxEase.cubeInOut});
				}

				}
				else
				{
					item.alpha = 1;		

					for(i in 0...iconOpponentGroup.length)		
					{
					if(i == curSelected)
					iconOpponentGroup.members[i].alpha = 1;
					}

					for(i in 0...iconBoyfriendGroup.length)		
					{
					if(i == curSelected)
					iconBoyfriendGroup.members[i].alpha = 1;
					}
				}
					
			}

			FlxG.sound.play(Paths.sound('confirmMenu'),0.7);

			new FlxTimer().start(3, function(tmr:FlxTimer)
			{
				MusicBeatState.switchState(new LoadingScreenState());
				LoadingScreenState.inPlayState = true;
			});
			FlxG.sound.music.stop();
					
			destroyFreeplayVocals();
			#if (MODS_ALLOWED && desktop)
			DiscordClient.loadModRPC();
			#end
		}
		else if((controls.RESET #if android || MusicBeatState._virtualpad.buttonY.justPressed #end) && !player.playingMusic)
		{
		    #if android
			removeVirtualPad();
			#end
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}

		updateTexts(elapsed);
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;

		if(opponentVocals != null) {
			opponentVocals.stop();
			opponentVocals.destroy();
		}
		opponentVocals = null;
	}

	function changeDiff(change:Int = 0)
		{
			if (player.playingMusic)
				return;
	
			curDifficulty += change;
	
			if (curDifficulty < 0)
				curDifficulty = Difficulty.list.length-1;
			if (curDifficulty >= Difficulty.list.length)
				curDifficulty = 0;
	
			#if !switch
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
			intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
			#end
	
			lastDifficultyName = Difficulty.getString(curDifficulty);
			if (Difficulty.list.length > 1)
				diffText.text = '< ' + lastDifficultyName.toUpperCase() + ' >';
			else
				diffText.text = lastDifficultyName.toUpperCase();
	
	
			positionHighscore();
			missingText.visible = false;
			missingTextBG.visible = false;
		}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if (player.playingMusic)
			return;

		_updateSongLastDifficulty();
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		var lastList:Array<String> = Difficulty.list;
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

		var bullShit:Int = 0;

		for (i in 0...iconOpponentGroup.length)
			{
				iconOpponentGroup.members[i].alpha = 0.6;
			}
	
			iconOpponentGroup.members[curSelected].alpha = 1;
	
			for (i in 0...iconBoyfriendGroup.length)
				{
					iconBoyfriendGroup.members[i].alpha = 0.6;
				}
		
			iconBoyfriendGroup.members[curSelected].alpha = 1;
	
		for (item in grpSongs.members)
		{
			bullShit++;
			item.alpha = 0.6;
			if (item.targetY == curSelected)
				item.alpha = 1;
		}
		
		Mods.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;
		Difficulty.loadFromWeek();
		
		var savedDiff:String = songs[curSelected].lastDifficulty;
		var lastDiff:Int = Difficulty.list.indexOf(lastDifficultyName);
		if(savedDiff != null && !lastList.contains(savedDiff) && Difficulty.list.contains(savedDiff))
			curDifficulty = Math.round(Math.max(0, Difficulty.list.indexOf(savedDiff)));
		else if(lastDiff > -1)
			curDifficulty = lastDiff;
		else if(Difficulty.list.contains(Difficulty.getDefault()))
			curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(Difficulty.getDefault())));
		else
			curDifficulty = 0;

		changeDiff();
		_updateSongLastDifficulty();
	}

	inline private function _updateSongLastDifficulty()
	{
		songs[curSelected].lastDifficulty = Difficulty.getString(curDifficulty);
	}

	private function positionHighscore() {
		scoreText.x = FlxG.width - scoreText.width - 6;
		diffText.x = FlxG.width - diffText.width - 6;

		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);

		diffBG.scale.x = FlxG.width - diffText.x + 6;
		diffBG.x = FlxG.width - (diffBG.scale.x / 2);

		diffText.x = Std.int(diffBG.x + (diffBG.width / 2));
		diffText.x -= diffText.width / 2;

		ratingBG.scale.x = FlxG.width - ratingText.x + 6;
		ratingBG.x = FlxG.width - (ratingBG.scale.x / 2);

		ratingText.x = Std.int(ratingBG.x + (ratingBG.width / 2));
		ratingText.x -= ratingText.width / 2;
	}

	var _drawDistance:Int = 4;
	var _lastVisibles:Array<Int> = [];
	public function updateTexts(elapsed:Float = 0.0)
		{
			lerpSelected = FlxMath.lerp(curSelected, lerpSelected, Math.exp(-elapsed * 9.6));
			for (i in _lastVisibles)
			{
				grpSongs.members[i].visible = grpSongs.members[i].active = false;
				iconOpponentGroup.members[i].visible = iconOpponentGroup.members[i].active = false;
				iconBoyfriendGroup.members[i].visible = iconBoyfriendGroup.members[i].active = false;
			}
			_lastVisibles = [];
	
			var min:Int = Math.round(Math.max(0, Math.min(songs.length, lerpSelected - _drawDistance)));
			var max:Int = Math.round(Math.max(0, Math.min(songs.length, lerpSelected + _drawDistance)));
			for (i in min...max)
			{
				var item:Alphabet = grpSongs.members[i];
				item.visible = item.active = true;
				item.screenCenter(X);
				item.y = ((item.targetY - lerpSelected) * 1.3 * item.distancePerItem.y) + item.startPosition.y;
	
				var dadIcon:HealthIcon = iconOpponentGroup.members[i];
				dadIcon.visible = dadIcon.active = true;
				dadIcon.x = item.x - 150;
				dadIcon.y = item.y - 15;

				var bfIcon:HealthIcon = iconBoyfriendGroup.members[i];
				bfIcon.visible = bfIcon.active = true;
				bfIcon.flipX = true;
				_lastVisibles.push(i);
			}
		}
	
		public function loadSong(curSelected:Int)
			{
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				
				Mods.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
		
				var music;
				music = Paths.inst(PlayState.SONG.song, (PlayState.SONG.songPostfix.length > 0) ? PlayState.SONG.songPostfix : null);

				inst = new FlxSound();
				inst.loadEmbedded(music);
				inst.volume = 0.8;
				inst.persist = true;
				inst.looped = true;
				if (PlayState.SONG.needsVoices)
				{
					vocals = new FlxSound();
					opponentVocals = new FlxSound();

					var playerVocals;
					if(PlayState.SONG.songPostfix != null)
						playerVocals = Paths.voices(PlayState.SONG.song,  PlayState.SONG.songPostfix + '-player');
					else
						playerVocals = Paths.voices(PlayState.SONG.song, 'player');
				
					if(vocals != null) 
					{
						vocals.loadEmbedded(playerVocals != null ? playerVocals : Paths.voices(PlayState.SONG.song));
						vocals.persist = true;
						vocals.looped = true;
					}
								
					var oppVocals;
					if(PlayState.SONG.songPostfix != null)
						oppVocals = Paths.voices(PlayState.SONG.song, PlayState.SONG.songPostfix + '-opponent');
					else
						oppVocals = Paths.voices(PlayState.SONG.song, 'opponent');
				
					if(oppVocals != null)
					{
						opponentVocals.loadEmbedded(oppVocals);
						opponentVocals.persist = true;
						opponentVocals.looped = true;
					}
					FlxG.sound.list.add(inst);
					FlxG.sound.list.add(vocals);
					FlxG.sound.list.add(opponentVocals);
				}
				FlxG.sound.music.volume = 0;
				musicPlay = true;
		
				Conductor.bpm = PlayState.SONG.bpm;
				inst.play();
		
				if(vocals != null) //Sync vocals to Inst
				{
					vocals.play();
					vocals.volume = 0.8;
				}
						
				if(opponentVocals != null) //Sync vocals to Inst
				{
					opponentVocals.play();
					opponentVocals.volume = 0.8;
				}
				instPlaying = curSelected;
		
				player.playingMusic = true;
				player.curTime = 0;
				player.switchPlayMusic();
				FlxG.mouse.visible = true;
	}
	override function destroy():Void
		{
			super.destroy();
	
			FlxG.autoPause = EnginePreferences.data.autoPause;
		}	
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var songBoyfriendCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";
	public var lastDifficulty:String = null;

	public function new(song:String, week:Int, songCharacter:String, songBoyfriendCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.songBoyfriendCharacter = songBoyfriendCharacter;
		this.color = color;
		this.folder = Mods.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}
