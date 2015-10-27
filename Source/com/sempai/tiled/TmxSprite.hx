package com.sempai.tiled;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

class Layer extends Sprite {

	var tmxParent : TmxSprite;
	var matrix : TmxMatrix<Sprite>;

	public function new(tmxParent : TmxSprite) {
		super();
		this.tmxParent = tmxParent;
		this.matrix = new TmxMatrix(tmxParent.mWidth, tmxParent.mHeight);
	}

	public function set(x : Int, y : Int, id : Int) {
		if (matrix.get(x, y)!=null) {
			this.removeChild(matrix.get(x, y));
			matrix.set(x, y, null);
		}
		if (tmxParent.tiles.get(id)==null) {
			return;
		}
		var spr = new Sprite();
		var bmp = new Bitmap(tmxParent.tiles[id]);
		spr.addChild(bmp);
		matrix.set(x, y, spr);
		spr.x = x*tmxParent.tileWidth*tmxParent.scale;
		spr.y = (y+1)*tmxParent.tileHeight*tmxParent.scale-spr.height;
		this.addChild(spr);
	}

}

@:allow(com.sempai.tiled.TmxLoader)
class TmxSprite extends Sprite {

	public var mWidth : Int;
	public var mHeight : Int;
	public var tileWidth : Float;
	public var tileHeight : Float;
	public var tiles : Map<Int, BitmapData>;
	public var scale : Float;
	var layers : Array<Layer>;

	private function new(
		mWidth : Int,
		mHeight : Int,
		tileWidth : Float,
		tileHeight : Float,
		tiles : Map<Int, BitmapData>,
		scale : Float
	) {
		super();
		this.mWidth = mWidth;
		this.mHeight = mHeight;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		this.layers  = [];
		this.tiles = tiles;
		this.scale = scale;
	}

	public function addLayer() {
		var l = new Layer(this);
		layers.push(l);
		addChild(l);
	}

	public function set(layer : Int, x : Int, y : Int, tileId : Int) {
		if (layers[layer]!=null) {
			layers[layer].set(x, y, tileId);
		}
	}

}
