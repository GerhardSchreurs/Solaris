package UI {
	import flash.display.ColorCorrection;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	public class ProgressBase extends Sprite implements IProgress {
		private var _stepsTotal:int;
		private var _stepCurrent:int;
		private var _displayWidth:int;
		private var _displayHeight:int;

		public var colorOn:uint = 0xB30066CC;
		public var colorOff:uint = 0xFF333333;
		public var colorDanger:uint = 0xB3FF0000;
		
		protected function init():void {
			throw new Error("Abstract Method!");
		}
		
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
		
		public function get displayWidth():int {
			return _displayWidth;
		}
		
		public function set displayWidth(value:int):void {
			_displayWidth = value;
		}
		
		public function get displayHeight():int {
			return _displayHeight;
		}
		
		public function set displayHeight(value:int):void {
			_displayHeight = value;
		}
		
		public function ProgressBase() {
			addEventListener(Event.ADDED_TO_STAGE, handleAdded);
		}
		
		public function handleAdded(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, handleAdded);
			init();
		}
	}
}