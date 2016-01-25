package Ship {
	public class ShipFactory {
		public function ShipFactory(shipType:ShipType):Ship {
			switch (shipType) {
				case (ShipType.KESTREL) {
					return new Kestrel();
					break;
				}
			}
		}
	}
}