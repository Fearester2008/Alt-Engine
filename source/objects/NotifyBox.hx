package objects;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.util.FlxColor;

enum BoxType
{
    ERROR;
    WARNING;
    TRACE;
    INFO;
}

class NotifyBox extends FlxState
{
    public var box:FlxSprite;
    public var boxLine:FlxSprite;
    public var boxText:FlxText;
    public var boxTitle:FlxText;

    public var title:String = '';
    public var oldText:String;
    public var newText:String;
    public var type:BoxType = INFO;
    public var color:FlxColor;
    public var show:Bool = false;
    public var changedText:Bool = true;
    public var typeString:String = 'INFO';
    //for fix is crash
    public function new()
    {
        super();
    }

    public function createBox()
    {
        box = FlxSpriteUtil.drawRoundRect(new FlxSprite(0, 0).makeGraphic(650, 100, FlxColor.TRANSPARENT), 0, 0, 650, 100, 35, 35, 0xFF000000);
        box.y = 15;
        box.alpha = 0.6;
        box.scrollFactor.set();
        box.screenCenter(X);
        add(box);

        boxLine = new FlxSprite(0, 0).makeGraphic(650, 5, 0xFFFFFFFF);
        boxLine.alpha = 1;
        boxLine.scrollFactor.set();
        boxLine.screenCenter(X);
        add(boxLine);

        boxTitle = new FlxText(box.x + 8, box.y, box.width, '', 10);
        boxTitle.scrollFactor.set();
        boxTitle.screenCenter(X);
        boxTitle.setFormat(Paths.font('vcr.ttf'), 15, color, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(boxTitle);

        boxText = new FlxText(box.x + 8, box.y + 5, box.width - 30, '', 25);
        boxText.scrollFactor.set();
        boxText.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(boxText);

        if(title == null)
            title = AppController.appName + " v: " + AppController.altEngineVersion + AppController.stage;
            
    }

    public function updatePosition():Void
    {
        boxTitle.y = box.y;
        boxText.x = box.x + 10;
        boxText.y = box.y + 20;
        boxLine.y = box.y + 15;
        boxText.fieldWidth = box.width - 30;

        boxTitle.visible = show;
        boxText.visible = show;
        boxLine.visible = show;
    }

    public function updateText(title:String, text:String):Void
    {
        newText = text;
        this.title = title;

        boxTitle.text = title;
        boxText.text = text;

        updateType(typeString);
    }
    public function updateType(type:String)
    {
        typeString = type;
        switch(type)
        {
            case "TRACE":
            this.type = TRACE;
            boxTitle.color = FlxColor.WHITE;
            case "ERROR":
            this.type = ERROR;
            boxTitle.text += " - ERROR!";
            boxTitle.color = FlxColor.RED;
            case "INFO":
            this.type = INFO;
            boxTitle.color = FlxColor.GREEN;
            case "WARNING":
            this.type = WARNING;
            boxTitle.color = FlxColor.YELLOW;
            boxTitle.text += " - WARNING!";
        }
    }
    override function update(elapsed:Float):Void
    {
        updatePosition();

        if(!changedText)
        {
            oldText = null;
        }
           
        show = (!changedText) ? true : false;
        if(!changedText)
        {
            new FlxTimer().start(4, function(tmr:FlxTimer)
            {
                oldText = newText;
                changedText = true;
            });
        }
        else if(newText != oldText)
        {
            FlxG.sound.play(Paths.sound('confirmMenu'));
            changedText = false;
        }
        
        box.visible = show;
        super.update(elapsed);
    }
}
