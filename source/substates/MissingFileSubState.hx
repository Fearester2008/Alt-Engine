
package substates;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;

using StringTools;

class MissingFileSubState extends MusicBeatSubstate
{
	var msg:String;
	var bigMsg:String;

	var detailText:Alphabet;
	var bigText:FlxText;

	public function new(message:String, headerText:String)
	{
		super();
		this.msg = message;
		this.bigMsg = headerText;
	}

	var canDoShit:Bool = false;
	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.SPACE && canDoShit){
            MusicBeatState.switchState(new states.FreeplayState());
        }
		super.update(elapsed);
	}
	override function create()
	{
		FlxG.camera.bgColor.alpha = 0;
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.7;
		add(bg);

		detailText = new Alphabet(90, 85, "", true);
		add(detailText);

		bigText = new FlxText(0, detailText.y + 140, FlxG.width, "", 24);
		bigText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		add(bigText);

		bigText.borderSize = 2;

		bigText.text = bigMsg;
		detailText.text = msg;

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		new FlxTimer().start(0.4,function(a:FlxTimer){
			canDoShit = true;
			states.FreeplayState.switched = true;
		});

		super.create();
	}
}