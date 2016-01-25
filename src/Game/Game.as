package Game {
	import Debug.FPSCounter;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import RectangleSelector.RectangleSelector;
	import Ship.Ship;
	import State.DEFAULTS;
	import State.GameData;
	import UI.*;
	
	
	
	public class Game extends MovieClip {
		private var _UI:LIB_Game;
		private var _panelTop:Sprite;
		private var _panelBot:Sprite;
		private var _shipContainer:Sprite;
		private var _gameData:GameData;
		private var _ship:Ship;
		public var _rectangleSelector:RectangleSelector;
		private var _fpsCounter:FPSCounter;

		
		//Panels
		private var _uiHitpoints:StepComponent;
		private var _uiShield:StepComponent;
		private var _uiOxygen:BarComponent;
		private var _uiWarpDrive:BarComponent;
		private var _uiEvasion:SimpleStatus;
		private var _uiRockets:SimpleStatus;
		private var _uiDroids:SimpleStatus;
		private var _uiFuel:SimpleStatus;
		
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
			
			//_UI.btnReturn.addEventListener(MouseEvent.CLICK, handleReturnClick);
			initPanels();
			
			this.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		private function handleReturnClick(e:MouseEvent):void {
			//_ship.testRoomsOut();
		}
		
		private function handleEnterFrame(e:Event):void {
			_uiOxygen.stepCurrent = _ship.statOxygenNow;
			_uiOxygen.rerender();
		}
		
		private function initPanels():void {
			//Hitpoints
			_uiHitpoints = new UI.StepComponent();
			_uiHitpoints.x = 20;
			_uiHitpoints.y = DEFAULTS.PanelOffsetTop;
			_uiHitpoints.icon = new iconHitPoints;
			_uiHitpoints.displayWidth = 300;
			_uiHitpoints.displayHeight = 30;
			_uiHitpoints.stepsTotal = _ship.statHealthMax;
			_uiHitpoints.stepCurrent = _ship.statHealthNow;
			
			_panelTop.addChild(_uiHitpoints);
			
			//Shields
			_uiShield = new StepComponent();
			_uiShield.x = 370;
			_uiShield.y = DEFAULTS.PanelOffsetTop;
			_uiShield.icon = new iconShield;
			_uiShield.displayWidth = 100;
			_uiShield.displayHeight = 30;
			_uiShield.stepsTotal = _ship.statShieldMax;
			_uiShield.stepCurrent = _ship.statShieldNow;
			
			_panelTop.addChild(_uiShield);
			
			//Oxygen
			_uiOxygen = new BarComponent();
			_uiOxygen.x = 520;
			_uiOxygen.y = DEFAULTS.PanelOffsetTop;
			_uiOxygen.icon = new iconOxygen;
			_uiOxygen.displayWidth = 30;
			_uiOxygen.displayHeight = 30;
			_uiOxygen.stepsTotal = _ship.statOxygenMax;
			_uiOxygen.stepCurrent = _ship.statOxygenNow;
			
			_panelTop.addChild(_uiOxygen);
			
			//WarpDrive
			_uiWarpDrive = new BarComponent();
			_uiWarpDrive.x = 560;
			_uiWarpDrive.y = DEFAULTS.PanelOffsetTop;
			_uiWarpDrive.icon = new iconWarpDrive;
			_uiWarpDrive.displayWidth = 30;
			_uiWarpDrive.displayHeight = 30;
			_uiWarpDrive.stepsTotal = _ship.statOxygenMax;
			_uiWarpDrive.stepCurrent = _ship.statOxygenNow;
			
			_panelTop.addChild(_uiWarpDrive);
			
			//Evasion
			_uiEvasion = new SimpleStatus();
			_uiEvasion.x = 610;
			_uiEvasion.y = DEFAULTS.PanelOffsetTop;
			_uiEvasion.icon = new iconEvasion;
			_uiEvasion.text = _ship.statOxygenNow.toString();
			
			_panelTop.addChild(_uiEvasion);
			
			//Rockets
			_uiRockets = new SimpleStatus();
			_uiRockets.x = 690;
			_uiRockets.y = DEFAULTS.PanelOffsetTop;
			_uiRockets.icon = new iconRockets;
			_uiRockets.text = "hi";
			
			addChild(_uiRockets);
			
			//Droids
			_uiDroids = new SimpleStatus();
			_uiDroids.x = 750;
			_uiDroids.y = DEFAULTS.PanelOffsetTop;
			_uiDroids.icon = new iconDroid;
			_uiDroids.text = "hi";
			
			addChild(_uiDroids);
			
			//Fuel
			_uiFuel = new SimpleStatus();
			_uiFuel.x = 810;
			_uiFuel.y = DEFAULTS.PanelOffsetTop;
			_uiFuel.icon = new iconEnergy;
			_uiFuel.text = "hi";
			
			addChild(_uiFuel);
		}
	}
}