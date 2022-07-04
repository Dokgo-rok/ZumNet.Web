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
            var row = $(el).parent().parent(), p = row.parent().parent(); //console.log(p)
            var s = 0, s2 = 0, f = '0,0.[0000]';

            if (el.name == "SUM") {
                p.find('td :text[name="' + el.name + '"]').each(function (idx, e) { s += numeral(e.value).value(); })
                $('#__mainfield[name="TOTALSUM"]').val(numeral(s).format(f));
            }
        },
        "autoCalc": function (p) {
            var s = 0, f = '0,0.[0000]';
            p.find('td :text[name="SUM"]').each(function (idx, e) { s += numeral(e.value).value(); })
            $('#__mainfield[name="TOTALSUM"]').val(numeral(s).format(f));
        }
    }
});