package objects;

import flixel.addons.ui.FlxInputText;

class InputText extends FlxInputText
{
    public var empty:Bool = true;

    public function new(x:Float, y:Float, width:Float, onEnter:(text:String)->Void)
    {
        super(x, y, Std.int(width));
        backgroundColor = FlxColor.TRANSPARENT;
        fieldBorderColor = FlxColor.TRANSPARENT;
        caretColor = FlxColor.WHITE;

        callback = (text, action) -> {
            if(action == FlxInputText.ENTER_ACTION)
            {
                hasFocus = false;
                onEnter(text);
            }
        };
    }
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(hasFocus && (FlxG.keys.justPressed.ESCAPE || (FlxG.mouse.justPressed && !FlxG.mouse.overlaps(this))))
        {
            hasFocus = false;
        }
        if(text == null)
        {
            empty = true;
        }
        else
        {
            empty = false;
        }
    }
}