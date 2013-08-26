package {
  import flash.display.Sprite;
  import flash.events.Event;
	
  public class Hangar extends Sprite {
		public function Hangar() {
			this.addEventListener(Event.REMOVED, handleRemoved, false, 0, true);

			trace('initHangar');
			
			var objBackground:LIB_Hangar = new LIB_Hangar();
			objBackground.name = 'objBackground';;
			addChild(objBackground);
		}
		
		function handleRemoved(e:Event):void {
			dispose();
		}
		
		public function dispose():void {
			this.removeEventListener(Event.REMOVED, handleRemoved);
			//TODO, implement
		}
  }
}