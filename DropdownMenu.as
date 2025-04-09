import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import gfx.events.EventDispatcher;

import skyui.components.list.BasicEnumeration;

class DropdownMenu extends MovieClip
{
	public static var THREAD_IDX: Number = 0;
	public static var POSITION_IDX: Number = 1;

	public static var MENU_ENTRY: String = "MenuEntryRow";
	public static var MENU_ENTRY_INPUT: String = "MenuEntryInput";
	public static var MENU_ENTRY_TEXT: String = "MenuEntryText";
	public static var MENU_ENTRY_BLANK: String = "MenuEntryBlank";

	/* STAGE ELEMENTS */
	public var background: MovieClip;
	
	public var left1: MovieClip;
	public var left2: MovieClip;
	public var left3: MovieClip;
	public var right1: MovieClip;
	public var right2: MovieClip;
	public var right3: MovieClip;

	/* PRIVATE VARIABLES */
	private var layout: Array;
	private var activeLayoutIdx: Number;
	private var activeLeftIdx: Number;
	private var activeRight: MovieClip;

	private var leftCardX: Number;
	private var leftCardY: Number;
	private var rightCardX: Number;
	private var rightCardY: Number;

	/* INITIALIZATION */
	public function DropdownMenu()
	{
		activeLayoutIdx = -1;
		activeLeftIdx = -1;

		var tmp = background.dropdownDouble;
		left1._x = tmp.decoratorLeft._x;
		left1._y = background._y;

		right1._x = right2._x = right3._x = tmp.decoratorRight._x;
		right1._y = right2._y = right3._y = background._y;
		right1._visible = right2._visible = right3._visible = false;

		EventDispatcher.initialize(this);
		layout = [
			getLayoutThread()
		];
	}

	public function onLoad()
	{
		right3.listEnumeration = new BasicEnumeration(right3.entryList);
		right3.addEventListener("itemPress", this, "onItemPressAlternate");

		updateThreadLayout();
	}

	/* PUBLIC FUNCTIONS */
	public function setLayout(layoutIdx)
	{
		if (layoutIdx >= layout.length) {
			trace("DropdownMenu: setLayout: layoutIdx is out of bounds for index " + layoutIdx);
			return;
		}
		if (activeLayoutIdx > 0) {
			this["left" + (activeLayoutIdx + 1)]._visible = false;
		}
		this["left" + (layoutIdx + 1)]._visible = true;
		activeLayoutIdx = layoutIdx;
		setActiveIdx(0, true);
	}

	/* GFX */
	public function handleInputEx(keyStr: String, modes: Boolean, reset: Boolean): Boolean
	{
		if (activeRight) {
			switch (keyStr) {
			case KeyType.EXTRA1:
			case KeyType.EXTRA2:
				activeRight.handleInputEx(keyStr, modes, reset);
				return true;
			case KeyType.LEFT:
			case KeyType.END:
				if (!activeRight.handleInputEx(keyStr, modes, reset))
					focusLeft();
				return true;
			default:
				return activeRight.handleInputEx(keyStr, modes, reset);
			}
		}
		var activeLayout = layout[activeLayoutIdx];
		var maxIdx = activeLayout.length - 1;
		switch (keyStr) {
		case KeyType.UP:
			setActiveIdx(activeLeftIdx <= 0 ? maxIdx : activeLeftIdx - 1, true);
			return true;
		case KeyType.DOWN:
			setActiveIdx(activeLeftIdx == -1 ? 0 : activeLeftIdx == maxIdx ? 0 : activeLeftIdx + 1, true);
			return true;
		case KeyType.LEFT:
			if (!activeRight) {
				return true;
			}
			focusLeft();
			return true;
		case KeyType.PAGE_DOWN:
			setActiveIdx(maxIdx, true);
			return true;
		case KeyType.PAGE_UP:
			setActiveIdx(0, true);
			return true;
		case KeyType.RIGHT:
			if (activeRight) {
				return true;
			}
			// fallthrough
		case KeyType.SELECT:
			if (!activeRight) {
				activeRight = this[activeLayout[activeLeftIdx].right];
				if (activeRight == undefined) {
					trace("DropdownMenu: handleInputEx: activeRight is undefined for index " + activeLeftIdx);
					return false;
				}
				this["left" + (activeLayoutIdx + 1)]._alpha = 30;
				activeRight.setDefault();
			} else {
				// TODO: handle select action for the current row
			}
			break;
		default:
			return false;
		}
	}

	private function setActiveIdx(newIdx, left)
	{
		if (newIdx == activeLeftIdx) {
			return;
		}
		var referenceArr = left ? layout[activeLayoutIdx] : layout[activeLayoutIdx].right;
		if (newIdx >= referenceArr.length) {
			trace("DropdownMenu: setActiveIdx: newIdx is out of bounds for index " + newIdx);
			return;
		}
		var newOption = referenceArr[newIdx];
		if (newOption == undefined) {
			trace("DropdownMenu: setActiveIdx: newOption is undefined for index " + newIdx);
			return;
		}
		var leftCard = this["left" + (activeLayoutIdx + 1)];
		if (activeLeftIdx > -1) {
			var oldOption = referenceArr[activeLeftIdx];
			leftCard[oldOption.name].setSelected(false);
			if (oldOption.right != undefined) {
				this[oldOption.right]._visible = false;
			}
		}
		leftCard[newOption.name].setSelected(true);
		if (newOption.right != undefined) {
			this[newOption.right]._visible = true;
			background.gotoAndStop("double");
		} else {
			this[newOption.right]._visible = false;
			background.gotoAndStop("single");
		}
		activeLeftIdx = newIdx;
	}

	public function focusLeft()
	{
		activeRight.resetSelection();
		activeRight = undefined;
		this["left" + (activeLayoutIdx + 1)]._alpha = 100;
	}

	/* PRIVATE FUNCTIONS */

	// @mixin by gfx.events.EventDispatcher
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	public var hasEventListener:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var removeAllEventListeners:Function;
	public var cleanUpEvents:Function;

	public function onItemPressAlternate(eventObj)
	{
		trace("DropdownMenu: onItemPressAlternate: eventObj is " + eventObj.entry.name);
	}

	/* LAYOUT */

	private function getTextInit(name, extra, selected)
	{
		return { name: name, extra: extra ? extra : "", selected: selected ? selected : false };
	}

	private function getInputInit(name, content, selected)
	{
		return { name: name, content: content, selected: selected };
	}

	private function getListInit(name, content)
	{
		return { name: name, content: content };
	}

	private function getLayoutThread()
	{
		return [
			{ name: "info", right: "right1" },
			{ name: "offset", right: "right2" },
			{ name: "scenes", right: "right3" },
			{ name: "pickRandom" },
			{ name: "pauseAnimation" },
			{ name: "toggleAutoplay" },
			{ name: "moveScene" },
			{ name: "endScene" }
		];
	}

	private function updateThreadLayout()
	{
		right1.updateFields();
		right2.updateFields();
		right3.updateFields();

		left1["info"].init(getTextInit("$SSL_SceneInfo", ">", true));
		left1["offset"].init(getTextInit("$SSL_Offset", ">"));
		left1["scenes"].init(getTextInit("$SSL_AlternateScenes", ">"));
		left1["pickRandom"].init(getTextInit("$SSL_PickRandom", ""));
		left1["pauseAnimation"].init(getTextInit("$SSL_PauseAnimation", "TODO: Hotkey..?"));
		left1["toggleAutoplay"].init(getTextInit("$SSL_ToggleAutoplay", "TODO: Hotkey..?"));
		left1["moveScene"].init(getTextInit("$SSL_MoveScene", "TODO: hotkey..?"));
		left1["endScene"].init(getTextInit("$SSL_EndScene", "TODO: lookup hotkey..."));
	}

}