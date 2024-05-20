package objects;

import flixel.FlxSprite;
import flixel.group.*;
import flixel.util.*;

enum FillDirection
{
	LEFT_TO_RIGHT;
	RIGHT_TO_LEFT;
	BOTTOM_TO_TOP;
	TOP_TO_BOTTOM;
}

class ExtendBar extends flixel.FlxState
{
    public var barBG:FlxSprite;
    public var bar:FlxSprite;
    public var barsBG:FlxTypedGroup<FlxSprite>;
    public var bars:FlxTypedGroup<FlxSprite>;

    //values
    public var emptyColor:FlxColor = FlxColor.BLACK;
    public var fillColor:FlxColor = FlxColor.BLACK;
    public var value:Float = 0;
    public var divisions:Int = 10;

    public var barX:Float;
    public var barY:Float;
    public var barWidth:Int = 100;
    public var barHeight:Int = 15;
    public var direction:FillDirection = BOTTOM_TO_TOP;
    public var barOffset:Float = 180;
    public var enabled:Bool = true;

    public function new(x:Float, y:Float, emptyColor:FlxColor = FlxColor.BLACK, fillColor:FlxColor = FlxColor.WHITE, divisions:Int = 10, barWidth:Int = 10, barHeight:Int = 20)
    {
        super();

        this.emptyColor = emptyColor;
        this.fillColor = fillColor;
        this.divisions = divisions;

        this.barX = x;
        this.barY = y;
        this.barWidth = barWidth;
        this.barHeight = barHeight;

        barsBG = new FlxTypedGroup<FlxSprite>();
        add(barsBG);

        bars = new FlxTypedGroup<FlxSprite>();
        add(bars);

        for(i in 0...divisions)
        {
            barBG = new FlxSprite().makeGraphic(barWidth, barHeight, emptyColor);
            barBG.scrollFactor.set();
            barsBG.add(barBG);

            bar = new FlxSprite().makeGraphic(barWidth, barHeight, fillColor);
            bar.scrollFactor.set();
            bars.add(bar);
        }
    }
    public function fillBarList(fill:FillDirection)
    {
        this.direction = fill;

        switch (fill)
        {
            case LEFT_TO_RIGHT:
            for(i in 0...divisions)
            {
            barsBG.members[i].x = 0 + barX + ((barWidth + 10) * i + 1);
            bars.members[i].x = 0 + barX + ((barWidth + 10) * i + 1);
            barsBG.members[i].y = barY;
            bars.members[i].y = barY;
            barsBG.members[i].angle = 0;
            bars.members[i].angle = 0;
            }

            case RIGHT_TO_LEFT:
            for(i in 0...divisions)
            {
            barsBG.members[i].x = barOffset + barX + ((barWidth + 10) * -i + 1);
            bars.members[i].x = barOffset + barX + ((barWidth + 10) * -i + 1);
            barsBG.members[i].y = barY;
            bars.members[i].y = barY;
            barsBG.members[i].angle = 0;
            bars.members[i].angle = 0;
            }

            case BOTTOM_TO_TOP:
            for(i in 0...divisions)
            {
            barsBG.members[i].x = barX;
            bars.members[i].x = barX;
            barsBG.members[i].y = 0 + barY + ((barWidth + 10) * -i + 1);
            bars.members[i].y = 0 + barY + ((barWidth + 10) * -i + 1);
            barsBG.members[i].angle = 90;
            bars.members[i].angle = 90;
            }

            case TOP_TO_BOTTOM:
            for(i in 0...divisions)
            {
            barsBG.members[i].x = barX;
            bars.members[i].x = barX;
            barsBG.members[i].y = -barOffset + barY + ((barWidth + 10) * i + 1);
            bars.members[i].y = -barOffset + barY + ((barWidth + 10) * i + 1);
            barsBG.members[i].angle = 90;
            bars.members[i].angle = 90;
            }

        }
    }
    public function updateValue(value:Float)
    {
        fillBarList(direction);
        if(!enabled)
            {
                for(i in 0...divisions)
                {
                    barsBG.members[i].alpha = 0.6;
                    bars.members[i].alpha = 0.6;
                }            
                return;
            }
        else
        {
            for(i in 0...divisions)
            {
                barsBG.members[i].alpha = 1;
                bars.members[i].alpha = 1;
            }
        }
        this.value = value;

        var valueToBars:Int = Math.round(value * divisions);

		for (i in 0...bars.members.length)
		{
			if (i < valueToBars)
			{
				bars.members[i].visible = true;
			}
			else
			{
				bars.members[i].visible = false;
			}
		}
    }

    override function update(elapsed:Float)
    {
        if(!enabled)
        {
            super.update(elapsed);
            return;
        }
        updateValue(value);
        fillBarList(direction);
    }
}
