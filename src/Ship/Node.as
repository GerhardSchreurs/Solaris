package Ship {
	import State.DEFAULTS;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextColorType;
	import Ship.Enum.Navigation;
	import Ship.Enum.Thickness;
	import State.*;
	import flash.filters.*;

	public class Node implements IDisposable {
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
		
		public var isOuterNode:Boolean;
		
		//new
		public var connectedWalkableNodes:Vector.<Node>;
		public var doors:Vector.<Door>;
		public var room:Room;
		public var connectedRoom:Room;

		public var ship:Ship;
		
		public var ID:Number;
		private var _parentNode:Node;

		public var X:Number;
		public var Y:Number;
		public var layout:LIB_Node;

		public var hasDoorL:Boolean;
		public var hasDoorT:Boolean;
		public var hasDoorR:Boolean;
		public var hasDoorB:Boolean;
		
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
		
		private var _connectedNodesCount:int;
		private var _connectedWalkableNodesCount:int;
		private var _connectedDoorsCount:int;

		private var _parentNodeCount:int = 0;

		public var isDeadEnd:Boolean;

		private var colorOn:ColorTransform = new ColorTransform();
		private var colorOff:ColorTransform = new ColorTransform();
		private var _doorGlowFilter:GlowFilter;
		
		private var _isDisposed:Boolean;
		
		public var hasAirLock:Boolean;
		
		public function Node() {
			layout = new LIB_Node();
			connectedWalkableNodes = new Vector.<Node>;
			doors = new Vector.<Door>();
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
			
			//highlighting
			//this.layout.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			//this.layout.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
		}
		
		public function init():void {
			checkForDeadEnds();
			initDoors();
			calculateBounds();
		}
		
		public function update(tick:int):void {
			var i:int;
			
			
			/*
			for (i == nodesLength; i--) {
				nodes[i].update();
			}
			*/
		}
		
		internal function registerAirLock():void {
			hasAirLock = true;
			room.registerAirLock();
			ship.registerAirLock();
			//ship.registerAirLock(this);
		}
		
		internal function unregisterAirLock():void {
			hasAirLock = false;
			ship.unregisterAirLock();
		}
		
		
		internal function queryStatus():void {
			ship.queryStatus(this);
		}
		

		//{ Asscessors
			//{ TOP/BOT/MID
			public function set TOPLnode(value:Node):void {
				if (value != undefined) {
					_TOPLnode = value;
					_connectedNodesCount += 1;
					_singleConnectedNode = value;
					
					if ((this.borderT == 1) && (this.borderL == 1)) {
						canTOPL = true;
						//new
						connectedWalkableNodes.push(value);
					}
				}
			}
			
			public function set TOPCnode(value:Node):void {
				if (value != undefined) {
					_TOPCnode = value;
					_connectedNodesCount += 1;
					_singleConnectedNode = value;
					
					if ((this.borderT == 1) || (this.hasDoorT)) {
						canTOPC = true;
						//new
						connectedWalkableNodes.push(value);
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
						connectedWalkableNodes.push(value);
					}
				}
			}

			public function set MIDLnode(value:Node):void {
				if (value != undefined) {
					_MIDLnode = value;
					_connectedNodesCount += 1;
					_singleConnectedNode = value;
					
					if ((this.borderL == 1) || (this.hasDoorL)) {
						canMIDL = true;
						//new
						connectedWalkableNodes.push(value);
					}
				}
			}
			
			public function set MIDRnode(value:Node):void {
				if (value != undefined) {
					_MIDRnode = value;
					_connectedNodesCount += 1;
					_singleConnectedNode = value;
					
					if ((this.borderR == 1) || (this.hasDoorR)) {
						canMIDR = true;
						//new
						connectedWalkableNodes.push(value);
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
						connectedWalkableNodes.push(value);
					}
				}
			}
			
			public function set BOTCnode(value:Node):void {
				if (value != undefined) {
					_BOTCnode = value;
					_connectedNodesCount += 1;
					_singleConnectedNode = value;
					
					if ((this.borderB == 1) || (this.hasDoorB)) {
						canBOTC = true;
						//new
						connectedWalkableNodes.push(value);
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
						connectedWalkableNodes.push(value);
					}
				}
			}
			//}

		public function get parentNode():Node {
			return this._parentNode;
		}

		public function set parentNode(value:Node):void  {
			this._parentNode = value;
			
			if (_parentNode != null) {
				_parentNodeCount = _parentNode.parentNodeCount + 1;
			}
		}

		public function get parentNodeCount():int {
			return _parentNodeCount;
		}
		
		public function get connectedNodesCount():int {
			return _connectedNodesCount;
		}

		public function get connectedDoorsCount():int {
			return _connectedDoorsCount;
		}
		//}
		
		//{ Display
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
		//}
		
		//{ Borders
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
		//}
		
		//{ Doors 
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
		
		///<b>WARNING!!!</b> Call only for dispose!
		private function removeDoorLeft():void {
			layout.doorL.removeEventListener(MouseEvent.MOUSE_OVER, handleDoorMouseOver);
			layout.doorL.removeEventListener(MouseEvent.MOUSE_OUT, handleDoorMouseOut);
			layout.doorL.removeEventListener(MouseEvent.CLICK, handleDoorClick);
			
			layout.removeChild(layout.doorL);
		}
		
		///<b>WARNING!!!</b> Call only for dispose!
		private function removeDoorTop():void {
			layout.doorT.removeEventListener(MouseEvent.MOUSE_OVER, handleDoorMouseOver);
			layout.doorT.removeEventListener(MouseEvent.MOUSE_OUT, handleDoorMouseOut);
			layout.doorT.removeEventListener(MouseEvent.CLICK, handleDoorClick);
			
			layout.removeChild(layout.doorT);
		}
		
		public function initDoors():void {
			if (ID == 29 && ship.shipName == "The Kestrel") {
				trace("3:wroah");
			}
			
			//Remove Double Doors
			if (hasDoorT && (_TOPCnode != undefined)) {
				if (_TOPCnode.hasDoorB) {
					//remove target doorB
					_TOPCnode.removeDoorBottom();
				}
			}
			
			if (hasDoorL && (_MIDLnode != undefined)) {
				if (_MIDLnode.hasDoorR) {
					//remove target doorR
					_MIDLnode.removeDoorRight();
				}
			}
			
			
			//Set connected nodes
			if (hasDoorL && _canMIDL) {
				layout.doorL.connectedNode = MIDLnode;
				doors.push(layout.doorL);
			}
			if (hasDoorT && _canTOPC) {
				layout.doorT.connectedNode = TOPCnode;
			}
			if (hasDoorR && _canMIDR) {
				layout.doorR.connectedNode = MIDRnode;
			}
			if (hasDoorB && _canBOTC) {
				layout.doorB.connectedNode = BOTCnode;
			}
			
			//Set outerDoor flags
			if (hasDoorL && !_canMIDL) {
				layout.doorL.isOuterDoor = true;
				isOuterNode = true;
			}
			if (hasDoorT && !_canTOPC) {
				layout.doorT.isOuterDoor = true;
				isOuterNode = true;
			}
			if (hasDoorR && !_canMIDR) {
				layout.doorR.isOuterDoor = true;
				isOuterNode = true;
			}
			if (hasDoorB && !_canBOTC) {
				layout.doorB.isOuterDoor = true;
				isOuterNode = true;
			}
			
			/*
			if (hasDoorL) {
				if (_canMIDL) {
					layout.doorL.connectedNode = MIDLnode;
				} else {
					layout.doorL.isOuterDoor = true;
					isOuterNode = true;
				}
			} else if (hasDoorT) {
				if (_canTOPC) {
					layout.doorT.connectedNode = TOPCnode;
				} else {
					layout.doorT.isOuterDoor = true;
					isOuterNode = true;
				}
			} else if (hasDoorR) {
				if (_canMIDR) {
					layout.doorR.connectedNode = MIDRnode;
				} else {
					layout.doorR.isOuterDoor = true;
					isOuterNode = true;
				}
			} else if (hasDoorB) {
				if (_canBOTC) {
					layout.doorB.connectedNode = BOTCnode;
				} else {
					layout.doorB.isOuterDoor = true;
					isOuterNode = true;
				}
			}
			*/
			
			/*
			if (hasDoorL && !_canMIDL) {
				layout.doorL.isOuterDoor = true;
				isOuterNode = true;
			} else if (hasDoorT && !_canTOPC) {
				layout.doorT.isOuterDoor = true;
				isOuterNode = true;
			} else if (hasDoorR && !_canMIDR) {
				layout.doorR.isOuterDoor = true;
				isOuterNode = true;
			} else if (hasDoorB && !_canBOTC) {
				layout.doorB.isOuterDoor = true;
				isOuterNode = true;
			}
			*/
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
			
			hasDoorL = L;
			hasDoorT = T;
			hasDoorR = R;
			hasDoorB = B;
			
			//TODO: Try to place doors in wrapper movieclip and handle events
			//there (optimisation)
			if (L) {
				door = layout.doorL;
				door.node = this;
				
				door.addEventListener(MouseEvent.MOUSE_OVER, handleDoorMouseOver);
				door.addEventListener(MouseEvent.MOUSE_OUT, handleDoorMouseOut);
				door.addEventListener(MouseEvent.CLICK, handleDoorClick);
			}
			if (T) {
				door = layout.doorT;
				door.node = this;
				
				door.addEventListener(MouseEvent.MOUSE_OVER, handleDoorMouseOver);
				door.addEventListener(MouseEvent.MOUSE_OUT, handleDoorMouseOut);
				door.addEventListener(MouseEvent.CLICK, handleDoorClick);
			}
			if (R) {
				door = layout.doorR;
				door.node = this;
				
				door.addEventListener(MouseEvent.MOUSE_OVER, handleDoorMouseOver);
				door.addEventListener(MouseEvent.MOUSE_OUT, handleDoorMouseOut);
				door.addEventListener(MouseEvent.CLICK, handleDoorClick);
			}
			if (B) {
				door = layout.doorB;
				door.node = this;
				
				door.addEventListener(MouseEvent.MOUSE_OVER, handleDoorMouseOver);
				door.addEventListener(MouseEvent.MOUSE_OUT, handleDoorMouseOut);
				door.addEventListener(MouseEvent.CLICK, handleDoorClick);
			}
		}
		
		private function handleDoorMouseOver(e:MouseEvent):void {
			//trace("I'm mouseover too!");
			
			/*
			if (e.target.parent is LIB_Node) {
				(e.target).filters = [_doorGlowFilter];
			} else {
				(e.target.parent as MovieClip).filters = [_doorGlowFilter];
			}
			*/
			
		}
		private function handleDoorMouseOut(e:MouseEvent):void {
			/*
			if (e.target.parent is LIB_Node) {
				(e.target).filters = [];
			} else {
				(e.target.parent as MovieClip).filters = [];
			}
			*/
		}
		
		private function registerOpenDoor(door:Door) {
			door.registerOpen();
		}
		
		public function registerOpenDoorL():void {
			if (layout.doorL != undefined) {
				registerOpenDoor(layout.doorL);
			}
		}
		
		public function registerOpenDoorT():void {
			if (layout.doorT != undefined) {
				registerOpenDoor(layout.doorT);
			}
		}
		
		public function openDoorT():void {
			if (layout.doorT != undefined) {
				openDoor(layout.doorT);
			}
			
			
			/*
			if (layout.doorT != undefined && !(layout.doorT.currentFrame > 1 && layout.doorT.currentFrame < 10)) {
				openDoor(layout.doorT as Door);
			}
			*/
		}
		
		public function openDoorL():void {
			if (layout.doorL != undefined) {
				openDoor(layout.doorL);
			}
			/*
			if (layout.doorL != undefined && !(layout.doorL.currentFrame > 1 && layout.doorL.currentFrame < 10)) {
				openDoor(layout.doorL as Door);
			}
			*/
		}
		
		public function openDoorB():void {
			if (layout.doorB != undefined) {
				openDoor(layout.doorB);
			}
			
			/*
			if (layout.doorB != undefined && !(layout.doorB.currentFrame > 1 && layout.doorB.currentFrame < 10)) {
				openDoor(layout.doorB as Door);
			}
			*/
		}
		
		private function openDoor(door:Door):void {
			door.open();
			//door.gotoAndPlay(2);
		}
		
		public function resetDoors():void {
			if (hasDoorL) {
				layout.doorL.reset();
			}
			if (hasDoorT) {
				layout.doorT.reset();
			}
			if (hasDoorR) {
				layout.doorR.reset();
			}
			if (hasDoorB) {
				layout.doorB.reset();
			}
		}
		
		public function closeDoors():void {
			if (hasDoorL) {
				layout.doorL.close();
			}
			if (hasDoorT) {
				layout.doorT.close();
			}
			if (hasDoorR) {
				layout.doorR.close();
			}
			if (hasDoorB) {
				layout.doorB.close();
			}
			
			/*
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
			*/
		}
		
		private function handleDoorClick(e:MouseEvent):void {
			return;
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
		
		//}
		
		//{ TOP/MID/BOT Functions
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
		//}
		
		//{ PathFind LOGIC
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
		
		public function clearNode():void {
			this.parentNode = null;
			_parentNodeCount = 0;
			_connectedNodesCount = 0;
			_connectedWalkableNodesCount = 0;
			_singleConnectedNode = null;
		}
		
		public function checkForDeadEnds():void {
			if (this.connectedWalkableNodes.length == 1) {
				this.isDeadEnd = true;
				this.layout.fldID.textColor = 0xFF0000;
			} else if (this.connectedWalkableNodes.length == 3) {
				if (this._connectedDoorsCount == 0) {
					this.isDeadEnd = true;
					this.layout.fldID.textColor = 0xFF0000;
				}
			}
		}
		
		public function getNeighbourNodes():Vector.<Node> {
			return room.nodes;
		}
		//}
		
		public function get isDisposed():Boolean {
			return _isDisposed;
		}
		
		public function dispose():void {
			//trace("Node.dispose(" + _isDisposed + ")");
			if (_isDisposed) { return; }
			
			if (layout.doorL != null) {
				if (layout.contains(layout.doorL)) {
					removeDoorLeft();
				}
				
				(layout.doorL as Door).dispose();
				layout.doorL = null;
			}
			if (layout.doorR != null) {
				if (layout.contains(layout.doorR)) {
					removeDoorRight();
				}
				
				(layout.doorR as Door).dispose();
				layout.doorR = null;
			}
			if (layout.doorT != null) {
				if (layout.contains(layout.doorT)) {
					removeDoorTop();
				}
				
				(layout.doorT as Door).dispose();
				layout.doorT = null;
			}
			if (layout.doorB != null) {
				if (layout.contains(layout.doorB)) {
					removeDoorBottom();
				}
				
				(layout.doorB as Door).dispose();
				layout.doorB = null;
			}	


			_parentNode = null;
			_TOPLnode = null;
			_TOPCnode = null;
			_TOPRnode = null;
			_MIDLnode = null;
			_MIDRnode = null;
			_BOTLnode = null;
			_BOTCnode = null;
			_BOTRnode = null;
			_singleConnectedNode = null;

			connectedWalkableNodes = null;
			room = null;
			ship = null;
			
			layout = null;

			colorOn = null;
			colorOff = null;
			_doorGlowFilter = null;
			
			_isDisposed = true;
		}
	}
}