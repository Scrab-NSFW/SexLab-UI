

class MenuRight1 extends MovieClip
{
	/* STAGE ELEMENTS */
	public var name: MovieClip;
	public var author: MovieClip;
	public var originPackage: MovieClip;
	public var tags: MovieClip;
	public var annotations: MovieClip;

	/* PRIVATE VARIABLES */
	private var _annotations: String;
	private var _activeScene: Object;

	/* INITIALIZATION */
	public function MenuRight1()
	{
		super();
	}

	/* PUBLIC FUNCTIONS */
	public function setActiveScene(scene: Object): Void
	{
		_activeScene = scene;
	}

	public function updateFields()
	{
		name.init({ name: "$SSL_Name", align: "left", extra: _activeScene.name });
		author.init({ name: "$SSL_Author", align: "left", extra: _activeScene.author });
		originPackage.init({ name: "$SSL_Package", align: "left", extra: _activeScene.package });
		tags.init({ name: "$SSL_Tags", content: _activeScene.tags });
		annotations.init({ name: "$SSL_CustomTags", content: _activeScene.annotations });
	}

	public function setDefault()
	{
		_annotations = annotations.getText();
		annotations.setSelected(true);
		annotations.setFocus();
	}

	public function resetSelection()
	{
		annotations.setSelected(false);
		annotations.endInput();
		if (_annotations != annotations.getText()) {
			Main.SetSceneAnnotations(annotations.getText());
		}
	}
	
	public function handleInputEx(keyStr: String, modes: Boolean, reset: Boolean): Boolean
	{
		if (keyStr == KeyType.END)
			return false;
		return true;
	}

}