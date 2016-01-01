package UI {
	import flash.display.MovieClip;
	public class BarComponent extends ProgressBar {
		private var _icon:MovieClip;

		public function BarComponent() {
		}
		
		public function set icon(value:MovieClip):void {
			_icon = value;
			
			_icon.x = 15 - (_icon.width / 2);
			_icon.y = 15 - (_icon.height / 2);
		}
		
		override protected function init():void {
			super.init();
			
			addChild(_icon);
		}
	}
}