package haxe.ui.backend;

import haxe.ui.assets.FontInfo;
import haxe.ui.backend.pixi.HtmlUtils;
import haxe.ui.core.Component;
import haxe.ui.styles.Style;
import pixi.core.text.Text;
import pixi.core.text.TextStyle;

class TextDisplayBase {

    public var textField:Text;
    public var parentComponent:Component;
    
    public function new() {
        textField = new Text("");
        textField.scale = new pixi.core.math.Point(1, 1);
        //this.style.wordWrap = true;
    }

    private var _text:String;
    private var _left:Float = 0;
    private var _top:Float = 0;
    private var _width:Float = 0;
    private var _height:Float = 0;
    private var _textWidth:Float = 0;
    private var _textHeight:Float = 0;
    private var _textStyle:Style;
    private var _multiline:Bool = true;
    private var _wordWrap:Bool = false;
    private var _fontInfo:FontInfo = null;
    
    //***********************************************************************************************************
    // Validation functions
    //***********************************************************************************************************

    private function validateData() {
        textField.text = _text;
    }
    
    private function validateStyle():Bool {
        var measureTextRequired:Bool = true;
        
        if (_textStyle.color != null) {
            textField.style.fill = HtmlUtils.color(_textStyle.color);
        }
        
        if (_textStyle.fontName != null) {
            textField.style.fontFamily = _textStyle.fontName;
            measureTextRequired = true;
        }
        
        if (_fontInfo != null && _fontInfo.data != textField.style.fontFamily) {
            textField.style.fontFamily = _fontInfo.data;
            measureTextRequired = true;
            parentComponent.invalidateLayout();
        }

        if (_textStyle.fontSize != null) {
            textField.style.fontSize = _textStyle.fontSize;
            measureTextRequired = true;
        }
        
        if (textField.style.wordWrap != _wordWrap) {
            textField.style.wordWrap = _wordWrap;

            measureTextRequired = true;
        }

        return measureTextRequired;
    }
    
    private function validatePosition() {
        textField.x = _left;
        textField.y = _top;
    }
    
    private function validateDisplay() {
        if (textField.width != _width && _width > 0) {
            textField.width = _width;
        }

        if (textField.height != _height && _height > 0) {
            textField.height = _height;
        }
        textField.scale = new pixi.core.math.Point(1, 1);
    }
    
    private function measureText() {
        _textWidth = textField.width;
        _textHeight = textField.height;
    }
}
