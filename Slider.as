import com.greensock.*;
import com.greensock.easing.*;

class Slider extends MovieClip
{
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
    trace("Slider loaded");
    separator._x = mask._x + __precent * 80;
  }

  /* API */
  public function setName(name)
  {
    trace(name);
    namecard.tf1.text = name;
  }

  public function setMeterPercent(percent)
	{
		timeLine.clear();
		percent = Math.min(100, Math.max(percent, 0));
		mask._width = __precent * percent;
	}

	public function updateMeterPercent(percent)
	{
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
}