#if sys
package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxGradient;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import lime.app.Application;
#if windows
import Discord.DiscordClient;
#end
import openfl.display.BitmapData;
import openfl.utils.Assets;
import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.FlxState;
import flixel.math.FlxRect;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import lime.system.ThreadPool;
import openfl.utils.Assets as OpenFLAssets;
#if (MODS_ALLOWED)
import sys.FileSystem;
import sys.io.File;
#end
import utils.*;
using StringTools;

class CacheState extends FlxState
{	

	var doneFiles = 0;
	var shouldBeDone = 0;

	var loaded:Bool = false;

	public static var bitmapData:Map<String,FlxGraphic>;
	public static var bitmapData2:Map<String,FlxGraphic>;

	var gradientBar:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 1, 0xFFAA00AA);

	var splash:FlxSprite;
	var loadingSpeen:FlxSprite;
	var text:FlxText;
	var randomTxt:FlxText;
	
	var isTweening:Bool = false;
	var lastString:String = '';

	var images = [];
	var music = [];
	var sounds = [];


	override function create()
	{
			
		FlxG.mouse.visible = true;

		FlxG.worldBounds.set(0,0);
        
		#if !android
		bitmapData = new Map<String,FlxGraphic>();
		bitmapData2 = new Map<String,FlxGraphic>();
		#end

		super.create();
		

		splash = new FlxSprite().loadGraphic(Paths.image("logoBump"));
		splash.screenCenter();
		splash.y -= 30;
		splash.antialiasing = true;
		add(splash);
		
		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00ff0000, 0x553D0468, 0xAABF1943], 1, 90, true);
		gradientBar.y = FlxG.height - gradientBar.height;
		add(gradientBar);
		gradientBar.scrollFactor.set(0, 0);
		
		var bottomPanel:FlxSprite = new FlxSprite(0, FlxG.height - 100).makeGraphic(FlxG.width, 100, 0xFF000000);
		bottomPanel.alpha = 0.5;
		add(bottomPanel);	
		
		randomTxt = new FlxText(20, FlxG.height - 80, 1000, "", 26);
		randomTxt.scrollFactor.set();
		randomTxt.setFormat("VCR OSD Mono", 26, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(randomTxt);

		loadingSpeen = new FlxSprite(FlxG.width - 91 ,FlxG.height - 91).loadGraphic(Paths.image("load_image"));
		loadingSpeen.angularVelocity = 180;
		loadingSpeen.antialiasing = true;
		add(loadingSpeen);
		
		#if (cpp && !android)
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters/")))
		{
			if (!i.endsWith(".png"))
				continue;
			images.push(i);
		}
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images/")))
			{
				if (!i.endsWith(".png"))
					continue;
				images.push(i);
			}
		#if MODS_ALLOWED
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("mods/images/characters")))
			{
				if (!i.endsWith(".png"))
					continue;
				images.push(i);
			}
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("mods/images/")))
			{
				if (!i.endsWith(".png"))
					continue;
				images.push(i);
			}
		#end
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs/")))
		{
			music.push(i);
		}
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/music/")))
			{
				music.push(i);
			}
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/sounds/")))
			{
				music.push(i);
			}
		#if MODS_ALLOWED
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("mods/songs/")))
		{
			music.push(i);
		}
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("mods/music/")))
			{
				music.push(i);
			}
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("mods/sounds/")))
			{
				music.push(i);
			}

		#end
		#end

		sys.thread.Thread.create(() -> {
			cache();
		});

		super.create();
	}
	
	var selectedSomethin:Bool = false;
	var timer:Float = 0;
	
	override function update(elapsed:Float) 
	{
		if (!selectedSomethin){
			if (isTweening){
				randomTxt.screenCenter(X);
				timer = 0;
			}else{
				randomTxt.screenCenter(X);
				timer += elapsed;
				if (timer >= 3)
				{
					changeText();
				}
			}
		}

		super.update(elapsed);
	}
	
	function cache()
	{

		#if (!linux && !android)

		for (i in images)
		{
			var replaced = i.replace(".png","");
			var data:BitmapData = BitmapData.fromFile("assets/shared/images/characters" + i);
			#if MODS_ALLOWED
			var data:BitmapData = BitmapData.fromFile("mods/images/characters" + i);
			#end
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced,graph);
			trace(i);
			doneFiles++;
		}
        for (i in images)
			{
				var replaced = i.replace(".png","");
				var data:BitmapData = BitmapData.fromFile("assets/shared/images/" + i);
				#if MODS_ALLOWED
				var data:BitmapData = BitmapData.fromFile("mods/images/" + i);
				#end
				var graph = FlxGraphic.fromBitmapData(data);
				graph.persist = true;
				graph.destroyOnNoUse = false;
				bitmapData.set(replaced,graph);
				doneFiles++;
				trace(i);
			}
		for (i in music)
		{
			doneFiles++;
			trace(i);
			loaded = true;

		}
		#end

		

		FlxG.switchState(new TitleState());
	}
	
	function changeText()
	{
		var selectedText:String = '';
		var textArray:Array<String> = CoolUtil.coolTextFile(SUtil.getPath() + Paths.txt('tipText'));

		randomTxt.alpha = 1;
		isTweening = true;
		selectedText = textArray[FlxG.random.int(0, (textArray.length - 1))].replace('--', '\n');
		FlxTween.tween(randomTxt, {alpha: 0}, 1, {
			ease: FlxEase.linear,
			onComplete: function(shit:FlxTween)
			{
				if (selectedText != lastString)
				{
					randomTxt.text = selectedText;
					lastString = selectedText;
				}
				else
				{
					selectedText = textArray[FlxG.random.int(0, (textArray.length - 1))].replace('--', '\n');
					randomTxt.text = selectedText;
				}

				randomTxt.alpha = 0;

				FlxTween.tween(randomTxt, {alpha: 1}, 1, {
					ease: FlxEase.linear,
					onComplete: function(shit:FlxTween)
					{
						isTweening = false;
					}
				});
			}
		});
	}
}
#end