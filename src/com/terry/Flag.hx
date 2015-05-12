package com.terry;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;

class Flag {
	public static function init():Void {
		for (i in 0...10000) flags.push(0);
	}
	
	public static function resetflags():Void {
		for (i in 0...10000) {
			flags[i] = 0;
		}
		flagindex = new Map<String, Int>();
	}
	
	public static function istrue(t:String):Bool {
		if (!flagindex.exists(t)) {
			if(Elizascript.debugscript) trace("DEBUGGING isTrue: " + t +" doesn't exist, so return false");
			return false;
		}else{
			if (flags[flagindex.get(t)] == 1) {
				if(Elizascript.debugscript) trace("DEBUGGING isTrue: " + t +" exists and is 1, so return true");
				return true;
			}
		}
		if(Elizascript.debugscript) trace("DEBUGGING isTrue: " + t +" exists and not 1, so return false.");
		return false;
	}
	
	public static function isfalse(t:String):Bool {
    if (!flagindex.exists(t)) {
			if(Elizascript.debugscript) trace("DEBUGGING isFalse: " + t +" doesn't exist, so return false");
			return true;
		}else {
			if (flags[flagindex.get(t)] == 0) {
				if(Elizascript.debugscript) trace("DEBUGGING isFalse: " + t +" exists and is zero, so return false");
				return true;
			}
		}
		if(Elizascript.debugscript) trace("DEBUGGING isFalse: " + t +" exists and not zero, so return true.");
		return false;
	}
	
	public static function settrue(t:String):Void {
		//trace(t + " set to TRUE.");
		if (!flagindex.exists(t)) {
			flagindex.set(t, numflag);
			numflag++;
			flags[flagindex.get(t)] = 1;
		}else {
			flags[flagindex.get(t)] = 1;
		}
	}
	
	public static function setfalse(t:String):Void {
		//trace(t + " set to FALSE."); 
		if (!flagindex.exists(t)) {
			flagindex.set(t, numflag);
			numflag++;
			flags[flagindex.get(t)] = 0;
		}else {
			flags[flagindex.get(t)] = 0;
		}
	}
	
	public static var flags:Array<Int> = new Array<Int>();
	public static var flagindex:Map<String, Int> = new Map<String, Int>(); //Holds the indexes!
	public static var numflag:Int = 0;
}
