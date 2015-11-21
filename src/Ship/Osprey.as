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
			
			constructNodes();
			constructCrew();
			initNodes();
		}
		
		override protected function constructNodes():void {
			trace("constructNodes (Osprey)");
			
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
		}
	}
}