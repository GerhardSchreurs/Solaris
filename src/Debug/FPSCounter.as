package Debug {
	import flash.display.ColorCorrection;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.events.Event;
    import flash.utils.getTimer;
     
    public class FPSCounter extends Sprite implements IDisposable {
        private var _startTime:Number;
        private var _framesNumber:Number = 0;
        private var _fpsTextField:TextField;
		private var _isDisposed:Boolean;
     
        public function FPSCounter() {
			_fpsTextField = new TextField();
			_fpsTextField.selectable = false;
			_fpsTextField.textColor = 0xFF3322;
            _startTime = getTimer();
            addChild(_fpsTextField);
            addEventListener(Event.ENTER_FRAME, checkFPS);
        }
     
        private function checkFPS(e:Event):void {
            var currentTime:Number = (getTimer() - _startTime) / 1000;
 
            _framesNumber++;
             
            if (currentTime > 1) {
                _fpsTextField.text = "FPS: " + (Math.floor((_framesNumber/currentTime)*10.0)/10.0);
                _startTime = getTimer();
                _framesNumber = 0;
            }
        }
		
		public function get isDisposed():Boolean {
			return _isDisposed;
		}
		
		public function dispose():void {
			trace("FPSCounter.dispose(" + _isDisposed + ")");
			if (isDisposed) { return; };
			
			removeEventListener(Event.ENTER_FRAME, checkFPS);
			removeChild(_fpsTextField);
			_fpsTextField = null;
			
			_isDisposed = true;
		}
    }
}