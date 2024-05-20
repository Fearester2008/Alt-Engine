package mobile.psychlua;

#if LUA_ALLOWED
import llua.*;
import llua.Lua;
import lime.ui.Haptic;
import psychlua.FunkinLua;
import backend.TouchFunctions;

class MobileFunctions {
    public static var mobileExtraInput(get, null):Dynamic;

    public static function implement(funk:FunkinLua) {
        funk.set("extraButtonPressed", function(button:String) {
			button = button.toLowerCase();
			if (mobileExtraInput != null){
				switch(button){
					case 'second':
						return mobileExtraInput.buttonExtra1.pressed;
					default:
						return mobileExtraInput.buttonExtra.pressed;
				}
			}
			return false;
		});

		funk.set("extraButtonJustPressed", function(button:String) {
			button = button.toLowerCase();
			if (mobileExtraInput != null){
				switch(button){
					case 'second':
						return mobileExtraInput.buttonExtra1.justPressed;
					default:
						return mobileExtraInput.buttonExtra.justPressed;
				}
			}
			return false;
		});

		funk.set("extraButtonJustReleased", function(button:String) {
			button = button.toLowerCase();
			if (mobileExtraInput != null){
				switch(button){
					case 'second':
						return mobileExtraInput.buttonExtra1.justReleased;
					default:
						return mobileExtraInput.buttonExtra.justReleased;
				}
			}
			return false;
		});

		funk.set("vibrate", function(duration:Null<Int>, ?period:Null<Int>){
		    if (period == null) period = 0;
		    if (duration == null) return FunkinLua.luaTrace('vibrate: No duration specified.');
		    return Haptic.vibrate(period, duration);
		});

        funk.set("makeVirtualPad", (DPadMode:String, ActionMode:String) -> {
          PlayState.instance.makeLuaVirtualPad(DPadMode, ActionMode);
        });

        funk.set("addVirtualPad", PlayState.instance.addLuaVirtualPad); // ig i can do it like this since it dosen't need any args ????

        funk.set("removeVirtualPad", PlayState.instance.removeLuaVirtualPad);

        funk.set("addVirtualPadCamera", (?DefaultDrawTarget:Bool=false) -> {
            if(PlayState.instance.luaVirtualPad == null){
    			FunkinLua.luaTrace('addVirtualPadCamera: Virtual Pad Does Not Exist!!');
                return;
            }
            PlayState.instance.addVirtualPadCamera(DefaultDrawTarget);
        });

        funk.set("virtualPadJustPressed", function(button:Dynamic):Bool {
            if(PlayState.instance.luaVirtualPad == null){
    			FunkinLua.luaTrace('virtualPadJustPressed: Virtual Pad Does Not Exist!!');
                return false;
            }
            return PlayState.instance.luaVirtualPadJustPressed(button);
        });

        funk.set("virtualPadPressed", function(button:Dynamic):Bool {
            if(PlayState.instance.luaVirtualPad == null){
    			FunkinLua.luaTrace('virtualPadPressed: Virtual Pad Does Not Exist!!');
                return false;
            }
            return PlayState.instance.luaVirtualPadPressed(button);
        });

        funk.set("virtualPadJustReleased", function(button:Dynamic):Bool {
            if(PlayState.instance.luaVirtualPad == null){
    			FunkinLua.luaTrace('virtualPadJustReleased: Virtual Pad Does Not Exist!!');
                return false;
            }
            return PlayState.instance.luaVirtualPadJustReleased(button);
        });

        funk.set("touchJustPressed", TouchFunctions.touchJustPressed);
        
        funk.set("touchPressed", TouchFunctions.touchPressed);

        funk.set("touchJustReleased", TouchFunctions.touchJustReleased);

        funk.set("touchPressedObject", function(object:String):Bool {
            var obj = PlayState.instance.getLuaObject(object);
            if(obj == null){
                FunkinLua.luaTrace('touchPressedObject: Object $object Does Not Exist!!');
                return false;
            }
            return TouchFunctions.touchOverlapObject(obj) && TouchFunctions.touchPressed;
        });

        funk.set("touchJustPressedObject", function(object:String):Bool {
            var obj = PlayState.instance.getLuaObject(object);
            if(obj == null){
                FunkinLua.luaTrace('touchJustPressedObject: Object $object Does Not Exist!!');
                return false;
            }
            return TouchFunctions.touchOverlapObject(obj) && TouchFunctions.touchJustPressed;
        });

        funk.set("touchJustReleasedObject", function(object:String):Bool {
            var obj = PlayState.instance.getLuaObject(object);
            if(obj == null){
                FunkinLua.luaTrace('touchJustPressedObject: Object $object Does Not Exist!!');
                return false;
            }
            return TouchFunctions.touchOverlapObject(obj) && TouchFunctions.touchJustReleased;
        });

        funk.set("touchOverlapsObject", function(object:String):Bool {
            var obj = PlayState.instance.getLuaObject(object);
            if(obj == null){
                FunkinLua.luaTrace('touchOverlapsObject: Object $object Does Not Exist!!');
                return false;
            }
            return TouchFunctions.touchOverlapObject(obj);
        });
    }

    private static function get_mobileExtraInput():Dynamic{
		switch (MobileControls.getMode()){
			case 0 | 1 | 2 | 3: // virtual pad
				return MusicBeatState.instance.mobileControls.virtualPadExtra;
			case 4: // hitbox
				return MusicBeatState.instance.mobileControls.hitbox;
			default: //keybaord
				return null;
		}
	}
}

#if android
class AndroidFunctions {
    public static function implement(funk:FunkinLua) {
        funk.set("backJustPressed", FlxG.android.justPressed.BACK);

        funk.set("backPressed", FlxG.android.pressed.BACK);

        funk.set("backJustReleased", FlxG.android.justReleased.BACK);

        funk.set("menuJustPressed", FlxG.android.justPressed.MENU);

        funk.set("menuPressed", FlxG.android.pressed.MENU);

        funk.set("menuJustReleased", FlxG.android.justReleased.MENU);
    }
}
#end
#end