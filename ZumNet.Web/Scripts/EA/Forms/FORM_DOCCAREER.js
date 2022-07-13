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
                //$('#__mainfield[name="TRIPPERSONID"]').val(info["id"]);

                $.ajax({
                    type: "POST",
                    url: "/EA/Common",
                    data: '{M:"getreportsearch",body:"S", k1:"",k2:"DOCWORKSTATE",k3:"",v1:"' + info["id"] + '",v2:"",v3:""}',
                    success: function (res) {
                        if (res.substr(0, 2) == 'OK') {
                            v = res.substr(2).split(',');
                            var person = [];
                            for (var i = 0; i < v.length; i++) { var d = v[i].split(':'); person[d[0]] = d[1]; }

                            $('#__mainfield[name="APPLICANTEMPNO"]').val(person.APPLICANTEMPNO);
                            $('#__mainfield[name="APPLICANTID"]').val(person.APPLICANTID);
                            $('#__mainfield[name="APPLICANTDEPTID"]').val(person.APPLICANTDEPTID);
                            //성명 
                            $('#__mainfield[name="APPLICANT"]').val(person.APPLICANT);
                            $('#__mainfield[name="ENGNM"]').val(person.ENGNM);
                            $('#__mainfield[name="APPLICANT"]').parent().find('span').html(person.ENGNM + " (" + person.APPLICANT + ")");
                            //부서
                            $('#__mainfield[name="APPLICANTDEPT"]').val(person.APPLICANTDEPT);
                            $('#__mainfield[name="ENGDEPTNM"]').val(person.ENGDEPTNM);
                            $('#__mainfield[name="APPLICANTDEPT"]').parent().find('span').html(person.ENGDEPTNM + " (" + person.APPLICANTDEPT + ")");
                            //직위
                            $('#__mainfield[name="APPLICANTGRADE"]').val(person.APPLICANTGRADE);
                            $('#__mainfield[name="ENGGRADENM"]').val(person.ENGGRADENM);
                            $('#__mainfield[name="APPLICANTGRADE"]').parent().find('span').html(person.ENGGRADENM + " (" + person.APPLICANTGRADE + ")");
                            //생년월일
                            $('#__mainfield[name="BIRTHDATE"]').val(person.BIRTHDATE);
                            //$('#__mainfield[name="BIRTHDATE"]').parent().find('span').html(convertDate2(person.BIRTHDATE, "en") + " (" + convertDate2(person.BIRTHDATE, "ko") + ")");
                            $('#__mainfield[name="BIRTHDATE"]').parent().find('span').html(_zw.ut.dateLocale(person.BIRTHDATE, 'en') + ' (' + _zw.ut.dateLocale(person.BIRTHDATE, 'ko') + ')');
                            //입사일
                            var enddate =  person.LEAVEDATE=="" ? f.document.getElementById("REQUESTDATE").value : person.LEAVEDATE;
                            $('#__mainfield[name="INDATE"]').val(person.INDATE);
                            $('#__mainfield[name="LEAVEDATE"]').val(enddate);
                            //$('#__mainfield[name="INDATE"]').parent().find('span').html(convertDate2(person.INDATE, "en") + " ~ " + convertDate2($('#__mainfield[name="REQUESTDATE").value, "en") + "\n (" + convertDate2(person.INDATE, "ko") + " ~ " + convertDate2($('#__mainfield[name="REQUESTDATE"]').val(), "ko") + ")");
                            $('#__mainfield[name="INDATE"]').parent().find('span').html(_zw.ut.dateLocale(person.INDATE, "en") + " ~ " + _zw.ut.dateLocale(enddate, "en") + "<br />(" + _zw.ut.dateLocale(person.INDATE, "ko") + " ~ " + _zw.ut.dateLocale(enddate, "ko") + ")");
                        }
                        else if (res.substr(0, 2) == 'ND') { bootbox.alert(res.substr(2)); return false; }
                        else { bootbox.alert(res); return false; }
                    }
                });
            });
            p.modal('hide');
        }
    }
});