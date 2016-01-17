package UI {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	public class ProgressBar extends ProgressStep {

		private var _rectangleHolder:Shape;
		private var _rectangleProgress:Shape;
		
		public function ProgressBar() {
			_rectangleHolder = new Shape();
			_rectangleProgress = new Shape();
		}
		
		override public function rerender():void {
			drawProgress();
		}
		
		private function drawProgress():void {
			var width:int = (displayWidth / stepsTotal) * stepCurrent - 2;
			
			_rectangleProgress.graphics.clear();
			_rectangleProgress.graphics.beginFill(colorOn, 0.7);
			_rectangleProgress.graphics.drawRect(2, 2, width, displayHeight - 2);
			_rectangleProgress.graphics.endFill();
		}
		
		private function generateRectangles():void {
			_rectangleHolder.graphics.lineStyle(1, 0xFFFFFF);
			_rectangleHolder.graphics.drawRect(0, 0, displayWidth, displayHeight);
			_rectangleHolder.graphics.endFill();
		}
		
		override protected function init():void {
			generateRectangles();
			drawProgress();
			
			addChild(_rectangleHolder);
			addChild(_rectangleProgress);
		}
	}
}