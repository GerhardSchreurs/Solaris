package State {
	import Crew.Crew;

	public class Idle implements IState {
		
		private var _stateMachine:StateMachine;
		private var _crewMember:Crew;
		
		public function Idle(crewMember:Crew) {
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