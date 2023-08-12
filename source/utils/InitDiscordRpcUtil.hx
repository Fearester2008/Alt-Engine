package utils;

#if desktop
import Discord.DiscordClient;
#end
import lime.app.Application;

using StringTools;

class InitDiscordRpcUtil
{
    public static function initial(?init:Bool = false)
    {
        if(init)
        {
        if(!DiscordClient.isInitialized)
            {
                DiscordClient.initialize();
                Application.current.window.onClose.add(function()
                {
                    DiscordClient.shutdown();
                });
            }
        }
    }
    public static function sleeping(turn:Bool = false)
    {
        if (turn)
        {
            DiscordClient.shutdown();
        }
    }

}