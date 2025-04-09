intrinsic class SexLabAPI
{
    static function GetOffset(idx: String):Number;
    static function SetOffset(idx: String, value: Number):Void;
    static function ResetOffsets():Void;
	static function GetOffsetStepSize():Number;
    static function AdjustOffsetStepSize(upward:Boolean):Number;
    static function GetAdjustStagenOnly():Boolean;
    static function SetAdjustStageOnly(value: Boolean):Void;

    static function GetActiveFurnitureName():String;
}