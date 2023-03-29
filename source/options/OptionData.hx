package;

import lime.app.Application;
import lime.system.DisplayMode;
import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;

class OptionCategory extends FlxSprite{
	public var optionObjects:FlxTypedGroup<FlxText>;
	public var options:Array<Option>;
	public var titleObject:FlxText;
	public var middle:Bool = false;
	public var title:String;
	public function new(x:Float, y:Float, _title:String, _options:Array<Option>, middleType:Bool = false){
		super(x, y);
		title = _title;
		middle = middleType;
		if (!middleType) makeGraphic(295, 64, FlxColor.BLACK);
		alpha = 0.5;
		options = _options;
		optionObjects = new FlxTypedGroup();
		titleObject = new FlxText((middleType ? 1180 / 2 : x), y + (middleType ? 0 : 16), 0, title);
		titleObject.setFormat(Paths.font("Highman.ttf"), 35, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		titleObject.borderSize = 3;
		if (middleType)
			titleObject.x = 50 + ((1180 / 2) - (titleObject.fieldWidth / 2));
		else
			titleObject.x += (width / 2) - (titleObject.fieldWidth / 2);
		titleObject.scrollFactor.set();
		scrollFactor.set();
		for (i in 0...options.length){
			var opt = options[i];
			var text:FlxText = new FlxText((middleType ? 1180 / 2 : 72), titleObject.y + 54 + (46 * i), 0, opt.getValue());
			if (middleType) text.screenCenter(X);
			text.setFormat(Paths.font("Highman.ttf"), 35, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			text.borderSize = 3;
			text.borderQuality = 1;
			text.scrollFactor.set();
			optionObjects.add(text);
		}
	}
	public function changeColor(color:FlxColor){
		makeGraphic(295, 64, color);
	}
}

class OptionData
{
	private var description:String = "";
	private var display:String;
	private var acceptValues:Bool = false;

	public function new() display = updateDisplay();
	public final function getDisplay():String return display;
	public final function getAccept():Bool return acceptValues;
	public final function getDescription():String return description;
	public function getValue():String return throw "stub!";
	// Returns whether the label is to be updated.
	public function press():Bool return throw "stub!";
	private function updateDisplay():String return throw "stub!";
	public function left():Bool return throw "stub!";
	public function right():Bool return throw "stub!";
}
    #if !android
class CustomControlsKeys extends OptionData
{

	private var controls:Controls;

	public function new(controls:Controls) {
		super();
		this.controls = controls;
	}

	public override function press():Bool {
		MusicBeatState.openSubState(new ControlsSubState());
		return false;
	}

	private override function updateDisplay():String
		return "Keyboard Bindings";
	
}
#end

#if android
class CustomControls extends OptionData
{
	public function new(desc:String) {
		super();
		description = desc;
	}

	public override function press():Bool {
		MusicBeatState.switchState(new android.AndroidControlsMenu());
		return true;
	}

	private override function updateDisplay():String
		return "Mobile controls";
}

#end

class lightStrums extends OptionData
{
	public function new(desc:String) {
		super();
		description = desc;
	}

	public override function press():Bool {
        ClientPrefs.lightStrums = !ClientPrefs.lightStrums
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
		return ClientPrefs.lightStrums ? "On" : "Off";
}

class DownscrollOption extends OptionData
{
	public function new(desc:String) {
		super();
		description = desc;
	}

	public override function press():Bool {
		ClientPrefs.downScroll = !ClientPrefs.downScroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
		return ClientPrefs.downScroll ? "On" : "Off";
}

class MiddlescrollOption extends OptionData
{
	public function new(desc:String) {
		super();
		description = desc;
	}

	public override function press():Bool {
ClientPrefs.middleScroll = !ClientPrefs.middleScroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
		return ClientPrefs.middleScroll ? "On" : "Off";
}
