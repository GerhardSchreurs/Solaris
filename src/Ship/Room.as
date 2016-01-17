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
		
		public var hasAirLock:Boolean;
		public var isOuterRoom:Boolean;
		
		private var _isDisposed:Boolean;
		private var _connectedRooms:Vector.<Room>;
		private var _connectedOpenRooms:Vector.<Room>;

		private var _airLockCount:int;

		
		public function Room() {
			nodes = new Vector.<Node>();
			_connectedRooms = new Vector.<Room>();
			_connectedOpenRooms = new Vector.<Room>();
		}
		
		public function registerAirLock():void {
			hasAirLock = true;
			_airLockCount ++;
		}
		
		public function unregisterAirLock():void {
			_airLockCount --;
		}
		
		public function get connectedRooms():Vector.<Room> {
			return _connectedRooms;
		}
		
		public function get connectedOpenRooms():Vector.<Room> {
			return _connectedOpenRooms;
		}
		
		public function addOpenRoom(room:Room):void {
			trace("Room.addOpenRoom()");
			if (_connectedOpenRooms.indexOf(room) == -1) {
				trace("Room.addOpenRoom() room not found, adding");
				_connectedOpenRooms.push(room);
			}
		}
		
		public function removeOpenRoom(room:Room):void {
			trace("Room.removeOpenRoom()");
			var index:int = _connectedOpenRooms.indexOf(room);
			
			if (index > -1) {
				trace("Room.removeOpenRoom() room found, removing");
				_connectedOpenRooms.splice(index, 1);
			}
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
		
		public function init():void {
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