package;

import com.terry.*;
import gamecontrol.*;
import config.*;

class Render {
	public static var temp:Int; 
	public static var tx:Int;
	public static var ty:Int;
	public static var tw:Int;
	public static var th:Int;
	public static var tchar:String;
	
	public static function drawbutton(x:Int, y:Int, w:Int, h:Int, title:String, active:Bool):Void {
		if (active) {
			Gfx.fillrect(x + 2, y + 1, w - 4, h - 1, 0x42c7ff);
		}else {
			//Gfx.fillrect(x + 2, y + 3, w - 4, h - 3, 0x2191ff);
			Gfx.fillrect(x + 2, y + 1, w - 4, h - 1, 0x2191ff);
		}
		
		Text.changesize(22);
		if (active) {
			Text.print(x + 5, y - 2, title.toUpperCase(), 0xffffff);
		}else{
			//Text.print(x + 5, y + 1, title.toUpperCase(), 0xa1f9ff);
			Text.print(x + 5, y - 2, title.toUpperCase(), 0xa1f9ff);
		}
	}
	
	public static function updaterender() {
		Gfx.fillrect(0, 0, Gfx.screenwidth, Elizascript.lineheight, 0xff81c5);
		
		Gfx.fillrect(0, 0, Gfx.screenwidth, Gfx.screenheight, Elizascript.backgroundcol);
		if (Elizascript.showcredits) {
			if (Elizascript.halfsize) {
				Text.changesize(48);
				Text.print(Gfx.CENTER, 20, Elizascript.title, Elizascript.playercol);
				
				Text.changesize(22);
				
				Text.print(Gfx.CENTER, 76, "by " + Elizascript.author, Elizascript.playercol);
				Text.print(Gfx.CENTER, 206, "[PRESS ENTER TO LOGIN]", Elizascript.playercol);
			}else{
				Text.changesize(48);
				Text.print(Gfx.CENTER, 190, Elizascript.title, Elizascript.playercol);
				
				Text.changesize(22);
				
				Text.print(Gfx.CENTER, 246, "by " + Elizascript.author, Elizascript.playercol);
				Text.print(Gfx.CENTER, 446, "[PRESS ENTER TO LOGIN]", Elizascript.playercol);
			}
		}else{
			drawchatbot();
		}
		
		if (Elizascript.shake > 0) {
			Elizascript.doshake();
		}
	}
	
	public static function drawchatbot(yoffset:Int = 0, showcursor:Bool = true):Void {
		Text.changesize(22);
		if (Elizascript.halfsize) {
			Elizascript.textposition = Elizascript.terminaltext.length - (11 - yoffset);
		}else {
			Elizascript.textposition = Elizascript.terminaltext.length - (24 - yoffset);
		}
		if (Elizascript.textposition < 0) Elizascript.textposition = 0;
		
		for (i in Elizascript.textposition ... Elizascript.terminaltext.length) {
			//if (Elizascript.terminaltextperson[i] != "") {
			//	Text.rprint(24, (i - Elizascript.textposition + yoffset) * Elizascript.lineheight, ">", Elizascript.terminalcol[i]);
			//}
			//Draw.terminalprint(Game.terminaltextperson[i].length + 3, i-Game.textposition, Game.terminaltext[i], Game.terminalcol[i]);
			Text.print(12, (i - Elizascript.textposition + yoffset) * Elizascript.lineheight, Elizascript.terminaltext[i], Elizascript.terminalcol[i]);
		}
		if(showcursor){
			//Draw cursor!
			if(Elizascript.acceptinginput){
				if (Elizascript.ready) {
					if(!Elizascript.presskey) {
						if(Elizascript.showcursor){
							Text.rprint(10, (Elizascript.terminaltext.length - Elizascript.textposition + yoffset) * Elizascript.lineheight, Elizascript.enteredname + ">", Elizascript.playercol);
						}
						if (Help.slowsine % 32 >= 16) {
							Text.print(12, (Elizascript.terminaltext.length - Elizascript.textposition + yoffset) * Elizascript.lineheight, Elizascript.textfield + "_", Elizascript.playercol);
						}else {
							Text.print(12, (Elizascript.terminaltext.length - Elizascript.textposition + yoffset) * Elizascript.lineheight, Elizascript.textfield, Elizascript.playercol);
						}
					}
				}
			}
		}
		
		if (Elizascript.typedelay > 0) {
		  Text.changesize(16);	
			if (Elizascript.botname != "") {
				if (Help.slowsine < 16) {
					Text.rprint(Gfx.screenwidth - 5, Gfx.screenheight - 25, "[" + Elizascript.botname + " is typing.  ]", Elizascript.elizacol);
				}else if (Help.slowsine < 32) {
					Text.rprint(Gfx.screenwidth - 5, Gfx.screenheight - 25, "[" + Elizascript.botname + " is typing.. ]", Elizascript.elizacol);
				}else if (Help.slowsine < 48) {
					Text.rprint(Gfx.screenwidth - 5, Gfx.screenheight - 25, "[" + Elizascript.botname + " is typing...]", Elizascript.elizacol);
				}else{
					Text.rprint(Gfx.screenwidth - 5, Gfx.screenheight - 25, "[" + Elizascript.botname + " is typing   ]", Elizascript.elizacol);
				}
			}else {
				if (Help.slowsine < 16) {
					Text.rprint(Gfx.screenwidth - 5, Gfx.screenheight - 25, "[Typing.  ]", Elizascript.elizacol);
				}else if (Help.slowsine < 32) {
					Text.rprint(Gfx.screenwidth - 5, Gfx.screenheight - 25, "[Typing.. ]", Elizascript.elizacol);
				}else if (Help.slowsine < 48) {
					Text.rprint(Gfx.screenwidth - 5, Gfx.screenheight - 25, "[Typing...]", Elizascript.elizacol);
				}else{
					Text.rprint(Gfx.screenwidth - 5, Gfx.screenheight - 25, "[Typing   ]", Elizascript.elizacol);
				}
			}
		}
		
		drawborder();
	}
	
	public static var borderr:Int;
	public static var borderg:Int;
	public static var borderb:Int;
	
	public static function drawborder():Void {
		borderr = Gfx.getred(Elizascript.backgroundcol);
		borderg = Gfx.getgreen(Elizascript.backgroundcol);
		borderb = Gfx.getblue(Elizascript.backgroundcol);
		
		if (borderr < 128 && borderg < 128 && borderb < 128) {
			//Light border
			if (borderr == 0 && borderg == 0 && borderb == 0) {
				borderr = 32;
				borderg = 32;
				borderb = 32;
			}else {
				borderr = Std.int(borderr * 1.2);
				borderg = Std.int(borderg * 1.2);
				borderb = Std.int(borderb * 1.2);
			}
		}else {
			//Dark border
			borderr = Std.int(borderr * 0.8);
			borderg = Std.int(borderg * 0.8);
			borderb = Std.int(borderb * 0.8);
		}
		
		Gfx.fillrect(0, 0, Gfx.screenwidth, 1, Gfx.RGB(borderr, borderg, borderb));
		Gfx.fillrect(0, Gfx.screenheight-1, Gfx.screenwidth, 1, Gfx.RGB(borderr, borderg, borderb));
		Gfx.fillrect(0, 0, 1, Gfx.screenheight, Gfx.RGB(borderr, borderg, borderb));
		Gfx.fillrect(Gfx.screenwidth-1, 0, 1, Gfx.screenheight, Gfx.RGB(borderr, borderg, borderb));
		
	}
	
	
	public static function outoffocus():Void {
		Gfx.fillrect(0, 0, Gfx.screenwidth, Gfx.screenheight, Elizascript.backgroundcol);
		drawchatbot(0, false);
		if(!Elizascript.dualmode){
			Gfx.drawimage(0, 0, "tint");
		}
		
		if (Elizascript.shake > 0) {
			Elizascript.doshake();
		}
	}
}