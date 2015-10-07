package;

import com.sempai.tiled.TmxLoader;
import com.sempai.tiled.TmxSprite;
import flash.geom.Point;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.Lib;

class Main extends Sprite {

	var mDown : Bool;
	var mapStartPos : Point;
	var mouseStartPos : Point;
	var spr : TmxSprite;

	public function new () {
		super ();
		spr = TmxLoader.load("assets/mapaloko.tmx", 0.2);
		this.addChild(spr);
		mDown = false;
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addChild(new openfl.display.FPS());
	}

	function onMouseDown(e : MouseEvent) {
		mDown = true;
		mapStartPos = new Point(spr.x, spr.y);
		mouseStartPos = new Point(e.stageX, e.stageY);
	}

	function onMouseUp(e : MouseEvent) {
		mDown = false;
	}

	function onMouseMove(e : MouseEvent) {
		if (mDown) {
			spr.x = mapStartPos.x - mouseStartPos.x + e.stageX;
			spr.y = mapStartPos.y - mouseStartPos.y + e.stageY;
		}
	}

}
