class MenuEntryText extends MovieClip
{
	/* STAGE ELEMENTS */
	public var background: MovieClip;
	public var name: TextField;
	public var content: TextField;

	/* PRIVATE VARIABLES */

	/* INITIALIZATION */
	public function MenuEntryText()
	{
	}

	public function init(initObj)
	{
		name.text = initObj.name;
		content.text = initObj.content;
	}

}