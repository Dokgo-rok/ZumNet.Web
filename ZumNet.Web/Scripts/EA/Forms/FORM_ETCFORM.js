$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            return true;
        },
        "make": function (f) {
            if (_zw.V.biz == "normal" && _zw.V.act == "_approver") {
                _zw.body.sub(f);
            }
        },
        "checkEvent": function (ckb, el, fld) {
        },
        "calc": function (el) {
        },
        "autoCalc": function (p) {
        }
    }
});