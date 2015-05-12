package com.terry.util;

import openfl.Assets;
import openfl.text.*;
import openfl.display.*;
import com.terry.*;

class Fontfile {
	public function new(_file:String) {
		filename = "data/graphics/font/" + _file + ".ttf";
		font = Assets.getFont(filename);
		//This is pretty weird, but it works so whatever
		#if flash
		typename = font.fontName;
		#else
		typename = "data/graphics/font/" + _file;
		#end
	}
	
	public var font:Font;
	public var filename:String;
	public var typename:String;
}