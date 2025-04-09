class MenuEntryOffset extends MovieClip
{
	/* STAGE ELEMENTS */
	public var background: MovieClip;
	public var name: TextField;
	public var value: TextField;
	public var selectIndicator: MovieClip;

	/* PRIVATE VARIABLES */

	/* INITIALIZATION */
	public function MenuEntryOffset()
	{
		selectIndicator._visible = false;
	}

	public function init(initObj)
	{
		name.text = initObj.name;
		selectIndicator._visible = initObj.selected;
		value.text = initObj.content;
		value.type = "input";
		value.border = true;
		value.borderColor = 0x000000;
		value.background = true;
		value.backgroundColor = 0xFFFFFF;
	}

}
