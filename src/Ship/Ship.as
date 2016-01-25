package Ship {
	//{ Imports
	import flash.display.SpreadMethod;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import Crew.Crew;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetDataEvent;
	import RectangleSelector.RectangleSelector;
	import RectangleSelector.RectangleSelectionEvent;
	import Ship.Events.PathFindEvent;
	import flash.display.Sprite;
    import flash.geom.Point;
	import State.*;
	import flash.utils.getTimer;
	import State.States.Walk;

	//}  
	
	public class Ship extends Sprite implements IDisposable {
		//TODO: improvements possible by reusing vector and other objects instead of recreating them!!!
		//TODO: reversed forward loops
		
		private var _stopNode:Node;
		private var _shipName:String;
		private var _shipLayout:Sprite;
		private var _airLockCount:int;
		private var _nodes:Vector.<Node>;
		private var _nodesLength:int;
		private var _roomsLength:int;
		private var _crewLength:int;
		private var _leakingNodesLength:int;
		private var _rooms:Vector.<Room>;
		private var _crew:Vector.<Crew>;
		private var _nodeIndex:Number = 0;
		private var _crewIndex:Number = 0;
		private var _roomIndex:Number = 0;
		private var _offsetMapX:Number;
		private var _offsetMapY:Number;
		private var _selectedCrewMembers:Vector.<Crew>;
		private var _selectedNodes:Vector.<Node>;
		private var _selectedNode:Node;
		private var _isDisposed:Boolean;
		
		private var _rectangleSelector:RectangleSelector;
		private var _timer:uint;
		private var _frameCounter:int;
		
		//NEW
		protected var _statHealthMax:int
		protected var _statHealthNow:int;
		protected var _statShieldMax:int;
		protected var _statShieldNow:int;
		protected var _statOxygenMax:int;
		protected var _statOxygenNow:int;
		
		/*
		private var _statFuelLevel:int;
		private var _statFuelCount:int;
		private var _statEvasionCount:int;
		private var _statRocketCount:int;
		private var _statDroidCount:int;
		*/
		
		public function get statHealthMax():int {
			return _statHealthMax;
		}
		
		public function set statHealthMax(value:int):void {
			_statHealthMax = value;
		}
		
		public function get statHealthNow():int {
			return _statHealthNow;
		}
		
		public function set statHealthNow(value:int):void {
			_statHealthNow = value;
		}
		
		public function get statShieldMax():int {
			return _statShieldMax;
		}
		
		public function set statShieldMax(value:int):void {
			_statShieldMax = value;
		}
		
		public function get statShieldNow():int {
			return _statShieldNow;
		}
		
		public function set statShieldNow(value:int):void {
			_statShieldNow = value;
		}
		
		public function get statOxygenMax():int {
			return _statOxygenMax;
		}
		
		public function set statOxygenMax(value:int):void {
			_statOxygenMax = value;
		}
		
		public function get statOxygenNow():int {
			return _statOxygenNow;
		}
		
		public function set statOxygenNow(value:int):void {
			_statOxygenNow = value;
		}
		
		var _openRooms:Vector.<Room> = new Vector.<Room>();
		
		internal function registerAirLock():void {
			_airLockCount ++;
		}
		internal function unregisterAirLock():void {
			_airLockCount --;
			
			if (_airLockCount == 0) {
				_leakingNodesLength = 0;
			}
		}
		
		internal function queryStatus(node:Node):void  {
			if (_airLockCount == 0) {
				return;
			}
			
			var room:Room = node.room;
			_openRooms.length = 0;
			_leakingNodesLength = 0;
			traverseRooms(room);
			
			trace("numberOfLeakingNodes = " + _leakingNodesLength);
			trace("_openRooms.length = " + _openRooms.length);			
		}
		
		
		private function traverseRooms(room:Room):void {
			_openRooms.push(room);
			
			var i:int = 0;
			var count:int = room.connectedOpenRooms.length;
			_leakingNodesLength += room.nodes.length;
			
			for (i = 0; i < count; i++) {
				if (_openRooms.indexOf(room.connectedOpenRooms[i]) == -1) {
					traverseRooms(room.connectedOpenRooms[i]);
				}
			}
		}
		
		
		//END NEW
		
		
		
		
		
		
		private function stopWatch():void {
			_timer = getTimer();
		}
		
		private function stopWatchTrace(value:String):void {
			trace("STOPWATCH (" + value + ") :: " + (getTimer() - _timer) + "ms"); 
		}
		
		
		public function Ship() {
			_nodes = new Vector.<Node>();
			_crew = new Vector.<Crew>();
			_rooms = new Vector.<Room>();
			_selectedCrewMembers = new Vector.<Crew>();
			_selectedNodes = new Vector.<Node>();
			
			addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, false);
			addEventListener(Event.REMOVED, handleRemoved, false, 0, true);
		}

		//{ Assessors
		public function get mapOffsetX():Number {
			return _offsetMapX;
		}

		public function get mapOffsetY():Number {
			return _offsetMapY;
		}

		public function set mapOffsetX(value:Number):void {
			_offsetMapX = value;
		}

		public function set mapOffsetY(value:Number):void {
			_offsetMapY = value;
		}
		
		public function get nodes():Vector.<Node> {
			return _nodes;
		}
		
		public function get shipName():String {
			return _shipName;
		}
		
		public function set shipName(value:String):void {
			_shipName = value;
		}
		
		public function get shipLayout():Sprite {
			return _shipLayout;
		}
		
		public function set shipLayout(value:Sprite):void {
			_shipLayout = value;
		}
		
		public function get shipCrew():Vector.<Crew> {
			return _crew;
		}
		
		public function get rectangleSelector():RectangleSelector {
			return _rectangleSelector;
		}
		
		public function set rectangleSelector(value:RectangleSelector):void {
			_rectangleSelector = value;
			_rectangleSelector.addEventListener(RectangleSelectionEvent.RESULT, handleRectangleSelection);
		}
		//}
		
		//{ Crew init
		protected function constructCrew():void { };
		
		protected function addCrew(crew:Crew, nodeIndex:Number):void {
			crew.ID = _crewIndex;
			crew.node = _nodes[nodeIndex];
			_crew.push(crew);
			
			var crewLayout:MovieClip = crew.crewLayout;
			crewLayout.name = _crewIndex.toString();
			crewLayout.x = (_nodes[nodeIndex].X * DEFAULTS.NodeSize) + _offsetMapX + DEFAULTS.CrewOffset;
			crewLayout.y = (_nodes[nodeIndex].Y * DEFAULTS.NodeSize) + _offsetMapY + DEFAULTS.CrewOffset;
			crewLayout.addEventListener(MouseEvent.CLICK, handleCrewClick);
			//TODO: do not forget to removeListener
			
			_crewIndex += 1;
			_shipLayout.addChild(crew.crewLayout);
		}		

		//}
		
		//{ Node init
		protected function constructNodes():void { 
			trace("0:IShip.constructNodes() " + this.shipName);
		}
		
		protected function generateNode(x:Number, y:Number):Node {
			var node:Node = new Node();
			node.ship = this;
			node.ID = _nodeIndex;
			node.X = x;
			node.Y = y;
			_nodeIndex += 1;
			return node;
		}
		
		protected function generateRoom():void {
			var room:Room = new Room();
			room.ID = _roomIndex;
			_rooms.push(room); 
			_roomIndex += 1;
		}
		
		protected function addNode(node:Node):void {
			_nodes.push(node);
			_rooms[_rooms.length - 1].addNode(node);
			node.room = _rooms[_rooms.length - 1];
			_shipLayout.addChild(node.layout);
			
			node.layout.x = (node.X * DEFAULTS.NodeSize) + _offsetMapX;
			node.layout.y = (node.Y * DEFAULTS.NodeSize) + _offsetMapY;
			node.layout.name = node.ID.toString();
			node.layout.addEventListener(MouseEvent.RIGHT_CLICK, handleNodeRightClick);
		}
		
		protected function initNodeArray(nodeArray:Array):void {
			for each (var node:Node in _nodes) {
				if (nodeArray[node.Y] == undefined) {
					nodeArray[node.Y] = new Array()
				}
				nodeArray[node.Y][node.X] = node;
			}
		}
		
		protected function initNodeNeighbours(nodeArray:Array, node:Node):void {
			var testX:Number;
			var testY:Number;
			
			//TOP
			testY = node.Y - 1;
			
			if (testY >= 0) {
				//TOP L
				testX = node.X - 1;
				
				if (testX >= 0) {
					node.TOPLnode = nodeArray[testY][testX];
				}
				
				//TOP C
				testX = node.X;
				node.TOPCnode = nodeArray[testY][testX];
				
				//TOP R
				testX = node.X + 1;
				
				if (testX < nodeArray[testY].length) {
					node.TOPRnode = nodeArray[testY][testX];
				}
			}
			
			//MID
			testY = node.Y;
			
			//MID L
			testX = node.X - 1;
			
			if (testX >= 0) {
				node.MIDLnode = nodeArray[testY][testX];
			}
			
			//MID R
			testX = node.X + 1;
			
			if (testX < nodeArray[testY].length) {
				node.MIDRnode = nodeArray[testY][testX];
			}
			
			//BOT
			testY = node.Y + 1;
			
			if (testY < nodeArray.length) {
				//BOT L
				testX = node.X - 1;
				
				if (testX >= 0) {
					node.BOTLnode = nodeArray[testY][testX];
				}
				
				//BOT C
				testX = node.X;
				node.BOTCnode = nodeArray[testY][testX];
				
				//BOT R
				testX = node.X + 1;
				if (testX < nodeArray[testY].length) {
					node.BOTRnode = nodeArray[testY][testX];
				}
			}		
		}
		
		protected function initShip():void {
			trace("0:IShip.initShip() " + this.shipName);
			
			var nodeArray:Array = new Array();
			var currentX:Number = 0;
			var currentY:Number = -1;
			
			//Fills nodeArray[x][y] so that we can reference a node by x,y
			//Example: node = nodeArray[10][4];
			initNodeArray(nodeArray);
			
			_nodesLength = _nodes.length;
			_roomsLength = _rooms.length;
			_crewLength = _crew.length;
			
			_statOxygenMax = _nodesLength;
			_statOxygenNow = _nodesLength;
			
			
			var i:int;
			
			for (i = _nodesLength; i--;) {
				var node:Node = _nodes[i];
				node.layout.fldID.text = node.ID.toString();
				initNodeNeighbours(nodeArray, node);
				node.init();
			}
			
			for (i = _roomsLength; i--;) {
				var room:Room = _rooms[i];
				room.init();
			}
			
			//testNodeOut(_nodes[2]);
			//testRoomOut(_rooms[1]);
		}
		//}
		
		//{ Debug
		public function tracePath(path:Vector.<Node>):void {
			//DISABLED
			return;
			var traceLog:String = "";
			
			for (var i:int = 0; i < path.length; i++) {
				traceLog += "tracePath : ID = " + path[i].ID + "\n";
			}
			
			trace(traceLog);
		}
		
		public function testRoomsOut():void {
			for (var i:int = 0; i < _rooms.length; i++) {
				testRoomOut(_rooms[i]);
			}
		}

		public function testRoomOut(room:Room):void {
			trace("testing room " + room.ID + " (" + room.nodes[0].ID + "), is outer room: " + room.isOuterRoom);
			
			var i:int;
			
			for (i = 0; i < room.connectedRooms.length; i++) {
				trace("connected room " + room.connectedRooms[i].ID + " (" + room.connectedRooms[i].nodes[0].ID + ")");
			}
			for (i = 0; i < room.connectedOpenRooms.length; i++) {
				trace("4:connectedOPEN room " + room.connectedOpenRooms[i].ID + " (" + room.connectedOpenRooms[i].nodes[0].ID + ")");
			}
			
			
			trace("");
		}
		
		public function testNodeOut(node:Node):void {
			trace("testing node ID : " + node.ID + " [x:" + node.X + " | y:" + node.Y + "]");
			
			trace("TOPL = " + node.canTOPL);
			trace("TOPC = " + node.canTOPC);
			trace("TOPR = " + node.canTOPR);
			trace("MIDL = " + node.canMIDL);
			trace("MIDR = " + node.canMIDR);
			trace("BOTL = " + node.canBOTL);
			trace("BOTC = " + node.canBOTC);
			trace("BOTR = " + node.canBOTR);
			trace("");
		}
		
		public function runVeryLong():void {
			var x:int = 0;
			
			for (var i:int = 0; i < 100000000; i++) {
				x += 1;
			}
		}
		//}
		
		//{ Event handlers
		public function handleCrewClick(e:MouseEvent):void {
			//deselect crew
			for (var i:int = 0; i < _selectedCrewMembers.length; i++) {
				_selectedCrewMembers[i].deselectMember();
			}
			
			var crewLayout:MovieClip = e.currentTarget as MovieClip;
			var crewMember:Crew = _crew[Number(crewLayout.name)];
			
			crewMember.selectMember();
			_selectedCrewMembers.push(crewMember);
			
			trace(crewLayout.name);
			
			
			//var crewID:Number = Number((e.currentTarget as MovieClip).name);
			//var crew:ICrew = _crew[crewID];
			
			trace(crewLayout);
		}
		
		private function handleRemoved(e:Event):void {
			dispose();
		}
		
		public function handleRectangleSelection(e:RectangleSelectionEvent):void {
			for (var i:int = 0; i < _crew.length; i++) {
				if (_crew[i].crewLayout.hitTestObject(e.result)) {
					_crew[i].selectMember();
				} else {
					_crew[i].deselectMember();
				}
			}
		}
		
		private function filterSelectedCrewMembers(element:Crew, index:int, array:Vector.<Crew>):Boolean {
			return (element.isSelected);
		}
		
		private function handleNodeRightClick(e:MouseEvent):void {
			stopWatch();
			
			hideNodePoints();

			_selectedCrewMembers.length = 0;
			_selectedCrewMembers = _crew.filter(filterSelectedCrewMembers);
			
			if (_selectedCrewMembers.length > 0) {
				var targetNode:String = MovieClip(e.target).parent.name;
				
				if (isNaN(Number(targetNode))) {
					//sometimes, something like instance144 for whatever reason
					trace("4:targetNode NaN");
					return;
				}
				
				var clickedNode:Node = _nodes[Number(targetNode)];
				
				if (_selectedCrewMembers.length == 1) {
					_selectedNodes.push(clickedNode);
					clickedNode.showPoint();
					
					//_selectedCrewMembers[0].Path = pathFind(_selectedCrewMembers[0].node, clickedNode);
					_selectedCrewMembers[0].stateMachine.changeState(new Walk(_selectedCrewMembers[0], pathFind(_selectedCrewMembers[0].node, clickedNode)));
				} else {
					//now, since we have multiple selected crewmembers, we need to get all nodes that are neighbour of clickedNode
					var neighbourNodes:Vector.<Node> = clickedNode.getNeighbourNodes();
					
					for (var i:int = 0; i < _selectedCrewMembers.length; i++) {
						if ((i < neighbourNodes.length) && (neighbourNodes[i] != undefined)) {
							neighbourNodes[i].showPoint();
							_selectedNodes.push(neighbourNodes[i]);
							//_selectedCrewMembers[i].path = pathFind(_selectedCrewMembers[i].node, neighbourNodes[i]);
							//_selectedCrewMembers[i].Path = pathFind(_selectedCrewMembers[i].node, neighbourNodes[i]);
							
							
							_selectedCrewMembers[i].stateMachine.changeState(new Walk(_selectedCrewMembers[i], pathFind(_selectedCrewMembers[i].node, clickedNode)));

						
							} else {
							//_selectedCrewMembers[i].deselectMember();
						}
					}
				}
				
				
				_selectedNode = clickedNode;
				stopWatchTrace("pathFind");
			}
		}
		//}
		
		private function handleEnterFrame(e:Event):void {
			var testing:Boolean = true;
			var i:int = 0;
			
			_frameCounter ++;
			
			if (_frameCounter > DEFAULTS.FrameRate) {
				_frameCounter = 0;
			}
			
			//rooms
			for (i = _roomsLength; i--; ) {
				_rooms[i].update(_frameCounter);
			}
			
			//crew
			for (i = _crewLength; i--; ) {
				//Notice! (_crew[i] as Agent).update!!!!
				
				_crew[i].update(_frameCounter);
				_crew[i].enterFrame(_frameCounter);
			}

			
			/* UNCOMMENTEN OM AIRLOCK TE HERSTELLEN!
			if (_airLockCount > 0) {
				_statOxygenNow = _nodesLength - _leakingNodesLength;
			} else {
				_statOxygenNow = _nodesLength;
			}
			*/
		}

		
		//{ Pathfinding
		public function pathFind(startNode:Node, stopNode:Node):Vector.<Node> {
			//TODO: Optimise? better to set length to null in global variable than reinit
			var openNodes:Vector.<Node> = new Vector.<Node>();
			
			//add our startNode to the openNodes
			openNodes.push(startNode);
			
			//Do our pathFinding
			openNodes = pathFindOpenNodes(openNodes, startNode, stopNode);
			
			//Reset startNode
			startNode.parentNode = null;
			
			var path:Vector.<Node> = new Vector.<Node>();
				
			startNode.parentNode = null;
				
			while (stopNode.parentNode != null) {
				path.push(stopNode);
				stopNode = stopNode.parentNode;
			}
			
			path.push(stopNode);
			path.reverse();
			tracePath(path);
			
			clearNodes();
			
			//Clear nodes, when?
			return path;
		}
		
		public function pathFindOpenNodes(openNodes:Vector.<Node>, startNode:Node, stopNode:Node):Vector.<Node> {
			var openNode:Node;
			var attachedNode:Node;
			var attachedNodes:Vector.<Node> = new Vector.<Node>;
			var foundStopNode:Boolean = false;
			
			for (var i:int = 0; i < openNodes.length; i++) {
				openNode = openNodes[i];
				
				//loop through all attached nodes in openNode
				for (var j:int = 0; j < openNode.connectedWalkableNodes.length; j++) {
					attachedNode = openNode.connectedWalkableNodes[j];
					
					if (attachedNode == stopNode) {
						//trace('attachedNode == stopNode');
						attachedNode.parentNode = openNode;
						foundStopNode = true;
						break;
					} else if (attachedNode.isDeadEnd) {
						//trace('attachedNode.isDeadEnd');
					} else if (attachedNode.parentNode != null) {
						//trace('attachedNode.parentNode != null');
					} else {
						attachedNodes.push(attachedNode);
						attachedNode.parentNode = openNode;
					}
				}
				
				if (foundStopNode) {
					break;
				}
			}
			
			openNodes = attachedNodes;
			
			if (foundStopNode == false) {
				pathFindOpenNodes(openNodes, startNode, stopNode);
			}
			
			return openNodes;
		}
		//}
		
		private function showNodePoints():void {
			for (var i:int = 0; i < _selectedNodes.length; i++) {
				_selectedNodes[i].showPoint();
			}			
		}
		
		private function hideNodePoints():void {
			for (var i:int = 0; i < _selectedNodes.length; i++) {
				_selectedNodes[i].hidePoint();
			}
		}

		public function clearNodes():void {
			for (var i:Number = 0; i < _nodes.length; i++) {
				_nodes[i].clearNode();
			}
		}
		
		public function moveToPoint(obj:Object, target:Point, speed:Number = 1, objRot:Boolean = false):void {
			// get the difference between obj and target points.
			var diff:Point = target.subtract(new Point(obj.x, obj.y)); 
			var dist:Number = diff.length;
			
			// if we will go past when we move just put it in place.
			if (dist <= speed) {
				obj.x = target.x;
				obj.y = target.y;
			} else  { 
			// If we are not there yet. Keep moving.	
				diff.normalize(1);
				obj.x += diff.x * speed;
				obj.y += diff.y * speed;
				
				// If we want to rotate with our movement direction.
				if (objRot)  { 
					obj.rotation = Math.atan2(diff.y, diff.x) * (180 / Math.PI) + 90;
				}
			}
		}
		
		//{ Dispose
		public function get isDisposed():Boolean {
			return _isDisposed;
		}
		
		public function dispose():void {
			trace("Ship.dispose(" + _isDisposed + ") (" + shipName + ")");
			
			if (_isDisposed) {
				return;
			}
			
			var count:int;
			var i:int;

			removeEventListener(Event.REMOVED, handleRemoved);
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
			_rectangleSelector.removeEventListener(RectangleSelectionEvent.RESULT, handleRectangleSelection);

			//Remove crew
			count = _crew.length;

			for (i = count; i--;) {
				var crewMember:Crew = _crew[i];
				var crewLayout:MovieClip = crewMember.crewLayout;
				
				crewLayout.removeEventListener(MouseEvent.CLICK, handleCrewClick);
				
				//if (_shipLayout.contains(crewLayout)) {
					_shipLayout.removeChild(crewLayout);
				//}
				
				crewMember.dispose();
			}
			
			_selectedCrewMembers = null;
			_crew = null;
			
			//Remove Rooms
			
			count = _rooms.length;
			
			for (i = count; i--;) {
				var room:Room = _rooms[i];
				room.dispose();
			}
			
			_rooms = null;
			
			count = _nodes.length;
			
			for (i = count; i--;) {
				var node:Node = _nodes[i];
				node.layout.removeEventListener(MouseEvent.RIGHT_CLICK, handleNodeRightClick)
				_shipLayout.removeChild(node.layout);
				node.dispose();
			}
			
			_selectedNode = null;
			_selectedNodes = null;
			_nodes = null;
			_shipLayout = null;
			
			_isDisposed = true;
		}
		//}
	}
}