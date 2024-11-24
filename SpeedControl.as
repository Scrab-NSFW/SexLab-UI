
class SpeedControl extends MovieClip
{
	private static var SPEED_INTERVAL: Number = 0.5;

	/* STAGE */
	var spdUp: MovieClip;
	var spdDown: MovieClip;
	var spdUpBtn: MovieClip;
	var spdDownBtn: MovieClip;
	var tf1: TextField;
	var spdCounter: TextField;

	/* VARIABLES */


	/* FUNCTIONS */
	public function SpeedControl()
	{
		spdUpBtn.onRelease = function() {
			trace("SpeedControl::spdUpBtn.onRelease");
			skse.SendModEvent("SL_SpeedChange", "", SPEED_INTERVAL);
		};

		spdDownBtn.onRelease = function() {
			trace("SpeedControl::spdDownBtn.onRelease");
			skse.SendModEvent("SL_SpeedChange", "", -SPEED_INTERVAL);
		};
	}

	public function setSpeedCounter(speed: Number)
	{
		spdCounter.text = speed.toString();
	}
}