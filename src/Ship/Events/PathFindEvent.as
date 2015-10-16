package Ship.Events {
	import flash.events.Event;
	public class PathFindEvent extends Event {
		public static const RESULT:String = "gotResult";
		public static const NJAA:String = "njaa";

	    // this is the object you want to pass through your event.
		public var result:Object;
		
		public function PathFindEvent(type:String, result:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.result = result;
		}
		
		 // always create a clone() method for events in case you want to redispatch them.
		public override function clone():Event {
			return new PathFindEvent(type, result, bubbles, cancelable);
		}
	}
}