package objects;

import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;

class JudgementCounter extends FlxState
{
    public var judgementCounter:FlxText;
    public var judgsGroup:FlxTypedGroup<FlxText>;
    public var judgs:Array<String> = [];
    public var counters:Array<Int> = [];
    public var defaultJudgs:Array<String> = ['Sicks', 'Goods', 'Bads', 'Shits'];
    public var defaultJudgsPercent:Array<String> = ['Sick', 'Good', 'Bad', 'Shit'];
    public var percents:Array<Float> = [];
    public var lerpPercents:Array<Float> = [];
    public var val:Int = 0;
    var judgementTextTween:FlxTween;
    var judgementTextHitTween:FlxTween;

    public function new(judgs:Array<String>, counters:Array<Int>, percents:Array<Float>)
    {
        super();
        if(judgs.length > 0)
            this.judgs = judgs;

        if(counters.length > 0)
            this.counters = counters;

        if(percents.length > 0)
            this.percents = percents;
        
        judgsGroup = new FlxTypedGroup<FlxText>();
        add(judgsGroup);

        for (i in 0...judgs.length)
        {
            var judgsVal:String = (ClientPrefs.data.judgementCounter == 'Counter') ? defaultJudgs[i] : defaultJudgsPercent[i];
            var subVal:String = (ClientPrefs.data.judgementCounter != 'Counter') ? '%' : '';
            var value:String = '' + Std.string(0) + subVal; 
            judgementCounter = new FlxText(20, FlxG.height / 2, 1280, (judgs != null) ? judgs[i] : judgsVal + ': ' + value, 22); 
            judgementCounter.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            judgementCounter.borderSize = 2;
            judgementCounter.borderQuality = 2;
            //judgementCounter.y += 20 * i;
            judgementCounter.scrollFactor.set();
            judgementCounter.visible = ClientPrefs.data.judgementCounter != 'Disabled' || !ClientPrefs.data.hideHud;
            judgsGroup.add(judgementCounter);
            FlxTween.tween(judgementCounter,{y: (FlxG.height / 2) + 20 * i}, 0.6, {ease:FlxEase.backInOut, startDelay: (0.6 * i) + 0.5});
        }
    }
    public function setFormat(size:Int, font:String)
    {
        judgementCounter.setFormat(Paths.font(font), size, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    }
    public function updateTextOnCounter(judgs:Array<String>, counters:Array<Int>)
        {
            this.judgs = judgs;
            this.counters = counters;
            
            for (i in 0...judgs.length)
            {
                var value:String = '' + Std.string(counters[i]);
                judgsGroup.members[i].text = judgs[i] + ': ' + Std.string(value);
            }
        }
    public function updateTextOnPercent(judgs:Array<String>, percents:Array<Float>)
        {
            this.judgs = judgs;
            this.percents = percents;
            
            for (i in 0...judgs.length)
            {
                lerpPercents[i] = FlxMath.lerp(lerpPercents[i], percents[i], 0.085);
                var value:String = '' + Std.string(MathUtil.truncatePercent(lerpPercents[i], 2));
                judgsGroup.members[i].text = judgs[i] + ': ' + Std.string(value) + '%';
            }
        }

        public function updateTextOnComplex(judgs:Array<String>, counters:Array<Int>, percents:Array<Float>)
            {
                this.judgs = judgs;
                this.counters = counters;
                this.percents = percents;

                for (i in 0...judgs.length)
                {
                    lerpPercents[i] = FlxMath.lerp(lerpPercents[i], percents[i], 0.085);
                    var value:String = '' + Std.string(MathUtil.truncatePercent(lerpPercents[i], 2)) + '%';
                    var countValue:String = ' (' + Std.string(counters[i]) + ')';
                    judgsGroup.members[i].text = judgs[i] + ': ' + Std.string(value + countValue);
                }
            }

        public function bop(val:Int):Void {
    
            this.val = val;

            judgsGroup.members[0].scale.x += 0.045;
            judgsGroup.members[0].scale.y += 0.045; 

            judgsGroup.members[val].scale.x += 0.045;
            judgsGroup.members[val].scale.y += 0.045;
    }
    
    override function update(elapsed:Float)
    {

        for(i in 0...judgs.length)
        {

            if(i != val)
            {
                judgsGroup.members[i].scale.x = FlxMath.lerp(judgsGroup.members[i].scale.x, 1, 0.2); 
                judgsGroup.members[i].scale.y = FlxMath.lerp(judgsGroup.members[i].scale.y, 1, 0.2); 
            }
        }

        judgsGroup.members[0].scale.x = FlxMath.lerp(judgsGroup.members[0].scale.x, 1, 0.2); 
        judgsGroup.members[0].scale.y = FlxMath.lerp(judgsGroup.members[0].scale.y, 1, 0.2);

        judgsGroup.members[val].scale.x = FlxMath.lerp(judgsGroup.members[val].scale.x, 1, 0.2); 
        judgsGroup.members[val].scale.y = FlxMath.lerp(judgsGroup.members[val].scale.y, 1, 0.2); 

        switch(ClientPrefs.data.judgementCounter)
        {
            case 'Counter':
            if(PlayState.instance.songHits > 0)
            updateTextOnCounter(['Hits', 'Sicks', 'Goods', 'Bads', 'Shits'], [PlayState.instance.songHits, PlayState.instance.sicks, PlayState.instance.goods, PlayState.instance.bads, PlayState.instance.shits]);
            else
            updateTextOnCounter(['Hits', 'Sicks', 'Goods', 'Bads', 'Shits'], [0, 0, 0, 0, 0]);

            case 'Percent':
            if(PlayState.instance.songHits > 0)
            updateTextOnPercent(['Hit' ,'Sick', 'Good', 'Bad', 'Shit'], [PlayState.instance.hitPercent, PlayState.instance.sickPercent, PlayState.instance.goodPercent, PlayState.instance.badPercent, PlayState.instance.shitPercent]);
            else
            updateTextOnPercent(['Hit' ,'Sick', 'Good', 'Bad', 'Shit'], [0, 0, 0, 0, 0]);

            case 'Complex':
            if(PlayState.instance.songHits > 0)
            updateTextOnComplex(['Hits', 'Sicks', 'Goods', 'Bads', 'Shits'], [PlayState.instance.songHits, PlayState.instance.sicks, PlayState.instance.goods, PlayState.instance.bads, PlayState.instance.shits], [PlayState.instance.hitPercent, PlayState.instance.sickPercent, PlayState.instance.goodPercent, PlayState.instance.badPercent, PlayState.instance.shitPercent]);
            else
            updateTextOnComplex(['Hits', 'Sicks', 'Goods', 'Bads', 'Shits'], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]);
        }
        super.update(elapsed);
    }
}
