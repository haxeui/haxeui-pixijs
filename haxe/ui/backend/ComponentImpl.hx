package haxe.ui.backend;

import haxe.ui.core.Component;
import haxe.ui.core.ImageDisplay;
import haxe.ui.core.TextDisplay;
import haxe.ui.core.TextInput;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import haxe.ui.backend.pixi.EventMapper;
import haxe.ui.backend.pixi.HaxeUIPixiGraphics;
import haxe.ui.backend.pixi.PixiStyleHelper;
import haxe.ui.styles.Style;
import haxe.ui.geom.Rectangle;
import pixi.core.display.DisplayObject;
import pixi.core.graphics.Graphics;

class ComponentImpl extends ComponentBase {
    private var _eventMap:Map<String, UIEvent->Void>;

    public function new() {
        super();
        _eventMap = new Map<String, UIEvent->Void>();
        interactive = true;
        this.interactiveChildren = true;
    }

    private function onAdded(event) {
        recursiveReady();
    }

    private function recursiveReady() {
        this.removeListener("added", onAdded);
        var component:Component = cast(this, Component);
        component.ready();
        component.invalidateComponentStyle();
        component.invalidateComponentLayout();
        for (child in component.childComponents) {
            child.recursiveReady();
        }
    }

    private override function handleCreate(native:Bool):Void {
        this.addListener("added", onAdded);
    }

    private override function handlePosition(left:Null<Float>, top:Null<Float>, style:Style):Void {
        if (left != null) {
            this.x = left;
        }
        if (top != null) {
            this.y = top;
        }
    }

    private override function handleSize(width:Null<Float>, height:Null<Float>, style:Style) {
        if (width == null || height == null || width == 0 || height == 0) {
            return;
        }

        new PixiStyleHelper().paintStyleSection(this, style, width, height);
        var n = 0;
        var gradientFill = this.getChildByName("gradient-fill");
        var backgroundSprite = this.getChildByName("background-sprite");

        if (gradientFill != null) {
            this.setChildIndex(gradientFill, n);
            n++;
        }
        if (backgroundSprite != null) {
            this.setChildIndex(backgroundSprite, n);
            n++;
        }
        if (hasTextDisplay() == true) {
            this.setChildIndex(_textDisplay.textField, n);
            n++;
        } else if (hasTextInput() == true) {
            this.setChildIndex(_textInput.textField, n);
            n++;
        }

        if (hasImageDisplay() == true) {
            this.setChildIndex(_imageDisplay.sprite, n);
            n++;
        }

        if (_mask != null) {
            this.setChildIndex(_mask, n);
        }

    }

    private var _mask:Graphics;
    private override function handleClipRect(value:Rectangle):Void {
        if (value != null) {
            this.x = -value.left;
            this.y = -value.top;
            if (_mask == null) {
                _mask = new Graphics();
                addChild(_mask);
                this.mask = _mask;
            }

            _mask.clear();
            _mask.beginFill(0xFF00FF);
            _mask.drawRect(0, 0, value.width, value.height);
            _mask.endFill();
            _mask.x = value.left;
            _mask.y = value.top;
        } else {
            removeChild(_mask);
            this.mask = null;
        }
    }

    //***********************************************************************************************************
    // Text related
    //***********************************************************************************************************
    public override function createTextDisplay(text:String = null):TextDisplay {
        if (_textDisplay == null) {
            _textDisplay = new TextDisplay();
            _textDisplay.parentComponent = cast this;
            _textDisplay.textField.name = "text-display";
            addChild(_textDisplay.textField);
        }
        if (text != null) {
            _textDisplay.text = text;
        }
        //_textDisplay.scale = new pixi.core.math.Point(1, 1);
        return _textDisplay;
    }

    public override function createTextInput(text:String = null):TextInput {
        if (_textInput == null) {
            _textInput = new TextInput();
            _textInput.parentComponent = cast this;
            _textInput.textField.name = "text-input";
            addChild(_textInput.textField);
        }
        if (text != null) {
            _textInput.text = text;
        }
        return _textInput;
    }

    //***********************************************************************************************************
    // Image related
    //***********************************************************************************************************
    public override function createImageDisplay():ImageDisplay {
        if (_imageDisplay == null) {
            _imageDisplay = new ImageDisplay();
            _imageDisplay.sprite.name = "image-display";
            addChild(_imageDisplay.sprite);
        }
        /*
        if (resource != null) {
            _imageDisplay.update(resource, type);
        }
        */
        return _imageDisplay;
    }

    public override function removeImageDisplay():Void {
        if (_imageDisplay != null) {
            if (getChildIndex(_imageDisplay.sprite) > -1) {
                removeChild(_imageDisplay.sprite);
            }
            _imageDisplay.dispose();
            _imageDisplay = null;
        }
    }

    //***********************************************************************************************************
    // Display tree
    //***********************************************************************************************************
    private override function handleAddComponent(child:Component):Component {
        addChild(child);
        return child;
    }

    private override function handleAddComponentAt(child:Component, index:Int):Component {
        addChildAt(child, index);
        return child;
    }

    private override function handleRemoveComponent(child:Component, dispose:Bool = true):Component {
        removeChild(child);
        return child;
    }

    private override function handleRemoveComponentAt(index:Int, dispose:Bool = true):Component {
        removeChildAt(index);
        return null;
    }

    private override function handleVisibility(show:Bool):Void {
        this.visible = show;
    }

    private override function applyStyle(style:Style) {
        var useHandCursor = false;
        if (style.cursor != null && style.cursor == "pointer") {
            useHandCursor = true;
        }

        this.buttonMode = useHandCursor;
        this.defaultCursor = useHandCursor ? "pointer" : "default";
        //this.interactive = useHandCursor;
        for (n in 0...this.children.length) {
            var c = this.getChildAt(n);
            if (Std.is(c, DisplayObject)) {
                cast(c, DisplayObject).buttonMode = useHandCursor;
                cast(c, DisplayObject).defaultCursor = useHandCursor ? "pointer" : "default";
            }
        }
    }

    //***********************************************************************************************************
    // Events
    //***********************************************************************************************************
    private override function mapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_MOVE | MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT
                | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP | MouseEvent.CLICK:

                interactive = true;
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    addListener(EventMapper.HAXEUI_TO_PIXI.get(type), __onMouseEvent);
                }
            case UIEvent.RESIZE:
                if (_eventMap.exists(UIEvent.RESIZE) == false) {
                    _eventMap.set(UIEvent.RESIZE, listener);
                }
        }
    }

    private override function unmapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.MOUSE_MOVE | MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT
                | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP | MouseEvent.CLICK:
                _eventMap.remove(type);
                removeListener(EventMapper.HAXEUI_TO_PIXI.get(type), __onMouseEvent);

            case UIEvent.RESIZE:
                _eventMap.remove(type);
        }

    }

    //***********************************************************************************************************
    // Event handlers
    //***********************************************************************************************************
    private function __onMouseEvent(event) {
        var type:String = EventMapper.PIXI_TO_HAXEUI.get(event.type);
        if (type != null) {
            var fn = _eventMap.get(type);
            if (fn != null) {
                var mouseEvent = new haxe.ui.events.MouseEvent(type);
                mouseEvent.screenX = event.data.global.x / Toolkit.scaleX;
                mouseEvent.screenY = event.data.global.y / Toolkit.scaleY;
                fn(mouseEvent);
            }
        }
    }
}