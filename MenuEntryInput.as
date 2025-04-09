import gfx.managers.FocusHandler;

class MenuEntryInput extends MovieClip
{
	/* STAGE ELEMENTS */
	public var background: MovieClip;
	public var name: TextField;
	public var inputField: TextField;
	public var selectIndicator: MovieClip;

	/* PROPERTIES */
	public var selectable: Boolean = true;

	/* PRIVATE VARIABLES */
	private var _previousFocus;

	/* INITIALIZATION */
	public function MenuEntryInput()
	{
		selectIndicator._visible = false;
	}

	public function init(initObj)
	{
		name.text = initObj.name;
		selectIndicator._visible = initObj.selected;
		inputField.text = initObj.content;
		inputField.type = "dynamic";
		inputField.border = true;
		inputField.borderColor = 0x000000;
		inputField.background = true;
		inputField.backgroundColor = 0xFFFFFF;
	}
	
	public function setSelected(selected): Void
	{
		if (!selectable) {
			return;
		}
		selectIndicator._visible = selected;
	}

	public function setFocus(): Void
	{
		trace("setFocus() called on MenuEntryInput");
		_previousFocus = FocusHandler.instance.getFocus(0);
		
		inputField.type = "input";
		inputField.noTranslate = true;
		inputField.selectable = true;
		
		Selection.setFocus(inputField);
		Selection.setSelection(0,0);

		skse.AllowTextInput(true);
	}

	public function endInput(): Void
	{
		trace("endInput() called on MenuEntryInput " + _previousFocus);
		if (!_previousFocus) {
			return;
		}
		
		inputField.type = "dynamic";
		inputField.selectable = false;
		
		var bPrevEnabled = _previousFocus.focusEnabled;
		_previousFocus.focusEnabled = true;
		Selection.setFocus(_previousFocus, 0);
		_previousFocus.focusEnabled = bPrevEnabled;

		skse.AllowTextInput(false);
	}

}
