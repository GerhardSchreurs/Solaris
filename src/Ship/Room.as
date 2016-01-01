package Ship {
	public class Room implements IDisposable {
		public var ID:int;
		public var nodes:Vector.<Node>;
		public var width:int;
		public var height:int;
		public var xStart:int = -1;
		public var yStart:int = -1;
		public var xStop:int = -1;
		public var yStop:int = -1;
		
		public var isLeaking:Boolean;
		public var isOuterRoom:Boolean;
		
		private var _isDisposed:Boolean;
		private var _connectedRooms:Vector.<Room>;
		
		public function Room() {
			nodes = new Vector.<Node>();
			_connectedRooms = new Vector.<Room>();
		}
		
		public function triggerLeak() {
			isLeaking = true;
		}
		
		public function get connectedRooms():Vector.<Room> {
			return _connectedRooms;
		}

		public function addNode(node:Node):void {
			nodes.push(node);
			
			if (xStart == -1) {
				xStart = node.X;
				yStart = node.Y;
			} else {
				if (node.X < xStart) {
					xStart = node.X;
				}
				if (node.Y < yStart) {
					yStart = node.Y;
				}
			}
			
			if (node.X > xStop) {
				xStop = node.X;
			}
			if (node.Y > yStop) {
				yStop = node.Y;
			}
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
		
		public function init() {
			width = xStop - xStart + 1;
			height = yStop - yStart + 1;
			
			var currentNode:Node;
			var attachedNode:Node;
			
			for (var i:int = 0; i < nodes.length; i++) {
				currentNode = nodes[i];
				
				if (currentNode.isOuterNode) {
					isOuterRoom = true;
				}
				
				for (var j:int = 0; j < currentNode.connectedWalkableNodes.length; j++) {
					attachedNode = currentNode.connectedWalkableNodes[j];
					
					if (attachedNode.room != this) {
						if (_connectedRooms.indexOf(attachedNode.room) == -1) {
							_connectedRooms.push(attachedNode.room);
							//trace("attaching room " + attachedNode.room.ID + " to " + this.ID);
						}
					}
				}
			}
			
			
			
			
			/*
			var traceAppend:String;
			for (var i:int = 0; i < nodes.length; i++) {
				traceAppend = " ||| x: " + xStart + " - " + xStop + " y: " + yStart + " - " + yStop + " W:" + width + " H:" + height;
				
				trace("Room ID = " + ID + " | Node ID = " + nodes[i].ID + " | x=" + nodes[i].X + " y=" + nodes[i].Y + traceAppend);
			}
			trace("");
			*/	
		}
		
		public function get isDisposed():Boolean {
			return _isDisposed;
		}
		
		public function dispose():void {
			//trace("Room.dispose(" + _isDisposed + ")");
			if (_isDisposed) { return; }
			
			_connectedRooms = null;
			nodes = null;
			
			_isDisposed = true;
		}
	}
}