package Ship {
	//{ Imports
	import flash.events.Event;
	import flash.utils.setTimeout;
	import Crew.ICrew;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetDataEvent;
	import RectangleSelector.RectangleSelector;
	import RectangleSelector.RectangleSelectionEvent;
	import Ship.Events.PathFindEvent;
	import flash.display.Sprite;
    import flash.geom.Point;
	//}  
	
	//should be treated as an abstract class
	public class IShip extends Sprite {
		private var _openNodes:Vector.<Node>;
		private var _startNode:Node;
		private var _stopNode:Node;
		private var _queueMovement:Vector.<Movement>;
		private var _shipName:String;
		private var _shipLayout:MovieClip;
		private var _nodes:Vector.<Node>;
		private var _rooms:Vector.<Room>;
		private var _crew:Vector.<ICrew>;
		private var _nodeIndex:Number = 0;
		private var _crewIndex:Number = 0;
		private var _roomIndex:Number = 0;
		private var _offsetMapX:Number;
		private var _offsetMapY:Number;
		private const _offsetCrewX:Number = 17;
		private const _offsetCrewY:Number = 17;
		private var _selectedCrewMembers:Vector.<ICrew>;
		private var _selectedNodes:Vector.<Node>;
		private var _selectedNode:Node;
		
		private var _hangar:Hangar;
		
		public function IShip() {
			_nodes = new Vector.<Node>();
			_crew = new Vector.<ICrew>();
			_rooms = new Vector.<Room>();
			_selectedCrewMembers = new Vector.<ICrew>();
			_selectedNodes = new Vector.<Node>();
			_queueMovement = new Vector.<Movement>();
			
			this.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, false);
			this.addEventListener(Event.REMOVED, handleRemoved, false, 0, true);
		}

		//{ Dispose
		public function dispose():void {
			//TODO, implement
			this.removeEventListener(Event.REMOVED, handleRemoved);
			this.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		//}
		
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
		
		public function get shipLayout():MovieClip {
			return _shipLayout;
		}
		
		public function set shipLayout(value:MovieClip):void {
			this._shipLayout = value;
		}
		
		public function get shipCrew():Vector.<ICrew> {
			return _crew;
		}
		
		public function set hangar(value:Hangar) {
			this._hangar = value;
			_hangar.rectangleSelector.addEventListener(RectangleSelectionEvent.RESULT, handleRectangleSelection);
		}
		//}
		
		//{ Crew init
		protected function constructCrew():void { };
		
		protected function addCrew(crew:ICrew, nodeIndex:Number):void {
			crew.ID = _crewIndex;
			crew.node = _nodes[nodeIndex];
			_crew.push(crew);
			
			var crewLayout:MovieClip = crew.crewLayout;
			crewLayout.name = _crewIndex.toString();
			crewLayout.x = (_nodes[nodeIndex].X * 34) + _offsetMapX + _offsetCrewX;
			crewLayout.y = (_nodes[nodeIndex].Y * 34) + _offsetMapY + _offsetCrewY;
			crewLayout.addEventListener(MouseEvent.CLICK, handleCrewClick);
			//TODO: do not forget to removeListener
			
			_crewIndex += 1;
			_shipLayout.addChild(crew.crewLayout);
		}		

		//}
		
		//{ Node init
		protected function constructNodes():void { };
		
		protected function generateNode(x:Number, y:Number) {
			var node:Node = new Node();
			node.ID = _nodeIndex;
			node.X = x;
			node.Y = y;
			_nodeIndex += 1;
			return node;
		}
		
		protected function generateRoom() {
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
			node.layout.x = (node.X * 34) + _offsetMapX;
			node.layout.y = (node.Y * 34) + _offsetMapY;
			node.layout.name = node.ID.toString();
			node.layout.addEventListener(MouseEvent.RIGHT_CLICK, handleNodeRightClick);
		}
		
		protected function initNodes():void {
			//opimisation?
			//instead of looping again, maybe add to stage while doing addNode?
			//Some of this code should be added to Node itself
			
			var currentX:Number = 0;
			var currentY:Number = -1;
			
			var nodeArray:Array = new Array();
			
			for each (var node:Node in _nodes) {
				/*
				if (node.Y != currentY) {
					currentY = node.Y;
					nodeArray[node.Y] = new Array();
				}
				*/
				
				if (nodeArray[node.Y] == undefined) {
					nodeArray[node.Y] = new Array()
				}
				
				nodeArray[node.Y][node.X] = node;
			}
			
			for (var i:Number = 0; i < _nodes.length; i++) {
				var node:Node = _nodes[i];
				
				if (node.ID == 2) {
					trace("yes");
				}
				
				
				node.layout.fldID.text = node.ID.toString();
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
			
			//Check for dead ends
			for (var i:Number = 0; i < _nodes.length; i++) {
				var node:Node = _nodes[i];
				node.checkForDeadEnds();
			}
			
			testNodeOut(_nodes[2]);
		}
		//}
		
		//{ Debug
		public function x_tracePath(path:Vector.<Node>):void {
			var traceLog:String = "";
			
			for (var i:int = 0; i < path.length; i++) {
				traceLog += "tracePath : ID = " + path[i].ID + "\n";
			}
			
			trace(traceLog);
		}

		public function x_tracePathOLD(path:Vector.<int>):void {
			var traceLog:String = "";
			
			for (var i:int = 0; i < path.length; i++) {
				traceLog += "tracePath : ID = " + path[i] + "\n";
			}
			
			trace(traceLog);
		}
		
		public function tracePathOLD():void {
			var testNode:Node = _selectedNode;
			var traceLog:String = "";
			
			
			while (testNode.parentNode != null) {
				traceLog = "tracePath : ID = " + testNode.ID + " (x=" + testNode.X + ",y=" + testNode.Y + ")\n" + traceLog;
				testNode = testNode.parentNode;
			}
			
			traceLog = "tracePath : ID = " + testNode.ID + " (x=" + testNode.X + ",y=" + testNode.Y + ")\n" + traceLog; 
			
			trace(traceLog);
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
			var crewMember:ICrew = _crew[Number(crewLayout.name)];
			
			crewMember.selectMember();
			_selectedCrewMembers.push(crewMember);
			
			trace(crewLayout.name);
			
			
			//var crewID:Number = Number((e.currentTarget as MovieClip).name);
			//var crew:ICrew = _crew[crewID];
			
			trace(crewLayout);
		}
		
		private function handleRemoved(e:Event) {
			dispose();
		}
		
		public function handleRectangleSelection(e:RectangleSelectionEvent) {
			for (var i:int = 0; i < _crew.length; i++) {
				if (_crew[i].crewLayout.hitTestObject(e.result)) {
					_crew[i].selectMember();
				} else {
					_crew[i].deselectMember();
				}
			}
		}
		
		private function filterSelectedCrewMembers(element:ICrew, index:int, array:Vector.<ICrew>):Boolean {
			return (element.isSelected);
		}
		
		private function handleNodeRightClick(e:MouseEvent):void {
			hideNodePoints();

			_selectedCrewMembers.length = 0;
			_selectedCrewMembers = _crew.filter(filterSelectedCrewMembers);
			
			if (_selectedCrewMembers.length > 0) {
				var clickedNode:Node = _nodes[Number(MovieClip(e.target).parent.name)];
				
				if (_selectedCrewMembers.length == 1) {
					_selectedNodes.push(clickedNode);
					clickedNode.showPoint();
					
					_selectedCrewMembers[0].path = pathFind(_selectedCrewMembers[0].node, clickedNode);
				} else {
					//now, since we have multiple selected crewmembers, we need to get all nodes that are neighbour of clickedNode
					var neighbourNodes:Vector.<Node> = clickedNode.getNeighbourNodes();
					
					for (var i:int = 0; i < _selectedCrewMembers.length; i++) {
						if ((i < neighbourNodes.length) && (neighbourNodes[i] != undefined)) {
							neighbourNodes[i].showPoint();
							_selectedNodes.push(neighbourNodes[i]);
							_selectedCrewMembers[i].path = pathFind(_selectedCrewMembers[i].node, neighbourNodes[i]);
						} else {
							//_selectedCrewMembers[i].deselectMember();
						}
					}
				}
				
				
				_selectedNode = clickedNode;
				//pathFind();
				//_shipLayout.addEventListener(Event.ENTER_FRAME, moveCrew, false, 0, true);
				
				//NOTE: ???
				//_selectedCrewMembers[0].crewLayout.addEventListener(Event.ENTER_FRAME, moveCrew);
			}
		}
		//}
		
		private function handleEnterFrame(e:Event):void {
			var testing:Boolean = true;
			
			
				for (var i:int = 0; i < _crew.length; i ++) {
					var crewMember:ICrew = _crew[i];
					crewMember.doStuff();
					
					
					if (crewMember.path != null) {
						//trace("crewMember.ID = " + crewMember.ID + " (" + crewMember.crewName + "). CurrentNode ID = " + crewMember.node.ID);
						//trace("crewMember.path = " + crewMember.path[0].ID);
						//trace("");
						
						testing = false;
					}
				}
			/*
			for (var i:int = 0; i < _queueMovement.length; i++) {
				//logic for switching between types
				var movement:Movement = _queueMovement[i];
				var point:Point = new Point((movement.toNode.X * 34) + _offsetMapX + _offsetCrewX, (movement.toNode.Y * 34) + _offsetMapY + _offsetCrewY);
				
				//(_nodes[nodeIndex].X * 34) + _offsetMapX + _offsetCrewX
				//trace(point.x + " = " + point.y);
				
				moveToPoint(movement.crewMember.crewLayout, point, 2, true);
			}
			*/
		}

		
		//{ Pathfinding
		public function pathFind(startNode:Node, stopNode:Node):Vector.<Node> {
			//TODO: Optimise? better to set length to null in global variable then reinit
			var openNodes:Vector.<Node> = new Vector.<Node>();
			
			//add our startNode to the openNodes
			openNodes.push(startNode);
			
			//Do our pathFinding
			openNodes = pathFindOpenNodes(openNodes, startNode, stopNode);
			
			//Reset startNode
			startNode.parentNode = null;
			
			var path:Vector.<int> = new Vector.<int>();
			var xpath:Vector.<Node> = new Vector.<Node>();
				
			startNode.parentNode = null;
				
			while (stopNode.parentNode != null) {
				path.push(stopNode.ID);
				xpath.push(stopNode);
				stopNode = stopNode.parentNode;
			}
			
			path.push(stopNode.ID);
			xpath.push(stopNode);
			path.reverse();
			xpath.reverse();
			x_tracePath(xpath);
			
			clearNodes();
			
			//Clear nodes, when?
			return xpath;
		}
		
		public function pathFindOpenNodes(openNodes:Vector.<Node>, startNode:Node, stopNode:Node):Vector.<Node> {
			var openNode:Node;
			var attachedNode:Node;
			var attachedNodes:Vector.<Node> = new Vector.<Node>;
			var foundStopNode:Boolean = false;
			
			for (var i:int = 0; i < openNodes.length; i++) {
				openNode = openNodes[i];
				
				//loop through all attached nodes in openNode
				for (var j:int = 0; j < openNode.x_ConnectedWalkableNodes.length; j++) {
					attachedNode = openNode.x_ConnectedWalkableNodes[j];
					
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
		
		public function pathFindOLD():void { 
			trace("");
			trace("=======================================");
			trace("");

			//var startNode:Node = _selectedCrewMember.node;
			var startNode:Node = _selectedCrewMembers[0].node;
			
			var stopNode:Node = _selectedNode;
			var currentNode:Node = startNode;
			
			//new
			_openNodes = new Vector.<Node>;
			_openNodes.push(startNode);
			_startNode = startNode;
			_stopNode = stopNode;
			
			pathFindOpenNodesOLD();
			
			//add currentNode to openNodes
			
			startNode.parentNode = null;
			
			tracePathOLD();
			clearNodes();
		}
		
		public function pathFindOpenNodesOLD():void {
			var openNode:Node;
			var attachedNode:Node;
			var attachedNodes:Vector.<Node> = new Vector.<Node>;
			var foundStopNode:Boolean = false;
			
			for (var i:int = 0; i < _openNodes.length; i++) {
				openNode = _openNodes[i];
				
				//loop through all attached nodes in openNode
				for (var j:int = 0; j < openNode.x_ConnectedWalkableNodes.length; j++) {
					attachedNode = openNode.x_ConnectedWalkableNodes[j];
					
					if (attachedNode == _stopNode) {
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
			
			_openNodes = attachedNodes;
			
			if (foundStopNode == false) {
				pathFindOpenNodesOLD();
			}
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

		private function moveCrew(e:Event):void {
		}
		
		public function clearNodes():void {
			for (var i:Number = 0; i < _nodes.length; i++) {
				_nodes[i].clearNode();
			}
		}
		
		public function removeMomementById(id:int) {
			for (var i:int = _queueMovement.length - 1; i >= 0; i--) {
				if (_queueMovement[i].ID == id) {
					trace("removing " + _queueMovement[i].ID);
					_queueMovement.splice(i, 1);
				}
			}
		}
		
		public function moveToPoint(obj:Object, target:Point, speed:Number = 1, objRot:Boolean = false):void {
			// get the difference between obj and target points.
			var diff:Point = target.subtract(new Point(obj.x, obj.y)); 
			var dist = diff.length;
			
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
	}
}