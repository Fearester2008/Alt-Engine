package objects;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var sprTrackerIcon:FlxSprite;
	public var hasWinningIcon:Bool = true;

	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false, ?allowGPU:Bool = true)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char, allowGPU);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);

		if (sprTrackerIcon != null)
			setPosition(sprTrackerIcon.x + 175, sprTracker.y - 30);

		hasWinningIcon = EnginePreferences.data.winIcon;
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String, ?allowGPU:Bool = true) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			
			var graphic = Paths.image(name, allowGPU);
			loadGraphic(graphic);
			var width2 = width;
			if (width == 450 && hasWinningIcon) {
				loadGraphic(graphic, true, Math.floor(width / 3), Math.floor(height)); //Then load it fr // winning icons go br
				iconOffsets[0] = (width - 150) / 3;
				iconOffsets[1] = (width - 150) / 3;
				iconOffsets[2] = (width - 150) / 3;
			} else {
				loadGraphic(graphic, true, Math.floor(width / 2), Math.floor(height)); //Then load it fr // winning icons go br
				iconOffsets[0] = (width - 150) / 2;
				iconOffsets[1] = (width - 150) / 2;
			}
			
			updateHitbox();
			if (width2 == 450 && hasWinningIcon) {
				animation.add(char, [0, 1, 2], 0, false, isPlayer);
			} else {
				animation.add(char, [0, 1], 0, false, isPlayer);
			}
			animation.play(char);
			
			this.char = char;

			if(char.endsWith('-pixel'))
				antialiasing = false;
			else
				antialiasing = EnginePreferences.data.antialiasing;
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String {
		return char;
	}

	override function destroy()
	{
		//sprTracker.kill();
		super.destroy();
	}
	public function originOffset(x:Float, y:Float) {
		origin.set(x, y);
	}
}
