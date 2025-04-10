

class ScrollingListInputEx extends skyui.components.list.ScrollingList
{
	public function ScrollingListInputEx()
    {
        super();
    }

    /* PUBLIC FUNCTIONS */

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

}