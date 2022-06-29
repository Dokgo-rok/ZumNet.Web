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
        "autoCalc": function (p) { //console.log(p)
            var s = 0, f = '0,0.[0000]';
            if (p.find('td select[name="WORKTIME"]').length > 0) {
                p.find('td select[name="WORKTIME"]').each(function (idx, e) { s += numeral(e.value).value(); });
                $('#__mainfield[name="UNITCOUNT"]').val(numeral(s).format(f));
            }
            s = 0;
            if (p.find('td select[name="WORKTIME2"]').length > 0) {
                p.find('td select[name="WORKTIME2"]').each(function (idx, e) { s += numeral(e.value).value(); });
                $('#__mainfield[name="UNITCOUNT2"]').val(numeral(s).format(f));
            }
        },
        "change": function (x) {
            var row = $(x).parent().parent(), p = row.parent().parent(); //console.log(p)
            _zw.formEx.autoCalc(p);
        }
    }
});