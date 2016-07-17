package haxe.ui.pixi;

import haxe.ui.Toolkit;
import haxe.ui.assets.ImageInfo;
import haxe.ui.styles.Style;
import haxe.ui.util.Rectangle;
import haxe.ui.util.Slice9;
import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasGradient;
import js.html.CanvasRenderingContext2D;
import js.html.Image;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;

class PixiStyleHelper {
    public function new() {

    }

    public function paintStyleSection(graphics:HaxeUIPixiGraphics, style:Style, width:Float, height:Float, left:Float = 0, top:Float = 0, clear:Bool = true) {
        if (clear == true) {
            graphics.clear();
        }

        var rc:Rectangle = new Rectangle(top, left, width, height);
        if (rc.width == 0 || rc.height == 0) {
            return;
        }

        var borderRadius:Float = 0;

        if (style.borderRadius != null) {
            borderRadius = style.borderRadius;
        }

        var borderSize:Rectangle = new Rectangle();
        if (style.borderLeftSize != null
            && style.borderLeftSize == style.borderRightSize
            && style.borderLeftSize == style.borderBottomSize
            && style.borderLeftSize == style.borderTopSize

            && style.borderLeftColor != null
            && style.borderLeftColor == style.borderRightColor
            && style.borderLeftColor == style.borderBottomColor
            && style.borderLeftColor == style.borderTopColor) {
                graphics.lineStyle(style.borderLeftSize, style.borderLeftColor);
                borderSize.left = style.borderLeftSize;
                borderSize.top = style.borderLeftSize;
                borderSize.bottom = style.borderLeftSize;
                borderSize.right = style.borderLeftSize;
        } else {
            if ((style.borderTopSize != null && style.borderTopSize > 0)
                || (style.borderBottomSize != null && style.borderBottomSize > 0)
                || (style.borderLeftSize != null && style.borderLeftSize > 0)
                || (style.borderRightSize != null && style.borderRightSize > 0)) {

                if (style.borderTopSize != null && style.borderTopSize > 0) {
                    graphics.beginFill(style.borderTopColor);
                    graphics.drawRect(0, 0, rc.width, 1);
                    graphics.endFill();

                    borderSize.top = 1;
                    rc.top += 1;
                }

                if (style.borderBottomSize != null && style.borderBottomSize > 0) {
                    graphics.beginFill(style.borderBottomColor);
                    graphics.beginFill(style.borderBottomColor);
                    graphics.drawRect(0, height - 1, rc.width, 1);
                    graphics.endFill();

                    borderSize.bottom = 1;
                    rc.bottom -= 1;
                }

                if (style.borderLeftSize != null && style.borderLeftSize > 0) {
                    graphics.beginFill(style.borderLeftColor);
                    graphics.drawRect(0, 0, 1, rc.height + 1);
                    graphics.endFill();

                    borderSize.left = 1;
                    rc.left += 1;
                }

                if (style.borderRightSize != null && style.borderRightSize > 0) {
                    graphics.beginFill(style.borderRightColor);
                    graphics.drawRect(rc.width, 0, 1, rc.height + 1);
                    graphics.endFill();

                    borderSize.right = 1;
                    rc.right -= 1;
                }
            }
        }

        if (Toolkit.screen.isCanvas == true) {
            rc.left += borderSize.left * 0.5;
            rc.top += borderSize.top * 0.5;
            rc.width -= borderSize.right;
            rc.height -= borderSize.bottom;
        }

        if (borderRadius >= rc.height) {
            borderRadius = Math.fceil(rc.height / 2);
        } else if (borderRadius > 2) {
            //trace(borderRadius);
            borderRadius--;
        }

        if (style.backgroundColor != null) {
            if (style.backgroundColorEnd != null && style.backgroundColor != style.backgroundColorEnd) {
                graphics.beginFill(style.backgroundColor, 1);

                if (Toolkit.screen.isCanvas == true) { // probably not very effecient
                    for (c in graphics.children) {
                        if (c.name == "gradient-fill") {
                            graphics.removeChild(c);
                            c = null;
                            break;
                        }
                    }

                    var canvas:CanvasElement = Browser.document.createCanvasElement();
                    var cx:Int = cast rc.width + (borderSize.left + borderSize.right);
                    var cy:Int = cast rc.height + (borderSize.top + borderSize.bottom);
                    canvas.width = cast rc.width - 1;
                    canvas.height = cast rc.height - 1;

                    var ctx:CanvasRenderingContext2D = canvas.getContext2d();
                    var gradient:CanvasGradient = null;
                    if (style.backgroundGradientStyle == "vertical") {
                        gradient = ctx.createLinearGradient(0, 0, 0, rc.height);
                    } else if (style.backgroundGradientStyle == "horizontal") {
                        gradient = ctx.createLinearGradient(0, 0, rc.width, 0);
                    } else {
                        gradient = ctx.createLinearGradient(0, 0, 0, rc.height);
                    }

                    gradient.addColorStop(0, "#" + StringTools.hex(style.backgroundColor, 6));
                    gradient.addColorStop(1, "#" + StringTools.hex(style.backgroundColorEnd, 6));
                    ctx.fillStyle = gradient;
                    drawRoundRect(ctx, 0, 0, canvas.width, canvas.height, borderRadius);
                    ctx.fill();

                    var t:Texture = Texture.fromCanvas(canvas);
                    var s:Sprite = new Sprite(t);
                    s.name = "gradient-fill";
                    s.x = 1;
                    s.y = 1;

                    graphics.addChildAt(s, 0);
                }
            } else {
                if (Toolkit.screen.isCanvas == true) {
                    for (c in graphics.children) {
                        if (c.name == "gradient-fill") {
                            graphics.removeChild(c);
                            c = null;
                            break;
                        }
                    }
                }

                graphics.beginFill(style.backgroundColor, 1);
            }
        }

        if (borderRadius == 0) {
            graphics.drawRect(rc.left, rc.top, rc.width, rc.height);
        } else {
            graphics.drawRoundedRect(rc.left, rc.top, rc.width, rc.height, borderRadius);
        }

        graphics.endFill();

        if (style.backgroundImage != null) {
            Toolkit.assets.getImage(style.backgroundImage, function(imageInfo:ImageInfo) {
                if (imageInfo == null) {
                    return;
                }

                for (c in graphics.children) {
                    if (c.name == "background-sprite") {
                        graphics.removeChild(c);
                        c = null;
                        break;
                    }
                }

                var c = Browser.document.createCanvasElement();
                var ctx = c.getContext("2d");
                c.width = imageInfo.width;
                c.height = imageInfo.height;
                ctx.drawImage(imageInfo.data.baseTexture.source, 0, 0);

                var imageRect:Rectangle = new Rectangle(0, 0, imageInfo.width, imageInfo.height);
                if (style.backgroundImageClipTop != null
                    && style.backgroundImageClipLeft != null
                    && style.backgroundImageClipBottom != null
                    && style.backgroundImageClipRight != null) {
                        imageRect = new Rectangle(style.backgroundImageClipLeft,
                                                  style.backgroundImageClipTop,
                                                  style.backgroundImageClipRight - style.backgroundImageClipLeft,
                                                  style.backgroundImageClipBottom - style.backgroundImageClipTop);
                }

                var slice:Rectangle = null;
                if (style.backgroundImageSliceTop != null
                    && style.backgroundImageSliceLeft != null
                    && style.backgroundImageSliceBottom != null
                    && style.backgroundImageSliceRight != null) {
                    slice = new Rectangle(style.backgroundImageSliceLeft,
                                          style.backgroundImageSliceTop,
                                          style.backgroundImageSliceRight - style.backgroundImageSliceLeft,
                                          style.backgroundImageSliceBottom - style.backgroundImageSliceTop);
                }

                if (slice == null) {
                    if (style.backgroundImageRepeat == null) {
                        // TODO: placeholder
                    } else if (style.backgroundImageRepeat == "repeat") {
                        // TODO: placeholder
                    } else if (style.backgroundImageRepeat == "stretch") {
                        // TODO: placeholder
                    }

                    var texture:Texture = Texture.fromCanvas(c);
                    var backgroundSprite:Sprite = new Sprite(texture);
                    backgroundSprite.name = "background-sprite";
                    graphics.addChildAt(backgroundSprite, 0);
                } else {
                    var rects:Slice9Rects = Slice9.buildRects(width, height, imageRect.width, imageRect.height, slice);
                    var srcRects:Array<Rectangle> = rects.src;
                    var dstRects:Array<Rectangle> = rects.dst;

                    var canvas:CanvasElement = Browser.document.createCanvasElement();
                    canvas.width = cast width;
                    canvas.height = cast height;
                    var ctx:CanvasRenderingContext2D = canvas.getContext2d();

                    for (i in 0...srcRects.length) {
                        var srcRect = new Rectangle(srcRects[i].left + imageRect.left,
                                                    srcRects[i].top + imageRect.top,
                                                    srcRects[i].width,
                                                    srcRects[i].height);
                        var dstRect = dstRects[i];
                        paintBitmap(ctx, cast imageInfo.data.baseTexture.source, srcRect, dstRect);
                    }

                    var texture:Texture = Texture.fromCanvas(canvas);
                    var backgroundSprite:Sprite = new Sprite(texture);
                    backgroundSprite.name = "background-sprite";
                    graphics.addChildAt(backgroundSprite, 0);
                }

            });
        }
    }

    private function paintBitmap(ctx:CanvasRenderingContext2D, img:Image, srcRect:Rectangle, dstRect:Rectangle) {
        ctx.drawImage(img, srcRect.left, srcRect.top, srcRect.width, srcRect.height, dstRect.left, dstRect.top, dstRect.width, dstRect.height);
    }

    private static inline function drawRoundRect(ctx:CanvasRenderingContext2D, x:Float, y:Float, width:Float, height:Float, radius:Float) {
        ctx.beginPath();
        ctx.moveTo(x + radius, y);
        ctx.lineTo(x + width - radius, y);
        ctx.quadraticCurveTo(x + width, y, x + width, y + radius);
        ctx.lineTo(x + width, y + height - radius);
        ctx.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
        ctx.lineTo(x + radius, y + height);
        ctx.quadraticCurveTo(x, y + height, x, y + height - radius);
        ctx.lineTo(x, y + radius);
        ctx.quadraticCurveTo(x, y, x + radius, y);
        ctx.closePath();
    }
}
