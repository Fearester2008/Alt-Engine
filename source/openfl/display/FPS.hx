package openfl.display;

import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.math.FlxMath;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
import Highscore;
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

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 14, color);
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
		    
			memoryMegas = checkMemory();
            fpsPercent = HelperFunctions.truncateFloat((currentFPS / framerate) * 100,2);
		    if(memoryMegas >= maxMemory)
				maxMemory = memoryMegas;

			if(ClientPrefs.sysInfo == 'System' && ClientPrefs.showFPS)
			{
			text = "FPS: " + currentFPS + " / " + framerate + " [ " + fpsPercent + " % ]";
			text += "\nMemory: " + ${CoolUtil.getInterval(memoryMegas)};
			text += "\nMemory Peak: " + ${CoolUtil.getInterval(maxMemory)};
			text += "\nOperating system: " + '${lime.system.System.platformLabel}';
            }
			if(ClientPrefs.sysInfo == 'OG FPS' && ClientPrefs.showFPS)
			{
			  text = "FPS: " + currentFPS;
			}
			if(ClientPrefs.sysInfo == 'PE FPS' && ClientPrefs.showFPS)
			{
			  text = "FPS: " + currentFPS;
			  #if openfl
			  text += "\nMemory: " +  ${CoolUtil.getInterval(memoryMegas)};
			  #end
			}
			if(ClientPrefs.sysInfo == 'FPS ALT' && ClientPrefs.showFPS)
			{
			text = "FPS: " + '[' + currentFPS + '] ';
			text += "\nMemory: " + ${CoolUtil.getInterval(memoryMegas)};
			text += "\nMemory Peak: " + ${CoolUtil.getInterval(memoryMegas)};
			text += "\nAlt Engine version: " + VersionStuff.altEngineVersion;
			text += "\nOperating system: " + '${lime.system.System.platformLabel}';
            }
			textColor = 0xFF02FF74;
			if (memoryMegas > 3000 || currentFPS <= ClientPrefs.framerate / 4)
			{
				textColor = 0xFFFF0000;
			}
			if (memoryMegas > 2000)
				{
				textColor = 0xFFFF7B00;
				}
			if (memoryMegas > 1000)
				{
				textColor = 0xFFE5FF00;
				}
			if (memoryMegas > 500)
				{
				textColor = 0xFF2BFF00;
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
