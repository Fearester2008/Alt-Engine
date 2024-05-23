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
        initControls();
        setup();
    }
    public static function pushLua() 
    {
    #if LUA_ALLOWED
    Paths.pushGlobalMods();
    #end
    }
    public static function enableMod()
    {
        WeekData.loadTheFirstEnabledMod();
    }
    public static function loadFlxKeys()
    {
    FlxG.game.focusLostFramerate = 60;
    FlxG.sound.muteKeys = TitleState.muteKeys;
    FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
    FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
    FlxG.keys.preventDefaultKeys = [TAB];
    }
    public static function initControls() {
        PlayerSettings.init();
    }
    public static function setup() {
    FlxG.save.bind('funkin' , CoolUtil.getSavePath());
    FlxG.mouse.visible = true;

    ClientPrefs.loadPrefs();
    Highscore.load();
    }
}