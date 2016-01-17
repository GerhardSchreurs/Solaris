package State {
	import Crew.Crew;
	import Ship.Node;
	
	public class Walk implements IState {
		//I chose to handle the whole walking routine in IShip / ICrew instead for
		//performance reasons.
		
		private var _stateMachine:StateMachine;
		private var _crewMember:Crew;
		
		public function Walk(crewMember:Crew) {
			_crewMember = crewMember;
			_stateMachine = crewMember.stateMachine;
		}
		
		public function enter():void {
			
		}
		
		public function exit():void {
			
		}
		
		public function update(tick:int):void {
			
		}
	}
}