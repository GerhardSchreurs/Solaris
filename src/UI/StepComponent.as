package UI {
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import UI.IProgress;
	import UI.ProgressStep;
	
	public class StepComponent extends Sprite implements IProgress {
		private var progressStep:ProgressStep;

		private var _icon:Sprite;
		
		public function get stepsTotal():int {
			return progressStep.stepsTotal;
		}
		
		public function set stepsTotal(value:int):void {
			progressStep.stepsTotal = value;
		}
		
		public function get stepCurrent():int {
			return progressStep.stepCurrent;
		}
		
		public function set stepCurrent(value:int):void {
			progressStep.stepCurrent = value;
		}
		
		public function get displayWidth():int {
			return progressStep.displayWidth;
		}
		
		public function set displayWidth(value:int):void {
			progressStep.displayWidth = value;
		}
		
		public function get displayHeight():int {
			return progressStep.displayHeight;
		}
		
		public function set displayHeight(value:int):void {
			progressStep.displayHeight = value;
		}
		
		public function rerender():void {
			progressStep.rerender();
		}
		
		
		public function set icon(value:Sprite):void {
			_icon = value;
			
			_icon.x = 15 - (_icon.width / 2);
			_icon.y = 15 - (_icon.height / 2);

			addChild(_icon);
		}
		
		public function StepComponent() {
			progressStep = new ProgressStep();
			progressStep.x = 32;
			addChild(progressStep);
			
			
			
			//Create our square
			var square:Shape = new Shape();
			square.graphics.lineStyle(1, 0xFFFFFF);
			square.graphics.drawRect(0, 0, 29, 29); 
			square.graphics.endFill();
			
			addChild(square);
		}
	}
}