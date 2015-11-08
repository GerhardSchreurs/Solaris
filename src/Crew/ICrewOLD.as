package Crew {
	import Direction.*;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.*;
	import Ship.Node;
	import Ship.NodeOLD;
	import State.*;
	
	public class ICrewOLD extends Sprite {
		private var _ID:Number;
		private var _crewName:String;
		private var _crewLayout:MovieClip;
		private var _crewPortrait:MovieClip;
		private var _glowFilter:GlowFilter;
		private var _node:Node;
		private var _path:Vector.<Node>;
		private var _pathOld:Vector.<Node>;
		private var _pathIndex:int;
		private var _pathIndexOld:int;
		private var _pathHasChanged:Boolean;
		private var _nodes:Vector.<Node>
		
		private var _moveX:int;
		private var _moveY:int;
		
		public var isSelected:Boolean;

		//private var _modifierX:Number = 17;
		//private var _modifierY:Number = 17;
		//private var _nodeWidth:int = 36;
		//private var _nodeHeight:int = 36;
		private var _speedModifierPositive:int = 2;
		private var _speedModifierNegative:int = -2;
		
		
		/******************************************************************/
		
		function addLeadingZero(val:Number, places:int):String {
			var result:String = val.toString();
			for(var i:int = result.length; i < places; i++) {
				result = '0' + result;
			}
			return result;
		}
		
		public function printData(crew:ICrew, node:Node) {
			
		}
		
		
		public function set movePath(value:Vector.<Node>) {
			if (value == null) {
				trace("3:movePath() value == null!!");
				return;
			}
			
			_movePath = value;
			_movePathIndex = 0;
			_movePathChanged = true;
		}

		private var _moveDirection:IDirection;
		private var _movePath:Vector.<Node>;
		private var _movePathIndex:int;
		private var _movePathChanged:Boolean;

		public function enterFrame():void {
			if (_movePathChanged) {
				preMoveLoop();
			}
			
			moveLoop();
		}
		
		public function resetMovePath():void {
			_moveDirection = Directions.MIDCPOS;
			_movePath = null;
			_movePathIndex = 0;
		}
		
		public function getNextMovePathNode():Node {
			if ((_movePathIndex + 1) < _movePath.length) {
				return _movePath[_movePathIndex + 1];
			} else {
				return null;
			}
		}
		
		public function walkToCenter():void {
			//we go back to the center point of current node
					
			var crewX:int = crewLayout.x;
			var crewY:int = crewLayout.y;
			var centerX:int = node.layout.x + DEFAULTS.CrewOffset;
			var centerY:int = node.layout.y + DEFAULTS.CrewOffset;
			
			var data:String = " (crewX = " + crewX + " crewY = " + crewY + " centerX = " + centerX + " centerY = " + centerY + ")";
			
			if (crewX == centerX && crewY == centerY) {
				trace("walkToCenter() member is MIDC, do nothing" + data);
				return;
			} else if (crewX < centerX && crewY < centerY) {
				trace("walkToCenter() member is TOPL positioned from center" + data);
				_moveDirection = Directions.BOTRPOS;
			} else if (crewX == centerX && crewY < centerY) {
				trace("walkToCenter() member is TOPC positioned from center" + data);
				_moveDirection = Directions.BOTCPOS;
			} else if (crewX > centerX && crewY < centerY) {
				trace("walkToCenter() member is TOPR positioned from center" + data);
				_moveDirection = Directions.BOTLPOS;
			} else if (crewX < centerX && crewY == centerY) {
				trace("walkToCenter() member is MIDL positioned from center" + data);
				_moveDirection = Directions.MIDRPOS;
			} else if (crewX > centerX && crewY == centerY) {
				trace("walkToCenter() member is MIDR positioned from center" + data);
				_moveDirection = Directions.MIDLPOS;
			} else if (crewX < centerX && crewY > centerY) {
				trace("walkToCenter() member is BOTL positioned from center" + data);
				_moveDirection = Directions.TOPRPOS;
			} else if (crewX == centerX && crewY > centerY) {
				trace("walkToCenter() member is BOTC positioned from center" + data);
				_moveDirection = Directions.TOPCPOS;
			} else if (crewX > centerX && crewY > centerY) {
				trace("walkToCenter() member is BOTR positioned from center" + data);
				_moveDirection = Directions.TOPLPOS;
			} else {
				trace("3:walkToCenter() huh?!");
			}			
		}
		
		public function isWalkingInDirectionOfNextNode():Boolean {
			var returnValue:Boolean = false;
			var nextNode:Node = getNextMovePathNode();
			
			if (nextNode == node.TOPLnode && _moveDirection == Directions.TOPLPOS) {
				returnValue = true;
			} else if (nextNode == node.TOPCnode && _moveDirection == Directions.TOPCPOS) {
				returnValue = true;
			} else if (nextNode == node.TOPRnode && _moveDirection == Directions.TOPRPOS) {
				returnValue = true;
			} else if (nextNode == node.MIDLnode && _moveDirection == Directions.MIDLPOS) {
				returnValue = true;
			} else if (nextNode == node.MIDRnode && _moveDirection == Directions.MIDRPOS) {
				returnValue = true;
			} else if (nextNode == node.BOTLnode && _moveDirection == Directions.BOTLPOS) {
				returnValue = true;
			} else if (nextNode == node.BOTCnode && _moveDirection == Directions.BOTCPOS) {
				returnValue = true;
			} else if (nextNode == node.BOTRnode && _moveDirection == Directions.BOTRPOS) {
				returnValue = true;
			}
			
			trace("isWalkingInDirectionOfNextNode(from: " + node.ID + " to: " + nextNode.ID + ") will return: " + returnValue.toString());
			return returnValue;
		}
		
		public function preMoveLoop():void {
			trace("preMoveLoop()");
			
			if (_moveDirection != null) {
				//Currently moving to some position
				
				if (_movePath.length == 1) {
					walkToCenter();
				} else {
					if (isWalkingInDirectionOfNextNode()) {
						//Do nothing
						trace("preMoveLoop() is walking in right direction");
					} else {
						walkToCenter();
					}
				}
			}
			
			_movePathChanged = false;
		}
		
		public function moveLoop():void {
			if (_movePath == null) {
				return;
			}
			
			if (isCrewMemberInCenterOfNode(_movePath[_movePath.length - 1], false)) {
				trace("moveLoop() finished!!! in node: " + node.ID);
				//this is the last node of the current path. We are finished
				resetMovePath();
				return;
			}
			
			var currentNode:Node = node;
			var nextNode:Node = getNextMovePathNode();
			
			if (isCrewMemberInCenterOfNode(node, true)) {
				trace("moveLoop() we are centered in node : " + node.ID);
				_moveDirection = Directions.MIDCPOS;
			}
			
			if (_moveDirection == Directions.MIDCPOS) {
				trace("moveLoop() calculating");
				
				if (nextNode == currentNode.TOPLnode) {
					trace("moveLoop() moving TOPL from " + currentNode.ID + " to " + currentNode.TOPLnode.ID);
					_moveY = _speedModifierNegative;
					_moveX = _speedModifierNegative;
					_moveDirection = Directions.TOPLPOS;
				} else if (nextNode == currentNode.TOPCnode) {
					trace("moveLoop() moving TOPC from " + currentNode.ID + " to " + currentNode.TOPCnode.ID);
					_moveY = _speedModifierNegative;
					_moveX = 0;
					_moveDirection = Directions.TOPCPOS;
				} else if (nextNode == currentNode.TOPRnode) {
					trace("moveLoop() moving TOPR from " + currentNode.ID + " to " + currentNode.TOPRnode.ID);
					_moveY = _speedModifierNegative;
					_moveX = _speedModifierPositive;
					_moveDirection = Directions.TOPRPOS;
				} else if (nextNode == currentNode.MIDLnode) {
					trace("moveLoop() moving MIDL from " + currentNode.ID + " to " + currentNode.MIDLnode.ID);
					_moveY = 0;
					_moveX = _speedModifierNegative;
					_moveDirection = Directions.MIDLPOS;
				} else if (nextNode == currentNode.MIDRnode) {
					trace("moveLoop() moving MIDR from " + currentNode.ID + " to " + currentNode.MIDRnode.ID);
					_moveY = 0;
					_moveX = _speedModifierPositive;
					_moveDirection = Directions.MIDRPOS;
				} else if (nextNode == currentNode.BOTLnode) {
					trace("moveLoop() moving BOTL from " + currentNode.ID + " to " + currentNode.BOTLnode.ID);
					_moveY = _speedModifierPositive;
					_moveX = _speedModifierNegative;
					_moveDirection = Directions.BOTLPOS;
				} else if (nextNode == currentNode.BOTCnode) {
					trace("moveLoop() moving BOTC from " + currentNode.ID + " to " + currentNode.BOTCnode.ID);
					_moveY = _speedModifierPositive;
					_moveX = 0;
					_moveDirection = Directions.BOTCPOS;
				} else if (nextNode == currentNode.BOTRnode) {
					trace("moveLoop() moving BOTR from " + currentNode.ID + " to " + currentNode.BOTRnode.ID);
					_moveY = _speedModifierPositive;
					_moveX = _speedModifierPositive;
					_moveDirection = Directions.BOTRPOS;
				} else if (nextNode == currentNode) {
					trace("3: moveLoop() nextNode == currentNode")
					_moveX = 0;
					_moveY = 0;
					
					if (_crewLayout.x < (currentNode.layout.x + DEFAULTS.CrewOffset)) {
						_moveX += 1;
					} else if (_crewLayout.x > (currentNode.layout.x + DEFAULTS.CrewOffset)) {
						_moveY -= 1;
					}
					if (_crewLayout.y < (currentNode.layout.y + DEFAULTS.CrewOffset)) {
						_moveY += 1;
					} else if (_crewLayout.y > (currentNode.layout.y + DEFAULTS.CrewOffset)) {
						_moveY -= 1;
					}
				} else {
					trace("WRAAAA");
				}
			}
				
			if (nextNode != null) {
				if (isCrewMemberInBoundariesOfNode(nextNode)) {
					trace("moveLoop() crewMember is node " + node.ID + " and In Boundaries Of Next Node " + nextNode.ID);
					trace("moveLoop() (crewX = " + crewLayout.x + " crewY = " + crewLayout.y + " centerX = " + (node.layout.x + DEFAULTS.CrewOffset) + " centerY = " + (node.layout.y + DEFAULTS.CrewOffset));
					//trace("crewMember is in boundaries of next node. Changing node");
					//trace("currentNode = " + node.ID + ", next node = " + nextNode.ID);
					//traceOutput(null);
					
					node = nextNode;
					_movePathIndex += 1;
				}
			}
			
			//this.crewLayout.x += _moveX;
			//this.crewLayout.y += _moveY;			
			this.crewLayout.x += _moveDirection.x;
			this.crewLayout.y += _moveDirection.y;			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/*****************************************************************/
		
		
		public function isInCenter():Boolean {
			if (((_crewLayout.x - node.layout.x) == DEFAULTS.CrewOffset) && ((_crewLayout.y - node.layout.y) == DEFAULTS.CrewOffset)) {
				return true;
			} else {
				return false;
			}
		}
		
		public function isCrewMemberInCenterOfNode(node:Node, traceDebug:Boolean):Boolean {
			var returnValue:Boolean = false;
			
			if ((crewLayout.x == (node.layout.x + DEFAULTS.CrewOffset)) && (crewLayout.y == (node.layout.y + DEFAULTS.CrewOffset))) {
				returnValue = true;
			}
			
			var debug:String = "isCrewMemberInCenterOfNode() node " + node.ID + " (";
			debug += returnValue.toString() + ") ";
			debug += "centerX = " + (node.layout.x + DEFAULTS.CrewOffset) + " centerY = " + (node.layout.y + DEFAULTS.CrewOffset) + ", ";
			debug += "crewX = " + crewLayout.x + " crewY = " + crewLayout.y;
			
			if (traceDebug) {
				trace(debug);
			}

			return returnValue;
		}
		
		public function isCrewMemberInBoundariesOfNode(targetNode:Node):Boolean {
			
			//trace("node.x = " + node.layout.x + " node.y = " + node.layout.y);
			//trace("crew.x = " + crewLayout.x + " crew.y = " + crewLayout.y);
			
			var debugString:String = "";
			
			debugString += "isCrewMemberInBoundariesOfNode (current = " + node.ID + " targetNode = " + targetNode.ID + ") : ";
			debugString += "crewLayout.x = " + crewLayout.x + " crewLayout.y = " + crewLayout.y + " ";
			debugString += "target.x = " + targetNode.layout.x + "(" + (targetNode.layout.x + DEFAULTS.NodeSize) + ") ";
			debugString += "target.y = " + targetNode.layout.y + "(" + (targetNode.layout.y + DEFAULTS.NodeSize) + ")";
			
			//trace(debugString);
			
			return (crewLayout.x > targetNode.layout.x) && (crewLayout.x < (targetNode.layout.x + DEFAULTS.NodeSize)) && (crewLayout.y > targetNode.layout.y) && (crewLayout.y < (targetNode.layout.y + DEFAULTS.NodeSize));
			//return node.layout.hitTestPoint(crewLayout.x, crewLayout.y, true);
			
			
			/*
			if (crewLayout.hitTestObject(node.layout)) {
				return true;
			} else {
				return false;
			}
			*/
		}
		
		public function isCrewMemberInBoundariesOfNodeOLD(targetNode:Node):Boolean {
			
			//trace("node.x = " + node.layout.x + " node.y = " + node.layout.y);
			//trace("crew.x = " + crewLayout.x + " crew.y = " + crewLayout.y);
			
			var debugString:String = "";
			
			debugString += "isCrewMemberInBoundariesOfNode (current = " + node.ID + " targetNode = " + targetNode.ID + ") : ";
			debugString += "crewLayout.x = " + crewLayout.x + " crewLayout.y = " + crewLayout.y + " ";
			debugString += "target.x = " + targetNode.layout.x + "(" + (targetNode.layout.x + targetNode.layout.width) + ") ";
			debugString += "target.y = " + targetNode.layout.y + "(" + (targetNode.layout.y + targetNode.layout.height) + ")";
			
			trace(debugString);
			
			return (crewLayout.x > targetNode.layout.x) && (crewLayout.x < (targetNode.layout.x + targetNode.layout.width)) && (crewLayout.y > targetNode.layout.y) && (crewLayout.y < (targetNode.layout.y + targetNode.layout.height));
			//return node.layout.hitTestPoint(crewLayout.x, crewLayout.y, true);
			
			
			/*
			if (crewLayout.hitTestObject(node.layout)) {
				return true;
			} else {
				return false;
			}
			*/
		}
		
		public function inverseModifiers():void {
			if (_moveX == _speedModifierPositive) {
				_moveX = _speedModifierNegative;
			} else {
				_moveX = _speedModifierPositive;
			}
			if (_moveY = _speedModifierPositive) {
				_moveY = _speedModifierNegative;
			} else {
				_moveY = _speedModifierPositive;
			}
		}
		
		public function reverseModifiers():void {
			//only reverse when we are moving away
			
			//get center point of targetnode
			var crewX:int = crewLayout.x;
			var crewY:int = crewLayout.y;
			var centerX:int = node.layout.x + DEFAULTS.CrewOffset;
			var centerY:int = node.layout.y + DEFAULTS.CrewOffset;
			
			if (crewX < centerX && crewY < centerY) {
				trace("topL");
				//TOPL
				_moveX = _speedModifierPositive;
				_moveY = _speedModifierPositive;
			} else if (crewX < centerX && crewY > centerY) {
				trace("botL");
				//BOTL
				_moveX = _speedModifierNegative;
				_moveY = _speedModifierNegative;
			} else if (crewX > centerX && crewY < centerY) {
				trace("topR");
				//TOPR
				_moveX = _speedModifierNegative;
				_moveY = _speedModifierPositive;
			} else if (crewX > centerX && crewY > centerY) {
				trace("botR");
				//BOTR
				_moveX = _speedModifierNegative;
				_moveY = _speedModifierNegative;
			} else {
				trace("in else block");
				trace("crewX = " + crewX + ", crewY=" + crewY + ", centerX=" + centerX + ",centerY=" + centerY + " | _moveX = " + _moveX + ", _moveY = " + _moveY);
				
				if ((crewX) < centerX) {
					trace("LEFT");
					_moveX = _speedModifierPositive;
				} else if ((crewX) > centerX) {
					trace("RIGHT");
					_moveX = _speedModifierNegative;
				} else if ((crewY) < centerY) {
					trace("TOP");
					_moveY = _speedModifierPositive;
				} else if ((crewY) > centerY) {
					trace("BOT");
					_moveY = _speedModifierNegative;
				} else {
					trace("3:=====================");
					trace("crewX = " + crewX + ", crewY=" + crewY + ", centerX=" + centerX + ",centerY=" + centerY + " | _moveX = " + _moveX + ", _moveY = " + _moveY);
				}
			}
			
			/*
			if (_moveX == speedModifierNegative) {
				_moveX = speedModifierPositive;
			} else if (_moveX == speedModifierPositive) {
				_moveX = speedModifierNegative;
			}
					
			if (_moveY == speedModifierNegative) {
				_moveY = speedModifierPositive;
			} else if (_moveY == speedModifierPositive) {
				_moveY = speedModifierNegative;
			}
			*/
		}
		
		public function doStuff():void {
			var njaa:IDirection = new TOPL();
			trace(njaa.x);
			
			if (njaa is TOPL) {
				trace("yes sur");
				
			}
			
			
			if (_pathHasChanged) {
				trace("pathHasChanged");
				//do stuff here
				if (isInCenter()) {
					trace("doStuff: is in center of " + node.ID);
					_moveX = 0;
					_moveY = 0;
					_pathIndex = 0;
				} else {
					if (_path == null) { 
						trace("4:_path == null in dostuff");
						return; 
					}
					
					//do we have a next destination or is it a reset?
					//if ((_path.length == 1) && (isCrewMemberInBoundariesOfNode(_path[0]))) {
					if ((_path.length == 1)) {
						trace("_path.length = 1; reverseModifiers");
						//reset
						//simply move "counterclockwise"
						
						reverseModifiers();
						//inverseModifiers();
					} else {
						var currentNode:Node = node;
						var nextNode:Node = getNextNode();
						
						if (_moveX == _speedModifierNegative && _moveY == _speedModifierNegative) {
							trace("we are moving topL");
							//we are moving to TOPL
							//is our next destination also TOPL?
							
							if (nextNode == currentNode.TOPLnode) {
								trace("continuing ");
								//do nothing
							} else {
								//we must walk back
								reverseModifiers();
								//_moveX = speedModifierPositive;
								//_moveY = speedModifierPositive;
								//trace("changed to botL");
							}
						} else if (_moveX == 0 && _moveY == _speedModifierNegative) {
							//we are moving TOPC
							trace("we are moving topC");
							if (nextNode == currentNode.TOPCnode) {
								trace("continuing ");
								//do nothing
							} else {
								//we must walk back
								reverseModifiers();
								//_moveY = speedModifierPositive;
							}
						} else if (_moveX == _speedModifierPositive && _moveY == _speedModifierNegative) {
							//we are moving TOPR
							trace("we are moving topR");
							if (nextNode == currentNode.TOPRnode) {
								trace("continuing ");
								//do nothing
							} else {
								//we must walk back
								reverseModifiers();
								//_moveX = speedModifierNegative;
								//_moveY = speedModifierPositive;
							}
						} else if (_moveX == _speedModifierNegative && _moveY == 0) {
							trace("we are moving midL");
							//trace("We are in node : " + node.ID);
							//trace("Our next node is : " + nextNode.ID);
							//trace("We are NOT in the boundaries of path[0] : " + path[0].ID);
							
							//we are moving MIDL
							if (nextNode == currentNode.MIDLnode) {
								//do nothing
								trace("continuing ");
							} else {
								//we must walk back
								reverseModifiers();
								//_moveX = speedModifierPositive;
							}						
						} else if (_moveX == _speedModifierPositive && _moveY == 0) {
							trace("we are moving midR");
							//trace("We are in node : " + node.ID)
							//trace("Our next node is : " + nextNode.ID)
							//trace("We are NOT in the boundaries of path[0] : " + path[0].ID);

							//we are moving MIDR
							
							if (nextNode == currentNode.MIDRnode) {
								//do nothing
								trace("continuing ");
							} else {
								//we must walk back
								//trace("The next node position NOT right. Moving left");
								reverseModifiers();
								//_moveX = speedModifierNegative;
							}
						} else if (_moveX == _speedModifierNegative && _moveY == _speedModifierPositive) {
							trace("we are moving botL");
							//we are moving BOTL
							
							if (nextNode == currentNode.BOTLnode) {
								//do nothing
								trace("continuing ");
							} else {
								//we must walk back
								reverseModifiers();
								//_moveX = speedModifierPositive;
								//_moveY = speedModifierNegative;
							}
						} else if (_moveX == 0 && _moveY == _speedModifierPositive) {
							trace("we are moving botC");
							//we are moving BOTC
							
							if (nextNode == currentNode.BOTCnode) {
								//do nothing
								trace("continuing ");
							} else {
								//we must walk back
								reverseModifiers();
								//_moveY = speedModifierNegative;
							}
						} else if (_moveX == _speedModifierPositive && _moveY == _speedModifierPositive) {
							trace("we are moving botR");
							//we are moving BOTR
						
							if (nextNode == currentNode.BOTRnode) {
								//do nothing
								trace("continuing ");
							} else {
								//we must walk back
								reverseModifiers();
								//_moveX = speedModifierNegative;
								//_moveY = speedModifierNegative;
							}
						}
					}
				}
				
				_pathHasChanged = false;
			} 	
			
			walkLoop();
		}
		
		public function getNextNode():Node {
			if ((_pathIndex + 1) < _path.length) {
				return _path[_pathIndex + 1];
			} else {
				return null;
			}
		}
		
		
		
		
		
		public function walkLoop():void {
			if (_path == null) { 
				return; 
			}
			if (_pathIndex >= _path.length) { 
				trace("_pathIndex (" + _pathIndex + ") >= _path.length (" + _path.length + ")");
				return; 
			}
			if (isCrewMemberInCenterOfNode(_path[_path.length - 1], false)) {
				trace("finished!!! in node: " + node.ID);
				//this is the last node of the current path. We are finished
				clearPath();
				return;
			}
			
			var currentNode:Node = node;
			var nextNode:Node = getNextNode();
			
			
			if (isCrewMemberInCenterOfNode(node, false)) {
				trace("walkLoop: we are centered in node : " + node.ID);
				_moveX = 0;
				_moveY = 0;
			}
			
			//Are _moveX or _moveY set?
			if (_moveX == 0 && _moveY == 0) {
				trace("calculating");
				//we need to calculate
				
				if (nextNode == currentNode.TOPLnode) {
					trace("moving TOPL from " + currentNode.ID + " to " + currentNode.TOPLnode.ID);
					_moveY = _speedModifierNegative;
					_moveX = _speedModifierNegative;
				} else if (nextNode == currentNode.TOPCnode) {
					trace("moving TOPC from " + currentNode.ID + " to " + currentNode.TOPCnode.ID);
					_moveY = _speedModifierNegative;
					_moveX = 0;
				} else if (nextNode == currentNode.TOPRnode) {
					trace("moving TOPR from " + currentNode.ID + " to " + currentNode.TOPRnode.ID);
					_moveY = _speedModifierNegative;
					_moveX = _speedModifierPositive;
				} else if (nextNode == currentNode.MIDLnode) {
					trace("moving MIDL from " + currentNode.ID + " to " + currentNode.MIDLnode.ID);
					_moveY = 0;
					_moveX = _speedModifierNegative;
				} else if (nextNode == currentNode.MIDRnode) {
					trace("moving MIDR from " + currentNode.ID + " to " + currentNode.MIDRnode.ID);
					_moveY = 0;
					_moveX = _speedModifierPositive;
				} else if (nextNode == currentNode.BOTLnode) {
					trace("moving BOTL from " + currentNode.ID + " to " + currentNode.BOTLnode.ID);
					_moveY = _speedModifierPositive;
					_moveX = _speedModifierNegative;
				} else if (nextNode == currentNode.BOTCnode) {
					trace("moving BOTC from " + currentNode.ID + " to " + currentNode.BOTCnode.ID);
					_moveY = _speedModifierPositive;
					_moveX = 0;
				} else if (nextNode == currentNode.BOTRnode) {
					trace("moving BOTR from " + currentNode.ID + " to " + currentNode.BOTRnode.ID);
					_moveY = _speedModifierPositive;
					_moveX = _speedModifierPositive;
				} else if (nextNode == currentNode) {
					_moveX = 0;
					_moveY = 0;
					
					if (_crewLayout.x < (currentNode.layout.x + DEFAULTS.CrewOffset)) {
						_moveX += 1;
					} else if (_crewLayout.x > (currentNode.layout.x + DEFAULTS.CrewOffset)) {
						_moveY -= 1;
					}
					if (_crewLayout.y < (currentNode.layout.y + DEFAULTS.CrewOffset)) {
						_moveY += 1;
					} else if (_crewLayout.y > (currentNode.layout.y + DEFAULTS.CrewOffset)) {
						_moveY -= 1;
					}
				} else {
					trace("WRAAAA");
				}
			}
				
			if (nextNode != null) {
				if (isCrewMemberInBoundariesOfNode(nextNode)) {
					//trace("crewMember is in boundaries of next node. Changing node");
					//trace("currentNode = " + node.ID + ", next node = " + nextNode.ID);
					//traceOutput(null);
					
					node = nextNode;
					_pathIndex += 1;
				}
			}
			
			this.crewLayout.x += _moveX;
			this.crewLayout.y += _moveY;
		}
		
		public function traceOutput(node:Node) {
			var output:String = "===============================\n";
			output += "tracing all elements in path array\n\n";
			
			trace("");
			trace("crew.X = " + _crewLayout.x);
			trace("crew.Y = " + _crewLayout.y);
			trace("");
			trace("_moveX = " + _moveX);
			trace("_moveY = " + _moveY);
			trace("currentPathIndex = " + _pathIndex);
			
			if (getNextNode == null) {
				trace("nextPathIndex = null");
			}
			
			for (var i:int = 0; i < _path.length; i++) {
				trace ("_path[" + i + "].ID = " + _path[i].ID);
				trace("node.X = " + _path[i].layout.x);
				trace("node.Y = " + _path[i].layout.y);
				trace("node.centerX = " + (_path[i].layout.x + DEFAULTS.CrewOffset));
				trace("node.centerY = " + (_path[i].layout.y + DEFAULTS.CrewOffset));
			}
			
			trace("");
		}
		
		
		
		
		public function walkLoopOLD():void {
			if (_path == null) { return; };
			if (_pathIndex >= _path.length) { return; };
			
			
			var nextNode:Node;
			
			if ((_pathIndex + 1) >= path.length) {
				nextNode = path[_pathIndex];
			} else {
				nextNode = path[_pathIndex + 1];
			}
			
			//trace("crewLayout = " + crewLayout.x + "," + crewLayout.y + " nextNode = " + (nextNode.layout.x + modifierX) + "," + (nextNode.layout.y + modifierY));
			
			//trace("currentNode = " + node.ID + ".");
			//trace("nextNode = " + nextNode.ID + ".");
			trace("member is in boundaries of nextNode: " + isCrewMemberInBoundariesOfNode(nextNode), false);
			//trace("");
			
			if (isCrewMemberInCenterOfNode(nextNode, false)) {
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
			
			if (_path.length == 1) {
				nextNode = node;
			} else {
				nextNode = path[_pathIndex + 1];
			}
			
			
			//Are _moveX or _moveY set?
			if (_moveX == 0 && _moveY == 0) {
				trace("calculating");
				//we need to calculate
				
				if (nextNode == currentNode.TOPLnode) {
					_moveY = _speedModifierNegative;
					_moveX = _speedModifierNegative;
				} else if (nextNode == currentNode.TOPCnode) {
					_moveY = _speedModifierNegative;
					_moveX = 0;
				} else if (nextNode == currentNode.TOPRnode) {
					_moveY = _speedModifierNegative;
					_moveX = _speedModifierPositive;
				} else if (nextNode == currentNode.MIDLnode) {
					_moveY = 0;
					_moveX = _speedModifierNegative;
				} else if (nextNode == currentNode.MIDRnode) {
					_moveY = 0;
					_moveX = _speedModifierPositive;
				} else if (nextNode == currentNode.BOTLnode) {
					_moveY = _speedModifierPositive;
					_moveX = _speedModifierNegative;
				} else if (nextNode == currentNode.BOTCnode) {
					_moveY = _speedModifierPositive;
					_moveX = 0;
				} else if (nextNode == currentNode.BOTRnode) {
					_moveY = _speedModifierPositive;
					_moveX = _speedModifierPositive;
				} else if (nextNode == currentNode) {
					_moveX = 0;
					_moveY = 0;
					
					if (_crewLayout.x < (currentNode.layout.x + DEFAULTS.CrewOffset)) {
						_moveX += 1;
					} else if (_crewLayout.x > (currentNode.layout.x + DEFAULTS.CrewOffset)) {
						_moveY -= 1;
					}
					if (_crewLayout.y < (currentNode.layout.y + DEFAULTS.CrewOffset)) {
						_moveY += 1;
					} else if (_crewLayout.y > (currentNode.layout.y + DEFAULTS.CrewOffset)) {
						_moveY -= 1;
					}
				} else {
					trace("WRAAAA");
				}
			}
				
			this.crewLayout.x += _moveX;
			this.crewLayout.y += _moveY;
			
			trace("crewLayout = " + _crewLayout.x + "," + _crewLayout.y);
			
			//trace("node.x = " + this.node.layout.x + " me.x = " + this._crewLayout.x);
			//trace("node.y = " + this.node.layout.y + " me.y = " + this._crewLayout.y);
			//trace("");			
		}
		
		public function clearPath() {
			_path = null;
			_pathIndex = 0;
		}
		
		public function set path(value:Vector.<Node>) {
			if (path == null) {
				trace("path == null in setter");
				//resetting
				_pathOld = null;
				_pathIndex = 0;
				_pathIndexOld = 0;
				_pathHasChanged = false;
			} else {
				_pathIndex = 0;
				_pathHasChanged = true;
			}
			
			_path = value;
		}
		
		public function set nodes(value:Vector.<Node>) {
			_nodes = value;
		}
		
		public function get path():Vector.<Node> {
			return _path;
		}
		
		public function ICrew() {
			var speedX:Number = 2;
			var speedY:Number = 2;
			
			Directions.TOPLPOS.x = 0 - speedX;
			Directions.TOPLPOS.y = 0 - speedY;
			Directions.TOPCPOS.x = 0;
			Directions.TOPCPOS.y = 0 - speedY;
			Directions.TOPRPOS.x = speedX;
			Directions.TOPRPOS.y = 0 - speedY;
			Directions.MIDLPOS.x = 0 - speedX;
			Directions.MIDLPOS.y = 0;
			Directions.MIDCPOS.x = 0;
			Directions.MIDCPOS.y = 0;
			Directions.MIDRPOS.x = speedX;
			Directions.MIDRPOS.y = 0;
			Directions.BOTLPOS.x = 0 - speedX;
			Directions.BOTLPOS.y = speedY;
			Directions.BOTCPOS.x = 0;
			Directions.BOTCPOS.y = speedY;
			Directions.BOTRPOS.x = speedX;
			Directions.BOTRPOS.y = speedY;
			
			/*
			Directions.TOPLPOS.x = (Directions.TOPLPOS.x * .75);
			Directions.TOPLPOS.y = (Directions.TOPLPOS.y * .75);
			Directions.TOPRPOS.x = (Directions.TOPRPOS.x * .75);
			Directions.TOPRPOS.y = (Directions.TOPRPOS.y * .75);
			Directions.BOTLPOS.x = (Directions.BOTLPOS.x * .75);
			Directions.BOTLPOS.y = (Directions.BOTLPOS.y * .75);
			Directions.BOTRPOS.x = (Directions.BOTRPOS.x * .75);
			Directions.BOTRPOS.y = (Directions.BOTRPOS.y * .75);
			*/
			
			_moveDirection = Directions.MIDCPOS;
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
			_crewPortrait.x = 22;
			_crewPortrait.y = 22;
		}
	}
}