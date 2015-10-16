package {
	import Crew.ICrew;
	import Ship.Node;
	public class Movement {
		public function Movement() {
		}
		
		public var ID:int;
		public var crewMember:ICrew;
		public var fromNode:Node;
		public var toNode:Node;
	}
}