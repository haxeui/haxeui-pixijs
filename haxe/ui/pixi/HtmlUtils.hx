package haxe.ui.pixi;

class HtmlUtils {
    public static function px(value:Float) {
        return '${value}px';
    }

    public static function color(value:Int) {
        return '#${StringTools.hex(value, 6)}';
    }

}