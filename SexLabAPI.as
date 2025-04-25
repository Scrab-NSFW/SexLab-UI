intrinsic class SexLabAPI
{
    static function GetHotkeyCombination(id: String):String;

    static function GetAlternateScenes():Array;
    static function GetActiveFurnitureName():String;
    static function GetOffset(idx: String, id: Number):Number;
    static function ResetOffsets(id: Number):Void;
	static function GetOffsetStepSize():Number;
    static function AdjustOffsetStepSize(upward:Boolean):Number;
    static function GetAdjustStageOnly():Boolean;
    static function SetAdjustStageOnly(value: Boolean):Void;

    static function ToggleAutoPlay():Void;
    static function IsAutoPlay():Boolean;

    static function GetPermutationData(id: Number):String;
    static function SelectNextPermutation(id: Number):Void;
    static function GetGhostMode(id: Number):Boolean;
    static function SetGhostMode(id: Number, ghostMode: Boolean):Void;
    static function GetExpressionName(id: Number):String;
    static function SetExpression(id: Number, expressionId: Number):Void;
    static function GetExpressions(id: Number):Array;
    static function GetVoiceName(id: Number):String;
    static function SetVoice(id: Number, voiceId: Number):Void;
    static function GetVoices(id: Number):Array;
}
