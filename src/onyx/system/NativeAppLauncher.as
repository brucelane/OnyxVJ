package onyx.system {
	import flash.desktop.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.*;
	import flash.system.Capabilities;
	
	import onyx.core.Console;
	
	public class NativeAppLauncher implements IEventDispatcher
	{
		private var dispatcher:EventDispatcher;
		private var nativeProcess:NativeProcess;
		private var pathToExe:String;
		private var receivedText:String = '';
		private var commandText:String = '';
		private var isExeValid:Boolean = false;
		private var file:File;

		public function NativeAppLauncher(exeFilename:String) 
		{
			dispatcher = new EventDispatcher(this);
			pathToExe = exeFilename;
			if (NativeProcess.isSupported)
			{
				checkExe();
			}
			else
			{
				Console.output("NativeProcess not supported.");
			}
		}
		public function checkExe():void
		{	 
			var folder:File = File.documentsDirectory.resolvePath( 'native' );
			var folderPath:String = folder.nativePath.toString();
			// creates folder if it does not exists
			if (!folder.exists) 
			{
				Console.output('Creating folder: ' + folderPath);
				// create the directory
				folder.createDirectory();
			}
			
			file = File.documentsDirectory.resolvePath( 'native' + File.separator + pathToExe );
			
			if( file.exists )
			{
				isExeValid = true;
			}
			
		}
		public function launchExe():void
		{	 	
			if ( isExeValid )
			{
				var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
				nativeProcessStartupInfo.executable = file;
				
				nativeProcess = new NativeProcess();
				nativeProcess.start(nativeProcessStartupInfo);
				
				nativeProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
				nativeProcess.addEventListener(ProgressEvent.STANDARD_INPUT_PROGRESS, inputProgressListener);
				nativeProcess.addEventListener(NativeProcessExitEvent.EXIT, onExit);
				nativeProcess.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
				nativeProcess.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
				dispatchEvent( new Event(Event.ACTIVATE) );
			}
		}
		public function writeData(text:String):void
		{
			if (nativeProcess && nativeProcess.running)
			{
				nativeProcess.standardInput.writeUTFBytes(text + "\n");
			}
			else
			{
				Console.output(pathToExe + " is not running");
			}
			
		}
		public function inputProgressListener(event:ProgressEvent):void
		{
			//Console.output("inputProgressListener");
			//nativeProcess.closeInput();
		}
		public function onOutputData(event:ProgressEvent):void
		{
			receivedText = nativeProcess.standardOutput.readUTFBytes(nativeProcess.standardOutput.bytesAvailable);
			Console.output(receivedText);
			 
			if ( receivedText.indexOf('!') > -1)
			{
				commandText = receivedText.substr(1);
				dispatchEvent( new Event(Event.CHANGE) );				
			}
			else
			{
				/*commandText = receivedText;
				dispatchEvent( new Event(Event.CHANGE) );*/
			}
		}
		
		public function readAppOutput():String
		{
			return commandText;
		}
		public function onExit(event:NativeProcessExitEvent):void
		{
			dispatchEvent( new Event(Event.CLOSE) );
			Console.output("Process exited with " + event.exitCode);
		}
		
		public function onIOError(event:IOErrorEvent):void
		{
			Console.output(event.toString());
		}
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority);
		}
		
		public function dispatchEvent(evt:Event):Boolean
		{
			return dispatcher.dispatchEvent(evt);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean 
		{
			return dispatcher.willTrigger(type);
		}
	}
}