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
	
	public class Hangar extends Sprite {
		private var _fleetIndex:Number = 0;
		private var _fleet:Vector.<IShip> = new Vector.<IShip>();
		private var UI:LIB_Hangar;
		private var _dialog:Dialog;
		private var _shipCurrent:IShip;
		
		public var rectangleSelector:RectangleSelector;
		
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
		
		public function Hangar():void  {
			this.addEventListener(Event.REMOVED, handleRemoved, false, 0, true);
			
			rectangleSelector = new RectangleSelector(new Rectangle(200,50, 800, 575));
			
			trace('initHangar');
			
			UI = new LIB_Hangar();
			UI.name = 'hangar';
			addChild(UI);
			
			UI.btnPrev.addEventListener(MouseEvent.CLICK, handlePrevClick, false, 0, true);
			UI.btnNext.addEventListener(MouseEvent.CLICK, handleNextClick, false, 0, true);
			UI.btnReturn.addEventListener(MouseEvent.CLICK, handleReturnClick, false, 0, true);
			
			var ship:IShip;

			ship = new Ship.Kestrel();
			ship.hangar = this;
			_fleet.push(ship);

			ship = new Ship.Torus();
			ship.hangar = this;
			_fleet.push(ship);
			
			ship = new Ship.Osprey();
			ship.hangar = this;
			_fleet.push(ship);

			
			/*
			_fleet.push(new Ship.Kestrel(this));
			_fleet.push(new Ship.Torus(this));
			_fleet.push(new Ship.Osprey(this));
			*/
			
			setUI();
			
			addChild(rectangleSelector);
			
			var fpsCounter:FPSCounter = new FPSCounter();
			addChild(fpsCounter);
		}
		
		function clearUI():void {
			var ship:IShip = _fleet[_fleetIndex];
			removeChild(ship.shipLayout);
		}
		
		function setUI():void {
			_shipCurrent = _fleet[_fleetIndex];
			UI.txtName.text = _shipCurrent.shipName;
			addChild(_shipCurrent.shipLayout);
			
			_shipCurrent.shipLayout.x = 306;
			_shipCurrent.shipLayout.y = 144;
			
			fillCrew();
		}
		
		function fillCrew():void {
			for (var i:Number = 0; i < _shipCurrent.shipCrew.length; i++) {
				var crewMember:ICrew = _shipCurrent.shipCrew[i];
				var block:MovieClip = UI.getChildByName("blockCrew_" + (i + 1)) as MovieClip;
				
				block.addChild(crewMember.crewPortrait);
			}
		}
		
		function handlePrevClick(e:MouseEvent):void {
			clearUI();
			_fleetIndex = prevShipIndex;
			setUI();
		}
		
		function handleNextClick(e:MouseEvent):void {
			clearUI();
			_fleetIndex = nextShipIndex;
			setUI();
		}
		
		function handleReturnClick(e:MouseEvent):void {
			if (_dialog == null) {
				_dialog = new Dialog(this.stage, "Return to home", "Are you sure that you want to leave the hangar?", null, null, handleDialogOk);
				addChild(_dialog);
			}
			
			_dialog.Show();
		}
		
		function handleDialogOk():void {
				trace("handleDialogOk");
				
				_dialog.Hide();
		}
		
		
		function handleRemoved(e:Event):void {
			dispose();
		}
		
		public function dispose():void {
			this.removeEventListener(Event.REMOVED, handleRemoved);
			//TODO, implement
		}
	}
}