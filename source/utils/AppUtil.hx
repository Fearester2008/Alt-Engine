package utils;

import lime.app.Application;
import utils.*;
import flixel.util.FlxColor;

#if LUA_ALLOWED
import llua.Lua;
import llua.State;
#end

using StringTools;

class AppUtil {

    //for getAppData()
    public static var appName:String = "FNF' Alt Engine";
    public static var appVersion:String = VersionStuff.altEngineVersion;

    public static function getAppData():Void
    {
        Application.current.window.title = appName + " v" + appVersion;
        return;
    }

    public static var appDataName:String;
    public static var appDataVersion:String;
    public static var actionApp:String;

    private static function alert(title:String, description:String)
        {
            Application.current.window.alert(description, title);
        }
    public static function setAppData(appDatasName:String, ?appDatasVersion:String, ?actionStr:String)
        {
            appDataName = appDatasName;
            appDataVersion = appDatasVersion;
            actionApp = actionStr;

        Application.current.window.title = appDataName + ' v' + appDataVersion + " [" + actionApp + "]";
        return;
        }
        public static function setAppTitle(title:String)
        {
            appDataName = title;
           Application.current.window.title = title + appDataVersion + " [" + actionApp + "]";
           return;

        }
        public static function setAppVersion(version:String)
         {
            appDataVersion = version;

            Application.current.window.title = appDataName + version + " [" + actionApp + "]";
            return;

         }
         public static function setAppAction(action:String)
            {
               actionApp = action;
               
               Application.current.window.title = appDataName + appDataVersion + " [" + action + "]";
               return;
   
            }
    #if LUA_ALLOWED
        public static function addLuasCallbacks(state:State)
    {
        		Lua_helper.add_callback(lua, "getAppData", function() {
			getAppData();
		});
		Lua_helper.add_callback(lua, "setAppData", function(title:String, ?version:String, ?action:String) {
			setAppData(title, version, action);
		});
		Lua_helper.add_callback(lua, "setAppTitle", function(title:String) {
			setAppTitle(title);
		});
		Lua_helper.add_callback(lua, "setAppVersion", function(ver:String) {
		    setAppVersion(ver);
		});
    }
    #end
}
