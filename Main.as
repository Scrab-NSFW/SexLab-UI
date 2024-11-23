import Shared.GlobalFunc;
import gfx.io.GameDelegate;
import gfx.utils.Delegate;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;

class Main extends MovieClip
{
	/* STAGE */
	var background:MovieClip;
	var settings:MovieClip;
	var messages:MovieClip;
	var sliders:MovieClip;
	var control:MovieClip;

	/* VARIABLES */

	/* FUNCTIONS */
	public function Main()
	{
	}

	public function onLoad()
	{
		_global.gfxExtensions = true;

		setLocation(settings, 0, 0)
		setLocation(messages, 1, 0)
		setLocation(sliders, 0, 1)
		setLocation(control, 1, 1)

		// setTimeout(Delegate.create(this, test), 2000);
	}

	private function test() {
		for (var i = 0; i < 10; i++)
			ShowMessage("test 123 very long test because I want to see how it 456 looks when its long, like very long 987");

		control.newStage(9, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
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

		control.newStage(4, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
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

	/* GFX */
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		if (!GlobalFunc.IsKeyPressed(details))
			return false;
		if (control.handleInput(details, pathToFocus))
			return true;
		if (settings.handleInput(details, pathToFocus)) {
			return true;
		}
		return false;
	}

}