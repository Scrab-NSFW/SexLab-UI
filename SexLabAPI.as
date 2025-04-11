intrinsic class SexLabAPI
{
    static function GetHotkeyCombination(id: String):String;

    static function GetActiveSceneName():String;
    static function GetActiveSceneAuthor():String;
    static function GetActiveSceneOrigin():String;
    static function GetActiveSceneTags():String;
    static function GetActiveAnnotations():String;
    static function SetActiveSceneAnnotations(annotations: String):Void;

    static function GetOffset(idx: String, id: Number):Number;
    static function SetOffset(idx: String, value: Number, id: Number):Void;
    static function ResetOffsets(id: Number):Void;
	static function GetOffsetStepSize():Number;
    static function AdjustOffsetStepSize(upward:Boolean):Number;
    static function GetAdjustStageOnly():Boolean;
    static function SetAdjustStageOnly(value: Boolean):Void;

    static function GetActiveFurnitureName():String;

    static function GetAlternateScenes():Array;
    static function SetActiveScene(id: String):Void;
    static function PickRandomScene():Void;

    static function ToggleAnimationPaused():Void;
    static function ToggleAutoPlay():Void;
    static function IsAutoPlay():Boolean;
    static function MoveScene():Void;
    static function EndScene():Void;

    static function GetPermutationData(id: Number):Object;
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