package haxe.ui.backend.pixi;

class EventMapper {
    public static var PIXI_TO_HAXEUI:Map<String, String> = [
        "mousemove" => haxe.ui.events.MouseEvent.MOUSE_MOVE,
        "mouseover" => haxe.ui.events.MouseEvent.MOUSE_OVER,
        "mouseout" => haxe.ui.events.MouseEvent.MOUSE_OUT,
        "mousedown" => haxe.ui.events.MouseEvent.MOUSE_DOWN,
        "mouseup" => haxe.ui.events.MouseEvent.MOUSE_UP,
        "click" => haxe.ui.events.MouseEvent.CLICK
    ];

    public static var HAXEUI_TO_PIXI:Map<String, String> = [
        haxe.ui.events.MouseEvent.MOUSE_MOVE => "mousemove",
        haxe.ui.events.MouseEvent.MOUSE_OVER => "mouseover",
        haxe.ui.events.MouseEvent.MOUSE_OUT => "mouseout",
        haxe.ui.events.MouseEvent.MOUSE_DOWN => "mousedown",
        haxe.ui.events.MouseEvent.MOUSE_UP => "mouseup",
        haxe.ui.events.MouseEvent.CLICK => "click"
    ];
}