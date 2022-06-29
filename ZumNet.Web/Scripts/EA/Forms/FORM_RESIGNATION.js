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
        "date": function (el) {
            var from = $('#__mainfield[name="RSNINDATE"]'), to = $('#__mainfield[name="RSNOUTDATE"]');
            var dif = _zw.ut.diff('day', from.val(), to.val()); //console.log(dif + " : " + !(dif))
            if (dif && dif > 0) { bootbox.alert('날짜 범위 입력 오류!', function () { to.val(''); to.focus(); }); return false; }
        },
        "orgSelect": function (p, x) { console.log(typeof (x))
            p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
                var info = JSON.parse($(this).attr('data-attr')); //console.log(info)
                var dn = $(this).next().text();

                if (typeof (x) === 'object') {
                    var row = $(x).parent().parent();
                    row.find('input[name="ACCEPTORID"]').val(info["id"]);
                    row.find('input[name="ACCEPTOR"]').val(dn);
                    row.find('input[name="ACCEPTORGRADE"]').val(info["grade"]);
                    row.find('input[name="ACCEPTORDEPTID"]').val(info["grid"]);
                    row.find('input[name="ACCEPTORDEPT"]').val(info["grdn"]);

                    if (row[0].rowIndex == 0) { //대표 인수자
                        $(':text[name="txtACCEPTOR"]').val(dn);
                        $(':text[name="txtACCEPTORGRADE"]').val(info["grade"]);
                    }

                } else {
                    if (x == 'RSNNM') { //퇴직자
                        $('#__mainfield[name="RSNID"]').val(info["id"]);
                        $('#__mainfield[name="RSNNM"]').val(dn);
                        $('#__mainfield[name="RSNEMPNO"]').val(info["empid"]);
                        $('#__mainfield[name="RSNGRADE"]').val(info["grade"]);
                        $('#__mainfield[name="RSNDEPTID"]').val(info["grid"]);
                        $('#__mainfield[name="RSNDEPT"]').val(info["grdn"]);
                        $('#__mainfield[name="RSNCORP"]').val(info["belong"]);
                        $('#__mainfield[name="RSNINDATE"]').val(info["indate"]);

                        $(':text[name="txtRSNNM"]').val(dn);
                        $(':text[name="txtRSNGRADE"]').val(info["grade"]);
                        $(':text[name="txtRSNDEPT"]').val(info["grdn"]);

                    } else if (x == 'OSVNM') {//입회자
                        $('#__mainfield[name="OSVID"]').val(info["id"]);
                        $('#__mainfield[name="OSVNM"]').val(dn);
                        $('#__mainfield[name="OSVGRADE"]').val(info["grade"]);
                        $('#__mainfield[name="OSVDEPTID"]').val(info["grid"]);
                        $('#__mainfield[name="OSVDEPT"]').val(info["grdn"]);

                        $(':text[name="txtOSVNM"]').val(dn);
                        $(':text[name="txtOSVGRADE"]').val(info["grade"]);
                    }
                }
            });
            p.modal('hide');
        },
        "blur": function (el) {
            if (el && el.value != '') {
                if (el.name == "RSNWORK") $(':text[name="txtRSNWORK"]').val(el.value);
                else if (el.name == "RSNJUMINNO") $(':text[name="txtRSNJUMINNO"]').val(el.value);
            }
        }
    }
});