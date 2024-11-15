import gfx.io.GameDelegate;
import gfx.utils.Delegate;

class Main extends MovieClip
{
	/* STAGE */
	var background:MovieClip;
	var details:MovieClip;
	var messages:MovieClip;
	var sliders:MovieClip;
	var control:MovieClip;

	/* VARIABLES */

	/* FUNCTIONS */
	public function Main()
	{
	}

	public function onLoad()
	{
		_global.gfxExtensions = true;

		setTimeout(Delegate.create(this, test), 1000);
	}

	private function test() {
		// for (var i = 0; i < 10; i++)
		// 	ShowMessage("test 123 very long test because I want to see how it");
	}

	public function onEnterFrame()
	{
		messages.Update();
	}

	public function ShowMessage(message:String)
	{
		messages.MessageArray.push(message);
	}

}