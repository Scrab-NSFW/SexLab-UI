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
	var speedValues: Array;
	var speedIdx;
	var speedVal;

	/* INIT */
	public function SpeedControl()
	{
		super();
		speedValues = [0.5, 0.75, 1, 1.25, 1.5, 2, 3];
		speedIdx = 3;
		speedVal = speedValues[speedIdx];

		spdUpBtn.onRelease = function() {
			_parent.changeSpeed(true);
		};

		spdDownBtn.onRelease = function() {
			_parent.changeSpeed(false);
		};
	}

	/* FUNCTIONS */
	public function changeSpeed(upOrDown: Boolean)
	{
		if (speedVal == 0) {
			// paused, restore previous speed
		} else if (upOrDown) {
			speedIdx++;
		} else {
			speedIdx--;
		}
		if (speedIdx < 0) {
			speedIdx = 0;
		} else if (speedIdx >= speedValues.length) {
			speedIdx = speedValues.length - 1;
		}
		// Feeds back into setSpeedCounter()
		Main.UpdateSpeed(speedValues[speedIdx])
	}

	public function setSpeedCounter(speed: Number)
	{
		speedVal = speed;
		if (speedVal == 0) {
			spdCounter.text = "$SSL_Paused";
			return;
		}
		var str = speed.toString(10);
		var where = str.indexOf(".");
		if (where != -1) {
			str = str.substr(0, where + 3);
		}
		spdCounter.text = str;
	}
}
