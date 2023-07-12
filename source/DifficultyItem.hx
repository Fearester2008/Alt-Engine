package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class DifficultyItem extends FlxSprite
{
    public var targetY:Float = 0;

    public function new(x:Float, y:Float, difficulty:String = '')
        {
            super(x, y);
            loadGraphic(Paths.image('menudifficulties/' + difficulty));
            //trace('Test added: ' + WeekData.getWeekNumber(weekNum) + ' (' + weekNum + ')');
            antialiasing = ClientPrefs.globalAntialiasing;
        }

        override function update(elapsed:Float)
            {
                super.update(elapsed);
                y = FlxMath.lerp(y, (targetY * 120) + 480, CoolUtil.boundTo(elapsed * 10.2, 0, 1));
            }
}

