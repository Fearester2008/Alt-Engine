package;

//Stealing this from dusttale lmao

import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import sys.FileSystem;
import sys.io.File;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
using StringTools;

class OpenState extends MusicBeatState
{
    var toBeDone = 0;
    var done = 0;

    var text:FlxText;
    var kadeLogo:FlxSprite;
    var progBar:FlxBar;
    
	override function create()
	{
        FlxG.mouse.visible = false;

        FlxG.worldBounds.set(0,0);

        text = new FlxText(FlxG.width / 2, FlxG.height / 2 + 300,0,"Loading...");
        text.size = 34;
        text.alignment = FlxTextAlign.CENTER;
        text.alpha = 0;

        kadeLogo = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic(Paths.image('logoBumpin'));
        kadeLogo.x -= kadeLogo.width / 2;
        kadeLogo.y -= kadeLogo.height / 2 + 100;
        text.y -= kadeLogo.height / 2 - 125;
        text.x -= 170;
        kadeLogo.setGraphicSize(Std.int(kadeLogo.width * 0.6));

        kadeLogo.alpha = 0;

        add(kadeLogo);
        add(text);
        progBar = new FlxBar(0, kadeLogo.y + 20, LEFT_TO_RIGHT, 1020, 30, this,
			'loadPercent', 0, 1);
		progBar.scrollFactor.set();
		progBar.screenCenter(X);
		progBar.createGradientFilledBar([0xFFFF0000, 0xFFFFFF00, 0xFF0FFF00],1,0,false,FlxColor.WHITE);
		add(progBar);
		
        trace('starting caching..');
        
        sys.thread.Thread.create(() -> {
            cache();
        });

        super.create();
    }

    var calledDone = false;

    override function update(elapsed) 
    {
        var loadPercent = Highscore.floorDecimal((done / toBeDone) * 100,2);

        if (toBeDone != 0 && done != toBeDone)
        {
            var alpha = Highscore.floorDecimal((done / toBeDone) * 100,2);
            kadeLogo.alpha = alpha;
            text.alpha = alpha;
            text.text = "Loading... (" + done + "/" + toBeDone + ")";
        }

        super.update(elapsed);
    }


    function cache()
    {

        var images = [];
        var music = [];

        trace("caching images...");

        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
        {
            if (!i.endsWith(".png"))
                continue;
            images.push(i);
        }

        trace("caching music...");

        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
        {
            music.push(i);
        }

        toBeDone = Lambda.count(images) + Lambda.count(music);

        trace("LOADING: " + toBeDone + " OBJECTS.");

        for (i in images)
        {
            var replaced = i.replace(".png","");
            Paths.image("characters/" + replaced,"shared");
            trace("cached " + replaced);
            done++;
        }

        for (i in music)
        {
            Paths.inst(i);
            Paths.voices(i);
            trace("cached " + i);
            done++;
        }

        trace("Finished caching...");

        FlxG.switchState(new TitleState());
    }

}
