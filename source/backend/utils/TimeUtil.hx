package backend.utils;

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
    public static function formatTime(Seconds:Float, ?ShowMS:Bool = false):String
    {
        var time:Int = Std.int(Seconds);
        var hours:Int = Std.int(time / 3600);
        var minutes:Int = Std.int((time % 3600) / 60);
        var seconds:Int = Std.int(time % 60);

        var hhString:String = (hours < 10 ? "0" : "") + hours + ":";
        var mmString:String = (minutes < 10 ? "0" : "") + minutes + ":";
        var ssString:String = (seconds < 10 ? "0" : "") + seconds;
        var timeString:String = if(hours >= 60) hhString + mmString + ssString else mmString + ssString;

        if (ShowMS)
        {
            var ms:Int = Std.int((Seconds - Std.int(Seconds)) * 100);
            timeString += "." + (ms < 10 ? "0" : "") + ms;
        }

        return timeString;
    }     
}