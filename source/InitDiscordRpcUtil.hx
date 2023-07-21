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
        DiscordClient.start();
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