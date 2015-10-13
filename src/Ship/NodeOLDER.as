package Ship {
	import flash.display.MovieClip;
	import flash.display3D.textures.VideoTexture;
	import flash.geom.Point;
	import flash.media.AVSource;
	import Ship.Enum.Compas;
	import Ship.Enum.Navigation;
	import Ship.Enum.Thickness;
	
	public class NodeOLD {
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
		public var canTOPL:Boolean;
		public var canTOPC:Boolean;
		public var canTOPR:Boolean;
		public var canMIDL:Boolean;
		public var canMIDR:Boolean;
		public var canBOTL:Boolean;
		public var canBOTC:Boolean;
		public var canBOTR:Boolean;
		
		private var _TOPLnode:Node;
		private var _TOPCnode:Node;
		private var _TOPRnode:Node;
		private var _MIDLnode:Node;
		private var _MIDRnode:Node;
		private var _BOTLnode:Node;
		private var _BOTCnode:Node;
		private var _BOTRnode:Node;
		
		public var isChecked:Boolean;
		public var F:Number;
		public var G:Number;
		public var H:Number;
		
		public function set parentNode(value:Node):void  {
			this._parentNode = value;
		}
		public function get parentNode():Node {
			return this._parentNode;
		}
		
		
		public function set TOPLnode(value:Node):void {
			if (value != undefined) {
				_TOPLnode = value;
				
				if ((this.borderT == 1) && (this.borderL == 1)) {
					canTOPL = true;
				}
			}
		}
		
		public function set TOPCnode(value:Node):void {
			if (value != undefined) {
				_TOPCnode = value;
				
				if ((this.borderT == 1) || (this.doorT)) {
					canTOPC = true;
				}
			}
		}
		public function set TOPRnode(value:Node):void {
			if (value != undefined) {
				_TOPRnode = value;
				
				if ((this.borderT == 1) && (this.borderR == 1)) {
					canTOPR = true;
				}
			}
		}
		public function set MIDLnode(value:Node):void {
			if (value != undefined) {
				_MIDLnode = value;
				
				if ((this.borderL == 1) || (this.doorL)) {
					canMIDL = true;
				}
			}
		}
		public function set MIDRnode(value:Node):void {
			if (value != undefined) {
				_MIDRnode = value;
				
				if ((this.borderR == 1) || (this.doorR)) {
					canMIDR = true;
				}
			}
		}
		public function set BOTLnode(value:Node):void {
			if (value != undefined) {
				_BOTLnode = value;
				
				if ((this.borderL == 1) && (this.borderB == 1)) {
					canBOTL = true;
				}
			}
		}
		public function set BOTCnode(value:Node):void {
			if (value != undefined) {
				_BOTCnode = value;
				
				if ((this.borderB == 1) || (this.doorB)) {
					canBOTC = true;
				}
			}
		}
		public function set BOTRnode(value:Node):void {
			if (value != undefined) {
				_BOTRnode = value;
				
				if ((this.borderR == 1) && (this.borderB == 1)) {
					canBOTR = true;
				}
			}
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
		
		public function pathfindCalculate(targetNode:Node, fromNode:Node, toNode:Node, gCost:Number):void {
			targetNode.isChecked = true;
			targetNode.parentNode = this;
			targetNode.G = gCost;
			targetNode.H = pathfindCalculateH(targetNode, toNode);
			targetNode.F = targetNode.G + targetNode.H;
			
			trace("pathfindCalculate for targetNode" + targetNode.ID + " x=" + targetNode.X + ",y=" + targetNode.Y + "|f=" + targetNode.F + ",g=" + targetNode.G + ",h=" + targetNode.H); 
		}
		
		public function pathfindCalculateH(fromNode:Node, toNode:Node):Number {
			//((Math.abs(this.posX - nodeStop.posX)) + (Math.abs(this.posY - nodeStop.posY))) * 10
			
			return ((Math.abs(fromNode.X - toNode.X)) + (Math.abs(fromNode.Y - toNode.Y))) * 10;
		}
		
		public function pathfind(searchList:Vector.<Node>, fromNode:Node, toNode:Node):void {
			//check 8 connected nodes;
			
			this.isChecked = true;

			if (canTOPL && (!TOPLnode.isChecked)) {
				pathfindCalculate(TOPLnode, fromNode, toNode, 14);
				searchList.push(TOPLnode);
			}
			if (canTOPC && (!TOPCnode.isChecked)) {
				pathfindCalculate(TOPCnode, fromNode, toNode, 10);
				searchList.push(TOPCnode);
			}
			if (canTOPR && (!TOPRnode.isChecked)) {
				pathfindCalculate(TOPRnode, fromNode, toNode, 14);
				searchList.push(TOPRnode);
			}
			if (canMIDL && (!MIDLnode.isChecked)) {
				pathfindCalculate(MIDLnode, fromNode, toNode, 10);
				searchList.push(MIDLnode);
			}
			if (canMIDR && (!MIDRnode.isChecked)) {
				pathfindCalculate(MIDRnode, fromNode, toNode, 10);
				searchList.push(MIDRnode);
			}
			if (canBOTL && (!BOTLnode.isChecked)) {
				pathfindCalculate(BOTLnode, fromNode, toNode, 14);
				searchList.push(BOTLnode);
			}
			if (canBOTC && (!BOTCnode.isChecked)) {
				pathfindCalculate(BOTCnode, fromNode, toNode, 10);
				searchList.push(BOTCnode);
			}
			if (canBOTR && (!BOTRnode.isChecked)) {
				pathfindCalculate(BOTRnode, fromNode, toNode, 14);
				searchList.push(BOTRnode);
			}
		}
		
		public function Node() {
			layout = new LIB_Node();
			
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
			layout.borderThickR.visible = false;
			layout.borderThickB.visible = false;
		}
		
		public function showPoint ():void {
			layout.nodePoint.visible = true;
		}
		
		public function hidePoint():void {
			layout.nodePoint.visible = false;
		}
		
		public function setDoors(L:Boolean, T:Boolean, R:Boolean, B:Boolean):void {
			layout.doorL.visible = L;
			layout.doorT.visible = T;
			layout.doorR.visible = R;
			layout.doorB.visible = B;
			
			doorL = L;
			doorT = T;
			doorR = R;
			doorB = B;
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