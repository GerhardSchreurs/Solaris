package Crew {
	import flash.display.Sprite;
	import State.StateMachine;
	
	public class Agent extends Sprite {
		private var _stateMachine:StateMachine;

		public function Agent() {
			_stateMachine = new StateMachine();
		}
		
		public function update( tick:int ):void {
			_stateMachine.update( tick );
		}
    
		public function get stateMachine():StateMachine {
			return _stateMachine;
		}
	}
}