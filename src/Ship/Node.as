package Ship {
	import flash.display.MovieClip;
	import flash.display3D.textures.VideoTexture;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.AVSource;
	import flash.text.TextColorType;
	import Ship.Enum.Compas;
	import Ship.Enum.Navigation;
	import Ship.Enum.Thickness;
	import State.*;
	import flash.filters.*;

	public class Node {
		//debug
		public var a:String;
		
		//for moving
		public var xPos:int;
		public var yPos:int;
		public var xPosStop:int;
		public var yPosStop:int;
		public var xCenterPosition:int;
		public var yCenterPosition:int;
		public var centerBoundL:Number;
		public var centerBoundR:Number;
		public var centerBoundT:Number;
		public var centerBoundB:Number;
		public var outsideBoundL:Number;
		public var outsideBoundR:Number;
		public var outsideBoundT:Number;
		public var outsideBoundB:Number;
		
		//new
		public var x_ConnectedWalkableNodes:Vector.<Node>;
		public var room:Room;
		
		public var ID:Number;
		private var _parentNode:Node;

		public var X:Number;
		public var Y:Number;
		public var layout:LIB_Node;

		public var doorL:Boolean;
		public var doorT:Boolean;
		public var doorR:Boolean;
		public var doorB:Boolean;
		
		public var borderL:Number;
		public var borderT:Number;
		public var borderR:Number;
		public var borderB:Number;

		//These should be calculated
		private var _canTOPL:Boolean;
		private var _canTOPC:Boolean;
		private var _canTOPR:Boolean;
		private var _canMIDL:Boolean;
		private var _canMIDR:Boolean;
		private var _canBOTL:Boolean;
		private var _canBOTC:Boolean;
		private var _canBOTR:Boolean;

		private var _TOPLnode:Node;
		private var _TOPCnode:Node;
		private var _TOPRnode:Node;
		private var _MIDLnode:Node;
		private var _MIDRnode:Node;
		private var _BOTLnode:Node;
		private var _BOTCnode:Node;
		private var _BOTRnode:Node;

		private var _singleConnectedNode:Node;
		private var _connectedNodesCount:Number;
		private var _connectedWalkableNodesCount:Number;
		private var _connectedDoorsCount:Number;

		private var _parentNodeCount = 0;

		public var isChecked:Boolean;
		public var isNextChecked:Boolean;
		public var isDeadEnd:Boolean;
		public var isConnectedToTarget:Boolean;

		public var F:Number;
		public var G:Number;
		public var H:Number;
		
		private var colorOn:ColorTransform = new ColorTransform();
		private var colorOff:ColorTransform = new ColorTransform();
		private var _doorGlowFilter:GlowFilter;

		
		public function set parentNode(value:Node):void  {
			this._parentNode = value;
			
			if (_parentNode != null) {
				_parentNodeCount = _parentNode.parentNodeCount + 1;
			}
		}

		public function get parentNode():Node {
			return this._parentNode;
		}

		public function get parentNodeCount():Number {
			return _parentNodeCount;
		}

		public function clearNode():void {
			this.parentNode = null;
			this.isChecked = false;	
			this.isNextChecked = false;
			this.isConnectedToTarget = false;
			_parentNodeCount = 0;
			_connectedNodesCount = 0;
			_connectedWalkableNodesCount = 0;
			_singleConnectedNode = null;
		}
		
		public function set TOPLnode(value:Node):void {
			if (value != undefined) {
				_TOPLnode = value;
				_connectedNodesCount += 1;
				_singleConnectedNode = value;
				
				if ((this.borderT == 1) && (this.borderL == 1)) {
					canTOPL = true;
					//new
					x_ConnectedWalkableNodes.push(value);
				}
			}
		}
		public function set TOPCnode(value:Node):void {
			if (value != undefined) {
				_TOPCnode = value;
				_connectedNodesCount += 1;
				_singleConnectedNode = value;
				
				if ((this.borderT == 1) || (this.doorT)) {
					canTOPC = true;
					//new
					x_ConnectedWalkableNodes.push(value);
				}
			}
		}
		public function set TOPRnode(value:Node):void {
			if (value != undefined) {
				_TOPRnode = value;
				_connectedNodesCount += 1;
				_singleConnectedNode = value;
				
				if ((this.borderT == 1) && (this.borderR == 1)) {
					canTOPR = true;
					//new
					x_ConnectedWalkableNodes.push(value);
				}
			}
		}

		public function set MIDLnode(value:Node):void {
			if (value != undefined) {
				_MIDLnode = value;
				_connectedNodesCount += 1;
				_singleConnectedNode = value;
				
				if ((this.borderL == 1) || (this.doorL)) {
					canMIDL = true;
					//new
					x_ConnectedWalkableNodes.push(value);
				}
			}
		}
		public function set MIDRnode(value:Node):void {
			if (value != undefined) {
				_MIDRnode = value;
				_connectedNodesCount += 1;
				_singleConnectedNode = value;
				
				if ((this.borderR == 1) || (this.doorR)) {
					canMIDR = true;
					//new
					x_ConnectedWalkableNodes.push(value);
				}
			}
		}
		public function set BOTLnode(value:Node):void {
			if (value != undefined) {
				_BOTLnode = value;
				_connectedNodesCount += 1;
				_singleConnectedNode = value;
				
				if ((this.borderL == 1) && (this.borderB == 1)) {
					canBOTL = true;
					//new
					x_ConnectedWalkableNodes.push(value);
				}
			}
		}
		public function set BOTCnode(value:Node):void {
			if (value != undefined) {
				_BOTCnode = value;
				_connectedNodesCount += 1;
				_singleConnectedNode = value;
				
				if ((this.borderB == 1) || (this.doorB)) {
					canBOTC = true;
					//new
					x_ConnectedWalkableNodes.push(value);
				}
			}
		}
		public function set BOTRnode(value:Node):void {
			if (value != undefined) {
				_BOTRnode = value;
				_connectedNodesCount += 1;
				_singleConnectedNode = value;
				
				if ((this.borderR == 1) && (this.borderB == 1)) {
					canBOTR = true;
					//new
					x_ConnectedWalkableNodes.push(value);
				}
			}
		}

		public function get singleConnectedNode():Node {
			return _singleConnectedNode;
		}

		public function get connectedNodesCount() {
			return _connectedNodesCount;
		}

		public function get connectedDoorsCount() {
			return _connectedDoorsCount;
		}
		
		public function init():void {
			checkForDeadEnds();
			removeDoubleDoors();
			calculateBounds();
		}
		
		private function removeDoorBottom():void {
			layout.doorB.removeEventListener(MouseEvent.MOUSE_OVER, handleDoorMouseOver);
			layout.doorB.removeEventListener(MouseEvent.MOUSE_OUT, handleDoorMouseOut);
			layout.doorB.removeEventListener(MouseEvent.CLICK, handleDoorClick);
			
			layout.removeChild(layout.doorB);
 		}
		
		private function removeDoorRight():void {
			layout.doorR.removeEventListener(MouseEvent.MOUSE_OVER, handleDoorMouseOver);
			layout.doorR.removeEventListener(MouseEvent.MOUSE_OUT, handleDoorMouseOut);
			layout.doorR.removeEventListener(MouseEvent.CLICK, handleDoorClick);
			
			layout.removeChild(layout.doorR);
		}
		
		
		public function removeDoubleDoors():void {
			if (doorT && (_TOPCnode != undefined)) {
				if (_TOPCnode.doorB) {
					//remove target doorB
					_TOPCnode.removeDoorBottom();
				}
			}
			
			if (doorL && (_MIDLnode != undefined)) {
				if (_MIDLnode.doorR) {
					//remove target doorR
					_MIDLnode.removeDoorRight();
				}
			}
		}
		

		public function checkForDeadEnds():void {
			if (this.x_ConnectedWalkableNodes.length == 1) {
				this.isDeadEnd = true;
				this.layout.fldID.textColor = 0xFF0000;
			} else if (this.x_ConnectedWalkableNodes.length == 3) {
				if (this._connectedDoorsCount == 0) {
					this.isDeadEnd = true;
					this.layout.fldID.textColor = 0xFF0000;
				}
			}
		}
		
		public function xIsInCenterBounds(x:Number) {
			return (x >= centerBoundL && x <= centerBoundR);
		}
		public function yIsInCenterBounds(y:Number) {
			return (y >= centerBoundT && y <= centerBoundB);
		}
		
		public function isInCenterBounds(x:Number, y:Number):Boolean {
			return (x >= centerBoundL && x <= centerBoundR && y >= centerBoundT && y <= centerBoundB);
		}
		
		public function isInOutBounds(x:Number, y:Number):Boolean {
			return (x >= outsideBoundL && x <= outsideBoundR && y >= outsideBoundT && y <= outsideBoundB);
		}
		
		
		public function calculateBounds():void {
			xPos = this.layout.x;
			yPos = this.layout.y;
			xPosStop = xPos + DEFAULTS.NodeSize;
			yPosStop = yPos + DEFAULTS.NodeSize;
			xCenterPosition = xPos + DEFAULTS.CrewOffset;
			yCenterPosition = yPos + DEFAULTS.CrewOffset;
			centerBoundL = xCenterPosition - DEFAULTS.NodeBoundsRange;
			centerBoundR = xCenterPosition + DEFAULTS.NodeBoundsRange;
			centerBoundT = yCenterPosition - DEFAULTS.NodeBoundsRange;
			centerBoundB = yCenterPosition + DEFAULTS.NodeBoundsRange;
			outsideBoundL = xPos + DEFAULTS.NodeBoundsRange;
			outsideBoundR = xPosStop - DEFAULTS.NodeBoundsRange;
			outsideBoundT = yPos + DEFAULTS.NodeBoundsRange;
			outsideBoundB = yPosStop - DEFAULTS.NodeBoundsRange;
		}
			
		public function get TOPLnode():Node {
			return _TOPLnode;
		}
		public function get TOPCnode():Node {
			return _TOPCnode;
		}
		public function get TOPRnode():Node {
			return _TOPRnode;
		}
		public function get MIDLnode():Node {
			return _MIDLnode;
		}
		public function get MIDRnode():Node {
			return _MIDRnode;
		}
		public function get BOTLnode():Node {
			return _BOTLnode;
		}
		public function get BOTCnode():Node {
			return _BOTCnode;
		}
		public function get BOTRnode():Node {

			return _BOTRnode;
		}

		public function get canTOPL():Boolean {
			return _canTOPL;
		}
		public function get canTOPC():Boolean {
			return _canTOPC;
		}
		public function get canTOPR():Boolean {
			return _canTOPR;
		}
		public function get canMIDL():Boolean {
			return _canMIDL;
		}
		public function get canMIDR():Boolean {
			return _canMIDR;
		}
		public function get canBOTL():Boolean {
			return _canBOTL;
		}
		public function get canBOTC():Boolean {
			return _canBOTC;
		}
		public function get canBOTR():Boolean {
			return _canBOTR;
		}

		public function set canTOPL(value:Boolean):void {
			_canTOPL = value;
			_connectedWalkableNodesCount += 1;
		}
		public function set canTOPC(value:Boolean):void {
			_canTOPC = value;
			_connectedWalkableNodesCount += 1;
		}
		public function set canTOPR(value:Boolean):void {
			_canTOPR = value;
			_connectedWalkableNodesCount += 1;
		}
		public function set canMIDL(value:Boolean):void {
			_canMIDL = value;
			_connectedWalkableNodesCount += 1;
		}
		public function set canMIDR(value:Boolean):void {
			_canMIDR = value;
			_connectedWalkableNodesCount += 1;
		}
		public function set canBOTL(value:Boolean):void {
			_canBOTL = value;
			_connectedWalkableNodesCount += 1;
		}
		public function set canBOTC(value:Boolean):void {
			_canBOTC = value;
			_connectedWalkableNodesCount += 1;
		}
		public function set canBOTR(value:Boolean):void {
			_canBOTR = value;
			_connectedWalkableNodesCount += 1;
		}
			
			
		public function clearCheckMarks():void {
			this.isChecked = false;
			
			var node:Node = this.parentNode;
			
			while (node.parentNode != null) {
				node = node.parentNode;
				node.isChecked = false;
			}
		}

		public function setConnectedToTargetFlags() {
			if (canTOPL) {
				TOPLnode.isConnectedToTarget = true;
			}
			if (canTOPC) {
				TOPCnode.isConnectedToTarget = true;
			}
			if (canTOPR) {
				TOPRnode.isConnectedToTarget = true;
			}
			if (canMIDL) {
				MIDLnode.isConnectedToTarget = true;
			}
			if (canMIDR) {
				MIDRnode.isConnectedToTarget = true;
			}
			if (canBOTL) {
				BOTLnode.isConnectedToTarget = true;
			}
			if (canBOTC) {
				BOTCnode.isConnectedToTarget = true;
			}
			if (canBOTR) {
				BOTRnode.isConnectedToTarget = true;
			}
		}
			
		public function uncheckParentChildNodes():void {
			trace("uncheckParentChildNodes");
			
			//optimisation here?
			//we do not which to recalculate F,G,H
			var parentNode:Node = this.parentNode;
			
			if (parentNode.TOPLnode) {
				parentNode.TOPLnode.isChecked = false;
			}
			if (parentNode.TOPCnode) {
				parentNode.TOPCnode.isChecked = false;
			}
			if (parentNode.TOPRnode) {
				parentNode.TOPRnode.isChecked = false;
			}
			if (parentNode.MIDLnode) {
				parentNode.MIDLnode.isChecked = false;
			}
			if (parentNode.MIDRnode) {
				parentNode.MIDRnode.isChecked = false;
			}
			if (parentNode.BOTLnode) {
				parentNode.BOTLnode.isChecked = false;
			}
			if (parentNode.BOTCnode) {
				parentNode.BOTCnode.isChecked = false;
			}
			if (parentNode.BOTRnode) {
				parentNode.BOTRnode.isChecked = false;
			}
			
			/*
			if (parentNode.canTOPL) {
				parentNode.TOPLnode.isChecked = false;
			}
			if (parentNode.canTOPC) {
				parentNode.TOPCnode.isChecked = false;
			}
			if (parentNode.canTOPR) {
				parentNode.TOPRnode.isChecked = false;
			}
			if (parentNode.canMIDL) {
				parentNode.MIDLnode.isChecked = false;
			}
			if (parentNode.canMIDR) {
				parentNode.MIDRnode.isChecked = false;
			}
			if (parentNode.canBOTL) {
				parentNode.BOTLnode.isChecked = false;
			}
			if (parentNode.canBOTC) {
				parentNode.BOTCnode.isChecked = false;
			}
			if (parentNode.canBOTR) {
				parentNode.BOTRnode.isChecked = false;
			}
			*/
			
			this.parentNode.isChecked = true;
			
		}
			
		public function pathfindCalculateNext(targetNode:Node, fromNode:Node, toNode:Node, gCost:Number):Number {
			targetNode.isNextChecked = true;
			targetNode.G = gCost;
			targetNode.H = pathfindCalculateH(targetNode, toNode);
			targetNode.F = targetNode.G + targetNode.H;
			
			return targetNode.F;
		}
			
		public function pathfindCalculate(targetNode:Node, fromNode:Node, toNode:Node, gCost:Number, isNextCheckFlag:Boolean = false):Number {
			targetNode.isChecked = (isNextCheckFlag == false);
			targetNode.isNextChecked = isNextCheckFlag;
			targetNode.parentNode = this;
			targetNode.G = gCost;
			targetNode.H = pathfindCalculateH(targetNode, toNode);
			targetNode.F = targetNode.G + targetNode.H;
			
			targetNode.layout.fldID.text = targetNode.ID.toString();
			targetNode.layout.fldF.text = targetNode.F.toString();
			//targetNode.layout.fldG.text = targetNode.G.toString();
			//targetNode.layout.fldH.text = targetNode.H.toString();
			
			//targetNode.layout.fldID.text = "i";
			
			if (isNextCheckFlag) {
				trace("pathfindCalculate ID = " + targetNode.ID + " parentID = " + targetNode.parentNode.ID + " (x=" + targetNode.X + ",y=" + targetNode.Y + ") f=" + targetNode.F + ",g=" + targetNode.G + ",h=" + targetNode.H + " " + isNextCheckFlag.toString()); 
			} else {
				trace("pathfindCalculate ID = " + targetNode.ID + " parentID = " + targetNode.parentNode.ID + " (x=" + targetNode.X + ",y=" + targetNode.Y + ") f=" + targetNode.F + ",g=" + targetNode.G + ",h=" + targetNode.H + " " + isNextCheckFlag.toString()); 
			}

			return targetNode.F;
		}
			
		public function pathfindCalculateH(fromNode:Node, toNode:Node):Number {
			//((Math.abs(this.posX - nodeStop.posX)) + (Math.abs(this.posY - nodeStop.posY))) * 10
			
			
			//Manhattan
			return ((Math.abs(fromNode.X - toNode.X)) + (Math.abs(fromNode.Y - toNode.Y))) * 10;
			
			
			//Manhattan 2
			
			/*
			var XX:Number = (toNode.X + 5) - fromNode.X;
			var YY:Number = toNode.Y - fromNode.Y;
			return Math.sqrt(XX*XX + YY*YY);
			return Math.sqrt(XX*XX + YY*YY);
			*/
		}
			
		public function pathFind(fromNode:Node, toNode:Node):Node {
			//Check all connected nodes
			var fromNodeIsDeadEnd:Boolean = fromNode.isDeadEnd;
			var toNodeIsDeadEnd:Boolean = toNode.isDeadEnd;
			
			fromNode.isDeadEnd = false;
			toNode.isDeadEnd = false;
			
			var connectedNode:Node = fromNode;
			var loopCounter:Number = 0;
			
			while (connectedNode != toNode) {
				trace("pathFind ID = " + connectedNode.ID);
				
				loopCounter += 1;
				
				if (loopCounter == 100) {
					break;
				}
				
				connectedNode = connectedNode.findConnectedNode(fromNode, toNode);
				trace("");
			}
			
			fromNode.isDeadEnd = fromNodeIsDeadEnd;
			toNode.isDeadEnd = toNodeIsDeadEnd;
			
			return connectedNode;
		}
			
		public function getConnectedNodes(fromNode:Node, toNode:Node):Array {
			var connectedNodes:Array = new Array();
			var currentF:Number;
			
			if (canTOPL && (!TOPLnode.isChecked) && (!TOPLnode.isDeadEnd)) {
				currentF = pathfindCalculate(TOPLnode, fromNode, toNode, 14);
				connectedNodes.push(TOPLnode);
			}
			if (canTOPC && (!TOPCnode.isChecked) && (!TOPCnode.isDeadEnd)) {
				currentF = pathfindCalculate(TOPCnode, fromNode, toNode, 10);
				connectedNodes.push(TOPCnode);
			}
			if (canTOPR && (!TOPRnode.isChecked) && (!TOPRnode.isDeadEnd)) {
				currentF = pathfindCalculate(TOPRnode, fromNode, toNode, 14);
				connectedNodes.push(TOPRnode);
			}
			if (canMIDL && (!MIDLnode.isChecked) && (!MIDLnode.isDeadEnd)) {
				currentF = pathfindCalculate(MIDLnode, fromNode, toNode, 10);
				connectedNodes.push(MIDLnode);
			}
			if (canMIDR && (!MIDRnode.isChecked) && (!MIDRnode.isDeadEnd)) {
				currentF = pathfindCalculate(MIDRnode, fromNode, toNode, 10);
				connectedNodes.push(MIDRnode);
			}
			if (canBOTL && (!BOTLnode.isChecked) && (!BOTLnode.isDeadEnd)) {
				currentF = pathfindCalculate(BOTLnode, fromNode, toNode, 14);
				connectedNodes.push(BOTLnode);
			}
			if (canBOTC && (!BOTCnode.isChecked) && (!BOTCnode.isDeadEnd)) {
				currentF = pathfindCalculate(BOTCnode, fromNode, toNode, 10);
				connectedNodes.push(BOTCnode);
			}
			if (canBOTR && (!BOTRnode.isChecked) && (!BOTRnode.isDeadEnd)) {
				currentF = pathfindCalculate(BOTRnode, fromNode, toNode, 14);
				connectedNodes.push(BOTRnode);
			}
			
			return connectedNodes;
		}
		
		public function getNeighbourNodes():Vector.<Node> {
			return room.nodes;
		}
			
		public function getConnectedTestNodes(t:Node, fromNode:Node, toNode:Node):Array {
			var connectedTestNodes:Array = new Array();
			var currentF:Number;
			
			if (t.canTOPL && ((!t.TOPLnode.isChecked) && (!t.TOPLnode.isNextChecked) && (!t.TOPLnode.isDeadEnd))) {
				currentF = t.pathfindCalculate(t.TOPLnode, fromNode, toNode, 14, true);
				connectedTestNodes.push(t.TOPLnode);
			}
			if (t.canTOPC && ((!t.TOPCnode.isChecked) && (!t.TOPCnode.isNextChecked) && (!t.TOPCnode.isDeadEnd))) {
				currentF = t.pathfindCalculate(t.TOPCnode, fromNode, toNode, 10, true);
				connectedTestNodes.push(t.TOPCnode);
			}
			if (t.canTOPR && ((!t.TOPRnode.isChecked) && (!t.TOPRnode.isNextChecked) && (!t.TOPRnode.isDeadEnd))) {
				currentF = t.pathfindCalculate(t.TOPRnode, fromNode, toNode, 14, true);
				connectedTestNodes.push(t.TOPRnode);
			}
			if (t.canMIDL && ((!t.MIDLnode.isChecked) && (!t.MIDLnode.isNextChecked) && (!t.MIDLnode.isDeadEnd))) {
				currentF = t.pathfindCalculate(t.MIDLnode, fromNode, toNode, 10, true);
				connectedTestNodes.push(t.MIDLnode);
			}
			if (t.canMIDR && ((!t.MIDRnode.isChecked) && (!t.MIDRnode.isNextChecked) && (!t.MIDRnode.isDeadEnd))) {
				currentF = t.pathfindCalculate(t.MIDRnode, fromNode, toNode, 10, true);
				connectedTestNodes.push(t.MIDRnode);
			}
			if (t.canBOTL && ((!t.BOTLnode.isChecked) && (!t.BOTLnode.isNextChecked) && (!t.BOTLnode.isDeadEnd))) {
				currentF = t.pathfindCalculate(t.BOTLnode, fromNode, toNode, 14, true);
				connectedTestNodes.push(t.BOTLnode);
			}
			if (t.canBOTC && ((!t.BOTCnode.isChecked) && (!t.BOTCnode.isNextChecked) && (!t.BOTCnode.isDeadEnd))) {
				currentF = t.pathfindCalculate(t.BOTCnode, fromNode, toNode, 10, true);
				connectedTestNodes.push(t.BOTCnode);
			}
			if (t.canBOTR && ((!t.BOTRnode.isChecked) && (!t.BOTRnode.isNextChecked) && (!t.BOTRnode.isDeadEnd))) {
				currentF = t.pathfindCalculate(t.BOTRnode, fromNode, toNode, 14, true);
				connectedTestNodes.push(t.BOTRnode);
			}
			
			return connectedTestNodes;
		}
			
		public function sliceNodeArrayOnFScore(nodes:Array):Array {
			var lowestFscore:Number = nodes[0].F;
			
			for (var i:Number = 0; i < nodes.length; i++) {
				if (nodes[i].F > lowestFscore) {
					nodes = nodes.slice(0, i);
					break;
				}
			}
			
			return nodes;
		}
			
		public function getLowestFscoreIndex(nodes:Array):Number {
			var lowestFscore:Number = nodes[0].F;
			var lowestFscoreIndex:Number = 0;
			
			if (nodes.length == 1) {
				return lowestFscoreIndex;
			} else {
				if (nodes[1].F > lowestFscore) {
					//only one attached node
					return 0;
				} else {
					//multiple nodes attached, give up
					return -1;
				}
			}
		}
			
		public function findConnectedNode(fromNode:Node, toNode:Node):Node {
		this.isChecked = true;
		var connectedNodes:Array = getConnectedNodes(fromNode, toNode);
			
		if (connectedNodes.length == 0) {
			trace("NO CONNECTED NODES");
		} else if (connectedNodes.length == 1) {
			trace("ONE CONNECTED NODE");
			return connectedNodes[0];
		} else { 
			connectedNodes.sortOn("F", Array.NUMERIC);
				
			if (connectedNodes[0].F < connectedNodes[1].F) {
				trace("MULTIPLE CONNECTED NODES, with single lowest F score");
				return connectedNodes[0];
			} else {
				trace("MULTIPLE CONNECTED NODES, some have same F score (" + connectedNodes[0].F.toString() + ")");
				connectedNodes = sliceNodeArrayOnFScore(connectedNodes);
					
				var testNodeScore:Vector.<Number> = new Vector.<Number>(connectedNodes.length);
				var maxLength:Number = 3;
				var innerCounter:Number = 0;
				
				for (var i:Number = 0; i < connectedNodes.length; i++) {
					var testNode:Node = connectedNodes[i];
					var testNodes:Array;
						
					for (var j:Number = 0; j < maxLength; j++) {
						trace("pathing : " + testNode.ID + " (" + i.toString() + ")(" + j.toString() + ")");
							
						//we are going to try to test 3 connected testNodes;
							
						innerCounter = j;
						testNodes = getConnectedTestNodes(testNode, fromNode, toNode);
							
						if (testNodes.length == 0) {
							//No connected nodes, break;
							testNodeScore[i] = 10000 + i;
							break;
						} else {
							//found one or multiple connected nodes
							testNodes.sortOn("F", Array.NUMERIC);
							var lowestIndex:Number = getLowestFscoreIndex(testNodes);
								
							if (lowestIndex == -1) {
								//found multiple nodes with same value, can't continue
								maxLength = j;
								testNodeScore[i] = testNodes[0].F;
								break;
							} else {
								testNodeScore[i] = testNodes[lowestIndex].F;
								testNode = testNodes[lowestIndex];
							}
						}
							
						if (testNode == toNode) {
							break;
						}
					}
				}
					
				//what is our lowestIndex?
				var lowestIndex:Number = 0;
				var lowestNumber:Number = testNodeScore[0];
					
				for (var i:Number = 1; i < testNodeScore.length; i++) {
					if (testNodeScore[i] < lowestNumber) {
						lowestNumber = testNodeScore[i];
						lowestIndex = i;
					}
				}
					
				return connectedNodes[lowestIndex];
			}
		}
			
		return null;
	}
		
		public function findNextNode(testNode:Node, fromNode:Node, toNode:Node) {
			//Unused?
			
			var connectedNodes:Array = new Array();
			var currentF:Number = 0;
			
			if (canTOPL && (!TOPLnode.isChecked) && (!TOPLnode.isNextChecked)) {
				currentF = pathfindCalculateNext(TOPLnode, fromNode, toNode, 14);
				connectedNodes.push(TOPLnode);
			}
 			if (canTOPC && (!TOPCnode.isChecked)) {
				currentF = pathfindCalculate(TOPCnode, fromNode, toNode, 10);
				connectedNodes.push(TOPCnode);
			}
			if (canTOPR && (!TOPRnode.isChecked)) {
				currentF = pathfindCalculate(TOPRnode, fromNode, toNode, 14);
				connectedNodes.push(TOPRnode);
			}
			if (canMIDL && (!MIDLnode.isChecked)) {
				currentF = pathfindCalculate(MIDLnode, fromNode, toNode, 10);
				connectedNodes.push(MIDLnode);
			}
			if (canMIDR && (!MIDRnode.isChecked)) {
				currentF = pathfindCalculate(MIDRnode, fromNode, toNode, 10);
				connectedNodes.push(MIDRnode);
			}
			if (canBOTL && (!BOTLnode.isChecked)) {
				currentF = pathfindCalculate(BOTLnode, fromNode, toNode, 14);
				connectedNodes.push(BOTLnode);
			}
			if (canBOTC && (!BOTCnode.isChecked)) {
				currentF = pathfindCalculate(BOTCnode, fromNode, toNode, 10);
				connectedNodes.push(BOTCnode);
			}
			if (canBOTR && (!BOTRnode.isChecked)) {
				currentF = pathfindCalculate(BOTRnode, fromNode, toNode, 14);
				connectedNodes.push(BOTRnode);
			}
			
			return null;
		}

		public function Node() {
			layout = new LIB_Node();
			x_ConnectedWalkableNodes = new Vector.<Node>;
			_doorGlowFilter = new GlowFilter();
			
			colorOff.color = 0xE6E2DB;
			colorOn.color = 0xCEC7BB;
			
			_singleConnectedNode = null;
			_connectedNodesCount = 0;
			_connectedWalkableNodesCount = 0;

			setBorders(Thickness.NONE, Thickness.NONE, Thickness.NONE, Thickness.NONE);
			setDoors(false, false, false, false);
			
			layout.borderThin.visible = true;
			
			layout.nodePoint.visible = false;
			
			layout.borderNormalL.visible = false;
			layout.borderNormalT.visible = false;
			layout.borderNormalR.visible = false;
			layout.borderNormalB.visible = false;
			
			layout.borderThickL.visible = false;
			layout.borderThickT.visible = false;
			layout.borderThickB.visible = false;
			layout.borderThickR.visible = false;
			
			layout.fldID.mouseEnabled = false;
			layout.fldF.mouseEnabled = false;
			//layout.fldG.mouseEnabled = false;
			//layout.fldH.mouseEnabled = false;
			
			this.layout.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			this.layout.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
			
		}
		
		private function handleMouseOver(e:MouseEvent):void {
			room.highLightOn();
		}
		
		private function handleMouseOut(e:MouseEvent):void {
			room.highLightOff();
		}
		
		public function highLightOn():void {
			layout.square.transform.colorTransform = colorOn;
		}
		
		public function highLightOff():void {
			layout.square.transform.colorTransform = colorOff;
		}
		
		public function showPoint ():void {
			layout.nodePoint.visible = true;
		}
		
		public function hidePoint():void {
			layout.nodePoint.visible = false;
		}
		
		public function setDoors(L:Boolean, T:Boolean, R:Boolean, B:Boolean):void {
			var door:Door;
			
			layout.doorL.visible = L;
			layout.doorT.visible = T;
			layout.doorR.visible = R;
			layout.doorB.visible = B;

			if (L == false && T == false && R == false && B == false) {
				_connectedDoorsCount = 0;
			} else if (L == true && T == true && R == true && B == true) {
				_connectedDoorsCount = 3;
			} else {
				_connectedDoorsCount = 1;
			}
			
			doorL = L;
			doorT = T;
			doorR = R;
			doorB = B;
			
			if (L) {
				door = layout.doorL as Door;
				
				door.addEventListener(MouseEvent.MOUSE_OVER, handleDoorMouseOver);
				door.addEventListener(MouseEvent.MOUSE_OUT, handleDoorMouseOut);
				door.addEventListener(MouseEvent.CLICK, handleDoorClick);
			}
			if (T) {
				door = layout.doorT as Door;
				
				door.addEventListener(MouseEvent.MOUSE_OVER, handleDoorMouseOver);
				door.addEventListener(MouseEvent.MOUSE_OUT, handleDoorMouseOut);
				door.addEventListener(MouseEvent.CLICK, handleDoorClick);
			}
			if (R) {
				door = layout.doorR as Door;
				
				door.addEventListener(MouseEvent.MOUSE_OVER, handleDoorMouseOver);
				door.addEventListener(MouseEvent.MOUSE_OUT, handleDoorMouseOut);
				door.addEventListener(MouseEvent.CLICK, handleDoorClick);
			}
			if (B) {
				door = layout.doorB as Door;
				
				door.addEventListener(MouseEvent.MOUSE_OVER, handleDoorMouseOver);
				door.addEventListener(MouseEvent.MOUSE_OUT, handleDoorMouseOut);
				door.addEventListener(MouseEvent.CLICK, handleDoorClick);
			}
		}
		
		private function handleDoorMouseOver(e:MouseEvent):void {
			if (e.target.parent is LIB_Node) {
				(e.target).filters = [_doorGlowFilter];
			} else {
				(e.target.parent as MovieClip).filters = [_doorGlowFilter];
			}
			
		}
		private function handleDoorMouseOut(e:MouseEvent):void {
			if (e.target.parent is LIB_Node) {
				(e.target).filters = [];
			} else {
				(e.target.parent as MovieClip).filters = [];
			}
		}
		
		public function openDoorT():void {
			if (layout.doorT != undefined && !(layout.doorT.currentFrame > 1 && layout.doorT.currentFrame < 10)) {
				openDoor(layout.doorT as Door);
			}
		}
		
		public function openDoorL():void {
			if (layout.doorL != undefined && !(layout.doorL.currentFrame > 1 && layout.doorL.currentFrame < 10)) {
				openDoor(layout.doorL as Door);
			}
		}
		
		public function openDoorB():void {
			if (layout.doorB != undefined && !(layout.doorB.currentFrame > 1 && layout.doorB.currentFrame < 10)) {
				openDoor(layout.doorB as Door);
			}
		}
		
		private function openDoor(door:Door):void {
			door.gotoAndPlay(2);
		}
		
		public function closeDoors():void {
			if ((doorL) && (layout.doorL.currentFrame == 10)) {
				layout.doorL.gotoAndPlay(11);
			}
			if ((doorT) && (layout.doorT.currentFrame == 10)) {
				layout.doorT.gotoAndPlay(11);
			}
			if ((doorR) && (layout.doorR.currentFrame == 10)) {
				layout.doorR.gotoAndPlay(11);
			}
			if ((doorB) && (layout.doorB.currentFrame == 10)) {
				layout.doorB.gotoAndPlay(11);
			}
		}
		
		private function handleDoorClick(e:MouseEvent):void {
			trace("handleDoorClick. e.target = " + e.target + " and e.target.parent = " + e.target.parent);
			
			var target:Door;
			
			if (e.target.parent is LIB_Door) {
				target = e.target.parent as Door;
			} else {
				target = e.target as Door;
			}
			
			target.filters = [];
			
			if (target.isPlaying == false) {
				target.play();
			} else {
				var intPosition:int = target.currentFrame;
				
				intPosition += 15;
				
				if (intPosition > 30) {
					intPosition = 30 - intPosition;
				}
				
				target.gotoAndPlay(intPosition);
				
			}

			//(e.target as MovieClip).gotoAndPlay(16);
			/*
			if (e.target.parent.isOpen) {
				(e.target as MovieClip).gotoAndPlay(16);
				e.target.isOpen = false;
			} else {
				(e.target.parent as MovieClip).play();
				e.target.isOpen = true;
			}
			*/
		}		
		
		public function setBorders(thicknessL:Number, thicknessT:Number, thicknessR:Number, thicknessB:Number):void {
			setBorderL(thicknessL);
			setBorderT(thicknessT);
			setBorderR(thicknessR);
			setBorderB(thicknessB);
		}
		
		public function setBorderL(thickness:Number):void {
			this.borderL = thickness;
			
			if (thickness == Thickness.NONE) {
				layout.borderNormalL.visible = false;
				layout.borderThickL.visible = false;
			} else if (thickness == Thickness.NORMAL) {
				layout.borderNormalL.visible = true;
				layout.borderThickL.visible = false;
			} else if (thickness == Thickness.THICK) {
				layout.borderNormalL.visible = true;
				layout.borderThickL.visible = true;
			}
		}
		
		public function setBorderT(thickness:Number):void {
			this.borderT = thickness;
			
			if (thickness == Thickness.NONE) {
				layout.borderNormalT.visible = false;
				layout.borderThickT.visible = false;
			} else if (thickness == Thickness.NORMAL) {
				layout.borderNormalT.visible = true;
				layout.borderThickT.visible = false;
			} else if (thickness == Thickness.THICK) {
				layout.borderNormalT.visible = true;
				layout.borderThickT.visible = true;
			}			
		}
		
		public function setBorderR(thickness:Number):void {
			this.borderR = thickness;
			
			if (thickness == Thickness.NONE) {
				layout.borderNormalR.visible = false;
				layout.borderThickR.visible = false;
			} else if (thickness == Thickness.NORMAL) {
				layout.borderNormalR.visible = true;
				layout.borderThickR.visible = false;
			} else if (thickness == Thickness.THICK) {
				layout.borderNormalR.visible = true;
				layout.borderThickR.visible = true;
			}			
		}
		
		public function setBorderB(thickness:Number):void {
			this.borderB = thickness;
			
			if (thickness == Thickness.NONE) {
				layout.borderNormalB.visible = false;
				layout.borderThickB.visible = false;
			} else if (thickness == Thickness.NORMAL) {
				layout.borderNormalB.visible = true;
				layout.borderThickB.visible = false;
			} else if (thickness == Thickness.THICK) {
				layout.borderNormalB.visible = true;
				layout.borderThickB.visible = true;
			}			
		}
	}
}