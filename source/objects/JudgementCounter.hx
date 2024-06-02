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
    public var maxCounters:Array<Int> = [];
    public var defaultJudgs:Array<String> = ['Hits', 'Sicks', 'Goods', 'Bads', 'Shits'];
    public var defaultJudgsPercent:Array<String> = ['Hit', 'Sick', 'Good', 'Bad', 'Shit'];
    public var percents:Array<Float> = [];
    public var lerpPercents:Array<Float> = [];
    public var val:Int = 0;
    var judgementTextTween:FlxTween;
    var judgementTextHitTween:FlxTween;

    public function new(judgs:Array<String>, counters:Array<Int>, percents:Array<Float>, maxCounters:Array<Int>)
    {
        super();
        if(judgs.length > 0)
            this.judgs = judgs;

        if(counters.length > 0)
            this.counters = counters;

        if(maxCounters.length > 0)
            this.maxCounters = maxCounters;

        if(percents.length > 0)
            this.percents = percents;
        
        judgsGroup = new FlxTypedGroup<FlxText>();
        add(judgsGroup);

        for (i in 0...judgs.length)
        {
            var type:String = EnginePreferences.data.judgementCounter;
            var subVal:String = (EnginePreferences.data.judgementCounter != 'Counter') ? '%' : '';
            var judgsVal:String = "";
            switch(type)
            {
                case "Counter":
                judgsVal = defaultJudgs[i] + ": " + counters[i] + " / " + maxCounters[i];
                subVal = "";
                case "Percent":
                judgsVal = defaultJudgsPercent[i] + ": " + percents[i] + subVal;
                subVal = "%";
                case "Complex":
                judgsVal = defaultJudgsPercent[i] + ": " + percents[i] + subVal + " ( " + counters[i] + " / " + maxCounters[i] + " )";
                subVal = "%";
                case "Complex (Reversed)":
                judgsVal = defaultJudgs[i] + ": " + counters[i] + " / " + maxCounters[i] + " ( " + percents[i] + subVal + " )";
                subVal = "%";
            }
            trace(judgsVal);
            var value:String = '' + Std.string(0) + subVal; 
            judgementCounter = new FlxText(-300, FlxG.height / 2, 1280, judgsVal, 20); 
            judgementCounter.setFormat(Paths.font('vcr.ttf'), 25, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            judgementCounter.borderSize = 1.1;
            //judgementCounter.borderQuality = 2;
            judgementCounter.y += 20 * i;
            judgementCounter.scrollFactor.set();
            judgementCounter.visible = EnginePreferences.data.judgementCounter != 'Disabled' || !EnginePreferences.data.hideHud;
            judgsGroup.add(judgementCounter);
            FlxTween.tween(judgementCounter, {x: 20}, 0.6, {ease:FlxEase.sineInOut, startDelay: (0.1 * i)});
        }
    }
    public function setFormat(size:Int, font:String)
    {
        judgementCounter.setFormat(Paths.font(font), size, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    }
    public function updateTextOnCounter(judgs:Array<String>, counters:Array<Int>, maxCounters:Array<Int>)
        {
            this.judgs = judgs;
            this.counters = counters;
            
            for (i in 0...judgs.length)
            {
                var value:String = '' + Std.string(counters[i]);
                judgsGroup.members[i].text = judgs[i] + ': ' + Std.string(value) + " / " + Std.string(maxCounters[i]);
            }
        }
    public function updateTextOnPercent(judgs:Array<String>, percents:Array<Float>, maxCounters:Array<Int>)
        {
            this.judgs = judgs;
            this.maxCounters = maxCounters;
            this.percents = percents;
            
            for (i in 0...judgs.length)
            {
                lerpPercents[i] = FlxMath.lerp(lerpPercents[i], percents[i], 0.085);
                var value:String = '' + Std.string(MathUtil.truncatePercent(lerpPercents[i], 2));
                judgsGroup.members[i].text = judgs[i] + ': ' + Std.string(value) + '%';
            }
        }

        public function updateTextOnComplex(judgs:Array<String>, counters:Array<Int>, percents:Array<Float>, maxCounters:Array<Int>)
            {
                this.judgs = judgs;
                this.counters = counters;
                this.maxCounters = maxCounters;
                this.percents = percents;

                for (i in 0...judgs.length)
                {
                    lerpPercents[i] = FlxMath.lerp(lerpPercents[i], percents[i], 0.085);
                    var value:String = '' + Std.string(MathUtil.truncatePercent(lerpPercents[i], 2)) + '%';
                    var countValue:String = ' ( ' + Std.string(counters[i]) + " / " + Std.string(maxCounters[i]) + ' )';
                    judgsGroup.members[i].text = judgs[i] + ': ' + Std.string(value + countValue);
                }
            }
        
        public function updateTextOnReversedComplex(judgs:Array<String>, counters:Array<Int>, percents:Array<Float>, maxCounters:Array<Int>)
            {
                this.judgs = judgs;
                this.counters = counters;
                this.maxCounters = maxCounters;
                this.percents = percents;

                for (i in 0...judgs.length)
                {
                    lerpPercents[i] = FlxMath.lerp(lerpPercents[i], percents[i], 0.085);
                    var value:String = ' ( ' + Std.string(MathUtil.truncatePercent(lerpPercents[i], 2)) + '% )';
                    var countValue:String = Std.string(counters[i]) + " / " + Std.string(maxCounters[i]);
                    judgsGroup.members[i].text = judgs[i] + ': ' + Std.string(countValue + value);
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

        switch(EnginePreferences.data.judgementCounter)
        {
            case 'Counter':
            if(PlayState.instance.songHits > 0)
            updateTextOnCounter(['Hits', 'Sicks', 'Goods', 'Bads', 'Shits'], [PlayState.instance.songHits, PlayState.instance.sicks, PlayState.instance.goods, PlayState.instance.bads, PlayState.instance.shits], [PlayState.instance.totalNotes, PlayState.instance.songHits, PlayState.instance.songHits, PlayState.instance.songHits, PlayState.instance.songHits]);
            else
            updateTextOnCounter(['Hits', 'Sicks', 'Goods', 'Bads', 'Shits'], [0, 0, 0, 0, 0], [PlayState.instance.totalNotes,PlayState.instance.songHits, PlayState.instance.songHits, PlayState.instance.songHits, PlayState.instance.songHits]);

            case 'Percent':
            if(PlayState.instance.songHits > 0)
            updateTextOnPercent(['Hit' ,'Sick', 'Good', 'Bad', 'Shit'], [PlayState.instance.hitPercent, PlayState.instance.sickPercent, PlayState.instance.goodPercent, PlayState.instance.badPercent, PlayState.instance.shitPercent], [PlayState.instance.totalNotes, PlayState.instance.songHits, PlayState.instance.songHits, PlayState.instance.songHits, PlayState.instance.songHits]);
            else
            updateTextOnPercent(['Hit' ,'Sick', 'Good', 'Bad', 'Shit'], [0, 0, 0, 0, 0], [PlayState.instance.totalNotes, PlayState.instance.songHits, PlayState.instance.songHits, PlayState.instance.songHits, PlayState.instance.songHits]);

            case 'Complex':
            if(PlayState.instance.songHits > 0)
            updateTextOnComplex(['Hit', 'Sick', 'Good', 'Bad', 'Shit'], [PlayState.instance.songHits, PlayState.instance.sicks, PlayState.instance.goods, PlayState.instance.bads, PlayState.instance.shits], [PlayState.instance.hitPercent, PlayState.instance.sickPercent, PlayState.instance.goodPercent, PlayState.instance.badPercent, PlayState.instance.shitPercent], [PlayState.instance.totalNotes, PlayState.instance.songHits, PlayState.instance.songHits, PlayState.instance.songHits, PlayState.instance.songHits]);
            else
            updateTextOnComplex(['Hit', 'Sick', 'Good', 'Bad', 'Shit'], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [PlayState.instance.totalNotes, PlayState.instance.songHits, PlayState.instance.songHits, PlayState.instance.songHits, PlayState.instance.songHits]);
            
            case 'Complex (Reversed)':
            if(PlayState.instance.songHits > 0)
            updateTextOnReversedComplex(['Hits', 'Sicks', 'Goods', 'Bads', 'Shits'], [PlayState.instance.songHits, PlayState.instance.sicks, PlayState.instance.goods, PlayState.instance.bads, PlayState.instance.shits], [PlayState.instance.hitPercent, PlayState.instance.sickPercent, PlayState.instance.goodPercent, PlayState.instance.badPercent, PlayState.instance.shitPercent], [PlayState.instance.totalNotes, PlayState.instance.songHits, PlayState.instance.songHits, PlayState.instance.songHits, PlayState.instance.songHits]);
            else
            updateTextOnReversedComplex(['Hits', 'Sicks', 'Goods', 'Bads', 'Shits'], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [PlayState.instance.totalNotes, PlayState.instance.songHits, PlayState.instance.songHits, PlayState.instance.songHits, PlayState.instance.songHits]);
            
        }
        super.update(elapsed);
    }
}
