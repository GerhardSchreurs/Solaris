package Crew {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.*;
	import Ship.Node;
	
	public class ICrew extends Sprite {
		private var _ID:Number;
		private var _crewName:String;
		private var _crewLayout:MovieClip;
		private var _crewPortrait:MovieClip;
		private var _glowFilter:GlowFilter;
		private var _node:Node;
		
		public function ICrew() {
			_glowFilter = new GlowFilter();
		}
		
		public function get ID():Number {
			return _ID;
		}
		
		public function set ID(value:Number):void {
			_ID = value;
		}
		
		public function get node():Node {
			return _node;
		}
		
		public function set node(value:Node):void {
			_node = value;
		}
		
		public function get crewName():String {
			return _crewName;
		}
		
		public function set crewName(value:String):void {
			_crewName = value;
		}
		
		public function get crewLayout():MovieClip {
			return _crewLayout;
		}
		
		public function set crewLayout(value:MovieClip):void {
			this._crewLayout = value;
		}
		
		public function get crewPortrait():MovieClip {
			return _crewPortrait;
		}
		
		public function selectMember():void {
			//var myGlow:GlowFilter = new GlowFilter();
			//my_mc.filters = [myBlur, myGlow];
			
			this._crewLayout.filters = [_glowFilter];
		}
		
		public function deselectMember():void {
			this._crewLayout.filters = [];
		}
		
		public function set crewPortrait(value:MovieClip):void {
			this._crewPortrait = value;
			
			_crewPortrait.width = 40;
			_crewPortrait.height = 40;
			_crewPortrait.x = 3;
			_crewPortrait.y = 3;
		}
	}
}