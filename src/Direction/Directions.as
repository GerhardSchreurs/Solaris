package Direction {
	
	public class Directions implements IDisposable {
		private var _isDisposed:Boolean;
		
		public var TOPLPOS:TOPL = new TOPL();
		public var TOPCPOS:TOPC = new TOPC();
		public var TOPRPOS:TOPR = new TOPR();
		public var MIDLPOS:MIDL = new MIDL();
		public var MIDCPOS:MIDC = new MIDC();
		public var MIDRPOS:MIDR = new MIDR();
		public var BOTLPOS:BOTL = new BOTL();
		public var BOTCPOS:BOTC = new BOTC();
		public var BOTRPOS:BOTR = new BOTR();
		
		public function get isDisposed():Boolean {
			return _isDisposed;
		}
		
		public function dispose():void {
			//trace("Directions.dispose(" + _isDisposed + ")");
			if (_isDisposed) { return; };
			
			TOPLPOS = null;
			TOPCPOS = null;
			TOPRPOS = null;
			MIDLPOS = null;
			MIDCPOS = null;
			MIDRPOS = null;
			BOTLPOS = null;
			BOTCPOS = null;
			BOTRPOS = null;
			
			_isDisposed = true;
		}
	}
}