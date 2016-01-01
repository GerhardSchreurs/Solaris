package UI {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	
	public class WeaponComponent extends Sprite {
		public var energyStep:ProgressStep;
		public var loadingBar:ProgressBar;
		private var _icon:MovieClip;
		
		public function WeaponComponent() {
			energyStep = new ProgressStep();
			loadingBar = new ProgressBar();
			
			energyStep.displayWidth = 45;
			energyStep.displayHeight = 6;
			energyStep.spacerWidth = -1;
			
			loadingBar.displayWidth = 45;
			loadingBar.displayHeight = 6;
			loadingBar.y = 32;
			
			addChild(energyStep);
			addChild(loadingBar);
			
			//Create our square
			var square:Shape = new Shape();
			square.graphics.lineStyle(1, 0xFFFFFF);
			square.graphics.drawRect(0, 0, 45, 38); 
			square.graphics.endFill();
			
			addChild(square);
		}
		
		public function set icon(value:MovieClip):void {
			_icon = value;
			
			_icon.x = 22- (_icon.width / 2);
			_icon.y = 20 - (_icon.height / 2);

			addChild(_icon);
		}
		
		
		/*
		public function get energyStepsTotal():int {
			return energyStep.stepsTotal;
		}
		
		public function set energyStepsTotal(value:int):void {
			energyStep.stepsTotal = value;
		}
		
		public function get energyStepCurrent():int {
			return energyStep.stepCurrent;
		}
		
		public function set energyStepCurrent(value:int):void {
			energyStep.stepCurrent = value;
		}
		
		public function get energyDisplayWidth():int {
			return energyStep.displayWidth;
		}
		
		public function set energyDisplayWidth(value:int):void {
			energyStep.displayWidth = value;
		}
		
		public function get energyDisplayHeight():int {
			return energyStep.displayHeight;
		}
		
		public function set energyDisplayHeight(value:int):void {
			energyStep.displayHeight = value;
		}
		
		public function energyRerender():void {
			energyStep.rerender();
		}		
		
		public function get loadingStepsTotal():int {
			return loadingBar.stepsTotal;
		}
		
		public function set loadingStepsTotal(value:int):void {
			loadingBar.stepsTotal = value;
		}
		
		public function get loadingStepCurrent():int {
			return loadingBar.stepCurrent;
		}
		
		public function set loadingStepCurrent(value:int):void {
			loadingBar.stepCurrent = value;
		}
		
		public function get loadingDisplayWidth():int {
			return loadingBar.displayWidth;
		}
		
		public function set loadingDisplayWidth(value:int):void {
			loadingBar.displayWidth = value;
		}
		
		public function get loadingDisplayHeight():int {
			return loadingBar.displayHeight;
		}
		
		public function set loadingDisplayHeight(value:int):void {
			loadingBar.displayHeight = value;
		}
		
		public function loadingRerender():void {
			loadingBar.rerender();
		}
		*/
	}
}