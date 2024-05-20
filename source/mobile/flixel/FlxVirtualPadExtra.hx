package mobile.flixel;

import mobile.flixel.FlxButton;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxPoint;

/**
 * This code is a extend for extra virtualpad buttons 
 *
 * author: Karim Akra (UTFan)
 */
class FlxVirtualPadExtra extends FlxSpriteGroup
{
	public var buttonExtra:FlxButton = new FlxButton(0, 0);
    public var buttonExtra1:FlxButton = new FlxButton(0,0);

	/**
	 * Create a gamepad
	 */
	public function new(Mode:FlxExtraActions)
	{
		super();

		scrollFactor.set();

		switch (Mode)
		{
			case SINGLE:
            add(buttonExtra = createButton(0, FlxG.height - 135, 132, 127, 's', 0xFF0066FF));
            case DOUBLE:
            add(buttonExtra = createButton(0, FlxG.height - 135, 132, 127, 's', 0xFF0066FF));
            add(buttonExtra1 = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'g', 0x00FFF7));
			case NONE: // do nothing
		}
	}

	/**
	 * Clean up memory.
	 */
	override public function destroy():Void
	{
		super.destroy();

		buttonExtra = FlxDestroyUtil.destroy(buttonExtra);
        buttonExtra1 = FlxDestroyUtil.destroy(buttonExtra1);
	}

	private function createButton(X:Float, Y:Float, Width:Int, Height:Int, Graphic:String, ?Color:Int = 0xFFFFFF):FlxButton
	{
		var button:FlxButton = new FlxButton(X, Y);
		button.frames = FlxTileFrames.fromFrame(Paths.getSparrowAtlas('virtualpad').getByName(Graphic), FlxPoint.get(Width, Height));
		button.resetSizeFromFrame();
		button.solid = false;
		button.immovable = true;
		button.moves = false;
		button.scrollFactor.set();
		button.color = Color;
		button.antialiasing = ClientPrefs.data.antialiasing;
		#if FLX_DEBUG
		button.ignoreDrawDebug = true;
		#end
		return button;
	}	
}

enum FlxExtraActions
{
    SINGLE;
    DOUBLE;
    NONE;
}
