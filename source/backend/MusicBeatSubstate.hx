package backend;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxBasic;
import flixel.FlxSprite;

#if android
import flixel.input.actions.FlxActionInput;
import android.FlxVirtualPad;
#end

class MusicBeatSubstate extends FlxSubState
{
	public function new()
	{
		super();
	}

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	#if android
	var _virtualpad:FlxVirtualPad;
	var trackedinputsUI:Array<FlxActionInput> = [];

	public function addVirtualPad(DPad:FlxDPadMode, Action:FlxActionMode)
	{
		_virtualpad = new FlxVirtualPad(DPad, Action);
		add(_virtualpad);

		controls.setVirtualPadUI(virtualPad, DPad, Action);
		trackedinputsUI = controls.trackedinputsUI;
		controls.trackedinputsUI = [];
	}

	public function removeVirtualPad()
	{
		if (trackedinputsUI != [])
			controls.removeFlxInput(trackedinputsUI);

		if (virtualPad != null)
			remove(_virtualpad);
	}

	public function addPadCamera()
	{
		if (_virtualpad != null)
		{
			var camControls = new flixel.FlxCamera();
			FlxG.cameras.add(camControls, false);
			camControls.bgColor.alpha = 0;
			_virtualpad.cameras = [camControls];
		}
	}
	#end

	override function destroy()
	{
		#if android
		if (trackedinputsUI != [])
			controls.removeFlxInput(trackedinputsUI);
		#end

		super.destroy();

		#if android
		if (_virtualpad != null)
		{
			_virtualpad = FlxDestroyUtil.destroy(virtualPad);
			_virtualpad = null;
		}
		#end
	}

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if(FlxG.keys.justPressed.F11)
        	FlxG.fullscreen = !FlxG.fullscreen;
		
		if (oldStep != curStep && curStep > 0)
			stepHit();

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
}
