package haxe.ui.backend;

import haxe.ui.core.Component;
import haxe.ui.events.UIEvent;
import haxe.ui.backend.pixi.EventMapper;
import pixi.core.display.Container;
import pixi.core.renderers.Detector;
import pixi.core.renderers.SystemRenderer;

class ScreenImpl extends ScreenBase {
    private var _stage:Container;
    private var _renderer:SystemRenderer;
    private var _mapping:Map<String, UIEvent->Void>;

    public function new() {
        _mapping = new Map<String, UIEvent->Void>();
    }

    public override function get_width():Float {
        return renderer.width;
    }

    public override function get_height() {
        return renderer.height;
    }

    private override function get_dpi():Float {
        return 72;
    }

    public var renderer(get, null):SystemRenderer;
    public function get_renderer():SystemRenderer {
        if (_renderer == null) {
            _renderer = Detector.autoDetectRenderer(null, 0, 0);
        }
        return _renderer;
    }

    public var isCanvas(get, null):Bool;
    private function get_isCanvas():Bool {
        return Std.is(renderer, pixi.core.renderers.canvas.CanvasRenderer);
    }

    private override function set_options(value:ToolkitOptions):ToolkitOptions {
        if (value != null && value.stage != null) {
            _stage = value.stage;
            _stage.interactive = true;
            _stage.interactiveChildren = true;
        }
        if (value != null && value.renderer != null) {
            _renderer = value.renderer;
        }
        return value;
    }

    private override function get_title():String {
        return js.Browser.document.title;
    }
    private override function set_title(s:String):String {
        js.Browser.document.title = s;
        return s;
    }

    public override function addComponent(component:Component):Component {
        component.scale.set(Toolkit.scaleX, Toolkit.scaleY);
        resizeComponent(component);
        _stage.addChild(component);
		return component;
    }

    public override function removeComponent(component:Component):Component {
        _stage.removeChild(component);
		return component;
    }

    private override function resizeComponent(c:Component) {
        if (c.percentWidth > 0) {
            c.width = (this.width * c.percentWidth) / 100;
        }
        if (c.percentHeight > 0) {
            c.height = (this.height * c.percentHeight) / 100;
        }
    }

    //***********************************************************************************************************
    // Events
    //***********************************************************************************************************
    private override function supportsEvent(type:String):Bool {
        return EventMapper.HAXEUI_TO_PIXI.get(type) != null;
    }

    private override function mapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case haxe.ui.events.MouseEvent.MOUSE_MOVE
                    | haxe.ui.events.MouseEvent.MOUSE_OVER
                    | haxe.ui.events.MouseEvent.MOUSE_OUT
                    | haxe.ui.events.MouseEvent.MOUSE_DOWN
                    | haxe.ui.events.MouseEvent.MOUSE_UP
                    | haxe.ui.events.MouseEvent.CLICK:
                if (_mapping.exists(type) == false) {
                    _mapping.set(type, listener);
                    _stage.addListener(EventMapper.HAXEUI_TO_PIXI.get(type), __onMouseEvent);
                }
        }
    }

    private override function unmapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case haxe.ui.events.MouseEvent.MOUSE_MOVE
                    | haxe.ui.events.MouseEvent.MOUSE_OVER
                    | haxe.ui.events.MouseEvent.MOUSE_OUT
                    | haxe.ui.events.MouseEvent.MOUSE_DOWN
                    | haxe.ui.events.MouseEvent.MOUSE_UP
                    | haxe.ui.events.MouseEvent.CLICK:
                _mapping.remove(type);
                _stage.removeListener(EventMapper.HAXEUI_TO_PIXI.get(type), __onMouseEvent);
        }
    }

    private function __onMouseEvent(event) {
        var type:String = EventMapper.PIXI_TO_HAXEUI.get(event.type);
        if (type != null) {
            var fn = _mapping.get(type);
            if (fn != null) {
                var mouseEvent = new haxe.ui.events.MouseEvent(type);
                mouseEvent.screenX = event.data.global.x / Toolkit.scaleX;
                mouseEvent.screenY = event.data.global.y / Toolkit.scaleY;
                fn(mouseEvent);
            }
        }
    }
}
