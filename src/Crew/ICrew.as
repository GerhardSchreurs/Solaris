package Crew {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.*;
	import Ship.Node;
	import Ship.NodeOLD;
	
	public class ICrew extends Sprite {
		private var _ID:Number;
		private var _crewName:String;
		private var _crewLayout:MovieClip;
		private var _crewPortrait:MovieClip;
		private var _glowFilter:GlowFilter;
		private var _node:Node;
		private var _path:Vector.<Node>;
		private var _pathIndex:int;
		private var _nodes:Vector.<Node>
		
		private var _moveX:int;
		private var _moveY:int;
		
		public var isSelected:Boolean;
		
		public function isInCenter():Boolean {
			if (((_crewLayout.x - node.layout.x) == 17) && ((_crewLayout.y - node.layout.y) == 17)) {
				return true;
			} else {
				return false;
			}
		}
		
		public function isWithinNode():Boolean {
			var returnValue:Boolean = false;
			
			
			return returnValue;
		}
		
		public function doStuff():void {
			//do i need to move?
			
			if (_path != null) {
				var modifierX:int = 17;
				var modifierY:int = 17;
				
				if (_pathIndex < _path.length) {
					//am i centered? if so, go to next node
					
					var nextNode:Node;
					
					if ((_pathIndex + 1) >= path.length) {
						nextNode = path[_pathIndex];
					} else {
						nextNode = path[_pathIndex + 1];
					}
					
					//trace("crewLayout = " + crewLayout.x + "," + crewLayout.y + " nextNode = " + (nextNode.layout.x + modifierX) + "," + (nextNode.layout.y + modifierY));

					if ((crewLayout.x == (nextNode.layout.x + modifierX)) && (crewLayout.y == (nextNode.layout.y + modifierY))) {
						//our crewmember arrived at a new node point
						trace("we reached a new node position! changing owner node")
						
						this.node = nextNode;
						_pathIndex += 1;
						_moveX = 0;
						_moveY = 0;
						
						if (_pathIndex == _path.length - 1) {
							//is this node the endpoint?
							trace("we've reached our destination!!!");
							_path = null;
							_pathIndex = 0;
							
							return;
						}
					}
					
					var currentNode:Node = node;
					
					//nextNode = path[_pathIndex + 1];
					
					if (_path.length == 1) {
						nextNode = node;
					} else {
						nextNode = path[_pathIndex + 1];
					}
					
					/*
					if ((_pathIndex + 1) >= path.length) {
						nextNode = path[_pathIndex];
					} else {
						nextNode = path[_pathIndex + 1];
					}
					*/
					
					//Are _moveX or _moveY set?
					if (_moveX == 0 && _moveY == 0) {
						trace("calculating");
						//we need to calculate
						
						if (nextNode == currentNode.TOPLnode) {
							_moveY = -1;
							_moveX = -1;
						} else if (nextNode == currentNode.TOPCnode) {
							_moveY = -1;
							_moveX = 0;
						} else if (nextNode == currentNode.TOPRnode) {
							_moveY = -1;
							_moveX = 1;
						} else if (nextNode == currentNode.MIDLnode) {
							_moveY = 0;
							_moveX = -1;
						} else if (nextNode == currentNode.MIDRnode) {
							_moveY = 0;
							_moveX = 1;
						} else if (nextNode == currentNode.BOTLnode) {
							_moveY = 1;
							_moveX = -1;
						} else if (nextNode == currentNode.BOTCnode) {
							_moveY = 1;
							_moveX = 0;
						} else if (nextNode == currentNode.BOTRnode) {
							_moveY = 1;
							_moveX = 1;
						} else if (nextNode == currentNode) {
							_moveX = 0;
							_moveY = 0;
							
							if (_crewLayout.x < (currentNode.layout.x + modifierX)) {
								_moveX += 1;
							} else if (_crewLayout.x > (currentNode.layout.x + modifierX)) {
								_moveY -= 1;
							}
							if (_crewLayout.y < (currentNode.layout.y + modifierY)) {
								_moveY += 1;
							} else if (_crewLayout.y > (currentNode.layout.y + modifierY)) {
								_moveY -= 1;
							}
						} else {
							trace("WRAAAA");
						}
					}
					
						
					this.crewLayout.x += _moveX;
					this.crewLayout.y += _moveY;
					
					trace("crewLayout = " + _crewLayout.x + "," + _crewLayout.y);
				}
			}
			
			
			
			
			//trace("node.x = " + this.node.layout.x + " me.x = " + this._crewLayout.x);
			//trace("node.y = " + this.node.layout.y + " me.y = " + this._crewLayout.y);
			//trace("");
			
			/*
			if (_path != null) {
				if (_pathIndex < _path.length) {
					
				} else {
					
				}
			}
			*/
		}
		
		public function set path(value:Vector.<Node>) {
			_moveX = 0;
			_moveY = 0;
			_path = value;
			_pathIndex = 0;
		}
		
		public function set nodes(value:Vector.<Node>) {
			_nodes = value;
		}
		
		public function get path():Vector.<Node> {
			return _path;
		}
		
		public function ICrew() {
			_glowFilter = new GlowFilter();
		}
		
		public function get ID():Number {
			return _ID;
		}
		
		public function set ID(value:Number):void {
			_ID = value;
		}
		
		public function get node():Node {
			return _node;
		}
		
		public function set node(value:Node):void {
			_node = value;
		}
		
		public function get crewName():String {
			return _crewName;
		}
		
		public function set crewName(value:String):void {
			_crewName = value;
		}
		
		public function get crewLayout():MovieClip {
			return _crewLayout;
		}
		
		public function set crewLayout(value:MovieClip):void {
			this._crewLayout = value;
		}
		
		public function get crewPortrait():MovieClip {
			return _crewPortrait;
		}
		
		public function selectMember():void {
			//var myGlow:GlowFilter = new GlowFilter();
			//my_mc.filters = [myBlur, myGlow];
			isSelected = true;
			this._crewLayout.filters = [_glowFilter];
		}
		
		public function deselectMember():void {
			isSelected = false;
			this._crewLayout.filters = [];
		}
		
		public function set crewPortrait(value:MovieClip):void {
			this._crewPortrait = value;
			
			_crewPortrait.width = 40;
			_crewPortrait.height = 40;
			_crewPortrait.x = 3;
			_crewPortrait.y = 3;
		}
	}
}