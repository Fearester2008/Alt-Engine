package backend.utils;

import lime.app.Application;
import flixel.util.FlxColor;
import lime.graphics.Image;

using StringTools;

class AppUtil {
    public static function getAppData():Void
    {
        var appName:String = AppController.appName;
        var appVersion:String = AppController.altEngineVersion + AppController.stage;
        Application.current.window.title = appName + " v: " + appVersion;
        return;
    }
    public static function setAppData(name:String, ?version:String, ?action:String)
        {
        if(EnginePreferences.data.customAppTitle)
        {
        Application.current.window.title = name + ' v: ' + version + " | " + action;
        }
        else 
        {
        Application.current.window.title = Application.current.meta.get('name');
        }
        return;
        }

        public static function setAppVersion(version:String, stage:String = '')
         {
            if (version == AppController.altEngineVersion + AppController.stage)
            {
                version = AppController.altEngineVersion;
                stage = AppController.stage;
            }
            else
            {
                var ver:String = AppController.altEngineVersion;
                var stageBuild:String = AppController.stage;
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