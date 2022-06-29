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
            if (el.value != '') {
                var t = parseFloat(el.value.replace(':', ''));
                if (el.name == 'FROMTIME') {
                    if (isNaN(t) || t < 800 || t > 2200) { bootbox.alert('8시 이전 또는 22시 이후는 출근시간으로 입력할 수 없습니다!', function () { el.value = ''; }); return false; }
                } else if (el.name == 'TOTIME') {
                    if (isNaN(t) || t > 2200) { bootbox.alert('22시 이후는 퇴근시간으로 입력할 수 없습니다!', function () { el.value = ''; }); return false; }
                    else if (isNaN(t) || t < 800) { bootbox.alert('22시 이후는 퇴근시간으로 입력할 수 없습니다!', function () { el.value = ''; }); return false; }
                }
            }
        },
        "orgSelect": function (p, x) {
            p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
                var info = JSON.parse($(this).attr('data-attr')); //console.log(info)
                var dn = $(this).next().text();
                $('#__mainfield[name="APPLICANTCORP"]').val(info["belong"]);
                $('#__mainfield[name="APPLICANTDEPT"]').val(info["grdn"]);
                $('#__mainfield[name="APPLICANTGRADE"]').val(info["grade"]);
                $('#__mainfield[name="APPLICANT"]').val(dn);
                $('#__mainfield[name="APPLICANTEMPNO"]').val(info["empid"]);
                $('#__mainfield[name="APPLICANTID"]').val(info["id"]);
                //$('#__mainfield[name="APPLICANTDEPTID"]').val(info["grid"]);
            });
            p.modal('hide');
        }
    }
});