package  {
	/**
	 * ...
	 * @author Wroah
	 */
	public class SupportSystem {
		public var supportTypeID:int = 0;
		
		var arrSupportTypeNames:Vector.<String>;
		var arrPowerCosts:Vector.<String>;
		
		public function SupportSystem(ID:int = 0) {
			initArrays();
		}
		
		private function initArrays():void {
			arrSupportTypeNames = new Vector.<String>;
			arrPowerCosts = new Vector.<String>;
			
			arrSupportTypeNames[0] = 'Piloting';
			arrSupportTypeNames[1] = 'Door System';
			arrSupportTypeNames[2] = '';
			
			arrPowerCosts[0] = '';
			arrPowerCosts[1] = '';
			arrPowerCosts[2] = '';
			
		}
	}
}