package options.format;

class NotesSettings extends Option
{
	public function new()
	{
		super();
        if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
		description = "Edit notes colors";
	}

	public override function press():Bool
	{
		//OptionsMenu.instance.selectedCatIndex = 4;
		//OptionsMenu.instance.switchCat(OptionsMenu.instance.options[4], false);

        if (OptionsMenu.isInPause)
			return false;

		OptionsMenu.openNotesState();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Edit Notes Colors";
	}
}

class AdjustOption extends Option
{
	public function new()
	{
		super();
        if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
		description = "Edit elements positions / beat offset";
	}

	public override function press():Bool
	{
		//OptionsMenu.instance.selectedCatIndex = 4;
		//OptionsMenu.instance.switchCat(OptionsMenu.instance.options[4], false);
        if (OptionsMenu.isInPause)
			return false;

		OptionsMenu.openAjustState();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Edit elements positions and beat offset";
	}
}