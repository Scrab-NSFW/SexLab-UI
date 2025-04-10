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

	public function updateFields(): Void
	{
		entryList.clearList();
		var scenes = SexLabAPI.GetAlternateScenes();
		for (var i = 0; i < scenes.length; i++) {
			var scene = scenes[i];
			if (scene == undefined) {
				continue;
			}
			entryList.push(scene);
		}
		InvalidateData();
	}

}