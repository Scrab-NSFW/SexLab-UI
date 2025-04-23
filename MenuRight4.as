import com.greensock.TweenLite;
import com.greensock.TimelineLite;
import com.greensock.easing.*;
import gfx.events.EventDispatcher;
import skyui.components.list.BasicEnumeration;

class MenuRight4 extends MovieClip
{
	public static var LIST_MENU = "MenuRight5";

	/* STAGE ELEMENTS */
	public var background: MovieClip;
	public var list: MovieClip;
	public var listHeader: MovieClip;

	public var permutation: MovieClip;
	public var expression: MovieClip;
	public var voice: MovieClip;
	public var ghostMode: MovieClip;

	public var resetOffsets: MovieClip;
	public var xOffset: MovieClip;
	public var yOffset: MovieClip;
	public var zOffset: MovieClip;
	public var rOffset: MovieClip;

	/* PRIVATE VARIABLES */
	private var selectables: Array;
	private var activeSelectionIndex: Number;
	private var transitionDone: Boolean;
	private var _referenceId: Number;

	/* INITIALIZATION */
	
	public function MenuRight4()
	{
		super();
		selectables = [
			permutation,
			expression,
			voice,
			ghostMode,
			resetOffsets,
			xOffset,
			zOffset,
			yOffset,
			rOffset
		];
		activeSelectionIndex = -1;
		transitionDone = true;

		EventDispatcher.initialize(this);
	}

	public function onLoad()
	{
		list = _parent.attachMovie(LIST_MENU, LIST_MENU + "Right4", _parent.getNextHighestDepth(), {
			_x: this._x, _y: this._y, _visible: false, entryRenderer: "MenuEntryRow", entryHeight: 30, topBorder: 90, leftBorder: 125
		});
		listHeader = list.headline;
		
		list.listEnumeration = new BasicEnumeration(list.entryList);
		list.addEventListener("itemPress", this, "onItemPress");
	}

	// @mixin by gfx.events.EventDispatcher
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	public var hasEventListener:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var removeAllEventListeners:Function;
	public var cleanUpEvents:Function;

	public function onItemPress(event)
	{
		if (event != undefined) {
			var item = event.entry;
			if (item == undefined) {
				trace("MenuRight4: onItemPress: No item found in event");
				return;
			}
			if (selectables[activeSelectionIndex] == this.voice) {
				SexLabAPI.SetVoice(_referenceId, item.id);
			} else {
				SexLabAPI.SetExpression(_referenceId, item.id);
			}
		}
		transitionDone = false;
		TweenLite.from(selectables[activeSelectionIndex], 0.35, { _y: listHeader._y, onComplete: function(self) {
			self.transitionDone = true;
		}, onCompleteParams: [this]});
		list._visible = false;
		this._visible = true;
	}


	/* PUBLIC FUNCTIONS */

	public function resetFields(id)
	{
		_referenceId = id;
		updateFields();
	}

	public function updateFields()
	{
		if (_referenceId == undefined) {
			trace("MenuRight4: updateFields: No referenceId set");
		}
		var exprName = SexLabAPI.GetExpressionName(_referenceId);
		var voiceName = SexLabAPI.GetVoiceName(_referenceId);
		var permutationData = SexLabAPI.GetPermutationData(_referenceId);
		if (exprName == undefined) exprName = "None";
		if (voiceName == undefined) voiceName = "None";
		if (permutationData == undefined) permutationData = { current: 0, total: 0 };

		permutation.init({ name: "$SSL_Permutation", extra: permutationData.current + "/" + permutationData.total });
		ghostMode.init({ name: "$SSL_GhostMode", extra: SexLabAPI.GetGhostMode(_referenceId).toString() });
		expression.init({ name: "$SSL_Expression", align: "left", extra: exprName });
		voice.init({ name: "$SSL_Voice", align: "left", extra: voiceName });

		resetOffsets.init({ name: "$SSL_ResetOffsets" });
		xOffset.init({ name: "X", referenceId: _referenceId });
		yOffset.init({ name: "Y", referenceId: _referenceId });
		zOffset.init({ name: "Z", referenceId: _referenceId });
		rOffset.init({ name: "R", referenceId: _referenceId });
	}

	public function setDefault()
	{
		permutation.setSelected(true);
		activeSelectionIndex = 0;
	}

	public function resetSelection()
	{
		selectables[activeSelectionIndex].setSelected(false);
		activeSelectionIndex = -1;
	}
	
	public function handleInputEx(keyStr: String, modes: Boolean, reset: Boolean): Boolean
	{
		if (list._visible) {
			if (keyStr == KeyType.END) {
				if (transitionDone)
					onItemPress(undefined);
				return true;
			}
			return list.handleInputEx(keyStr, modes, reset);
		}
		var selection = selectables[activeSelectionIndex];
		if (selection.hasFocus != undefined && selection.hasFocus()) {
			trace("MenuRight4: handleInputEx: selection has focus, calling endInput() " + selection);
			if (keyStr == KeyType.END)
				selection.endInput();
			return true;
		}
		switch (keyStr) {
		case KeyType.PAGE_UP:
			selection.setSelected(false);
			activeSelectionIndex = 0;
			selectables[activeSelectionIndex].setSelected(true);
			return true;
		case KeyType.PAGE_DOWN:
			selection.setSelected(false);
			activeSelectionIndex = selectables.length - 1;
			selectables[activeSelectionIndex].setSelected(true);
			return true;
		case KeyType.UP:
			if (selection.endInput != undefined && modes) {
				selection.adjustOffset(true);
				return true;
			}
			selection.setSelected(false);
			activeSelectionIndex = (activeSelectionIndex - 1 + selectables.length) % selectables.length;
			selectables[activeSelectionIndex].setSelected(true);
			return true;
		case KeyType.DOWN:
			if (selection.endInput != undefined && modes) {
				selection.adjustOffset(false);
				return true;
			}
			selection.setSelected(false);
			activeSelectionIndex = (activeSelectionIndex + 1) % selectables.length;
			selectables[activeSelectionIndex].setSelected(true);
			return true;
		case KeyType.SELECT:
			selectOption();
			return true;
		default:
			return false;
		}
	}

	private function selectOption()
	{
		var selection = selectables[activeSelectionIndex];
		if (selection == permutation) {
			SexLabAPI.SelectNextPermutation(_referenceId);
			updateFields();
		} else if (selection == ghostMode) {
			SexLabAPI.SetGhostMode(_referenceId, !SexLabAPI.GetGhostMode(_referenceId));
			updateFields();
		} else if (selection == expression || selection == voice) {
			createList();
		} else if (selection == resetOffsets) {
			SexLabAPI.ResetOffsets(_referenceId);
			updateFields();
		} else if (selection.setFocus != undefined) {
			selection.setFocus();
		}
	}

	private function createList()
	{
		var selection = selectables[activeSelectionIndex];
		var arr = (selection == expression) ? SexLabAPI.GetExpressions(_referenceId) : SexLabAPI.GetVoices(_referenceId);
		listHeader.init({ name: selection.name.text, extra: selection.value.text });
		list.updateFieldsCustom(arr);
		list.setDefault();
		transitionDone = false;
		TweenLite.from(listHeader, 0.35, { _y: selection._y, onComplete: function(self) {
			self.transitionDone = true;
		}, onCompleteParams: [this]});
		this._visible = false;
		list._visible = true;
	}

}
