package UI {
	import flash.display.ColorCorrection;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	
	public class ProgressBase extends ComponentBase implements IProgress {
		private var _stepsTotal:int;
		private var _stepCurrent:int;

		public var colorOn:uint = 0xB30066CC;
		public var colorOff:uint = 0xFF333333;
		public var colorDanger:uint = 0xB3FF0000;
		
		public function rerender():void {
			throw new Error("Implement in encapsulating class!");
		}
		
		public function get stepsTotal():int {
			return _stepsTotal;
		}
		
		public function set stepsTotal(value:int):void {
			_stepsTotal = value;
		}
		
		public function get stepCurrent():int {
			return _stepCurrent;
		}
		
		public function set stepCurrent(value:int):void {
			_stepCurrent = value;
		}
		
		public function ProgressBase() {
		}
	}
}