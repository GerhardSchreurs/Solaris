package Game {
	import Debug.FPSCounter;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import RectangleSelector.RectangleSelector;
	import Ship.IShip;
	import State.GameData;
	import UI.*;
	
	
	
	public class Game extends MovieClip {
		private var _UI:LIB_Game;
		private var _panelTop:Sprite;
		private var _panelBot:Sprite;
		private var _shipContainer:Sprite;
		private var _gameData:GameData;
		private var _ship:IShip;
		public var _rectangleSelector:RectangleSelector;
		private var _fpsCounter:FPSCounter;

		
		//Panels
		private var _uiHealthBar:StepComponent;
		
		public function Game() {
			_gameData = GameData.getInstance();
			_UI = new LIB_Game;
			_fpsCounter = new FPSCounter;
			
			_panelTop = _UI.panelTop;
			_panelBot = _UI.panelBottom;
			_shipContainer = _UI.shipContainer;
			
			
			_rectangleSelector = new RectangleSelector(new Rectangle(200, 100, 800, 475));
			_ship = _gameData.ship;
			_ship.rectangleSelector = _rectangleSelector;

			addChild(_rectangleSelector);
			addChild(_UI);
			_shipContainer.addChild(_ship.shipLayout);
			
			addChild(_fpsCounter);
			
			
			initPanels();
		}
		
		private function initPanels():void {
			//Health
			_uiHealthBar = new UI.StepComponent();
			_uiHealthBar.x = 10;
			_uiHealthBar.y = 15;
			_uiHealthBar.icon = new iconHealth;
			_uiHealthBar.displayWidth = 300;
			_uiHealthBar.displayHeight = 30;
			_uiHealthBar.stepsTotal = 30;
			_uiHealthBar.stepCurrent = 30;
			
			_panelTop.addChild(_uiHealthBar);
			
			_uiHealthBar.stepCurrent = 4;
			_uiHealthBar.rerender();
		}
	}
}