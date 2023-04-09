package options.substates;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import flixel.FlxG;

using StringTools;

class OptionsHelpers
{
	public static var noteskinArray = ["Default", "Chip", "Future", "Grafex"];
    public static var IconsBopArray = ['Grafex',  'Modern', 'Classic'];
    public static var TimeBarArray = ['Time Left', 'Time Elapsed', 'Disabled'];
    public static var ColorBlindArray = ['None', 'Deuteranopia', 'Protanopia', 'Tritanopia'];
    public static var AccuracyTypeArray = ['Grafex', 'Kade', 'Mania', 'Andromeda', 'Forever', 'Psych'];
    
	public static function getNoteskinByID(id:Int)
	{
		return noteskinArray[id];
	}

    public static function getIconBopByID(id:Int)
	{
	    return IconsBopArray[id];
	}


    public static function getTimeBarByID(id:Int)
	{
	    return TimeBarArray[id];
	}

    static public function ChangeTimeBar(id:Int)
    {
        ClientPrefs.timeBarType = getTimeBarByID(id);
    }

    public static function getColorBlindByID(id:Int)
    {
        return ColorBlindArray[id];
    }

    public static function getAccTypeID(id:Int)
    {
        return AccuracyTypeArray[id];
    }

}
