package {
	import Dialog.Dialog;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import Ship.Kestrel;
	import Ship.Node;
	import Ship.Torus;
	import State.GameData;
	import Game.Game;
	
	[Frame(factoryClass="Preloader")]
	
	public class Main extends Sprite {
		public var gameData:GameData = GameData.getInstance();
		private var _hangar:Hangar;
		private var _menu:Menu;
		private var _game:Game;
		
		
		public function Main():void {
		  if (stage) {
			  init();
		  } else {
			  addEventListener(Event.ADDED_TO_STAGE, init);
		  }
		}

		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.addEventListener(MouseEvent.RIGHT_CLICK, function(e:Event):void { } );
			
			//var objSound:LIB_Music_track1  = new LIB_Music_track1();
			//objSound.play();
		  
			//preInitGame();
			//initGame();
			
			
			initMenu();
			
			/*
			var njaa:MovieClip = new MovieClip();
			njaa.addChild(new LIB_Kestrel());
			njaa.scrollRect = new Rectangle(100, 100, 200, 200);
			addChild(njaa);
			*/
			
			
			
		  
			
			//initHangar();
			/*
			var objShip:Ship = new Ship;
			trace(objShip.nameOfShip);
			
			var objSystem:SupportSystem = new SupportSystem(1);
			*/
		}
		
		private function preInitGame():void {
			//for debug purposes
			
			var ship:Kestrel = new Kestrel();
			ship.shipLayout.x = 300;
			ship.shipLayout.y = 150;
			gameData.ship = ship;
			gameData.difficulty = 1;
		}
		
		
		public function initGame():void {
			cleanUp();
			
			trace("4:initGame called!!!");
			
			
			_game = new Game();
			addChild(_game);
		}

		public function initMenu():void {
			cleanUp();

			_menu = new Menu();
			_menu.name = 'objMenu';
			addChild(_menu);
		}

		public function initHangar():void {
			cleanUp();
			
			_hangar = new Hangar(this);
			_hangar.name = 'objHangar';
			addChild(_hangar);
		}
		
		private function cleanUp():void {
			if (_menu != null) {
				trace("Main.cleanUp : removing menu!");

				removeChild(_menu);
				_menu.dispose();
				_menu = null;
			}
			
			if (_hangar != null) {
				trace("Main.cleanUp : removing hangar!");
				removeChild(_hangar);
				_hangar.dispose();
				_hangar = null;
			}
		}
	}
}