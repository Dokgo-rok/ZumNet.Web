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
            if (el.name == 'FROMDATE' || el.name == 'TODATE') {
                var from = $('#__mainfield[name="FROMDATE"]'), to = $('#__mainfield[name="TODATE"]');
                var dif = _zw.ut.diff('day', from.val(), to.val()); //console.log(dif + " : " + !(dif))
                if (dif && dif > 0) { bootbox.alert('날짜 범위 입력 오류!', function () { to.val(''); to.focus(); }); return false; }

            } else if (el.value != '' && (el.name == 'OFROMTIME' || el.name == 'OTOTIME')) {
                var t = parseFloat(el.value.replace(':', ''));
                if (isNaN(t) || t < 900 || t > 1900) { bootbox.alert('외근시간은 9시~19시까지 입력 가능합니다!', function () { el.value = ''; }); return false; }

                if (el.name == 'OTOTIME') {
                    var stdDate = $(el).parent().parent().find('td :text[name="LEAVEDATE"]').val();
                    //data body 조건 : S(문자열반환), N(modal-body 없음), F(footer 포함)
                    $.ajax({
                        type: "POST",
                        url: "/EA/Common",
                        data: '{M:"getreportsearch",body:"S", k1:"",k2:"REGISTER_OUTWORK",k3:"' + '' + '",query:"' + $('#__mainfield[name="APPLICANTID"]').val() + '",v1:"' + stdDate + '"}',
                        success: function (res) {
                            if (res.substr(0, 2) == 'OK') {
                                var st = parseFloat(res.substr(2).replace(':', ''));
                                if (st < 800) {
                                    if (t > 1700) { bootbox.alert(stdDate + ' 출근시간 기준 17시까지 외근시간 입력 가능합니다!', function () { el.value = ''; }); return false; }
                                } else if (st >= 800 && st < 1000) {
                                    var temp = parseFloat(st + 900); //console.log(temp)
                                    if (t > temp) {
                                        var temp2 = temp < 1000 ? temp.toString().substr(0, 1) + ':' + temp.toString().substr(1, 2) : temp.toString().substr(0, 2) + ':' + temp.toString().substr(2, 2);
                                        bootbox.alert(stdDate + ' 출근시간 기준 ' + temp2 + '까지 외근시간 입력 가능합니다!', function () { el.value = ''; }); return false;
                                    }
                                } else if (st >= 1000) {
                                    if (t > 1900) { bootbox.alert(stdDate + ' 출근시간 기준 19시까지 외근시간 입력 가능합니다!', function () { el.value = ''; }); return false; }
                                }
                            } else if (res.substr(0, 2) == 'ND') {
                                if (t > 1800) bootbox.alert('출근기록이 없는 경우 최대 18시까지 외근시간 입력 가능합니다!', function () { el.value = ''; });

                            } else if (res.substr(0, 2) == 'NE') {
                                bootbox.alert(res.substr(2), function () { el.value = ''; });

                            } else bootbox.alert(res);
                        },
                        beforeSend: function () { }
                    });
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