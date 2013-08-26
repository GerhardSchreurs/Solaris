package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.StageAlign;
    import flash.display.StageScaleMode;
	import Soundlib_track1;

	/**
	 * ...
	 * @author Wroah
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		public function MainOLD():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode = StageScaleMode.SHOW_ALL; 
			
			var objBackground:Menu = new Menu();
			
			objBackground.name = 'backgroundMenu';
			addChild(objBackground);
			
			var objSound:Soundlib_track1 = new Soundlib_track1();
			objSound.play();
			
			createHomeButtons();
		}
		
		private function createHomeButtons() {
			var objButton:Menu_button;
			
			objButton = new Menu_button();
			objButton.txtField.text = 'CONTINUE';
			objButton.name = '1';
			addButton(objButton);

			objButton = new Menu_button();
			objButton.txtField.text = 'NEW GAME';
			objButton.name = '2';
			addButton(objButton);

			objButton = new Menu_button();
			objButton.txtField.text = 'OPTIONS';
			objButton.name = '3';
			addButton(objButton);
		
			objButton = new Menu_button();
			objButton.txtField.text = 'CREDITS';
			objButton.name = '4';
			addButton(objButton);

			objButton = new Menu_button();
			objButton.txtField.text = 'QUIT';
			objButton.name = '5';
			addButton(objButton);
		}
		
		private function addButton(objButton:Menu_button):void {
			objButton.mcBackground.alpha = .4;
			objButton.addEventListener(MouseEvent.MOUSE_OVER, handleButtonOver);
			objButton.addEventListener(MouseEvent.MOUSE_OUT, handleButtonOut);
			objButton.addEventListener(MouseEvent.CLICK, handleButtonClick);
			addChild(objButton);
			trace(objButton.parent);
			
			var i:Number = Number(objButton.name);
			objButton.y = 140 + (47 * i);
		}
		
		function handleButtonOver(e:MouseEvent):void  {
			Menu_button(e.currentTarget).mcBackground.alpha = .9;
		}			
		function handleButtonOut(e:MouseEvent):void  {
			Menu_button(e.currentTarget).mcBackground.alpha = .4;
		}
		function handleButtonClick(e:MouseEvent):void  {
			var i:Number = Number(Menu_button(e.currentTarget).name);
			
			switch(i) {
				case 2 : destroyHome();  initHangar(); 
			}
		}
		
		
		function destroyHome() {
			var objButton:Menu_button;
			
			for (var i:int = this.numChildren - 1; i>=0; i--) {
				if (this.getChildAt(i) is Menu_button) {	
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
		


	}

}