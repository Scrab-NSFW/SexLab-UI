class MenuEntryInput extends MovieClip
{
	/* STAGE ELEMENTS */
	public var background: MovieClip;
	public var name: TextField;
	public var inputField: TextField;

	/* PRIVATE VARIABLES */

	/* INITIALIZATION */
	public function MenuEntryInput()
	{
	}

	public function initialize(initObj)
	{
		name.text = initObj.name;
		inputField.text = initObj.inputText;
		inputField.type = "input";
		inputField.border = true;
		inputField.borderColor = 0x000000;
		inputField.background = true;
		inputField.backgroundColor = 0xFFFFFF;
		inputField.autoSize = true;
	}

}
