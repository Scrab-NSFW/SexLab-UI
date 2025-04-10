

class Settings extends MovieClip
{
	public static var MENU_ENTRY_TEXT: String = "MenuBarEntry";
	public static var MENU_SEPARATOR: String = "MenuSeparator";

	/* STAGE ELEMENTS */
	public var background: MovieClip;
	public var menuBar: MovieClip;
	private var dropdownMenu: MovieClip;

	/* PRIVATE VARIABLES */
	private var menuSets: Array;
	private var activeIdx: Number;

	/* INITIALIZATION */
	public function Settings()
	{
		activeIdx = -1;
		dropdownMenu._visible = false;
	}

	public function onLoad()
	{
		menuSets = menuBar.textArr;
		dropdownMenu._x = menuBar._x;
		dropdownMenu._y = menuBar._y + (menuBar.background.background._height / 2) + 5;
	}

	/* GFX */
	public function handleInputEx(keyStr: String, modes: Boolean, reset: Boolean): Boolean
	{
		if (dropdownMenu._visible && dropdownMenu.handleInputEx(keyStr, modes, reset)) {
			return true;
		}
		switch (keyStr) {
		case KeyType.EXTRA1:
			slide(activeIdx <= 1 ? 0 : activeIdx - 1);
			return true;
		case KeyType.EXTRA2:
			slide(
				activeIdx == -1 ? menuSets.length - 1 : 
				activeIdx == menuSets.length - 1 ? activeIdx : activeIdx + 1
			);
			return true;
		case KeyType.END:
			if (activeIdx > -1) {
				closeMenu();
				return true;
			}
			return false;
		default:
			return false;
		}
	}

	public function slide(newIdx): Void
	{
		if (newIdx == activeIdx) {
			return;
		}
		if (activeIdx > -1) {
			var previousMenu: TextField = menuSets[activeIdx];
			previousMenu.text = previousMenu.text.substr(1, previousMenu.text.length - 2);
		}
		if (newIdx == -1) {
			activeIdx = -1;
			return;
		}
		var activeMenu: TextField = menuSets[newIdx];
		activeMenu.text = "<" + activeMenu.text + ">";
		activeIdx = newIdx;
		dropdownMenu.setLayout(newIdx);
		dropdownMenu._visible = true;
	}

	public function closeMenu(): Void
	{
		dropdownMenu._visible = false;
		slide(-1);
	}

}