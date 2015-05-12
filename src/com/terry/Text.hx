package com.terry;

import com.terry.util.*;
import openfl.Assets;
import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import openfl.text.*;

class Text {
	public static function init():Void {
		drawto = Gfx.backbuffer;
	}
	
	//Text functions
	public static function rprint(x:Int, y:Int, t:String, col:Int):Void {
		x = Std.int(x - len(t));
		print(x, y, t, col);
	}
	
	public static function len(t:String):Int {
		typeface[currentindex].tf.text = t;
		return Std.int(typeface[currentindex].tf.textWidth);
	}
	
	public static function height():Int {
		typeface[currentindex].tf.text = "???";
		return Std.int(typeface[currentindex].tf.textHeight);
	}
	
	public static function alignx(x:Int):Int {
		if (x == CENTER) return Gfx.screenwidthmid - Std.int(typeface[currentindex].tf.textWidth / 2);
		if (x == LEFT || x == TOP) return 0;
		if (x == RIGHT || x == BOTTOM) return Gfx.screenwidth - Std.int(typeface[currentindex].tf.textWidth);
		
		return x;
	}
	
	public static function aligny(y:Int):Int {
		if (y == CENTER) return Gfx.screenheightmid - Std.int(typeface[currentindex].tf.textHeight / 2);
		if (y == LEFT || y == TOP) return 0;
		if (y == RIGHT || y == BOTTOM) return Gfx.screenheight - Std.int(typeface[currentindex].tf.textHeight);
		
		return y;
	}
	
	public static function aligntextx(t:String, x:Int):Int {
		if (x == CENTER) return Std.int(len(t) / 2);
		if (x == LEFT || x == TOP) return 0;
		if (x == RIGHT || x == BOTTOM) return len(t);
		return x;
	}
	
	public static function aligntexty(y:Int):Int {
		if (y == CENTER) return Std.int(height() / 2);
		if (y == TOP || y == LEFT) return 0;
		if (y == BOTTOM || y == RIGHT) return height();
		return y;
	}
	
	public static function print(x:Int, y:Int, t:String, col:Int):Void {
		typeface[currentindex].tf.textColor = col;
		typeface[currentindex].tf.text = t;
		
		x = alignx(x); y = aligny(y);
		
		fontmatrix.identity();
		fontmatrix.translate(x, y);
		typeface[currentindex].tf.textColor = col;
		drawto.draw(typeface[currentindex].tf, fontmatrix);
	}
	
	public static function print_scale(x:Int, y:Int, t:String, col:Int, scale:Float, transx:Int, transy:Int):Void {
	  drawto = typeface[currentindex].tfbitmap;
		typeface[currentindex].clearbitmap();
		
		print(0, 0, t, col);
		
		x = alignx(x); y = aligny(y);
		transx = aligntextx(t, transx); transy = aligntexty(transy);
		
		fontmatrix.identity();
		fontmatrix.translate(-transx, -transy);
		fontmatrix.scale(scale, scale);
		fontmatrix.translate(x + transx, y + transy);
		drawto = Gfx.backbuffer;
		drawto.draw(typeface[currentindex].tfbitmap, fontmatrix);
	}
	
	public static function print_freescale(x:Int, y:Int, t:String, col:Int, xscale:Float, yscale:Float, transx:Int, transy:Int):Void {
	  drawto = typeface[currentindex].tfbitmap;
		typeface[currentindex].clearbitmap();
		
		print(0, 0, t, col);
		
		x = alignx(x); y = aligny(y);
		transx = aligntextx(t, transx); transy = aligntexty(transy);
		
		fontmatrix.identity();
		fontmatrix.translate(-transx, -transy);
		fontmatrix.scale(xscale, yscale);
		fontmatrix.translate(x + transx, y + transy);
		drawto = Gfx.backbuffer;
		drawto.draw(typeface[currentindex].tfbitmap, fontmatrix);
	}
	
	public static function print_rotate(x:Int, y:Int, t:String, col:Int, rotate:Int, transx:Int, transy:Int):Void {
	  drawto = typeface[currentindex].tfbitmap;
		typeface[currentindex].clearbitmap();
		
		print(0, 0, t, col);
		
		x = alignx(x); y = aligny(y);
		transx = aligntextx(t, transx); transy = aligntexty(transy);
		
		fontmatrix.identity();
		fontmatrix.translate(-transx, -transy);
		fontmatrix.rotate((rotate * 3.1415) / 180);
		fontmatrix.translate(x + transx, y + transy);
		drawto = Gfx.backbuffer;
		drawto.draw(typeface[currentindex].tfbitmap, fontmatrix);
	}
	
	public static function print_scale_rotate(x:Int, y:Int, t:String, col:Int, scale:Float, rotate:Int, transx:Int, transy:Int):Void {
	  drawto = typeface[currentindex].tfbitmap;
		typeface[currentindex].clearbitmap();
		
		print(0, 0, t, col);
		
		x = alignx(x); y = aligny(y);
		transx = aligntextx(t, transx); transy = aligntexty(transy);
		
		fontmatrix.identity();
		fontmatrix.translate(-transx, -transy);
		fontmatrix.scale(scale, scale);
		fontmatrix.rotate((rotate * 3.1415) / 180);
		fontmatrix.translate(x + transx, y + transy);
		drawto = Gfx.backbuffer;
		drawto.draw(typeface[currentindex].tfbitmap, fontmatrix);
	}
	
	public static function print_freescale_rotate(x:Int, y:Int, t:String, col:Int, xscale:Float, yscale:Float, rotate:Int, transx:Int, transy:Int):Void {
	  drawto = typeface[currentindex].tfbitmap;
		typeface[currentindex].clearbitmap();
		
		print(0, 0, t, col);
		
		x = alignx(x); y = aligny(y);
		transx = aligntextx(t, transx); transy = aligntexty(transy);
		
		fontmatrix.identity();
		fontmatrix.translate(-transx, -transy);
		fontmatrix.scale(xscale, yscale);
		fontmatrix.rotate((rotate * 3.1415) / 180);
		fontmatrix.translate(x + transx, y + transy);
		drawto = Gfx.backbuffer;
		drawto.draw(typeface[currentindex].tfbitmap, fontmatrix);
	}
	
	public static function changefont(t:String):Void {
		currentfont = t;
		if (currentsize != -1) {
			if (typefaceindex.exists(currentfont + "_" + Std.string(currentsize))) {
				currentindex = typefaceindex.get(currentfont + "_" + Std.string(currentsize));
			}else {
				addtypeface(currentfont, currentsize);
				currentindex = typefaceindex.get(currentfont + "_" + Std.string(currentsize));
			}
		}
	}
	
	public static function changesize(t:Int):Void {
		currentsize = t;
		if (currentfont != "null") {
			if (typefaceindex.exists(currentfont + "_" + Std.string(currentsize))) {
				currentindex = typefaceindex.get(currentfont + "_" + Std.string(currentsize));
			}else {
				addtypeface(currentfont, currentsize);
				currentindex = typefaceindex.get(currentfont + "_" + Std.string(currentsize));
			}
		}
	}
	
	public static function addfont(t:String):Void {
		fontfile.push(new Fontfile(t));
		fontfileindex.set(t, fontfile.length - 1);
		currentfont = t;
	}
	
	public static function addtypeface(_name:String, _size:Int):Void {
		typeface.push(new Fontclass(_name, _size));
		typefaceindex.set(_name+"_" + Std.string(_size), typeface.length - 1);
	}
	
	public static function cachefont(_name:String, _s1:Int, _s2:Int = -1, _s3:Int = -1,
															_s4:Int = -1, _s5:Int = -1, _s6:Int = -1, _s7:Int = -1,
															_s8:Int = -1, _s9:Int = -1, _s10:Int = -1, _s11:Int = -1, _s12:Int = -1) {
    changefont(_name);
		changesize(_s1);
		if (_s2 > -1) changesize(_s2);
		if (_s3 > -1) changesize(_s3);
		if (_s4 > -1) changesize(_s4);
		if (_s5 > -1) changesize(_s5);
		if (_s6 > -1) changesize(_s6);
		if (_s7 > -1) changesize(_s7);
		if (_s8 > -1) changesize(_s8);
		if (_s9 > -1) changesize(_s9);
		if (_s10 > -1) changesize(_s10);
		if (_s11 > -1) changesize(_s11);
		if (_s12 > -1) changesize(_s12);
	}
	
	
	public static var fontfile:Array<Fontfile> = new Array<Fontfile>();
	public static var fontfileindex:Map<String,Int> = new Map<String,Int>();
	
	public static var typeface:Array<Fontclass> = new Array<Fontclass>();
	public static var typefaceindex:Map<String,Int> = new Map<String,Int>();
	
	public static var fontmatrix:Matrix = new Matrix();
	public static var currentindex:Int = -1;
	public static var currentfont:String = "null";
	public static var currentsize:Int = -1;
	
	public static var drawto:BitmapData;
	
	public static var LEFT:Int = -20000;
	public static var RIGHT:Int = -20001;
	public static var TOP:Int = -20002;
	public static var BOTTOM:Int = -20003;
	public static var CENTER:Int = -20004;
}