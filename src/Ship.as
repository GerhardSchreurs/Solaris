package  {
	import flash.utils.Dictionary;
	public class ShipOLD {
		public var nameOfShip:String = 'hihi';

		var shipClass:ShipClass;
		var crew = new Vector.<Crew>();
		var weapons = new Vector.<Weapon>();
		var drones = new Vector.<Drone>();
		var augmentations = new Vector.<Augmentation>();
		//var supportsystems:Vector.<SupportSystem> = new Vector.<SupportSystem>();
		
		var supportSystems:Dictionary = new Dictionary();
		
		
		public function ShipOLD():void {
			
			var item1:ShipPropertyItem= new ShipPropertyItem("Needs pilot", 0);
			var item2:ShipPropertyItem = new ShipPropertyItem("1/4 evasion", 15);
			var item3:ShipPropertyItem = new ShipPropertyItem("1/2 evasion", 25);
			var items:Vector.<ShipPropertyItem> = new <ShipPropertyItem>[item1, item2, item3];
			//var piloting:ShipProperty= new ShipProperty(items);
			var piloting:ShipPropertyClass = new ShipPropertyClass(items);

			
			
			var newLevel = 0;
			var success = piloting.setProperty(newLevel);	
			if (success == false) {
				trace("failed to set level to ", newLevel);
			} else {
				supportSystems[piloting] = newLevel;
			}
		}
		
		public function setProperty(prop:ShipProperty, level:int):Boolean {
			var success:Boolean = false;
			
			if (level > prop.items.length || level < 0) {
				return false;
			} else {
				supportSystems[prop] = level;
				return true;
			}
			
		}
	}
}