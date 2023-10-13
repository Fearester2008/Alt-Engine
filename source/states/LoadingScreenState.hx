package states;

import flixel.FlxSprite;
import flixel.ui.FlxBar;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
class LoadingScreenState extends MusicBeatState
{
    public var progress:Float = 0;
    public var progressLerp:Float = 0;
    public var max:Float = 1;
    public var percent:Float = 0;

    public static var inPlayState:Bool = false;

    //for restart song
    public static var needRestart:Bool = false;
    
    public static var startLoading:Bool;

    var funkay:FlxSprite;
	var logo:FlxSprite;
	var loadBar:FlxBar;
    var loadTxt:FlxText;
    var endBg:FlxSprite;

    //FOR CACHE
    public static var imagesToCache:Array<String> = [];
    public static var soundsToCache:Array<String> = [];
    public static var musicToCache:Array<String> = [];
    public static var songsToCache:Array<String> = [];
    public static var videosToCache:Array<String> = [];

    override function create()
    {
        super.create();
        FlxG.camera.bgColor.alpha = 1;

        funkay = new FlxSprite(0, 0).loadGraphic(Paths.image('menuDesat'));
		funkay.updateHitbox();
		funkay.color = 0xFFFF6600;
		funkay.antialiasing = ClientPrefs.globalAntialiasing;
		add(funkay);
		funkay.scrollFactor.set();
		funkay.screenCenter();

		logo = new FlxSprite(0, 0).loadGraphic(Paths.image('logoBump'));
		logo.updateHitbox();
		logo.y -= 30;
		logo.antialiasing = ClientPrefs.globalAntialiasing;
		add(logo);
		logo.scrollFactor.set();
		logo.screenCenter(X);

		loadBar = new FlxBar(0, FlxG.height - 40, LEFT_TO_RIGHT, 720, 25, this, 'progress', 0, 1);
        loadBar.filledCallback = goToState;
        loadBar.screenCenter(X);
        loadBar.numDivisions = 3000;
		loadBar.antialiasing = ClientPrefs.globalAntialiasing;
		loadBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		add(loadBar);

        loadTxt = new FlxText((FlxG.width / 2) - 90, FlxG.height - 40, 0, "", 24);
		loadTxt.scrollFactor.set();
		loadTxt.setFormat(Paths.font("vcr-rus.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(loadTxt);
        trace('Loading... ' + percent + "%");

        startLoading = true;
    }
    override function update(elapsed:Float)
    {
        super.update(elapsed);
       
        percent = HelperFunctions.truncateFloat(progress * 100, 0); 
        loadTxt.text = "Loading... " + percent + "%";
        if(progress >= 1)
        {
        progress = 1;
        startLoading = false;
        loadTxt.text = "Loading... 100%";
        trace("Loaded...");
        }
        else
        {
            progress += FlxG.random.float(0.000001, 0.009);
        }
    }
    function goToState()
    {
        if (inPlayState)
        LoadingState.loadAndSwitchState(new PlayState(), false);
        else
        MusicBeatState.switchState(new TitleState());
    }
}