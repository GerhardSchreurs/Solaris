package Crew {
	import State.DEFAULTS;
	import Direction.*;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import Journey.Journey;
	//import flash.events.AVDictionaryDataEvent;
	import flash.filters.*;
	import Ship.Door;
	import Ship.Node;
	import State.*;
	
	public class Crew extends Agent implements IDisposable {
		public var isSelected:Boolean;
		
		private var _journey:Vector.<Journey>;
		private var _journeyIndex:int;

		private var _ID:Number;
		private var _crewName:String;
		private var _crewLayout:MovieClip;
		private var _crewPortrait:MovieClip;
		private var _glowFilter:GlowFilter;
		private var _node:Node;
		private var _speed:Number;
		private var _speedDiagonal:Number;
		private var _pathHasChanged:Boolean;
		private var _map:Vector.<Node>;
		private var _path:Vector.<Node>;
		private var _pathIndex:int;
		private var _printDebug:Boolean = false;
		private var _lastDoorNode:Node;
		public var _directions:Directions;
		
		private var nodeSize:int = DEFAULTS.NodeSize;
		private var nodeSizeHalf:int = DEFAULTS.NodeSize / 2;
		
		private var _isDisposed:Boolean;
		
		public function Crew() {
			stateMachine.initState = new Idle(this);
			_glowFilter = new GlowFilter();
			_journey = new Vector.<Journey>();
		}
		
		public function enterFrame(tick:int):void {
			if (_journey.length != 0) {
				var journey:Journey = _journey[_journeyIndex];
				
				if (journey.isBoundary) {
					node = journey.node;
				}
				
				if (journey.isCenter) {
					crewLayout.rotation = journey.direction.r;
				}
				
				if (journey.isEndPoint) {
					crewLayout.rotation = 180;
					stateMachine.changeState(new Idle(this));
				}
				
				crewLayout.x = journey.x;
				crewLayout.y = journey.y;
				
				if (_journeyIndex == _journey.length - 1) {
					_journey.length = 0;
					_journeyIndex = 0;
				} else {
					_journeyIndex += 1;
				}
			}
		}
		
		//{ Debug 
		private function addLeadingZero(val:Number, places:int):String {
			var result:String = val.toString();
			for(var i:int = result.length; i < places; i++) {
				result = '0' + result;
			}
			return result;
		}
		
		public function printData(name:String, node:Node, addition:String = ""):void {
			var data:String = name + 
			" CrewID=" + addLeadingZero(ID, 2) + 
			" [xy=" + _crewLayout.x + "," + _crewLayout.y + "]" +
			" NodeID=" + addLeadingZero(node.ID, 2) +
			" [X=" + node.xPos + "|" + node.xCenterPosition + "|" + node.xPosStop + "]" + 
			" [Y=" + node.yPos + "|" + node.yCenterPosition + "|" + node.yPosStop + "]" + 
			//" [X=" + node.xPos + " - " + node.outsideBoundL + " || " + node.centerBoundL + " - " + node.xCenterPosition + " - " + node.centerBoundR + " || " + node.outsideBoundR + " - " + node.xPosStop + "]" + 
			//" [Y=" + node.yPos + " - " + node.outsideBoundT + " || " + node.centerBoundT + " - " + node.yCenterPosition + " - " + node.centerBoundB + " || " + node.outsideBoundB + " - " + node.yPosStop + "]" + 
			" " + addition;
			
			trace(data);
			//CrewID=03 [xy=50,100] NodeID=03 [xy=100,200] X=100,130-133,150 Y=200,220-202,240 
		}
		//}

		//{ Assessors
		public function set speed(value:Number):void {
			_speed = value;
			_speedDiagonal = _speed * .50;
			
			_directions = DirectionsFactory.create(_speed);
		}
		
		public function get speed():Number {
			return _speed;
		}
		
		public function set map(value:Vector.<Node>):void {
			_map = value;
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
			_crewLayout = value;
			_crewLayout.rotation = 180;
		}
		
		public function get crewPortrait():MovieClip {
			return _crewPortrait;
		}
		
		public function set Path(value:Vector.<Node>):void {
			if (value == null) {
				trace("3:Path() setter is null");
				return;
			}
			
			trace("Path init");
			_path = value;
			_pathIndex = 0;
			
			constructPath();
			
			/*
			if (value == null) {
				trace("3:movePath() value == null!!");
				return;
			}
			
			_movePath = value;
			_movePathIndex = 0;
			_movePathChanged = true;
			
			if (_lastDoorNode != null) {
				_lastDoorNode.resetDoors();
			}
			
			
			calculateDirections();
			*/
		}
		
		public function set crewPortrait(value:MovieClip):void {
			this._crewPortrait = value;
			
			
			_crewPortrait.width = 40;
			_crewPortrait.height = 40;
			_crewPortrait.x = 22;
			_crewPortrait.y = 22;
			_crewPortrait.rotation = 180;

		}
		//}
		
		//{ Selection
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
		//}
		
		//{ Doors 
		
		//{ Pathing Functions
		private function getNodeByIndex(nodeIndex:int):Node {
			if ((nodeIndex < _path.length) && (nodeIndex >= 0)) {
				return _path[nodeIndex];
			} else {
				return null;
			}
		}
		
		private function getDirectionsFromAdjecentNode(fromNode:Node, toNode:Node):IDirection {
			if (fromNode.TOPLnode == toNode) {
				return _directions.TOPLPOS;
			} else if (fromNode.TOPCnode == toNode) {
				return _directions.TOPCPOS;
			} else if (fromNode.TOPRnode == toNode) {
				return _directions.TOPRPOS;
			} else if (fromNode.MIDLnode == toNode) {
				return _directions.MIDLPOS;
			} else if (fromNode.MIDRnode == toNode) {
				return _directions.MIDRPOS;
			} else if (fromNode.BOTLnode == toNode) {
				return _directions.BOTLPOS;
			} else if (fromNode.BOTCnode == toNode) {
				return _directions.BOTCPOS;
			} else if (fromNode.BOTRnode == toNode) {
				return _directions.BOTRPOS;
			} else {
				trace("3:getDirectionsFromAdjecentNode() Error, no adjecent nodes?");
				return null;
			}
		}
		
		public function placeCrewInCenter(node:Node):void {
			crewLayout.x = node.xPos + DEFAULTS.CrewOffset;
			crewLayout.y = node.yPos + DEFAULTS.CrewOffset;
		}
		//}
		
		//{ Pathing Implementation
		private function constructPath():void {
			trace("constructPath()");
			constructStartPath(node);
			
			for (var i:int = _pathIndex; i < _path.length; i++) {
				constuctNodePath(i);
			}
			_pathIndex = 0;
		}

		private function constructStartPath(node:Node):void {
			trace("constructStartPath()");
			if (_journey.length != 0) {
				if ((crewLayout.x != node.xCenterPosition) || (crewLayout.y != node.yCenterPosition)) {
					trace("constructStartPath() active");
					//So, we are not positioned in the center of the startnode.
					
					//what is the position relative to the center?
					var crewX:Number = crewLayout.x;
					var crewY:Number = crewLayout.y;
					var centerX:Number = node.xCenterPosition;
					var centerY:Number = node.yCenterPosition;
					var direction:IDirection;
					var isWalkingInRightDirection:Boolean;
					
					//are we walking in the direction of the nextnode?
					if (_path.length >= 2) {
						var nextNode:Node = _path[1];
						direction = _journey[_journeyIndex].direction;
						trace("direction = " + direction);
			
						if (nextNode == node.TOPLnode && direction == _directions.TOPLPOS) {
							isWalkingInRightDirection = true;
						} else if (nextNode == node.TOPCnode && direction == _directions.TOPCPOS) {
							isWalkingInRightDirection = true;
						} else if (nextNode == node.TOPRnode && direction == _directions.TOPRPOS) {
							isWalkingInRightDirection = true;
						} else if (nextNode == node.MIDLnode && direction == _directions.MIDLPOS) {
							isWalkingInRightDirection = true;
						} else if (nextNode == node.MIDRnode && direction == _directions.MIDRPOS) {
							isWalkingInRightDirection = true;
						} else if (nextNode == node.BOTLnode && direction == _directions.BOTLPOS) {
							isWalkingInRightDirection = true;
						} else if (nextNode == node.BOTCnode && direction == _directions.BOTCPOS) {
							isWalkingInRightDirection = true;
						} else if (nextNode == node.BOTRnode && direction == _directions.BOTRPOS) {
							isWalkingInRightDirection = true;
						}
					}
					
					trace("4:Walking in right direction? " + isWalkingInRightDirection);
					
					//reset vector
					_journey.length = 0;
					_journeyIndex = 0;
					
					if (isWalkingInRightDirection == false) {
						if (crewX < centerX && crewY < centerY) {
							printData("constructPathToCenter() member is TOPL positioned from center", node);
							direction = _directions.BOTRPOS;
						} else if (crewX == centerX && crewY < centerY) {
							printData("constructPathToCenter() member is TOPC positioned from center", node);
							direction = _directions.BOTCPOS;
						} else if (crewX > centerX && crewY < centerY) {
							printData("constructPathToCenter() member is TOPR positioned from center", node);
							direction = _directions.BOTLPOS;
						} else if (crewX < centerX && crewY == centerY) {
							printData("constructPathToCenter() member is MIDL positioned from center", node);
							direction = _directions.MIDRPOS;
						} else if (crewX > centerX && crewY == centerY) {
							printData("constructPathToCenter() member is MIDR positioned from center", node);
							direction = _directions.MIDLPOS;
						} else if (crewX < centerX && crewY > centerY) {
							printData("constructPathToCenter() member is BOTL positioned from center", node);
							direction = _directions.TOPRPOS;
						} else if (crewX == centerX && crewY > centerY) {
							printData("constructPathToCenter() member is BOTC positioned from center", node);
							direction = _directions.TOPCPOS;
						} else if (crewX > centerX && crewY > centerY) {
							printData("constructPathToCenter() member is BOTR positioned from center", node);
							direction = _directions.TOPLPOS;
						} else {
							printData("3:constructPathToCenter() huh?!", node);
							placeCrewInCenter(node);
							return;
						}						
					}
					
					var targetNode:Node = node;
					
					if (isWalkingInRightDirection) {
						targetNode = _path[1];
						
						centerX = targetNode.xCenterPosition;
						centerY = targetNode.yCenterPosition;
					}

					var numSteps:Number;
					var distanceFromCenter:Number;
					var intSteps:int;
					var journey:Journey;
					var numStepsDone:Number;
					var xPos:Number  = crewLayout.x;
					var yPos:Number = crewLayout.y;
					
					//how far are we located from the center?
					if (direction.isDiagonal) {
						//both x and y are set
						distanceFromCenter = Math.abs(targetNode.xCenterPosition - crewLayout.x);
					} else {
						if (direction.xFixed) {
							distanceFromCenter = Math.abs(targetNode.yCenterPosition - crewLayout.y);
						} else {
							distanceFromCenter = Math.abs(targetNode.xCenterPosition - crewLayout.x);
						}
					}
					
					numSteps = distanceFromCenter / _speed
					var intStepBoundary:int  = (numSteps / 2);
					
					//how many steps do we need to take to get from here to the center?
					//numSteps = nodeSize / _speed;
					
					if (direction.isDiagonal) {
						numSteps *= 1.4;
					}

					intSteps = numSteps;
					
					for (var i:int = 0; i < intSteps; i++) {
						journey = new Journey();
						journey.direction = direction;
						
						xPos += direction.x;
						yPos += direction.y;
						
						if (i == 0) {
							journey.node = node;
							journey.isStartPoint = true;
							journey.isCenter = true;
						} else if ((isWalkingInRightDirection) && (i == intStepBoundary)) {
							journey.node = targetNode;
							journey.isBoundary = true;
							trace("3: boundary fired");
						} else if (i == intSteps - 1) {
							journey.node = targetNode;
							xPos = targetNode.xCenterPosition;
							yPos = targetNode.yCenterPosition;
							
							if (_path.length <= 2) {
								journey.isEndPoint = true;
							}
						}
						
						journey.x = xPos;
						journey.y = yPos;
						
						_journey.push(journey);
					}
					
					if (isWalkingInRightDirection) {
						_pathIndex += 1;
						trace("path has shifted");
					}
				} else {
					trace("WRARAWRWAWRARWAARWWARWARAWRWAR");
					_journey.length = 0;
					_journeyIndex = 0;
				}
			}
		}
		
		private function constuctNodePath(nodeIndex:int):void {
			//DISABLED
			//trace("constructNodePath()");
			if (nodeIndex == _path.length - 1) { 
				return;
			}
			
			var nodeCurrent:Node = _path[nodeIndex];
			
			//DISABLED
			//trace("constructNodePath(" + nodeIndex + ") " + nodeCurrent.ID);
			
			if (nodeCurrent == null) {
				//DISABLED
				//trace("3:constructNodePath() nodeCurrent = null");
				return;
			}
			
			var nodeNext:Node = getNodeByIndex(nodeIndex + 1);
			var nodeLast:Node = getNodeByIndex(nodeIndex - 1);
			var xPos:Number  = nodeCurrent.xCenterPosition;
			var yPos:Number = nodeCurrent.yCenterPosition;
			
			var direction:IDirection = getDirectionsFromAdjecentNode(nodeCurrent, nodeNext);
			
			var journey:Journey;
			var numSteps:Number;
			var intSteps:int;
			var intStepBoundary:int;
			
			//how many steps do we need to take to get from here to the next node?
			numSteps = nodeSize / _speed;
			
			if (direction.isDiagonal) {
				numSteps *= 1.4;
			}
			
			intSteps = numSteps;
			
			var stepDifference:Number = (numSteps - intSteps) / intSteps;
			
			//what is the boundary position?
			intStepBoundary = (numSteps / 2);
			
			//construct first part
			
			
			for (var i:int = 0; i < intSteps; i++) {
				journey = new Journey();
				
				xPos += direction.x;
				yPos += direction.y;

				journey.direction = direction;
				
				if (i == 0) {
					journey.node = nodeCurrent;
					journey.isStartPoint = true;
					journey.isCenter = true;
				} else if (i == intStepBoundary) {
					journey.node = nodeNext;
					journey.isBoundary = true;
				} else if (i == intSteps - 1) {
					if (nodeIndex == _path.length - 2) {
						journey.isEndPoint = true;
					}
					xPos = nodeNext.xCenterPosition;
					yPos = nodeNext.yCenterPosition;
				}
				
				journey.x = xPos;
				journey.y = yPos;
				
				_journey.push(journey);
				
			}
		}
		
		public function resetPathData():void {
			/*
			moveDirection = directions.BOTCPOS;
			closeLastDoor();
			closeFinishDoor();
			_lastDoorNode = null;
			_movePath = null;
			_movePathIndex = 0;
			*/
		}
		
		public function get isDisposed():Boolean {
			return _isDisposed;
		}
		
		public function dispose():void {
			//trace("ICrew.dispose(" + _isDisposed + ")");
			if (_isDisposed) { return; }
			
			var count:int;
			
			count = _journey.length - 1;
			
			for (var i:int = count; i >= 0; i--) {
				_journey[i].dispose();
			}
			
			_journey = null;
			_crewLayout = null;
			_crewPortrait = null;
			_glowFilter = null;
			_map = null;
			_path = null;
			_lastDoorNode = null;
			
			_directions.dispose();
			_directions = null;
		
			_isDisposed = true;
		}
		//}
	}
}