import skyui.components.list.ScrollingList;

class MenuRight3 extends ScrollingListInputEx
{
	/* STAGE ELEMENTS */

	/* PRIVATE VARIABLES */

	/* INITIALIZATION */
	public function MenuRight3()
	{
		super();
	}

	/* SCENE LIST */

	public function updateFields(): Void
	{
		var scenes = SexLabAPI.GetAlternateScenes();
		updateFieldsCustom(scenes);
	}

	/* EXPRESSION & VOICE LIST */

	public function updateFieldsCustom(arr)
	{
		clearList();
		trace("updateFieldsCustom: " + clearList);
		for (var i = 0; i < arr.length; i++) {
			var obj = arr[i];
			if (obj == undefined) {
				trace("MenuRight3: updateFieldsCustom: Invalid object at index " + i);
				continue;
			}
			entryList.push(obj);
		}
		InvalidateData();
	}

}