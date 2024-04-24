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
            var from = $('#__mainfield[name="FROMDATE"]'), to = $('#__mainfield[name="TODATE"]');
            var dif = _zw.ut.diff('day', from.val(), to.val()); //console.log(dif + " : " + !(dif))
            if (dif && dif > 0) { bootbox.alert('날짜 범위 입력 오류!', function () { to.val(''); to.focus(); }); return false; }
        },
        "orgSelect": function (p, x) {
            p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
                var info = JSON.parse($(this).attr('data-attr')); console.log(info)
                var dn = $(this).next().text();
                $('#__mainfield[name="APPLICANTCORP"]').val(info["belong"]);
                $('#__mainfield[name="APPLICANTDEPT"]').val(info["grdn"]);
                $('#__mainfield[name="APPLICANTGRADE"]').val(info["grade"]);
                $('#__mainfield[name="APPLICANT"]').val(dn);
                $('#__mainfield[name="APPLICANTEMPNO"]').val(info["empid"]);
                $('#__mainfield[name="APPLICANTID"]').val(info["id"]);
            });
            p.modal('hide');
        }
    }
});