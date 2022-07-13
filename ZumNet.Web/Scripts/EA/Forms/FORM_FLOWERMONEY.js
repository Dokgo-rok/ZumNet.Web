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
                $('#__mainfield[name="APPLICANTEMPNO"]').val(info["empid"]);
                $('#__mainfield[name="APPLICANTGRADE"]').val(info["grade"]);
                $('#__mainfield[name="APPLICANTDEPT"]').val(info["grdn"]);
                $('#__mainfield[name="APPLICANTCORP"]').val(info["belong"]);
            });
            p.modal('hide');
        },
        "change": function (x) {
            $(x).next().val($(x).children('option:selected').text());

            if (x.name == 'RELATIONCODE') {
                if (x.value == '4') $('#__mainfield[name="RELATION"]').val('').show();
                else $('#__mainfield[name="RELATION"]').val($(x).children('option:selected').text()).hide();

            } else if (x.name == 'FLONAMECODE') {
                if (x.value == '8') $('#__mainfield[name="FLONAME"]').val('').show();
                else $('#__mainfield[name="FLONAME"]').val($(x).children('option:selected').text()).hide();

            } else if (x.name == 'FLOKEYCODE') {
                if (x.value == '11') $('#__mainfield[name="FLOKEY"]').val('').show();
                else $('#__mainfield[name="FLOKEY"]').val($(x).children('option:selected').text()).hide();

            } else if (x.name == 'CELMONEYCODE') {
                if (x.value == '16') $('#__mainfield[name="CELMONEY"]').val('').show();
                else $('#__mainfield[name="CELMONEY"]').val($(x).children('option:selected').text()).hide();

            } else if (x.name == 'FLODETAILCODE') {
                if (x.value == '21') $('#__mainfield[name="FLODETAIL"]').val('').show();
                else $('#__mainfield[name="FLODETAIL"]').val($(x).children('option:selected').text()).hide();

            } else if (x.name == 'FLOMONEYCODE') {
                if (x.value == '26') $('#__mainfield[name="FLOMONEY"]').val('').show();
                else $('#__mainfield[name="FLOMONEY"]').val($(x).children('option:selected').text()).hide();
            }
        }
    }
});