import skyui.components.list.BasicListEntry;
import skyui.components.list.ListState;
import skyui.components.list.BasicList;

class MenuEntryRow extends skyui.components.list.BasicListEntry
{
	/* STAGE ELEMENTS */
	public var background: MovieClip;
	public var name: TextField;
	public var value: TextField;
	public var selectIndicator: MovieClip;

	/* PROPERTIES */
	public var selectable: Boolean;

	/* PRIVATE VARIABLES */

	/* INITIALIZATION */
	public function MenuEntryRow()
	{
		selectIndicator._visible = false;
		isEnabled = selectable;
	}

	/* UNIQUE IMPL FUNCTIONS */

	public function init(initObj)
	{
		name.text = initObj.name;
		value.text = initObj.extra ? initObj.extra : "";
		if (initObj.align != undefined) {
			value.autoSize = initObj.align;
		}
		selectIndicator._visible =  initObj.selected != undefined ? initObj.selected : selectIndicator._visible;
	}

	public function setSelected(selected): Void
	{
		if (!selectable) {
			return;
		}
		selectIndicator._visible = selected;
	}

	/* BASIC LIST FUNCTIONS */

	public function setEntry(a_entryObject: Object, a_state: ListState): Void
	{
		a_entryObject.selected = (a_entryObject == a_state.list.selectedEntry);
		init(a_entryObject);
	}

}