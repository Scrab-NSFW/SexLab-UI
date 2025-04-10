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

	/* INITIALIZATION */
	public function MenuEntryOffset()
	{
		selectIndicator._visible = false;
	}

	public function init(initObj)
	{
		name.text = initObj.name;
		selectIndicator._visible = initObj.selected != undefined ? initObj.selected : selectIndicator._visible;
		var keyIdx = value.keyIdx = initObj.name.toLowerCase();
		if (SexLabAPI.GetOffset(keyIdx) != undefined) {
			value.text = SexLabAPI.GetOffset(keyIdx).toString();
		} else {
			trace("Adjusting Offset for " + keyIdx + ": No value found, setting to 0.0");
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
		value.onKillFocus = function() {
			trace("Adjusting Offset for " + keyIdx + ": " + this.text);
			var numValue = parseFloat(this.text);
			if (isNaN(numValue)) {
				trace("Adjusting Offset for " + keyIdx + ": Invalid input " + value.text + " , resetting to 0.0");
				this.text = "0.0";
				return;
			}
			trace("Adjusting Offset for " + keyIdx + ": " + numValue);
			SexLabAPI.SetOffset(keyIdx, numValue);
		};
	}

	public function setSelected(selected): Void
	{
		selectIndicator._visible = selected;
	}

	public function setFocus(): Void
	{
		_previousFocus = FocusHandler.instance.getFocus(0);
		
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
		value.type = "dynamic";
		value.selectable = false;
		
		var bPrevEnabled = _previousFocus.focusEnabled;
		_previousFocus.focusEnabled = true;
		Selection.setFocus(_previousFocus, 0);
		_previousFocus.focusEnabled = bPrevEnabled;

		skse.AllowTextInput(false);
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
		value.text = numValue.toString();
		SexLabAPI.SetOffset(value.keyIdx, numValue);
	}

}
