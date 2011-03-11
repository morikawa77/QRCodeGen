﻿/*THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS ORIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THEAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHERLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS INTHE SOFTWARE.*/package maja.air{		import flash.filesystem.File;	import flash.filesystem.FileMode;	import flash.filesystem.FileStream;	import flash.events.Event;		import flash.utils.ByteArray	import flash.display.DisplayObject	import flash.events.ErrorEvent;	import flash.events.EventDispatcher	import flash.display.BitmapData;		import com.adobe.images.JPGEncoder	import com.adobe.images.PNGEncoder		/**	 * SaveToBitmap Class	 * @copy 2009 http://www.fmajakovskij.info	 * @author Majakovskij	 * @see http://www.fmajakovskij.info	 * @langversion ActionScript 3.0	 * @playerversion Air 1.5+	 * 	 * @example	 * <listing version="3.0">	 *      import maja.air.SaveToBitmap	 *      	 *      var save:SaveToBitmap = new SaveToBitmap( myDisplayObject )	 * 			 *      // defaut format: jpg, you can change by using:	 * 		save.format = SaveToBitmap.PNG	 * 			 *		// only for jpg, you can set the quality of the compression (0-100) default: 100			 *      save.jpgQuality = 80 	 * 			 * </listing>     * 	 * <p>	 * The SaveToBitmap class allow you to save to bitmap file on your file system from any drawable DisplayObject	 * </p>	 *	 * <p>Dependencies: JPGEncoder and PNGEncoder from AS3coreLib from Adobe</p>	 * @see http://code.google.com/p/as3corelib/	 *	 * <code>Source code licensed under a Creative Commons Attribution-Share Alike 3.0 License.	 * http://creativecommons.org/licenses/by-sa/3.0/	 * Some Rights Reserved.</code>	 */	public class SaveToBitmap extends EventDispatcher	{				public static const PNG:String = "png"		public static const JPG:String = "jpg"				public var format:String = "jpg"		public var jpgQuality:int = 100				// the displayobject to be saved		private var _doToSave:*				public function SaveToBitmap(_do:*)		{			_doToSave = _do			if(_doToSave) selectDestination()		}						// prompt the dialogue box for destination		private function selectDestination()		{			//trace("Select destination for saving")			var desktop:File = File.desktopDirectory			try			{				desktop.browseForSave("Save As");				desktop.addEventListener(Event.SELECT, saveData);			}			catch (e:Error)			{				trace("[SaveToBitmap] Failed on selectDestination: "+e.message)			}		}								// save the bytearray to file		private function saveData(e:Event):void 		{			var file:File = e.target as File;						//trace("Saving the file: "+file.name)						// check the extension provided by the user			// we have to be sure it'll be the correct extension			var _extension:String = format						var len:int = (file.extension != null) ? file.extension.length : 0;			if(len)			{				file.nativePath = file.nativePath.substr(0,file.nativePath.length-len) + _extension; 			}else{				file.nativePath += "." + _extension;				}						if(file.exists)			{				trace("[SaveToBitmap] file already exists")				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR))				return			}						try			{				var bmd:BitmapData = new BitmapData( _doToSave.width, _doToSave.height, true)				bmd.draw(_doToSave)								var ba:ByteArray				if(format==JPG)				{					var jpg:JPGEncoder = new JPGEncoder( jpgQuality );					ba = jpg.encode( bmd );				}else{					ba = PNGEncoder.encode( bmd );				}				var stream:FileStream = new FileStream();				stream.open(file, FileMode.WRITE);				stream.writeBytes(ba);				stream.close();								dispatchEvent(new Event(Event.COMPLETE))								//trace("file saved: "+file.url)							}catch(e:Error){				trace("[SaveToBitmap] Failed on saveData: "+e.message)				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR))			}					}								}	}