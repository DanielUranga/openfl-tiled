package com.sempai.tiled;

import haxe.ds.Vector;

class TmxMatrix {

	public var width(default, null) : Int;
	public var height(default, null) : Int;
	var data : Vector<Int>;

	public function new(width : Int, height : Int) {
		this.width = width;
		this.height = height;
		this.data = new Vector(width*height);
	}

	public function get(x : Int, y : Int) {
		return data[y*width+x];
	}

	public function set(x : Int, y : Int, val : Int) {
		data[y*width+x] = val;
	}

}
