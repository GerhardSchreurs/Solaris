package  {
	/**
	 * ...
	 * @author Wroah
	 */
	public class ShipProperty {
		private var _items:Vector.<ShipPropertyItem>;
		
		
		public function ShipProperty(items:Vector.<ShipPropertyItem>) {
			_items = items;
		}
		
		public function get items():Vector.<ShipPropertyItem>{
			return _items;
		}
	}
}