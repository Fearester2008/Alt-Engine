#if sys
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
    var done:Int = 0;
    var total:Int = 0;
    
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
    
    var fileName:String = null;

    //FOR CACHE
    public static var bitmapData:Map<String,FlxGraphic>;
	public static var bitmapData2:Map<String,FlxGraphic>;
    
    var images = [];
	var music = [];

    override function create()
    {
        
        FlxG.mouse.visible = true;

		FlxG.worldBounds.set(0,0);

		bitmapData = new Map<String,FlxGraphic>();
		bitmapData2 = new Map<String,FlxGraphic>();
        
        super.create();
        
        FlxG.camera.bgColor.alpha = 1;

        funkay = new FlxSprite(0, 0).loadGraphic(Paths.image('menuDesat'));
		funkay.updateHitbox();
		funkay.color = 0xFF00FF6A;
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

		loadBar = new FlxBar(0, FlxG.height - 10, LEFT_TO_RIGHT, FlxG.width, 10, this, 'progress', 0, 1);
        loadBar.filledCallback = goToState;
        loadBar.screenCenter(X);
        loadBar.numDivisions = 3000;
		loadBar.antialiasing = ClientPrefs.globalAntialiasing;
		loadBar.createFilledBar(FlxColor.TRANSPARENT, 0xFF00FF6A);
		add(loadBar);

        loadTxt = new FlxText(0, FlxG.height - 60, 0, "", 24);
		loadTxt.scrollFactor.set();
		loadTxt.setFormat(Paths.font("vcr-rus.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(loadTxt);
        trace('Loading... ' + percent + "%");

        startLoading = true;
        
        if(!inPlayState)
        {
        #if cpp
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
		{
			if (!i.endsWith(".png"))
				continue;
			images.push(i);
            total++;
		}
        
        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images")))
            {
                if (!i.endsWith(".png"))
                    continue;
                images.push(i);
                total++;
            }
    
            for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images/")))
                {
                    if (!i.endsWith(".png"))
                        continue;
                    images.push(i);
                    total++;
                }
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
		{
            if (!i.endsWith(".ogg"))
                continue;
			music.push(i);
            total++;
		}
        
        #if MODS_ALLOWED
        for (i in FileSystem.readDirectory(FileSystem.absolutePath("mods/images/characters")))
            {
                if (!i.endsWith(".png"))
                    continue;
                images.push(i);
                total++;
            }
    
            for (i in FileSystem.readDirectory(FileSystem.absolutePath("mods/images")))
                {
                    if (!i.endsWith(".png"))
                        continue;
                    images.push(i);
                    total++;
                }

            for (i in FileSystem.readDirectory(FileSystem.absolutePath("mods/songs")))
            {
                if (!i.endsWith(".ogg"))
                    continue;
                music.push(i);
                total++;
            }
        #end
		#end

		sys.thread.Thread.create(() -> {
			cache();
		});
        }
		super.create();
        
    }
    
    function cache()
        {
            #if !linux
    
            for (i in images)
            {
                var replaced = i.replace(".png","");
                var data:BitmapData = BitmapData.fromFile("assets/shared/images/characters/" + i);
                var graph = FlxGraphic.fromBitmapData(data);
                graph.persist = true;
                graph.destroyOnNoUse = false;
                bitmapData.set(replaced,graph);
                trace(i);
                done++;
            }
    
            for (i in music)
            {
                trace(i);
                done++;
            }
    
            #if MODS_ALLOWED
            for (i in images)
                {
                    var replaced = i.replace(".png","");
                    var data:BitmapData = BitmapData.fromFile("mods/images/characters/" + i);
                    var graph = FlxGraphic.fromBitmapData(data);
                    graph.persist = true;
                    graph.destroyOnNoUse = false;
                    bitmapData.set(replaced,graph);
                    trace(i);
                    done++;
                }
        
                for (i in music)
                {
                    fileName = i;
                    trace(i);
                    done++;
                }
                #end
    
            #end
          
            goToState();
        }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
       
        percent = HelperFunctions.truncateFloat(progress * 100, 0); 
        if(progress >= 1)
        {
        progress = 1;
        startLoading = false;
        loadTxt.text = "Loading... 100%";
        }
        else
        {   
            if(!inPlayState)
            {
            loadTxt.text = "Loading... " + percent + "% " + done + " / " + total;
            progress = done / total;
            }
            else
            {
                loadTxt.text = "Loading... " + percent + "% ";
                progress += FlxG.random.float(0.0004, 0.002);
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
#end