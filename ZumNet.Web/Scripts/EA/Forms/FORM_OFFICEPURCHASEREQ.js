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
            var s = 0, f = '0,0', row = null;

            if (el.name == "REQCOUNT" || el.name == "REALCOST") {
                row = $(el).parent().parent();
                s = parseFloat(_zw.ut.empty(row.find('td :text[name="REQCOUNT"]').val())) * parseFloat(_zw.ut.empty(row.find('td :text[name="REALCOST"]').val()));
                row.find('td :text[name="PRECOST"]').val(numeral(s).format(f)); s = 0;

                $('#__subtable1 td :text[name="PRECOST"]').each(function (idx, e) { s += numeral(e.value).value(); });
                $('#__mainfield[name="TOTALSUM"]').val(numeral(s).format(f));
            }
        },
        "autoCalc": function (p) {
            var s = 0, f = '0,0';
            p.find('td :text[name="PRECOST"]').each(function (idx, e) { s += numeral(e.value).value(); })
            $('#__mainfield[name="TOTALSUM"]').val(numeral(s).format(f));
        }
    }
});