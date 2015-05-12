package;

import com.terry.*;
import gamecontrol.*;
import config.*;
import openfl.display.*;

class InputLogic {
	public static var temp:Int;
	public static var tw:Int;
	public static var th:Int;
	
	public static function updateinput() {
		if (Elizascript.shake > 0) Elizascript.shake--;
		
		Elizascript.slowsine++;
		if (Elizascript.slowsine >= 96) Elizascript.slowsine = 0;
		
		if (Elizascript.showcredits) {				
			if (Key.justpressed_map) {
				Elizascript.showcredits = false;
				Elizascript.ready = true;
				Flag.settrue("start");
				Elizascript.processscript("");
				Flag.setfalse("start");
			}
		}else{
			if (Elizascript.typedelay > 0) {
				Elizascript.typedelay--;
				if (Elizascript.typedelay <= 0) {
					Elizascript.giveanswer();
				}
			}
			
			if (Elizascript.ready && Elizascript.acceptinginput) {
				if (Elizascript.presskey) {
					if (Key.justpressed_map) {
						Elizascript.presskey = false;
						Elizascript.inittext("");
						Elizascript.processscript("");
					}
				}else{
					if (Elizascript.waitfortext) {
						if (!Elizascript.finishtext) {
							Elizascript.gettext();
						}
					}
				}
			}
		}
	}
}