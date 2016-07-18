package haxe.ui.backend;

import haxe.ui.backend.pixi.HtmlUtils;
import pixi.core.text.Text;

class TextDisplayBase extends Text {
    private var _style:TextStyle = { };

    public function new() {
        super("");
        scale = new pixi.core.math.Point(1, 1);
        this.style = _style;
        this.fontName = "Tahoma";
        this.fontSize = 13;
    }

    public var textWidth(get, null):Float;
    private function get_textWidth():Float {
        return this.width;
    }

    public var textHeight(get, null):Float;
    private function get_textHeight():Float {
        return this.height;
    }

    public var left(get, set):Float;
    private function get_left():Float {
        return this.x;
    }
    private function set_left(value:Float):Float {
        this.x = value;
        return value;
    }

    public var top(get, set):Float;
    private function get_top():Float {
        return this.y;
    }
    private function set_top(value:Float):Float {
        this.y = value;
        return value;
    }

    public var color(get, set):Int;
    private function get_color():Int {
        return 0;// _style.fill;
    }
    private function set_color(value:Int):Int {
        _style.fill = HtmlUtils.color(value);
        this.style = _style;

        return value;
    }

    private var _fontName:String = "Tahoma";
    public var fontName(get, set):String;
    private function get_fontName():String {
        return _fontName;
    }
    private function set_fontName(value:String):String {
        _fontName = value;
        updateFont();
        return value;
    }

    private var _fontSize:Float = 13;
    public var fontSize(get, set):Null<Float>;
    private function get_fontSize():Null<Float> {
        return _fontSize;
    }
    private function set_fontSize(value:Null<Float>):Null<Float> {
        _fontSize = value;
        updateFont();
        return value;
    }

    private function updateFont() {
        _style.font = "normal " + HtmlUtils.px(_fontSize) + " " + _fontName;
        this.style = _style;
    }
}