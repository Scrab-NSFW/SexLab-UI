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
		updatePositions(
			{name: "Slider 1", id: 0, submissive: true},
			{name: "Slider 2", id: 1, submissive: false},
			{name: "Slider 3", id: 2, submissive: true},
			{name: "Slider 4", id: 3, submissive: true},
			{name: "Slider 5", id: 4, submissive: false}
		);
		
		setTimeout(Delegate.create(this, test2), 10 * 1000);
	}

	private function test2() {
		for (var i = 0; i < 10; i++)
			ShowMessage("test 456");

		updatePositions(
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

	/* PUBLIC FUNCTIONS */
	public function updatePositions(/* args */)
	{
		sliders.setSliders.apply(sliders, arguments);
		settings.updatePositions.apply(settings, arguments);
	}

	/* MESSAGES */
	public function ShowMessage(message:String)
	{
		messages.MessageArray.push(message);
	}

	/* SLIDERS */

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

	/* SETTINGS */
	public function setActiveScene(scene: Object): Void
	{
		settings.setActiveScene(scene);
	}

	/* GFX */
	public function handleInputEx(str: String, modes: Boolean, reset: Boolean): Void
	{
		trace("Main.handleInputEx(" + str + ", " + modes + ", " + reset + ")");
		if (settings.handleInputEx(str, modes, reset))
			return;
		if (control.handleInputEx(str, modes, reset))
			return;
		if (str == KeyType.END) {
			if (modes) {
				PauseScene();
			} else {
				EndScene();
			}
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
			var keyStr = KeyMap.string_from_gfx(details.code).toLowerCase();
			if (keyStr == null)
				return false;
			else if (keyStr == "leftshift")
				return !(modes = true);
			else if (keyStr == "leftcontrol")
				return !(reset = true);
			else if (keyStr == "q") {
				retVal = handleInputEx(KeyType.EXTRA1, modes, reset);
				break;
			} else if (keyStr == "e") {
				retVal = handleInputEx(KeyType.EXTRA2, modes, reset);
				break;
			} else if (keyStr == "leftalt") {
				retVal = handleInputEx(KeyType.MOUSE, modes, reset);
				break;
			} else {
				retVal = handleInputEx(keyStr, modes, reset);
				break;
			}
		}
		modes = reset = false;
		return retVal;
	}

	/* UI Control */
	static public function SetActiveScene(id: String): Void
	{
		trace("Main.SetActiveScene(" + id + ")");
		skse.SendModEvent("SL_SetActiveScene", id);
	}

	static public function AdvanceScene(stageId, rev): Void
	{
		trace("Main.AdvanceScene(" + stageId + ", " + rev + ")");
		skse.SendModEvent("SL_AdvanceScene", stageId, rev);
	}

	static public function PauseScene(): Void
	{
		trace("Main.PauseScene()");
		UpdateSpeed(0);
	}

	static public function UpdateSpeed(speed: Number): Void
	{
		trace("Main.UpdateSpeed(" + speed + ")");
		_root.main.control.speedControl.setSpeedCounter(speed);
		skse.SendModEvent("SL_SetSpeed", "", speed);
	}

	static public function MoveScene(): Void
	{
		trace("Main.MoveScene()");
		skse.SendModEvent("SL_MoveScene");
	}

	static public function EndScene(): Void
	{
		trace("Main.EndScene()");
		skse.SendModEvent("SL_EndScene");
	}

	static public function SetSceneAnnotations(annotations: String): Void
	{
		trace("Main.SetSceneAnnotations(" + annotations + ")");
		skse.SendModEvent("SL_SetAnnotations", annotations);
	}

	static public function SetOffset(idx: String, value: Number, id: Number): Void
	{
		trace("Main.SetOffset(" + idx + ", " + value + ", " + id + ")");
		skse.SendModEvent("SL_SetOffset", idx, value, id);
	}

	// TODO: This currently isnt implemented
	static public function AdjustOffset(idx: String, value: Number, id: Number): Void
	{
		trace("Main.AdjustOffset(" + idx + ", " + value + ", " + id + ")");
		skse.SendModEvent("SL_StartAdjustOffset", idx, value, id);
	}

}
