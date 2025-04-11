import com.greensock.TweenLite;
import com.greensock.TimelineLite;
import com.greensock.easing.*;
import gfx.events.EventDispatcher;

import skyui.components.list.BasicEnumeration;

class DropdownMenu extends MovieClip
{
	public static var MENU_TOP_BORDER: Number = 90;
	public static var MENU_ENTRY_HEIGHT: Number = 30;

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
	public var right4: MovieClip;

	/* PRIVATE VARIABLES */
	private var positionArrObjs: Array;
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
		var yOffset = background._y + background._height * 0.025;
		left1._x = left2._x = left3._x = tmp.decoratorLeft._x;
		left1._y = left2._y = left3._y = yOffset;
		left1._visible = left2._visible = left3._visible = false;

		right1._x = right2._x = right3._x = right4._x = tmp.decoratorRight._x;
		right1._y = right2._y = right3._y = right4._y = yOffset;
		right1._visible = right2._visible = right3._visible = right4._visible = false;

		EventDispatcher.initialize(this);
		
		positionArrObjs = new Array();
		for (var i = 0; i < 5; i++) {
			positionArrObjs.push(left2.attachMovie(MENU_ENTRY, MENU_ENTRY + i, left2.getNextHighestDepth(), {
				_x: left2.background._x + left2.background._width / 2, _y: MENU_TOP_BORDER + MENU_ENTRY_HEIGHT * i, _visible: false
			}));
		}

		layout = getLayout();
	}

	public function onLoad()
	{
		right3.listEnumeration = new BasicEnumeration(right3.entryList);
		right3.addEventListener("itemPress", this, "onItemPressAlternate");

		updateThreadLayout();
		updatePositionLayout();
		updateDebugLayout();
	}

	/* PUBLIC FUNCTIONS */
	public function setLayout(layoutIdx)
	{
		if (layoutIdx >= layout.length) {
			trace("DropdownMenu: setLayout: layoutIdx is out of bounds for index " + layoutIdx);
			return;
		}
		if (activeLayoutIdx > -1) {
			if (activeRight)
				focusLeft();
			setActiveIdx(-1);
			this["left" + (activeLayoutIdx + 1)]._visible = false;
		}
		this["left" + (layoutIdx + 1)]._visible = true;
		activeLayoutIdx = layoutIdx;
		setActiveIdx(0);
	}
	
	public function loadBackground(layoutIdx)
	{
		if (layoutIdx >= layout.length) {
			trace("DropdownMenu: loadBackground: layoutIdx is out of bounds for index " + layoutIdx);
			return;
		}
		var defaultOption = layout[layoutIdx][0];
		if (defaultOption == undefined) {
			trace("DropdownMenu: loadBackground: defaultOption is undefined for index 0");
			return;
		} else if (defaultOption.rightClip != undefined) {
			background.gotoAndStop("double");
		} else {
			background.gotoAndStop("single");
		}
	}

	/* GFX */
	public function handleInputEx(keyStr: String, modes: Boolean, reset: Boolean): Boolean
	{
		if (activeLayoutIdx == -1) {
			return false;
		}
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
			setActiveIdx(activeLeftIdx <= 0 ? maxIdx : activeLeftIdx - 1);
			return true;
		case KeyType.DOWN:
			setActiveIdx(activeLeftIdx == -1 ? 0 : activeLeftIdx == maxIdx ? 0 : activeLeftIdx + 1);
			return true;
		case KeyType.LEFT:
			if (!activeRight) {
				return true;
			}
			focusLeft();
			return true;
		case KeyType.PAGE_DOWN:
			setActiveIdx(maxIdx);
			return true;
		case KeyType.PAGE_UP:
			setActiveIdx(0);
			return true;
		case KeyType.RIGHT:
			if (activeRight) {
				return true;
			}
			// fallthrough
		case KeyType.SELECT:
			if (!activeRight) {
				activeRight = activeLayout[activeLeftIdx].rightClip;
				if (activeRight != undefined) {
					TweenLite.to(this["left" + (activeLayoutIdx + 1)], 0.2, { _alpha: 30 });
					TweenLite.to(activeRight, 0.2, { _alpha: 100 });
					activeRight.setDefault();
				} else if (activeLayout[activeLeftIdx].func != undefined) {
					activeLayout[activeLeftIdx].func();
				} else if (activeLayout[activeLeftIdx].clip == left2["offsetStepSize"]) {
					SexLabAPI.AdjustOffsetStepSize(!reset);
				} else if (activeLayout[activeLeftIdx].clip == left2["offsetStageOnly"]) {
					toggleStageOnly();
				} else if (activeLayout[activeLeftIdx].clip == left3["exitMenu"]) {
					_parent.closeMenu();
				} else {
					trace("DropdownMenu: handleInputEx: rightClip is undefined for index " + activeLeftIdx);
				}
				return true;
			} else {
				return activeRight.handleInputEx && activeRight.handleInputEx(keyStr, modes, reset);
			}
		default:
			return false;
		}
	}

	private function setActiveIdx(newIdx)
	{
		if (newIdx == activeLeftIdx) {
			return;
		}
		var referenceArr = layout[activeLayoutIdx];
		if (newIdx >= referenceArr.length) {
			trace("DropdownMenu: setActiveIdx: newIdx is out of bounds for index " + newIdx);
			return;
		}
		if (activeLeftIdx > -1) {
			var oldOption = referenceArr[activeLeftIdx];
			oldOption.clip.setSelected(false);
			if (oldOption.rightClip != undefined) {
				oldOption.rightClip._visible = false;
			}
		}
		if (newIdx == -1) {
			activeLeftIdx = -1;
			return;
		}
		var newOption = referenceArr[newIdx];
		if (newOption == undefined) {
			trace("DropdownMenu: setActiveIdx: newOption is undefined for index " + newIdx);
			return;
		}
		newOption.clip.setSelected(true);
		if (newOption.rightClip != undefined) {
			if (newOption.rightClip.resetFields != undefined) {
				newOption.rightClip.resetFields(newOption.id);
			}
			newOption.rightClip._alpha = 30;
			newOption.rightClip._visible = true;
			background.gotoAndStop("double");
		} else {
			newOption.rightClip._visible = false;
			background.gotoAndStop("single");
		}
		activeLeftIdx = newIdx;
	}

	public function focusLeft()
	{
		activeRight.resetSelection();
		TweenLite.to(activeRight, 0.2, { _alpha: 30 });
		TweenLite.to(this["left" + (activeLayoutIdx + 1)], 0.2, { _alpha: 100 });
		activeRight = undefined;
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
		trace("onItemPressAlternate: " + eventObj.entry.name);
		SexLabAPI.SetActiveScene(eventObj.entry.id);
	}

	/* LAYOUT */

	private function getTextInit(name, extra, selected)
	{
		return { name: name, extra: extra != undefined ? extra : "", selected: selected != undefined ? selected : false };
	}

	private function getInputInit(name, content, selected)
	{
		return { name: name, content: content, selected: selected };
	}

	private function getListInit(name, content)
	{
		return { name: name, content: content };
	}

	private function getLayout()
	{
		return [
			getLayoutThread(),
			getLayoutPositions(),
			getDebugLayout()
		]
	}
	private function getLayoutThread()
	{
		return [
			{ clip: left1["info"], rightClip: right1 },
			{ clip: left1["offset"], rightClip: right2 },
			{ clip: left1["scenes"], rightClip: right3 },
			{ clip: left1["pickRandom"], func: SexLabAPI.PickRandomScene },
			{ clip: left1["toggleAutoplay"], func: SexLabAPI.ToggleAutoPlay }
		];
	}
	private function getLayoutPositions()
	{
		var positions = SexLabAPI.GetPositions();
		var ret = [
			{ clip: left2["offsetStepSize"] },
			{ clip: left2["offsetStageOnly"] }
		];
		if (positions.length == 0) {
			return ret;
		}
		var i = 0;
		for (;i < positions.length; i++) {
			var position = positions[i];
			position.extra = ">";
			position.rightClip = right4;
			position.clip = positionArrObjs[i];
			position.clip._visible = true;
			ret.push(position);
		}
		for (; i < positionArrObjs.length; i++) {
			positionArrObjs[i]._visible = false;
		}
		return ret;
	}
	private function getDebugLayout()
	{
		return [
			{ clip: left3["exitMenu"] },
			{ clip: left3["pauseAnimation"], func: SexLabAPI.PickRandomScene },
			{ clip: left3["moveScene"], func: SexLabAPI.MoveScene },
			{ clip: left3["endScene"], func: SexLabAPI.EndScene }
		]
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
		left1["toggleAutoplay"].init(getTextInit("$SSL_ToggleAutoplay", SexLabAPI.IsAutoPlay()));
	}
	private function updatePositionLayout()
	{
		left2["offsetStepSize"].init(getTextInit("$SSL_StepSize", SexLabAPI.GetOffsetStepSize().toString(), true));
		left2["offsetStageOnly"].init(getTextInit("$SSL_StageOnly", SexLabAPI.GetAdjustStageOnly() || true));
		for (var i = 2; i < layout[1].length; i++) {
			var position = layout[1][i]
			position.clip.init(position);
		}
	}
	private function updateDebugLayout()
	{
		left3["exitMenu"].init(getTextInit("$SSL_ExitMenu", "", true));
		left3["pauseAnimation"].init(getTextInit("$SSL_PauseAnimation"));
		left3["moveScene"].init(getTextInit("$SSL_MoveScene"));
		left3["endScene"].init(getTextInit("$SSL_EndScene", SexLabAPI.GetHotkeyCombination("endScene")));
	}

	private function toggleStageOnly()
	{
		var stageOnly = !SexLabAPI.GetAdjustStageOnly();
		SexLabAPI.SetAdjustStageOnly(stageOnly);
		left2["offsetStageOnly"].init(getTextInit("$SSL_StageOnly", stageOnly, true));
	}

}