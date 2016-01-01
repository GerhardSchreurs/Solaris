package Crew {
	public class Gerhard extends ICrew {
		public function Gerhard() {
			crewName = "Gerhard";
			crewLayout = new LIB_Crew_Gerhard();
			crewPortrait = new LIB_Crew_Gerhard();
			
			speed = 2;
		}
	}
}