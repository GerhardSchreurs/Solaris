package RectangleSelector {
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Wroah
	 */
	public class RectangleSelectionEvent extends Event {
		public function RectangleSelectionEvent (type:String, result:Sprite, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.result = result;
		}

		public static const RESULT:String = "gotResult";

		// this is the object you want to pass through your event.
		public var result:Sprite;

		// always create a clone() method for events in case you want to redispatch them.
		public override function clone():Event {
			return new RectangleSelectionEvent(type, result, bubbles, cancelable);
		}
	}
} 