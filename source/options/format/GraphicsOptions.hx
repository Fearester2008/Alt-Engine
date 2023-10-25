package options.format;

class LowQualityOption extends Option
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
        ClientPrefs.lowQuality = !ClientPrefs.lowQuality;
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
		return "Low Quality: < " + (ClientPrefs.lowQuality ? "Enabled" : "Disabled") + " >";
	} 
}

class AntiAliasingOption extends Option
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
		ClientPrefs.globalAntialiasing = !ClientPrefs.globalAntialiasing;
               // onChangeAntiAliasing();
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
		return "Antialiasing: < " + (ClientPrefs.globalAntialiasing ? "Enabled" : "Disabled") + " >";
	}
}

class ShadersOption extends Option
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
		ClientPrefs.shaders = !ClientPrefs.shaders;
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
		return "Shaders: < " + (ClientPrefs.shaders ? "Enabled" : "Disabled") + " >";
	}
}

class FPSCapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return "FPS: < " + ClientPrefs.framerate + " >";
	}

	override function right():Bool
	{
		if (ClientPrefs.framerate >= 120)
		{
			ClientPrefs.framerate = 120;
            onChangeFramerate();
		}
		else
        {
			ClientPrefs.framerate = ClientPrefs.framerate + 5;
		    onChangeFramerate();
        }
		return true;
	}

	override function left():Bool
	{
		if (ClientPrefs.framerate <= 60)
			ClientPrefs.framerate = 60;
		else
			ClientPrefs.framerate = ClientPrefs.framerate - 5;
			onChangeFramerate();
        
		return true;
	}

    function onChangeFramerate()
	{
		if(ClientPrefs.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.framerate;
			FlxG.drawFramerate = ClientPrefs.framerate;
		}
		else
		{
			FlxG.drawFramerate = ClientPrefs.framerate;
			FlxG.updateFramerate = ClientPrefs.framerate;
		}
	}

	override function getValue():String
	{
		return updateDisplay();
	}
}

class ScreenResolution extends Option
{
    public function new(desc:String)
    {
        super();
        if (OptionsMenu.isInPause)
            description = "This option cannot be toggled in the pause menu.";
        else
            description = desc;
    }

    var values(default, null):Array<String> = ['640x360', '852x480','960x540','1280x720', '1960x1080', '2560x1440', '3840x2160', '7680x4320'];
    function changeValue(value:Int)
    {
        value += values.indexOf(ClientPrefs.screenRes);
        if (value >= values.length) value = 0;
        else if (value < 0) value = values.length - 1;
        ClientPrefs.screenRes = values[value];
    }

    public override function left():Bool
    {
        if (OptionsMenu.isInPause)
            return false;

        changeValue(-1);
        onChangeResolution();

        return true;
    }

    public override function right():Bool
    {
        if (OptionsMenu.isInPause)
            return false;

        changeValue(1);
        onChangeResolution();

        return true;
    }

    private override function updateDisplay():String
    {
        return "Screen Resolution: < " + ClientPrefs.screenRes + " >";
    }

    function onChangeResolution()
        {
            if(!FlxG.fullscreen)
            {
                var resolution = ClientPrefs.screenRes.split('x');
                FlxG.resizeWindow(Std.parseInt(resolution[0]), Std.parseInt(resolution[1]));
            }
        }	
}

