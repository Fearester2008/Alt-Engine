
package openfl.display;

import haxe.display.Protocol.NoData;
import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System as OpenFlSystem;
import lime.system.System as LimeSystem;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if(!windows)
@:headerInclude('sys/utsname.h')
#elseif (windows)
@:cppFileCode('#include <windows.h>
#include <string>
')

#end

class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	/**
		The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	**/
	public var memoryMegas(get, never):Float;

	public var percent:Float = 0;

	public var style:String = EnginePreferences.data.fpsStyle;

	public var memoryPeak:Float;

	public var maxFrame:Int = EnginePreferences.data.framerate;

	@:noCompletion private var times:Array<Float>;
	public var os:String = ''; 

	public function new()
	{
		
		super();
		if(LimeSystem.platformName == LimeSystem.platformVersion || LimeSystem.platformVersion == null)
			os = '\nOS: ${LimeSystem.platformName}';
		else
			os = '\nOS:' + LimeSystem.platformName + ' [ ' + LimeSystem.platformVersion + " ]";

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		times = [];
	}

	var deltaTimeout:Float = 0.0;

	// Event Handlers
	private override function __enterFrame(deltaTime:Float):Void
	{
		// prevents the overlay from updating every frame, why would you need to anyways
		if (deltaTimeout > 1000) {
			deltaTimeout = 0.0;
			return;
		}

		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();

		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;		

		if (currentFPS > maxFrame) currentFPS = maxFrame;

		updateText();

		deltaTimeout += deltaTime;
	}

	public dynamic function updateText():Void // so people can override it in hscript
	{
		percent = MathUtil.truncateFloat((currentFPS / maxFrame) * 100,0);

		if (memoryMegas >= memoryPeak)
			memoryPeak = memoryMegas;

		switch(style)
			{
				case 'System':
				text = "" + currentFPS + " / " + maxFrame + " - " + percent + "%";
				text += "\n" + flixel.util.FlxStringUtil.formatBytes(memoryMegas) + " / " + flixel.util.FlxStringUtil.formatBytes(memoryPeak);
				text += os;
				x = 0;
				y = 0;

				case 'Official':
				text = "FPS: " + currentFPS;
				x = 0;
				y = 0;

				case 'Psych Engine':
				text = 'FPS: $currentFPS' + 
				'\nMemory:' + flixel.util.FlxStringUtil.formatBytes(memoryMegas) + os;
				x = 0;
				y = 0;

				case 'Alt Engine':
				text = "Framerate: " + currentFPS + " / " + maxFrame + " - " + percent + "%";
				text += "\n" + flixel.util.FlxStringUtil.formatBytes(memoryMegas) + " / " + flixel.util.FlxStringUtil.formatBytes(memoryPeak);
				text += "\nAlt Engine version: " + AppController.altEngineVersion + AppController.stage;
				x = 0;
				y = 0;
			}

		textColor = 0xFFFFFFFF;
		if (currentFPS < FlxG.drawFramerate * 0.5)
			textColor = 0xFFFF0000;

		//trace(Std.string(width));
		updateFont();
	}

	inline function get_memoryMegas():Float
		return cast(OpenFlSystem.totalMemory, UInt);

	public dynamic function updateFont():Void {
		switch(style)
		{
			case 'Official':
			defaultTextFormat = new TextFormat("_sans", 10, 0xFFFFFFFF);
			case 'Psych Engine':
			defaultTextFormat = new TextFormat("_sans", 14, 0xFFFFFFFF);
			default:
			defaultTextFormat = new TextFormat("VCR OSD Mono", 13, 0xFFFFFFFF);
		}
	}
}