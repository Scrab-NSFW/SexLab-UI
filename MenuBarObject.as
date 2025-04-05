class MenuBarObject extends MovieClip
{
	public static var OUTLINE_MID: String = "MenuBarMid";
	public static var OUTLINE_END: String = "MenuBarEnd";
	public static var OUTLINE_SEP: String = "MenuBarSep";

	/* STAGE ELEMENTS */
	public var background: MovieClip;
	public var outlineStart: MovieClip;

	public var text1: TextField;
	public var text2: TextField;
	public var text3: TextField;

	/* VARIABLES */
	private var textArr: Array;


	/* INITIALIZATION */
	public function MenuBarObject()
	{
		textArr = [text1, text2, text3];
	}

	public function onLoad()
	{
		var midIdx = 0;
		var mid = attachMovie(OUTLINE_MID, "outlineMid" + (midIdx++), getNextHighestDepth(), {
			_x: outlineStart._x + outlineStart._width,
			_y: outlineStart._y
		});
		for (var i = 0; i < textArr.length; i++) {
			var text = textArr[i];
			text._x = mid._x + (mid._width / 2);
			var lastIteration = i == textArr.length - 1;
			var expectedWidth = text._x + text._width - (lastIteration ? mid._width : 0);
			while (mid._x < expectedWidth) {
				mid = attachMovie(OUTLINE_MID, "outlineMid" + (midIdx++), getNextHighestDepth(), {
					_x: mid._x + mid._width,
					_y: mid._y
				});
			}
			if (lastIteration) {
				break;
			}
			attachMovie(OUTLINE_SEP, "outlineSep" + i, getNextHighestDepth(), {
				_x: mid._x,
				_y: mid._y
			});
			mid = attachMovie(OUTLINE_MID, "outlineMid" + (midIdx++), getNextHighestDepth(), {
				_x: mid._x + mid._width,
				_y: mid._y
			});
		}
		mid = attachMovie(OUTLINE_END, "outlineEnd", getNextHighestDepth(), {
			_x: mid._x + mid._width,
			_y: mid._y
		});
		var outlineXEnd = mid._x + mid._width;
		var outlineXStart = outlineStart._x;
		var outlineWidth = outlineXEnd - outlineXStart;
		var bgRatio = outlineWidth / background.background._width;
		trace("bgRatio: " + bgRatio);
		background._width *= bgRatio;
		trace("background._width: " + background._width);
	}

}