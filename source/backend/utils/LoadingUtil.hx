package backend.utils;

import flixel.FlxG;
using StringTools;

class LoadingUtil
{
    public static function loading()
    {
        pushLua();
        enableMod();
        loadFlxKeys();
        setup();
    }
    public static function pushLua() 
    {
    #if LUA_ALLOWED
	Mods.pushGlobalMods();
	#end
    }

    public static function enableMod()
    {
        Mods.loadTopMod();
    }
    public static function loadFlxKeys()
    {

    #if android
	FlxG.android.preventDefaultKeys = [BACK];
    #end
    FlxG.fixedTimestep = false;
	FlxG.game.focusLostFramerate = 60;
	FlxG.keys.preventDefaultKeys = [TAB];
    }

    public static function setup() {
	FlxG.save.bind('funkin', CoolUtil.getSavePath());
	EnginePreferences.loadPrefs();
    Highscore.load();
    }
}