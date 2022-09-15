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
            if (el.name == "DEFECTIVEQUANTITY" || el.name == "TOTALQUANTITY") {
                var e1 = $('#__mainfield[name="TOTALQUANTITY"]'), e2 = $('#__mainfield[name="DEFECTIVEQUANTITY"]'), e3 = $('#__mainfield[name="TOTALDEFECTIVE"]');
                if (e1.val() == '0') {
                    e2.val('0'); e3.val('0');
                } else if (e1.val() != '' && e2.val() != '') {
                    var s = _zw.ut.rate(e2.val(), e1.val(), 2);
                    e3.val(numeral(s).format('0,0.[00]'));
                }
            }
        },
        "autoCalc": function (p) {
        }
    }
});