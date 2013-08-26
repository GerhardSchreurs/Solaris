package  {
	public class Ship {
		var nameOfShip:String = '';
		

		var shipClass:ShipClass;
		var crew:Vector.<Crew> = new Vector.<Crew>();
		var weapons:Vector.<Weapon> = new Vector.<Weapon>();
		var drones:Vector.<Drone> = new Vector.<Drone>();
		var augmentations:Vector.<Augmentation> = new Vector.<Augmentation>();
		var supportsystems:Vector.<SupportSystem> = new Vector.<SupportSystem>();
		
		public function Ship() {
			
		}
	}
}