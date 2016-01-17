package State {
	import Crew.Crew;
	import Ship.IShip;
	
	public final class GameData {
		//{ Singelton init
		private static var _instance:GameData;

		public function GameData(){
			if(_instance){
				throw new Error("Game... use getInstance()");
			} 
			_instance = this;
			init();
		}

		public static function getInstance():GameData {
			if(!_instance){
				new GameData();
			} 
			return _instance;
		}
		//}
	
		public function init():void {
			_difficulty = 1;
		}
		
		private var _difficulty:int; //1 or 2
		private var _ship:IShip;
		private var _crew:Crew;
		
		public function get difficulty():int {
			return _difficulty;
		}
		
		public function set difficulty(value:int):void {
			_difficulty = value;
		}
		
		public function get ship():IShip {
			return _ship;
		}
		
		public function set ship(value:IShip):void {
			_ship = value;
		}
	}
}