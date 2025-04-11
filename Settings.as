import com.greensock.TweenLite;
import com.greensock.TimelineLite;
import com.greensock.easing.*;

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
	private var backgroundY: Number;

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
		backgroundY = dropdownMenu.background._y;
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
		} else if (newIdx == -1) {
			// TweenLite.to(dropdownMenu.background, 0.2, { _y: -dropdownMenu.background._height, onComplete: function(dropdownMenu) {
			// 	dropdownMenu._visible = false;
			// }, onCompleteParams: [dropdownMenu] });
			dropdownMenu._visible = false;
		} else {
			var activeMenu = menuSets[newIdx];
			activeMenu.text = "<" + activeMenu.text + ">";
		}
		if (activeIdx > -1) {
			var previousMenu: TextField = menuSets[activeIdx];
			previousMenu.text = previousMenu.text.substr(1, previousMenu.text.length - 2);
			if (dropdownMenu.background._y == backgroundY) {	// skip if animating (layout will be set afterwards)
				dropdownMenu.setLayout(newIdx);
			}
		} else {
			dropdownMenu.background._y = -dropdownMenu.background._height;
			dropdownMenu.loadBackground(newIdx);
			TweenLite.to(dropdownMenu.background, 0.3, { _y: backgroundY, onComplete: function(self) {
				self.dropdownMenu.setLayout(self.activeIdx);
			}, onCompleteParams: [this] });
			dropdownMenu._visible = true;
		}
		activeIdx = newIdx;
	}

	public function closeMenu(): Void { slide(-1); }

}