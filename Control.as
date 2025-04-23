import com.greensock.TweenLite;
import com.greensock.TimelineLite;
import com.greensock.easing.*;
import gfx.ui.NavigationCode;
import gfx.ui.InputDetails;

class Control extends MovieClip
{
	/* STAGE */
	static private var STAGE_MC: String = "BranchButton";
	public var background: MovieClip;
	public var timer: MovieClip;
	public var speedControl: MovieClip;

	/* VARIABLES */
	private var instanceCounter: Number;
	private var stages: Array;
	private var rootCoordinates: Object;
	private var selectedStage: MovieClip;
	private var __timerWidth: Number;
	private var timerTimeLine: TimelineLite;

	public var speedUpKey: Number = 69;
	public var speedDownKey: Number = 81;

	/* FUNCTIONS */
	public function Control()
	{
		super();
		instanceCounter = 0;
		stages = new Array();

		__timerWidth = timer._width;
		timerTimeLine = new TimelineLite({_paused:true});
	}

	public function onLoad()
	{		
		var farRight = (Stage.visibleRect.x + Stage.visibleRect.width - Stage.safeRect.x) * 0.99;
		var farDown = Stage.visibleRect.y + Stage.visibleRect.height - Stage.safeRect.y;

		var localStageTimer = { x: farRight, y: farDown * 0.98};
		globalToLocal(localStageTimer);
		timer._x = localStageTimer.x;
		timer._y = localStageTimer.y;

		var localSpeedControl = { 
			x: farRight - speedControl._width / 2 + speedControl.spdUp._width * 0.25,
			y: farDown * 0.96 - speedControl._height * 0.25
		};
		globalToLocal(localSpeedControl);
		speedControl._x = localSpeedControl.x;
		speedControl._y = localSpeedControl.y;

		rootCoordinates = {
			x: farRight,
			y: farDown * 0.94 - speedControl._height * 0.5 
		};
		globalToLocal(rootCoordinates);
	}

	public function setStages(/* args */)
	{
		var count = Math.max(arguments.length, 0);
		if (count > instanceCounter) {
			for (var i = instanceCounter; i < count; i++) {
				var slider = attachMovie(STAGE_MC, STAGE_MC + i, getNextHighestDepth(), {
					_alpha: 80
				});
				slider.selectIndicator._alpha = 0;
				stages.push(slider);
			}
		} else if (count < instanceCounter) {
			for (var i = count; i < instanceCounter; i++) {
				stages[i].removeMovieClip();
			}
			stages.splice(count, instanceCounter - count);
		}
		instanceCounter = count;
		if (stages.length == 0) {
			return;
		}
		var distance_between_stages = stages[0]._height * 1.1;
		for (var i = 0; i < stages.length; i++) {
			stages[i]._x = rootCoordinates.x
			stages[i]._alpha = selectedStage == stages[i] ? 100 : 80;
			TweenLite.from(stages[i], 1, {
				_x: stages[i]._x + stages[i]._width,
				_alpha: 0,
				ease: Quint.easeOut
			});
			var argText = arguments[i].name ? arguments[i].name : "$SSL_NextStage";
			stages[i]._y = rootCoordinates.y - stages[i]._height - distance_between_stages * i;
			stages[i].tf1.text = argText;
			stages[i].tf2.text = (i + 1) + "}";
			stages[i].id = arguments[i].id;
			stages[i].onRollOver = function() {
				_parent.selectStage(this, false);
			};
			stages[i].onRelease = function() {
				_parent.selectStage(this, false, true);
			};
		}
	}

	public function setTimer(t: Number)
	{
		trace("Setting timer to " + t);
		timerTimeLine.clear();
		if (t <= 0) {
			timerTimeLine.to(timer, 0.25, { _alpha: 0 });
		} else {
			timerTimeLine
				.to(timer, 0.1, { _width: __timerWidth, _alpha: 100, ease: Linear.easeNone })
				.to(timer, t, { _width: 0, ease: Linear.easeNone });
		}
	}
	
	/* GFX */
	public function handleInputEx(str: String, modes: Boolean, reset: Boolean): Boolean
	{
		switch (str) {
		case KeyType.RIGHT:
			speedControl.changeSpeed(true);
			return true;
		case KeyType.LEFT:
			speedControl.changeSpeed(false);
			return true;
		case KeyType.UP:
			if (selectedStage) {
				var index = getSelectedIndex();
				if (index >= 0) {
					index = (index + 1) % stages.length;
					selectStage(stages[index], reset, false);
					return true;
				}
			}
			if (stages.length > 0) {
				selectStage(stages[0], reset);
				return true;
			}
			break;
		case KeyType.DOWN:
			if (selectedStage) {
				var index = getSelectedIndex();
				if (index >= 0) {
					index = (index - 1 + stages.length) % stages.length;
					selectStage(stages[index], reset, false);
					return true;
				}
			}
			if (stages.length > 0) {
				selectStage(stages[stages.length - 1], reset);
				return true;
			}
			break;
		case KeyType.PAGE_DOWN:
			if (stages.length > 0) {
				selectStage(stages[0], reset);
				return true;
			}
			break;
		case KeyType.PAGE_UP:
			if (stages.length > 0) {
				selectStage(stages[stages.length - 1], reset);
				return true;
			}
			break;
		case KeyType.SELECT:
			if (stages.length > 0 && !selectedStage) {
				selectStage(stages[0], reset);
			}
			advanceStage(reset);
			return true;
		case KeyType.N1:
		case KeyType.N2:
		case KeyType.N3:
		case KeyType.N4:
		case KeyType.N5:
		case KeyType.N6:
		case KeyType.N7:
		case KeyType.N8:
		case KeyType.N9:
			var idx = parseInt(str.charAt(1));
			if (idx > 0 && idx <= stages.length) {
				selectStage(stages[idx - 1], false);
				return true;
			}
			break;
		}
		return false;
	}

	/* PRIVATE */
	private function selectStage(stage: MovieClip, reverse: Boolean, advance: Boolean)
	{
		for (var i = 0; i < stages.length; i++) {
			if (stages[i] == stage) {
				if (selectedStage) {
					TweenLite.to(selectedStage.selectIndicator, 0.2, { _alpha: 0 });
				}
				selectedStage = stage;
				TweenLite.to(stage.selectIndicator, 0.2, { _alpha: 100 });
				if (advance == true) {
					advanceStage(reverse);
				}
				break;
			}
		}
	}

	private function advanceStage(reverse: Boolean)
	{
		var id = selectedStage ? selectedStage.id : "";
		var rev = reverse ? 1 : 0;
		Main.AdvanceScene(id, rev);
	}

	private function getSelectedIndex(): Number
	{
		for (var i = 0; i < stages.length; i++) {
			if (stages[i] == selectedStage) {
				return i;
			}
		}
		return -1;
	}
}
