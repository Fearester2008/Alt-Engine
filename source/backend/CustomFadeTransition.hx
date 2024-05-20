package backend;

import flixel.util.FlxGradient;
import flixel.FlxSubState;

class CustomFadeTransition extends FlxSubState {
	public static var finishCallback:Void->Void;
	var isTransIn:Bool = false;
	var duration:Float;
	public function new(duration:Float, isTransIn:Bool)
	{
		this.duration = duration;
		this.isTransIn = isTransIn;
		super();
	}

	override function create()
	{
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length]];

		super.create();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if(isTransIn)
		{
			FlxG.cameras.fade(FlxColor.BLACK, duration, true);
			new FlxTimer().start(duration, function(_) {
				close();
				if(finishCallback != null) finishCallback();
				finishCallback = null;
			});
		}
		else
		{
			FlxG.cameras.fade(FlxColor.BLACK, duration, false);
			new FlxTimer().start(duration, function(_) {
				close();
				if(finishCallback != null) finishCallback();
				finishCallback = null;
			});
		}

		
	}
}
