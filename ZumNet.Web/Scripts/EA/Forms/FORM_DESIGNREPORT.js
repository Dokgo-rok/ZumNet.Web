$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            return true;
        },
        "make": function (f) {
        },
        "checkEvent": function (ckb, el, fld) {
        },
        "calc": function (el) {
        },
        "autoCalc": function (p) {
        },
        "change": function (x) {
	        if (x.value == 'IDEA기술보고서') {
                $('#panDisplay1').hide();
                $('#panDisplay2').hide();
                $('#panDisplay3').show();
            } else {
                $('#panDisplay1').show();
                $('#panDisplay2').show();
                $('#panDisplay3').hide();
            }
        },
    }
});