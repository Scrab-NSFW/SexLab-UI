
class MenuRight2 extends MovieClip
{
	/* STAGE ELEMENTS */

	public var furnitureType: MovieClip;
	
	public var stepSize: MovieClip;
	public var stageOnly: MovieClip;
	public var resetOffsets: MovieClip;

	public var xOffset: MovieClip;
	public var yOffset: MovieClip;
	public var zOffset: MovieClip;
	public var rOffset: MovieClip;

	/* PRIVATE VARIABLES */

	private var selectables: Array;
	private var activeSelectionIndex: Number = 0;

	/* INITIALIZATION */
	public function MenuRight2()
	{
		selectables = [
			stepSize,
			stageOnly,
			resetOffsets
		];
	}

	public function setDefault()
	{
		stepSize.setSelected(true);
		activeSelectionIndex = 0;
	}

	public function resetSelection()
	{
		selectables[activeSelectionIndex].setSelected(false);
		activeSelectionIndex = -1;
	}

	public function updateFields()
	{
		furnitureType.init({ name: "$SSL_ActiveFurniture", extra: "", selected: false });

		stepSize.init({ name: "$SSL_StepSize", extra: "0.5", selected: false });
		stageOnly.init({ name: "$SSL_StageOnly", extra: "N", selected: false });
		resetOffsets.init({ name: "$SSL_ResetOffsets", extra: "", selected: false });

		xOffset.init({ name: "X", content: "13.5", selected: false });
		yOffset.init({ name: "Y", content: "13.5", selected: false });
		zOffset.init({ name: "Z", content: "13.5", selected: false });
		rOffset.init({ name: "R", content: "13.5", selected: false });
	}
	
	public function handleInputEx(keyStr: String, modes: Boolean, reset: Boolean): Boolean
	{
		switch (keyStr) {
		case KeyType.PAGE_UP:
			selectables[activeSelectionIndex].setSelected(false);
			activeSelectionIndex = 0;
			selectables[activeSelectionIndex].setSelected(true);
			return true;
		case KeyType.PAGE_DOWN:
			selectables[activeSelectionIndex].setSelected(false);
			activeSelectionIndex = selectables.length - 1;
			selectables[activeSelectionIndex].setSelected(true);
			return true;
		case KeyType.UP:
			selectables[activeSelectionIndex].setSelected(false);
			activeSelectionIndex = (activeSelectionIndex - 1 + selectables.length) % selectables.length;
			selectables[activeSelectionIndex].setSelected(true);
			return true;
		case KeyType.DOWN:
			selectables[activeSelectionIndex].setSelected(false);
			activeSelectionIndex = (activeSelectionIndex + 1) % selectables.length;
			selectables[activeSelectionIndex].setSelected(true);
			return true;
		case KeyType.SELECT:
			{
				var selection = selectables[activeSelectionIndex];
				if (selection == stepSize) {
					// TODO: increase/reduce stepsize
				} else if (selection == stageOnly) {
					// TODO: toggle stage only
				} else if (selection == resetOffsets) {
					// TODO: reset offsets
				}
				return true;
			}
		default:
			return false;
		}
	}

}