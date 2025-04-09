
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

	private var stepSizeValue: Number = 0.5;
	private var stageOnlyValue: Boolean = false;

	/* INITIALIZATION */
	public function MenuRight2()
	{
		selectables = [
			stepSize,
			stageOnly,
			resetOffsets,
			xOffset,
			zOffset,
			yOffset,
			rOffset
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
		stepSizeValue = SexLabAPI.GetOffsetStepSize();
		if (stepSizeValue == undefined) stepSizeValue = 0.5;	// Test value
		stageOnlyValue = SexLabAPI.GetAdjustStagenOnly() || true;

		furnitureType.init({ name: "$SSL_ActiveFurniture{" + SexLabAPI.GetActiveFurnitureName() + "}" });

		stepSize.init({ name: "$SSL_StepSize", extra: stepSizeValue.toString() });
		stageOnly.init({ name: "$SSL_StageOnly", extra: stageOnlyValue });
		resetOffsets.init({ name: "$SSL_ResetOffsets" });

		xOffset.init({ name: "X" });
		yOffset.init({ name: "Y" });
		zOffset.init({ name: "Z" });
		rOffset.init({ name: "R" });
	}
	
	public function handleInputEx(keyStr: String, modes: Boolean, reset: Boolean): Boolean
	{
		var selection = selectables[activeSelectionIndex];
		if (selection.hasFocus != undefined && selection.hasFocus()) {
			if (keyStr == KeyType.END)
				selection.endInput();
			return true;
		}
		switch (keyStr) {
		case KeyType.PAGE_UP:
			selection.setSelected(false);
			activeSelectionIndex = 0;
			selectables[activeSelectionIndex].setSelected(true);
			return true;
		case KeyType.PAGE_DOWN:
			selection.setSelected(false);
			activeSelectionIndex = selectables.length - 1;
			selectables[activeSelectionIndex].setSelected(true);
			return true;
		case KeyType.UP:
			if (selection.endInput != undefined && modes) {
				selection.adjustOffset(stepSizeValue, true);
				return true;
			}
			selection.setSelected(false);
			activeSelectionIndex = (activeSelectionIndex - 1 + selectables.length) % selectables.length;
			selectables[activeSelectionIndex].setSelected(true);
			return true;
		case KeyType.DOWN:
			if (selection.endInput != undefined && modes) {
				selection.adjustOffset(stepSizeValue, false);
				return true;
			}
			selection.setSelected(false);
			activeSelectionIndex = (activeSelectionIndex + 1) % selectables.length;
			selectables[activeSelectionIndex].setSelected(true);
			return true;
		case KeyType.SELECT:
			if (selection == stepSize) {
				selection.adjustOffset(stepSizeValue, !reset);
				updateFields();
			} else if (selection == stageOnly) {
				SexLabAPI.SetAdjustStageOnly(!stageOnlyValue);
				updateFields();
			} else if (selection == resetOffsets) {
				SexLabAPI.ResetOffsets();
				updateFields();
			} else if (selection.setFocus != undefined) {
				selection.setFocus();
			}
			return true;
		default:
			return false;
		}
	}

}