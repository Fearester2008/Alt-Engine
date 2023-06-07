package utils;

import flash.display.BitmapData;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.system.FlxAssets;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import flixel.util.typeLimit.OneOfTwo;

using StringTools;

#if flash
import flash.geom.Matrix;
#end

/**
 * A class primarily containing functions related
 * to formatting different data types to strings.
 */
class TimeUtil
{
	/**
	 * Takes two "ticks" timestamps and formats them into the number of seconds that passed as a String.
	 * Useful for logging, debugging, the watch window, or whatever else.
	 *
	 * @param	StartTicks	The first timestamp from the system.
	 * @param	EndTicks	The second timestamp from the system.
	 * @return	A String containing the formatted time elapsed information.
	 */
	public static inline function formatTicks(StartTicks:Int, EndTicks:Int):String
	{
		return (Math.abs(EndTicks - StartTicks) / 1000) + "s";
	}

	public static function formativeTime(Seconds:Float, ShowMS:Bool = false):String
		{
			var stuff1:String = ":";
			var stuff2:String = "0";
			var time:Int = Std.int(Seconds / 60);
			var timeStringHelper:Int = Std.int(Seconds) % 60;
			var timeString:String = stuff2 + time + stuff1;
			
			
			if (time > 10)
				{
					stuff2 = '';
				}
			if (timeStringHelper < 10)
			{
				timeString += "0";
			}
			timeString += timeStringHelper;
			if (ShowMS)
			{
				timeString += ".";
				timeStringHelper = Std.int((Seconds - Std.int(Seconds)) * 100);
				if (timeStringHelper < 10)
				{
					timeString += "0";
				}
				timeString += timeStringHelper;
			}
	
			return timeString;
		}
	
}
	