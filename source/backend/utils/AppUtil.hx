package backend.utils;

import lime.app.Application;
import flixel.util.FlxColor;

using StringTools;

class AppUtil {

    public static function getAppData():Void
    {
        var appName:String = VersionStuff.appName;
        var appVersion:String = VersionStuff.altEngineVersion + VersionStuff.stage;
        Application.current.window.title = appName + " v" + appVersion;
        return;
    }
    public static function setAppData(appDatasName:String, ?appDatasVersion:String, ?actionStr:String)
        {
        var appDataName:String = appDatasName;
        var appDataVersion:String = appDatasVersion;
        var actionApp:String = actionStr;

        Application.current.window.title = appDataName + ' v' + appDataVersion + " - " + actionApp;
        return;
        }
        public static function setAppTitle(title:String)
        {
           Application.current.window.title = title;
           return;

        }
        public static function setAppVersion(version:String)
         {
            Application.current.window.title = "FNF' Alt Engine v" + version;
            return;

         }
}