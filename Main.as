import Shared.GlobalFunc;
import gfx.io.GameDelegate;
import gfx.utils.Delegate;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import gfx.managers.FocusHandler;

class Main extends MovieClip
{
	/* STAGE */
	var background:MovieClip;
	var settings:MovieClip;
	var messages:MovieClip;
	var sliders:MovieClip;
	var control:MovieClip;

	/* VARIABLES */
	var endSceneHotkey:Number = 35; // End

	/* FUNCTIONS */
	public function Main()
	{
		super();
		_global.gfxExtensions = true;
		FocusHandler.instance.setFocus(this, 0);
	}

	public function onLoad()
	{
		setLocation(settings, 0, 0)
		setLocation(messages, 1, 0)
		setLocation(sliders, 0, 1)
		setLocation(control, 1, 1)

		_global.testing = true;
		// setTimeout(Delegate.create(this, test), 2000);
	}

	private function test() {
		for (var i = 0; i < 10; i++)
			ShowMessage("test 123 very long test because I want to see how it 456 looks when its long, like very long 987");

		setStages(
			7,
			{name: "Stage 1", id: 1},
			{name: "Stage 2", id: 2},
			{name: "Stage 3", id: 3},
			{name: "Stage 4", id: 4},
			{name: "Stage 5", id: 5},
			{name: "Stage 6", id: 6}
		);
		setSliders(
			{name: "Slider 1", id: 0},
			{name: "Slider 2", id: 1},
			{name: "Slider 3", id: 2},
			{name: "Slider 4", id: 3},
			{name: "Slider 5", id: 4}
		);
		
		setTimeout(Delegate.create(this, test2), 10 * 1000);
	}

	private function test2() {
		for (var i = 0; i < 10; i++)
			ShowMessage("test 456");

		setSliders(
			{name: "YAY", id: 7},
			{name: "HAHAHAHAHA4", id: 6}
		);
	}

	public static function setLocation(obj: MovieClip, xpos_prc: Number, ypos_prc: Number, rot: Number, xscale: Number, yscale: Number): Void
	{
			var minXY: Object = {x: Stage.visibleRect.x + Stage.safeRect.x, y: Stage.visibleRect.y + Stage.safeRect.y};
			var maxXY: Object = {x: Stage.visibleRect.x + Stage.visibleRect.width - Stage.safeRect.x, y: Stage.visibleRect.y + Stage.visibleRect.height - Stage.safeRect.y};

			//  (minXY.x, minXY.y) _____________ (maxXY.x, minXY.y)
			//                    |             |
			//                    |     THE     |
			//                    |    STAGE    |
			//  (minXY.x, maxXY.y)|_____________|(maxXY.x, maxXY.y)

			obj._x = minXY.x + maxXY.x * xpos_prc;
			obj._y = minXY.y + maxXY.y * ypos_prc;

			if (rot != undefined)
					obj._rotation = rot;
			if (xscale != undefined)
					obj._xscale = xscale;
			if (yscale != undefined)
					obj._yscale = yscale;
	}

	public function onEnterFrame()
	{
		messages.Update();
	}

	/* MESSAGES */
	public function ShowMessage(message:String)
	{
		messages.MessageArray.push(message);
	}

	/* SLIDERS */
	public function setSliders(/* args */)
	{
		sliders.setSliders.apply(sliders, arguments);
	}

	public function updateSliderPct(id: Number, enj: Number)
	{
		sliders.updateSliderPct(id, enj);
	}

	public function setSliderPct(id: Number, enj: Number)
	{
		sliders.setSliderPct(id, enj);
	}

	/* CONTROL */
	public function setStages(/* args */)
	{
		control.setStages.apply(control, arguments);
	}

	public function setTimer(time: Number)
	{
		control.setTimer(time);
	}

	public function setSpeedCounter(speed: Number)
	{
		control.speedControl.setSpeedCounter(speed);
	}

	/* GFX */
	public function handleInputEx(str: String, modes: Boolean, reset: Boolean): Void
	{
		str = str.toLowerCase();
		trace("Main.handleInputEx(" + str + ")");
		if (settings.handleInputEx(str, modes, reset))
			return;
		if (control.handleInputEx(str, modes, reset))
			return;
		if (str == KeyType.END) {
			skse.SendModEvent("SL_EndScene", "", 0);
			trace("SL_EndScene");
			return;
		}
	}

	private var modes = false;
	private var reset = false;
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		if (!GlobalFunc.IsKeyPressed(details)) {
			return false;
		}
		var retVal = false;
		switch (details.navEquivalent) {
		case NavigationCode.LEFT:
			retVal = handleInputEx(KeyType.LEFT, modes, reset);
			break;
		case NavigationCode.RIGHT:
			retVal = handleInputEx(KeyType.RIGHT, modes, reset);
			break;
		case NavigationCode.PAGE_UP:
			retVal = handleInputEx(KeyType.PAGE_UP, modes, reset);
			break;
		case NavigationCode.PAGE_DOWN:
			retVal = handleInputEx(KeyType.PAGE_DOWN, modes, reset);
			break;
		case NavigationCode.DOWN:
			retVal = handleInputEx(KeyType.DOWN, modes, reset);
			break;
		case NavigationCode.UP:
			retVal = handleInputEx(KeyType.UP, modes, reset);
			break;
		case NavigationCode.ENTER:
			retVal = handleInputEx(KeyType.SELECT, modes, reset);
			break;
		default:
			var keyStr = KeyMap.string_from_gfx(details.code);
			if (keyStr == null)
				return false;
			else if (keyStr == "LeftShift")
				return !(modes = true);
			else if (keyStr == "LeftControl")
				return !(reset = true);
			else if (keyStr == "Q") {
				retVal = handleInputEx(KeyType.EXTRA1, modes, reset);
				break;
			} else if (keyStr == "E") {
				retVal = handleInputEx(KeyType.EXTRA2, modes, reset);
				break;
			} else if (keyStr == "LeftAlt") {
				retVal = handleInputEx(KeyType.MOUSE, modes, reset);
				break;
			} else {
				retVal = handleInputEx(keyStr);
				break;
			}
		}
		modes = reset = false;
		return retVal;
	}

}
