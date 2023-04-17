package options.substates;

import lime.app.Application;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import Controls;
class Option
{
	public function new()
	{
		display = updateDisplay();
	}

	private var description:String = "";
	private var display:String;
	private var acceptValues:Bool = false;

	public var acceptType:Bool = false;

	public var waitingType:Bool = false;

	public final function getDisplay():String
	{
		return display;
	}

	public final function getAccept():Bool
	{
		return acceptValues;
	}

	public final function getDescription():String
	{
		return description;
	}

	public function getValue():String
	{
		return updateDisplay();
	};

	public function onType(text:String)
	{
	}

	// Returns whether the label is to be updated.
	public function press():Bool
	{
		return true;
	}

	private function updateDisplay():String
	{
		return "";
	}

	public function left():Bool
	{
		return false;
	}

	public function right():Bool
	{
		return false;
	}
}

class DFJKOption extends Option
{
	public function new()
	{
		super();
                if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
		description = "Edit your keybindings";
	}

	public override function press():Bool
	{
		//OptionsMenu.instance.selectedCatIndex = 4;
		//OptionsMenu.instance.switchCat(OptionsMenu.instance.options[4], false);

        if (OptionsMenu.isInPause)
			return false;
		OptionsMenu.openControllsState();
        return true;
	}

	private override function updateDisplay():String
	{
		return "Edit Keybindings";
	}
}

class NotesOption extends Option
{
	public function new()
	{
		super();
        if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
		description = "Edit notes colors";
	}

	public override function press():Bool
	{
		//OptionsMenu.instance.selectedCatIndex = 4;
		//OptionsMenu.instance.switchCat(OptionsMenu.instance.options[4], false);

        if (OptionsMenu.isInPause)
			return false;
		OptionsMenu.openNotesState();
        return true;
	}

	private override function updateDisplay():String
	{
		return "Edit Notes Colors";
	}
}

class Customizeption extends Option
{
	public function new()
	{
		super();
        if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
		description = "Edit elements positions / beat offset";
	}

	public override function press():Bool
	{
		//OptionsMenu.instance.selectedCatIndex = 4;
		//OptionsMenu.instance.switchCat(OptionsMenu.instance.options[4], false);


        if (OptionsMenu.isInPause)
			return false;
		OptionsMenu.openAjustState();
	    return true;
	}

	private override function updateDisplay():String
	{
		return "Edit elements positions and beat offset";
	}
}

class SickMSOption extends Option
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

class GoodMsOption extends Option
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

class BadMsOption extends Option
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

/*class ShitMsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		FlxG.save.data.shitMs--;
		if (FlxG.save.data.shitMs < 0)
			FlxG.save.data.shitMs = 0;
		display = updateDisplay();
		return true;
	}

	public override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			FlxG.save.data.shitMs = 160;
	}

	public override function right():Bool
	{
		FlxG.save.data.shitMs++;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "SHIT: < " + FlxG.save.data.shitMs + " ms >";
	}
}*/

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

class GhostTapOption extends Option
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
		return "Score zomming in beats: < " + (ClientPrefs.scoreZoom ? "Enabled" : "Disabled") + " >";
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
		return "💡 Notes: < " + (ClientPrefs.lightStrums ? "Enabled" : "Disabled") + " >";
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

class AntialiasingOption extends Option
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

       /* function onChangeAntiAliasing()
	{
		for (sprite in members)
		{
			var sprite:Dynamic = sprite; //Make it check for FlxSprite instead of FlxBasic
			var sprite:FlxSprite = sprite; //Don't judge me ok
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.globalAntialiasing;
			}
		}
	} */
}

class Judgement extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		OptionsMenu.instance.selectedCatIndex = 5;
		OptionsMenu.instance.switchCat(OptionsMenu.instance.options[5], false);
		return true;
	}

	private override function updateDisplay():String
	{
		return "Edit Judgements";
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
		return "FPS Counter: < " + (ClientPrefs.showFPS ? "Enabled" : "Disabled") + " >";
	} 
}

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
		return "NoteSplashes: < " + (ClientPrefs.noteSplashes ? "Enabled" : "Disabled") + " >";
	} 
}
class QualityLow extends Option
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
		return "FPS Cap: < " + ClientPrefs.framerate + " >";
	}

	override function right():Bool
	{
		if (ClientPrefs.framerate >= 360)
		{
			ClientPrefs.framerate = 360;
            onChangeFramerate();
		}
		else
			ClientPrefs.framerate = ClientPrefs.framerate + 5;
		    onChangeFramerate();

		return true;
	}

	override function left():Bool
	{
		if (ClientPrefs.framerate > 290)
			ClientPrefs.framerate = 290;
		else if (ClientPrefs.framerate <= 60)
			ClientPrefs.framerate = Application.current.window.displayMode.refreshRate;
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

class HideOppStrumsOption extends Option
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

class OffsetMenu extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");

		PlayState.SONG = Song.loadFromJson('tutorial', '');
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = 0;
		PlayState.storyWeek = 0;
		//PlayState.offsetTesting = true;
		trace('CUR WEEK' + PlayState.storyWeek);
		LoadingState.loadAndSwitchState(new PlayState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Time your offset";
	}
}
class OffsetThing extends Option
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
		ClientPrefs.noteOffset--;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		ClientPrefs.noteOffset++;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Note offset: < " + ClientPrefs.noteOffset + " >";
	}

	public override function getValue():String
	{
		return "Note offset: < " + ClientPrefs.noteOffset + " >";
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

class ComboStacking extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.comboStacking = !ClientPrefs.comboStacking;
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
		return "Combo Stacking: < " + (ClientPrefs.comboStacking ? "Enabled" : "Disabled") + " >";
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
        return "TimeBar Type: < " + ClientPrefs.timeBarType + " >";
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
