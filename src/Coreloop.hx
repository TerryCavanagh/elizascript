import openfl.display.*;
import openfl.utils.Timer;
import openfl.events.*;
import openfl.Lib;
import com.terry.*;
import com.terry.util.*;

class Coreloop {
	public static function init(stage:Stage):Void {
		infocus = true; 
		if(!Elizascript.dualmode){
			stage.addEventListener(Event.DEACTIVATE, windowNotActive);
			stage.addEventListener(Event.ACTIVATE, windowActive);
		}
	}
	
	public static function setupgametimer():Void {
		_rate = 1000 / TARGET_FPS;
	  _skip = _rate * 10;
		_timer.addEventListener(TimerEvent.TIMER, mainloop);
		_timer.start();
	}
	
	private static function mainloop(e:TimerEvent):Void {
		_current = Lib.getTimer();
		if (_last < 0) _last = _current;
		_delta += _current - _last;
		_last = _current;
		if (_delta >= _rate){
			_delta %= _skip;
			while (_delta >= _rate){
				_delta -= _rate;
				inputlogic();
			}
			render();
			e.updateAfterEvent();
		}
	}
	
	private static function inputlogic():Void {
		Mouse.update(Std.int(Lib.current.mouseX / Gfx.screenscale), Std.int(Lib.current.mouseY / Gfx.screenscale));
		Key.keypoll();
		Music.processmusic();
		InputLogic.updateinput();
		Help.updateglow();
	}

	private static function render():Void {
		if (!infocus) {
			Render.outoffocus();
			Gfx.screenrender();
		}else {
			Gfx.backbuffer.lock();
			Render.updaterender();
			Gfx.screenrender();
		}
	}
	
	public static var gamestate:Int;
	
	private static var TARGET_FPS:Int = 60;
	private static var _rate:Float;
	private static var _skip:Float;
	private static var _last:Float = -1;
	private static var _current:Float = 0;
	private static var _delta:Float = 0;
	private static var _timer:Timer = new Timer(4);
	
	public static function windowNotActive(e:Event):Void { 
		infocus = false; focuscount = 0;
	}
	
  public static function windowActive(e:Event):Void { 
		infocus = true; focuscount = 0;
	}
	
	public static var infocus:Bool = false;
	public static var focuscount:Int;
}