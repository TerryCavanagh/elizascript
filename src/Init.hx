package;

import openfl.display.*;
import openfl.Assets;
import com.terry.*;

class Init {
	public static function init(url:String):Void {
		if (Elizascript.halfsize) {
			Gfx.createscreen(768, 240, 1);
		}else{
			Gfx.createscreen(768, 480, 1);
		}
		Gfx.updategraphicsmode();
		
		Gfx.addimage("tint", "data/graphics/tint.png");
		
		//Sound effects!
		Music.addeffect("01type.mp3");
		Music.addeffect("02online.mp3");
		Music.addeffect("03newemail.mp3");
		Music.addeffect("04newalert.mp3");
		Music.addeffect("05nudge.mp3");
		Music.addeffect("06vimdone.mp3");
		Music.addeffect("07ring.mp3");
		Music.addeffect("08knpmsg.mp3");
		Music.addeffect("BABELEPH.mp3");
		Music.addeffect("BABYCRY4.mp3");
		Music.addeffect("BEE.mp3");
		Music.addeffect("BELCH1.mp3");
		Music.addeffect("BELCH2.mp3");
		Music.addeffect("BIRD2.mp3");
		Music.addeffect("BLAHST.mp3");
		Music.addeffect("COUGHFEM.mp3");
		Music.addeffect("CROW2.mp3");
		Music.addeffect("DOGBARK2.mp3");
		Music.addeffect("EEK.mp3");
		Music.addeffect("EXERT1.mp3");
		Music.addeffect("EXERT2.mp3");
		Music.addeffect("G'BYE.mp3");
		Music.addeffect("GAMEON.mp3");
		Music.addeffect("GOTLUCKY.mp3");
		Music.addeffect("HEART1.mp3");
		Music.addeffect("HELP.mp3");
		Music.addeffect("HICCUP.mp3");
		Music.addeffect("KISSMACK.mp3");
		Music.addeffect("KISSMALE.mp3");
		Music.addeffect("KOFF.mp3");
		Music.addeffect("LAUGHHI.mp3");
		Music.addeffect("LAUGHING.mp3");
		Music.addeffect("NGH.mp3");
		Music.addeffect("NYAAH.mp3");
		Music.addeffect("NYUUAH.mp3");
		Music.addeffect("OH.mp3");
		Music.addeffect("OH2.mp3");
		Music.addeffect("OHFEMALE.mp3");
		Music.addeffect("OHMALE.mp3");
		Music.addeffect("OOH.mp3");
		Music.addeffect("OOOH.mp3");
		Music.addeffect("ORF.mp3");
		Music.addeffect("OUCH.mp3");
		Music.addeffect("PARROT.mp3");
		Music.addeffect("POOT1.mp3");
		Music.addeffect("PULSE.mp3");
		Music.addeffect("QUACK1.mp3");
		Music.addeffect("RASPERRY.mp3");
		Music.addeffect("RUDE.mp3");
		Music.addeffect("SCREAMM1.mp3");
		Music.addeffect("SCREECH.mp3");
		Music.addeffect("SIGH.mp3");
		Music.addeffect("SIRENWOW.mp3");
		Music.addeffect("SNEEZE.mp3");
		Music.addeffect("SPIT.mp3");
		Music.addeffect("TSKTSK.mp3");
		Music.addeffect("UH-OH1.mp3");
		Music.addeffect("UHOH.mp3");
		Music.addeffect("VOICEHI.mp3");
		Music.addeffect("WARBLELO.mp3");
		Music.addeffect("WHISTLE.mp3");
		Music.addeffect("WHISTLE1.mp3");
		Music.addeffect("WHOA.mp3");
		Music.addeffect("WHOOPS.mp3");
		Music.addeffect("YEARGH.mp3");
		Music.addeffect("YO.mp3");
		Music.addeffect("YOULOSE.mp3");
		
		//Load resources
		Text.addfont("dos");
		Text.cachefont("dos", 16, 22, 48);
		Text.changesize(22);
		
		//Elizascript.loadfile();
		Elizascript.addline("CONNECTING ...", "eliza");
		Elizascript.addline("", "intro");
		Elizascript.inittext("");
		
		if (Help.isinstring(url, "elizascript.net")) {
			Elizascript.initfromgithub();
		}else {
			Elizascript.loadfile();
		}
		
		Gfx.buffer = new BitmapData(Gfx.screenwidth, Gfx.screenheight, false, 0x000000);
		
		
		//Start the game
		Coreloop.setupgametimer();
	}
}