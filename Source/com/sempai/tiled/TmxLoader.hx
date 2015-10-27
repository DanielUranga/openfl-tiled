package com.sempai.tiled;

import flash.display.Sprite;
import haxe.crypto.Base64;
import haxe.io.BytesInput;
import haxe.xml.Fast;
import haxe.xml.Parser;
import haxe.zip.Uncompress;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;

class TmxLoader {

	static function parseLayer(data : String, width : Int, height : Int) : TmxMatrix<Int> {
		trace(data);
		var un64 = Base64.decode(data);
		var uncompressed = new BytesInput(Uncompress.run(un64));
		var mat = new TmxMatrix(width, height);
		for (y in 0...height) {
			for (x in 0...width) {
				mat.set(x, y, uncompressed.readInt32());
			}
		}
		return mat;
	}

	static function loadScaledBmp(path : String, scale : Float) : BitmapData {
		var orig = Assets.getBitmapData(path, false);
		var m = new Matrix();
		var scaleX = Math.ceil(scale*orig.width)/orig.width;
		var scaleY = Math.ceil(scale*orig.height)/orig.height;
		m.scale(scaleX, scaleY);
		var scaled = new BitmapData(
			Std.int(Math.ceil(orig.width*scale)),
			Std.int(Math.ceil(orig.height*scale)),
			true,
			0
		);
		scaled.draw(orig, m, true);
		return scaled;
	}

	public static function load(file : String, scale : Float) : TmxSprite {

		var prefix = file.substr(0, file.lastIndexOf("/"));
		var map = Parser.parse(Assets.getText(file)).firstElement();
		var width = Std.parseInt(map.get("width"));
		var height = Std.parseInt(map.get("height"));
		var tileWidth = Std.parseInt(map.get("tilewidth"));
		var tileHeight = Std.parseInt(map.get("tileheight"));
		var tiles = new Map<Int, BitmapData>();
		var firstGid : Int = 0;

		var layers = [];

		for (child in map.elements()) {
			switch (child.nodeName) {
				case "tileset": {
					firstGid = Std.parseInt(child.get("firstgid"));
					for (tile in child.elements()) {
						var id = Std.parseInt(tile.get("id"));
						var source = tile.firstElement().get("source");
						tiles[id] = loadScaledBmp(prefix + "/" + source, scale);
					}
				}
				case "layer": {
					var name = child.get("name");
					var data = child.firstElement().toString().split(">")[1].split("<")[0];
					data = StringTools.trim(data);
					layers.push(parseLayer(data, width, height));
				}
				default: {}
			}
		}

		var tmx = new TmxSprite(width, height, tileWidth, tileHeight, tiles, scale);
		var layerId = 0;
		for (l in layers) {
			tmx.addLayer();
			for (yPos in 0...height) {
				for (xPos in 0...width) {
					var id = l.get(xPos, yPos)-firstGid;
					tmx.set(layerId, xPos, yPos, id);
				}
			}
			layerId++;
		}
		return tmx;

	}

}
