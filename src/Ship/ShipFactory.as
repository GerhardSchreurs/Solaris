package Ship {
	public class ShipFactory {
		public function ShipFactory(shipType:ShipType):IShip {
			switch (shipType) {
				case (ShipType.KESTREL) {
					return new Kestrel();
					break;
				}
			}
		}
	}
}