package haxe.ui.backend;

import haxe.ui.backend.pixi.HtmlUtils;
import haxe.ui.styles.Style;
import pixi.core.text.Text;
import pixi.core.text.TextStyle;

class TextDisplayBase extends Text {

    public function new() {
        super("");
        scale = new pixi.core.math.Point(1, 1);
        //this.style.wordWrap = true;
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

    public function applyStyle(style:Style) {
        if (style.color != null) {
            this.style.fill = HtmlUtils.color(style.color);
        }
        if (style.fontName != null) {
            this.style.fontFamily = style.fontName;
        }
        if (style.fontSize != null) {
            this.style.fontSize = Std.parseFloat(style.fontSize);
        }
    }
}
