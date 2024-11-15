import com.greensock.TweenLite;
import com.greensock.TimelineLite;
import com.greensock.easing.*;

class Messages extends MovieClip
{
	/* STAGE */
	var background: MovieClip;

	/* VARIABLES */
	static var MAX_SHOWN: Number = 8;
	static var BLEND_TIME: Number = 0.55;
	static var InstanceCounter: Number = 0;

	var MessageArray: Array;
	var ActiveMessages: Array;
	var ShownCount: Number;
	var iAnimating: Number;
	var ySpacing: Number;

	public function Messages()
	{
		super();
		MessageArray = new Array();
		ShownCount = 0;

		iAnimating = 0;
		ActiveMessages = new Array();
		for (var i = 0; i < Messages.MAX_SHOWN; i++) {
			var obj = new Object();
			ActiveMessages.push(obj);
			obj.timeline = new TimelineLite({_paused:true});
			obj.ready = true;
		}
	}

	public function onLoad()
	{
		ySpacing = (Stage.visibleRect.y + Stage.visibleRect.height - Stage.safeRect.y) / 50;
	}
	
	public function Update()
	{
		if (iAnimating > 0 || MessageArray.length == 0 || ShownCount >= Messages.MAX_SHOWN) {
			return;
		}
		trace("ShowMessage");
		var activeMessage = null;
		for (var i = 0; i < ActiveMessages.length; i++) {
			if (ActiveMessages[i].ready) {
				activeMessage = ActiveMessages[i];
				break;
			}
		}
		if (activeMessage == null) {
			return;
		}
		activeMessage.ready = false;
		iAnimating = 2;

		var newClip = attachMovie("MessageText", "Text" + Messages.InstanceCounter++, getNextHighestDepth(), {_x: background._x, _y: background._y, _alpha: 0});
		activeMessage.clip = newClip;
		TweenLite.to(newClip, BLEND_TIME, {
			_alpha: 100, 
			_y: background._y + ySpacing,
			onComplete: onCreateEnd,
			onCompleteParams: [this, activeMessage]
		});
		newClip.tf1.html = true;
		newClip.tf1.textAutoSize = "shrink";
		newClip.tf1.htmlText = MessageArray.shift();

		var shiftAmount = newClip._height;
		for (var i = 0; i < ActiveMessages.length; i++) {
			if (ActiveMessages[i] != activeMessage && !ActiveMessages[i].ready) {
				TweenLite.to(ActiveMessages[i].clip, BLEND_TIME, {
					_y: ActiveMessages[i].clip._y + shiftAmount
				});
			}
		}
		ShownCount++;
		iAnimating--;
	}

	public function onCreateEnd(__this, activeMessage)
	{
		__this.iAnimating--;

		var timeline = activeMessage.timeline;
		timeline.to(activeMessage.clip, 3.3, {}).to(activeMessage.clip, 0.6, {
			_alpha: 0,
			_x: activeMessage.clip._x + activeMessage.clip._width,
			onComplete: __this.onCreateEndEnd,
			onCompleteParams: [__this, activeMessage]
		});
		timeline.play();
	}

	public function onCreateEndEnd(__this, activeMessage)
	{
		activeMessage.clip.removeMovieClip();
		activeMessage.timeline.clear();
		activeMessage.ready = true;
		__this.ShownCount--;
	}
}