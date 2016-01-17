package State {
	public class StateMachine {
		private var _currentState:IState;
		private var _previousState:IState;
		private var _nextState:IState;
		
		public function StateMachine() {
			_currentState = null;
			_previousState = null;
			_nextState = null;
		}
		
		// prepare a state for use after the current state
		public function setNextState(state:IState ):void {
			_nextState = state;
		}

		// Update the FSM. Parameter is the frametime for this frame.
		public function update( time:Number ):void {
			if( _currentState ) {
				_currentState.update( time );
			}
		}
		
		// Set init state
		public function set initState(state:IState):void {
			//so we don't have to check if _currentState = null
			_currentState = state;
		}
		
		// Change to another state
		public function changeState( state:IState ):void {
			_currentState.exit();
			_previousState = _currentState;
			_currentState = state;
			_currentState.enter;
		}
		
		// Change back to the previous state
		public function goToPreviousState():void {
			changeState( _previousState );
		}
    
		// Go to the next state
		public function goToNextState():void {
			changeState( _nextState );
		}
	}
}