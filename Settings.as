import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;

class Settings extends MovieClip
{


	public function Details()
	{
		// constructor code
	}

	/* GFX */
	public function handleInputEx(details: InputDetails, pathToFocus: Array): Boolean
	{
		return handleInput(details, pathToFocus);
	}

	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		return false;
	}
}