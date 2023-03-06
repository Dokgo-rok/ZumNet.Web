$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            var bRt = true;
            if (_zw.V.biz == "normal" && _zw.V.act == "_approver") {
                $('#__subtable1 tr.sub_table_row').each(function () {
                    if ($(this).find('td :text[name="TOTALFIRST"]').val() != '' && $(this).find('td select[name="CHANGE"]').val() == '') {
                        bootbox.alert("필수항목 [조정] 누락!");
                        bRt = false;
                        return false;
                    }
                });
            }
            return bRt;
        },
        "make": function (f) {
            if (_zw.V.biz == "normal" && _zw.V.act == "_approver") _zw.body.sub(f);
        },
        "checkEvent": function (ckb, el, fld) {
        },
        "calc": function (el) {
        },
        "autoCalc": function (p) {
        }
    }
});