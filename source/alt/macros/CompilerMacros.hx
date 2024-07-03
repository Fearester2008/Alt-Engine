package alt.macros;
import backend.utils.AppController;

//thanks for slushi_ds for this code
class CompilerMacros
{
    #if macro
    static var ENGINE_VERSION = AppController.altEngineVersion + AppController.stage;

    public static function init() {
        Sys.println('\n---- \033[96mAlt Engine\033[0m version: \x1b[38;5;236m[\033[0m\033[96m${ENGINE_VERSION}\033[0m\x1b[38;5;236m]\033[0m ----');
        Sys.println('Trying to initialize the compilation...');
        Sys.println('Date on start compilation: \033[32m${Date.now().toString()}\033[0m');
    }
    #end
}
