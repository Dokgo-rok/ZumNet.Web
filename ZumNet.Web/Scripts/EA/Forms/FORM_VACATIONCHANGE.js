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
                $('#__mainfield[name="APPLICANTDEPTID"]').val(info["grid"]);
            });
            p.modal('hide');
        },
        "change": function (x) {
            var row = $(x).parent().parent(), p = row.parent().parent(); //console.log(p)
            $(x).next().val($(x).children('option:selected').text());
            var c2 = row.find('td:nth-child(4) :text'), c3 = row.find('td:nth-child(5) :text'), c4 = row.find('td:nth-child(6) :text');
            c2.val(''); c3.val(''); c4.val('')

            if (x.value == 'B' || x.value == 'C' || x.value == 'D' || x.value == 'H' || x.value == 'I') {
                if (x.value == 'B') {
                    c2.val('09:00'); c3.val('18:00');

                } else {
                    var j = { "close": true, "width": 200, "height": 84 }

                    if (x.value == 'C') {
                        j["content"] = '<div><ul class="list-group list-group-flush">'
                            + '<li class="list-group-item list-group-item-action"><a href="javascript:" class="z-lnk-navy-n" data-val="09:00^13:30">오전반차&nbsp;&nbsp;09:00 ~ 13:30</a></li>'
                            + '<li class="list-group-item list-group-item-action"><a href="javascript:" class="z-lnk-navy-n" data-val="13:30^18:00">오후반차&nbsp;&nbsp;13:30 ~ 18:00</a></li>'
                            + '</ul></div>';
                    } else if (x.value == 'D') {
                        j["content"] = '<div><ul class="list-group list-group-flush">'
                            + '<li class="list-group-item list-group-item-action"><a href="javascript:" class="z-lnk-navy-n" data-val="09:00^11:00">오전1/4차&nbsp;&nbsp;09:00 ~ 11:00</a></li>'
                            + '<li class="list-group-item list-group-item-action"><a href="javascript:" class="z-lnk-navy-n" data-val="16:00^18:00">오후1/4차&nbsp;&nbsp;16:00 ~ 18:00</a></li>'
                            + '</ul></div>';
                    } else if (x.value == 'H') {
                        j["content"] = '<div><ul class="list-group list-group-flush">'
                            + '<li class="list-group-item list-group-item-action"><a href="javascript:" class="z-lnk-navy-n" data-val="08:30^12:30">반차A&nbsp;&nbsp;08:30 ~ 12:30</a></li>'
                            + '<li class="list-group-item list-group-item-action"><a href="javascript:" class="z-lnk-navy-n" data-val="09:00^14:00">반차B&nbsp;&nbsp;09:00 ~ 14:00</a></li>'
                            + '</ul></div>';
                    } else if (x.value == 'I') {
                        j["content"] = '<div><ul class="list-group list-group-flush">'
                            + '<li class="list-group-item list-group-item-action"><a href="javascript:" class="z-lnk-navy-n" data-val="13:30^17:30">반차A&nbsp;&nbsp;13:30 ~ 17:30</a></li>'
                            + '<li class="list-group-item list-group-item-action"><a href="javascript:" class="z-lnk-navy-n" data-val="14:00^18:00">반차B&nbsp;&nbsp;14:00 ~ 18:00</a></li>'
                            + '</ul></div>';
                    }
                    var pop = _zw.ut.popup(x, j);
                    pop.find('a[data-val]').click(function () {
                        var v = $(this).attr('data-val').split('^');
                        c2.val(v[0]); c3.val(v[1]);
                        pop.find('.close[data-dismiss="modal"]').click();
                    });
                }

                c2.prop('readonly', true); c3.prop('readonly', true);

            } else {
                if (x.value == 'F') c4.val("결근 만큼 급여에서 차감 됩니다.");
                c2.prop('readonly', false); c3.prop('readonly', false);
                _zw.fn.input(c2[0]); _zw.fn.input(c3[0]);
            }
        },
        "optionWnd": function (pos, w, h, m, n, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.'); //console.log(arguments)
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]); //console.log(param);
            var m = 'getreportsearch', v1 = '', v2 = '', v3 = '';

            //data body 조건 : N(modal-body 없음), F(footer 포함)
            $.ajax({
                type: "POST",
                url: "/EA/Common",
                data: '{M:"' + m + '",body:"F", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",query:"' + $('#__mainfield[name="APPLICANTID"]').val() + '"}',
                success: function (res) {
                    //res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
                    if (res.substr(0, 2) == 'OK') {
                        var p = $('#popBlank');
                        p.html(res.substr(2)).find('.modal-title').html('신청 내역');
                        p.find('.zf-modal').removeClass('modal-sm');
                        //p.find(".modal-dialog").css("max-width", "30rem");
                        //p.find(".modal-content").css("height", h + "px")

                        p.find('.modal-footer .btn[data-zm-menu="confirm"]').click(function () {
                            var col = p.find('.modal-body :checkbox:checked'); //console.log(col)
                            if (col.length < 1) bootbox.alert('변경할 항목을 선택하십시오!');
                            else {
                                var subId = '__subtable2';
                                var tbl = $('#' + subId); var iDiff = col.length - tbl.find('tr.sub_table_row').length; _zw.form.resetField(tbl);
                                if (iDiff > 0) { for (var i = 0; i < iDiff; i++) _zw.form.addRow(subId); }
                                //console.log(tbl.find('tr.sub_table_row'))
                                col.each(function (idx) {
                                    var c = $(this).parent().parent();
                                    var row =$(tbl.find('tr.sub_table_row')[idx]);
                                    row.find('td > :text[name]').each(function () {
                                        if ($(this).attr('name') == 'TGVACCLASSDN') $(this).val(c.next().text());
                                        if ($(this).attr('name') == 'TGLEAVEDATE') $(this).val(c.text());
                                        if ($(this).attr('name') == 'TGFROMTIME') $(this).val(c.next().next().text());
                                        if ($(this).attr('name') == 'TGCOUNT') $(this).val(c.next().next().next().text());
                                    });
                                    row.find('td > :hidden[name]').each(function () {
                                        $(this).val(c.find(':hidden[data-for="' + $(this).attr('name') + '"]').val());
                                    });
                                    //console.log(row.find('td > :hidden[name]'))
                                });
                                p.modal('hide');
                            }
                        });

                        $('.zf-modal input:text.z-input-in').keyup(function (e) {
                            if (e.which == 13) {
                                $('#__mainfield[name="' + param[0] + '"]').val($(this).val());
                                p.modal('hide');
                            }
                        });

                        p.on('hidden.bs.modal', function () { p.html(''); });
                        p.modal();

                    } else bootbox.alert(res);
                }
            });
        }
    }
});