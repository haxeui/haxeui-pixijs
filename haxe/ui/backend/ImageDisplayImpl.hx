package haxe.ui.backend;

import haxe.ui.assets.ImageInfo;
import haxe.ui.core.Component;
import haxe.ui.geom.Rectangle;
import js.html.*;
import pixi.core.sprites.Sprite;


class ImageDisplayImpl extends ImageBase {
    public var sprite:Sprite;
    
    public function new() {
        super();
        sprite = new Sprite();
    }

    public override function dispose():Void {
        if (sprite.texture != null) {
            sprite.texture.destroy();
            _imageInfo = null;
        }
    }

    //***********************************************************************************************************
    // Validation functions
    //***********************************************************************************************************

    private override function validateData() {
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
    
    private override function validatePosition() {
        if (sprite.x != _left) {
            sprite.x = _left;
        }

        if (sprite.y != _top) {
            sprite.y = _top;
        }
    }
    
    private override function validateDisplay() {
        if (_imageInfo != null) {
            var scaleX:Float = _imageWidth / sprite.texture.width;
            var scaleY:Float = _imageHeight / sprite.texture.height;
            sprite.scale = new pixi.core.math.Point(scaleX, scaleY);
        }
    }
}