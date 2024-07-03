#if macro
package alt.macros;
import backend.utils.AppController;
import haxe.Timer;
using StringTools;

class CompilerMacros
{
    static var startTime = haxe.Timer.stamp();
    static var endTime = haxe.Timer.stamp();
    static var elapsedTime = endTime - startTime;
    static var ENGINE_VERSION = AppController.altEngineVersion + AppController.stage;
    public static function init() {
        if(AppController.stage == 'b' || AppController.stage == 'beta')
            Sys.println('This is Beta build. This version can contains bugs, unfinished stuffs...');
        else if(AppController.stage == 'a' || AppController.stage == 'alpha')
            Sys.println('This is Alpha build. This version on release stage...');
        else if(AppController.stage == 'h' || AppController.stage == 'hotfix')
            Sys.println('This is Hotfix build. This version for new stuffs that will be in next release...');
        else
            Sys.println('You use stable build. Enjoy:)');

        Sys.println('\n\n---- \033[96mAlt Engine\033[0m version: \x1b[38;5;236m[\033[0m\033[96m${ENGINE_VERSION}\033[0m\x1b[38;5;236m]\033[0m ----');
        Sys.println('Trying to initialize the compilation...');
        Sys.println('Date on start compilation: \033[32m${Date.now().toString()}\033[0m s');

        afterInit();
    }
    public static function afterInit()
    {
        Sys.println('Compile initialized in: \033[32m${elapsedTime}\033[0m');
    }
}
#end
