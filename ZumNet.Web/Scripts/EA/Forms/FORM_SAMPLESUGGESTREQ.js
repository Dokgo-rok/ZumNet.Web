$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            return true;
        },
        "make": function (f) {
            if (_zw.V.biz == "설계수신" && _zw.V.act == "_reviewer") _zw.body.main(f, ["DESIGNREQ", "ATTCH4", "ATTCH5"]);
            else if (_zw.V.biz == "receive" && _zw.V.act == "__r") _zw.body.main(f, ["PURCHASEREQ", "ATTCH6"]);
            else if (_zw.V.biz == "구매수신" && _zw.V.act == "__r") _zw.body.main(f, ["PURCHASEREQ", "ATTCH6"]);
            else if (_zw.V.biz == "외주수신" && _zw.V.act == "__r") _zw.body.main(f, ["PRODCONTROLREQ", "ATTCH7"]);
        },
        "checkEvent": function (ckb, el, fld) {
            if (fld == 'DEVCLASS') {
                if (el.value == '기타' && el.checked) $('#__mainfield[name="DEVCLASSETC"]').removeClass('txtRead').addClass('txtText').prop('readonly', false).val('');
                else $('#__mainfield[name="DEVCLASSETC"]').removeClass('txtText').addClass('txtRead').prop('readonly', true).val('');
            }
        },
        "calc": function (el) {
        },
        "autoCalc": function (p) {
        }
    }
});