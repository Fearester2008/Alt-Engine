package hscript;

import FunkinLua;
import animateatlas.AtlasFrameMaker;
import flixel.FlxG;
import flixel.addons.effects.FlxTrail;
import flixel.input.keyboard.FlxKey;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets;
import flixel.math.FlxMath;
import flixel.util.FlxSave;
import flixel.addons.transition.FlxTransitionableState;
import flixel.system.FlxAssets.FlxShader;

#if (!flash && sys)
import flixel.addons.display.FlxRuntimeShader;
#end
import lime.app.Application;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

import Type.ValueType;
import Controls;
import DialogueBoxPsych;

#if desktop
import Discord;
#end

#if hscript
import hscript.Parser;
import hscript.Interp;
import hscript.Expr;
#end

#if hscript
class HScript
{
	public static var parser:Parser = new Parser();
	public var interp:Interp;

	public var variables(get, never):Map<String, Dynamic>;

	public function get_variables()
	{
		return interp.variables;
	}

	public function new()
	{
		interp = new Interp();
		interp.variables.set('FlxG', FlxG);
		interp.variables.set('FlxSprite', FlxSprite);
		interp.variables.set('FlxCamera', FlxCamera);
		interp.variables.set('FlxTimer', FlxTimer);
		interp.variables.set('FlxTween', FlxTween);
		interp.variables.set('FlxEase', FlxEase);
		interp.variables.set('PlayState', PlayState);
		interp.variables.set('game', PlayState.instance);
		interp.variables.set('Paths', Paths);
		interp.variables.set('Conductor', Conductor);
		interp.variables.set('ClientPrefs', ClientPrefs);
		interp.variables.set('Character', Character);
		interp.variables.set('Alphabet', Alphabet);
		interp.variables.set('Application', Application);
		interp.variables.set('CustomSubState', CustomSubstate);
        interp.variables.set('CustomState', CustomState);
		#if (!flash && sys)
		interp.variables.set('FlxRuntimeShader', FlxRuntimeShader);
		#end
		interp.variables.set('ShaderFilter', openfl.filters.ShaderFilter);
		interp.variables.set('StringTools', StringTools);

		interp.variables.set('setVar', function(name:String, value:Dynamic)
		{
			PlayState.instance.variables.set(name, value);
		});
		interp.variables.set('getVar', function(name:String)
		{
			var result:Dynamic = null;
			if(PlayState.instance.variables.exists(name)) result = PlayState.instance.variables.get(name);
			return result;
		});
		interp.variables.set('removeVar', function(name:String)
		{
			if(PlayState.instance.variables.exists(name))
			{
				PlayState.instance.variables.remove(name);
				return true;
			}
			return false;
		});
        interp.variables.set("import", function(lib:Dynamic, ?as:Null<Dynamic>) // Does this even work?
		{
			if (lib != null && Type.resolveClass(lib) != null)
			{
				interp.variables.set(as != null ? as : lib, Type.resolveClass(lib));
			}
			if (lib == null && Type.resolveClass(lib) == null)
			{
				Application.current.window.alert(lib + " not imported, please import it lib: \n" + lib, "Import Lib Error!!!");
			}
            
		});
	}

	public function execute(codeToRun:String):Dynamic
	{
		@:privateAccess
		HScript.parser.line = 1;
		HScript.parser.allowTypes = true;
		return interp.execute(HScript.parser.parseString(codeToRun));
	}
}
#end
