import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;

class SettingsDropdown extends MovieClip
{
	public static var THREAD_IDX: Number = 0;
	public static var POSITION_IDX: Number = 1;

	public static var MENU_SEPARATOR: String = "MenuSeparator";
	public static var MENU_ENTRY: String = "MenuEntryRow";
	public static var MENU_ENTRY_BLANK: String = "MenuEntryBlank";

	/* STAGE ELEMENTS */
	public var background: MovieClip;

	/* PRIVATE VARIABLES */
	private var threadMenuLayout: Object;
	private var threadMenuLayoutIdx: Number;
	private var separator: MovieClip;

	/* INITIALIZATION */
	public function SettingsDropdown()
	{
	}

	public function onLoad()
	{
		separator = attachMovie(MENU_SEPARATOR, "separator", getNextHighestDepth(), {
			_x: _width / 2,
			_y: _height / 2,
			_rotation: 90
		});

	}

	/* PUBLIC FUNCTIONS */
	public function setLayout(layoutIdx)
	{
		var key = "layout" + layoutIdx;
		var layout = threadMenuLayout[key];
		if (layout == undefined) {
			layout = this[key]();
		}
		threadMenuLayout[threadMenuLayoutIdx]._visible = false;
		threadMenuLayout[layoutIdx]._visible = true;
		threadMenuLayoutIdx = layoutIdx;
	}

	/* GFX */
	public function handleInputEx(keyStr: String, modes: Boolean, reset: Boolean): Boolean
	{
		return false;
	}

	/* LAYOUT */	
	private function layout0()
	{
		var layout = {
			isLeft: true,
			prefix: "l0",
			list: [
				MENU_ENTRY,
				MENU_ENTRY,
				MENU_ENTRY,
				MENU_ENTRY_BLANK,
				MENU_ENTRY,
				MENU_ENTRY
			],
			initList: [
				{ name: "Scene Info", extra: ">" },
				{ name: "Alternate Scenes", extra: ">" },
				{ name: "Furniture Offset", extra: ">" },
				{},
				{ name: "Move Scene", extra: "" },
				{ name: "End Scene", extra: "Shift + END" }
			]
		};
		return buildLayout(layout);
	}

	private function buildLayout(layoutObj)
	{
		var centerX = _width * (layoutObj.isLeft ? 0.25 : 0.75);

		var list = layoutObj.list;
		var objects = new Array();
		var totalHeight = 0;
		for (var i = 0; i < list.length; i++) {
			var entry = attachMovie(list[i], layoutObj.prefix + list[i] + i, getNextHighestDepth(), { _x: centerX });
			totalHeight += entry._height
			objects.push(entry);
		}
		var spacing = (_height - totalHeight) / (list.length + 1);
		var tmpY = spacing / 1.5;
		for (var i = 0; i < objects.length; i++) {
			tmpY += objects[i]._height / 2;
			objects[i]._y = tmpY;
			tmpY += spacing + objects[i]._height / 2;
			if (list[i] == MENU_ENTRY_BLANK) {
				// objects[i]._visible = false;
			} else {
				objects[i].initialize(layoutObj.initList[i]);
			}
		}
		return objects;
	}

}