package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Gameplay Settings';
		rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Controller Mode',
			'Check this if you want to play with\na controller instead of using your keyboard.',
			'Проверьте это, если вы хотите играть с контроллером вместо клавиатуры',
			'controllerMode',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Combo Stacking',
			'if checked, ratings and numbers sprites will be stacking, and memory will be much loading.',
			'Если флажок установлен, спрайты рейтингов и цифр будут группироваться, тем временем нагружать очень сильно вашу память.',
			'stacking',
			'bool',
			true);
		addOption(option);

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Downscroll', //Name
			'If checked, notes go Down instead of Up, simple enough.', //Description
			'Если флажок установлен, стрелки идут вниз, а не вверх.',
			'downScroll', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Middlescroll',
			'If checked, your notes get centered.',
			'Если флажок установлен, ваши стрелки будут выровнены по центру.',
			'middleScroll',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Opponent Notes',
			'If unchecked, opponent notes get hidden.',
			'Если флажок не установлен, стрелки оппонента будут скрыты.',
			'opponentStrums',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Ghost Tapping',
			"If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit.",
			'Если флажок установлен, вы не будете получать промахи при нажатии на не появившую стрелку.',
			'ghostTapping',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Light Strums',
			"If checked, your notes going to be lighting. [WITH BOTPLAY OR WHEN OPPONENT GOING TO BE ON NOTES!].",
            'Если флажок установлен, ваши стрелки и стрелки противника будут подсвечиваться. [ПРИ ИГРЕ БОТОМ ИЛИ КОГДА ОППОНЕНТ БУДЕТ НАЖИМАТЬ НА СТРЕЛКИ!].',
			'lightStrums',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Disable Reset Button',
			"If checked, pressing Reset won't do anything.",
			'Если флажок установлен, нажатие на кнопку "Перезапуск" не будет работать.',
			'noReset',
			'bool',
			false);
		addOption(option);

        var option:Option = new Option('Icon Bop: ',
			"What should be the icon bop?",
			'Каким должен быть бит иконки?',
			'iconBop',
			'string',
			'Psych',
			['Alt', 'Psych']);
		addOption(option);

		var option:Option = new Option('Beat Type: ',
		"What should be a zoom?",
		'Каким должен быть режим масштаба?',
		'beatType',
		'string',
		'1/16',
		['1/2', '1/4', '1/16']);
	addOption(option);
	var option:Option = new Option('Camera Mode: ',
	"What should be the camera mode?",
	'Каким должен быть режим камеры?',
	'beatMode',
	'string',
	'Both camera',
	['Both camera', 'HUD camera', 'Game camera']);
addOption(option);
var option:Option = new Option('Camera Mult:',
			'How much much or slow should be a cameras?',
			'Насколько сильно или слабо камеры будут масштабироваться?',
			'camSpeed',
			'float',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.1;
		option.maxValue = 5;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		var option:Option = new Option('Judgement Counter Type: ',
		"What should be the judgement counter?",
		'Каким должен быть счётчик суждений?',
		'judgementCounterType',
		'string',
		'Counter',
		['Counter', 'Percent']);
	addOption(option);

	var option:Option = new Option('Judgement Counter ',
			"If checked, Judgement counter should be visible.",
			"Если флажок установлен, счетчик суждений должен быть видимым?",
			'judgementCounter',
			'bool',
			true);
		addOption(option);
		var option:Option = new Option('Results Screen ',
			"If checked, Results should be visible.",
			"Если флажок установлен, результаты должен быть видны.",
			'results',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Hitsound Volume',
			'Funny notes does \"Tick!\" when you hit them."',
			'Весёлые стрелки делают \"Тик!\" когда ты попадаешь по ним.',
			'hitsoundVolume',
			'percent',
			0);
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

		var option:Option = new Option('Rating Offset',
			'Changes how late/early you have to hit for a "Sick!"\nHigher values mean you have to hit later.',
			'Изменяет, насколько поздно/рано вы нажали на стрелку. Более высокие значения означают, что вы должны нажать позже.',
			'ratingOffset',
			'int',
			0);
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		addOption(option);

		var option:Option = new Option('Sick! Hit Window',
			'Changes the amount of time you have\nfor hitting a "Sick!" in milliseconds.',
			'Изменяет количество времени, которое у вас есть для нажатия на "Больной!" в миллисекундах.',
			'sickWindow',
			'int',
			45);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 15;
		option.maxValue = 45;
		addOption(option);

		var option:Option = new Option('Good Hit Window',
			'Changes the amount of time you have\nfor hitting a "Good" in milliseconds.',
			'Изменяет количество времени, которое у вас есть для нажатия на "Хорош!" в миллисекундах.',
			'goodWindow',
			'int',
			90);
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 15;
		option.maxValue = 90;
		addOption(option);

		var option:Option = new Option('Bad Hit Window',
			'Changes the amount of time you have\nfor hitting a "Bad" in milliseconds.',
			'Изменяет количество времени, которое у вас есть для нажатия на "Плох!" в миллисекундах.',
			'badWindow',
			'int',
			135);
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 15;
		option.maxValue = 135;
		addOption(option);

		var option:Option = new Option('Safe Frames',
			'Changes how many frames you have for\nhitting a note earlier or late.',
			'Изменяет количество кадров, которые у вас есть для более раннего или позднего попадания на ноты.',
			'safeFrames',
			'float',
			10);
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);

		super();
	}

	function onChangeHitsoundVolume()
	{
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
	}
}