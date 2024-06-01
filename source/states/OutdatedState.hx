package states;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Sup bro, looks like you're running an   \n
			outdated version of Alt Engine (" + AppController.altEngineVersion + AppController.stage + " | Psych Engine v:" + AppController.psychEngineVersion + "),\n
			please update to " + AppController.updateVersion + "!\n
			Press B to proceed anyway.\n
			\n
			Thank you for using the Engine!",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);

    #if mobile
    addVirtualPad(NONE, A_B);
    #end
	}

	override function update(elapsed:Float)
	{
		AppUtil.setAppData(AppController.appName, AppController.altEngineVersion + AppController.stage, "Have Update!");

		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
				CoolUtil.openLink("https://github.com/Fearester2008/Alt-Engine/releases");
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
