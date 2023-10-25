package options.format;

class KeyBindingsOption extends Option
{
	public function new()
	{
		super();
                if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
		description = "Edit your keybindings";
	}

	public override function press():Bool
	{
		//OptionsMenu.instance.selectedCatIndex = 4;
		//OptionsMenu.instance.switchCat(OptionsMenu.instance.options[4], false);

        if (OptionsMenu.isInPause)
			return false;

		OptionsMenu.openControlsState();
        return true;
	}

	private override function updateDisplay():String
	{
		return "Edit Keybindings";
	}
}
