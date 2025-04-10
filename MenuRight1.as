

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
	
	public function MenuRight1()
	{
		super();
	}

	public function updateFields()
	{
		var sceneName = SexLabAPI.GetActiveSceneName();
		var authorName = SexLabAPI.GetActiveSceneAuthor();
		var packageName = SexLabAPI.GetActiveSceneOrigin();
		var tagStr = SexLabAPI.GetActiveSceneTags();
		var annotationStr = SexLabAPI.GetActiveAnnotations();
		if (sceneName == undefined) sceneName = "None";
		if (authorName == undefined) authorName = "None";
		if (packageName == undefined) packageName = "None";
		if (tagStr == undefined) tagStr = "";
		if (annotationStr == undefined) annotationStr = "";

		name.init({ name: "$SSL_Name", align: "left", extra: sceneName });
		author.init({ name: "$SSL_Author", align: "left", extra: authorName });
		originPackage.init({ name: "$SSL_Package", align: "left", extra: packageName });
		tags.init({ name: "$SSL_Tags", content: tagStr });
		annotations.init({ name: "$SSL_CustomTags", content: annotationStr });
	}

	public function setDefault()
	{
		annotations.setSelected(true);
		annotations.setFocus();
	}

	public function resetSelection()
	{
		annotations.setSelected(false);
		SexLabAPI.SetActiveSceneAnnotations(annotations.getText());
		annotations.endInput();
	}
	
	public function handleInputEx(keyStr: String, modes: Boolean, reset: Boolean): Boolean
	{
		if (keyStr == KeyType.END)
			return false;
		return true;
	}

}