package backend.utils;

import lime.app.Application;
import flixel.util.FlxColor;
import lime.graphics.Image;

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
        public static function setAppVersion(version:String, stage:String = '')
         {
            if (version == VersionStuff.altEngineVersion + VersionStuff.stage)
            {
                version = VersionStuff.altEngineVersion;
                stage = VersionStuff.stage;
            }
            else
            {
                var ver:String = VersionStuff.altEngineVersion;
                var stageBuild:String = VersionStuff.stage;
                ver = version;
                stageBuild = stage;
            }
            return;
         }
         public static function setAppIcon(path:String = 'mods/images/', icon:String = 'iconOG')
            {
                #if !android
                #if MODS_ALLOWED
                var iconPath:String = 'mods/images/';
                #else
                var iconPath:String = 'assets/images/';
                #end
                var iconImage:String = 'iconOG';
    
                if(iconImage == 'iconOG' || iconImage == null)
                {
                    iconImage = icon;
                }
    
                #if MODS_ALLOWED
                if(iconPath == 'mods/images/' || iconPath == null)
                    {
                        iconPath = path;
                    }
                #else
                if(iconPath == 'assets/images/' || iconPath == null)
                {
                    iconPath = path;
                }
                #end
    
                return Application.current.window.setIcon(Image.fromFile(path + icon + '.png'));
                #end
            }
}