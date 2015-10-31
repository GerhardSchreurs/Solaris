package Ship {
	public class Room {
		public var ID:Number;
		public var nodes:Vector.<Node>;
		
		public function Room() {
			nodes = new Vector.<Node>();
		}
		
		public function addNode(node:Node):void {
			nodes.push(node);
		}
		
		public function highLightOn():void {
			for (var i:int = 0; i < nodes.length; i++) {
				nodes[i].highLightOn();
			}
		}
		
		public function highLightOff():void {
			for (var i:int = 0; i < nodes.length; i++) {
				nodes[i].highLightOff();
			}
		}
	}
}