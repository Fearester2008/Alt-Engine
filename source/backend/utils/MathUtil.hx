package backend.utils;

class MathUtil
{
    public static function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
	}
	
	public static function truncatePercent(val:Float, precs:Int, ?split:String = '.')
	{
		var numSplit:Array<String> = Std.string(truncateFloat(val * 100, precs)).split(".");
		if(numSplit.length < precs) { //No decimals, add an empty space
			numSplit.push('');
		}
		
		while(numSplit[1].length < precs) { //Less than 2 decimals in it, add decimals then
			numSplit[1] += '0';
		}

		return numSplit.join(split);
	}

	public static function getRank(acc:Float):String
		{
			var rank:String = '';
	
			if (acc == 0)
				rank = "?";
			else if (acc <= 0.6999)
				rank = 'F';
			else if (acc >= 0.7 && acc < 0.7499)
				rank = 'D';
			else if (acc >= 0.75 && acc < 0.7999)
				rank = 'C';
			else if (acc >= 0.8 && acc < 0.8499)
				rank = 'B';
			else if (acc >= 0.85 && acc < 0.8999)
				rank = 'A';
			else if (acc >= 0.9 && acc < 0.9499)
				rank = 'S';
			else if (acc >= 0.95 && acc < 0.9999)
				rank = 'S+';
			else if (acc >= 1)
				rank = 'S++';
	
			return rank;
		}
		public static function getRankFromNew(rating:Float):String
			{
				var rank:String = '';
		
				if (rating == 0)
					rank = "?";
				else if (rating < 60)
					rank = 'D';
				else if (rating >= 60 && rating <= 70)
					rank = 'C';
				else if (rating >= 70 && rating < 80)
					rank = 'B';
				else if (rating >= 80 && rating < 85)
					rank = 'A';
				else if (rating >= 85 && rating < 90)
					rank = 'A.';
				else if (rating >= 90 && rating < 93)
					rank = 'A:';
				else if (rating >= 93 && rating < 96.50)
					rank = 'AA';
				else if (rating >= 96.50 && rating < 99)
					rank = 'AA.';
				else if (rating >= 99 && rating < 99.70)
					rank = 'AA:';
				else if (rating >= 99.70 && rating < 99.80)
					rank = 'AAA';
				else if (rating >= 99.80 && rating < 99.90)
					rank = 'AAA.';
				else if (rating >= 99.90 && rating < 99.955)
					rank = 'AAA:';
				else if (rating >= 99.955 && rating < 99.970)
					rank = 'AAAA';
				else if (rating >= 99.970 && rating < 99.980)
					rank = 'AAAA.';
				else if (rating >= 99.980 && rating < 99.9935)
					rank = 'AAAA:';
				else if (rating >= 99.9935 && rating < 100)
					rank = 'AAAAA';
				else if (rating >= 100)
					rank = 'AAAAAA+';

				return rank;
			}
}