$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            if (cmd == "draft") { //기안
                //if ($('#__mainfield[name="ECONTYN"]').val() == '진행') {
                //    var p = "ECONTMAILSUB;ECONTMAILBODY;ECONTEXPIRED;ECONTPWD;ECONTRCVNMA;ECONTRCVMAILA;ECONTRCVNMB;ECONTRCVMAILB".split(';');
                //    for (var i = 0; i < p.length; i++) {
                //        el = $('#__mainfield[name="' + p[i] + '"]'); if ($.trim(el.val()) == '') { bootbox.alert("전자계약 필수 항목 누락!", function () { el.focus(); }); return false; }
                //    }
                //}

            } else {
                //if (_zw.V.biz == "receive" && _zw.V.act == "__r") {
                //    if ($('#__mainfield[name="ECONTYN"]').val() == '진행') {
                //        var p = "ECONTFNM;ECONTFID;ECONTMAILSUB;ECONTMAILBODY;ECONTEXPIRED;ECONTPWD;ECONTRCVNMA;ECONTRCVMAILA;ECONTRCVNMB;ECONTRCVMAILB".split(';');
                //        for (var i = 0; i < p.length; i++) {
                //            el = $('#__mainfield[name="' + p[i] + '"]'); if ($.trim(el.val()) == '') { bootbox.alert("전자계약 필수 항목 누락!", function () { el.focus(); }); return false; }
                //        }
                //    }
                //}
            }
            return true;
        },
        "make": function (f) {
            if (_zw.V.biz == "receive" && _zw.V.act == "__r" && $('#__mainfield[name="ECONTYN"]').val() == '진행') {
                _zw.body.main(f, ["ECONTFNM", "ECONTFID", "ECONTMAILSUB", "ECONTMAILBODY", "ECONTEXPIRED", "ECONTPWD", "ECONTRCVNMA", "ECONTRCVMAILA", "ECONTRCVNMB", "ECONTRCVMAILB"]);
            }
        },
        "checkEvent": function (ckb, el, fld) {
            if (fld == 'ECONTYN') {
                var p1 = $('#_layer_econtract');
                if (el.checked && el.value == '진행') p1.show(); else p1.hide();

            } else if (fld == 'GENDER') {
                if (el.checked && el.value == '남') {
                    $('#__mainfield[name="ECONTRCVNMA"]').prop('disabled', true).css('background-color', '#ffffff').val('크레신');
                    $('#__mainfield[name="ECONTRCVMAILA"]').prop('disabled', true).css('background-color', '#ffffff').val('contract@cresyn.com');
                    $('#__mainfield[name="ECONTRCVTELA"]').prop('disabled', true).css('background-color', '#ffffff').val('02-2041-2700');

                    $('#__mainfield[name="ECONTRCVNMB"]').prop('disabled', false).val('');
                    $('#__mainfield[name="ECONTRCVMAILB"]').prop('disabled', false).val('');
                    $('#__mainfield[name="ECONTRCVTELB"]').prop('disabled', false).val('');

                } else if (el.checked && el.value == '여') {
                    $('#__mainfield[name="ECONTRCVNMA"]').prop('disabled', false).val('');
                    $('#__mainfield[name="ECONTRCVMAILA"]').prop('disabled', false).val('');
                    $('#__mainfield[name="ECONTRCVTELA"]').prop('disabled', false).val('');

                    $('#__mainfield[name="ECONTRCVNMB"]').prop('disabled', true).css('background-color', '#ffffff').val('크레신');
                    $('#__mainfield[name="ECONTRCVMAILB"]').prop('disabled', true).css('background-color', '#ffffff').val('contract@cresyn.com');
                    $('#__mainfield[name="ECONTRCVTELB"]').prop('disabled', true).css('background-color', '#ffffff').val('02-2041-2700');
                } else {
                    $('#__mainfield[name="ECONTRCVNMA"]').prop('disabled', false).val('');
                    $('#__mainfield[name="ECONTRCVMAILA"]').prop('disabled', false).val('');
                    $('#__mainfield[name="ECONTRCVTELA"]').prop('disabled', false).val('');

                    $('#__mainfield[name="ECONTRCVNMB"]').prop('disabled', false).val('');
                    $('#__mainfield[name="ECONTRCVMAILB"]').prop('disabled', false).val('');
                    $('#__mainfield[name="ECONTRCVTELB"]').prop('disabled', false).val('');
                }
            }
        },
        "calc": function (el) {
        },
        "autoCalc": function (p) {
        },
        "date": function (el) {
            var from, to, diff;
            if (el.name == 'ECONTEXPIRED') {
                from = _zw.V.current.date; to = $('#__mainfield[name="ECONTEXPIRED"]');
                dif = _zw.ut.diff('day', to.val(), from);
                if (dif && dif < 0) { bootbox.alert('만료일은 오늘 이후로 입력하세요!', function () { to.val(''); to.focus(); }); return false; }

            } else if (el.name == 'STDATE' || el.name == 'FIDATE') {
                from = $('#__mainfield[name="STDATE"]'); to = $('#__mainfield[name="FIDATE"]');
                dif = _zw.ut.diff('day', to.val(), from);
                if (dif && dif < 0) { bootbox.alert('날짜 범위 입력 오류!', function () { to.val(''); to.focus(); }); return false; }
            }
        },
    }
});