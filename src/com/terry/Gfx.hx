package com.terry;
	
import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import openfl.text.*;
import openfl.Assets;
import gamecontrol.*;
import com.terry.util.*;
import openfl.Lib;
import openfl.system.Capabilities;

class Gfx {
	public static function init(stage:Stage):Void {
		gfxstage = stage;
	}
	
	public static function createscreen(width:Int, height:Int, scale:Int = 1):Void {
		initgfx(width, height, scale);
		Text.init();
		gfxstage.addChild(screen);
	}
	
	//Initialise arrays here
	public static function initgfx(width:Int, height:Int, scale:Int):Void {
		//We initialise a few things
		screenwidth = width; screenheight = height;
		screenwidthmid = Std.int(screenwidth / 2); screenheightmid = Std.int(screenheight / 2);
		
		devicexres = Std.int(flash.system.Capabilities.screenResolutionX);
		deviceyres = Std.int(flash.system.Capabilities.screenResolutionY);
		screenscale = scale;
		
		trect = new Rectangle(); tpoint = new Point();
		tbuffer = new BitmapData(1, 1, true);
		ct = new ColorTransform(0, 0, 0, 1, 255, 255, 255, 1); //Set to white
		fademode = 0; fadeamount = 0; fadeaction = "nothing";
		
		backbuffer = new BitmapData(screenwidth, screenheight, false, 0x000000);
		screenbuffer = new BitmapData(screenwidth, screenheight, false, 0x000000);
		textboxbuffer = new BitmapData(screenwidth, screenheight, false, 0x00000000);
		
		drawto = backbuffer;
		
		screen = new Bitmap(screenbuffer);
		screen.width = screenwidth * scale;
		screen.height = screenheight * scale;
		
		fullscreen = false;
		
		test = false; teststring.push("TEST = True");
	}
	
	public static function cleartest():Void {
		teststring = new Array<String>();
	}
	
	public static function addtest(t:String):Void {
		teststring.push(t);
		test = true;
		if (teststring.length > 20) {
			teststring.reverse();
			teststring.pop();
			teststring.reverse();
		}
	}
	
	public static function settest(t:String):Void {
		teststring[0] = t;
		test = true;
	}
	
	public static function settrect(x:Int, y:Int, w:Int, h:Int):Void {
		trect.x = x;
		trect.y = y;
		trect.width = w;
		trect.height = h;
	}
	
	public static function settpoint(x:Int, y:Int):Void {
		tpoint.x = x;
		tpoint.y = y;
	}
	
	public static function addimage(imagename:String, filename:String):Void {
		buffer = new Bitmap(Assets.getBitmapData(filename)).bitmapData;
		imageindex.set(imagename, images.length);
		
		var t:BitmapData = new BitmapData(buffer.width, buffer.height, true, 0x000000);
		settrect(0, 0, buffer.width, buffer.height);			
		t.copyPixels(buffer, trect, tl);
		images.push(t);
	}
	
	public static function imagealignx(x:Int):Int {
		if (x == CENTER) return Gfx.screenwidthmid - Std.int(images[imagenum].width / 2);
		if (x == LEFT || x == TOP) return 0;
		if (x == RIGHT || x == BOTTOM) return images[imagenum].width;
		return x;
	}
	
	public static function imagealigny(y:Int):Int {
		if (y == CENTER) return Gfx.screenheightmid - Std.int(images[imagenum].height / 2);
		if (y == LEFT || y == TOP) return 0;
		if (y == RIGHT || y == BOTTOM) return images[imagenum].height;
		return y;
	}
	
	public static function imagealignonimagex(x:Int):Int {
		if (x == CENTER) return Std.int(images[imagenum].width / 2);
		if (x == LEFT || x == TOP) return 0;
		if (x == RIGHT || x == BOTTOM) return images[imagenum].width;
		return x;
	}
	
	public static function imagealignonimagey(y:Int):Int {
		if (y == CENTER) return Std.int(images[imagenum].height / 2);
		if (y == LEFT || y == TOP) return 0;
		if (y == RIGHT || y == BOTTOM) return images[imagenum].height;
		return y;
	}
	
	public static function drawimage(x:Int, y:Int, imagename:String):Void {
		imagenum = imageindex.get(imagename);
		
		x = imagealignx(x); y = imagealigny(y);
		shapematrix.identity();
		shapematrix.translate(x, y);
		backbuffer.draw(images[imagenum], shapematrix);
	}
	
	public static function drawimage_scale(x:Int, y:Int, imagename:String, scale:Float, transx:Int, transy:Int):Void {
		imagenum = imageindex.get(imagename);
		
		x = imagealignx(x); y = imagealigny(y);
		transx = imagealignonimagex(transx); transy = imagealignonimagey(transy);
		
		shapematrix.identity();
		shapematrix.translate(-transx, -transy);
		shapematrix.scale(scale, scale);
		shapematrix.translate(x + transx, y + transy);
		drawto.draw(images[imagenum], shapematrix);
	}
	
	public static function drawimage_freescale(x:Int, y:Int, imagename:String, xscale:Float, yscale:Float, transx:Int, transy:Int):Void {
		imagenum = imageindex.get(imagename);
		
		x = imagealignx(x); y = imagealigny(y);
		transx = imagealignonimagex(transx); transy = imagealignonimagey(transy);
		
		shapematrix.identity();
		shapematrix.translate(-transx, -transy);
		shapematrix.scale(xscale, yscale);
		shapematrix.translate(x + transx, y + transy);
		drawto.draw(images[imagenum], shapematrix);
	}
	
	public static function drawimage_rotate(x:Int, y:Int, imagename:String, rotate:Int, transx:Int, transy:Int):Void {
		imagenum = imageindex.get(imagename);
		
		x = imagealignx(x); y = imagealigny(y);
		transx = imagealignonimagex(transx); transy = imagealignonimagey(transy);
		
		shapematrix.identity();
		shapematrix.translate(-transx, -transy);
		shapematrix.rotate((rotate * 3.1415) / 180);
		shapematrix.translate(x + transx, y + transy);
		drawto.draw(images[imagenum], shapematrix);
	}
	
	public static function drawimage_scale_rotate(x:Int, y:Int, imagename:String, scale:Float, rotate:Int, transx:Int, transy:Int):Void {
		drawimage_freescale_rotate(x, y, imagename, scale, scale, rotate, transx, transy);
	}
	
	public static function drawimage_freescale_rotate(x:Int, y:Int, imagename:String, xscale:Float, yscale:Float, rotate:Int, transx:Int, transy:Int):Void {
		imagenum = imageindex.get(imagename);
		
		x = imagealignx(x); y = imagealigny(y);
		transx = imagealignonimagex(transx); transy = imagealignonimagey(transy);
		
		shapematrix.identity();
		shapematrix.translate(-transx, -transy);
		shapematrix.rotate((rotate * 3.1415) / 180);
		shapematrix.scale(xscale, yscale);
		shapematrix.translate(x + transx, y + transy);
		drawto.draw(images[imagenum], shapematrix);
	}
	
	public static function drawimage_col(x:Int, y:Int, imagename:String, col:Int):Void {
		imagenum = imageindex.get(imagename);
		
		x = imagealignx(x); y = imagealigny(y);
		
  	shapematrix.identity();
		shapematrix.translate(x, y);
		ct.color = col;
		drawto.draw(images[imagenum], shapematrix, ct);
	}
	
	public static function drawimage_scale_col(x:Int, y:Int, imagename:String, scale:Float, transx:Int, transy:Int, col:Int):Void {
		drawimage_freescale_col(x, y, imagename, scale, scale, transx, transy, col);
	}
	
	public static function drawimage_freescale_col(x:Int, y:Int, imagename:String, xscale:Float, yscale:Float, transx:Int, transy:Int, col:Int):Void {
		imagenum = imageindex.get(imagename);
		
		x = imagealignx(x); y = imagealigny(y);
		transx = imagealignonimagex(transx); transy = imagealignonimagey(transy);
		
		shapematrix.identity();
		shapematrix.translate(-transx, -transy);
		shapematrix.scale(xscale, yscale);
		shapematrix.translate(x + transx, y + transy);
		ct.color = col;
		drawto.draw(images[imagenum], shapematrix, ct);
	}
	
	public static function drawimage_rotate_col(x:Int, y:Int, imagename:String, rotate:Int, transx:Int, transy:Int, col:Int):Void {
		imagenum = imageindex.get(imagename);
		
		x = imagealignx(x); y = imagealigny(y);
		transx = imagealignonimagex(transx); transy = imagealignonimagey(transy);
		
		shapematrix.identity();
		shapematrix.translate(-transx, -transy);
		shapematrix.rotate((rotate * 3.1415) / 180);
		shapematrix.translate(x + transx, y + transy);
		ct.color = col;
		drawto.draw(images[imagenum], shapematrix, ct);
	}
	
	public static function drawimage_scale_rotate_col(x:Int, y:Int, imagename:String, scale:Float, rotate:Int, transx:Int, transy:Int, col:Int):Void {
		drawimage_freescale_rotate_col(x, y, imagename, scale, scale, rotate, transx, transy, col);
	}
	
	public static function drawimage_freescale_rotate_col(x:Int, y:Int, imagename:String, xscale:Float, yscale:Float, rotate:Int, transx:Int, transy:Int, col:Int):Void {
		imagenum = imageindex.get(imagename);
		
		x = imagealignx(x); y = imagealigny(y);
		transx = imagealignonimagex(transx); transy = imagealignonimagey(transy);
		
		shapematrix.identity();
		shapematrix.translate(-transx, -transy);
		shapematrix.rotate((rotate * 3.1415) / 180);
		shapematrix.scale(xscale, yscale);
		shapematrix.translate(x + transx, y + transy);
		ct.color = col;
		drawto.draw(images[imagenum], shapematrix, ct);
	}
	
	public static function cls():Void {
		fillrect(0, 0, screenwidth, screenheight, 0, 0, 0);
	}

	public static function fillrect(x1:Int, y1:Int, w1:Int, h1:Int, r:Int, g:Int = -1, b:Int = -1):Void {
		settrect(x1, y1, w1, h1);
		if (g == -1 && b == -1) {
			backbuffer.fillRect(trect, r);
		}else{
			backbuffer.fillRect(trect, RGB(r, g, b));
		}
	}
	
	public static function getred(c:Int):Int {
		return (( c >> 16 ) & 0xFF);
	}
	
	public static function getgreen(c:Int):Int {
		return ( (c >> 8) & 0xFF );
	}
	
	public static function getblue(c:Int):Int {
		return ( c & 0xFF );
	}
	
	public static function RGB(red:Int, green:Int, blue:Int):Int {
		return (blue | (green << 8) | (red << 16));
	}
	
	public static function RGBA(red:Int, green:Int, blue:Int):Int {
		return (blue | (green << 8) | (red << 16)) + 0xFF000000;
	}
	
	public static function shade(currentcol:Int, a:Float):Int {
		if (a > 1.0) a = 1.0;	if (a < 0.0) a = 0.0;
		return RGB(Std.int((getred(currentcol) * a)), Std.int((getgreen(currentcol) * a)), Std.int((getblue(currentcol) * a)));
	}
	
	//Render functions
	public static function normalrender():Void {
		backbuffer.unlock();
		
		screenbuffer.lock();
		screenbuffer.copyPixels(backbuffer, backbuffer.rect, tl, null, null, false);
		screenbuffer.unlock();
		
		backbuffer.lock();
	}

	public static function screenrender():Void {
		if (test) {
			for (k in 0 ... teststring.length) {
				for (j in -1 ... 2) {
					for (i in -1 ... 2) {
						Text.print(2 + i, j + Std.int(2 + ((teststring.length - 1 - k) * (Text.height() + 2))), teststring[k], Gfx.RGB(0, 0, 0));
					}
				}
				Text.print(2, Std.int(2 + ((teststring.length-1-k) * (Text.height() + 2))), teststring[k], Gfx.RGB(255, 255, 255));
			}
		}
		
		normalrender();
	}
	
	public static function setzoom(t:Int):Void {
		screen.width = screenwidth * t;
		screen.height = screenheight * t;
		screen.x = (screenwidth - (screenwidth * t)) / 2;
		screen.y = (screenheight - (screenheight * t)) / 2;
	}
	
	public static function updategraphicsmode():Void {
		//This was always incomplete
		if (fullscreen) {
			//gfx.context.configureBackBuffer(game.fullscreenwidth, game.fullscreenheight, 0, true);
			//stage.fullScreenSourceRect = new Rectangle(0, 0, Gfx.screenwidth, Gfx.screenheight);
			Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
			var xScaleFresh:Float = cast(devicexres, Float) / cast(screenwidth, Float);
			var yScaleFresh:Float = cast(deviceyres, Float) / cast(screenheight, Float);
			if (xScaleFresh < yScaleFresh){
				screen.width = screenwidth * xScaleFresh;
				screen.height = screenheight * xScaleFresh;
			}else if (yScaleFresh < xScaleFresh){
				screen.width = screenwidth * yScaleFresh;
				screen.height = screenheight * yScaleFresh;
			} else {
				screen.width = screenwidth * xScaleFresh;
				screen.height = screenheight * yScaleFresh;
			}
			screen.x = (cast(devicexres, Float) / 2.0) - (screen.width / 2.0);
			screen.y = (cast(deviceyres, Float) / 2.0) - (screen.height / 2.0);
			//Mouse.hide();
		}else {
			Lib.current.stage.displayState = StageDisplayState.NORMAL;
			screen.width = screenwidth * screenscale;
			screen.height = screenheight * screenscale;
			screen.x = 0.0;
			screen.y = 0.0;
			gfxstage.scaleMode = StageScaleMode.SHOW_ALL;
			gfxstage.quality = StageQuality.HIGH;
			//gfx.context.configureBackBuffer(gfx.screenwidth, gfx.screenheight, 0, true);
			//stage.displayState = StageDisplayState.NORMAL;
			//Mouse.show();
		}
	}
	
	public static var screenwidth:Int;
	public static var screenheight:Int;
	public static var screenwidthmid:Int;
	public static var screenheightmid:Int;
	public static var screentilewidth:Int;
	public static var screentileheight:Int;
	
	public static var screenscale:Int;
	public static var devicexres:Int;
	public static var deviceyres:Int;
	public static var fullscreen:Bool;
	
	public static var tiles:Array<Tileset> = new Array<Tileset>();
	public static var tilesetindex:Map<String, Int> = new Map<String, Int>();
	public static var currenttileset:Int;
	public static var currenttilesetname:String;
	
	public static var drawto:BitmapData;
	
	public static var images:Array<BitmapData> = new Array<BitmapData>();
	public static var imagenum:Int;
	public static var ct:ColorTransform;
	public static var images_rect:Rectangle;
	public static var tl:Point = new Point(0, 0);
	public static var trect:Rectangle;
	public static var tpoint:Point;
	public static var tbuffer:BitmapData;
	public static var imageindex:Map<String, Int> = new Map<String, Int>();
	
	public static var buffer:BitmapData;
	
	public static var temptile:BitmapData;
	//Actual backgrounds
	public static var backbuffer:BitmapData;
	public static var screenbuffer:BitmapData;
	public static var screen:Bitmap;
	//Tempshape
	public static var tempshape:Shape = new Shape();
	public static var shapematrix:Matrix = new Matrix();
	//Fade Transition (room changes, game state changes etc)
	public static var fademode:Int;
	public static var fadeamount:Int;
	public static var fadeaction:String;
	
	public static var screenshake:Int;
	public static var flashlight:Int;
	
	public static var alphamult:Int;
	public static var textboxbuffer:BitmapData;
	public static var gfxstage:Stage;
	
	public static var test:Bool;
	public static var teststring:Array<String> = new Array<String>();
	
	public static var LEFT:Int = -20000;
	public static var RIGHT:Int = -20001;
	public static var TOP:Int = -20002;
	public static var BOTTOM:Int = -20003;
	public static var CENTER:Int = -20004;
	
	public static var FADED_IN:Int = 0;
	public static var FADED_OUT:Int = 1;
	public static var FADE_OUT:Int = 2;
	public static var FADING_OUT:Int = 3;
	public static var FADE_IN:Int = 4;
	public static var FADING_IN:Int = 5;
}