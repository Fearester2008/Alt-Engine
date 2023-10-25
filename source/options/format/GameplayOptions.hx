package options.format;

class ControllerMode extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.controllerMode = !ClientPrefs.controllerMode;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Controller Mode: < " + (ClientPrefs.controllerMode ? "Enabled" : "Disabled") + " >";
	}
}

class Stacking extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.stacking = !ClientPrefs.stacking;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Combo Stacking: < " + (ClientPrefs.stacking ? "Enabled" : "Disabled") + " >";
	}
}

class DownscrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.downScroll = !ClientPrefs.downScroll;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Downscroll: < " + (ClientPrefs.downScroll ? "Enabled" : "Disabled") + " >";
	}
}

class MiddleScrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.middleScroll = !ClientPrefs.middleScroll;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Middle Scroll: < " + (ClientPrefs.middleScroll ? "Enabled" : "Disabled") + " >";
	}
}

class OpponentStrumsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.opponentStrums = !ClientPrefs.opponentStrums;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Opponent Strums: < " + (ClientPrefs.opponentStrums ? "Enabled" : "Disabled") + " >";
	}
}

class GhostTappingOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.ghostTapping = !ClientPrefs.ghostTapping;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Ghost Tapping: < " + (ClientPrefs.ghostTapping ? "Enabled" : "Disabled") + " >";
	}
}

class BlurNotes extends Option
{
	public function new(desc:String)
	{
		super();
              if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
           	if (OptionsMenu.isInPause)
			return false;

		ClientPrefs.lightStrums = !ClientPrefs.lightStrums;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Glow Notes: < " + (ClientPrefs.lightStrums ? "Enabled" : "Disabled") + " >";
	}
}

class NoReset extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.noReset = !ClientPrefs.noReset;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Reset Button: < " + (!ClientPrefs.noReset ? "Enabled" : "Disabled") + " >";
	}
}

class IconBop extends Option
{
    public function new(desc:String)
    {
        super();
        if (OptionsMenu.isInPause)
            description = "This option cannot be toggled in the pause menu.";
        else
            description = desc;
    }

    var values(default, null):Array<String> = ["Alt","Psych"];
    function changeValue(value:Int)
    {
        value += values.indexOf(ClientPrefs.iconBop);
        if (value >= values.length) value = 0;
        else if (value < 0) value = values.length - 1;
        ClientPrefs.iconBop = values[value];
    }

    public override function left():Bool
    {
        if (OptionsMenu.isInPause)
            return false;

        changeValue(-1);

        return true;
    }

    public override function right():Bool
    {
        if (OptionsMenu.isInPause)
            return false;

        changeValue(1);

        return true;
    }

    private override function updateDisplay():String
    {
        return "Icon Bop: < " + ClientPrefs.iconBop + " >";
    }
}

class CameraBop extends Option
{
    public function new(desc:String)
    {
        super();
        if (OptionsMenu.isInPause)
            description = "This option cannot be toggled in the pause menu.";
        else
            description = desc;
    }

    var values(default, null):Array<String> = ['Both camera', 'HUD camera', 'Game camera'];
    function changeValue(value:Int)
    {
        value += values.indexOf(ClientPrefs.beatMode);
        if (value >= values.length) value = 0;
        else if (value < 0) value = values.length - 1;
        ClientPrefs.beatMode = values[value];
    }

    public override function left():Bool
    {
        if (OptionsMenu.isInPause)
            return false;

        changeValue(-1);

        return true;
    }

    public override function right():Bool
    {
        if (OptionsMenu.isInPause)
            return false;

        changeValue(1);

        return true;
    }

    private override function updateDisplay():String
    {
        return "Camera Mode: < " + ClientPrefs.beatMode + " >";
    }
}

class JudgementCounter extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.judgementCounter = !ClientPrefs.judgementCounter;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Judgement Counter: < " + (ClientPrefs.judgementCounter ? "Enabled" : "Disabled") + " >";
	}
}

class JudgementCounterType extends Option
{
    public function new(desc:String)
    {
        super();
        if (OptionsMenu.isInPause)
            description = "This option cannot be toggled in the pause menu.";
        else
            description = desc;
    }

    var values(default, null):Array<String> = ['Counter', 'Percent'];
    function changeValue(value:Int)
    {
        value += values.indexOf(ClientPrefs.judgementCounterType);
        if (value >= values.length) value = 0;
        else if (value < 0) value = values.length - 1;
        ClientPrefs.judgementCounterType = values[value];
    }

    public override function left():Bool
    {
        if (OptionsMenu.isInPause)
            return false;

        changeValue(-1);

        return true;
    }

    public override function right():Bool
    {
        if (OptionsMenu.isInPause)
            return false;

        changeValue(1);

        return true;
    }

    private override function updateDisplay():String
    {
        return "Judgement Counter Type: < " + ClientPrefs.judgementCounterType + " >";
    }
}

class ResultsScreen extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{	
		ClientPrefs.results = !ClientPrefs.results;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Results Screen: < " + (ClientPrefs.results ? "Enabled" : "Disabled") + " >";
	} 
}

class HitSoundOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	private override function updateDisplay():String
	{
		return "HitSound volume: < " + ClientPrefs.hitsoundVolume + " >";
	}

	override function right():Bool
	{
		ClientPrefs.hitsoundVolume += 0.1;
		if (ClientPrefs.hitsoundVolume > 1)
			ClientPrefs.hitsoundVolume = 1;
		return true;

	}

	override function left():Bool
	{
		ClientPrefs.hitsoundVolume -= 0.1;
		if (ClientPrefs.hitsoundVolume < 0)
			ClientPrefs.hitsoundVolume = 0;
		return true;
	}
}