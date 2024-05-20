package;

import debug.FPSCounter;
import flixel.graphics.FlxGraphic;
import flixel.FlxGame;
import flixel.FlxState;
import haxe.io.Path;
import openfl.Assets;
import openfl.system.System;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import lime.system.System as LimeSystem;
import lime.app.Application;
import states.TitleState;
import openfl.events.KeyboardEvent;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

#if hl
import hl.Api;
#end
#if linux
import lime.graphics.Image;

@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end
class Main extends Sprite
{
	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: TitleState, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};
	
	public static var fpsVar:FPSCounter;

	#if mobile
	public static final platform:String = "Phones";
	#else
	public static final platform:String = "PCs";
	#end

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
		#if cpp
        cpp.NativeGc.enable(true);
        cpp.NativeGc.run(true);
        #end
	}

	public function new()
	{
		super();
		#if (android && EXTERNAL || MEDIA)
		SUtil.doPermissionsShit();
		#end
		CrashHandler.init();

		#if windows
		@:functionCode("
		#include <windows.h>
		#include <winuser.h>
		setProcessDPIAware() // allows for more crisp visuals
		DisableProcessWindowsGhosting() // lets you move the window and such if it's not responding
		")
		#end

		#if cpp
		@:privateAccess
		untyped __global__.__hxcpp_set_critical_error_handler(SUtil.onError);
		#elseif hl
		@:privateAccess
		Api.setErrorHandler(SUtil.onError);
		#end

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		var resolution = ClientPrefs.data.resolution.split('x');

		stageWidth = Std.parseInt(resolution[0]);
		stageHeight = Std.parseInt(resolution[1]);
		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}

		#if mobile
		Sys.setCwd(#if (android)Path.addTrailingSlash(#end SUtil.getStorageDirectory()#if (android))#end);
		#end
	
		#if LUA_ALLOWED llua.Lua.set_callbacks_function(cpp.Callable.fromStaticFunction(psychlua.CallbackHandler.call)); #end
		Controls.instance = new Controls();
		ClientPrefs.loadDefaultKeys();

		#if ACHIEVEMENTS_ALLOWED Achievements.load(); #end

		addChild(new FlxGame(#if (openfl >= "9.2.0") 1280, 720 #else game.width, game.height #end, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate, game.skipSplash, game.startFullscreen));

		Achievements.load();

		fpsVar = new FPSCounter();
		FlxG.game.addChild(fpsVar);

		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		if(fpsVar != null) {
			fpsVar.visible = ClientPrefs.data.showFPS;
		}

		#if linux
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end

		#if desktop
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, toggleFullScreen);
		#if debug
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, setDebuggerKeys);
		#end
		#end

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end

		#if DISCORD_ALLOWED
		DiscordClient.prepare();
		#end

		#if mobile
		LimeSystem.allowScreenTimeout = ClientPrefs.data.screensaver;
		#end

		// shader coords fix
		FlxG.signals.gameResized.add(function (w, h) {

		final scale:Float = Math.min(FlxG.stage.stageWidth / FlxG.width, FlxG.stage.stageHeight / FlxG.height);

		if (fpsVar != null)
			fpsVar.scaleX = fpsVar.scaleY = (scale > 1 ? scale : 1);

		     if (FlxG.cameras != null) {
			   for (cam in FlxG.cameras.list) {
				if (cam != null && cam.filters != null)
					resetSpriteCache(cam.flashSprite);
			   }
			}

			if (FlxG.game != null)
			resetSpriteCache(FlxG.game);
		});
	}

	static function resetSpriteCache(sprite:Sprite):Void {
		@:privateAccess {
		        sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}

	function toggleFullScreen(event:KeyboardEvent){
		if(Controls.instance.justReleased('fullscreen'))
			FlxG.fullscreen = !FlxG.fullscreen;
	}
	#if debug
	function setDebuggerKeys(key:KeyboardEvent) {
		FlxG.debugger.toggleKeys = ClientPrefs.keyBinds.get('debugger').copy();
	}
	#end
}
