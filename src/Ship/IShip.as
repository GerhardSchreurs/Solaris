package Ship {
	//{ Imports
	import flash.events.Event;
	import flash.utils.setTimeout;
	import Crew.ICrew;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetDataEvent;
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
		private var _crew:Vector.<ICrew>;
		private var _nodeIndex:Number = 0;
		private var _crewIndex:Number = 0;
		private var _offsetMapX:Number;
		private var _offsetMapY:Number;
		private const _offsetCrewX:Number = 9;
		private const _offsetCrewY:Number = 11;
		private var _selectedCrewMembers:Vector.<ICrew>;
		private var _selectedNode:Node;
		
		public function IShip() {
			_nodes = new Vector.<Node>();
			_crew = new Vector.<ICrew>();
			_selectedCrewMembers = new Vector.<ICrew>();
			_queueMovement = new Vector.<Movement>;
			
			this.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, false);
			this.addEventListener(Event.REMOVED, handleRemoved, false, 0, true);
			this.addEventListener(PathFindEvent.RESULT, handlePathFindEvent, false, 0, true);
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
		
		protected function addNode(node:Node):void {
			_nodes.push(node);
			
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
				if (node.Y != currentY) {
					currentY = node.Y;
					nodeArray[node.Y] = new Array();
				}
				
				nodeArray[node.Y][node.X] = node;
			}
			
			for (var i:Number = 0; i < _nodes.length; i++) {
				var node:Node = _nodes[i];
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
			
			trace(_nodes);
			testNodeOut(_nodes[7]);
		}
		//}
		
		//{ Debug
		public function tracePath():void {
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
			trace("testing node [x:" + node.X + " | y:" + node.Y + "]");
			
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

		private function handleEnterFrame(e:Event) {
			for (var i:int = 0; i < _queueMovement.length; i++) {
				//logic for switching between types
				var movement:Movement = _queueMovement[i];
				var point:Point = new Point((movement.toNode.X * 34) + _offsetMapX + _offsetCrewX, (movement.toNode.Y * 34) + _offsetMapY + _offsetCrewY);
				
				//(_nodes[nodeIndex].X * 34) + _offsetMapX + _offsetCrewX
				//trace(point.x + " = " + point.y);
				
				moveToPoint(movement.crewMember.crewLayout, point, 2, true);
			}
		}
		
		private function handleRemoved(e:Event) {
			dispose();
		}
		//}
		
		//{ Pathfinding
		public function pathFind():void { 
			trace("");
			trace("=======================================");
			trace("");

			var startNode:Node = _selectedCrewMember.node;
			var stopNode:Node = _selectedNode;
			var currentNode:Node = startNode;
			
			//new
			_openNodes = new Vector.<Node>;
			_openNodes.push(startNode);
			_startNode = startNode;
			_stopNode = stopNode;
			
			pathFindOpenNodes();
			
			//add currentNode to openNodes
			
			startNode.parentNode = null;
			
			tracePath();

			for (var i:Number = 0; i < _nodes.length; i++) {
				_nodes[i].clearNode();
			}
		}
		
		public function pathFindOpenNodes():void {
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
				pathFindOpenNodes();
			}
		}		
		//}

		private function moveCrew(e:Event):void {
			trace(this);
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