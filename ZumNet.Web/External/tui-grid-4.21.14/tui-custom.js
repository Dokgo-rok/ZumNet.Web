var _createClass = function() {
    function defineProperties(target, props) {
        for (var i = 0; i < props.length; i++) {
            var descriptor = props[i];
            descriptor.enumerable = descriptor.enumerable || false;
            descriptor.configurable = true;
            if ("value" in descriptor) descriptor.writable = true;
            Object.defineProperty(target, descriptor.key, descriptor);
        }
    }
    return function(Constructor, protoProps, staticProps) {
        if (protoProps) defineProperties(Constructor.prototype, protoProps);
        if (staticProps) defineProperties(Constructor, staticProps);
        return Constructor;
    };
}();

function _classCallCheck(instance, Constructor) {
    if (!(instance instanceof Constructor)) {
        throw new TypeError("Cannot call a class as a function");
    }
}

var CustomTextEditor = function() {
    function CustomTextEditor(props) {
        _classCallCheck(this, CustomTextEditor);

        var el = document.createElement('input');
        var maxLength = props.columnInfo.editor.options.maxLength;

        el.type = 'text';
        el.maxLength = maxLength;
        if (props.columnInfo.editor.options.inputmask) { 
            el.setAttribute("data-inputmask", props.columnInfo.editor.options.inputmask);
        }
        el.value = props && props.value ? String(props.value) : '';

        if (props.columnInfo.editor.options.inputmask) { _zw.fn.input(el); }
        //if (props.columnInfo.editor.options.event) { _ZF.fn.addEvent(el, props.columnInfo.editor.options.event); }
        
        this.el = el;
    }

    _createClass(CustomTextEditor, [{
        key: 'getElement',
        value: function getElement() {
            return this.el;
        }
    }, {
        key: 'getValue',
        value: function getValue() {
            return this.el.value;
        }
    }, {
        key: 'mounted',
        value: function mounted() {
            this.el.select();
        }
    }]);

    return CustomTextEditor;
}();