package Ship {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.*;
	import flash.utils.*;
	import State.DEFAULTS;
	
	public class Door extends MovieClip implements IDisposable {
		private var _isDisposed:Boolean;
		private var _doorGlowFilter:GlowFilter;
		private var _registerCount:int;
		
		public var node:Node;
		public var connectedNode:Node;
		
		public var isOpenedClosedManually:Boolean;
		public var isOpenedManually:Boolean;
		public var isClosedManually:Boolean;
		public var isOpening:Boolean;
		public var isClosing:Boolean;
		public var isOpened:Boolean;
		public var isClosed:Boolean;
		
		private var _isOuterDoor:Boolean;
		
		public function set isOuterDoor(value:Boolean):void {
			_isOuterDoor = value;
		}
		
		public function get isOuterDoor() {
			return _isOuterDoor;
		}
		
		private var _closeReference:uint;
		
		/*=================*/
		public var X:int;
		public var Y:int;
		
		/*=================*/
		
		public function Door() {
			_doorGlowFilter = new GlowFilter();
			mouseEnabled = false;
			addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
			addEventListener(MouseEvent.CLICK, handleClick);
			
			//parent.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			//parent.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
		}
		
		public function ext_closeLoop():void {
			trace("3:ext_closeLoop()");
		}
		
		
		function queryDoorStatus():void {
			if (isPlaying) {
				isOpened = false;
				isClosed = false;
				
				if (currentFrame < DEFAULTS.DoorAnimationMidFrame) {
					isOpening = true;
					isClosing = false;
				} else {
					isOpening = false;
					isClosing = true;
				}
			} else {
				isOpening = false;
				isClosing = false;
				
				if (currentFrame == DEFAULTS.DoorAnimationStartFrame) {
					isOpened = false;
					isClosed = true;
				} else if (currentFrame == DEFAULTS.DoorAnimationMidFrame) {
					isOpened = true;
					isClosed = false;
				} else {
					trace("3:problem in queryDoorstatus!!");
				}
			}
		}
		
		function handleMouseOver(e:MouseEvent):void {
			//trace("I'm mouseover");
			filters = [_doorGlowFilter];
		}
		
		function handleMouseOut(e:MouseEvent):void {
			//trace("I'm mouseout");
			filters = [];
		}
		
		function handleClick(e:MouseEvent):void {
			//filters = [];
			openclose(true);
		}
		
		
		public function registerOpen():void {
			_registerCount ++;
			
			trace("registerCount() : " + _registerCount);
		}
		
		private function registerClose():void {
			_registerCount --;
			
			if (_registerCount < 0) {
				_registerCount = 0;
			}
		}
		
		public function openclose(manually:Boolean = false):void {
			if (_registerCount > 0) {
				return;
			}
			
			queryDoorStatus();
			
			isOpenedClosedManually = manually;
			
			if (manually) {
				if (isClosed || isClosing) {
					isOpenedManually = true;
					isClosedManually = false;
					
					if (_isOuterDoor) {
						trace("3:AIRLOCK");
						node.registerAirLock();
					} else {
						node.room.addOpenRoom(connectedNode.room);
						connectedNode.room.addOpenRoom(node.room);
					}
				} else {
					if (_isOuterDoor) {
						trace("3:UNREGISTER AIRLOCK");
						node.unregisterAirLock();
					} else {
						node.room.removeOpenRoom(connectedNode.room);
						connectedNode.room.removeOpenRoom(node.room);
					}
					
					isOpenedManually = false;
					isClosedManually = true;
				}
				
				node.queryStatus();
			}
			
			
			
			if (isClosed) {
				open();
			} else if (isOpened) {
				closeIT();
			} else {
				gotoCounterFrame();
			}
		}
		
		public function gotoCounterFrame() {
			gotoAndPlay(Math.abs(currentFrame - DEFAULTS.DoorAnimationStopFrame));
		}
		
		public function open():void {
			queryDoorStatus();
			
			if (isOpened || isOpening) {
				trace("door isOpened or isOpening (do nothing)");
				//Do nothing
			} else if (isClosing) {
				//GoTo counterframe and play
				trace("door isClosing (gotoCounterFrame)");
				gotoCounterFrame();
			} else {
				//Should be opened
				trace("door should be opened");
				gotoAndPlay(1);
			}
			
			if (isOpenedManually) {
			} else {
				clearTimeout(_closeReference);
				_closeReference = setTimeout(closeIT, 850);
			}

		}
		
		public function reset():void {
			_registerCount = 0;
		}
		
		public function closeIT():void {
			queryDoorStatus();
			
			if (isClosed || isClosing) {
				//Do nothing
			} else if (isOpening) {
				//Go to counterframe and play
				
				registerClose();
			
				if (_registerCount == 0) {
					gotoCounterFrame();
				}
				
			} else {
				//Should be closed
				registerClose();
				
				if (_registerCount == 0) {
					gotoAndPlay(DEFAULTS.DoorAnimationMidFrame);
				}
			}			
		}
		
		public function close():void {
		}
		
		public function get isDisposed():Boolean {
			return _isDisposed;
		}
		
		public function dispose():void {
			//trace("Door.isDisposed(" + _isDisposed + ")");
			if (_isDisposed) { return; }
			
			stop();
			
			clearTimeout(_closeReference);
			removeEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
			removeEventListener(MouseEvent.CLICK, handleClick);

			_doorGlowFilter = null;
			node = null;
			
			_isDisposed = true;
		}
	}
}