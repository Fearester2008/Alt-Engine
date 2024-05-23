package openfl.display;

import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.math.FlxMath;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if flash
import openfl.Lib;
#end

#if openfl
import openfl.system.System;
#end

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

var tmp:Bitmap;

class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/

	function checkMemory():Dynamic
	{
		return System.totalMemory;
	}
	public var currentFPS(default, null):Int;
	public var maxMemory:Float;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;
	public var colorStr:Dynamic;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;
		colorStr = color;
		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
        var framerate:Int = ClientPrefs.framerate;

		currentFPS = Math.round((currentCount + cacheCount) / 2);
		
		if (currentFPS > framerate) currentFPS = framerate;

		if (currentCount != cacheCount /*&& visible*/)
		{
			var memoryMegas:Float = 0;
			
			var fpsPercent:Float = 0;

		switch(ClientPrefs.sysInfo)
		{
			case 'OG FPS':
			defaultTextFormat = new TextFormat("_sans", 10, colorStr);
			case 'PE FPS':
			defaultTextFormat = new TextFormat("_sans", 14, colorStr);
			default:
			defaultTextFormat = new TextFormat("VCR OSD Mono", 13, colorStr);
		}
		    
			memoryMegas = checkMemory();
            fpsPercent = HelperFunctions.truncateFloat((currentFPS / framerate) * 100,2);
		    if(memoryMegas >= maxMemory)
				maxMemory = memoryMegas;

			var fpsType:String = ClientPrefs.sysInfo;

			if(ClientPrefs.showFPS)
			{
			switch(fpsType)
			{
				case 'System':
				text = "Framerate: " + currentFPS + " / " + framerate + " - " + fpsPercent + "%";
				text += "\nMemory: " + ${CoolUtil.getInterval(memoryMegas)};
				text += "\nMemory Peak: " + ${CoolUtil.getInterval(maxMemory)};
				text += "\nOperating system: " + '${lime.system.System.platformLabel}';

				case 'OG FPS':
				text = "FPS: " + currentFPS;

				case 'PE FPS':
				text = "FPS: " + currentFPS;
				#if openfl
				text += "\nMemory: " +  ${CoolUtil.getInterval(memoryMegas)};
				#end

				case 'FPS ALT':
				text = "Framerate: " + currentFPS + " / " + framerate + " - " + fpsPercent + "%";
				text += "\nMemory: " + ${CoolUtil.getInterval(memoryMegas)};
				text += "\nMemory Peak: " + ${CoolUtil.getInterval(maxMemory)};
				text += "\nAlt Engine version: " + VersionStuff.altEngineVersion + VersionStuff.stage;
			}
		}
			if(currentFPS > 0)
			{
			textColor = 0xFFFFFFFF;
			}
			if (currentFPS < framerate / 4)
			{
				textColor = 0xFF830101;
			}
			if (currentFPS < framerate / 3)
				{
				textColor = 0xFFA14E00;
				}
			if (currentFPS < framerate / 2)
				{
				textColor = 0xFFB1C406;
				}
			if (currentFPS < framerate)
				{
				textColor = 0xFF1A8F03;
				}

			#if (gl_stats && !disable_cffi && (!html5 || !canvas))
			text += "\ntotalDC: " + Context3DStats.totalDrawCalls();
			text += "\nstageDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE);
			text += "\nstage3DDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D);
			#end

			text += "\n";
		}

		cacheCount = currentCount;
	}
}