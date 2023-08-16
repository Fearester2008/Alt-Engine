package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		AppUtil.setAppData("FNF' Alt Engine", VersionStuff.altEngineVersion + VersionStuff.stage, "In The Update Check Menu.");

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,(ClientPrefs.language == 'English') ?
			"Yo kid, looks like you're running an   \n
			outdated version of Alt Engine (" + VersionStuff.altEngineVersion + VersionStuff.stage + "),\n
			update it to " + VersionStuff.updateVersion + "!\n
			Press B to proceed anyway.\n
			\n
			Press A to install update for engine." : "Эй, чувак, похоже, ты используешь
			устаревшую версию Alt Engine (" + VersionStuff.altEngineVersion + VersionStuff.stage +"),
			обнови ее до " + VersionStuff.UpdateVersion + "!
			 Нажмите B, чтобы продолжить в любом случае.\n
			 \n
			Нажмите A, чтобы установить обновление движка.",
			32);
		warnText.setFormat(Paths.font("vcr-rus.ttf"), 32, FlxColor.WHITE, LEFT);
		warnText.screenCenter(Y);
		add(warnText);

		#if android
		addVirtualPad(NONE, A_B);
		#end
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
				CoolUtil.browserLoad("https://github.com/ShadowMario/FNF-PsychEngine/releases");
			}
			else if(controls.BACK) {
				leftState = true;
			}

			if(leftState)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new MainMenuState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
