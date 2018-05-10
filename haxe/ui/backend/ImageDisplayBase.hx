package haxe.ui.backend;

import haxe.ui.util.Rectangle;
import haxe.ui.assets.ImageInfo;
import haxe.ui.core.Component;
import js.html.*;
import pixi.core.sprites.Sprite;


class ImageDisplayBase {
    public var parentComponent:Component;
    public var aspectRatio:Float = 1; // width x height
    public var sprite:Sprite;
    
    public function new() {
        sprite = new Sprite();
    }

    private var _left:Float = 0;
    private var _top:Float = 0;
    private var _imageWidth:Float = 0;
    private var _imageHeight:Float = 0;
    private var _imageInfo:ImageInfo;
    private var _imageClipRect:Rectangle;
    
    public function dispose():Void {
        if (sprite.texture != null) {
            //sprite.texture.destroy();
            _imageInfo = null;
        }
    }

    //***********************************************************************************************************
    // Validation functions
    //***********************************************************************************************************

    private function validateData() {
        if (_imageInfo != null) {
            sprite.texture = _imageInfo.data;
            if (_imageWidth <= 0) {
                _imageWidth = _imageInfo.width;
            }
            if (_imageHeight <= 0) {
                _imageHeight = _imageInfo.height;
            }
            aspectRatio = _imageInfo.width / _imageInfo.height;
        }
    }
    
    private function validatePosition() {
        if (sprite.x != _left) {
            sprite.x = _left;
        }

        if (sprite.y != _top) {
            sprite.y = _top;
        }
    }
    
    private function validateDisplay() {
        if (_imageInfo != null) {
            var scaleX:Float = _imageWidth / sprite.texture.width;
            var scaleY:Float = _imageHeight / sprite.texture.height;
            sprite.scale = new pixi.core.math.Point(scaleX, scaleY);
        }
    }
}