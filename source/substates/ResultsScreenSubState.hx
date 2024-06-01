package substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
#if(flixel <= "5.3.0") import flixel.system.FlxSound; #else import flixel.sound.FlxSound; #end
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import objects.*;
import states.*;
import substates.*;

class ResultsScreenSubState extends MusicBeatSubstate {
	var background:FlxSprite;
	var resultsText:FlxText;
	var endText:FlxText;
	var results:FlxText;
	var songNameText:FlxText;
	var difficultyNameTxt:FlxText;
	var judgementCounterTxt:FlxText;
	var tipTxt:FlxText;
	var tipTxtSine:Float = 0;
	var hits:Int = PlayState.instance.songHits;
	var cpuControl:Bool = PlayState.instance.cpuControlled;

	public var iconPlayer1:HealthIcon;
	public var iconPlayer2:HealthIcon;

	public function new(daResults:Array<Int>, campaignScore:Int, songMisses:Int, ratingPercent:Float) {
		super();
		background = new FlxSprite(-80).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		background.scrollFactor.set();
		background.updateHitbox();
		background.screenCenter();
		background.alpha = 0;
		background.antialiasing = EnginePreferences.data.antialiasing;
		add(background);

		resultsText = new FlxText(5, 0, 0, 'RESULTS', 72);
		resultsText.scrollFactor.set();
		resultsText.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		resultsText.updateHitbox();
		add(resultsText);

		results = new FlxText(5, resultsText.height, FlxG.width, '', 48);
		results.text = 'Sicks: ' + daResults[0] + '\nGoods: ' + daResults[1] + '\nBads: ' + daResults[2] + '\nShits: ' + daResults[3];
		results.scrollFactor.set();
		results.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		results.updateHitbox();
		add(results);

		songNameText = new FlxText(FlxG.width , 5, 0, '', 32);
		songNameText.text = "Song: " + PlayState.SONG.song;
		songNameText.scrollFactor.set();
		songNameText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songNameText.updateHitbox();
		
		add(songNameText);

		difficultyNameTxt = new FlxText(700, 29, 0, '', 24);
		difficultyNameTxt.text = "Difficulty: " + Difficulty.getString();
		difficultyNameTxt.scrollFactor.set();
		difficultyNameTxt.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		difficultyNameTxt.updateHitbox();
		add(difficultyNameTxt);

		judgementCounterTxt = new FlxText(0, 450, FlxG.width, '', 86);
		
		if(hits == 0 && cpuControl) 
		{
			judgementCounterTxt.text = 'Score: 0\nMisses: 0\nAccuracy: 0%';	
		}
		else
		{
		judgementCounterTxt.text = 'Score: ' + campaignScore + '\nMisses: ' + songMisses + '\nAccuracy: ' + ratingPercent + '%';
		}
		judgementCounterTxt.scrollFactor.set();
		judgementCounterTxt.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		judgementCounterTxt.updateHitbox();
		judgementCounterTxt.screenCenter(X);
		add(judgementCounterTxt);

		#if android
		tipTxt = new FlxText(0, 650, FlxG.width, "[Tap on B button to continue]\n[Tap on A button to restart song]", 32);
		#else
		tipTxt = new FlxText(400, 650, FlxG.width, "[Press ACCEPT to continue]\n[Press R to restart song]", 32);
		#end
		tipTxt.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		tipTxt.scrollFactor.set();
		tipTxt.screenCenter(X);
		tipTxt.visible = true;
		add(tipTxt);

		iconPlayer1 = new HealthIcon(PlayState.instance.boyfriend.healthIcon, true);
		iconPlayer1.setGraphicSize(Std.int(iconPlayer1.width * 1.2));
		iconPlayer1.updateHitbox();
		add(iconPlayer1);

		iconPlayer2 = new HealthIcon(PlayState.instance.dad.healthIcon, false);
		iconPlayer2.setGraphicSize(Std.int(iconPlayer2.width * 1.2));
		iconPlayer2.updateHitbox();
		add(iconPlayer2);

		resultsText.alpha = 0;
		results.alpha = 0;
		songNameText.alpha = 0;
		difficultyNameTxt.alpha = 0;
		judgementCounterTxt.alpha = 0;
		iconPlayer1.alpha = 0;
		iconPlayer2.alpha = 0;
		tipTxt.alpha = 0;

		iconPlayer1.setPosition(FlxG.width - iconPlayer1.width - 10, FlxG.height - iconPlayer1.height - 15);
		iconPlayer2.setPosition(10, iconPlayer1.y);

		FlxTween.tween(background, {alpha: 0.7}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(resultsText, {alpha: 1, y: 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.2});
		FlxTween.tween(songNameText, {alpha: 1, y: songNameText.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.2});
		FlxTween.tween(difficultyNameTxt, {alpha: 1, y: difficultyNameTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.4});
		FlxTween.tween(results, {alpha: 1, y: results.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.6});
		FlxTween.tween(judgementCounterTxt, {alpha: 1, y: judgementCounterTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.6});
		FlxTween.tween(iconPlayer1, {alpha: 1, y: FlxG.height - iconPlayer1.height - 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.8});
		FlxTween.tween(iconPlayer2, {alpha: 1, y: FlxG.height - iconPlayer2.height - 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.8});
		FlxTween.tween(tipTxt, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.10});

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		#if android
		addVirtualPad(NONE, B);
		#end
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		AppUtil.setAppData(AppController.appName, AppController.altEngineVersion + AppController.stage, "Results: " + PlayState.SONG.song);
		reloadPositions();

		if (tipTxt.visible) {
			tipTxtSine += 150 * elapsed;
			tipTxt.alpha = 1 - Math.sin((Math.PI * tipTxtSine) / 150);
		}
		if(PlayState.instance.boyfriend.healthIcon == null)
		iconPlayer1.changeIcon('bf');

		if(PlayState.instance.dad.healthIcon == null)
		iconPlayer2.changeIcon('bf');
		
		if(PlayState.finishedSong)
		{
		if ((controls.ACCEPT #if android || MusicBeatSubstate._virtualpad.buttonB.justPressed #end)) {
			if (PlayState.isStoryMode)
				MusicBeatState.switchState(new StoryMenuState());
			else
				MusicBeatState.switchState(new FreeplayState());
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		if(FlxG.keys.justPressed.R #if android || MusicBeatSubstate._virtualpad.buttonA.justPressed #end)
		{
			PauseSubState.restartSong();
		}
		}
	}
	private function reloadPositions()
	{
		songNameText.x = FlxG.width - songNameText.width - 6;
		difficultyNameTxt.x = FlxG.width - difficultyNameTxt.width - 6;
	}
}
