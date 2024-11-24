import com.greensock.TweenLite;
import com.greensock.TimelineLite;
import com.greensock.easing.*;
import gfx.ui.NavigationCode;
import gfx.ui.InputDetails;
import KeyMap

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

	var __timerWidth: Number;
	var timerTimeLine: TimelineLite;


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
		trace("Setting " + arguments.length + " stages");
		var t = arguments[0];
		timerTimeLine.clear();
		if (t <= 0) {
			timerTimeLine.to(timer, 0.4, { _alpha: 0 });
		} else {
			timerTimeLine
				.to(timer, 0.3, { _width: __timerWidth, _alpha: 100, ease: Linear.easeNone })
				.to(timer, t, { _width: 0, ease: Linear.easeNone });
		}

		var count = Math.max(arguments.length - 1, 0);
		if (count > instanceCounter) {
			for (var i = instanceCounter; i < count; i++) {
				var slider = attachMovie(STAGE_MC, STAGE_MC + i, getNextHighestDepth(), {
					_x: rootCoordinates.x,
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
		if (stages.length == 0) {
			return;
		}
		var distance_between_stages = stages[0]._height * 1.1;
		for (var i = 0; i < stages.length; i++) {
			TweenLite.from(stages[i], 1, {
				_x: stages[i]._x + stages[i]._width,
				_alpha: 0,
				ease: Quint.easeOut
			});
			stages[i]._y = rootCoordinates.y - stages[i]._height - distance_between_stages * i;
			stages[i].tf1.text = (i + 1) + "} " + arguments[i + 1].name;
			stages[i].id = arguments[i + 1].id;
			stages[i].onRollOver = function() {
				_parent.selectStage(this);
			};
			stages[i].onRelease = function() {
				_parent.selectStage(this, true);
			};
		}
		instanceCounter = count;
	}
	
	/* GFX */
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		switch (details.navEquivalent) {
		case NavigationCode.RIGHT:
		case NavigationCode.PAGE_DOWN:
			if (stages.length > 0) {
				selectStage(stages[stages.length - 1]);
				return true;
			}
			break;
		case NavigationCode.LEFT:
		case NavigationCode.PAGE_UP:
			if (stages.length > 0) {
				selectStage(stages[0]);
				return true;
			}
			break;
		case NavigationCode.UP:
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
		case NavigationCode.DOWN:
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
			if (selectedStage) {
				advanceStage();
			}
			return true;
		default:
			{
				var str = KeyMap.string_from_gfx(details.code)
				var select = function(idx) {
					if (stages.length > idx) {
						selectStage(stages[idx]);
						return true;
					}
					return false;
				}
				switch (str) {
				case "1":
					return select(0);
				case "2":
					return select(1);
				case "3":	
					return select(2);
				case "4":
					return select(3);
				case "5":
					return select(4);
				case "6":
					return select(5);
				case "7":
					return select(6);
				case "8":
					return select(7);
				case "9":
					return select(8);
				}
			}
		}
		return false;
	}

	/* PRIVATE */
	private function selectStage(stage: MovieClip, advance: Boolean)
	{
		if (stage == selectedStage) {
			advanceStage();
			return;
		}
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
		skse.SendModEvent("SL_StageAdvance", selectedStage.id, 0);
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