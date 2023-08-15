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
     * @param StartTicks The first timestamp from the system.
     * @param EndTicks The second timestamp from the system.
     * @return A String containing the formatted time elapsed information.
     */

    public static inline function formatTicks(StartTicks:Int, EndTicks:Int):String
    {
        return (Math.abs(EndTicks - StartTicks) / 1000) + "s";
    }
   
    public static function formativeTime(Seconds:Float, ?ShowMS:Bool = false, ?hoursEnabled:Bool = false):String
    {
        var time:Int = Std.int(Seconds);
        var hours:Int = Std.int(time / 3600);
        var minutes:Int = Std.int((time % 3600) / 60);
        var seconds:Int = Std.int(time % 60);

        var hhString:String = (hours < 10 ? "0" : "") + hours + ":";
        var mmString:String = (minutes < 10 ? "0" : "") + minutes + ":";
        var ssString:String = (seconds < 10 ? "0" : "") + seconds;
        var timeString:String = if(hoursEnabled) hhString + mmString + ssString else mmString + ssString;

        if (ShowMS)
        {
            var ms:Int = Std.int((Seconds - Std.int(Seconds)) * 100);
            timeString += "." + (ms < 10 ? "0" : "") + ms;
        }

        return timeString;
    }     

    public static function startTimer(Seconds:Float, ?ShowMS:Bool = false, ?hoursEnabled:Bool = false):String
    {
        var time:Int = Std.int(Seconds);
        var hours:Int = Std.int(time / 3600);
        var minutes:Int = Std.int((time % 3600) / 60);
        var seconds:Int = Std.int(time % 60);

        var hhString:String = (hours < 10 ? "0" : "") + hours + ":";
        var mmString:String = (minutes < 10 ? "0" : "") + minutes + ":";
        var ssString:String = (seconds < 10 ? "0" : "") + seconds;
        var timeString:String = if(hoursEnabled) hhString + mmString + ssString else mmString + ssString;

        if (ShowMS)
        {
            var ms:Int = Std.int((Seconds - Std.int(Seconds)) * 100);
            timeString += "." + (ms < 10 ? "0" : "") + ms;
        }

        return timeString;
    }    
}