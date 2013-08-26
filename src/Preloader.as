package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Wroah
	 */
	public class Preloader extends MovieClip 
	{
		private var bar:Sprite;
		
		public function Preloader() 
		{
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
	
           bar = new Sprite();
           bar.graphics.lineStyle(1, 0x4444ff, 1, true);
           bar.graphics.drawRect(0, 0, 100, 6);
           bar.x = stage.stageWidth / 2 - bar.width / 2;
           bar.y = stage.stageHeight / 2 - bar.height / 2;
           addChild(bar);			
			
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// TODO update loader
           bar.graphics.lineStyle(0, 0, 0);
           bar.graphics.beginFill(0x8888ff);
           bar.graphics.drawRect(1, 1, (e.bytesLoaded / e.bytesTotal) * 98 , 4);
           bar.graphics.endFill();
           trace( "loading:" + (e.bytesLoaded / e.bytesTotal) * 100 );
		 }
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
            removeChild(bar);
            bar = null;
		   
			startup();
		}
		
		private function startup():void 
		{
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}