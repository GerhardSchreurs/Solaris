package Direction {
	public final class DirectionsFactory {
		
		public function DirectionsFactory():void {
		}
		
		public static function create(speed:Number):Directions {
			var modifier:Number = .75;
			var directions:Directions = new Directions();

			directions.TOPLPOS.x = 0 - speed;
			directions.TOPLPOS.y = 0 - speed;
			directions.TOPCPOS.x = 0;
			directions.TOPCPOS.y = 0 - speed;
			directions.TOPRPOS.x = speed;
			directions.TOPRPOS.y = 0 - speed;
			directions.MIDLPOS.x = 0 - speed;
			directions.MIDLPOS.y = 0;
			directions.MIDCPOS.x = 0;
			directions.MIDCPOS.y = 0;
			directions.MIDRPOS.x = speed;
			directions.MIDRPOS.y = 0;
			directions.BOTLPOS.x = 0 - speed;
			directions.BOTLPOS.y = speed;
			directions.BOTCPOS.x = 0;
			directions.BOTCPOS.y = speed;
			directions.BOTRPOS.x = speed;
			directions.BOTRPOS.y = speed;
			
			directions.TOPLPOS.x = (directions.TOPLPOS.x * modifier);
			directions.TOPLPOS.y = (directions.TOPLPOS.y * modifier);
			directions.TOPRPOS.x = (directions.TOPRPOS.x * modifier);
			directions.TOPRPOS.y = (directions.TOPRPOS.y * modifier);
			directions.BOTLPOS.x = (directions.BOTLPOS.x * modifier);
			directions.BOTLPOS.y = (directions.BOTLPOS.y * modifier);
			directions.BOTRPOS.x = (directions.BOTRPOS.x * modifier);
			directions.BOTRPOS.y = (directions.BOTRPOS.y * modifier);
			
			return directions;		
		}
	}
}