package text;

//basically flx text.
import flixel.math.FlxMath;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;

class FlixText extends FlxSpriteGroup {
    public var theText:FlxText;
    public var targetY:Float = 0;
    public var isMenu:Bool = false;
    public var theXPos:Float = 0;
    public var changedX:Bool = false;
    public var changedY:Bool = true;
    public var center:Bool = false;
    public var itemType:String = 'Classic';
    public var targetX:Float = 0;
    public var yMult:Float = 120;
	public var xAdd:Float = 0;
	public var yAdd:Float = 0;

	public var forceX:Float = Math.NEGATIVE_INFINITY;

    public function new(x:Float, y:Float, text:String = '', size:Int, color:FlxColor, alignment:FlxTextAlign) {
        super();
        theText = new FlxText(x,y,FlxG.width,text,size);
        theText.setFormat('VCR OSD Mono', size,color,alignment,OUTLINE,FlxColor.BLACK);
        theText.borderSize = 2;
        add(theText);
    }

    override function update(elapsed:Float) { //hehe boi, Alphabet.hx update code.
        var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3); 
        if (isMenu)
            {    
                var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
                if(changedY)
                {
                theText.y = FlxMath.lerp(theText.y, 200 + (scaledY * 30) + (FlxG.height * 0.1), lerpVal);
                }
                if(changedX)
                {
                theText.x = FlxMath.lerp(theText.x, theXPos, CoolUtil.boundTo(elapsed * 32, 0, 1));	
                }
            }
            if (center)
                {
                    var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
                    y = FlxMath.lerp(y, (scaledY * yMult) + (FlxG.height * 0.48) + yAdd, lerpVal);
                    if(forceX != Math.NEGATIVE_INFINITY) {
                        screenCenter(X);
                    } else {
                        screenCenter(X);
                    }
                }
    
                    switch (itemType)
                    {
                    case "Classic":
                y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * 0.48), 0.16);
                x = FlxMath.lerp(x, (targetY * 20) + 90, 0.16);
                 case "Horizontal":
                y = FlxMath.lerp(y, (scaledY * -10) + (FlxG.height * 0.48), 0.16);
                x = FlxMath.lerp(x, (targetY * 320) + 390, 0.16);
                    case "Vertical":
                y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * 0.5), 0.16);
                x = FlxMath.lerp(x, (targetY * 0) + 308, 0.16);
                x += targetX;
                case "C-Shape":
                y = FlxMath.lerp(y, (scaledY * 65) + (FlxG.height * 0.39), 0.16);
    
                x = FlxMath.lerp(x, Math.exp(scaledY * 0.8) * 70 + (FlxG.width * 0.1), 0.16);
                if (scaledY < 0)
                    x = FlxMath.lerp(x, Math.exp(scaledY * -0.8) * 70 + (FlxG.width * 0.1), 0.16);
    
                if (x > FlxG.width + 30)
                    x = FlxG.width + 30;
                    case "D-Shape":
                y = FlxMath.lerp(y, (scaledY * 90) + (FlxG.height * 0.45), 0.16);
    
                x = FlxMath.lerp(x, Math.exp(scaledY * 0.8) * -70 + (FlxG.width * 0.35), 0.16);
                if (scaledY < 0)
                    x = FlxMath.lerp(x, Math.exp(scaledY * -0.8) * -70 + (FlxG.width * 0.35), 0.16);
    
                if (x < -900)
                    x = -900;
            }
            
                    if (center)
                         screenCenter(X);
        super.update(elapsed);
    }
}
