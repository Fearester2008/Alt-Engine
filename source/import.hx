#if !macro
//Discord API
#if DISCORD_ALLOWED
import backend.Discord;
#end

//Psych
#if ACHIEVEMENTS_ALLOWED
import backend.Achievements;
#end
#if VIDEOS_ALLOWED
import backend.VideoManager;
import backend.VideoSpriteManager;
#end

//Mobile Controls
import mobile.objects.MobileControls;
import mobile.substates.MobileControlsSubState;
import mobile.flixel.FlxHitbox;
import mobile.flixel.FlxVirtualPad;
import mobile.flixel.FlxVirtualPadExtra;
import mobile.flixel.input.FlxMobileInputID;

//Android
#if android
import android.content.Context as AndroidContext;
import android.widget.Toast as AndroidToast;
import android.os.Environment as AndroidEnvironment;
import android.Permissions as AndroidPermissions;
import android.Settings as AndroidSettings;
import android.Tools as AndroidTools;
import android.os.BatteryManager as AndroidBatteryManager;
#end

#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end

import backend.Paths;
import backend.Controls;
import backend.CoolUtil;
import backend.MusicBeatState;
import backend.MusicBeatSubstate;
import backend.CustomFadeTransition;
import backend.ClientPrefs;
import backend.Conductor;
import backend.BaseStage;
import backend.Difficulty;
import backend.Mods;
import backend.SUtil;

import objects.Alphabet;
import objects.BGSprite;

import states.PlayState;
import states.LoadingState;

#if flxanimate
import flxanimate.*;
#end

//Flixel
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.util.FlxDestroyUtil;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxSpriteUtil;

using StringTools;

//backends
import backend.*;
import backend.utils.*;
import backend.ClientPrefs;

import options.*;

//states
import states.*;
import states.editors.*;

//lua
#if LUA_ALLOWED
import llua.Lua;
import llua.LuaL;
import llua.State;
import llua.Convert;
#end
import psychlua.CustomSubstate;

//file sys
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
import flash.media.Sound;
#end

//dialogue
import cutscenes.DialogueBoxPsych;
import cutscenes.DialogueBox;

//data
import backend.Song;

//objects
import states.stages.objects.*;
import objects.*;

//for all states/substates
import backend.MusicBeatState;
import backend.MusicBeatSubstate;

//for hscript
#if hscript
import hscript.Parser;
import hscript.Interp;
import hscript.Expr;
#end

//shaders
import shaders.*;

//swither
import substates.Prompt;

//transistion
import backend.Section;

import substates.*;
import flixel.*;
#end
