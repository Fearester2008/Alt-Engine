
package states;

import flixel.graphics.FlxGraphic;

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
import openfl.display.BitmapData;
using StringTools;
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
    var loadTween:FlxTween;

    override function create()
    {
        
        Paths.clearStoredMemory(); 
		Paths.clearUnusedMemory();
        LoadingUtil.loading();

        FlxG.mouse.visible = true;

		FlxG.worldBounds.set(0,0);
        
        super.create();
        
        FlxG.camera.bgColor.alpha = 1;

        funkay = new FlxSprite(0, 0).loadGraphic(Paths.image('menuDesat'));
		funkay.updateHitbox();
		funkay.color = 0xFF0084FF;
		funkay.antialiasing = EnginePreferences.data.antialiasing;
		//add(funkay);
		funkay.scrollFactor.set();
		funkay.screenCenter();

		logo = new FlxSprite(0, 0).loadGraphic(Paths.image('logoBump'));
		logo.updateHitbox();
		logo.y -= 30;
		logo.antialiasing = EnginePreferences.data.antialiasing;
		add(logo);
		logo.scrollFactor.set();
		logo.screenCenter(X);

		loadBar = new FlxBar(0, FlxG.height - 100, LEFT_TO_RIGHT, FlxG.width - 400, 10, this, 'progress', 0, 1);
        loadBar.filledCallback = goToState;
        loadBar.screenCenter(X);
        loadBar.numDivisions = 3000;
		loadBar.antialiasing = EnginePreferences.data.antialiasing;
		loadBar.createFilledBar(FlxColor.TRANSPARENT, 0xFFFF002B);
		add(loadBar);

        loadTxt = new FlxText(loadBar.x, FlxG.height - 80, 0, "", 24);
		loadTxt.scrollFactor.set();
		loadTxt.setFormat(Paths.font("digit.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(loadTxt);
        trace('Loading... ' + percent + "%");

        startLoading = true;
		super.create();
        
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
       
        percent = MathUtil.truncateFloat(progress * 100, 0);

        progressLerp = FlxMath.lerp(0, progress, 1 / progress);
        //logo.y = 0 + progress * 100;
        
        if(progress >= 1)
        {
        progress = 1;
        startLoading = false;
        //loadTxt.text = "Loading... 100%";
        }
        else
        {   
            if(!inPlayState)
            {
            loadTxt.text = "Loading... " + percent + "% ";
            progress += elapsed / 4.5;
            }
            else
            {
                loadTxt.text = "Loading... " + percent + "% ";
                progress += elapsed / 1.5;
            }
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