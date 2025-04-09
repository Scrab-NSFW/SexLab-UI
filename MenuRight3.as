import skyui.components.list.ScrollingList;

class MenuRight3 extends skyui.components.list.ScrollingList
{
	/* STAGE ELEMENTS */

	/* PRIVATE VARIABLES */

	/* INITIALIZATION */
	public function MenuRight3() {}

	public function setDefault()
	{
		selectDefaultIndex(true);
	}

	public function resetSelection()
	{
		doSetSelectedIndex(-1, SELECT_KEYBOARD);
	}

	public function handleInputEx(keyStr: String, modes: Boolean, reset: Boolean): Boolean
	{
		switch (keyStr) {
		case KeyType.PAGE_UP:
		case KeyType.UP:
			moveSelectionUp(keyStr == KeyType.PAGE_UP);
			return true;
		case KeyType.PAGE_DOWN:
		case KeyType.DOWN:
			moveSelectionDown(keyStr == KeyType.PAGE_DOWN);
			return true;
		case KeyType.SELECT:
			onItemPress();
			return true;
		default:
			return false;
		}
	}

	public function updateFields(): Void
	{
		// TODO: lookup scene names in backend
		var scenes = [
			{ name: "$SSL_Scene1", extra: "" },
			{ name: "$SSL_Scene2", extra: "" },
			{ name: "$SSL_Scene3", extra: "" },
			{ name: "$SSL_Scene4", extra: "" },
			{ name: "$SSL_Scene5", extra: "" },
			{ name: "$SSL_Scene6", extra: "" },
			{ name: "$SSL_Scene7", extra: "" },
			{ name: "$SSL_Scene8", extra: "" }
		];

		entryList.clearList();
		for (var i = 0; i < scenes.length; i++) {
			var scene = scenes[i];
			if (scene == undefined) {
				continue;
			}
			entryList.push(scene);
		}
		InvalidateData();
	}

}