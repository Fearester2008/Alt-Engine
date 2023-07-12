class HelperFunctions
{
    public static function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
	}
	public static function getPercent(sPercent:Float, ePercent:Float)
	{
		var fPercent:Float = sPercent / ePercent * 100;

		return fPercent;
	}

	// for app title
}