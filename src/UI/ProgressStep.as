package UI {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	public class ProgressStep extends ProgressBase {
		private var _rectangleOn:Shape;
		private var _rectangleOff:Shape;
		private var _rectangleDanger:Shape;
		private var _rectangleCount:int;
		
		private var _squareWidth:Number = displayWidth / stepsTotal;
		private	var _squareHeight:int = displayHeight;
		private	var _dangerThreshold:int;
		
		public var spacerWidth:int = 2;
		
		public function ProgressStep() {
			_rectangleOn = new Shape();
			_rectangleOff = new Shape();
			_rectangleDanger = new Shape();
		}
		
		private function generateRectangles():void {
			_rectangleOn.graphics.lineStyle(1, 0xFFFFFF);
			_rectangleOn.graphics.beginFill(colorOn, 0.7);
			_rectangleOn.graphics.drawRect(0, 0, displayWidth - 1, displayHeight - 1); // (x spacing, y spacing, width, height)
			_rectangleOn.graphics.endFill();
			
			_rectangleOff.graphics.lineStyle(1, 0xFFFFFF);
			_rectangleOff.graphics.beginFill(colorOff, 1);
			_rectangleOff.graphics.drawRect(0, 0, displayWidth - 1, displayHeight - 1); // (x spacing, y spacing, width, height)
			_rectangleOff.graphics.endFill();
			
			_rectangleDanger.graphics.lineStyle(1, 0xFFFFFF);
			_rectangleDanger.graphics.beginFill(colorDanger, 0.7);
			_rectangleDanger.graphics.drawRect(0, 0, displayWidth - 1, displayHeight - 1); // (x spacing, y spacing, width, height)
			_rectangleDanger.graphics.endFill();					
		}
		
		private function calculate():void {
			_squareWidth = displayWidth / stepsTotal;
			_squareHeight = displayHeight;
			_dangerThreshold = stepsTotal / 4;

			_squareWidth -= spacerWidth;
		}
		
		public function render():void {
			while (this.numChildren > 0) {
				removeChildAt(0);
			}
			
			var rectangle:Shape;
			var currentX:int = 0;
			var currentY:int = 0;
			
			calculate();
			
			for (var i:int = 1; i <= stepsTotal; i++) {
				rectangle = new Shape();
				
				if (i <= _dangerThreshold) {
					if (i > stepCurrent) {
						rectangle.graphics.copyFrom(_rectangleOff.graphics);
					} else if (stepCurrent > _dangerThreshold) {
						rectangle.graphics.copyFrom(_rectangleOn.graphics);
					} else {
						rectangle.graphics.copyFrom(_rectangleDanger.graphics);
					}
				} else {
					if (i <= stepCurrent) {
						rectangle.graphics.copyFrom(_rectangleOn.graphics);
					} else {
						rectangle.graphics.copyFrom(_rectangleOff.graphics);
					}
				}
				
				rectangle.width = _squareWidth;
				rectangle.height = _squareHeight;
				rectangle.x = currentX;
				rectangle.y = currentY;
				addChild(rectangle);
				
				currentX += _squareWidth + spacerWidth;
			}
			
			_rectangleCount = stepsTotal;			
		}
		
		override public function rerender():void {
			trace("rerender" + getQualifiedClassName(this));
			calculate();
			
			trace("dangerThreshold = " + _dangerThreshold);
			
			if (stepsTotal == _rectangleCount) {
				for (var i:int = 1; i <= stepsTotal; i++) {
					var rectangle:Shape = getChildAt(i - 1) as Shape;
					
					if (i <= _dangerThreshold) {
						if (i > stepCurrent) {
							rectangle.graphics.copyFrom(_rectangleOff.graphics);
						} else if (stepCurrent > _dangerThreshold) {
							rectangle.graphics.copyFrom(_rectangleOn.graphics);
						} else {
							rectangle.graphics.copyFrom(_rectangleDanger.graphics);
						}
					} else {
						if (i <= stepCurrent) {
							rectangle.graphics.copyFrom(_rectangleOn.graphics);
						} else {
							rectangle.graphics.copyFrom(_rectangleOff.graphics);
						}
					}
				}
			} else {
				render();
			}
		}
		
		
		override protected function init():void {
			generateRectangles();
			render();
		}
	}
}