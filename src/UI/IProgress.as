package UI {
	public interface IProgress {
		function get stepsTotal():int;
		function set stepsTotal(value:int):void;
		
		function get stepCurrent():int;
		function set stepCurrent(value:int):void;
		
		function get displayWidth():int;
		function set displayWidth(value:int):void;
		
		function get displayHeight():int;
		function set displayHeight(value:int):void;
		
		function rerender():void;
	}
}