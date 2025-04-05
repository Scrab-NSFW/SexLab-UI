import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;

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
	}

	/* GFX */
	public function handleInputEx(keyStr: String, modes: Boolean, reset: Boolean): Boolean
	{
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
			if (dropdownMenu._visible) {
				dropdownMenu._visible = false;
				return true;
			}
			return false;
		default:
			return dropdownMenu.handleInputEx(keyStr, modes, reset);
		}
	}

	public function slide(newIdx): Void
	{
		if (newIdx == activeIdx) {
			return;
		}
		dropdownMenu._visible = true;
		var activeMenu: TextField = menuSets[newIdx];
		activeMenu.text = "<" + activeMenu.text + ">";
		if (activeIdx >= 0) {
			var previousMenu: TextField = menuSets[activeIdx];
			previousMenu.text = previousMenu.text.substr(1, previousMenu.text.length - 2);
		}
		activeIdx = newIdx;
		dropdownMenu.setLayout(activeIdx);
	}

}