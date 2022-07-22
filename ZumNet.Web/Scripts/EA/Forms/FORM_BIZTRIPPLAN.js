$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            var el = null;
            if (cmd == "draft") { //기안
                if ($('#__mainfield[name="USEMONEY"]').val() == '고객부담') {
                    var iCnt = 0;
                    for (var i = 1; i <= 5; i++) {
                        if ($('#__mainfield[name="USEMONEYDETAIL' + i.toString() + '"]').val() != '') { iCnt++; break; }
                    }
                    if (iCnt == 0) { bootbox.alert('고객부담 세부사항을 체크하십시오!'); return false; }
                    if ($('#__mainfield[name="USEMONEYDETAIL5"]').val() == '기타') {
                        if ($('#__mainfield[name="USEMONEYDETAILETC"]').val() == '') { bootbox.alert('기타 세부사항을 체크하십시오!'); return false; }
                    }
                }
                $('#__subtable10 tr.sub_table_row').each(function (idx) {
                    var c = $(this).find('> td:nth-child(3) input');
                    if (idx == 0 && c.val() == '') { bootbox.alert('항공료를 입력하십시오!', function () { c.focus(); }); return false; }
                    else if (idx == 1 && c.val() == '') { bootbox.alert('숙박료를 입력하십시오!', function () { c.focus(); }); return false; }
                    else if (idx == 5 && c.val() == '') { bootbox.alert('일비를 입력하십시오!', function () { c.focus(); }); return false; }
                });
            } else {
                if (_zw.V.biz == '동행자') {
                    var ln = _zw.V.process.signline.find(function (element) { if (element.bizrole == '동행자' && element.actrole == '_manager' && element.partid == _zw.V.current.urid) return true; });
                    el = $('#__mainfield[name="LOCATION_C' + ln["substep"] + '"]');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [출장지] 누락!', function () { el.focus(); }); return false; }

                    el = $('#__mainfield[name="TRIPFROM_C' + ln["substep"] + '"]');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [출장시작일] 누락!', function () { el.focus(); }); return false; }

                    el = $('#__mainfield[name="TRIPTO_C' + ln["substep"] + '"]');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [출장종료일] 누락!', function () { el.focus(); }); return false; }

                    el = $('#__mainfield[name="STAY_C' + ln["substep"] + '"]');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [출장(박)] 누락!', function () { el.focus(); }); return false; }

                    el = $('#__mainfield[name="PURPOSE_C' + ln["substep"] + '"]');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [출장목적] 누락!', function () { el.focus(); }); return false; }

                    var row = $('#__FormView .fm table.ft-sub[active="Y"] tr.sub_table_row')[0];
                    el = $(row).find('> td:nth-child(2) input');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [출장계획 일자] 누락!', function () { el.focus(); }); return false; }

                    el = $(row).find('> td:nth-child(3) input');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [출장계획 방문처] 누락!', function () { el.focus(); }); return false; }

                    $('#__subtable10 tr.sub_table_row').each(function (idx) {
                        var c = $(this).find('> td:nth-child(5) input');
                        if (idx == 0 && c.val() == '') { bootbox.alert('항공료를 입력하십시오!', function () { c.focus(); }); return false; }
                        else if (idx == 1 && c.val() == '') { bootbox.alert('숙박료를 입력하십시오!', function () { c.focus(); }); return false; }
                        else if (idx == 5 && c.val() == '') { bootbox.alert('일비를 입력하십시오!', function () { c.focus(); }); return false; }
                    });
                }
            }
            return true;
        },
        "make": function (f) {
            if (_zw.V.biz == "동행자") {
                var ln = _zw.V.process.signline.find(function (element) { if (element.bizrole == '동행자' && element.actrole == '_manager' && element.partid == _zw.V.current.urid) return true; });
                _zw.body.main(f, ["LOCATION_C" + ln["substep"], "TRIPFROM_C" + ln["substep"], "TRIPTO_C" + ln["substep"], "STAY_C" + ln["substep"], "DAY_C" + ln["substep"], "PURPOSE_C" + ln["substep"], "UNITEXPENSE_C" + ln["substep"]]);

                var p = $('#__FormView .fm table.ft-sub[active="Y"]');
                _zw.body.subPart(f, p.attr('id').replace('__subtable', '') + ";TRIPDAY;VISITTO;BIZNOW;BIZPLAN^10;EXPENSEAMOUNT_C" + ln["substep"] + ";EXPENSEETC_C" + ln["substep"])
            }
        },
        "checkEvent": function (ckb, el, fld) {
            if (fld == 'OUTBUDGET') {
                var p1 = $('#panDisplay');
                if (el.checked && el.value == '필요') {
                    p1.show();
                } else if (el.checked && el.value == '불필요') {
                    p1.hide(); p1.find('#__mainfield[name]').val('');
                }
            } else if (fld == 'USEMONEY') {
                if (el.checked && el.value == '고객부담') {
                    for (var i = 1; i <= 5; i++) {
                        $(el).parent().parent().find('[name="ckbUSEMONEYDETAIL' + i.toString() + '"]').prop('disabled', false);
                    }
                } else {
                    for (var i = 1; i <= 5; i++) {
                        $(el).parent().parent().find('[name="ckbUSEMONEYDETAIL' + i.toString() + '"]').prop('checked', false).prop('disabled', true);
                        $('#__mainfield[name="USEMONEYDETAIL' + i.toString() + '"]').val('');
                    }
                    $('#__mainfield[name="USEMONEYDETAILETC"]').prop('readonly', true).css('display', 'none').val('');
                }
            } else if (fld == 'USEMONEYDETAIL5') {
                if (el.checked && el.value == '기타') $('#__mainfield[name="USEMONEYDETAILETC"]').prop('readonly', false).css('display', '');
                else $('#__mainfield[name="USEMONEYDETAILETC"]').prop('readonly', true).css('display', 'none').val('');
            }
        },
        "calc": function (el) {
            var row = $(el).parent().parent(), p = row.parent().parent();
            var s = 0, s2 = 0, f = '0,0.[0000]';

            if (el.name.indexOf("EXPENSEAMOUNT") != -1) {
                var nm = 'UNITEXPENSE' + (el.name.indexOf("_C") > 0 ? "_" + el.name.split("_")[1] : ''); //console.log(el.name  + " : " + nm)
                p.find('td :text[name="' + el.name + '"]').each(function (idx, e) { s += numeral(e.value).value(); })
                $('#__mainfield[name="' + nm + '"]').val(numeral(s).format(f));

            } else if (el.name.indexOf("STAY") != -1) {
                _zw.formEx.event('BIZTRIP_EXPENSERULE', el.name);
            }
        },
        "autoCalc": function (p, nm) {
            p = p || $('#__subtable10'); nm = nm || '';
            var s = 0, f = '0,0.[0000]';

            p.find('td :text[name="EXPENSEAMOUNT' + nm + '"]').each(function (idx, e) { s += numeral(e.value).value(); })
            $('#__mainfield[name="UNITEXPENSE' + nm + '"]').val(numeral(s).format(f));
        },
        "date": function (el) {
            var from, to;
            if (el.name.indexOf('_C') > 0) {
                from = $('#__mainfield[name="TRIPFROM_' + el.name.split('_')[1] + '"]'); to = $('#__mainfield[name="TRIPTO_' + el.name.split('_')[1] + '"]');
            } else {
                from = $('#__mainfield[name="TRIPFROM"]'); to = $('#__mainfield[name="TRIPTO"]');
            }
            var dif = _zw.ut.diff('day', from.val(), to.val()); //console.log(dif + " : " + !(dif))
            if (dif && dif > 0) { bootbox.alert('날짜 범위 입력 오류!', function () { to.val(''); to.focus(); }); return false; }
        },
        "orgSelect": function (p, x) {
            p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
                var info = JSON.parse($(this).attr('data-attr')); //console.log(info)
                var dn = $(this).next().text();
                $('#__mainfield[name="TRIPPERSON"]').val(dn);
                $('#__mainfield[name="TRIPPERSONID"]').val(info["id"]);
                $('#__mainfield[name="TRIPPERSONEMPID"]').val(info["empid"]);
                $('#__mainfield[name="TRIPPERSONGRADE"]').val(info["grade"]);
                $('#__mainfield[name="TRIPPERSONORG"]').val(info["grdn"]);
                $('#__mainfield[name="TRIPPERSONDEPTID"]').val(info["grid"]);
                $('#__mainfield[name="TRIPPERSONCORP"]').val(info["belong"]);

                _zw.formEx.event('BIZTRIP_EXPENSERULE', '');
            });
            p.modal('hide');
        },
        "optionWnd": function (pos, w, h, l, t, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.');
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]);
            var m = '', v1 = '', v2 = '', v3 = '';
            if (vPos[0] == 'erp') m = 'getoracleerp';
            else if (vPos[0] == 'report') m = 'getreportsearch';
            else m = 'getcodedescription';

            var pOption = ['F', 'checkbox'];
            if (vPos[1] == 'currency') pOption = ['N', ''];

            //data body 조건 : N(modal-body 없음), F(footer 포함)
            $.ajax({
                type: "POST",
                url: "/EA/Common",
                data: '{M:"' + m + '",body:"' + pOption[0] + '", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",fn:"' + pOption[1] + '",query:"",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:""}',
                success: function (res) {
                    //res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
                    if (res.substr(0, 2) == 'OK') {
                        if (pOption[0] != 'N') {
                            var p = $('#popBlank');
                            p.html(res.substr(2)).find('.modal-title').html(el.attr('title'));
                            //if (m == 'getcodedescription') p.find(".modal-dialog").css("max-width", "15rem");

                            p.find('.zf-modal .modal-footer .btn[data-zm-menu="confirm"]').click(function () {
                                var v = '';
                                p.find('.modal-body td [name="ckbMultiOption"]:checked').each(function (idx) {
                                    var c = $(this).parent().next().next();
                                    v += (idx > 0 ? ',' : '') + (c.find('.z-input-in').length > 0 ? c.find('.z-input-in').val() : c.text());
                                });
                                $('#__mainfield[name="' + param[0] + '"]').val(v); _zw.formEx.event('BIZTRIP_EXPENSERULE', param[0]);
                                p.modal('hide');
                            });

                            p.on('hidden.bs.modal', function () { p.html(''); });
                            p.modal();

                        } else {
                            var j = { "close": true, "width": w, "height": h, "left": l, "top": t }
                            j["title"] = el.attr('title'); j["content"] = res.substr(2);

                            var pop = _zw.ut.popup(el[0], j);
                            pop.find('a[data-val]').click(function () {
                                var v = $(this).attr('data-val').split('^');
                                for (var i = 0; i < param.length; i++) {
                                    el.parent().parent().find('[name="' + param[i] + '"]').val(v[i]);
                                }
                                pop.find('.close[data-dismiss="modal"]').click();
                            });

                            pop.find('input:text.z-input-in').keyup(function (e) {
                                if (e.which == 13) {
                                    el.parent().parent().find('[name="' + param[0] + '"]').val($(this).val());
                                    pop.find('.close[data-dismiss="modal"]').click();
                                }
                            });
                        }

                    } else bootbox.alert(res);
                }
            });
        },
        "event": function (pos, x) { //console.log(x)
            //if ($('#__mainfield[name="TRIPFROM"]').val() == '') { bootbox.alert('[출장시작일]을 입력하십시오!'); return false; }
            var nm = ["", $('#__mainfield[name="TRIPPERSONID"]').val(), $('#__mainfield[name="TRIPPERSONDEPTID"]').val()];
            var m = 'getreportsearch', v = '', v3 = '';

            if (x && x.indexOf("_C") != -1) {
                nm[0] = '_' + x.split('_')[1]; nm[1] = _zw.V.current.urid; nm[2] = _zw.V.current.deptid;
                v3 = '1'; //console.log(nm)
            } else {
                var dif = _zw.ut.diff('day', $('#__mainfield[name="TRIPFROM"]').val(), '2019-03-01');
                v3 = dif && dif < 0 ? '2' : '1';
            }

            var loc = $('#__mainfield[name="LOCATION' + nm[0] + '"]').val(), dur = $('#__mainfield[name="STAY' + nm[0] + '"]').val();
            dur = dur == '' ? 0 : parseInt(dur); //console.log($('#__mainfield[name="LOCATION' + nm[0] + '"]'))

            $.ajax({
                type: "POST",
                url: "/EA/Common",
                async: false,
                data: '{M:"' + m + '",body:"S", k1:"",k2:"' + pos + '",k3:"",v1:"' + nm[1] + '",v2:"' + nm[2] + '",v3:"' + v3 + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == 'OK') { v = res.substr(2); }
                    else { bootbox.alert(res); return false; }
                },
                beforeSend: function () { }
            });

            var c1, c2, s = 0, f = '0,0';
            $('#__subtable10 tr.sub_table_row').each(function (idx) {
                c1 = $(this).find('> td:nth-child(2) input');
                c2 = nm[0] != '' ? $(this).find('> td:nth-child(5) input') : $(this).find('> td:nth-child(3) input'); //console.log(c2)

                if (idx == 0) { c1.val('항공료'); c2.val(v != '' ? '0' : ''); }
                else if (idx == 1) { c1.val('숙박료'); c2.val(v != '' ? '0' : ''); }
                else if (idx == 2) { c1.val('접대비'); c2.val(v != '' ? '0' : ''); }
                else if (idx == 3) { c1.val('교통비'); c2.val(v != '' ? '0' : ''); }
                else if (idx == 4) { c1.val('식비'); c2.val(v != '' ? '0' : ''); }
                else if (idx == 5) {
                    c1.val('일비'); c2.val(v != '' ? '0' : '');
                    if (v != '') {
                        if (loc == 'JY') {
                            var jptrip = 0;
                            if (v == '100') jptrip = 12000;
                            else if (v == '50') jptrip = 5000;
                            else if (v == '40') jptrip = 4000;
                            else if (v == '30') jptrip = 3500;
                            else if (v == '25') jptrip = 3000;
                            else if (v == '20') jptrip = 2500;
                            else if (v == '15') jptrip = 2000;
                            else if (v == '10') jptrip = 1500;
                            else if (v == '5') jptrip = 750;
                            else jptrip = 0;

                            if (dur < 15) s = parseInt(dur * jptrip * 11);
                            else s = parseInt(14 * jptrip * 11) + parseFloat((dur - 14) * jptrip * 0.9 * 11);
                        } else {
                            v = v == '' ? 0 : parseInt(v); //console.log(v + " : " + dur)
                            if (dur < 15) s = parseInt(dur * v * 1127); 
                            //else s = _zw.ut.round((parseInt(14 * v * 1127) + parseFloat((dur - 14) * v * 0.9 * 1127).toFixed(4)), 0);
                            else s = parseInt(14 * v * 1127) + parseFloat((dur - 14) * v * 0.9 * 1127);
                        }
                        c2.val(numeral(s).format(f));

                    } else c2.val('');
                }
                else if (idx == 5) { c1.val('기타'); c2.val(v != '' ? '0' : ''); }
            });
            _zw.formEx.autoCalc($('#__subtable10'), nm[0]);
        }
    }
});