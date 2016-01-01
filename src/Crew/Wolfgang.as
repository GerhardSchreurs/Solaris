package Crew {
	public class Wolfgang extends ICrew {
		public function Wolfgang() {
			crewName = "Wolfgang";
			crewLayout = new LIB_Crew_Wolfgang();
			crewPortrait = new LIB_Crew_Wolfgang();
			
			speed = 4;
		}
	}
}