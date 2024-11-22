import com.greensock.TweenLite;
import com.greensock.TimelineLite;
import com.greensock.easing.*;

class Control extends MovieClip
{
	/* STAGE */
	static var MAX_SHOWN: Number = 9;
	static var InstanceCounter: Number = 0;
	var background: MovieClip;
	var timer: MovieClip;
	var speedControl: MovieClip;

	/* VARIABLES */
	var farRight: Number;
	var farDown: Number;

	var __timerWidth: Number;
	var timerTimeLine: TimelineLite;


	/* FUNCTIONS */
	public function Control()
	{
		super();

		__timerWidth = timer._width;
		timerTimeLine = new TimelineLite({_paused:true});
	}

	public function onLoad()
	{
		_global.gfxExtensions = true;
		
		farRight = Stage.visibleRect.x + Stage.visibleRect.width - Stage.safeRect.x;
		farDown = Stage.visibleRect.y + Stage.visibleRect.height - Stage.safeRect.y;

		var localStageTimer = { x: farRight * 0.99, y: farDown * 0.98};
		globalToLocal(localStageTimer);
		timer._x = localStageTimer.x;
		timer._y = localStageTimer.y;

		var localSpeedControl = { 
			x: farRight * 0.98 - speedControl._width / 2 + speedControl.spdUp._width * 0.25,
			y: farDown * 0.96 - speedControl._height * 0.25
		};
		globalToLocal(localSpeedControl);
		speedControl._x = localSpeedControl.x;
		speedControl._y = localSpeedControl.y;
	}

	public function newStage(/* args */)
	{
		var t = arguments[0];
		timerTimeLine.clear();
		if (t == 0) {
			timerTimeLine.to(timer, 0.4, { _alpha: 0 });
		} else {
			timerTimeLine
				.to(timer, 0.3, { _width: __timerWidth, _alpha: 100, ease: Linear.easeNone })
				.to(timer, t, { _width: 0, ease: Linear.easeNone });
		}

		var anchor = { x: farRight * 0.99, y: farDown * 0.94 - speedControl._height };
		globalToLocal(anchor);
		var distanceBetweenObject = farDown * 0.005;
		for (var i = 1; i < Math.min(arguments.length, 9); i++) {
			var obj = arguments[i];
			var branch = attachMovie("BranchButton", "Text" + InstanceCounter++, getNextHighestDepth(), {
				_x: anchor.x
			});
			branch._y = anchor.y - branch._height / 2 - (branch._height + distanceBetweenObject) * (i - 1);
			TweenLite.from(branch, 1, { _x: branch._x + branch._width, _alpha: 0, ease: Quint.easeOut });
		}
	}
}