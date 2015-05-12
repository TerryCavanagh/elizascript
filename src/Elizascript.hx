package;

import openfl.geom.*;
import openfl.display.*;
import openfl.text.*;
import com.terry.*;
import openfl.events.*;
import openfl.net.*;
import openfl.external.ExternalInterface;

class Elizascript {
	public static function init(swfstage:Stage):Void {
		enabletextfield(swfstage);
		
		for (i in 0...1000) {
			possibleresponse.push(new String(""));
			possibleresponse_branch.push(new String(""));
		}
		currentbranch = "none";
		numresponses = 0;
		
		currenttab = 0;
		slowsine = 0;
		
		ready = false;
	}
	
	public static function inittext(t:String):Void {
		#if flash
		inputField.text = t; textfield = t;	waitfortext = true;
		#else
		inputField.text = Help.reversetext(t); textfield = Help.reversetext(t);	waitfortext = true;
		#end
	}
	
	public static function enabletextfield(swfstage:Stage):Void {
		gamestage = swfstage;
		swfstage.addChild(inputField);
		inputField.border = true;
		inputField.width = 600;
		inputField.height = 20;
		inputField.x = 5;
		inputField.y = Gfx.screenheight + 10;
		inputField.type = TextFieldType.INPUT;
		inputField.visible = false;
		
		inputField.maxChars = 58;
		//inputField.restrict = null; //Not in haxe I guess?
	}
	
	
	public static function gettext():Void {
		gamestage.focus = inputField;
		#if flash
		inputField.setSelection(inputField.text.length, inputField.text.length);
		#else
		inputField.setSelection(inputField.text.length, inputField.text.length);
		#end
		inputField.text = Help.Left(inputField.text, 58);
		if (dualmode) {
			
		}else{
			textfield = inputField.text;
		}
		
		if (Key.justpressed_map && textfield != "") {
			if (typedelay <= 0) {
				entertext();
			}
		}
	}
	
	public static function gettext_clear():Void {
		gamestage.focus = inputField;
		#if flash
		inputField.setSelection(inputField.text.length, inputField.text.length);
		#else
		inputField.setSelection(inputField.text.length, inputField.text.length);
		#end
		inputField.text = Help.Left(inputField.text, 58);
		textfield = inputField.text;
	}
	
	public static function entertext():Void {
		lastentry = Help.Left(textfield, 58);
		textfield = "";
		inputField.text = "";
		finishtext = true;
		
		finishtext = false; waitfortext = false;
		
		addline(lastentry);
		
		//respond(lastentry);
		addline("", "intro");
		processscript(lastentry);
		inittext("");
	}
	
	public static function getlinelength(line:Int):Int {
		if (rawscript.length > 0) {
			if (line >= 0 && line < rawscript.length) return rawscript[line].length;
		}
		return 0;
	}
	
	public static function addline(t:String, person:String = "you"):Void {
		var col:Int;
		if (person == "eliza") {
			person = "eliza";
			//t = t.toUpperCase();
			col = elizacol;
		}else if (person == "eliza2") {
			person = "";
			//t = t.toUpperCase();
			col = elizacol;
		}else if (person == "intro") {
			person = "";
			//t = t.toUpperCase();
			col = elizacol;
		}else if (person == "error") {
			person = "";
			col = elizacol;
		}else {
			col = playercol;
			person = enteredname;
		}
		
		Text.changesize(22);
		if (Text.len(t) > Gfx.screenwidth - 20) {
			stringbreak = ""; stringbreakcounter = 0; stringbreakline = 0;
			
			while (stringbreakcounter < t.length) {
				stringbreak += Help.Mid(t, stringbreakcounter);
				//if (len(stringbreak) >= 280) {
				if (Text.len(stringbreak) >= Gfx.screenwidth - 20) {
					//Ok: stringbreak now contains a chunk of a sentance.
					//We need to work back and find the last space in this, then readjust everything.
					while (Help.Mid(stringbreak, stringbreak.length-1) != " ") {
						stringbreak = Help.Mid(stringbreak, 0, stringbreak.length - 1);
						stringbreakcounter--;
					}
					if(stringbreakline==0){
						terminaltext.push(stringbreak);
						terminaltextperson.push("eliza");
						terminalcol.push(col);
					}else {
						terminaltext.push(stringbreak);
						terminaltextperson.push("");
						terminalcol.push(col);
					}
					stringbreakline++;
					stringbreak = "";
				}
				stringbreakcounter++;
			}
			
			//Anything leftover?
			if (stringbreak.length > 0) {
				terminaltext.push(stringbreak);
				terminaltextperson.push("");
				terminalcol.push(col);
				stringbreakline++;
				stringbreak = "";
			}
		}else{
			terminalcol.push(col);
			terminaltextperson.push(person);
			terminaltext.push(t);
		}
	}
	
	
	public static function printerror():Void {		
		elizacol = 0xFF8888;
		backgroundcol = 0x440000;
		hexelizacol = "FF8888";
		hexbackgroundcol = "440000";
			
		addline("", "intro");
		if(errorline!= -1){
			addline("ERROR ON LINE " + Std.string(errorline+1) +":", "intro");	
		}else {
			addline("ERROR:", "intro");	
		}
		elizacol = 0xFF4444;
		hexelizacol = "FF4444";
		addline(errorstring, "error");
		addline("", "intro");
	}
	
	public static function countchar(t:String):Int {
		var c:Int = 0;
		for (i in 0 ... rawscript.length) {
			if (Help.Instr(rawscript[i], t) != -1) c++;
		}
		return c;
	}
	
	public static function checkforerrors():Bool {
		//Read through the script and catch obvious errors before they come up.
		var errorfound:Bool = false;
		for (i in 0 ... rawscript.length) {
			/*
			if (Help.Instr(rawscript[i], "\"") != -1) {
				if (Help.Left(Help.trimspaces(rawscript[i])) != "\"") {
					errorline = i;
					errorstring = "Chatbox response can't contain the character \".";
					printerror();
					errorfound = true;
				}
			}
			*/
		}
		
		if (countchar("{") != countchar("}")) {
			errorline = -1;
			errorstring = "{ and } brackets don't match up! Have you forgotten a bracket somewhere?";
			printerror();
			errorfound = true;
		}
		
		return errorfound;
	}
	
	public static function makecleanscript():Void {
		//Take rawscript, and make a clean formatted version I can process easier.
		cleanscript = new Array<String>();
		
		for (i in 0 ... rawscript.length) {
			workingstring = removecomments(rawscript[i]);
			workingstring = Help.trimspaces(workingstring);
			tempstring1 = "";
			for (j in 0 ... workingstring.length) {
				tempstring2 = Help.Mid(workingstring, j);
			  if (tempstring2 == "{") {
					//Push everything in tempstring1 to the line and start a new line
					if(!Help.isblankstring(tempstring1)) cleanscript.push(tempstring1);
					cleanscript.push("{");
					tempstring1 = "";
				}else if (tempstring2 == "}") {
					//Push everything in tempstring1 to the line and start a new line
					if(!Help.isblankstring(tempstring1)) cleanscript.push(tempstring1);
					cleanscript.push("}");
					tempstring1 = "";
			  }else {
					tempstring1 = tempstring1 + tempstring2;
				}
			}
			
			tempstring1 = Help.trimspaces(tempstring1);
			if(!Help.isblankstring(tempstring1)) cleanscript.push(tempstring1);
		}
		
		if(debugscript){
			trace("Clean script:");
			trace("=-=-=-=-=-=-=-=-=-=-=-=-=-");
			for (i in 0 ... cleanscript.length) {
				trace(Std.string(i) + " " + cleanscript[i]);
			}
		}
	}
	
	public static function resetchatbot():Void {
		terminaltext = new Array<String>();
		terminaltextperson = new Array<String>();
		terminalcol = new Array<Int>();
		//elizacol = 0x11fff9;
	  //playercol = 0x00BBB2;
		//backgroundcol = 0x000000;
		Flag.resetflags();
		elizacol = 0x0000BB;
	  playercol = 0x000000;
		backgroundcol = 0xFFFFFF;
		hexelizacol = "0000BB";
		hexplayercol = "000000";
		hexbackgroundcol = "FFFFFF";
		acceptinginput = true;
		currentbracketlevel = 0;
		currentbranch = "none";
		numresponses = 0;
		botname = "";
		showbotname = false;
		firstresponse = true;
		nextsound = -1;
		chatsound = -1;
		endscreen = false;
		title = "";
		author = "";
		website = "";
		showcredits = false;
		fallback = false;
		typespeed = 0;
		if (dualmode) {
			typespeed = 6;
		}
		
		showcursor = false;
		skipresponse = false;
		presskey = false;
		doclear = false;
		
		makecleanscript();
		
		if (checkforerrors()) {
			acceptinginput = false;
		}else {
			Flag.resetflags();
			scriptstart = 0; scriptend = cleanscript.length;
			processtags();
		}
	}
	
	public static function removecomments(t:String):String {
		//Remove comments
		temp = Help.Instr(t, "//");
		if (temp > -1){
		  t = Help.Left(t, temp);
		}
		return t;
	}
	
	public static function cleanstring(t:String):String {
		//Process a script string, if there's anything interesting, extract it!
		t = removecomments(t);
		
		//Check for brackets
		t = Help.replacechar(t, "{", "");
		t = Help.replacechar(t, "}", "");
		
		t = Help.trimspaces(t);
		return t;
	}
	
	public static function isbranch(t:Int):Bool {
		//True if the current line is the head of a branch
		t++;
		if (t < cleanscript.length) {
			if (Help.Instr(cleanscript[t], "{") > -1) {
				return true;
			}
		}
		return false;
	}
	
	public static function findscriptend(t:Int):Int {
		//Ok: we're starting at line t.
		//return the last line of the script based on a closing bracket
		temp = 1;
		for (i in t ... cleanscript.length) {
			if (Help.Instr(cleanscript[i], "{") > -1) temp++;
			if (Help.Instr(cleanscript[i], "}") > -1) temp--;
			if (temp == 0) return i;
		}
		return t;
	}
	
	public static function processscript(response:String, alreadyresponded:Bool = false):Void {
		//Read through the script, and decide what to say!
		if(debugscript) trace("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-");
		if(debugscript) trace("In Processscript: response string is " + response);
		response = response.toLowerCase();
		numresponses = 0;
		currentbracketlevel = 0; scriptbracketlevel = 0;
		donematchresponse = 0;
		if (alreadyresponded) donematchresponse = 1;
		
		//Ok: we figure out our current bracket level and branch starting points first...
		if (currentbranch == "none") {
			scriptstart = 0;
			scriptend = cleanscript.length;
		}else {
			scriptstart = Std.parseInt(currentbranch) + 2;
			scriptend = findscriptend(scriptstart);
		}
		
		if (debugscript) {
			trace("processscript status:");
			trace("Current branch" + currentbranch);
			trace("Range [" + Std.string(scriptstart) + " - " + Std.string(scriptend) + "]");
			trace("Bracket levels [Current:" + Std.string(currentbracketlevel) + "] - [Script:" + Std.string(scriptbracketlevel) + "]");
		}
		
		/*
		if (currentbranch == "77") {
			trace("stepping in...");
		}
		*/
		
		for (i in scriptstart ... scriptend) {
			workingstringtype = 0;
			workingstring = cleanscript[i];
			
			if(scriptbracketlevel <= currentbracketlevel){
				if (Help.Left(workingstring, 1) == "\"") {
					if(debugscript) trace("Line " + Std.string(i) + ": Checking for response matches...");
					workingstringtype = 1;
					if (donematchresponse == 0) {
						//Break this string down into a list of answers to match against!
						answerlist = workingstring.split(",");
						for (j in 0 ... answerlist.length) {
							if (donematchresponse == 0) {
								answerlist[j] = Help.replacechar(answerlist[j], "\"", "");
								answerlist[j] = Help.trimspaces(answerlist[j]);
								answerlist[j] = answerlist[j].toLowerCase();
								
								if (Help.isinstring(response, answerlist[j]) && response != "") {
									//Ok, we've got a match. We chuck out all possible responses 
									//so far and change branch.
									if(debugscript) trace("Line " + Std.string(i) + ": Found a match in " + workingstring + ". Starting again!");
									currentbranch = Std.string(i);
									processscript("", true);
									return;
								}
							}
						}
						if(debugscript) trace("Line " + Std.string(i) + ": Checked " + workingstring + " for a response match but didn't find one.");
					}
				}else if (Help.Left(workingstring, 1) == "[") {
					if(debugscript) trace("Line " + Std.string(i) + ": Checking for flag matches...");
					workingstringtype = 2;
					var flagmatch:Bool = false; //Just for debugging, can delete later
					//Break this string down into a list of flags to match against!
					answerlist = workingstring.split(",");
					for (j in 0 ... answerlist.length) {
						answerlist[j] = Help.replacechar(answerlist[j], "[", "");
						answerlist[j] = Help.replacechar(answerlist[j], "]", "");
						answerlist[j] = Help.trimspaces(answerlist[j]);
						answerlist[j] = answerlist[j].toLowerCase();
						
						if (Help.Left(answerlist[j], 1) == "!") {
							if (Flag.isfalse(Help.Right(answerlist[j], answerlist[j].length - 1)) && answerlist[j] != "") {
								if(debugscript) trace("Line " + Std.string(i) + ": Found a flag match in " + workingstring + ". Including!");
								currentbracketlevel++;
								flagmatch = true;
							}
						}else{
							if (Flag.istrue(answerlist[j]) && answerlist[j] != "") {
								if(debugscript) trace("Line " + Std.string(i) + ": Found a flag match in " + workingstring + ". Including!");
								currentbracketlevel++;
								flagmatch = true;
							}
						}
					}
					if(debugscript) if (!flagmatch) trace("Line " + Std.string(i) + ": Checked " + workingstring + " for a flag match but didn't find one.");
				}
			}
			
			workingstring = Help.trimspaces(workingstring);
			
			if (Help.Instr(workingstring, "{") > -1) {
				workingstringtype = 3;
				scriptbracketlevel++;
				if(debugscript) trace("Line " + Std.string(i) + ": Bracket levels [Current:" + Std.string(currentbracketlevel) + "] - [Script:" + Std.string(scriptbracketlevel) + "]");
			}
			
			if (Help.Instr(workingstring, "}") > -1) {
				workingstringtype = 3;
			}
			
			if (workingstringtype == 0) {
				if (Help.Left(workingstring, 1) == "#") {
					//Hashtag, don't worry about it, unless:
					if (Help.isinstring(workingstring, "break")) {
						if(scriptbracketlevel <= currentbracketlevel){
							//Oh, we're done here!
							scriptend = i;
							if (debugscript) trace("# break;");
							break;
						}
					}
				}else if (isbranch(i)) {
					if(scriptbracketlevel <= currentbracketlevel){
						addresponse(workingstring, Std.string(i));
						if(debugscript) trace("Line " + Std.string(i) + ": added possible response with branch " + Std.string(i) + ": " +workingstring);
					}
				}else {
					if(scriptbracketlevel <= currentbracketlevel){
						addresponse(workingstring);
						if(debugscript) trace("Line " + Std.string(i) + ": added possible response: " + workingstring);
					}
				}
			}
			
			if (Help.Instr(workingstring, "}") > -1) {
				scriptbracketlevel--;
				if (scriptbracketlevel < currentbracketlevel) {
					currentbracketlevel--;
					if (currentbracketlevel < 0) currentbracketlevel = 0;
				}
				if(debugscript) trace("Line " + Std.string(i) + ": Bracket levels [Current:" + Std.string(currentbracketlevel) + "] - [Script:" + Std.string(scriptbracketlevel) + "]");
			}
		}
		
		processtags();
		
		if (numresponses == 0) {
			if (!fallback) {
				if(debugscript) trace("No reply found: Falling back to previous branch.");
				fallback = true; //Prevent infinite loop
				currentbranch = "none";
				processscript(response);
				return;
			}
		}
		
		doresponse();
	}
	
	public static function processtags():Void {
		//Do hashtag stuff
		if(debugscript) trace("Now processing Hashtags...");
		currentbracketlevel = 0; scriptbracketlevel = 0;
		for (i in scriptstart ... scriptend) {
			
			workingstring = cleanscript[i];
			
			if(scriptbracketlevel <= currentbracketlevel){
				if (Help.Left(workingstring, 1) == "[") {
					workingstringtype = 2;
					var flagmatch:Bool = false; //Just for debugging, can delete later
					//Break this string down into a list of flags to match against!
					answerlist = workingstring.split(",");
					for (j in 0 ... answerlist.length) {
						answerlist[j] = Help.replacechar(answerlist[j], "[", "");
						answerlist[j] = Help.replacechar(answerlist[j], "]", "");
						answerlist[j] = Help.trimspaces(answerlist[j]);
						answerlist[j] = answerlist[j].toLowerCase();
						
						if (Help.Left(answerlist[j], 1) == "!") {
							if (Flag.isfalse(Help.Right(answerlist[j], answerlist[j].length - 1)) && answerlist[j] != "") {
								if(debugscript) trace("Found a flag match in " + workingstring + ". Including!");
								currentbracketlevel++;
								flagmatch = true;
							}
						}else{
							if (Flag.istrue(answerlist[j]) && answerlist[j] != "") {
								if(debugscript) trace("Found a flag match in " + workingstring + ". Including!");
								currentbracketlevel++;
								flagmatch = true;
							}
						}
					}
					if(debugscript) if (!flagmatch) trace("Checked " + workingstring + " for a flag match but didn't find one.");
				}
			}
			
			workingstring = Help.trimspaces(workingstring);
			
			if (Help.Instr(workingstring, "{") > -1) {
				workingstringtype = 3;
				scriptbracketlevel++;
			}
			
			if (Help.Instr(workingstring, "}") > -1) {
				workingstringtype = 3;
			}
			
			if(scriptbracketlevel == currentbracketlevel){
				if (Help.Left(cleanscript[i], 1) == "#") {
					workingstring = Help.Right(cleanscript[i], cleanscript[i].length - 1);
					if (Help.isinstring(workingstring, "playercol")) {
						workingstring = Help.getvariable(workingstring, "playercol");
						hexplayercol = workingstring;
						playercol = Std.parseInt("0x" + workingstring);
						if(debugscript) trace("# Set playercol to" + hexplayercol);
					}else if (Help.isinstring(workingstring, "botcol")) {
						workingstring = Help.getvariable(workingstring, "botcol");
						hexelizacol = workingstring;
						elizacol = Std.parseInt("0x" + workingstring);
						if(debugscript) trace("# Set botcol to" + hexelizacol);
					}else if (Help.isinstring(workingstring, "backcol")) {
						workingstring = Help.getvariable(workingstring, "backcol");
						hexbackgroundcol = workingstring;
						backgroundcol = Std.parseInt("0x" + workingstring);
						if(debugscript) trace("# Set background col to" + hexbackgroundcol);
					}else if (Help.isinstring(workingstring, "typespeed")) {
						workingstring = Help.getvariable(workingstring, "typespeed");
						typespeed = Std.parseInt(workingstring);
						if(debugscript) trace("# Set typespeed to" + workingstring);
					}else if (Help.isinstring(workingstring, "botname")) {
						workingstring = Help.getvariable(workingstring, "botname");
						botname = workingstring;
						if(debugscript) trace("# Set botname to" + workingstring);
					}else if (Help.isinstring(workingstring, "showcursor")) {
						showcursor = true;
						if(debugscript) trace("# Showing cursor");
					}else if (Help.isinstring(workingstring, "hidecursor")) {
						showcursor = false;
						if(debugscript) trace("# Hiding cursor");
					}else if (Help.isinstring(workingstring, "next")) {
						skipresponse = true;
						if(debugscript) trace("# Next");
					}else if (Help.isinstring(workingstring, "presskey")) {
						presskey = true;
						if(debugscript) trace("# Waiting for keypress");
					}else if (Help.isinstring(workingstring, "cls")) {
						doclear = true;
						if(debugscript) trace("# Clearing screen");
					}else if (Help.isinstring(workingstring, "clear")) {
						doclear = true;
						if(debugscript) trace("# Clearing screen");
					}else if (Help.isinstring(workingstring, "delay")) {
						workingstring = Help.getvariable(workingstring, "delay");
						typedelay = Std.parseInt(workingstring);
						if(debugscript) trace("# Delay for " + workingstring + " frames");
					}else if (Help.isinstring(workingstring, "chatsound")) {
						workingstring = Help.getvariable(workingstring, "chatsound");
						if (Help.isNumber(workingstring)) {
							chatsound = Std.parseInt(workingstring) % Music.numeffects;
						}else{
							chatsound = 0;
						}
						
						if(debugscript) trace("# Chatsound set to " + workingstring);
					}else if (Help.isinstring(workingstring, "sound")) {
						workingstring = Help.getvariable(workingstring, "sound");
						if (Help.isNumber(workingstring)) {
							nextsound = Std.parseInt(workingstring) % Music.numeffects;
						}else{
							nextsound = 0;
						}
						if(debugscript) trace("# Sound set to " + workingstring);
					}else if (Help.isinstring(workingstring, "showname")) {
						showbotname = true;
						if(debugscript) trace("# Showing botname");
					}else if (Help.isinstring(workingstring, "hidename")) {
						showbotname = false;
						if(debugscript) trace("# Hiding botname");
					}else if (Help.isinstring(workingstring, "title")) {
						workingstring = Help.getvariable(workingstring, "title");
						title = workingstring;
						if(debugscript) trace("# Title: " + workingstring);
					}else if (Help.isinstring(workingstring, "author")) {
						workingstring = Help.getvariable(workingstring, "author");
						author = workingstring;
						if(debugscript) trace("# Author: " + workingstring);
					}else if (Help.isinstring(workingstring, "website")) {
						workingstring = Help.getvariable(workingstring, "website");
						website = workingstring;
						if(debugscript) trace("# Website: " + workingstring);
					}
				}
			}
			
			if (Help.Instr(workingstring, "}") > -1) {
				scriptbracketlevel--;
				if (scriptbracketlevel < currentbracketlevel) {
					currentbracketlevel--;
					if (currentbracketlevel < 0) currentbracketlevel = 0;
				}
			}
		}
	}
	
	public static function doresponse():Void {
		if(debugscript) trace("Do reponse called.");
		fallback = false;
		if (numresponses == 0) {
			elizacol = 0xFF8888;
			backgroundcol = 0x440000;
			
			addline("", "intro");
			addline("ERROR:", "intro");	
			
			elizacol = 0xFF4444;
			addline("No response possible to this reply.", "error");
			addline("", "intro");
			
			acceptinginput = false;
		}else {
			if (dualmode) {
				if (firstresponse) {
					firstresponse = false;
					if (chatbotnum == 1) {
						typedelay = 1;
					}else {
						typedelay = 10;
					}
				}
				if (typespeed > 0) {
					if (typedelay == 0) typedelay = (typespeed * 15) + Random.int(0, 10);
					if (skipresponse) {
						typedelay = typedelay = ((typespeed+3) * 15) + Random.int(0, 10);
					}
				}else {
					firstresponse = false;
					giveanswer();
				}
			}else{
				if (typespeed > 0 && !firstresponse) {
					if (typedelay == 0) typedelay = (typespeed * 15) + Random.int(0, 10);
					if (skipresponse) {
						typedelay = typedelay = ((typespeed+3) * 15) + Random.int(0, 10);
					}
				}else {
					firstresponse = false;
					giveanswer();
				}
			}
		}
	}
	
	/** Read string t for flags to set and unset. Return a clean string. */
	public static function setflags(t:String):String {
		temp = 0;
		tempstring1 = "";
		tempstring2 = "";
		for (i in 0 ... t.length) {
			tempstring3 = Help.Mid(t, i, 1);
			if (temp == 0) {
				//Normal string mode;
				if (tempstring3 == "[") {
				  temp = 1;
					tempstring2 = "";
				}else {
					tempstring1 += tempstring3;
				}
			}else if (temp == 1) {
				//Reading flags mode
				if (tempstring3 == "]") {
				  temp = 0;
					if (Help.Left(tempstring2, 1) == "!") {
						Flag.setfalse(Help.Right(tempstring2, tempstring2.length - 1));
					}else {
						Flag.settrue(tempstring2);
					}
					tempstring2 = "";
				}else {
					tempstring2 += tempstring3;
				}
			}
		}
		
		return tempstring1;
	}
	
	public static function giveanswer():Void {
		if (doclear) {			
			terminaltext = new Array<String>();
			terminaltextperson = new Array<String>();
			terminalcol = new Array<Int>();
			doclear = false;
		}
		
		answer = Random.int(0, numresponses - 1);
		
		tempstring1 = setflags(possibleresponse[answer]);
		if (dualmode) {
			if (!skipresponse) {
				if (dualrunning) {
					if (chatbotnum == 1) {
						if (dualfirstturn) {
							dualfirstturn = false;
						}else{
							ExternalInterface.call("bot1says", tempstring1);
						}
					}else if (chatbotnum == 2) {
						ExternalInterface.call("bot2says", tempstring1);
					}
				}
			}
		}
		
		
		if (showbotname) {
			addline(botname + ": " + tempstring1, "eliza");
		}else{
			addline(tempstring1, "eliza");
		}
		currentbranch = possibleresponse_branch[answer];
		addline("", "intro");
		
		if (nextsound > -1) {
			Music.playefnum(nextsound);
			nextsound = -1;
		}else {
			if (chatsound > -1) {
				Music.playefnum(chatsound);
			}
		}
		
		if (presskey) {
			addline("[PRESS ENTER KEY TO CONTINUE]", "intro");
			addline("", "intro");
		}
		
		if (skipresponse) {
			skipresponse = false;
			processscript("");
		}
		
		if (Flag.istrue("end")) {
			endscreen = true;
			acceptinginput = false;
		}
		
		if(debugscript) trace("decided to say \"" + possibleresponse[answer] + "\"");
		if(debugscript) trace("currentbranch is now " + currentbranch);
		if(debugscript) trace("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
	}
	
	public static function addresponse(r:String, b:String = "none"):Void {
		possibleresponse[numresponses] = r;
		possibleresponse_branch[numresponses] = b;
		numresponses++;
	}
	
	public static var elizacol:Int = 0x11fff9;
	public static var playercol:Int = 0x00BBB2;
	public static var backgroundcol:Int = 0x000000;
	
	public static var hexelizacol:String = "11fff9";
	public static var hexplayercol:String = "00BBB2";
	public static var hexbackgroundcol:String = "000000";
	/*
	public static var elizacol:Int = 0x0000BB;
	public static var playercol:Int = 0x000000;
	public static var backgroundcol:Int = 0xFFFFFF;
	*/
	public static var answer:Int = 0;
	public static var enteredname:String = " ";
	public static var textposition:Int = 0;
	
	public static var stringbreak:String;
	public static var stringbreakcounter:Int;
	public static var stringbreakline:Int;
	
	public static var currentbranch:String = "none";
	
	public static var possibleresponse:Array<String> = new Array<String>();
	public static var possibleresponse_branch:Array<String> = new Array<String>();
	public static var numresponses:Int;
	
	public static var terminaltext:Array<String> = new Array<String>();
	public static var terminalcol:Array<Int> = new Array<Int>();
	public static var terminaltextperson:Array<String> = new Array<String>();
	
	public static var lineheight:Int = 18;
	public static var caretwidth:Int = 12;
	
	public static var ready:Bool = false;
	
	public static function loadfile():Void {
		 //make a new loader
    myLoader = new URLLoader();
    //new request - for a file in the same folder called 'someTextFile.txt'
    var myRequest:URLRequest = new URLRequest("script.txt");
		
		//wait for the load
    myLoader.addEventListener(Event.COMPLETE, onLoadComplete);
		myLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		
    //load!
    myLoader.load(myRequest);
	}
	
	public static function onIOError(e:Event):Void {
		Elizascript.addline("\"script.txt\" not found.", "intro");
		Elizascript.addline("", "intro");
		Elizascript.addline("To use Elizascript on your own website or computer, place a \"script.txt\" file in the same folder!", "intro");
	}
	
	public static function initfromgithub():Void {
		try {
			githubmode = true;
			ExternalInterface.addCallback("loadfromGithub", loadfromGithub);
			ExternalInterface.addCallback("loadfromGithub2", loadfromGithub2);
			ExternalInterface.addCallback("loadfromEditor", loadfromEditor);
			ExternalInterface.addCallback("uploadsound", uploadsound);
			ExternalInterface.addCallback("saytobot", saytobot);
			ExternalInterface.addCallback("startdual", startdual);
			ExternalInterface.addCallback("stopdual", stopdual);
			ExternalInterface.addCallback("blankurl", blankurl);
			ExternalInterface.addCallback("getMessage", getMessage);
			ExternalInterface.addCallback("getId", getID);
			ExternalInterface.addCallback("getError", getError);
			ExternalInterface.call("init");
		}catch (unknown : Dynamic) {
			githubmode = false;
			//Ok, we must be offline. Try loading a file instead.
			loadfile();
		}
	}
	
	public static function onLoadComplete(e:Event):Void {
		rawscript = myLoader.data.split("\n");
		for (i in 0 ... rawscript.length) {
			rawscript[i] = Help.trimspacesright(rawscript[i]);
		}
		
		terminaltext = new Array<String>();
		terminaltextperson = new Array<String>();
		terminalcol = new Array<Int>();
		
		resetchatbot();
		
		if (title != "") {
			showcredits = true;
		}else {
			ready = true;
			Flag.settrue("start");
			processscript("");
			Flag.setfalse("start");
		}
		
		/*
		ExternalInterface.addCallback("getMessage", getMessage);
		ExternalInterface.addCallback("getId", getID);
		ExternalInterface.addCallback("getError", getError);
		ExternalInterface.call("console.log('poop')");
		*/
    //ExternalInterface.call("shareClick", Std.string(myLoader.data));
	}
	
	public static function loadfromEditor(message:String):Void {
		shake = 10;
		loadfromGithub(message);
	}
	
	public static function loadfromGithub2(message:String):Void {
	  chatbotnum = 2;
		
		rawscript = message.split("\n");
		for (i in 0 ... rawscript.length) {
			rawscript[i] = Help.trimspacesright(rawscript[i]);
		}
		
		terminaltext = new Array<String>();
		terminaltextperson = new Array<String>();
		terminalcol = new Array<Int>();
		
		resetchatbot();
		
		if (title != "") {
			showcredits = true;
		}else {
			ready = true;
			Flag.settrue("start");
			processscript("");
			Flag.setfalse("start");
		}
		
		ExternalInterface.call("senddetails", website, hexplayercol, hexbackgroundcol);
	}
	
	public static function loadfromGithub(message:String):Void {
		chatbotnum = 1;
		
		rawscript = message.split("\n");
		for (i in 0 ... rawscript.length) {
			rawscript[i] = Help.trimspacesright(rawscript[i]);
		}
		
		terminaltext = new Array<String>();
		terminaltextperson = new Array<String>();
		terminalcol = new Array<Int>();
		
		resetchatbot();
		
		if (title != "") {
			showcredits = true;
		}else {
			ready = true;
			Flag.settrue("start");
			processscript("");
			Flag.setfalse("start");
		}
		
		ExternalInterface.call("senddetails", website, hexplayercol, hexbackgroundcol);
	}
	
	public static function uploadsound():Void {
		Music.playefnum(3);
	}
	
	public static function startdual():Void {
		//Reset the chatbots, and start chatting.
		//If we're chatbot 2, don't say anything yet.
		dualrunning = true;
		dualfirstturn = true;
		
		resetchatbot();
		
		ready = true;
		Flag.settrue("start");
		processscript("");
		Flag.setfalse("start");
	}

	public static function stopdual():Void {
		dualrunning = false;
	}

	public static function saytobot(thing:String):Void {
		addline(thing);
		
		//respond(lastentry);
		addline("", "intro");
		processscript(thing);
		inittext("");
	}
	
	public static function getMessage(message:String):Void {
		Gfx.settest("message called" + message);
		Music.playefnum(30);
		Elizascript.addline("", "intro");
		Elizascript.addline(message, "intro");
		Elizascript.addline("", "intro");
	}
	
	public static function blankurl():Void {
		terminaltext = new Array<String>();
		terminaltextperson = new Array<String>();
		terminalcol = new Array<Int>();
		
		elizacol = 0x0000BB;
	  playercol = 0x000000;
	  backgroundcol = 0xFFFFFF;
		Elizascript.addline("Welcome to Elizascript!", "intro");
		Elizascript.addline("--------------------------------", "intro");
		Elizascript.addline("", "intro");
		Elizascript.addline("Elizascript is a simple tool for creating chatbots.", "intro");
		Elizascript.addline("", "intro");
		Elizascript.addline("Read the quick start guide to learn how to create your own!", "intro");
		Elizascript.addline("", "intro");
	}
	
	public static function getID(message:String):Void {
		
	}
	
  public static function getError(message:String):Void {
		
	}
	
	public static function doshake():Void {
		Gfx.buffer = new BitmapData(Gfx.screenwidth, 24, false, 0x000000);
		var i:Int = 0;
		while (i < 20) {
			Gfx.buffer.copyPixels(Gfx.backbuffer, new Rectangle(0, i * 24, Gfx.screenwidth, 24), Gfx.tl);
			Gfx.backbuffer.copyPixels(Gfx.buffer, Gfx.buffer.rect, new Point(Random.int( -15, 15), i * 24));
			i++;
		}
		
	}
	
	public static var myLoader:URLLoader;
	
	public static var rawscript:Array<String>;
	public static var cleanscript:Array<String>;
	
	public static var currenttab:Int;
	public static var slowsine:Int;
	
	public static var temp:Int;
	public static var tempstring1:String;
	public static var tempstring2:String;
	public static var tempstring3:String;
	
	public static var selectionline:Int;
	public static var selectiontextposition:Int;
	public static var selectioncaret:Int;
	public static var selectionmode:Int = 0;
	
	public static var syntaxhighlight:Int;
	
	public static var errorline:Int;
	public static var errorstring:String;
	public static var acceptinginput:Bool;
	public static var workingstring:String;
	public static var workingstringtype:Int;
	public static var currentbracketlevel:Int;
	public static var scriptbracketlevel:Int;
	public static var scriptstart:Int;
	public static var scriptend:Int;
	public static var nextsound:Int;
	public static var chatsound:Int;
	
	public static var botname:String;
	public static var showbotname:Bool;
	public static var typespeed:Int;
	public static var typedelay:Int;
	public static var firstresponse:Bool;
	public static var doclear:Bool;
	
	public static var showcursor:Bool;
	public static var skipresponse:Bool;
	public static var presskey:Bool;
	public static var fallback:Bool;
	
	public static var endscreen:Bool;
	
	public static var title:String;
	public static var author:String;
	public static var website:String;
	public static var showcredits:Bool;
	
	public static var donematchresponse:Int;
	public static var answerlist:Array<String>;
	
	public static var shake:Int;
	public static var githubmode:Bool;
	public static var debugscript:Bool = false;
	
	public static var gamestage:Stage;
	
	public static var inputField:TextField = new TextField();
	public static var waitfortext:Bool;
	public static var finishtext:Bool;
	public static var textfield:String;
	public static var lastentry:String;
	
	public static var halfsize:Bool = false;
	public static var dualmode:Bool = false;
	public static var chatbotnum:Int;
	public static var dualrunning:Bool = false;
	public static var dualfirstturn:Bool;
}