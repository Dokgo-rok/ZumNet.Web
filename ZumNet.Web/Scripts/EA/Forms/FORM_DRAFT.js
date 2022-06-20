$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            var el = null;
            if (cmd == "draft") { //기안

            } else { //결재
                if (_zw.V.biz == "의견") {
                    el = $('#__mainfield[name="CONTENTS"]');
                    if (el.length > 0 && $.trim(el.val()) == '') {
                        bootbox.alert("필수항목 [기획조정실의견] 누락!", function () { el.focus(); }); return false;
                    }
                }
            }
            return true;
        },
        "make": function (f) { //결재 중 정보 구성
            if (_zw.V.biz == "의견") {
                _zw.body.main(f, ["CONTENTS"]);
            }
        },
        "checkEvent": function (ckb, el, fld) {
        },
        "calc": function (e) {
        },
        "autoCalc": function (p) {
        }
    }
});