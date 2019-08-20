package haxe.ui.backend;

import haxe.ui.assets.FontInfo;
import haxe.ui.backend.pixi.HtmlUtils;
import haxe.ui.core.Component;
import haxe.ui.core.TextDisplay.TextDisplayData;
import haxe.ui.styles.Style;
import pixi.core.text.Text;

class TextDisplayImpl extends TextBase {

    public var textField:Text;
    
    public function new() {
        super();
        textField = new Text("");
        textField.style.fontSize = 13;
        textField.scale = new pixi.core.math.Point(1, 1);
    }

    //***********************************************************************************************************
    // Validation functions
    //***********************************************************************************************************

    private override function validateData() {
        textField.text = normalizeText(_text);
    }
    
    private override function validateStyle():Bool {
        if (_textStyle == null) {
            return false;
        }
        
        var measureTextRequired:Bool = false;
        
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
            parentComponent.invalidateComponentLayout();
        }

        if (_textStyle.fontSize != null) {
            textField.style.fontSize = _textStyle.fontSize;
            measureTextRequired = true;
        }
        
        if (textField.style.wordWrap != _displayData.wordWrap) {
            textField.style.wordWrap = _displayData.wordWrap;
            measureTextRequired = true;
        }

        if (textField.style.fontWeight != "bold" && _textStyle.fontBold == true) {
            textField.style.fontWeight = "bold";
        }
        
        if (textField.style.fontStyle != "italic" && _textStyle.fontItalic == true) {
            textField.style.fontStyle = "italic";
        }
        
        return measureTextRequired;
    }
    
    private override function validatePosition() {
        textField.x = _left;
        textField.y = _top;
    }
    
    private override function validateDisplay() {
        if (textField.width != _width && _width > 0) {
            textField.width = _width;
        }

        if (textField.height != _height && _height > 0) {
            textField.height = _height;
        }
        textField.scale = new pixi.core.math.Point(1, 1);
    }
    
    private override function measureText() {
        _textWidth = textField.width;
        _textHeight = textField.height;
    }
    
    private function normalizeText(text:String):String {
        if (text == null) {
            return text;
        }
        text = StringTools.replace(text, "\\n", "\n");
        return text;
    }
}
