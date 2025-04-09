

class MenuRight1 extends MovieClip
{
	/* STAGE ELEMENTS */
	
	public var name: MovieClip;
	public var author: MovieClip;
	public var originPackage: MovieClip;
	public var tags: MovieClip;
	public var annotations: MovieClip;

	/* PRIVATE VARIABLES */

	/* INITIALIZATION */
	
	public function MenuRight1() {}

	public function updateFields()
	{
		name.init({ name: "$SSL_Name", extra: "", selected: false });
		author.init({ name: "$SSL_Author", extra: "", selected: false });
		originPackage.init({ name: "$SSL_Package", extra: "", selected: false });
		tags.init({ name: "$SSL_Tags", content: "TODO: lookup scene tags..." });
		annotations.init({ name: "$SSL_CustomTags", content: "TODO: lookup annotations...", selected: false });
	}

	public function setDefault()
	{
		annotations.setSelected(true);
		annotations.setFocus();
	}

	public function resetSelection()
	{
		annotations.setSelected(false);
		annotations.endInput();
	}
	
	public function handleInputEx(keyStr: String, modes: Boolean, reset: Boolean): Boolean
	{ 
		return true;
	}

}