package Ship {
	import Crew.Gerhard;
	import Crew.ICrew;
	import Crew.Sergay;
	import Crew.Wolfgang;
	import Ship.IShip;
	
	public class Kestrel extends IShip {
		public function Kestrel() {
			shipName = "The Kestrel";
			shipLayout = new LIB_Kestrel();
			mapOffsetX = 30;
			mapOffsetY = 66;
			
			constructNodes();
			constructCrew();
			initNodes();
		}
		
		override protected function constructCrew():void {
			addCrew(new Gerhard(), 3);
			addCrew(new Wolfgang(), 15);
			addCrew(new Sergay(), 22);
		}
		
		override protected function constructNodes():void {
			super.constructNodes();
			
			//0=none
			//1=thin
			//2=normal
			//3=thick
			
			var node:Node;
			
			node = generateNode(6, 0);
			node.setBorders(2, 3, 1, 3);
			node.setDoors(false, true, false, false);
			addNode(node);
			
			node = generateNode(7, 0);
			node.setBorders(1, 3, 2, 3);
			node.setDoors(false, true, false, true);
			addNode(node);
			
			node = generateNode(1, 1);
			node.setBorders(2, 2, 1, 3);
			node.setDoors(false, true, false, false);
			addNode(node);
			
			node = generateNode(2, 1);
			node.setBorders(1,2,3,3);
			node.setDoors(false, false, true, true);
			addNode(node);

			node = generateNode(3, 1);
			node.setBorders(3,2,1,2);
			node.setDoors(true, false, false, false);
			addNode(node);

			node = generateNode(4, 1);
			node.setBorders(1,2,2,3);
			node.setDoors(false, false, false, true);
			addNode(node);
			
			node = generateNode(6, 1);
			node.setBorders(2,3,1,1);
			node.setDoors(false, false, false, false);
			addNode(node);

			node = generateNode(7, 1);
			node.setBorders(1,3,3,1);
			node.setDoors(false, true, true, false);
			addNode(node);

			node = generateNode(8, 1);
			node.setBorders(3,2,1,1);
			node.setDoors(true, false, false, false);
			addNode(node);

			node = generateNode(9, 1);
			node.setBorders(1,2,2,1);
			node.setDoors(false, false, false, false);
			addNode(node);

			node = generateNode(0, 2);
			node.setBorders(3,2,3,1);
			node.setDoors(true, false, true, false);
			addNode(node);

			node = generateNode(1, 2);
			node.setBorders(3,3,1,1);
			node.setDoors(true, false, false, false);
			addNode(node);

			node = generateNode(2, 2);
			node.setBorders(1,3,2,1);
			node.setDoors(false, true, false, false);
			addNode(node);

			node = generateNode(4, 2);
			node.setBorders(2,3,1,1);
			node.setDoors(false, true, false, false);
			addNode(node);

			node = generateNode(5, 2);
			node.setBorders(1,2,3,1);
			node.setDoors(false, false, true, false);
			addNode(node);
			
			//Deze
			node = generateNode(6, 2);
			node.setBorders(3,1,1,3);
			node.setDoors(true, false, false, false);
			addNode(node);

			node = generateNode(7, 2);
			node.setBorders(1,1,3,3);
			node.setDoors(false, false, false, false);
			addNode(node);

			node = generateNode(8, 2);
			node.setBorders(3,1,1,3);
			node.setDoors(false, false, false, true);
			addNode(node);

			node = generateNode(9, 2);
			node.setBorders(1,1,3,3);
			node.setDoors(false, false, true, false);
			addNode(node);

			node = generateNode(10, 2);
			node.setBorders(3,2,1,3);
			node.setDoors(true, false, false, false);
			addNode(node);

			node = generateNode(11, 2);
			node.setBorders(1,2,3,3);
			node.setDoors(false, false, true, false);
			addNode(node);

			node = generateNode(12, 2);
			node.setBorders(3,2,1,1);
			node.setDoors(true, false, false, false);
			addNode(node);

			node = generateNode(13, 2);
			node.setBorders(1,2,3,1);
			node.setDoors(false, false, false, false);
			addNode(node);

			node = generateNode(14, 2);
			node.setBorders(3,2,2,1);
			node.setDoors(false, false, false, false);
			addNode(node);
			
			node = generateNode(0, 3);
			node.setBorders(3,1,3,2);
			node.setDoors(true, false, true, false);
			addNode(node);

			node = generateNode(1, 3);
			node.setBorders(3,1,1,3);
			node.setDoors(true, false, false, false);
			addNode(node);

			node = generateNode(2, 3);
			node.setBorders(1,1,2,3);
			node.setDoors(false, false, false, true);
			addNode(node);

			node = generateNode(4, 3);
			node.setBorders(2,1,1,3);
			node.setDoors(false, false, false, true);
			addNode(node);

			node = generateNode(5, 3);
			node.setBorders(1,1,3,2);
			node.setDoors(false, false, true, false);
			addNode(node);

			node = generateNode(6, 3);
			node.setBorders(3,3,1,1);
			node.setDoors(true, false, false, false);
			addNode(node);
			
			node = generateNode(7, 3);
			node.setBorders(1,3,3,1);
			node.setDoors(false, false, false, false);
			addNode(node);

			node = generateNode(8, 3);
			node.setBorders(3,3,1,1);
			node.setDoors(false, true, false, false);
			addNode(node);

			node = generateNode(9, 3);
			node.setBorders(1,3,3,1);
			node.setDoors(false, false, true, false);
			addNode(node);
			
			node = generateNode(10, 3);
			node.setBorders(3,3,1,2);
			node.setDoors(true, false, false, false);
			addNode(node);

			node = generateNode(11, 3);
			node.setBorders(1,3,3,2);
			node.setDoors(false, false, true, false);
			addNode(node);

			node = generateNode(12, 3);
			node.setBorders(3,1,1,2);
			node.setDoors(true, false, false, false);
			addNode(node);
			
			node = generateNode(13, 3);
			node.setBorders(1,1,3,2);
			node.setDoors(false, false, true, false);
			addNode(node);

			node = generateNode(14, 3);
			node.setBorders(3,1,2,2);
			node.setDoors(true, false, false, false);
			addNode(node);
			
			node = generateNode(1, 4);
			node.setBorders(2,3,1,2);
			node.setDoors(false, false, false, false);
			addNode(node);

			node = generateNode(2, 4);
			node.setBorders(1,3,3,2);
			node.setDoors(false, true, true, false);
			addNode(node);

			node = generateNode(3, 4);
			node.setBorders(3,2,1,2);
			node.setDoors(true, false, false, false);
			addNode(node);

			node = generateNode(4, 4);
			node.setBorders(1,3,2,2);
			node.setDoors(false, true, false, false);
			addNode(node);
			
			node = generateNode(6, 4);
			node.setBorders(2,1,1,3);
			node.setDoors(false, false, false, false);
			addNode(node);

			node = generateNode(7, 4);
			node.setBorders(1,1,3,3);
			node.setDoors(false, false, true, true);
			addNode(node);

			node = generateNode(8, 4);
			node.setBorders(3,1,1,2);
			node.setDoors(true, false, false, false);
			addNode(node);
			
			node = generateNode(9, 4);
			node.setBorders(1,1,2,2);
			node.setDoors(false, false, false, false);
			addNode(node);

			node = generateNode(6, 5);
			node.setBorders(2,3,1,3);
			node.setDoors(false, false, false, true);
			addNode(node);

			node = generateNode(7, 5);
			node.setBorders(1,3,2,3);
			node.setDoors(false, true, false, true);
			addNode(node);

		}
	}
}
