package haxe.ui.core;

import haxe.ui.core.Component;
import haxe.ui.core.ImageDisplay;
import haxe.ui.core.MouseEvent;
import haxe.ui.core.TextDisplay;
import haxe.ui.core.TextInput;
import haxe.ui.core.UIEvent;
import haxe.ui.pixi.EventMapper;
import haxe.ui.pixi.HaxeUIPixiGraphics;
import haxe.ui.pixi.PixiStyleHelper;
import haxe.ui.styles.Style;
import haxe.ui.util.Rectangle;
import pixi.core.display.DisplayObject;
import pixi.core.graphics.Graphics;

class ComponentBase extends HaxeUIPixiGraphics {
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
        component.invalidateStyle();
        component.invalidateLayout();
        for (child in component.childComponents) {
            child.recursiveReady();
        }
    }

    private function handleCreate(native:Bool):Void {
        this.addListener("added", onAdded);
    }

    private function handlePosition(left:Null<Float>, top:Null<Float>, style:Style):Void {
        if (left != null) {
            this.x = left;
        }
        if (top != null) {
            this.y = top;
        }
    }

    private function handleSize(width:Null<Float>, height:Null<Float>, style:Style) {
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
            this.setChildIndex(_textDisplay, n);
            n++;
        } else if (hasTextInput() == true) {
            this.setChildIndex(_textInput, n);
            n++;
        }

        if (hasImageDisplay() == true) {
            this.setChildIndex(_imageDisplay, n);
            n++;
        }

        if (_mask != null) {
            this.setChildIndex(_mask, n);
        }

    }

    private var _mask:Graphics;
    private function handleClipRect(value:Rectangle):Void {
        if (value != null) {
            this.x = -value.left + 1;
            this.y = -value.top + 1;
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

    private function handleReady() {

    }

    private function handlePreReposition() {

    }

    private function handlePostReposition() {

    }

    //***********************************************************************************************************
    // Text related
    //***********************************************************************************************************
    private var _textDisplay:TextDisplay;
    public function createTextDisplay(text:String = null):TextDisplay {
        if (_textDisplay == null) {
            _textDisplay = new TextDisplay();
            _textDisplay.name = "text-display";
            addChild(_textDisplay);
        }
        if (text != null) {
            _textDisplay.text = text;
        }
        //_textDisplay.scale = new pixi.core.math.Point(1, 1);
        return _textDisplay;
    }

    public function getTextDisplay():TextDisplay {
        return createTextDisplay();
    }

    public function hasTextDisplay():Bool {
        return (_textDisplay != null);
    }

    private var _textInput:TextInput;
    public function createTextInput(text:String = null):TextInput {
        if (_textInput == null) {
            _textInput = new TextInput();
            _textInput.name = "text-input";
            addChild(_textInput);
        }
        if (text != null) {
            _textInput.text = text;
        }
        return _textInput;
    }

    public function getTextInput():TextInput {
        return createTextInput();
    }

    public function hasTextInput():Bool {
        return (_textInput != null);
    }

    //***********************************************************************************************************
    // Image related
    //***********************************************************************************************************
    private var _imageDisplay:ImageDisplay;
    public function createImageDisplay():ImageDisplay {
        if (_imageDisplay == null) {
            _imageDisplay = new ImageDisplay();
            _imageDisplay.name = "image-display";
            addChild(_imageDisplay);
        }
        /*
        if (resource != null) {
            _imageDisplay.update(resource, type);
        }
        */
        return _imageDisplay;
    }

    public function getImageDisplay():ImageDisplay {
        return createImageDisplay();
    }

    public function hasImageDisplay():Bool {
        return (_imageDisplay != null);
    }


    public function removeImageDisplay():Void {
        if (_imageDisplay != null) {
            if (getChildIndex(_imageDisplay) > -1) {
                removeChild(_imageDisplay);
            }
            _imageDisplay.dispose();
            _imageDisplay = null;
        }
    }

    //***********************************************************************************************************
    // Display tree
    //***********************************************************************************************************
    private function handleAddComponent(child:Component):Component {
        addChild(child);
        return child;
    }

    private function handleRemoveComponent(child:Component, dispose:Bool = true):Component {
        removeChild(child);
        return child;
    }

    private function handleVisibility(show:Bool):Void {
        this.visible = show;
    }

    private function applyStyle(style:Style) {
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
    private function mapEvent(type:String, listener:UIEvent->Void) {
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

    private function unmapEvent(type:String, listener:UIEvent->Void) {
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
                var mouseEvent = new haxe.ui.core.MouseEvent(type);
                mouseEvent.screenX = event.data.global.x;
                mouseEvent.screenY = event.data.global.y;
                fn(mouseEvent);
            }
        }
    }
}