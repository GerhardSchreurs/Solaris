package Journey {
	import Direction.IDirection;
	import Ship.Node;

	public class Journey implements IDisposable {
		private var _isDisposed:Boolean;
		public var x:Number;
		public var y:Number;
		public var direction:IDirection;
		
		public var isStartPoint:Boolean;
		public var isEndPoint:Boolean;
		public var isCenter:Boolean;
		public var isBoundary:Boolean;
		
		public var node:Node;
		
		public function get isDisposed():Boolean {
			return _isDisposed;
		}
		
		public function dispose():void {
			//trace("Journey.dispose(" + _isDisposed + ")");
			if (_isDisposed) { return; };
			
			direction = null;
			node = null;
			
			_isDisposed = true;
		}
	}
}