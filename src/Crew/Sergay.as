package Crew {
	public class Sergay extends Crew {
		public function Sergay() {
			crewName = "Sergay";
			crewLayout = new LIB_Crew_Sergay();
			crewPortrait = new LIB_Crew_Sergay();
			
			speed = 3;
		}
	}
}