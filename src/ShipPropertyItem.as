package  {
	/**
	 * ...
	 * @author Wroah
	 */

	public class ShipPropertyItem {
		private var _price:int;
		private var _name:String;
		
		public function ShipPropertyItem(name:String, price:int):void {
			_price = price;
			_name = name;
		}
		
		public function get price():int {
			return _price;
		}
		
		public function get name():String{
			return _name;
		}			
	}
	
}