class MenuEntryRow extends MovieClip
{
	/* STAGE ELEMENTS */
	public var background: MovieClip;
	public var name: TextField;
	public var extra: TextField;

	/* PRIVATE VARIABLES */

	/* INITIALIZATION */
	public function MenuEntryRow()
	{
	}

	public function initialize(initObj)
	{
		name.text = initObj.name;
		extra.text = initObj.extra;
	}

}