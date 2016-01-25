package State.States {
	import Crew.Crew;
	import flash.display.Sprite;
	import Ship.Node;
	import Journey.Journey;
	import Direction.*;
	import State.DEFAULTS;
	import State.Idle;
	import State.IState;
	import State.StateMachine;
	
	public class Walk implements IState {
		//I chose to handle the whole walking routine in IShip / ICrew instead for
		//performance reasons.
		
		private var _stateMachine:StateMachine;
		private var _crewMember:Crew;
		private var _crewLayout:Sprite;
		private var _path:Vector.<Node>;
		private var _pathIndex:int;
		private var _journey:Vector.<Journey>;
		private var _journeyIndex:int;
		private var _directions:Directions;
		private var _speed:Number;
		private var _node:Node;		
		private var _nodeSize:int = DEFAULTS.NodeSize;
		private var _nodeSizeHalf:int = DEFAULTS.NodeSize / 2;

		public function get path():Vector.<Node> {
			return _path;
		}
		
		public function set path(value:Vector.<Node>):void {
			_path = value;
			_pathIndex = 0;
			_journey = new Vector.<Journey>();
			
			constructPath();
		}
		
		
		public function Walk(crewMember:Crew, $path:Vector.<Node>) {
			_crewMember = crewMember;
			_crewLayout = _crewMember.crewLayout;
			_directions = _crewMember._directions;
			_speed = _crewMember.speed;
			_node = _crewMember.node;
			
			_stateMachine = crewMember.stateMachine;
			
			path = $path;
		}
		
		public function enter():void {
			
		}
		
		public function exit():void {
			
		}
		
		public function update(tick:int):void {
			if (_journey.length != 0) {
				var journey:Journey = _journey[_journeyIndex];
				
				if (journey.isBoundary) {
					trace("journey.isBoundary");
					trace("_node = " + _node.ID);
					trace("journey.node = " + journey.node.ID);
					trace("_crewMember.node = " + _crewMember.node.ID);
					
					_node = journey.node;
					
					//I don't get it. _node is a reference to _crewMember.node;
					//So I shouldn't have to update _crewMember.node, right ???
					_crewMember.node = _node;
					
					trace("================");
					trace("_node = " + _node.ID);
					trace("journey.node = " + journey.node.ID);
					trace("_crewMember.node = " + _crewMember.node.ID);
					trace("");
				}
				
				if (journey.isCenter) {
					_crewLayout.rotation = journey.direction.r;
				}
				
				if (journey.isEndPoint) {
					_crewLayout.rotation = 180;
					_stateMachine.changeState(new Idle(this._crewMember));
				}
				
				_crewLayout.x = journey.x;
				_crewLayout.y = journey.y;
				
				if (_journeyIndex == _journey.length - 1) {
					_journey.length = 0;
					_journeyIndex = 0;
				} else {
					_journeyIndex += 1;
				}
			}			
		}
		
		private function constructPath():void {
			trace("constructPath()");
			constructStartPath(_node);
			
			for (var i:int = _pathIndex; i < _path.length; i++) {
				constuctNodePath(i);
			}
			_pathIndex = 0;
		}
		
		private function constructStartPath(node:Node):void {
			trace("constructStartPath()");
			if (_journey.length != 0) {
				if ((_crewLayout.x != _node.xCenterPosition) || (_crewLayout.y != _node.yCenterPosition)) {
					trace("constructStartPath() active");
					//So, we are not positioned in the center of the startnode.
					
					//what is the position relative to the center?
					var crewX:Number = _crewLayout.x;
					var crewY:Number = _crewLayout.y;
					var centerX:Number = _node.xCenterPosition;
					var centerY:Number = _node.yCenterPosition;
					var direction:IDirection;
					var isWalkingInRightDirection:Boolean;
					
					//are we walking in the direction of the nextnode?
					if (_path.length >= 2) {
						var nextNode:Node = _path[1];
						direction = _journey[_journeyIndex].direction;
						trace("direction = " + direction);
			
						if (nextNode == _node.TOPLnode && direction == _directions.TOPLPOS) {
							isWalkingInRightDirection = true;
						} else if (nextNode == _node.TOPCnode && direction == _directions.TOPCPOS) {
							isWalkingInRightDirection = true;
						} else if (nextNode == _node.TOPRnode && direction == _directions.TOPRPOS) {
							isWalkingInRightDirection = true;
						} else if (nextNode == _node.MIDLnode && direction == _directions.MIDLPOS) {
							isWalkingInRightDirection = true;
						} else if (nextNode == _node.MIDRnode && direction == _directions.MIDRPOS) {
							isWalkingInRightDirection = true;
						} else if (nextNode == _node.BOTLnode && direction == _directions.BOTLPOS) {
							isWalkingInRightDirection = true;
						} else if (nextNode == _node.BOTCnode && direction == _directions.BOTCPOS) {
							isWalkingInRightDirection = true;
						} else if (nextNode == _node.BOTRnode && direction == _directions.BOTRPOS) {
							isWalkingInRightDirection = true;
						}
					}
					
					trace("4:Walking in right direction? " + isWalkingInRightDirection);
					
					//reset vector
					_journey.length = 0;
					_journeyIndex = 0;
					
					if (isWalkingInRightDirection == false) {
						if (crewX < centerX && crewY < centerY) {
							_crewMember.printData("constructPathToCenter() member is TOPL positioned from center", node);
							direction = _directions.BOTRPOS;
						} else if (crewX == centerX && crewY < centerY) {
							_crewMember.printData("constructPathToCenter() member is TOPC positioned from center", node);
							direction = _directions.BOTCPOS;
						} else if (crewX > centerX && crewY < centerY) {
							_crewMember.printData("constructPathToCenter() member is TOPR positioned from center", node);
							direction = _directions.BOTLPOS;
						} else if (crewX < centerX && crewY == centerY) {
							_crewMember.printData("constructPathToCenter() member is MIDL positioned from center", node);
							direction = _directions.MIDRPOS;
						} else if (crewX > centerX && crewY == centerY) {
							_crewMember.printData("constructPathToCenter() member is MIDR positioned from center", node);
							direction = _directions.MIDLPOS;
						} else if (crewX < centerX && crewY > centerY) {
							_crewMember.printData("constructPathToCenter() member is BOTL positioned from center", node);
							direction = _directions.TOPRPOS;
						} else if (crewX == centerX && crewY > centerY) {
							_crewMember.printData("constructPathToCenter() member is BOTC positioned from center", node);
							direction = _directions.TOPCPOS;
						} else if (crewX > centerX && crewY > centerY) {
							_crewMember.printData("constructPathToCenter() member is BOTR positioned from center", node);
							direction = _directions.TOPLPOS;
						} else {
							_crewMember.printData("3:constructPathToCenter() huh?!", node);
							placeCrewInCenter(node);
							return;
						}						
					}
					
					var targetNode:Node = _node;
					
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
					var xPos:Number  = _crewLayout.x;
					var yPos:Number = _crewLayout.y;
					
					//how far are we located from the center?
					if (direction.isDiagonal) {
						//both x and y are set
						distanceFromCenter = Math.abs(targetNode.xCenterPosition - _crewLayout.x);
					} else {
						if (direction.xFixed) {
							distanceFromCenter = Math.abs(targetNode.yCenterPosition - _crewLayout.y);
						} else {
							distanceFromCenter = Math.abs(targetNode.xCenterPosition - _crewLayout.x);
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
			numSteps = _nodeSize / _speed;
			
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
			_crewLayout.x = node.xPos + DEFAULTS.CrewOffset;
			_crewLayout.y = node.yPos + DEFAULTS.CrewOffset;
		}
		

	}
}