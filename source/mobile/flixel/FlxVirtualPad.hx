package mobile.flixel;

import mobile.flixel.FlxButton;
import mobile.flixel.FlxButton.ButtonsStates;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxPoint;
import haxe.ds.Map;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

/**
 * A gamepad.
 * It's easy to customize the layout.
 *
 * @original author Ka Wing Chin & Mihai Alexandru
 * @modification's author: Karim Akra (UTFan) & Lily (mcagabe19)
 */
class FlxVirtualPad extends FlxButtonGroup
{
	public var buttonLeft:FlxButton = new FlxButton(0, 0);
	public var buttonUp:FlxButton = new FlxButton(0, 0);
	public var buttonRight:FlxButton = new FlxButton(0, 0);
	public var buttonDown:FlxButton = new FlxButton(0, 0);
	public var buttonLeft2:FlxButton = new FlxButton(0, 0);
	public var buttonUp2:FlxButton = new FlxButton(0, 0);
	public var buttonRight2:FlxButton = new FlxButton(0, 0);
	public var buttonDown2:FlxButton = new FlxButton(0, 0);
	public var buttonA:FlxButton = new FlxButton(0, 0);
	public var buttonB:FlxButton = new FlxButton(0, 0);
	public var buttonC:FlxButton = new FlxButton(0, 0);
	public var buttonD:FlxButton = new FlxButton(0, 0);
	public var buttonE:FlxButton = new FlxButton(0, 0);
    public var buttonF:FlxButton = new FlxButton(0, 0);
    public var buttonG:FlxButton = new FlxButton(0, 0);
    public var buttonS:FlxButton = new FlxButton(0, 0);
	public var buttonV:FlxButton = new FlxButton(0, 0);
	public var buttonX:FlxButton = new FlxButton(0, 0);
	public var buttonY:FlxButton = new FlxButton(0, 0);
	public var buttonZ:FlxButton = new FlxButton(0, 0);
	public var buttonP:FlxButton = new FlxButton(0, 0);

	public var buttonsMap:Map<FlxMobileInputID, FlxButton> = new Map<FlxMobileInputID, FlxButton>();
	// kill me -Karim
	public var buttons:Array<FlxMobileInputID> = [
		FlxMobileInputID.A,
		FlxMobileInputID.B,
		FlxMobileInputID.C,
		FlxMobileInputID.D,
		FlxMobileInputID.E,
		FlxMobileInputID.F,
		FlxMobileInputID.G,
		FlxMobileInputID.S,
		FlxMobileInputID.V,
		FlxMobileInputID.X,
		FlxMobileInputID.Y,
		FlxMobileInputID.Z,
		FlxMobileInputID.P,
		FlxMobileInputID.UP,
		FlxMobileInputID.UP2,
		FlxMobileInputID.DOWN,
		FlxMobileInputID.DOWN2,
		FlxMobileInputID.LEFT,
		FlxMobileInputID.LEFT2,
		FlxMobileInputID.RIGHT,
		FlxMobileInputID.RIGHT2,
		FlxMobileInputID.noteUP,
		FlxMobileInputID.noteDOWN,
		FlxMobileInputID.noteLEFT,
		FlxMobileInputID.noteRIGHT
	];

	/**
	 * Create a gamepad.
	 *
	 * @param   DPadMode     The D-Pad mode. `LEFT_FULL` for example.
	 * @param   ActionMode   The action buttons mode. `A_B_C` for example.
	 */
	public function new(DPad:FlxDPadMode, Action:FlxActionMode)
	{
		super();

		var buttonLeftColor:Array<FlxColor>;
		var buttonDownColor:Array<FlxColor>;
		var buttonUpColor:Array<FlxColor>;
		var buttonRightColor:Array<FlxColor>;

		buttonLeftColor = ClientPrefs.defaultData.arrowRGB[0];
		buttonDownColor = ClientPrefs.defaultData.arrowRGB[1];
		buttonUpColor = ClientPrefs.defaultData.arrowRGB[2];
		buttonRightColor = ClientPrefs.defaultData.arrowRGB[3];

		scrollFactor.set();

		switch (DPad)
		{
			case UP_DOWN:
				add(buttonUp = createButton(0, FlxG.height - 255, 132, 127, 'up', buttonUpColor[0]));
				add(buttonDown = createButton(0, FlxG.height - 135, 132, 127, 'down', buttonDownColor[0]));
			case LEFT_RIGHT:
				add(buttonLeft = createButton(0, FlxG.height - 135, 132, 127, 'left', buttonLeftColor[0]));
				add(buttonRight = createButton(127, FlxG.height - 135, 132, 127, 'right', buttonRightColor[0]));
			case UP_LEFT_RIGHT:
				add(buttonUp = createButton(105, FlxG.height - 243, 132, 127, 'up', buttonUpColor[0]));
				add(buttonLeft = createButton(0, FlxG.height - 135, 132, 127, 'left', buttonLeftColor[0]));
				add(buttonRight = createButton(207, FlxG.height - 135, 132, 127, 'right', buttonRightColor[0]));
			case LEFT_FULL:
				add(buttonUp = createButton(105, FlxG.height - 345, 132, 127, 'up', buttonUpColor[0]));
				add(buttonLeft = createButton(0, FlxG.height - 243, 132, 127, 'left', buttonLeftColor[0]));
				add(buttonRight = createButton(207, FlxG.height - 243, 132, 127, 'right', buttonRightColor[0]));
				add(buttonDown = createButton(105, FlxG.height - 135, 132, 127, 'down', buttonDownColor[0]));
			case RIGHT_FULL:
				add(buttonUp = createButton(FlxG.width - 258, FlxG.height - 408, 132, 127, 'up', buttonUpColor[0]));
				add(buttonLeft = createButton(FlxG.width - 384, FlxG.height - 309, 132, 127, 'left', buttonLeftColor[0]));
				add(buttonRight = createButton(FlxG.width - 132, FlxG.height - 309, 132, 127, 'right', buttonRightColor[0]));
				add(buttonDown = createButton(FlxG.width - 258, FlxG.height - 201, 132, 127, 'down', buttonDownColor[0]));
			case BOTH:
				add(buttonUp = createButton(105, FlxG.height - 345, 132, 127, 'up', buttonUpColor[0]));
				add(buttonLeft = createButton(0, FlxG.height - 243, 132, 127, 'left', buttonLeftColor[0]));
				add(buttonRight = createButton(207, FlxG.height - 243, 132, 127, 'right', buttonRightColor[0]));
				add(buttonDown = createButton(105, FlxG.height - 135, 132, 127, 'down', buttonDownColor[0]));
				add(buttonUp2 = createButton(FlxG.width - 258, FlxG.height - 408, 132, 127, 'up', buttonUpColor[0]));
				add(buttonLeft2 = createButton(FlxG.width - 384, FlxG.height - 309, 132, 127, 'left', buttonLeftColor[0]));
				add(buttonRight2 = createButton(FlxG.width - 132, FlxG.height - 309, 132, 127, 'right', buttonRightColor[0]));
				add(buttonDown2 = createButton(FlxG.width - 258, FlxG.height - 201, 132, 127, 'down', buttonDownColor[0]));
			// PSYCH RELEATED BUTTONS
			case DIALOGUE_PORTRAIT:
				add(buttonUp = createButton(105, FlxG.height - 345, 132, 127, 'up', buttonUpColor[0]));
				add(buttonLeft = createButton(0, FlxG.height - 243, 132, 127, 'left', buttonLeftColor[0]));
				add(buttonRight = createButton(207, FlxG.height - 243, 132, 127, 'right', buttonRightColor[0]));
				add(buttonDown = createButton(105, FlxG.height - 135, 132, 127, 'down', buttonDownColor[0]));
				add(buttonUp2 = createButton(105, 0, 132, 127, 'up', buttonUpColor[0]));
				add(buttonLeft2 = createButton(0, 82, 132, 127, 'left', buttonLeftColor[0]));
				add(buttonRight2 = createButton(207, 82, 132, 127, 'right', buttonRightColor[0]));
				add(buttonDown2 = createButton(105, 190, 132, 127, 'down', buttonDownColor[0]));
			case MENU_CHARACTER:
				add(buttonUp = createButton(105, 0, 132, 127, 'up', buttonUpColor[0]));
				add(buttonLeft = createButton(0, 82, 132, 127, 'left', buttonLeftColor[0]));
				add(buttonRight = createButton(207, 82, 132, 127, 'right', buttonRightColor[0]));
				add(buttonDown = createButton(105, 190, 132, 127, 'down', buttonDownColor[0]));
			case NOTE_SPLASH_DEBUG:
				add(buttonLeft = createButton(0, 0, 132, 127, 'left', buttonLeftColor[0]));
				add(buttonRight = createButton(127, 0, 132, 127, 'right', buttonRightColor[0]));
				add(buttonUp = createButton(0, 125, 132, 127, 'up', buttonUpColor[0]));
				add(buttonDown = createButton(127, 125, 132, 127, 'down', buttonDownColor[0]));
				add(buttonUp2 = createButton(127, 393, 132, 127, 'up', buttonUpColor[0]));
				add(buttonLeft2 = createButton(0, 393, 132, 127, 'left', buttonLeftColor[0]));
				add(buttonRight2 = createButton(1145, 393, 132, 127, 'right', buttonRightColor[0]));
				add(buttonDown2 = createButton(1015, 393, 132, 127, 'down', buttonDownColor[0]));
			case NONE: // do nothing
		}

		switch (Action)
		{
			case A:
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000));
			case B:
				add(buttonB = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'b', 0xFFCB00));
			case B_X:
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00));
				add(buttonX = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'x', 0x99062D));
			case A_B:
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000));
			case A_B_C:
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 132, 127, 'c', 0x44FF00));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000));
			case A_B_E:
				add(buttonE = createButton(FlxG.width - 384, FlxG.height - 135, 132, 127, 'e', 0xFF7D00));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000));
			case A_B_X_Y:
				add(buttonX = createButton(FlxG.width - 510, FlxG.height - 135, 132, 127, 'x', 0x99062D));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00));
				add(buttonY = createButton(FlxG.width - 384, FlxG.height - 135, 132, 127, 'y', 0x4A35B9));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000));
			case A_B_C_X_Y:
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 132, 127, 'c', 0x44FF00));
				add(buttonX = createButton(FlxG.width - 258, FlxG.height - 255, 132, 127, 'x', 0x99062D));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00));
				add(buttonY = createButton(FlxG.width - 132, FlxG.height - 255, 132, 127, 'y', 0x4A35B9));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000));
			case A_B_C_X_Y_Z:
				add(buttonX = createButton(FlxG.width - 384, FlxG.height - 255, 132, 127, 'x', 0x99062D));
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 132, 127, 'c', 0x44FF00));
				add(buttonY = createButton(FlxG.width - 258, FlxG.height - 255, 132, 127, 'y', 0x4A35B9));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00));
				add(buttonZ = createButton(FlxG.width - 132, FlxG.height - 255, 132, 127, 'z', 0xCCB98E));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000));
			case A_B_C_D_V_X_Y_Z:
				add(buttonV = createButton(FlxG.width - 510, FlxG.height - 255, 132, 127, 'v', 0x49A9B2));
				add(buttonD = createButton(FlxG.width - 510, FlxG.height - 135, 132, 127, 'd', 0x0078FF));
				add(buttonX = createButton(FlxG.width - 384, FlxG.height - 255, 132, 127, 'x', 0x99062D));
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 132, 127, 'c', 0x44FF00));
				add(buttonY = createButton(FlxG.width - 258, FlxG.height - 255, 132, 127, 'y', 0x4A35B9));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00));
				add(buttonZ = createButton(FlxG.width - 132, FlxG.height - 255, 132, 127, 'z', 0xCCB98E));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000));
			// PSYCH RELEATED BUTTONS
			case CHARACTER_EDITOR:
				add(buttonV = createButton(FlxG.width - 510, FlxG.height - 255, 132, 127, 'v', 0x49A9B2));
				add(buttonD = createButton(FlxG.width - 510, FlxG.height - 135, 132, 127, 'd', 0x0078FF));
				add(buttonX = createButton(FlxG.width - 384, FlxG.height - 255, 132, 127, 'x', 0x99062D));
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 132, 127, 'c', 0x44FF00));
				add(buttonS = createButton(FlxG.width - 636, FlxG.height - 135, 132, 127, 's', 0xEA00FF));
				add(buttonF = createButton(FlxG.width - 410, 0, 132, 127, 'f', 0xFF009D));
				add(buttonY = createButton(FlxG.width - 258, FlxG.height - 255, 132, 127, 'y', 0x4A35B9));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00));
				add(buttonZ = createButton(FlxG.width - 132, FlxG.height - 255, 132, 127, 'z', 0xCCB98E));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000));
			case DIALOGUE_PORTRAIT:
				add(buttonX = createButton(FlxG.width - 384, 0, 132, 127, 'x', 0x99062D));
				add(buttonC = createButton(FlxG.width - 384, 125, 132, 127, 'c', 0x44FF00));
				add(buttonY = createButton(FlxG.width - 258, 0, 132, 127, 'y', 0x4A35B9));
				add(buttonB = createButton(FlxG.width - 258, 125, 132, 127, 'b', 0xFFCB00));
				add(buttonZ = createButton(FlxG.width - 132, 0, 132, 127, 'z', 0xCCB98E));
				add(buttonA = createButton(FlxG.width - 132, 125, 132, 127, 'a', 0xFF0000));
			case MENU_CHARACTER:
				add(buttonC = createButton(FlxG.width - 384, 0, 132, 127, 'c', 0x44FF00));
				add(buttonB = createButton(FlxG.width - 258, 0, 132, 127, 'b', 0xFFCB00));
				add(buttonA = createButton(FlxG.width - 132, 0, 132, 127, 'a', 0xFF0000));
			case NOTE_SPLASH_DEBUG:
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00));
				add(buttonE = createButton(FlxG.width - 132, 0, 132, 127, 'e', 0xFF7D00));
				add(buttonX = createButton(FlxG.width - 258, 0, 132, 127, 'x', 0x99062D));
				add(buttonY = createButton(FlxG.width - 132, 250, 132, 127, 'y', 0x4A35B9));
				add(buttonZ = createButton(FlxG.width - 258, 250, 132, 127, 'z', 0xCCB98E));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000));
				add(buttonC = createButton(FlxG.width - 132, 125, 132, 127, 'c', 0x44FF00));
				add(buttonV = createButton(FlxG.width - 258, 125, 132, 127, 'v', 0x49A9B2));
			case P:
				add(buttonP = createButton(FlxG.width - 132, 0, 132, 127, 'x', 0x99062D));
			case B_C:
				add(buttonC = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'c', 0x44FF00));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00));
			case NONE: // do nothing
		}
		updateMap();
	}

	/*
	 * Clean up memory.
	 */
	override public function destroy():Void
	{
		super.destroy();

		buttonLeft = FlxDestroyUtil.destroy(buttonLeft);
		buttonUp = FlxDestroyUtil.destroy(buttonUp);
		buttonDown = FlxDestroyUtil.destroy(buttonDown);
		buttonRight = FlxDestroyUtil.destroy(buttonRight);
		buttonLeft2 = FlxDestroyUtil.destroy(buttonLeft2);
		buttonUp2 = FlxDestroyUtil.destroy(buttonUp2);
		buttonDown2 = FlxDestroyUtil.destroy(buttonDown2);
		buttonRight2 = FlxDestroyUtil.destroy(buttonRight2);
		buttonA = FlxDestroyUtil.destroy(buttonA);
		buttonB = FlxDestroyUtil.destroy(buttonB);
		buttonC = FlxDestroyUtil.destroy(buttonC);
		buttonD = FlxDestroyUtil.destroy(buttonD);
		buttonE = FlxDestroyUtil.destroy(buttonE);
        buttonF = FlxDestroyUtil.destroy(buttonF);
        buttonG = FlxDestroyUtil.destroy(buttonG);
        buttonS = FlxDestroyUtil.destroy(buttonS);
		buttonV = FlxDestroyUtil.destroy(buttonV);
		buttonX = FlxDestroyUtil.destroy(buttonX);
		buttonY = FlxDestroyUtil.destroy(buttonY);
		buttonZ = FlxDestroyUtil.destroy(buttonZ);
		buttonP = FlxDestroyUtil.destroy(buttonP);
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
		button.tag = Graphic.toUpperCase();
		return button;
	}

	/**
	* Check to see if the button was pressed.
	*
	* @param	button 	A button ID
	* @return	Whether at least one of the buttons passed was pressed.
	*/
	public inline function buttonPressed(button:FlxMobileInputID):Bool {
		return anyPressed([button]);
	}

	/**
	* Check to see if the button was just pressed.
	*
	* @param	button 	A button ID
	* @return	Whether at least one of the buttons passed was just pressed.
	*/
	public inline function buttonJustPressed(button:FlxMobileInputID):Bool {
		return anyJustPressed([button]);
	}
	
	/**
	* Check to see if the button was just released.
	*
	* @param	button 	A button ID
	* @return	Whether at least one of the buttons passed was just released.
	*/
	public inline function buttonJustReleased(button:FlxMobileInputID):Bool {
		return anyJustReleased([button]);
	}

	/**
	* Check to see if at least one button from an array of buttons is pressed.
	*
	* @param	buttonsArray 	An array of buttos names
	* @return	Whether at least one of the buttons passed in is pressed.
	*/
	public inline function anyPressed(buttonsArray:Array<FlxMobileInputID>):Bool {
		return checkButtonArrayState(buttonsArray, PRESSED);
	}

	/**
	* Check to see if at least one button from an array of buttons was just pressed.
	*
	* @param	buttonsArray 	An array of buttons names
	* @return	Whether at least one of the buttons passed was just pressed.
	*/
	public inline function anyJustPressed(buttonsArray:Array<FlxMobileInputID>):Bool {
		return checkButtonArrayState(buttonsArray, JUST_PRESSED);
	}
	
	/**
	* Check to see if at least one button from an array of buttons was just released.
	*
	* @param	buttonsArray 	An array of button names
	* @return	Whether at least one of the buttons passed was just released.
	*/
	public inline function anyJustReleased(buttonsArray:Array<FlxMobileInputID>):Bool {
		return checkButtonArrayState(buttonsArray, JUST_RELEASED);
	}

	/**
	 * Check the status of a single button
	 *
	 * @param	Button		button to be checked.
	 * @param	state		The button state to check for.
	 * @return	Whether the provided key has the specified status.
	 */
	 public function checkStatus(button:FlxMobileInputID, state:ButtonsStates = JUST_PRESSED):Bool {
		switch(button){
			case FlxMobileInputID.ANY:
				for(each in buttons){
					checkStatusUnsafe(each, state);
				}
			case FlxMobileInputID.NONE:
				return false;
	
			default:
				if(this.buttonsMap.exists(button))
					return checkStatusUnsafe(button, state);
		}
		return false;
	}

	/**
	* Helper function to check the status of an array of buttons
	*
	* @param	Buttons	An array of buttons as Strings
	* @param	state		The button state to check for
	* @return	Whether at least one of the buttons has the specified status
	*/
	function checkButtonArrayState(Buttons:Array<FlxMobileInputID>, state:ButtonsStates = JUST_PRESSED):Bool {
		if(Buttons == null)
			return false;
	
		for(button in Buttons)
			if(checkStatus(button, state))
				return true;

		return false;
	}

	function checkStatusUnsafe(button:FlxMobileInputID, state:ButtonsStates = JUST_PRESSED):Bool {
		return this.buttonsMap.get(button).hasState(state);
	}

	function updateMap() {
		buttonsMap.clear();
		// DPad Buttons
		buttonsMap.set(FlxMobileInputID.UP, buttonUp);
		buttonsMap.set(FlxMobileInputID.UP2, buttonUp2);
		buttonsMap.set(FlxMobileInputID.DOWN, buttonDown);
		buttonsMap.set(FlxMobileInputID.DOWN2, buttonDown2);
		buttonsMap.set(FlxMobileInputID.LEFT, buttonLeft);
		buttonsMap.set(FlxMobileInputID.LEFT2, buttonLeft2);
		buttonsMap.set(FlxMobileInputID.RIGHT, buttonRight);
		buttonsMap.set(FlxMobileInputID.RIGHT2, buttonRight2);

		buttonsMap.set(FlxMobileInputID.noteUP, buttonUp);
		buttonsMap.set(FlxMobileInputID.noteRIGHT, buttonRight);
		buttonsMap.set(FlxMobileInputID.noteLEFT, buttonLeft);
		buttonsMap.set(FlxMobileInputID.noteDOWN, buttonDown);

		// Actions buttons
		buttonsMap.set(FlxMobileInputID.A, buttonA);
		buttonsMap.set(FlxMobileInputID.B, buttonB);
		buttonsMap.set(FlxMobileInputID.C, buttonC);
		buttonsMap.set(FlxMobileInputID.D, buttonD);
		buttonsMap.set(FlxMobileInputID.E, buttonE);
		buttonsMap.set(FlxMobileInputID.F, buttonF);
		buttonsMap.set(FlxMobileInputID.G, buttonG);
		buttonsMap.set(FlxMobileInputID.S, buttonS);
		buttonsMap.set(FlxMobileInputID.V, buttonV);
		buttonsMap.set(FlxMobileInputID.X, buttonX);
		buttonsMap.set(FlxMobileInputID.Y, buttonY);
		buttonsMap.set(FlxMobileInputID.Z, buttonZ);
		buttonsMap.set(FlxMobileInputID.P, buttonP);
	}
}

enum FlxDPadMode
{
	UP_DOWN;
	LEFT_RIGHT;
	UP_LEFT_RIGHT;
	LEFT_FULL;
	RIGHT_FULL;
	BOTH;
	DIALOGUE_PORTRAIT;
	MENU_CHARACTER;
	NOTE_SPLASH_DEBUG;
	NONE;
}

enum FlxActionMode
{
	A;
	B;
	B_X;
	A_B;
	A_B_C;
	A_B_E;
	A_B_X_Y;
	A_B_C_X_Y;
	A_B_C_X_Y_Z;
	A_B_C_D_V_X_Y_Z;
	CHARACTER_EDITOR;
	DIALOGUE_PORTRAIT;
	MENU_CHARACTER;
	NOTE_SPLASH_DEBUG;
	P;
	B_C;
	NONE;
}

typedef FlxButtonGroup = FlxTypedSpriteGroup<FlxButton>;

