package  {
	import Dialog.Dialog;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Menu extends Sprite {
		private var UI:LIB_Menu;
		
		public function Menu() {
			this.addEventListener(Event.REMOVED, handleRemoved, false, 0, true);	
			
			UI = new LIB_Menu;
			addChild(UI);
			createButtons();
		}
		
		private function createButtons():void {
			var objButton:LIB_Menu_button;
			
			objButton = new LIB_Menu_button();
			objButton.txtField.text = 'CONTINUE';
			objButton.name = '1';
			addButton(objButton);
			
			objButton = new LIB_Menu_button();
			objButton.txtField.text = 'NEW GAME';
			objButton.name = '2';
			addButton(objButton);
			
			objButton = new LIB_Menu_button();
			objButton.txtField.text = 'OPTIONS';
			objButton.name = '3';
			addButton(objButton);
			
			objButton = new LIB_Menu_button();
			objButton.txtField.text = 'CREDITS';
			objButton.name = '4';
			addButton(objButton);
			
			objButton = new LIB_Menu_button();
			objButton.txtField.text = 'QUIT';
			objButton.name = '5';
			addButton(objButton);
		}
		
		private function addButton(objButton:LIB_Menu_button):void {
			objButton.background.alpha = .4;
			objButton.addEventListener(MouseEvent.MOUSE_OVER, handleButtonOver, false, 0, true);
			objButton.addEventListener(MouseEvent.MOUSE_OUT, handleButtonOut, false, 0, true);
			objButton.addEventListener(MouseEvent.CLICK, handleButtonClick, false, 0, true);
			addChild(objButton);
			
			var i:Number = Number(objButton.name);
			objButton.y = 140 + (47 * i);
		}
		
		function handleButtonOver(e:MouseEvent):void {
			LIB_Menu_button(e.currentTarget).background.alpha = .9;
		}
		
		function handleButtonOut(e:MouseEvent):void	{
			LIB_Menu_button(e.currentTarget).background.alpha = .4;
		}
		
		function handleButtonClick(e:MouseEvent):void {
			var i:Number = Number(LIB_Menu_button(e.currentTarget).name);
			
			switch (i) {
			case 2: 
				var objParent:Main = Main(parent);
				objParent.initHangar();
			}
		}
		
		function handleRemoved(e:Event):void {
			dispose();
		}
		
		public function dispose():void {
			this.removeEventListener(Event.REMOVED, handleRemoved);
			var objButton:LIB_Menu_button;
			
			for (var i:int = this.numChildren - 1; i >= 0; i--) {
				if (this.getChildAt(i) is LIB_Menu_button) {
					objButton = LIB_Menu_button(this.getChildAt(i));
					objButton.removeEventListener(MouseEvent.CLICK, handleButtonClick);
					objButton.removeEventListener(MouseEvent.MOUSE_OVER, handleButtonOver);
					objButton.removeEventListener(MouseEvent.MOUSE_OUT, handleButtonOut);
					this.removeChild(objButton);
					objButton = null;
				} 
			}
		}
  }
}