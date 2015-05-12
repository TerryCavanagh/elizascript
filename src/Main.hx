/** Elizascript - Terry Cavanagh 2015.  

The Elizascript site has three SWF files on it: 
 - The regular chat swf, which is on the chat.html page.
 - The "dualing swf", which doesn't take input and is for having two scripts dual.
 - The editor swf, which is half size and is on the index page.
 
To make the regular chat swf, make no changes to this source.

To make the dualing swf, change "dualmode" at the bottom of Elizascript.hx to TRUE.

To make the editor swf, change "halfsize" at the bottom of Elizascript.hx to TRUE, and
  change the window resolution to 768x240 in the project.xml file, also in Preloader.hx,
	change screenheight and stageheight to half their values.
	
*/


package;

import openfl.display.*;
import com.terry.*;
import openfl.external.ExternalInterface;
import openfl.errors.Error;
import openfl.display.LoaderInfo;

class Main extends Sprite {
	public function new () {
		super();
		
		Key.init(this.stage);
		Mouse.init(this.stage);
		Gfx.init(this.stage);
		Music.init();
		
		Elizascript.init(this.stage);
		
		Coreloop.init(this.stage);
		
		var url:String = "";	
		try {
		  if (!localmode()) {
					url = ExternalInterface.call("window.location.href.toString");				
			}
		}
		catch (e:Error) {
			url = "";
		}
		
		Init.init(url);
	}
	
	public function localmode():Bool {
		return (loaderInfo.url.indexOf("file://") >= 0);
	}
}