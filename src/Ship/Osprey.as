package Ship {
	import Crew.ICrew;
	import Crew.Gerhard;
	import Crew.Sergay;
	import Crew.Wolfgang;
	import Ship.IShip;

	public class Osprey extends IShip {
		public function Osprey() {
			shipName = "The Osprey";
			shipLayout = new LIB_Osprey();

			mapOffsetX = 32;
			mapOffsetY = 66;
			
			_statHealthMax = 40;
			_statHealthNow = 40;
			_statOxygenMax = 100;
			_statOxygenNow = 100;
			_statShieldMax = 4;
			_statShieldNow = 1;

			constructNodes();
			constructCrew();
			initNodes();
		}
		
		override protected function constructNodes():void {
			super.constructNodes();
			
			//0=none
			//1=thin
			//2=normal
			//3=thick
			
			var node:Node;
			
			//TOP
			generateRoom();
			
			node = generateNode(0, 0);
			node.setBorders(3, 3, 3, 1);
			node.setDoors(true, false, false, false);
			addNode(node);
			
			node = generateNode(0, 1);
			node.setBorders(3, 1, 3, 3);
			node.setDoors(true, false, true, false);
			addNode(node);
			
			//TOPR
			generateRoom();
			
			node = generateNode(1, 1);
			node.setBorders(3, 3, 1, 3);
			node.setDoors(true, false, false, false);
			addNode(node);
			
			node = generateNode(2, 1);
			node.setBorders(1, 3, 3, 3);
			node.setDoors(false, false	, false, true);
			addNode(node);
			
			//BOT
			generateRoom();
			
			node = generateNode(0, 6);
			node.setBorders(3, 3, 3, 1);
			node.setDoors(true, false, true, false);
			addNode(node);
			
			node = generateNode(0, 7);
			node.setBorders(3, 1, 3, 3);
			node.setDoors(true, false, false, false);
			addNode(node);
			
			generateRoom();
			
			node = generateNode(2, 2);
			node.setBorders(3, 3, 1, 3);
			node.setDoors(false, true, false, true);
			addNode(node);
			
			node = generateNode(3, 2);
			node.setBorders(1, 3, 3, 3);
			node.setDoors(false, false, true, false);
			addNode(node);
			
			generateRoom();
			
			node = generateNode(1, 3);
			node.setBorders(3, 3, 1, 1);
			node.setDoors(false, false, false, false);
			addNode(node);
			
			node = generateNode(2, 3);
			node.setBorders(1, 3, 3, 1);
			node.setDoors(false, true, false, false);
			addNode(node);
			
			node = generateNode(1, 4);
			node.setBorders(3, 1, 1, 3);
			node.setDoors(false, false, false, false);
			addNode(node);
			
			node = generateNode(2, 4);
			node.setBorders(1, 1, 3, 3);
			node.setDoors(false, false, true, true);
			addNode(node);
			
			generateRoom();
			
			node = generateNode(3, 3);
			node.setBorders(3, 3, 3, 1);
			node.setDoors(false, false, false, false);
			addNode(node);
			
			node = generateNode(3, 4);
			node.setBorders(3, 1, 3, 3);
			node.setDoors(true, false, false, false);
			addNode(node);
			
			generateRoom();
			
			node = generateNode(2, 5);
			node.setBorders(3, 3, 1, 3);
			node.setDoors(false, true, false, true);
			addNode(node);
			
			node = generateNode(3, 5);
			node.setBorders(1, 3, 3, 3);
			node.setDoors(false, false, true, false);
			addNode(node);
	
			//BOTR
			generateRoom();
			
			node = generateNode(1, 6);
			node.setBorders(3, 3, 1, 3);
			node.setDoors(true, false, false, false);
			addNode(node);
			
			node = generateNode(2, 6);
			node.setBorders(1, 3, 3, 3);
			node.setDoors(false, true, false, false);
			addNode(node);
			
			generateRoom();
			
			node = generateNode(4, 2);
			node.setBorders(3, 3, 3, 1);
			node.setDoors(true, false, false, false);
			addNode(node);
			
			node = generateNode(4, 3);
			node.setBorders(3, 1, 3, 3);
			node.setDoors(false, false, true, false);
			addNode(node);
			
			generateRoom();
			
			node = generateNode(4, 4);
			node.setBorders(3, 3, 3, 1);
			node.setDoors(false, false, true, false);
			addNode(node);
			
			node = generateNode(4, 5);
			node.setBorders(3, 1, 3, 3);
			node.setDoors(true, false, false, false);
			addNode(node);
			
			generateRoom();
			
			node = generateNode(5, 3);
			node.setBorders(3, 3, 1, 1);
			node.setDoors(true, false, false, false);
			addNode(node);
			
			node = generateNode(6, 3);
			node.setBorders(1, 3, 3, 1);
			node.setDoors(false, false, false, false);
			addNode(node);
			
			node = generateNode(5, 4);
			node.setBorders(3, 1, 1, 3);
			node.setDoors(true, false, false, false);
			addNode(node);
			
			node = generateNode(6, 4);
			node.setBorders(1, 1, 3, 3);
			node.setDoors(false, false, true, false);
			addNode(node);
			
			generateRoom();
			
			node = generateNode(7, 3);
			node.setBorders(3, 3, 1, 1);
			node.setDoors(false, false, false, false);
			addNode(node);
			
			node = generateNode(8, 3);
			node.setBorders(1, 3, 3, 1);
			node.setDoors(false, false, true, false);
			addNode(node);
			
			node = generateNode(7, 4);
			node.setBorders(3, 1, 1, 3);
			node.setDoors(true, false, false, false);
			addNode(node);
			
			node = generateNode(8, 4);
			node.setBorders(1, 1, 3, 3);
			node.setDoors(false, false, false, false);
			addNode(node);
			
			generateRoom();
			
			node = generateNode(9, 3);
			node.setBorders(3, 3, 3, 1);
			node.setDoors(true, false, true, false);
			addNode(node);
			
			node = generateNode(9, 4);
			node.setBorders(3, 1, 3, 3);
			node.setDoors(false, false, true, false);
			addNode(node);
			
			generateRoom();
			
			node = generateNode(10, 3);
			node.setBorders(3, 3, 1, 3);
			node.setDoors(true, false, false, false);
			addNode(node);
			
			node = generateNode(11, 3);
			node.setBorders(1, 3, 3, 3);
			node.setDoors(false, false, true, false);
			addNode(node);
			
			generateRoom();
			
			node = generateNode(10, 4);
			node.setBorders(3, 3, 1, 3);
			node.setDoors(true, false, false, false);
			addNode(node);
			
			node = generateNode(11, 4);
			node.setBorders(1, 3, 3, 3);
			node.setDoors(false, false, true, false);
			addNode(node);
			
			generateRoom();
			
			node = generateNode(12, 2);
			node.setBorders(3, 3, 1, 1);
			node.setDoors(false, false, false, false);
			addNode(node);
			
			node = generateNode(13, 2);
			node.setBorders(1, 3, 3, 1);
			node.setDoors(false, false, false, false);
			addNode(node);
			
			node = generateNode(12, 3);
			node.setBorders(3, 1, 1, 3);
			node.setDoors(true, false, false, true);
			addNode(node);
			
			node = generateNode(13, 3);
			node.setBorders(1, 1, 3, 3);
			node.setDoors(false, false, true, false);
			addNode(node);
		}
	}
}