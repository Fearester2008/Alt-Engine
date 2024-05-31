package backend;

import flixel.util.FlxGradient;

class CustomFadeTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	public static var nextCamera:FlxCamera;

	var isTransIn:Bool = false;
	var duration:Float;

	public function new(duration:Float, isTransIn:Bool) {
		super();
		this.isTransIn = isTransIn;
		this.duration = duration;
	}

	override function create()
	{
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length]];
		super.create();
	}

	override function update(elapsed:Float) {
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
	
		super.update(elapsed);
	}
}