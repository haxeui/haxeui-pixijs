package haxe.ui.core;

import haxe.ui.assets.ImageInfo;
import haxe.ui.core.Component;
import js.html.*;
import pixi.core.sprites.Sprite;


class ImageDisplayBase extends Sprite {
    public function new() {
        super(null);
    }

    private var _left:Float = 0;
    private var _top:Float = 0;
    private var _imageWidth:Float = -1;
    private var _imageHeight:Float = -1;

    public var parentComponent:Component;
    public var aspectRatio:Float = 1; // width x height

    public var left(get, set):Float;
    private function get_left():Float {
        return _left;
    }
    private function set_left(value:Float):Float {
        _left = value;
        return value;
    }

    public var top(get, set):Float;
    private function get_top():Float {
        return _top;
    }
    private function set_top(value:Float):Float {
        _top = value;
        return value;
    }

    public var imageWidth(get, set):Float;
    private function set_imageWidth(value:Float):Float {
        return value;
    }

    private function get_imageWidth():Float {
        return _imageWidth;
    }

    public var imageHeight(get, set):Float;
    private function set_imageHeight(value:Float):Float {
        return value;
    }

    private function get_imageHeight():Float {
        return _imageHeight;
    }


    private var _imageInfo:ImageInfo;
    public var imageInfo(get, set):ImageInfo;
    private function get_imageInfo():ImageInfo {
        return _imageInfo;
    }
    private function set_imageInfo(value:ImageInfo):ImageInfo {
        _imageInfo = value;
        this.texture = _imageInfo.data;
        _imageWidth = _imageInfo.width;
        _imageHeight = _imageInfo.height;
        aspectRatio = _imageInfo.width / _imageInfo.height;
        return value;
    }

    public function dispose():Void {
        if (texture != null) {
            texture.destroy;
        }
    }

}