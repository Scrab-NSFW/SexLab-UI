class Sliders extends MovieClip
{
	static private var SLIDER_SCALE: Number = 100; // Using 65 when on 1280x720
	static private var MAX_SLIDERS: Number = 5;
	static private var SLIDER_NAME: String = "Slider";

	/* STAGE */
	public var background: MovieClip;

	/* VARIABLES */
	private var instanceCounter: Number;
	private var sliders: Array;
	private var farLeft: Number;
	private var farDown: Number;
	private var rootCoordinates: Object;

	/* INIT */
	public function Sliders()
	{
		instanceCounter = 0;
		sliders = new Array();
	}

	public function onLoad()
	{
		farLeft = 0;
		farDown = Stage.visibleRect.y + Stage.visibleRect.height - Stage.safeRect.y;
		
		rootCoordinates = { x: farLeft, y: farDown };
		globalToLocal(rootCoordinates);
	}

	/* API */
	public function setSliders(/* args */)
	{
		var count = Math.min(MAX_SLIDERS, Math.max(arguments.length, 0));
		trace("Setting " + count + " sliders");
		if (count > instanceCounter) {
			for (var i = instanceCounter; i < count; i++) {
				var slider = attachMovie(SLIDER_NAME, SLIDER_NAME + i, getNextHighestDepth(), {
					_xscale: SLIDER_SCALE,
					_yscale: SLIDER_SCALE
				});
				sliders.push(slider);
			}
		} else if (count < instanceCounter) {
			for (var i = count; i < instanceCounter; i++) {
				sliders[i].removeMovieClip();
			}
			sliders.splice(count, instanceCounter - count);
		}
		for (var i = 0; i < count; i++) {
			sliders[i].setName(arguments[i].name);
			sliders[i].id = arguments[i].id;
			trace("Setting slider " + i + " to " + arguments[i].name + " with id " + arguments[i].id);
		}
		instanceCounter = count;
		positionSliders();
	}

	public function updateSliderPct(id: Number, enj: Number)
	{
		for (var i = 0; i < sliders.length; i++) {
			if (sliders[i].id == id) {
				sliders[i].updateMeterPercent(enj);
				break;
			}
		}
	}

	public function setSliderPct(id: Number, enj: Number)
	{
		for (var i = 0; i < sliders.length; i++) {
			if (sliders[i].id == id) {
				sliders[i].setMeterPercent(enj);
				break;
			}
		}
	}

	/* PRIVATE */
	private function positionSliders()
	{
		if (sliders.length == 0) {
			trace("No sliders to position");
			return;
		}
		var shift_y = sliders[0]._height * 0.5;
		var shift_x = sliders[0]._width * 0.06;
		var anchorX = rootCoordinates.x + sliders[0]._width / 2;
		var anchorY = rootCoordinates.y - sliders[0]._height / 2;
		anchorX -= shift_y / 2;
		anchorY += shift_x / 2;

		for (var i = 0; i < sliders.length; i++) {
			var n = sliders.length - 1 - i;
			var it = sliders[i];
			it._x = anchorX + (i * shift_x);
			it._y = anchorY - (n * shift_y);
		}
	}
}
