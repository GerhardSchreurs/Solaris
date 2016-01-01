package UI {
	import flash.display.MovieClip;
	import flash.display.Shape;
	
	public class MainStatus extends ProgressStep {
		private var _icon:MovieClip;
		private var _square:Shape;
		
		public function MainStatus() {
			//Create our square
			_square = new Shape();
			_square.graphics.lineStyle(1, 0xFFFFFF);
			_square.graphics.drawRect(0, 0, 30, 38); 
			_square.graphics.endFill();
			
		}
		
		public function set icon(value:MovieClip):void {
			_icon = value;
			
			_icon.x = 15 - (_icon.width / 2);
			_icon.y = 20 - (_icon.height / 2);
		}
		
		override protected function init():void {
			super.init();
			
			addChild(_square);
			addChild(_icon);
		}
	}
}