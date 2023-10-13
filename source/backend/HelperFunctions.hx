package backend;

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

	public static function getRank(acc:Float):String
		{
			var aee:String = '';
	
			if (acc == 0)
				aee = "?";
			else if (acc <= 0.6999)
				aee = 'F';
			else if (acc >= 0.7 && acc < 0.7499)
				aee = 'D';
			else if (acc >= 0.75 && acc < 0.7999)
				aee = 'C';
			else if (acc >= 0.8 && acc < 0.8499)
				aee = 'B';
			else if (acc >= 0.85 && acc < 0.8999)
				aee = 'A';
			else if (acc >= 0.9 && acc < 0.9499)
				aee = 'S';
			else if (acc >= 0.95 && acc < 0.9999)
				aee = 'S+';
			else if (acc == 1)
				aee = 'S++';
	
			return aee;
		}
		public static function getMaxRank(maxAcc:Float):String
			{
				var aee:String = '';
		
				if (maxAcc == 0)
					aee = "?";
				else if (maxAcc <= 0.6999)
					aee = 'F';
				else if (maxAcc >= 0.7 && maxAcc < 0.7499)
					aee = 'D';
				else if (maxAcc >= 0.75 && maxAcc < 0.7999)
					aee = 'C';
				else if (maxAcc >= 0.8 && maxAcc < 0.8499)
					aee = 'B';
				else if (maxAcc >= 0.85 && maxAcc < 0.8999)
					aee = 'A';
				else if (maxAcc >= 0.9 && maxAcc < 0.9499)
					aee = 'S';
				else if (maxAcc >= 0.95 && maxAcc < 0.9999)
					aee = 'S+';
				else if (maxAcc == 1)
					aee = 'S++';
		
				return aee;
			}
							
}