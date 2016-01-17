package State {
	public interface IState {
		function enter():void; 				// called on entering the state
		function exit():void; 				// called on leaving the state
		function update(tick:int):void;	// called every frame while in the state
	}
}