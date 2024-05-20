package states;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;
import sys.io.File;
import lime.app.Application;
import flixel.tweens.FlxTween;
import flixel.math.FlxRandom;
import openfl.filters.ShaderFilter;
import haxe.ds.Map;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.*;
import flixel.util.FlxTimer;
import flash.system.System;
import flixel.sound.FlxSound;

using StringTools;

class TerminalState extends MusicBeatState
{
	// dont just yoink this code and use it in your own mod. this includes you, psych engine porters.
	// if you ingore this message and use it anyway, atleast give credit.
	public var bg:FlxSprite;
	public var textBG:FlxSprite;
	public var displayText:FlxText;
	public var displayTextGroup:FlxTypedGroup<FlxText>;
	public var onEnter:(String, Array<String>) -> Bool;
	public var inputBG:FlxSprite;
	public var input:InputText;

	public var typedText:String = "";
	public var previousText:String = CommandHelper.helloConsoleString;
	public var typeSound:FlxSound;

	public var commands:Array<String> = [
		'help',
		'getHistory',
		'clearHistory'
		];

	public var helpText:Array<String> = [
	'Show This Text.',
	'Get History Of This Terminal',
	'Clear History Of This Terminal'
	];

	public var history:History;

	override public function create():Void
	{
		Main.fpsVar.visible = false;
		PlayState.isStoryMode = false;
		FlxG.mouse.visible = true;
		FlxG.mouse.useSystemCursor = true;

		history = new History();

		typedText += "                          " + previousText + "\n";

		displayTextGroup = new FlxTypedGroup<FlxText>();
		add(displayTextGroup);

		bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.screenCenter();
		bg.scrollFactor.set();
		add(bg);

		textBG = FlxSpriteUtil.drawRoundRect(new FlxSprite().makeGraphic(FlxG.width - 100, FlxG.height, FlxColor.TRANSPARENT), 0, 0, FlxG.width - 100, FlxG.height, 55, 55, 0xFF000000);
		textBG.screenCenter();
		textBG.scrollFactor.set();
		textBG.y -= 100;
		textBG.alpha = 0.6;
		add(textBG);

		displayText = new FlxText(50, 600, textBG.width - 10, "", 24);
		displayText.setFormat("VCR OSD Mono", 16);
		displayText.size = 20;
		displayText.antialiasing = false;
		add(displayText);

		typeSound = FlxG.sound.load(Paths.sound('hitsound'), 0.6);
		FlxG.sound.playMusic(Paths.music('tea-time'), 0.7);
		ClientPrefs.toggleVolumeKeys(false);

		inputBG = FlxSpriteUtil.drawRoundRect(new FlxSprite().makeGraphic(FlxG.width - 100, 25, FlxColor.TRANSPARENT), 0, 0, FlxG.width - 100, 25, 25, 25, FlxColor.BLACK);
		inputBG.scrollFactor.set();
		inputBG.alpha = 0.6;
		inputBG.x = 50;
		inputBG.y = 680;
		add(inputBG);

		input = new InputText(inputBG.x + 10, inputBG.y, textBG.width - 30, text -> {
			history.addCommand(text);
			addText(text);
			switch(text)
			{
				case "help":
				for(i in 0...helpText.length)
				addText(commands[i] + " - " + helpText[i]);

				case "getHistory":
				var hist:String = "";
				for(i in 0...history.commands.length)
				{
					hist += '\n' + history.commands[i];
				}
				addText("\n" + hist);
				case "clearHistory":
				history.clear();
				addText("\n" + "History Cleared!");
				case "clear":
				typedText = "                          " + previousText + "\n";
			}
			input.text = "";
			displayText.y -= 20 * input.fieldHeight;
		});
		
		input.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(input);

		super.create();
	}

	function addText(text:String)
	{
		typedText += "\n" + text;
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		AppUtil.setAppData(AppController.appName, AppController.altEngineVersion + AppController.stage, input.text);

		if(displayText.fieldHeight > 600)
		{
		displayText.fieldHeight = 600;
		}

		displayText.text = typedText;

		var keyJustPressed:FlxKey = cast(FlxG.keys.firstJustPressed(), FlxKey);
		switch(keyJustPressed.toString().toLowerCase())
		{
			case 'up':
			if (!history.isEmpty)
			{
				setText(history.getPreviousCommand());
				input.hasFocus = true;
			}
			else
			{
				input.hasFocus = false;
			}
			case 'down':
			if (!history.isEmpty)
			{
				setText(history.getNextCommand());
				input.hasFocus = true;
			}
			else
			{
				input.hasFocus = false;
			}
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			Main.fpsVar.visible = ClientPrefs.data.showFPS;
			FlxG.mouse.visible = false;
			FlxG.mouse.useSystemCursor = false;
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
			FlxG.switchState(new MainMenuState());
		}
	}
	function setText(text:String)
		{
			input.text = text;
			// Set caret to the end of the command
		}
}

class History
{
	static inline var MAX_LENGTH:Int = 50;

	public var commands:Array<String>;

	public var isEmpty(get, never):Bool;

	var index:Int = 0;

	public function new()
	{
	#if FLX_SAVE
		if (FlxG.save.isBound)
		{
			if (FlxG.save.data.history != null)
			{
				commands = FlxG.save.data.history;
				index = commands.length;
			}
			else
			{
				commands = [];
				FlxG.save.data.history = commands;
			}
		}
		else
		{
			commands = [];
		}
		#else
		commands = [];
		#end
	}
	public function getPreviousCommand():String
	{
		if (index > 0)
			index--;
		return commands[index];
	}

	public function getNextCommand():String
	{
		if (index < commands.length)
			index++;
		return (commands[index] != null) ? commands[index] : "";
	}

	public function addCommand(command:String)
		{
			// Only save new commands
			if (isEmpty || getPreviousCommand() != command)
			{
				commands.push(command);
				
				#if FLX_SAVE
				if (FlxG.save.isBound)
					FlxG.save.flush();
				#end
	
				if (commands.length > MAX_LENGTH)
					commands.shift();
			}
	
			index = commands.length;
		}
	
		public function clear()
		{
			commands.splice(0, commands.length);
			
			#if FLX_SAVE
			FlxG.save.flush();
			#end
		}
		function get_isEmpty():Bool
		{
			return commands.length == 0;
		}
}