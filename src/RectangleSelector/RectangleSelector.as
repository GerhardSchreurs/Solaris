package RectangleSelector {
	import flash.display.MovieClip;
	import flash.display.Stage;
    import flash.events.MouseEvent;
	import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.display.Sprite;
    import flash.events.Event;
	
	public class RectangleSelector extends Sprite implements IDisposable {
		
		public static var STAGE:Stage;
		public var _isDisposed:Boolean;
		public var _selectionRect:Rectangle; // Will hold the data for our rectangle.
        public var _selectionSprite:Sprite; // Making a new Sprite to draw the rectangle.
        public var _isMouseHeld:Boolean; // Will tell us whether the mouse button is Up/Down
		
		private var _captureArea:Rectangle;
		
		public function RectangleSelector(captureArea:Rectangle) {
			_captureArea = captureArea;
			
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			}
		}
		
		private function init(e:Event = null):void {
			trace("fired");
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			STAGE=stage;
			
            _isMouseHeld = false; // The mouse is not held yet.
			
			_selectionSprite = new Sprite();
			
            STAGE.addChild(_selectionSprite); // Adding the selectionSprite to the stage.
             
            STAGE.addEventListener(MouseEvent.MOUSE_DOWN, setStartPoint); // Listen for mouse hold.
            STAGE.addEventListener(MouseEvent.MOUSE_UP, removeRectangle); // Listen for mouse release.
            STAGE.addEventListener(Event.ENTER_FRAME, updateGame); // Run this function every frame (24 FPS).
		}
		
		public function setStartPoint( me:MouseEvent ):void {
			if (_captureArea.contains(stage.mouseX, stage.mouseY)) {
				_selectionRect = new Rectangle( stage.mouseX, stage.mouseY ); // Creating the selection rectangle.
				_isMouseHeld = true; // The mouse is now held.
			}
        }
         
         
        public function removeRectangle( me:MouseEvent ):void {
            _isMouseHeld = false; // The mouse is no longer held.
        }
         
         
        public function updateGame( e:Event ):void {
            _selectionSprite.graphics.clear(); // Clear the rectangle so it is ready to be drawn again.
             
            if( _isMouseHeld ) {
                _selectionRect.width = stage.mouseX - _selectionRect.x; // Set the width of the rectangle.
                _selectionRect.height = stage.mouseY - _selectionRect.y; // Set the height of the rectangle.
                _selectionSprite.graphics.lineStyle(1, 0x3B5323, 0.6); // Set the border of the rectangle.
                _selectionSprite.graphics.beginFill( 0x458B00, 0.4 ); // Set the fill and transparency of the rectangle.
                _selectionSprite.graphics.drawRect( _selectionRect.x, _selectionRect.y, _selectionRect.width, _selectionRect.height ); // Draw the rectangle to the stage!
                _selectionSprite.graphics.endFill(); // Stop filling the rectangle.
				
				//some switch here to not throw events every frame?
				dispatchEvent(new RectangleSelectionEvent(RectangleSelectionEvent.RESULT, _selectionSprite));
            }
        }
		
        public function get isDisposed():Boolean {
			return _isDisposed;
		}

		
		public function dispose():void {
			trace("RectangleSelector.dispose(" + _isDisposed + ")");
			if (_isDisposed) { return; };

            STAGE.removeEventListener(Event.ENTER_FRAME, updateGame);
            STAGE.removeEventListener(MouseEvent.MOUSE_UP, removeRectangle);
            STAGE.removeEventListener(MouseEvent.MOUSE_DOWN, setStartPoint);

			STAGE.removeChild(_selectionSprite);
			
			_selectionRect = null;
			_selectionSprite = null;
			
			_isDisposed = true;
		}
	}
}