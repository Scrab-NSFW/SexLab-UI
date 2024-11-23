import com.greensock.*;
import com.greensock.easing.*;

class Slider extends MovieClip
{
  private static var HUNDRED_PCT_THRESH = 80;

  /* STAGE */
  public var mask: MovieClip;
  public var namecard: MovieClip;
  public var separator: MovieClip;

  /* VARIABLES */
  var timeLine: TimelineLite;
  var __maskWidth: Number;
  var __precent: Number;

  /* INIT */
	public function Slider()
	{
		timeLine = new TimelineLite({_paused:true});
    namecard.tf1.textAutoSize = "shrink";
    __maskWidth = mask._width;
    __precent = __maskWidth / 100;
	}

  public function onLoad()
  {
    separator._x = mask._x + __precent * HUNDRED_PCT_THRESH;
    setMeterPercent(0);
  }

  /* API */
  public function setName(name)
  {
    namecard.tf1.text = name;
  }

  public function setMeterPercent(enjoyment: Number)
	{
    var percent = getMeterPctFromEnjoyment(enjoyment);
		timeLine.clear();
		percent = Math.min(100, Math.max(percent, 0));
		mask._width = __precent * percent;
	}

	public function updateMeterPercent(enjoyment: Number)
	{
    var percent = getMeterPctFromEnjoyment(enjoyment);
		if (!timeLine.isActive())
		{
			timeLine.clear();
			timeLine.progress(0);
			timeLine.restart();
		}
		percent = Math.min(100, Math.max(percent, 0));
		timeLine.to(mask, 1, {_width: __precent * percent});
		timeLine.play();
	}

  /* PRIVATE */
  private function getMeterPctFromEnjoyment(enjoyment: Number): Number
  {
    var ret;
    if (enjoyment <= 100) {
      ret = (enjoyment / 100) * HUNDRED_PCT_THRESH;
    } else {
      var added = Math.pow(1.25 * (enjoyment - 100), 0.6) * 1.4;
      ret = HUNDRED_PCT_THRESH + Math.min(added, 100 - HUNDRED_PCT_THRESH);
    }
    trace("Slider::getMeterPctFromEnjoyment: " + enjoyment + " -> " + ret);
    return Math.min(100, Math.max(ret, 0));
  }
}