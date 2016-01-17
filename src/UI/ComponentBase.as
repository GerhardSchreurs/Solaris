package UI {
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ComponentBase extends Sprite {
		private var _displayWidth:int;
		private var _displayHeight:int;

		protected function init():void {
			throw new Error("Abstract Method, must be overridden!");
			
			//Purpose:
			//ComponentBase will call init methods in subclasses once ADDED_TO_SAGE event has fired
			//After this event we know our own width/height and such
		}
		
		public function ComponentBase() {
			addEventListener(Event.ADDED_TO_STAGE, handleAdded);
		}
		
		public function handleAdded(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, handleAdded);
			init();
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
		
	}

}