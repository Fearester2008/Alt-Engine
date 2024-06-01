package objects;

import flixel.util.FlxSpriteUtil;
import backend.TouchFunctions;

class Button extends FlxSpriteGroup
{
	public var bg:FlxSprite;
	public var buttonText:FlxText;
	public var icon:FlxSprite;
	public var onClick:Void->Void = null;
	public var enabled(default, set):Bool = true;
	public function new(x:Float, y:Float, width:Int, height:Int, ?text:String = null, onClick:Void->Void = null)
	{
		super(x, y);
		
		bg = FlxSpriteUtil.drawRoundRect(new FlxSprite().makeGraphic(width, height, FlxColor.TRANSPARENT), 0, 0, width, height, 15, 15, FlxColor.WHITE);
		bg.color = FlxColor.BLACK;
		add(bg);

		if(text != null)
		{
			buttonText = new FlxText(bg.x, bg.y, bg.width, text, 29);
			centerOnBg(buttonText);
			buttonText.scrollFactor.set();
			buttonText.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            buttonText.borderSize = 2;
            buttonText.borderQuality = 2;
			add(buttonText);
		}

		this.onClick = onClick;
		setButtonVisibility(false);
	}

	public var focusChangeCallback:Bool->Void = null;
	public var onFocus(default, set):Bool = false;
	public var ignoreCheck:Bool = false;
	private var _needACheck:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(!enabled)
		{
			onFocus = false;
			return;
		}

			#if mobile
			if(!ignoreCheck)
				onFocus = TouchFunctions.touchOverlapObject(this);

			if(onFocus && TouchFunctions.touchJustReleased)
				onFocus = false;

			if(onFocus && onClick != null && TouchFunctions.touchJustPressed)
				onClick();

			if(_needACheck) {
				_needACheck = false;
				setButtonVisibility(TouchFunctions.touchOverlapObject(this));
			}
			#else
			if(!ignoreCheck && !Controls.instance.controllerMode && FlxG.mouse.justMoved && FlxG.mouse.visible)
				onFocus = FlxG.mouse.overlaps(this);

			if(onFocus && onClick != null && FlxG.mouse.justPressed)
				onClick();

			if(_needACheck) {
				_needACheck = false;
				if(!Controls.instance.controllerMode)
					setButtonVisibility(FlxG.mouse.overlaps(this));
			}
			#end
	}

	function set_onFocus(newValue:Bool)
	{
		var lastFocus:Bool = onFocus;
		onFocus = newValue;
		if(onFocus != lastFocus && enabled) setButtonVisibility(onFocus);
		return newValue;
	}

	function set_enabled(newValue:Bool)
	{
		enabled = newValue;
		setButtonVisibility(false);
		alpha = enabled ? 1 : 0.4;

		_needACheck = enabled;
		return newValue;
	}

	 public function setButtonVisibility(focusVal:Bool)
	{
		alpha = 1;
		bg.color = FlxColor.BLACK;
		bg.alpha = focusVal ? 1 : 0.6;

		var focusAlpha = focusVal ? 1 : 0.6;
		if(buttonText != null)
		{
			buttonText.alpha = focusAlpha;
		}

		if(!enabled) alpha = 0.4;
		if(focusChangeCallback != null) focusChangeCallback(focusVal);
	}
	public function centerOnBg(txt:FlxText)
		{
			txt.x = bg.width/2 - txt.width/2;
			txt.y = bg.height/2 - txt.height/2 + 5;
		}
}