package com.terry.util;

import openfl.display.*;
import com.terry.*;

class Tileset {
	public function new(n:String, w:Int, h:Int) {
		name = n;
		width = w;
		height = h;
		fastblit = false;
	}
	
	public var tiles:Array<BitmapData> = new Array<BitmapData>();
	public var name:String;
	public var width:Int;
	public var height:Int;
	
	public var fastblit:Bool;
}