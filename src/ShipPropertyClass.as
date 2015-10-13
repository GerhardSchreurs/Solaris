package  {
	/**
	 * ...
	 * @author Wroah
	 */
	public class ShipPropertyClass {
		private var _shipProperty:ShipProperty;
		
		public function ShipPropertyClass(items:Vector.<ShipPropertyItem>) {
			_shipProperty = new ShipProperty(items);
		}
		
		public function setProperty(level:int):Boolean {
			var success:Boolean = false;
			
			if (level > _shipProperty.items.length || level < 0) {
				return false;
			} else {
				//supportSystems[prop] = level;
				return true;
			}
		}
	}
}