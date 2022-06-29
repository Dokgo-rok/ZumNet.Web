$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            if (cmd == 'draft') {
                if ($(':checkbox[name="ckbEMPLOYTYPE"]:checked, :checkbox[name="ckbEMPLOYTYPEB"]:checked, :checkbox[name="ckbEMPLOYTYPEC"]:checked, :checkbox[name="ckbEMPLOYTYPED"]:checked').length < 1) {
                    bootbox.alert('구분을 선택하십시오!'); return false;
                }
            }
            return true;
        },
        "make": function (f) {
        },
        "checkEvent": function (ckb, el, fld) {
        },
        "calc": function (el) {
        },
        "autoCalc": function (p) {
        }
    }
});