package haxe.ui.pixi;

class EventMapper {
    public static var PIXI_TO_HAXEUI:Map<String, String> = [
        "mousemove" => haxe.ui.core.MouseEvent.MOUSE_MOVE,
        "mouseover" => haxe.ui.core.MouseEvent.MOUSE_OVER,
        "mouseout" => haxe.ui.core.MouseEvent.MOUSE_OUT,
        "mousedown" => haxe.ui.core.MouseEvent.MOUSE_DOWN,
        "mouseup" => haxe.ui.core.MouseEvent.MOUSE_UP,
        "click" => haxe.ui.core.MouseEvent.CLICK
    ];

    public static var HAXEUI_TO_PIXI:Map<String, String> = [
        haxe.ui.core.MouseEvent.MOUSE_MOVE => "mousemove",
        haxe.ui.core.MouseEvent.MOUSE_OVER => "mouseover",
        haxe.ui.core.MouseEvent.MOUSE_OUT => "mouseout",
        haxe.ui.core.MouseEvent.MOUSE_DOWN => "mousedown",
        haxe.ui.core.MouseEvent.MOUSE_UP => "mouseup",
        haxe.ui.core.MouseEvent.CLICK => "click"
    ];
}