class SpeedControl extends MovieClip
{
	/* STAGE */
	var spdUp: MovieClip;
	var spdDown: MovieClip;
	var spdUpBtn: MovieClip;
	var spdDownBtn: MovieClip;
	var tf1: TextField;
	var spdCounter: TextField;

	/* VARIABLES */
	var speedValues: Array = [0.5, 0.75, 1, 1.25, 1.5, 2, 3];
	var speedIdx = 3;

	/* FUNCTIONS */
	public function SpeedControl()
	{
		spdUpBtn.onRelease = function() {
			trace("SpeedControl::spdUpBtn.onRelease");
			_parent.changeSpeed(true);
		};

		spdDownBtn.onRelease = function() {
			trace("SpeedControl::spdDownBtn.onRelease");
			_parent.changeSpeed(false);
		};
	}

	public function setSpeedCounter(speed: Number)
	{
		spdCounter.text = speed.toFixed(2);
	}

	public function changeSpeed(upOrDown: Boolean)
	{
		if (upOrDown) {
			speedIdx++;
		} else {
			speedIdx--;
		}
		setSpeedCounter(speedValues[speedIdx]);
		skse.SendModEvent("SL_SetSpeed", "", speedValues[speedIdx]);
	}
}
