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
		"orgSelect": function (p, x) {
			p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
				var info = JSON.parse($(this).attr('data-attr')); //console.log(info)
				var dn = $(this).next().text();
                $('#__mainfield[name="APPLICANT"]').val(dn);
                $('#__mainfield[name="APPLICANTID"]').val(info["id"]);
                $('#__mainfield[name="APPLICANTGRADE"]').val(info["grade"]);
                $('#__mainfield[name="APPLICANTEMPNO"]').val(info["empid"]);
                $('#__mainfield[name="APPLICANTDEPT"]').val(info["grdn"]);
                $('#__mainfield[name="APPLICANTCORP"]').val(info["belong"]);
                $('#__mainfield[name="APPLICANTINDATE"]').val(info["indate"]);
			});
			p.modal('hide');
		}
    }
});