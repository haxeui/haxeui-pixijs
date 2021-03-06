package haxe.ui.backend;

import haxe.ui.core.TextInput.TextInputData;

class TextInputImpl extends TextDisplayImpl {
    public function new() {
        super();
    }
    
    private override function measureText() {
        super.measureText();
        
        _inputData.hscrollMax = _textWidth - _width;
        _inputData.hscrollPageSize = (_width * _inputData.hscrollMax) / _textWidth;
        
        _inputData.vscrollMax = _textHeight - _height;
        _inputData.vscrollPageSize = (_height * _inputData.vscrollMax) / _textHeight;
    }
}
