package haxe.ui.backend;

import js.Browser;
import pixi.core.graphics.Graphics;
import pixi.core.renderers.Detector;
import pixi.core.renderers.Detector.RenderingOptions;
import pixi.core.renderers.SystemRenderer;
import pixi.core.renderers.canvas.CanvasRenderer;
import pixi.core.renderers.webgl.WebGLRenderer;

class AppBase {
    var _renderer:SystemRenderer;
    var _stage:Graphics;

    public function new() {
    }

    private function build() {
        var width:Int = Toolkit.backendProperties.getPropInt("haxe.ui.pixi.width", 800);
        var height:Int = Toolkit.backendProperties.getPropInt("haxe.ui.pixi.height", 600);

        _stage = new Graphics();
        _stage.beginFill(0xFFFFFF);
        _stage.drawRect(0, 0, width, height);
        _stage.endFill();

        var options:RenderingOptions = {};
        options.backgroundColor = parseCol(Toolkit.backendProperties.getProp("haxe.ui.pixi.background.color", "0xFFFFFF"));
        options.resolution = 1;

        //_renderer = Detector.autoDetectRenderer(width, height, options);
        //_renderer = new CanvasRenderer(width, height, options);
        //_renderer = new WebGLRenderer(width, height, options);
        _renderer = getRenderer();

        Browser.document.body.appendChild(_renderer.view);
        Browser.window.requestAnimationFrame(cast _render);
    }

    private function init(callback:Void->Void, onEnd:Void->Void = null) {
        callback();
    }

    function _render() {
        Browser.window.requestAnimationFrame(cast _render);
        _renderer.render(_stage);
    }

    private function getToolkitInit():Dynamic {
        return {
            stage: _stage,
            renderer: _renderer
        };
    }

    public function start() {

    }

    private static inline function parseCol(s:String):Int {
        if (StringTools.startsWith(s, "#")) {
            s = s.substring(1, s.length);
        } else if (StringTools.startsWith(s, "0x")) {
            s = s.substring(2, s.length);
        }
        return Std.parseInt("0xFF" + s);
    }

    private static inline function getRenderer():SystemRenderer {
        var width:Int = Toolkit.backendProperties.getPropInt("haxe.ui.pixi.width", 800);
        var height:Int = Toolkit.backendProperties.getPropInt("haxe.ui.pixi.height", 600);

        var renderer:SystemRenderer = null;
        var options:RenderingOptions = {};
        #if canvas
            renderer = new CanvasRenderer(width, height, options);
        #elseif webgl
            renderer = new WebGLRenderer(width, height, options);
        #else
            var r:String = Toolkit.backendProperties.getProp("haxe.ui.pixi.renderer", "auto");
            switch (r) {
                case "canvas":
                    renderer = new CanvasRenderer(width, height, options);
                case "webgl":
                    renderer = new WebGLRenderer(width, height, options);
                default:
                    renderer = Detector.autoDetectRenderer(width, height, options);
            }
        #end

        return renderer;
    }
}
