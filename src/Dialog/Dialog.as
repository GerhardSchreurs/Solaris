package Dialog {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	
	public class Dialog extends Sprite implements IDisposable {
		private var _dialog:LIB_Dialog
		private var _closeReference:Function;
		private var _cancelReference:Function;
		private var _okReference:Function;
		private var _btnClose:SimpleButton;
		private var _btnOk:LIB_Dialog_Button_Container;
		private var _btnCancel:LIB_Dialog_Button_Container;
		private var _stage:Stage;
		private var _isDisposed:Boolean;
		
		public function Dialog(stage:Stage, title:String, message:String, close:Function = null, cancel:Function = null, ok:Function = null):void {
			_dialog = new LIB_Dialog();
			_stage = stage;
			_okReference = ok;
			_cancelReference = cancel;
			_closeReference = close;
			_btnClose = _dialog.buttonClose; //x
			
			if (ok != null) {
				//we need an o.k. button
				_btnOk = new LIB_Dialog_Button_Container();
				_btnOk.addEventListener(MouseEvent.CLICK, handleButtonOkClick, false, 0, true);
				_btnOk.title.text = "OK";
				_btnOk.title.mouseEnabled = false;
				
				_dialog.addChild(_btnOk);
			}
			if (cancel != null) {
				//we need a cancel button
				
				_btnCancel = new LIB_Dialog_Button_Container();
				_btnCancel.addEventListener(MouseEvent.CLICK, handleButtonCancelClick, false, 0, true);
				_btnCancel.title.text = "Cancel";
				_btnCancel.title.mouseEnabled = false;
				_dialog.addChild(_btnCancel);
			}
			
			if ((_btnOk != null) && (_btnCancel != null)) {
				_btnCancel.x = 600;
				_btnCancel.y = 180;
				
				_btnOk.x = 725;
				_btnOk.y = 180;
			}
			
			_dialog.title.text = title;
			_dialog.message.text = message;
			
			_btnClose.addEventListener(MouseEvent.CLICK, handleButtonCancelClick, false , 0, true);
			
			_stage.addChild(_dialog);
			
			_btnOk.title.text = "OK";
		}
		
		public function Show():void {
			_dialog.visible = true;
		}
		
		public function Hide():void {
			_dialog.visible = false;
		}
		
		public function handleButtonCloseClick(e:MouseEvent):void {
			if (_closeReference != null) {
				_closeReference();
			}
		}

		public function handleButtonOkClick(e:MouseEvent):void {
			if (_okReference != null) {
				_okReference();
			}
		}
		
		public function handleButtonCancelClick(e:MouseEvent):void {
			if (_cancelReference != null) {
				_cancelReference();
			}
		}
		
		public function get isDisposed():Boolean {
			return _isDisposed;
		}
		
		public function dispose():void {
			trace("Dialog.dispose(" + _isDisposed + ")");
			if (_isDisposed) {  return; }
			
			_closeReference = null;
			_cancelReference = null;
			_okReference = null;
			
			if (_btnClose.hasEventListener(MouseEvent.CLICK)) {
				_btnClose.removeEventListener(MouseEvent.CLICK, handleButtonCloseClick);
			}
			if (_btnOk != null) {
				_btnOk.removeEventListener(MouseEvent.CLICK, handleButtonOkClick);
			}
			if (_btnCancel != null) {
				_btnCancel.removeEventListener(MouseEvent.CLICK, handleButtonCancelClick);
			}
			
			_stage.removeChild(_dialog);
			_dialog = null;
			
			_isDisposed = true;
		}
	}
}