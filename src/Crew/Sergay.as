package Crew {
	public class Sergay extends ICrew {
		public function Sergay() {
			this.crewName = "Sergay";
			this.crewLayout = new LIB_Crew_Sergay();
			this.crewPortrait = new LIB_Crew_Sergay();
		}
	}
}