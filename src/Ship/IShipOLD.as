package Ship {
	import Crew.ICrew;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetDataEvent;
	//should be treated as an abstract class
	
	
	public class IShipOLD {
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
		
		private var _selectedCrewMember:ICrew;
		private var _selectedNode:Node;
		
		public function IShip() {
			_nodes = new Vector.<Node>();
			_crew = new Vector.<ICrew>();
		}
		
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
		
		protected function addNode(node:Node):void {
			_nodes.push(node);
			
			_shipLayout.addChild(node.layout);
			node.layout.x = (node.X * 34) + _offsetMapX;
			node.layout.y = (node.Y * 34) + _offsetMapY;
			node.layout.name = node.ID.toString();
			node.layout.addEventListener(MouseEvent.RIGHT_CLICK, handleNodeRightClick);
		}

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
		
		public function handleCrewClick(e:MouseEvent):void {
			if (_selectedCrewMember != undefined) {
				_selectedCrewMember.deselectMember();
			}
			
			var crewLayout:MovieClip = e.currentTarget as MovieClip;
			var crewMember:ICrew = _crew[Number(crewLayout.name)];
			crewMember.selectMember();
			_selectedCrewMember = crewMember;
			
			trace(crewLayout.name);
			
			
			//var crewID:Number = Number((e.currentTarget as MovieClip).name);
			//var crew:ICrew = _crew[crewID];
			
			trace(crewLayout);
		}
		
		public function handleNodeRightClick(e:MouseEvent):void {
			if (_selectedCrewMember != undefined) {
				if (_selectedNode != undefined) {
					_selectedNode.hidePoint();
				}
				
				var target:MovieClip = e.target as MovieClip;
				var node:Node = _nodes[Number(MovieClip(e.target).parent.name)];
				node.showPoint();
				
				_selectedNode = node;
				
				pathFind();
			}
		}
		
		public function pathfindLowestF(searchList:Vector.<Node>):Node {
			var lowestCost:Number = 10000;
			var lowestCostIndex:Number = 0;
			
			for (var i:Number = 0; i < searchList.length; i++) {
				if (searchList[i].F > 0) {
					if (searchList[i].F < lowestCost) {
						lowestCost = searchList[i].F;
						lowestCostIndex = i;
					}
				}
			}
			
			return searchList[lowestCostIndex];
		}
		
		public function pathFind():void {
			//from selectedCrewMember to selectedNode
			
			var searchList:Vector.<Node> = new Vector.<Node>();
			var nodeStart:Node = _selectedCrewMember.node;
			var nodeStop:Node = _selectedNode;
			var nodeCurrent:Node = nodeStart;
			var counter:Number = 0;
			
			
			trace(_nodes);
			
			
			nodeCurrent.F = 0;
			nodeCurrent.G = 0;
			nodeCurrent.H = 0;
			
			searchList.push(nodeCurrent);
			
			while ((nodeCurrent != nodeStop) && (counter < 100)) {
				trace("");
				trace("pathFind. ID = " + nodeCurrent.ID + " | x=" + nodeCurrent.X + ",y=" + nodeCurrent.Y + " (" + counter.toString() + ")"); 
				trace("F=" + nodeCurrent.F + ",G=" + nodeCurrent.G + ",H=" + nodeCurrent.H);
				nodeCurrent.pathfind(searchList, nodeStart, nodeStop);
				
				//find lowest F cost
				nodeCurrent = pathfindLowestF(searchList);
				
				searchList = new Vector.<Node>();
				
				counter += 1;
			}
			
			tracePath();
			
			for (var i:Number = 0; i < _nodes.length; i++) {
				_nodes[i].isChecked = false;
			}
		}
		
		public function tracePath() {
			var testNode:Node = _selectedNode;
			
			while (testNode.parentNode != null) {
				trace("tracePath : ID = " + testNode.ID + " (x=" + testNode.X + ",y=" + testNode.Y + ")");
				testNode = testNode.parentNode;
			}
			
			trace("tracePath : ID = " + testNode.ID + " (x=" + testNode.X + ",y=" + testNode.Y + ")");
		}
		
		public function get shipCrew():Vector.<ICrew> {
			return _crew;
		}
		
		protected function constructNodes():void { };
		protected function constructCrew():void { };
		
		protected function drawLayout():void {
			//opimisation?
			//instead of looping again, maybe add to stage while doing addNode?
			
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
			
			trace(nodeArray);
			testNodeOut(_nodes[7]);
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
		
		public function generateNode(x:Number, y:Number) {
			var node:Node = new Node();
			node.ID = _nodeIndex;
			node.X = x;
			node.Y = y;
			_nodeIndex += 1;
			return node;
		}
	}
}