package Ship {
	import Crew.Crew;

	import Crew.Gerhard;
	
	public class Torus extends IShip {
		
		public function Torus() {
			this.shipName = "The Torus";
			this.shipLayout = new LIB_Torus();
			mapOffsetX = 45;
			mapOffsetY = 32;
			
			_statHealthMax = 30;
			_statHealthNow = 30;
			_statOxygenMax = 100;
			_statOxygenNow = 100;
			_statShieldMax = 4;
			_statShieldNow = 1;

			constructNodes();
			constructCrew();
			initShip();
		}
		
		override protected function constructCrew():void {
			var member:Crew;
			
			member = new Gerhard();
			member.map = nodes;
			addCrew(member, 0);
		}
		
		override protected function constructNodes():void {
			super.constructNodes();
			
			var node:Node;
			
			generateRoom();
			
			node = generateNode(0,0);
			node.setBorders(3, 3, 1, 1);
			node.setDoors(false, false, false, false);
			addNode(node);
			
			node = generateNode(1,0);
			node.setBorders(1, 3, 3, 1);
			node.setDoors(false, false, false, false);
			addNode(node);
			
			node = generateNode(0,1);
			node.setBorders(3, 1, 1, 3);
			node.setDoors(false, false, false, false);
			addNode(node);
					
			node = generateNode(1,1);
			node.setBorders(1, 1, 2, 2);
			node.setDoors(false, false, false, true);
			addNode(node);
			
			generateRoom();
			
			node = generateNode(1,2);
			node.setBorders(3, 2, 2, 1);
			node.setDoors(false, true, true, false);
			addNode(node);
			
			node = generateNode(1,3);
			node.setBorders(3, 1, 3, 2);
			node.setDoors(false, false, false, true);
			addNode(node);
			
			generateRoom();
			
			node = generateNode(0,4);
			node.setBorders(3, 3, 1, 1);
			node.setDoors(false, false, false, false);
			addNode(node);
			
			node = generateNode(1,4);
			node.setBorders(1, 2, 2, 1);
			node.setDoors(false, true, false, false);
			addNode(node);

			node = generateNode(0,5);
			node.setBorders(3, 1, 1, 3);
			node.setDoors(false, false, false, false);
			addNode(node);
			
			node = generateNode(1,5);
			node.setBorders(1, 1, 2, 3);
			node.setDoors(false, false, true, false);
			addNode(node);
			
			generateRoom();
			
			node = generateNode(2,1);
			node.setBorders(2, 3, 2, 1);
			node.setDoors(false, false, true, false);
			addNode(node);
			
			node = generateNode(2,2);
			node.setBorders(2, 1, 3, 3);
			node.setDoors(true, false, false, false);
			addNode(node);

			generateRoom();
			
			node = generateNode(2,4);
			node.setBorders(2, 3, 1, 1);
			node.setDoors(false, false, false, false);
			addNode(node);
						
			node = generateNode(3,4);
			node.setBorders(1, 3, 2, 1);
			node.setDoors(false, false, false, false);
			addNode(node);
			
			node = generateNode(2,5);
			node.setBorders(2, 1, 1, 3);
			node.setDoors(true, false, false, false);
			addNode(node);
						
			node = generateNode(3,5);
			node.setBorders(1, 1, 2, 3);
			node.setDoors(false, false, true, false);
			addNode(node);

			generateRoom();

			node = generateNode(3,0);
			node.setBorders(2, 2, 1, 2);
			node.setDoors(false, true, false, true);
			addNode(node);
						
			node = generateNode(4,0);
			node.setBorders(1, 2, 2, 2);
			node.setDoors(false, true, false, true);
			addNode(node);

			generateRoom();
			
			node = generateNode(3,1);
			node.setBorders(2, 2, 1, 3);
			node.setDoors(true, true, false, false);
			addNode(node);
						
			node = generateNode(4,1);
			node.setBorders(1, 2, 2, 3);
			node.setDoors(false, true, true, false);
			addNode(node);
			
			generateRoom();
			
			node = generateNode(4,3);
			node.setBorders(3, 3, 3, 1);
			node.setDoors(false, false, false, false);
			addNode(node);
			
			node = generateNode(4,4);
			node.setBorders(2, 1, 2, 2);
			node.setDoors(false, false, true, true);
			addNode(node);

			generateRoom();

			node = generateNode(4,5);
			node.setBorders(2, 2, 2, 1);
			node.setDoors(true, true, false, false);
			addNode(node);

			node = generateNode(4, 6);
			node.setBorders(3, 1, 3, 3);
			node.setDoors(false, false, false, false);
			addNode(node);

			generateRoom();
			
			node = generateNode(5,0);
			node.setBorders(2, 3, 3, 1);
			node.setDoors(false, false, false, false);
			addNode(node);
						
			node = generateNode(5,1);
			node.setBorders(2, 1, 2, 3);
			node.setDoors(true, false, true, false);
			addNode(node);

			generateRoom();
			
			node = generateNode(5,4);
			node.setBorders(2, 3, 2, 1);
			node.setDoors(true, false, true, false);
			addNode(node);

			node = generateNode(5, 5);
			node.setBorders(2, 1, 2, 3);
			node.setDoors(false, false, true, false);
			addNode(node);
			
			generateRoom();

			node = generateNode(6,1);
			node.setBorders(2, 3, 1, 1);
			node.setDoors(true, false, false, false);
			addNode(node);
						
			node = generateNode(7,1);
			node.setBorders(1, 3, 3, 1);
			node.setDoors(false, false, false, false);
			addNode(node);

			node = generateNode(6,2);
			node.setBorders(3, 1, 1, 2);
			node.setDoors(false, false, false, true);
			addNode(node);
						
			node = generateNode(7,2);
			node.setBorders(1, 1, 3, 2);
			node.setDoors(false, false, false, false);
			addNode(node);
			
			generateRoom();

			node = generateNode(6,3);
			node.setBorders(3, 2, 2, 1);
			node.setDoors(false, true, true, false);
			addNode(node);

			node = generateNode(6,4);
			node.setBorders(2, 1, 2, 2);
			node.setDoors(true, false, false, true);
			addNode(node);

			generateRoom();
			
			node = generateNode(7,3);
			node.setBorders(2, 2, 2, 1);
			node.setDoors(true, false, true, false);
			addNode(node);

			node = generateNode(7,4);
			node.setBorders(2, 1, 3, 2);
			node.setDoors(false, false, true, false);
			addNode(node);
			
			generateRoom();

			node = generateNode(6, 5);
			node.setBorders(2, 2, 1, 1);
			node.setDoors(true, true, false, false);
			addNode(node);			
						
			node = generateNode(7, 5);
			node.setBorders(1, 2, 2, 1);
			node.setDoors(false, false, false, false);
			addNode(node);

			node = generateNode(6, 6);
			node.setBorders(3, 1, 1, 3);
			node.setDoors(false, false, false, false);
			addNode(node);
						
			node = generateNode(7, 6);
			node.setBorders(1, 1, 2, 3);
			node.setDoors(false, false, true, false);
			addNode(node);

			generateRoom();

			node = generateNode(8, 5);
			node.setBorders(2, 3, 3, 1);
			node.setDoors(false, false, false, false);
			addNode(node);
						
			node = generateNode(8, 6);
			node.setBorders(2, 1, 3, 3);
			node.setDoors(true, false, false, false);
			addNode(node);
		}
	}
}