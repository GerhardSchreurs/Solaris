package RectangleSelector {
	import flash.display.MovieClip;
	import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.display.Sprite;
    import flash.events.Event;
	
	public class RectangleSelector extends Sprite {
		
		//todo, write logic to remove eventListeners
		
		public static var STAGE:Stage;
		public var selectionRect:Rectangle; // Will hold the data for our rectangle.
        public var selectionSprite:Sprite; // Making a new Sprite to draw the rectangle.
        public var isMouseHeld:Boolean; // Will tell us whether the mouse button is Up/Down
		
		public function RectangleSelector() {
			trace("I'm here");
			
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
				trace("doing this");
			}
		}
		
		private function init(e:Event = null):void {
			trace("fired");
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			STAGE=stage;
			
            isMouseHeld = false; // The mouse is not held yet.
			
			selectionSprite = new Sprite();
			
            STAGE.addChild(selectionSprite); // Adding the selectionSprite to the stage.
             
            STAGE.addEventListener(MouseEvent.MOUSE_DOWN, SetStartPoint); // Listen for mouse hold.
            STAGE.addEventListener(MouseEvent.MOUSE_UP, RemoveRectangle); // Listen for mouse release.
            STAGE.addEventListener(Event.ENTER_FRAME, UpdateGame); // Run this function every frame (24 FPS).
		}
		
		public function SetStartPoint( me:MouseEvent ):void {
            selectionRect = new Rectangle( stage.mouseX, stage.mouseY ); // Creating the selection rectangle.
            isMouseHeld = true; // The mouse is now held.
        }
         
         
        public function RemoveRectangle( me:MouseEvent ):void {
            isMouseHeld = false; // The mouse is no longer held.
        }
         
         
        public function UpdateGame( e:Event ):void {
            selectionSprite.graphics.clear(); // Clear the rectangle so it is ready to be drawn again.
             
            if( isMouseHeld ) {
                selectionRect.width = stage.mouseX - selectionRect.x; // Set the width of the rectangle.
                selectionRect.height = stage.mouseY - selectionRect.y; // Set the height of the rectangle.
                selectionSprite.graphics.lineStyle(1, 0x3B5323, 0.6); // Set the border of the rectangle.
                selectionSprite.graphics.beginFill( 0x458B00, 0.4 ); // Set the fill and transparency of the rectangle.
                selectionSprite.graphics.drawRect( selectionRect.x, selectionRect.y, selectionRect.width, selectionRect.height ); // Draw the rectangle to the stage!
                selectionSprite.graphics.endFill(); // Stop filling the rectangle.
				
				//some switch here to not throw events every frame?
				dispatchEvent(new RectangleSelectionEvent(RectangleSelectionEvent.RESULT, selectionSprite));
            }
        }
	}
}