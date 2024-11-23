import gfx.io.GameDelegate;
import gfx.utils.Delegate;

class Main extends MovieClip
{
	/* STAGE */
	var background:MovieClip;
	var details:MovieClip;
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

		setTimeout(Delegate.create(this, test), 2000);
	}

	private function test() {
		for (var i = 0; i < 10; i++)
			ShowMessage("test 123 very long test because I want to see how it");

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

	public function setLocation(xpos_prc: Number, ypos_prc: Number, rot: Number, xscale: Number, yscale: Number): Void
	{
			var minXY: Object = {x: Stage.visibleRect.x + Stage.safeRect.x, y: Stage.visibleRect.y + Stage.safeRect.y};
			var maxXY: Object = {x: Stage.visibleRect.x + Stage.visibleRect.width - Stage.safeRect.x, y: Stage.visibleRect.y + Stage.visibleRect.height - Stage.safeRect.y};

			//  (minXY.x, minXY.y) _____________ (maxXY.x, minXY.y)
			//                    |             |
			//                    |     THE     |
			//                    |    STAGE    |
			//  (minXY.x, maxXY.y)|_____________|(maxXY.x, maxXY.y)

			this._x = maxXY.x * xpos_prc;
			this._y = maxXY.y * ypos_prc;

			if (rot != undefined)
					this._rotation = rot;
			if (xscale != undefined)
					this._xscale = xscale;
			if (yscale != undefined)
					this._yscale = yscale;
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

}