import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;

class Settings extends MovieClip
{
	/* STAGE ELEMENTS */

	/* PRIVATE VARIABLES */
	private var active: Boolean;


	public function Settings()
	{
		active = false;
	}

	/* GFX */
	public function handleInputEx(keyStr: String, modes: Boolean, reset: Boolean): Boolean
	{
		return active ? handleActiveInput(keyStr, modes, reset) : handleInactiveInput(keyStr);
	}

	private function handleInactiveInput(keyStr: String, modes: Boolean, reset: Boolean): Boolean
	{
		active = modes && (keyStr == KeyType.EXTRA1 || keyStr == KeyType.EXTRA2);
		// this.gotoAndPlay(active ? "open" : "close");
		return active;
	}

	private function handleActiveInput(keyStr: String, modes: Boolean, reset: Boolean): Boolean
	{
		if (keyStr == KeyType.END) {
			active = false;
			//this.gotoAndPlay("close");
			return true;
		}
		return false;
	}

}