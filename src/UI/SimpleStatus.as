package UI {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class SimpleStatus extends ComponentBase {
		private var _icon:Sprite;
		private var _textFormat:TextFormat;
		private var _textField:TextField;
		
		public function set text(value:String):void {
			_textField.text = value;
		}

		public function SimpleStatus() {
			//Create our square
			
			var square:Shape = new Shape();
			square.graphics.lineStyle(1, 0xFFFFFF);
			square.graphics.drawRect(0, 0, 59, 29); 
			square.graphics.endFill();
			
			addChild(square);
			
			_textFormat = new TextFormat();
			_textFormat.font = "Good Times"
			_textFormat.size = 12;
			_textFormat.color = 0xFFFFFF;
			
			_textField = new TextField();
			_textField.defaultTextFormat = _textFormat;
			_textField.embedFonts = true;
			_textField.selectable = false;
			_textField.x = 28;
			_textField.y = 8;
		
			addChild(_textField);
		}
		
		public function rerender():void {
		}
		
		override protected function init():void {

		}

		public function set icon(value:Sprite):void {
			_icon = value;
			
			_icon.x = 15 - (_icon.width / 2);
			_icon.y = 15 - (_icon.height / 2);

			addChild(_icon);
		}
	}
}