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
		super();

		spdUpBtn.onRelease = function() {
			_parent.changeSpeed(true);
		};

		spdDownBtn.onRelease = function() {
			_parent.changeSpeed(false);
		};
	}

	public function setSpeedCounter(speed: Number)
	{
		var str = speed.toString(10);
		var where = str.indexOf(".");
		if (where != -1) {
			str = str.substr(0, where + 3);
		}
		spdCounter.text = str;
	}

	public function changeSpeed(upOrDown: Boolean)
	{
		if (upOrDown) {
			speedIdx++;
		} else {
			speedIdx--;
		}
		if (speedIdx < 0) {
			speedIdx = 0;
		} else if (speedIdx >= speedValues.length) {
			speedIdx = speedValues.length - 1;
		}
		setSpeedCounter(speedValues[speedIdx]);
		skse.SendModEvent("SL_SetSpeed", "", speedValues[speedIdx]);
	}
}
