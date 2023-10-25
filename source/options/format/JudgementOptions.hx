package options.format;

class RatingOffset extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		ClientPrefs.ratingOffset--;
		if (ClientPrefs.ratingOffset < 0)
			ClientPrefs.ratingOffset = 0;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.ratingOffset++;
		display = updateDisplay();
		return true;
	}

	public override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.ratingOffset = 45;
	}

	private override function updateDisplay():String
	{
		return "Rating offset: < " + ClientPrefs.ratingOffset + " ms >";
	}
}

class SickOffsetOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		ClientPrefs.sickWindow--;
		if (ClientPrefs.sickWindow < 0)
			ClientPrefs.sickWindow = 0;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.sickWindow++;
		display = updateDisplay();
		return true;
	}

	public override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.sickWindow = 45;
	}

	private override function updateDisplay():String
	{
		return "SICK: < " + ClientPrefs.sickWindow + " ms >";
	}
}

class GoodOffsetOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		ClientPrefs.goodWindow--;
		if (ClientPrefs.goodWindow < 0)
			ClientPrefs.goodWindow = 0;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.goodWindow++;
		display = updateDisplay();
		return true;
	}

	public override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.goodWindow = 90;
	}

	private override function updateDisplay():String
	{
		return "GOOD: < " + ClientPrefs.goodWindow + " ms >";
	}
}

class BadOffsetOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		ClientPrefs.badWindow--;
		if (ClientPrefs.badWindow < 0)
			ClientPrefs.badWindow = 0;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.badWindow++;
		display = updateDisplay();
		return true;
	}

	public override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.badWindow = 135;
	}

	private override function updateDisplay():String
	{
		return "BAD: < " + ClientPrefs.badWindow + " ms >";
	}
}

class SafeFrames extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		ClientPrefs.safeFrames = ClientPrefs.safeFrames - 1;
		if (ClientPrefs.safeFrames < 2)
			ClientPrefs.safeFrames = 2;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.safeFrames = ClientPrefs.safeFrames + 1;
		display = updateDisplay();
		return true;
	}

	public override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.safeFrames = 10;
	}

	private override function updateDisplay():String
	{
		return "Safe Frames: < " + ClientPrefs.safeFrames + " >";
	}
}