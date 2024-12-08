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
			var argText = arguments[i].name ? arguments[i].name : "$SL_NextStage";
			stages[i]._y = rootCoordinates.y - stages[i]._height - distance_between_stages * i;
			stages[i].tf1.text = argText;
			stages[i].tf2.text = (i + 1) + "}";
			stages[i].id = arguments[i].id;
			stages[i].onRollOver = function() {
				_parent.selectStage(this);
			};
			stages[i].onRelease = function() {
				_parent.selectStage(this, true);
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
	public function handleInputEx(details: InputDetails, pathToFocus: Array): Boolean
	{
		return handleInput(details, pathToFocus);
	}

	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		trace("Control.handleInput: " + details.code + ", " + details.navEquivalent + ", " + details.value + ", " + details.controllerIdx + ", " + details.type);
		switch (details.navEquivalent) {
		case NavigationCode.LEFT:
			speedControl.changeSpeed(false);
			return true;
		case NavigationCode.RIGHT:
			speedControl.changeSpeed(true);
			return true;
		case NavigationCode.PAGE_UP:
			if (stages.length > 0) {
				selectStage(stages[stages.length - 1]);
				return true;
			}
			break;
		case NavigationCode.PAGE_DOWN:
			if (stages.length > 0) {
				selectStage(stages[0]);
				return true;
			}
			break;
		case NavigationCode.DOWN:
			if (selectedStage) {
				var index = getSelectedIndex();
				if (index >= 0) {
					index = (index - 1 + stages.length) % stages.length;
					selectStage(stages[index], false);
					return true;
				}
			}
			if (stages.length > 0) {
				selectStage(stages[stages.length - 1]);
				return true;
			}
			break;
		case NavigationCode.UP:
			if (selectedStage) {
				var index = getSelectedIndex();
				if (index >= 0) {
					index = (index + 1) % stages.length;
					selectStage(stages[index], false);
					return true;
				}
			}
			if (stages.length > 0) {
				selectStage(stages[0]);
				return true;
			}
			break;
		case NavigationCode.ENTER:
			if (stages.length > 0 && !selectedStage) {
				selectStage(stages[0]);
			}
			advanceStage();
			return true;
		default:
			{
				var select = function(idx) {
					var targetStage = undefined
					if (stages.length > idx) {
						targetStage = stages[idx];
					}
					if (!targetStage) {
						return false;
					} else if (targetStage == selectedStage) {
						advanceStage();
					} else {
						selectStage(targetStage);
					}
					return true;
				}
				switch (details.code) {
				case 49:
					return select(0);
				case 50:
					return select(1);
				case 51:
					return select(2);
				case 52:
					return select(3);
				case 53:
					return select(4);
				case 54:
					return select(5);
				case 55:
					return select(6);
				case 56:
					return select(7);
				case 57:
					return select(8);
				}
			}
		}
		return false;
	}

	/* PRIVATE */
	private function selectStage(stage: MovieClip, advance: Boolean)
	{
		for (var i = 0; i < stages.length; i++) {
			if (stages[i] == stage) {
				if (selectedStage) {
					TweenLite.to(selectedStage.selectIndicator, 0.2, { _alpha: 0 });
				}
				selectedStage = stage;
				TweenLite.to(stage.selectIndicator, 0.2, { _alpha: 100 });
				if (advance == true) {
					advanceStage();
				}
				break;
			}
		}
	}

	private function advanceStage()
	{
		var id = selectedStage ? selectedStage.id : "";
		skse.SendModEvent("SL_StageAdvance", id, 0);
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
