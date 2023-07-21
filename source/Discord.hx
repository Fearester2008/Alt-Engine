package;

import lime.app.Application;
import Sys.sleep;
#if desktop
import discord_rpc.DiscordRpc;
#end
#if LUA_ALLOWED
import llua.Lua;
import llua.State;
#end

using StringTools;

class DiscordClient
{
	#if desktop
	public static var isInitialized:Bool = false;
	private static var _defaultID:String =  "1104335650603417670";
	public static var clientID(default, set):String = _defaultID;

	private static var _settings:Dynamic = {
		details: "In The Menus",
		state: null,
		largeImageKey: 'icon',
		largeImageText: "Psych Engine",
		smallImageKey: null,
		startTimestamp: null,
		endTimestamp: null
	};

	public function new()
	{
		trace("Discord Client starting...");
		DiscordRpc.start({
			clientID: clientID,
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		trace("Discord Client started.");

		var ID:String = clientID;
		while (ID == clientID)
		{
			DiscordRpc.process();
			sleep(2);
			//trace("Discord Client Update");
		}

		// DiscordRpc.shutdown();
	}
	public static function check() {
		if(!ClientPrefs.showDiscordActivity)
		{
			if(isInitialized) shutdown();
			isInitialized = false;
		}
		else
			{
				start();
			}
	}
	public static function start()
	{
			if(!isInitialized && ClientPrefs.showDiscordActivity)
				{
					initialize();
					Application.current.window.onClose.add(function() {
						shutdown();
					});
				}
	}
	public static function shutdown()
	{
		DiscordRpc.shutdown();
	}
	
	static function onReady()
	{
		DiscordRpc.presence(_settings);
	}

	private static function set_clientID(newID:String) {
		var change:Bool = (clientID != newID);
		clientID = newID;

		if(change && isInitialized)
		{
			shutdown();
			isInitialized = false;
			start();
			DiscordRpc.process();
		}
		return newID;
	}

	static function onError(_code:Int, _message:String)
	{
		trace('Error! $_code : $_message');
	}

	static function onDisconnected(_code:Int, _message:String)
	{
		trace('Disconnected! $_code : $_message');
	}

	public static function initialize()
	{
		var DiscordDaemon = sys.thread.Thread.create(() ->
		{
			new DiscordClient();
		});
		trace("Discord Client initialized");
		isInitialized = true;
	}

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey : String, ?hasStartTimestamp : Bool, ?endTimestamp: Float)
	{
		var startTimestamp:Float = if(hasStartTimestamp) Date.now().getTime() else 0;

		if (endTimestamp > 0)
		{
			endTimestamp = startTimestamp + endTimestamp;
		}

		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: 'icon',
			largeImageText: "Engine Version: " + VersionStuff.altEngineVersion,
			smallImageKey : smallImageKey,
			// Obtained times are in milliseconds so they are divided so Discord can use it
			startTimestamp : Std.int(startTimestamp / 1000),
            endTimestamp : Std.int(endTimestamp / 1000)
		});

		//trace('Discord RPC Updated. Arguments: $details, $state, $smallImageKey, $hasStartTimestamp, $endTimestamp');
	}

	public static function resetID() {
		clientID = _defaultID;
	}
	
	#if LUA_ALLOWED
	public static function addLuaCallbacks(lua:State) {
		Lua_helper.add_callback(lua, "changePresence", function(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float) {
			changePresence(details, state, smallImageKey, hasStartTimestamp, endTimestamp);
		});
	}
	#end
	#end
}
