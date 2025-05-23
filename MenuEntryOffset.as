import gfx.managers.FocusHandler;

class MenuEntryOffset extends MovieClip
{
	/* STAGE ELEMENTS */
	public var background: MovieClip;
	public var name: TextField;
	public var value: TextField;
	public var selectIndicator: MovieClip;

	/* PRIVATE VARIABLES */
	private var _previousFocus;
	private var _referenceId;
	private var _autoPlay;

	/* INITIALIZATION */
	public function MenuEntryOffset()
	{
		selectIndicator._visible = false;
	}

	public function init(initObj)
	{
		name.text = initObj.name;
		_referenceId = initObj.referenceId;
		selectIndicator._visible = initObj.selected != undefined ? initObj.selected : selectIndicator._visible;
		var keyIdx = value.keyIdx = initObj.name.toLowerCase();
		var offset = SexLabAPI.GetOffset(keyIdx, _referenceId);
		if (offset != undefined) {
			setStepSizeText(offset);
		} else {
			trace("Initializing Offset for " + _referenceId + "." + keyIdx + ": No value found, setting to 0.0");
			value.text = "0.0";
		}
		value.type = "dynamic";
		value.border = true;
		value.borderColor = 0x000000;
		value.background = true;
		value.backgroundColor = 0xFFFFFF;
		value.restrict = "0-9\\-\\.";
		value.maxChars = 5;
		value.onChanged = function() {
			var dotIdx = this.text.indexOf(".");
			var dotIdx2 = this.text.indexOf(".", dotIdx + 1);
			if (dotIdx != -1 && dotIdx2 != -1) {
				this.text = this.text.substring(0, dotIdx2);
			}
		};
	}

	public function setStepSizeText(stepSizeArg): Void
	{
		var stepSizeValue = stepSizeArg.toString();
		var pointAt = stepSizeValue.indexOf(".");
		if (pointAt != -1) {
			if (stepSizeValue.length - pointAt < 3) {
				stepSizeValue += "0";
			} else {
				stepSizeValue = stepSizeValue.substr(0, pointAt + 3);
			}
		}
		value.text = stepSizeValue;
	}

	public function setSelected(selected): Void
	{
		selectIndicator._visible = selected;
	}

	public function setFocus(): Void
	{
		if (hasFocus()) {
			return;
		}
		_previousFocus = FocusHandler.instance.getFocus(0);
		_autoPlay = SexLabAPI.IsAutoPlay();
		SexLabAPI.ToggleAutoPlay(false);
		
		value.type = "input";
		value.noTranslate = true;
		value.selectable = true;
		
		Selection.setFocus(value);
		Selection.setSelection(0, 0);

		skse.AllowTextInput(true);
	}

	public function endInput(): Void
	{
		if (!_previousFocus) {
			return;
		}
		SexLabAPI.ToggleAutoPlay(_autoPlay);
		value.type = "dynamic";
		value.selectable = false;
		
		var bPrevEnabled = _previousFocus.focusEnabled;
		_previousFocus.focusEnabled = true;
		Selection.setFocus(_previousFocus, 0);
		_previousFocus.focusEnabled = bPrevEnabled;

		skse.AllowTextInput(false);

		var numValue = parseFloat(value.text);
		if (isNaN(numValue)) {
			trace("Adjusting Offset for " + value.keyIdx + ": Invalid input " + value.text + " , resetting to 0.0");
			value.text = "0.0";
		} else {
			// trace("Adjusting Offset for " + _referenceId + "." + value.keyIdx + ": " + numValue);
			Main.SetOffset(value.keyIdx, numValue, _referenceId);
		}
	}

	public function hasFocus()
	{
		return value.type == "input";
	}

	public function adjustOffset(isNegative): Void
	{
		var stepSizeValue = SexLabAPI.GetOffsetStepSize();
		if (stepSizeValue == undefined) {
			trace("Adjusting Offset for " + value.keyIdx + ": No step size found, setting to 0.1");
			stepSizeValue = 0.1;	// Should only happen during testing
		}
		var numValue = parseFloat(value.text);
		if (isNaN(numValue)) {
			trace("Adjusting Offset for " + value.keyIdx + ": Invalid input " + value.text + " , resetting to 0.0");
			numValue = 0.0;
		}
		if (isNegative) {
			numValue -= stepSizeValue;
		} else {
			numValue += stepSizeValue;
		}
		setStepSizeText(numValue);
		Main.SetOffset(value.keyIdx, numValue, _referenceId);
	}

	public function handleInputEx(keyStr: String, modes: Boolean, reset: Boolean): Boolean
	{
		if (!modes) {
			return hasFocus();
		}
		switch (keyStr) {
		case KeyType.DOWN:
		case KeyType.RIGHT:
			adjustOffset(true);
			return true;
		case KeyType.UP:
		case KeyType.LEFT:
			adjustOffset(false);
			return true;
		case KeyType.END:
			endInput();
			return true;
		default:
			return hasFocus();
		}
	}
}
