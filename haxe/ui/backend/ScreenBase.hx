package haxe.ui.backend;

import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.DialogButton;
import haxe.ui.core.Component;
import haxe.ui.core.UIEvent;
import haxe.ui.backend.pixi.EventMapper;
import pixi.core.display.Container;
import pixi.core.renderers.Detector;
import pixi.core.renderers.SystemRenderer;

class ScreenBase {
    private var _stage:Container;
    private var _renderer:SystemRenderer;
    private var _mapping:Map<String, UIEvent->Void>;

    public function new() {
        _mapping = new Map<String, UIEvent->Void>();
    }

    public var width(get, null):Float;
    public function get_width():Float {
        return renderer.width;
    }

    public var height(get, null):Float;
    public function get_height() {
        return renderer.height;
    }

    public var dpi(get, null):Float;
    private function get_dpi():Float {
        return 72;
    }

    public var options(get, set):ToolkitOptions;
    private function get_options():ToolkitOptions {
        return null;
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

    private function set_options(value:ToolkitOptions):ToolkitOptions {
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

    public var focus(get, set):Component;
    private function get_focus():Component {
        return null;
    }
    private function set_focus(value:Component):Component {
        return value;
    }

    public var title(get,set):String;
    private inline function get_title():String {
        return js.Browser.document.title;
    }
    private inline function set_title(s:String):String {
        js.Browser.document.title = s;
        return s;
    }

    public function addComponent(component:Component) {
        component.scale.set(Toolkit.scaleX, Toolkit.scaleY);
        resizeComponent(component);
        _stage.addChild(component);
    }

    public function removeComponent(component:Component) {
        _stage.removeChild(component);
    }

    private function resizeComponent(c:Component) {
        if (c.percentWidth > 0) {
            c.width = (this.width * c.percentWidth) / 100;
        }
        if (c.percentHeight > 0) {
            c.height = (this.height * c.percentHeight) / 100;
        }
    }

    private function handleSetComponentIndex(child:Component, index:Int) {

    }

    //***********************************************************************************************************
    // Dialogs
    //***********************************************************************************************************
    public function messageDialog(message:String, title:String = null, options:Dynamic = null, callback:DialogButton->Void = null):Dialog {
        return null;
    }

    public function showDialog(content:Component, options:Dynamic = null, callback:DialogButton->Void = null):Dialog {
        return null;
    }

    public function hideDialog(dialog:Dialog):Bool {
        return false;
    }

    //***********************************************************************************************************
    // Events
    //***********************************************************************************************************
    private function supportsEvent(type:String):Bool {
        return EventMapper.HAXEUI_TO_PIXI.get(type) != null;
    }

    private function mapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case haxe.ui.core.MouseEvent.MOUSE_MOVE
                    | haxe.ui.core.MouseEvent.MOUSE_OVER
                    | haxe.ui.core.MouseEvent.MOUSE_OUT
                    | haxe.ui.core.MouseEvent.MOUSE_DOWN
                    | haxe.ui.core.MouseEvent.MOUSE_UP
                    | haxe.ui.core.MouseEvent.CLICK:
                if (_mapping.exists(type) == false) {
                    _mapping.set(type, listener);
                    _stage.addListener(EventMapper.HAXEUI_TO_PIXI.get(type), __onMouseEvent);
                }
        }
    }

    private function unmapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case haxe.ui.core.MouseEvent.MOUSE_MOVE
                    | haxe.ui.core.MouseEvent.MOUSE_OVER
                    | haxe.ui.core.MouseEvent.MOUSE_OUT
                    | haxe.ui.core.MouseEvent.MOUSE_DOWN
                    | haxe.ui.core.MouseEvent.MOUSE_UP
                    | haxe.ui.core.MouseEvent.CLICK:
                _mapping.remove(type);
                _stage.removeListener(EventMapper.HAXEUI_TO_PIXI.get(type), __onMouseEvent);
        }
    }

    private function __onMouseEvent(event) {
        var type:String = EventMapper.PIXI_TO_HAXEUI.get(event.type);
        if (type != null) {
            var fn = _mapping.get(type);
            if (fn != null) {
                var mouseEvent = new haxe.ui.core.MouseEvent(type);
                mouseEvent.screenX = event.data.global.x / Toolkit.scaleX;
                mouseEvent.screenY = event.data.global.y / Toolkit.scaleY;
                fn(mouseEvent);
            }
        }
    }
}
