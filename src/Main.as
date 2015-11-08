package {
	import Dialog.Dialog;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import Ship.Node;
	
	[Frame(factoryClass="Preloader")]
	
	public class Main extends Sprite {
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
			stage.addEventListener(MouseEvent.RIGHT_CLICK, function(e:Event) { } );
			
			var objSound:LIB_Music_track1  = new LIB_Music_track1();
			//objSound.play();
		  
			initMenu();
		  
			//initHangar();
			/*
			var objShip:Ship = new Ship;
			trace(objShip.nameOfShip);
			
			var objSystem:SupportSystem = new SupportSystem(1);
			*/
		}

		public function initMenu() {
			var objMenu:Menu = new Menu();
			objMenu.name = 'objMenu';
			addChild(objMenu);
			
		}

		public function initHangar():void {
			cleanUp();
			
			var objHangar:Hangar = new Hangar();
			objHangar.name = 'objHangar';
			addChild(objHangar);
		}

		function cleanUp():void {
			if (getChildByName('objMenu') != undefined) {
				removeChild(getChildByName('objMenu'));
			}
		}


		function destroyHome() {
			var objButton:LIB_Menu_button;
	  
			for (var i:int = this.numChildren - 1; i >= 0; i--) {
				if (this.getChildAt(i) is LIB_Menu_button) {
					//objButton = Menu_button(this.getChildAt(i));
					//this.removeChild(objButton);
					this.removeChildAt(i);
				} else {
					trace(this.getChildAt(i).name);
				}
			}

			/*
			for ( var i:int = 0; i < this.numChildren; i++) {
			if ( stage.getChildAt(i) is Menu_button) {
			trace("found");
			}
			}
			*/
		}

		/*
		function initHangar():void {
		  trace('initHangar');
		  //removeChild(getChildByName('backgroundMenu'));
		  
		  var objBackgroundMenu = getChildByName('backgroundMenu');
		  var intIndex:int = objBackgroundMenu.parent.getChildIndex(objBackgroundMenu);
		  removeChild(objBackgroundMenu);
		  
		  var objBackground:Hangar_background = new Hangar_background();
		  objBackground.name = 'backgroundHangar';
		  addChild(objBackground);
		  setChildIndex(objBackground, intIndex);
		}
		*/
	}
}