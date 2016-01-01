package {
	import Crew.ICrew;
	import Debug.FPSCounter;
	import Dialog.Dialog;
	import flash.accessibility.ISearchableText;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import Ship.IShip;
	import RectangleSelector.RectangleSelector;
	import RectangleSelector.RectangleSelectionEvent;
	import Ship.Torus;
	
	public class Hangar extends Sprite implements IDisposable {
		private var UI:LIB_Hangar;
		
		private var _disposeAllInFleet:Boolean;
		private var _fleetIndex:Number = 0;
		private var _fleet:Vector.<IShip> = new Vector.<IShip>();
		private var _dialog:Dialog //Done;
		private var _fpsCounter:FPSCounter; //Done
		private var _shipCurrent:IShip;
		private var _isDisposed:Boolean;
		public var _rectangleSelector:RectangleSelector //Done;
		private var _main:Main;
		
		private function get nextShipIndex():Number {
			if ((_fleetIndex + 1) < _fleet.length) {
				return _fleetIndex + 1;
			} else {
				return 0;
			}
		}
		
		private function get prevShipIndex():Number  {
			if ((_fleetIndex - 1) >= 0) {
				return _fleetIndex - 1;
			} else {
				return _fleet.length - 1;
			}
		}
		
		public function Hangar(main:Main):void  {
			//TODO, this handler, still necessary?
			//this.addEventListener(Event.REMOVED, handleRemoved, false, 0, true);
			
			_main = main;
			
			_rectangleSelector = new RectangleSelector(new Rectangle(200,50, 800, 575));
			
			trace('initHangar');
			
			UI = new LIB_Hangar();
			UI.name = 'hangar';
			addChild(UI);
			
			UI.btnPrev.addEventListener(MouseEvent.CLICK, handlePrevClick, false, 0, true);
			UI.btnNext.addEventListener(MouseEvent.CLICK, handleNextClick, false, 0, true);
			UI.btnReturn.addEventListener(MouseEvent.CLICK, handleReturnClick, false, 0, true);
			
			UI.btnStartEasy.addEventListener(MouseEvent.CLICK, handleStartGameEasy);
			UI.btnStartHard.addEventListener(MouseEvent.CLICK, handleStartGameHard);
			
			
			var ship:IShip;

			ship = new Ship.Kestrel();
			ship.rectangleSelector = _rectangleSelector;
			_fleet.push(ship);

			ship = new Ship.Torus();
			ship.rectangleSelector = _rectangleSelector;
			_fleet.push(ship);
			
			ship = new Ship.Osprey();
			ship.rectangleSelector = _rectangleSelector;
			_fleet.push(ship);

			setUI();
			
			addChild(_rectangleSelector);
			
			_fpsCounter = new FPSCounter();
			addChild(_fpsCounter);
		}
		
		private function clearUI():void {
			var ship:IShip = _fleet[_fleetIndex];
			removeChild(ship.shipLayout);
		}
		
		private function setUI():void {
			_shipCurrent = _fleet[_fleetIndex];
			UI.txtName.text = _shipCurrent.shipName;
			addChild(_shipCurrent.shipLayout);
			
			_shipCurrent.shipLayout.x = 306;
			_shipCurrent.shipLayout.y = 144;
			
			fillCrew();
		}
		
		private function fillCrew():void {
			for (var i:Number = 0; i < _shipCurrent.shipCrew.length; i++) {
				if (i == 3) {
					trace("cannot exceed 3 crewMembers for display in hangar");
					return;
				}
				var crewMember:ICrew = _shipCurrent.shipCrew[i];
				var block:MovieClip = UI.getChildByName("blockCrew_" + (i + 1)) as MovieClip;
				
				block.addChild(crewMember.crewPortrait);
			}
		}
		
		private function handlePrevClick(e:MouseEvent):void {
			clearUI();
			_fleetIndex = prevShipIndex;
			setUI();
		}
		
		private function handleNextClick(e:MouseEvent):void {
			clearUI();
			_fleetIndex = nextShipIndex;
			setUI();
		}
		
		private function handleReturnClick(e:MouseEvent):void {
			if (_dialog == null) {
				_dialog = new Dialog(this.stage, "Return to home", "Are you sure that you want to leave the hangar?", handleDialogCancel, handleDialogCancel, handleDialogOk);
				
				addChild(_dialog);
			}
			
			_dialog.Show();
		}
		
		private function handleDialogCancel():void {
			_dialog.Hide();
		}
		
		private function handleDialogOk():void {
			_disposeAllInFleet = true;
			_dialog.Hide();
			_main.initMenu();
		}
		
		
		private function handleRemoved(e:Event):void {
			dispose();
		}
		
		private function handleStartGameEasy(e:MouseEvent):void {
			startGame(1);
		}
		
		private function handleStartGameHard(e:MouseEvent):void {
			startGame(2);
		}
		
		private function startGame(difficulty:int):void {
			_disposeAllInFleet = false;
			_main.gameData.difficulty = difficulty;
			_main.gameData.ship = _shipCurrent;
			_main.initGame();
		}
		
		public function get isDisposed():Boolean {
			return _isDisposed;
		}
		
		public function dispose():void {
			trace("Hangar.dispose(" + _isDisposed + ")");
			if (_isDisposed) { return; }
			
			var count:int;
			//this.removeEventListener(Event.REMOVED, handleRemoved);
			
			//Event handlers
			UI.btnPrev.removeEventListener(MouseEvent.CLICK, handlePrevClick);
			UI.btnNext.removeEventListener(MouseEvent.CLICK, handleNextClick);
			UI.btnReturn.removeEventListener(MouseEvent.CLICK, handleReturnClick);
			
			//FPS
			removeChild(_fpsCounter);
			_fpsCounter.dispose();
			_fpsCounter = null;
			
			//DIALOG
			if (_dialog != null) {
				removeChild(_dialog);
				_dialog.dispose();
				_dialog = null;
			}
			
			//Fleet
			count = _fleet.length;
			
			trace("disposeAllInFleet = " + _disposeAllInFleet);
			
			for (var i:int = 0; i < count; i++) {
				var ship:IShip = _fleet[i];
				
				if (ship == _shipCurrent) {
					removeChild(_shipCurrent.shipLayout);
					if (_disposeAllInFleet) {
						ship.dispose();
						ship = null;
					}
				} else {
					ship.dispose();
					ship = null;
				}
			}
			

			_fleet.length = 0;
			_fleet = null;
			
			
			//RectangleSelector (AFTER FLEET, cause they have references
			//BAD programming... bad..
			removeChild(_rectangleSelector);
			_rectangleSelector.dispose();
			_rectangleSelector = null;

			
			//UI
			removeChild(UI);
			UI = null;
			
			//main
			_main = null;
			
			_isDisposed = true;
		}
	}
}