package options.format;

class ShowSplashes extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
        ClientPrefs.noteSplashes = !ClientPrefs.noteSplashes;
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
		return "Note Splashes: < " + (ClientPrefs.noteSplashes ? "Enabled" : "Disabled") + " >";
	} 
}

class HideHUD extends Option
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
		ClientPrefs.hideHud = !ClientPrefs.hideHud;
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
		return "HUD: < " + (ClientPrefs.hideHud ? "Hidden" : "Shown") + " >";
	}
}

class TimeBarTypeOption extends Option
{
    public function new(desc:String)
    {
        super();
        if (OptionsMenu.isInPause)
            description = "This option cannot be toggled in the pause menu.";
        else
            description = desc;
    }

    var values(default, null):Array<String> = ["Song Name", "Time Elapsed", "Time Left", "Disabled","Time Length","Song Percentage","Time Length Percent"];
    function changeValue(value:Int)
    {
        value += values.indexOf(ClientPrefs.timeBarType);
        if (value >= values.length) value = 0;
        else if (value < 0) value = values.length - 1;
        ClientPrefs.timeBarType = values[value];
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
        return "Timebar type: < " + ClientPrefs.timeBarType + " >";
    }
}

class LanguageOption extends Option
{
    public function new(desc:String)
    {
        super();
        if (OptionsMenu.isInPause)
            description = "This option cannot be toggled in the pause menu.";
        else
            description = desc;
    }

    var values(default, null):Array<String> = ["Russian", "English"];
    function changeValue(value:Int)
    {
        value += values.indexOf(ClientPrefs.language);
        if (value >= values.length) value = 0;
        else if (value < 0) value = values.length - 1;
        ClientPrefs.language = values[value];
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
        return "Language: < " + ClientPrefs.language + " >";
    }
}

class CamZoomOption extends Option
{
	public function new(desc:String)
	{
		super();
        description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.camZooms = !ClientPrefs.camZooms;
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
		return "Camera Zooming: < " + (ClientPrefs.camZooms ? "Enabled" : "Disabled") + " >";
	}
}

class ScoreZoom extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.scoreZoom = !ClientPrefs.scoreZoom;
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
		return "Score Zoom On Notes Hit: < " + (ClientPrefs.scoreZoom ? "Enabled" : "Disabled") + " >";
	}
}

class HealthBarAlpha extends Option
{
	public function new(desc:String)
	{
		super();

		description = desc;
		acceptValues = true;
	}

	override function right():Bool
	{
		ClientPrefs.healthBarAlpha += 0.1;
		if (ClientPrefs.healthBarAlpha > 1)
			ClientPrefs.healthBarAlpha = 1;

		return true;
	}

	override function left():Bool
	{
		ClientPrefs.healthBarAlpha -= 0.1;

		if (ClientPrefs.healthBarAlpha < 0)
			ClientPrefs.healthBarAlpha = 0;
			
		return true;
	}

	private override function updateDisplay():String
		{
			return "Health Bar Transparceny: < " + ClientPrefs.healthBarAlpha + " >";
		}
	
}

class FPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{	
		ClientPrefs.showFPS = !ClientPrefs.showFPS;
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
		return "Show FPS: < " + (ClientPrefs.showFPS ? "Enabled" : "Disabled") + " >";
	} 
}

class FPSinfo extends Option
{
    public function new(desc:String)
    {
        super();
        if (OptionsMenu.isInPause)
            description = "This option cannot be toggled in the pause menu.";
        else
            description = desc;
    }

    var values(default, null):Array<String> = ["FPS ALT","PE FPS", "OG FPS", "System"];
    function changeValue(value:Int)
    {
        value += values.indexOf(ClientPrefs.sysInfo);
        if (value >= values.length) value = 0;
        else if (value < 0) value = values.length - 1;
        ClientPrefs.sysInfo = values[value];
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
        return "FPS Mode: < " + ClientPrefs.sysInfo + " >";
    }
}

class HudStyle extends Option
{
    public function new(desc:String)
    {
        super();
        if (OptionsMenu.isInPause)
            description = "This option cannot be toggled in the pause menu.";
        else
            description = desc;
    }

    var values(default, null):Array<String> = ['Vanila', 'Alt Engine', 'Psych Engine', 'Better Alt HUD'];
    function changeValue(value:Int)
    {
        value += values.indexOf(ClientPrefs.hudStyle);
        if (value >= values.length) value = 0;
        else if (value < 0) value = values.length - 1;
        ClientPrefs.hudStyle = values[value];
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
        return "HUD Style: < " + ClientPrefs.hudStyle + " >";
    }
}

class ToggleVolumeKeys extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{	
		ClientPrefs.enableToggleVolume = !ClientPrefs.enableToggleVolume;
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
		return "Volume Keys: < " + (ClientPrefs.enableToggleVolume ? "Enabled" : "Disabled") + " >";
	} 
}

class WinningIcons extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{	
		ClientPrefs.winIcon = !ClientPrefs.winIcon;
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
		return "Winning Icons: < " + (ClientPrefs.winIcon ? "Enabled" : "Disabled") + " >";
	} 
}

class DiscordRPC extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{	
		ClientPrefs.showDiscordActivity = !ClientPrefs.showDiscordActivity;
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
		return "Use Discord RPC: < " + (ClientPrefs.showDiscordActivity ? "Enabled" : "Disabled") + " >";
	} 
}




