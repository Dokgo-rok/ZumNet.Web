$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            return true;
        },
        "make": function (f) {
            if (_zw.V.biz == "receive" && _zw.V.act == "__r") _zw.body.sub(f);
        },
        "checkEvent": function (ckb, el, fld) {
        },
        "calc": function (e) {
        },
        "autoCalc": function (p) {
        }
    }
});