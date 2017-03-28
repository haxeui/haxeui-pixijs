<p align="center">
  <img src="http://haxeui.org/db/haxeui2-warning.png"/>
</p>

[![Build Status](https://travis-ci.org/haxeui/haxeui-pixijs.svg?branch=master)](https://travis-ci.org/haxeui/haxeui-pixijs)
[![Support this project on Patreon](http://haxeui.org/db/patreon_button.png)](https://www.patreon.com/haxeui)

# haxeui-pixijs
`haxeui-pixijs` is the `PixiJS` backend for HaxeUI.

<p align="center">
	<img src="https://github.com/haxeui/haxeui-pixijs/raw/master/screen.png" />
</p>


## Installation
 * `haxeui-pixijs` has a dependency to <a href="https://github.com/haxeui/haxeui-core">`haxeui-core`</a>, and so that too must be installed.
 * `haxeui-pixijs` also has a dependency to <a href="https://github.com/pixijs/pixi-haxe">pixi-haxe</a> (the `PixiJS` Haxe externs), please refer to the installation instructions on their <a href="https://github.com/pixijs/pixi-haxe">site</a>.
 * You will also need a copy of the `PixiJS` JavaScript libraries which can be obtained <a href="http://www.pixijs.com/">here</a>. (_Note: if you are using <a href="https://github.com/haxeui/haxeui-templates">haxeui-templates</a> the library is included automatically for you_)

Eventually all these libs will become haxelibs, however, currently in their alpha form they do not even contain a `haxelib.json` file (for dependencies, etc) and therefore can only be used by downloading the source and using the `haxelib dev` command or by directly using the git versions using the `haxelib git` command (recommended). Eg:

```
haxelib git haxeui-core https://github.com/haxeui/haxeui-core
haxelib dev haxeui-pixijs path/to/expanded/source/archive
```

## Usage
The simplest method to create a new `PixiJS` application that is HaxeUI ready is to use one of the <a href="https://github.com/haxeui/haxeui-templates">haxeui-templates</a>. These templates will allow you to start a new project rapidly with HaxeUI support baked in. 

If however you already have an existing application, then incorporating HaxeUI into that application is straightforward:

### haxelibs
As well as the `haxeui-core` and `haxeui-pixijs` haxelibs, you must also include (in either the IDE or your `.hxml`) the haxelib `pixijs`.

### Toolkit initialisation and usage
The `PixiJS` system itself must be initialised and a render loop started. This can be done by using code similar to:

```haxe
private static function initPixi() {
	_stage = new Graphics();
    var options:RenderingOptions = {};
    _renderer = Detector.autoDetectRenderer(width, height, options);
	
    Browser.document.body.appendChild(_renderer.view);
    Browser.window.requestAnimationFrame(cast _render);
}

private static function _render() {
    Browser.window.requestAnimationFrame(cast _render);
    _renderer.render(_stage);
}
```

Initialising the toolkit requires you to add these lines somewhere _before_ you start to actually use HaxeUI in your application and _after_ `PixiJS` has been initialised:

```haxe
Toolkit.init({
	stage: _stage,      // the default place 'Screen' will place objects
	renderer: _renderer // the renderer that is being used
});
```

Once the toolkit is initialised you can add components using the methods specified <a href="https://github.com/haxeui/haxeui-core#adding-components-using-haxe-code">here</a>.

## PixiJS specifics

As well as using the generic `Screen.instance.addComponent`, it is also possible to add components directly using a `PixiJS` display container. Eg:

```haxe
_stage = new Graphics();
_stage.addChild(main);
```

### Initialisation options
The configuration options that may be passed to `Tookit.init()` are as follows:

```haxe
Toolkit.init({
	stage: _stage,      // the default place 'Screen' will place objects
	renderer: _renderer // the renderer that is being used
});
```


## Addtional resources
* <a href="http://haxeui.github.io/haxeui-api/">haxeui-api</a> - The HaxeUI api docs.
* <a href="https://github.com/haxeui/haxeui-guides">haxeui-guides</a> - Set of guides to working with HaxeUI and backends.
* <a href="https://github.com/haxeui/haxeui-demo">haxeui-demo</a> - Demo application written using HaxeUI.
* <a href="https://github.com/haxeui/haxeui-templates">haxeui-templates</a> - Set of templates for IDE's to allow quick project creation.
* <a href="https://github.com/haxeui/haxeui-bdd">haxeui-bdd</a> - A behaviour driven development engine written specifically for HaxeUI (uses <a href="https://github.com/haxeui/haxe-bdd">haxe-bdd</a> which is a gherkin/cucumber inspired project).
* <a href="https://www.youtube.com/watch?v=L8J8qrR2VSg&feature=youtu.be">WWX2016 presentation</a> - A presentation given at WWX2016 regarding HaxeUI.

