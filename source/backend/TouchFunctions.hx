package backend;
import flixel.FlxBasic;

class TouchFunctions {
    public static var touchPressed(get, never):Bool;
    public static var touchJustPressed(get, never):Bool;
    public static var touchJustReleased(get, never):Bool;

	public static function touchOverlapObject(object:FlxBasic):Bool {
		for(touch in FlxG.touches.list)
			return touch.overlaps(object);
		return false;
	}

	@:noCompletion
    private static function get_touchPressed():Bool {
		for(touch in FlxG.touches.list)
			return touch.pressed;
        return false;
	}

    @:noCompletion
    private static function get_touchJustPressed():Bool {
		for(touch in FlxG.touches.list)
			return touch.justPressed;
        return false;
	}

    @:noCompletion
    private static function get_touchJustReleased():Bool {
		for(touch in FlxG.touches.list)
			return touch.justReleased;
        return false;
	}
}