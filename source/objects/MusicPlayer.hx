package objects;

import flixel.group.FlxGroup;
import flixel.util.*;
import flixel.ui.FlxBar;

import states.FreeplayState;
import flixel.FlxState;
/**
 * Music player used for Freeplay
 */
@:access(states.FreeplayState)
@:access(flixel.sound.FlxSound._sound)
@:access(openfl.media.Sound.__buffer)

class MusicPlayer extends MusicBeatState
{
	public var instance:FreeplayState;

	public var playing(get, never):Bool;
	public var paused(get, never):Bool;

	public var playingMusic:Bool = false;
	public var curTime:Float;

	var bg:FlxSprite;
	var songBG:FlxSprite;
	var songTxt:FlxText;

	var timePositionTxt:FlxText;
	var timeLengthTxt:FlxText;
	
	var timeBar:FlxBar;

	var playbackBG:FlxSprite;
	var playbackTxt:FlxText;

	var stateButton:Button;
	public var buttonsGrp:FlxTypedGroup<Button>;

	var wasPlaying:Bool;

	var holdPitchTime:Float = 0;
	var playbackRate(default, set):Float = 1;

	public var songPercent:Float = 0;
	public var instAmplitudeBar:ExtendBar;
	public var vocalsAmplitudeBar:ExtendBar;
	public var oppVocalsAmplitudeBar:ExtendBar;

	public var beatTween:FlxTween;

	public function new(instance:FreeplayState)
	{
		super();

		buttonsGrp = new FlxTypedGroup<Button>();
		add(buttonsGrp);

		FlxG.mouse.visible = true;
		this.instance = instance;

		var xPos:Float = FlxG.width * 0.7;

		songBG = FlxSpriteUtil.drawRoundRect(new FlxSprite().makeGraphic(FlxG.width, 25, FlxColor.TRANSPARENT), 0, 0, FlxG.width, 25, 15, 15, FlxColor.BLACK);
		songBG.scrollFactor.set();
		songBG.alpha = 0.6;
		songBG.y = (FlxG.height / 2) + 35;
		add(songBG);

		playbackBG = new FlxSprite(FlxG.width - 100, 0).makeGraphic(120, 32, 0xFF000000);
		playbackBG.alpha = 0.6;
		add(playbackBG);

		songTxt = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		songTxt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT);
		add(songTxt);

		timePositionTxt = new FlxText(0, songBG.y, 0, "test", 32);
		timePositionTxt.setFormat(Paths.font("digit.ttf"), 24, FlxColor.WHITE, LEFT);
		add(timePositionTxt);

		timeLengthTxt = new FlxText(FlxG.width - 75, songBG.y, 0, "test", 32);
		timeLengthTxt.setFormat(Paths.font("digit.ttf"), 24, FlxColor.WHITE, RIGHT);
		add(timeLengthTxt);

		timeBar = new FlxBar(75, (FlxG.height / 2) + 35, LEFT_TO_RIGHT, FlxG.width - 150, 25, this, 'songPercent', 0, 1, true);
		timeBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE);
		//timeBar.numDivisions = 3000;
		add(timeBar);

		playbackTxt = new FlxText(FlxG.width * 0.6, 20, 0, "", 32);
		playbackTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE);
		add(playbackTxt);

		instAmplitudeBar = new ExtendBar(20, FlxG.height - 120, FlxColor.BLACK, FlxColor.LIME, 10);
		add(instAmplitudeBar);

		vocalsAmplitudeBar = new ExtendBar(70, FlxG.height - 120, FlxColor.BLACK, FlxColor.LIME, 10);
		add(vocalsAmplitudeBar);
		//vocalsAmplitudeBar.setBarsSize(10, 10);

		oppVocalsAmplitudeBar = new ExtendBar(120, FlxG.height - 120, FlxColor.BLACK, FlxColor.LIME, 10);
		add(oppVocalsAmplitudeBar);
		//oppVocalsAmplitudeBar.setBarsSize(10, 10);

		buttonsList();
		switchPlayMusic();

		//beatTween = FlxTween.tween(instance.bg.scale, {}, 0);
	}

	function buttonsList()
	{
		var button = new Button(575, timeBar.y + 35, 60, 60, "►", function(){
			pauseOrResume(true);
		});
		buttonsGrp.add(button);

		var button = new Button(645, timeBar.y + 35, 60, 60, "||", function(){
			pauseOrResume(false);
		});
		buttonsGrp.add(button);

		var button = new Button(495, timeBar.y + 35, 60, 60, "◄◄", function(){

			if (playing)
				wasPlaying = true;

			pauseOrResume(true);

			curTime = FlxG.sound.music.time - 2000;

			if (curTime > FlxG.sound.music.length)
				curTime = FlxG.sound.music.length;

			FlxG.sound.music.time = curTime;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.time = curTime;

			if (FreeplayState.opponentVocals != null)
				FreeplayState.opponentVocals.time = curTime;
		});
		buttonsGrp.add(button);

		var button = new Button(725, timeBar.y + 35, 60, 60, "►►", function(){
		if (playing)
		wasPlaying = true;

		pauseOrResume(true);

		curTime = FlxG.sound.music.time + 2000;

		if (curTime > FlxG.sound.music.length)
			curTime = FlxG.sound.music.length;

		FlxG.sound.music.time = curTime;
		if (FreeplayState.vocals != null)
			FreeplayState.vocals.time = curTime;

		if (FreeplayState.opponentVocals != null)
			FreeplayState.opponentVocals.time = curTime;
		});
		buttonsGrp.add(button);

		var button = new Button(805, timeBar.y + 35, 60, 60, "P↓", function(){
			playbackRate -= 0.05;
			setPlaybackRate();
		});
		buttonsGrp.add(button);

		var button = new Button(875, timeBar.y + 35, 60, 60, "P↑", function(){
			playbackRate += 0.05;
			setPlaybackRate();
		});
		buttonsGrp.add(button);

		var button = new Button(345, timeBar.y + 35, 60, 60, "V-", function(){
			FlxG.sound.music.volume -= 0.1;
			if(FreeplayState.vocals.exists) FreeplayState.vocals.volume -= 0.1;
			if(FreeplayState.opponentVocals.exists)FreeplayState.opponentVocals.volume -= 0.1;
		});
		buttonsGrp.add(button);

		var button = new Button(415, timeBar.y + 35, 60, 60, "V+", function(){
			FlxG.sound.music.volume += 0.1;
			if(FreeplayState.vocals.exists) FreeplayState.vocals.volume += 0.1;
			if(FreeplayState.opponentVocals.exists)FreeplayState.opponentVocals.volume += 0.1;
		});
		buttonsGrp.add(button);

		var button = new Button(FlxG.width - 65, 5, 60, 60, "X", function(){
			FlxG.sound.music.stop();
			FreeplayState.destroyFreeplayVocals();
			FlxG.sound.music.volume = 0;
 			instance.instPlaying = -1;

			playingMusic = false;
			switchPlayMusic();
			FlxG.mouse.visible = false;
			instance.musicPlay = false;

			instance.camGame.zoom = 1;
			instance.iconOpponentGroup.members[FreeplayState.curSelected].scale.set(1, 1);
			instance.iconBoyfriendGroup.members[FreeplayState.curSelected].scale.set(1, 1);

			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxTween.tween(FlxG.sound.music, {volume: 1}, 1);
		});
		add(button);
	}

	function bop(camGameZoom:Float = 0.015)
	{
		if (instance.camGame.zoom < 1.35 && EnginePreferences.data.camZooms)
		{
		instance.camGame.zoom += camGameZoom;
		}
	}

	function iconBop(iconBop = 1.145)
	{
		instance.iconOpponentGroup.members[FreeplayState.curSelected].scale.set(iconBop, iconBop);
		instance.iconBoyfriendGroup.members[FreeplayState.curSelected].scale.set(iconBop, iconBop);
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!playingMusic)
		{
			return;
		}


		beatStuff(elapsed);

		var time:Float = 0;
		time = FlxG.sound.music.time / playbackRate;
		var songLength:Float = 0;
		songLength = FlxG.sound.music.length / playbackRate;

		songPercent = time / songLength;

		instAmplitudeBar.updateValue((FlxG.sound.music.exists) ? updateAmplitude(FlxG.sound.music) : 0);	
		vocalsAmplitudeBar.updateValue((FreeplayState.vocals.exists) ? updateAmplitude(FreeplayState.vocals) : 0);
		oppVocalsAmplitudeBar.updateValue((FreeplayState.opponentVocals.exists) ? updateAmplitude(FreeplayState.opponentVocals) : 0);

		instAmplitudeBar.enabled = FlxG.sound.music.exists;
		vocalsAmplitudeBar.enabled = FreeplayState.vocals.exists;
		oppVocalsAmplitudeBar.enabled = FreeplayState.opponentVocals.exists;

		if(curStep % 16 == 0)
		{
		bop();
		}

		if(curStep % 4 == 0)
		{
			iconBop();
		}

		/*if (paused && !wasPlaying)
			timeSlider.nameLabel.text = 'PLAYING: ' + instance.songs[FreeplayState.curSelected].songName + ' (PAUSED)';
		else
			.text = 'PLAYING: ' + instance.songs[FreeplayState.curSelected].songName;
*/
		positionSong();

		if (instance.controls.UI_LEFT_P)
		{
			if (playing)
				wasPlaying = true;

			pauseOrResume();

			curTime = FlxG.sound.music.time - 1000;
			instance.holdTime = 0;

			if (curTime < 0)
				curTime = 0;

			FlxG.sound.music.time = curTime;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.time = curTime;

			if (FreeplayState.opponentVocals != null)
				FreeplayState.opponentVocals.time = curTime;
		}
		if (instance.controls.UI_RIGHT_P)
		{
			if (playing)
				wasPlaying = true;

			pauseOrResume();

			curTime = FlxG.sound.music.time + 1000;
			instance.holdTime = 0;

			if (curTime > FlxG.sound.music.length)
				curTime = FlxG.sound.music.length;

			FlxG.sound.music.time = curTime;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.time = curTime;

			if (FreeplayState.opponentVocals != null)
				FreeplayState.opponentVocals.time = curTime;
		}
	
		updateTimeTxt();

		if(instance.controls.UI_LEFT || instance.controls.UI_RIGHT)
		{
			instance.holdTime += elapsed;
			if(instance.holdTime > 0.5)
			{
				curTime += 40000 * elapsed * (instance.controls.UI_LEFT ? -1 : 1);
			}

			var difference:Float = Math.abs(curTime - FlxG.sound.music.time);
			if(curTime + difference > FlxG.sound.music.length) curTime = FlxG.sound.music.length;
			else if(curTime - difference < 0) curTime = 0;

			FlxG.sound.music.time = curTime;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.time = curTime;

			if (FreeplayState.opponentVocals != null)
				FreeplayState.opponentVocals.time = curTime;

			updateTimeTxt();
		}

		if(instance.controls.UI_LEFT_R || instance.controls.UI_RIGHT_R)
		{
			FlxG.sound.music.time = curTime;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.time = curTime;

			if (FreeplayState.opponentVocals != null)
				FreeplayState.opponentVocals.time = curTime;

			if (wasPlaying)
			{
				pauseOrResume(true);
				wasPlaying = false;
			}

			updateTimeTxt();
		}
		if (instance.controls.UI_UP_P)
		{
			holdPitchTime = 0;
			playbackRate += 0.05;
			setPlaybackRate();
		}
		else if (instance.controls.UI_DOWN_P)
		{
			holdPitchTime = 0;
			playbackRate -= 0.05;
			setPlaybackRate();
		}
		if (instance.controls.UI_DOWN || instance.controls.UI_UP)
		{
			holdPitchTime += elapsed;
			if (holdPitchTime > 0.6)
			{
				playbackRate += 0.05 * (instance.controls.UI_UP ? 1 : -1);
				setPlaybackRate();
			}
		}
		if ((FreeplayState.vocals != null || FreeplayState.opponentVocals != null) && FlxG.sound.music.time > 5)
		{
			var difference:Float = Math.abs(FlxG.sound.music.time - FreeplayState.vocals.time);
			if (difference >= 5 && !paused)
			{
				pauseOrResume();
				FreeplayState.vocals.time = FlxG.sound.music.time;
				FreeplayState.opponentVocals.time = FlxG.sound.music.time;
				pauseOrResume(true);
			}
		}
		updatePlaybackTxt();

		if (#if mobile MusicBeatState._virtualpad.buttonC.justPressed || #end instance.controls.RESET)
		{
			playbackRate = 1;
			setPlaybackRate();

			FlxG.sound.music.time = 0;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.time = 0;

			if (FreeplayState.opponentVocals != null)
				FreeplayState.opponentVocals.time = 0;

			updateTimeTxt();
		}
	}

	function beatStuff(elapsed:Float)
	{
		var mult = FlxMath.lerp(1, instance.camGame.zoom, Math.exp(-elapsed * 7.125 * playbackRate));
		instance.camGame.zoom = mult;

		var mult = FlxMath.lerp(1, instance.iconOpponentGroup.members[FreeplayState.curSelected].scale.x, Math.exp(-elapsed * 6.125 * playbackRate));
		instance.iconOpponentGroup.members[FreeplayState.curSelected].scale.set(mult, mult);

		var mult = FlxMath.lerp(1, instance.iconBoyfriendGroup.members[FreeplayState.curSelected].scale.x, Math.exp(-elapsed * 6.125 * playbackRate));
		instance.iconBoyfriendGroup.members[FreeplayState.curSelected].scale.set(mult, mult);

	}

	public function pauseOrResume(resume:Bool = false) 
	{
		if (resume)
		{
			FlxG.sound.music.resume();

			if (FreeplayState.vocals != null)
				FreeplayState.vocals.resume();

			if (FreeplayState.opponentVocals != null)
				FreeplayState.opponentVocals.resume();

		}
		else 
		{
			FlxG.sound.music.pause();

			if (FreeplayState.vocals != null)
				FreeplayState.vocals.pause();

			if (FreeplayState.opponentVocals != null)
				FreeplayState.opponentVocals.pause();

		}
		positionSong();
	}
	
	public function switchPlayMusic()
	{
		FlxG.autoPause = (!playingMusic && EnginePreferences.data.autoPause);
		active = visible = playingMusic;

		instance.scoreBG.visible = instance.diffText.visible = instance.scoreText.visible = instance.diffBG.visible = instance.ratingBG.visible = instance.ratingText.visible = !playingMusic; //Hide Freeplay texts and boxes if playingMusic is true
		songTxt.visible = timePositionTxt.visible = timeLengthTxt.visible = songBG.visible = playbackTxt.visible = playbackBG.visible = timeBar.visible = playingMusic; //Show Music Player texts and boxes if playingMusic is true
		
		holdPitchTime = 0;
		instance.holdTime = 0;
		playbackRate = 1;
		updatePlaybackTxt();

		if (playingMusic)
		{
			positionSong();

			updateTimeTxt();
		}
		else
		{
			instance.positionHighscore();
		}

	}

	function updatePlaybackTxt()
	{
		var text = "";
		if (playbackRate is Int)
			text = playbackRate + '.00';
		else
		{
			var playbackRate = Std.string(playbackRate);
			if (playbackRate.split('.')[1].length < 2) // Playback rates for like 1.1, 1.2 etc
				playbackRate += '0';

			text = playbackRate;
		}
		playbackTxt.text = text + 'x';
	}

	function positionSong() 
	{
		playbackBG.x = FlxG.width - 100;
		playbackBG.y = songBG.y + 50;

		playbackTxt.x = playbackBG.x;
		playbackTxt.y = playbackBG.y;

		//instAmplitudeBar.y = songBG.y + 100;
	}

	function updateTimeTxt()
	{
		var posText = TimeUtil.formatTime(FlxG.sound.music.time / 1000 / playbackRate, false);
		var lengthText = TimeUtil.formatTime(FlxG.sound.music.length / 1000 / playbackRate, false);

		timePositionTxt.text = posText;
		timeLengthTxt.text = lengthText;
	}

	function setPlaybackRate() 
	{
		FlxG.sound.music.pitch = playbackRate;
		if (FreeplayState.vocals != null)
			FreeplayState.vocals.pitch = playbackRate;

		if (FreeplayState.opponentVocals != null)
			FreeplayState.opponentVocals.pitch = playbackRate;
	}

	function get_playing():Bool 
	{
		return FlxG.sound.music.playing;
	}

	function get_paused():Bool 
	{
		@:privateAccess return FlxG.sound.music._paused;
	}

	function set_playbackRate(value:Float):Float 
	{
		var value = FlxMath.roundDecimal(value, 2);
		if (value > 3)
			value = 3;
		else if (value <= 0.25)
			value = 0.25;
		return playbackRate = value;
	}

	#if (lime_cffi && !macro)
	function updateAmplitude(sound:FlxSound) {
		var snd = sound;
		var curAmplitude:Float = 0;		

		var midx = 100 / 2;

		var currentTime = snd.time;
		
		var buffer = snd._sound.__buffer;
		var bytes = buffer.data.buffer;
		
		var length = bytes.length - 1;
		var khz = (buffer.sampleRate / 1000);
		var channels = buffer.channels;
		var stereo = channels > 1;
		var src = buffer.src;
		var bitsPerSample = buffer.bitsPerSample;
		
		var index = Math.floor(currentTime * khz);
		var samples = 720;//Math.floor((currentTime + (((60 / Conductor.bpm) * 1000 / 4) * 16)) * khz - index);
		var samplesPerRow = samples / 720;

		var lmin:Float = 0;
		var lmax:Float = 0;
		
		var rmin:Float = 0;
		var rmax:Float = 0;

		var rows = 0;
		var render = 0;
		var prevRows = 0;
		
		var byte = 0;
		
		while (index < length) {
			if (index >= 0) {
				byte = bytes.getUInt16(index * channels * 2);

				if (byte > 65535 / 2) byte -= 65535;

				var sample = (byte / 65535);

				if (sample > 0) {
					if (sample > lmax) lmax = sample;
				} else if (sample < 0) {
					if (sample < lmin) lmin = sample;
				}

				if (stereo) {
					 byte = bytes.getUInt16((index * channels * 2) + 2);

					if (byte > 65535 / 2) byte -= 65535;

					var sample = (byte / 65535);

					if (sample > 0) {
						if (sample > rmax) rmax = sample;
					} else if (sample < 0) {
						if (sample < rmin) rmin = sample;
					}
				}
			}
			
			if (rows - prevRows >= samplesPerRow) {
				prevRows = rows + ((rows - prevRows) - 1);
				
				curAmplitude = (((rmax - rmin) * 2 * 50) / 25);

				lmin = lmax = rmin = rmax = 0;
				render++;
			}
			
			index++;
			rows++;
			if (render > (640 - 50 - 1)) break;

		}
		return curAmplitude;
	}
#end
override function stepHit()
	{
		var timeSub:Float = Conductor.songPosition - Conductor.offset;
		var syncTime:Float = 20 * playbackRate;

		if(FreeplayState.vocals.exists || FreeplayState.opponentVocals.exists)
		{
		if (Math.abs(FlxG.sound.music.time - timeSub) > syncTime ||
		(FreeplayState.vocals.length > 0 && Math.abs(FreeplayState.vocals.time - timeSub) > syncTime) ||
		(FreeplayState.opponentVocals.length > 0 && Math.abs(FreeplayState.opponentVocals.time - timeSub) > syncTime))
		{
			resyncVocals();
		}
		}
	}
	function resyncVocals():Void
		{	
			if(FreeplayState.vocals != null)
			FreeplayState.vocals.pause();

			if(FreeplayState.opponentVocals != null)
			FreeplayState.opponentVocals.pause();
	
			FlxG.sound.music.play();
			FlxG.sound.music.pitch = playbackRate;
			Conductor.songPosition = FlxG.sound.music.time;
			if (Conductor.songPosition <= FreeplayState.vocals.length && FreeplayState.vocals.exists)
			{
				FreeplayState.vocals.time = Conductor.songPosition;
				FreeplayState.vocals.pitch = playbackRate;
			}
	
			if (Conductor.songPosition <= FreeplayState.opponentVocals.length && FreeplayState.opponentVocals.exists)
			{
				FreeplayState.opponentVocals.time = Conductor.songPosition;
				FreeplayState.opponentVocals.pitch = playbackRate;
			}
			
			if(FreeplayState.vocals.exists) FreeplayState.vocals.play();
			if(FreeplayState.opponentVocals.exists) FreeplayState.opponentVocals.play();
		}
}
