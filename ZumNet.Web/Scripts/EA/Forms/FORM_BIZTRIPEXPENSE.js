//const { alphaNumerate } = require("chartist");

$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            return true;
        },
        "make": function (f) {
        },
        "checkEvent": function (ckb, el, fld) {
            _zw.formEx.event($('#__mainfield[name="TRIPFROM"]')[0]);
        },
        "calc": function (el) {
            if (el.name == "EXCHANGE2" || el.name == "EXCHANGE3" || el.name == "EXCHANGE4" || el.name == "EXCHANGE5" || el.name == "EXCHANGE6" || el.name == "EXCHANGE7" || el.name == "EXCHANGE8") {
                if (el.value != '') {
                    $('#__FormView .f-lbl-sub [name="' + el.name.replace("EXCHANGE", "EXCHANGE_") + '"]').each(function () {
                        $(this).val(el.value);
                    });
                    if (el.name == "EXCHANGE2" || el.name == "EXCHANGE3") {
                        _zw.formEx.dailyPay(parseInt($('#__mainfield[name="DAILYPAY"]').val()), parseInt($('#__mainfield[name="STAY"]').val()), $('#__mainfield[name="EXCHANGE2"]').val(), $('#__subtable5 tr.sub_table_row').first().find('td:nth-child(6)'));
                    }
                    _zw.formEx.calcForm();
                }
            } else {
                var n = $('#__mainfield[name="LOCATION"]');
                if (n && $.trim(n.val()) == '') { bootbox.alert('출장지를 선택 하십시오!', function () { el.value = ''; }); return false; }
                //if (n && $.trim(n.val()) == '') { alert('출장지를 선택 하십시오!'); return false; }

                n = $('#__mainfield[name="TRIPFROM"]');
                if (n && $.trim(n.val()) == '') { bootbox.alert('출장시작일을 입력 하십시오!', function () { el.value = ''; }); return false; }
                //if (n && $.trim(n.val()) == '') { alert('출장시작일을 입력 하십시오!'); return false; }

                n = $('#__mainfield[name="TRIPTO"]');
                if (n && $.trim(n.val()) == '') { bootbox.alert('출장종료일을 입력 하십시오!', function () { el.value = ''; }); return false; }
                //if (n && $.trim(n.val()) == '') { alert('출장종료일을 입력 하십시오!'); return false; }

                _zw.formEx.calcForm(el);
            }
        },
        "autoCalc": function (p) {
            _zw.formEx.calcForm();
        },
        "calcForm": function (el) {
            var p, row, el1, el2, el3, el4, el5;
            var s = 0, idx = 0, prefix = '', iStd = 0, f = '0,0';
            if (el) {
                p = el.parentNode.parentNode;
                idx = el.name.substr(el.name.length - 1); prefix = el.name.substr(0, 1); //console.log(prefix + " : " + idx)
                el1 = $('#__mainfield[name="CURRENCY' + idx + '"]'); el2 = $('#__mainfield[name="EXCHANGE' + idx + '"]'); ex = $('#__mainfield[name="EXCHANGE2"]');
                el3 = p.cells[p.cells.length - 10].firstChild;

                if (prefix == 'C') {
                    el4 = p.cells[3].firstChild; el5 = p.cells[4].firstChild;
                    if (el4.value == '') { bootbox.alert("식비구분을 선택하십시오!", function () { el4.focus(); el.value = ''; }); return; }
                    if (el5.value == '' || el5.value == '0') { bootbox.alert("인원수를 입력하십시오!", function () { el5.focus(); el.value = ''; }); return; }

                    if (el4.value == "갑지1") iStd = 24 * parseFloat(_zw.ut.empty(ex.val())) * parseFloat(_zw.ut.empty(el5.value));
                    else if (el4.value == "갑지2") iStd = 12 * parseFloat(_zw.ut.empty(ex.val())) * parseFloat(_zw.ut.empty(el5.value));
                    else if (el4.value == "을지") iStd = 12 * parseFloat(_zw.ut.empty(ex.val())) * parseFloat(_zw.ut.empty(el5.value));
                    else if (el4.value == "일본") iStd = 1500 * parseFloat(_zw.ut.empty($('#__mainfield[name="EXCHANGE3"]').val())) * parseFloat(_zw.ut.empty(el5.value));

                    s = parseFloat(_zw.ut.empty(el.value)) * parseFloat(_zw.ut.empty(el2.val()));
                    iStd = iStd.toFixed(0); s = s.toFixed(0); console.log(iStd + " : " + s)
                    if (s - iStd > 0) { bootbox.alert("식비한도(" + el4.value + " " + numeral(iStd).format(f) + "원)를 초과할 수 없습니다!", function () { el.value = ''; el.focus(); }); return; }
                }
                s = 0;
                if (el1.value != '' && el2.value != '' && el3.value != '') {
                    do { p = p.parentNode; } while (p.tagName != 'TABLE');

                    $(p).find('td :text[name="' + el.name + '"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value)) * parseFloat(_zw.ut.empty(el2.val()))).value(); });
                    $('#__mainfield[name="' + prefix + 'SUM' + idx + '"]').val(numeral(s).format(f));

                    s = 0;
                    for (var x = 1; x <= 8; x++) { s += numeral($('#__mainfield[name="' + prefix + 'SUM' + x.toString() + '"]').val()).value(); }
                    $('#__mainfield[name="' + prefix + 'TOTAL"]').val(numeral(s).format(f));

                    _zw.formEx.expenseTotal();
                } else {
                    el.value = '';
                }
            } else {
                for (var i = 1; i <= 5; i++) {
                    p = $('#__subtable' + i.toString());
                    var len = p.find('tr.sub_table_row').first().find('td').length;
                    p.find('tr.sub_table_row').first().find('td').each(function (k) {
                        if (k >= len - 9 && k < len - 1) {
                            el1 = $(this).find('input[name]'); idx = el1.attr('name').substr(el1.attr('name').length - 1); prefix = el1.attr('name').substr(0, 1);
                            ex = $('#__mainfield[name="EXCHANGE' + idx + '"]');

                            s = 0; //console.log(idx + ' : el1 => ' + el1.attr('name'))
                            p.find('td :text[name="' + el1.attr('name') + '"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value)) * parseFloat(_zw.ut.empty(ex.val()))).value(); })
                            $('#__mainfield[name="' + prefix + 'SUM' + idx + '"]').val(numeral(s).format(f));
                        }
                    });
                    
                    s = 0;
                    for (var x = 1; x <= 8; x++) { s += numeral($('#__mainfield[name="' + prefix + 'SUM' + x.toString() + '"]').val()).value(); }
                    $('#__mainfield[name="' + prefix + 'TOTAL"]').val(numeral(s).format(f));
                }
                _zw.formEx.expenseTotal();
            }
        },
        "date": function (el) {
            var from, to, n, el2, el3, el4, el5;
            if (el.name == "TRIPFROM" || el.name == "TRIPTO") {
                n = $('#__mainfield[name="LOCATION"]');
                //if (n && $.trim(n.val()) == '') { bootbox.alert('출장지를 선택 하십시오!'); return false; }
                //if (n && $.trim(n.val()) == '') { alert('출장지를 선택 하십시오!'); return false; }
                from = $('#__mainfield[name="TRIPFROM"]'); to = $('#__mainfield[name="TRIPTO"]');

            } else if (el.name == "FROMDATE" || el.name == "TODATE") {
                from = $(el).parent().parent().find('td :text[name="FROMDATE"]'); to = $(el).parent().parent().find('td :text[name="TODATE"]');

            } else if (el.name == "JPTRIPFROM" || el.name == "JPTRIPTO") { //일본출장일 내용 추가
                from = $('#__mainfield[name="JPTRIPFROM"]'); to = $('#__mainfield[name="JPTRIPTO"]');
                el2 = $('#__mainfield[name="TRIPFROM"]'); el3 = $('#__mainfield[name="TRIPTO"]');
                el4 = $('#__mainfield[name="JPSTAY"]'); el5 = $('#__mainfield[name="JPDAY"]');

                if (el.name == "JPTRIPFROM" && el.value != '') {
                    if (from.val() < el2.val() || from.val() > el3.val()) {
                        bootbox.alert('일본출장 시작일을 전체출장일안에 포함시켜주십시오!', function () { from.val(''); el4.val(''); el5.val(''); });
                        //alert('일본출장 시작일을 전체출장일안에 포함시켜주십시오!');
                        _zw.formEx.event(el4[0]); return false;
                    }
                } else if (el.name == "JPTRIPTO" && el.value != '') {
                    if (to.val() < el2.val() || to.val() > el3.val()) {
                        bootbox.alert('일본출장 종료일을 전체출장일안에 포함시켜주십시오!', function () { to.val(''); el4.val(''); el5.val(''); });
                        //alert('일본출장 종료일을 전체출장일안에 포함시켜주십시오!');
                        _zw.formEx.event(el4[0]); return false;
                    }
                }

            } else if (el.name == "EXPENSEDATE") {//식비 지출일
                n = el.parentNode;
                do { n = n.parentNode; } while (n.tagName != 'TABLE');

                if (n.id == '__subtable3' && el.value != '') {
                    el.value += ' (' + moment(el.value).format('dd') + ')';
                }
            }

            if (from && from.length > 0 && to && to.length > 0) {
                var dif = _zw.ut.diff('day', to.val(), from.val()); //console.log(dif + " : " + !(dif))
                if (dif && dif < 0) { bootbox.alert('날짜 범위 입력 오류!', function () { to.val(''); to.focus(); }); return false; }

                if (dif) { //alert(dif + " : " + (dif-1))
                    if (el.name == "TRIPFROM" || el.name == "TRIPTO") {
                        $('#__mainfield[name="STAY"]').val(dif); $('#__mainfield[name="DAY"]').val(dif + 1);
                        _zw.formEx.event(from[0]);

                    } else if (el.name == "JPTRIPFROM" || el.name == "JPTRIPTO") {
                        $('#__mainfield[name="JPSTAY"]').val(dif); $('#__mainfield[name="JPDAY"]').val(dif + 1);
                        _zw.formEx.event($('#__mainfield[name="JPSTAY"]')[0]);
                    }
                }
            }
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

                _zw.formEx.event(''); //일비 가져오기
            });
            p.modal('hide');
        },
        "change": function (x, fld) {
            $(x).next().val($(x).children('option:selected').text());
            _zw.formEx.event(x);
        },
        "optionWnd": function (pos, w, h, l, t, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.');
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]);
            var m = '', v1 = '', v2 = '', v3 = '';
            if (vPos[0] == 'erp') m = 'getoracleerp';
            else if (vPos[0] == 'report') m = 'getreportsearch';
            else m = 'getcodedescription';

            var pOption = ['N', ''];
            if (vPos[1] == 'centercode2') pOption = ['F', 'checkbox'];
            else {
                var n = $('#__mainfield[name="LOCATION"]');
                if (n && $.trim(n.val()) == '') { bootbox.alert('출장지를 선택 하십시오!'); return false; }

                n = $('#__mainfield[name="TRIPFROM"]');
                if (n && $.trim(n.val()) == '') { bootbox.alert('출장시작일을 입력 하십시오!'); return false; }
            }

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
                                $('#__mainfield[name="' + param[0] + '"]').val(v); //_zw.formEx.event(param[0]);
                                p.modal('hide');
                            });

                            p.on('hidden.bs.modal', function () { p.html(''); });
                            p.modal();

                        } else {
                            var j = { "close": true, "width": w, "height": h, "left": l, "top": t }
                            j["title"] = el.attr('title'); j["content"] = res.substr(2);

                            var pop = _zw.ut.popup(el[0], j);
                            pop.find('a[data-val]').click(function () {
                                if (param[0].indexOf('CURRENCY') != -1) {
                                    for (var i = 1; i <= 8; i++) {
                                        var temp = $('#__mainfield[name="CURRENCY' + i.toString() + '"]');
                                        if (temp.val() == param[0]) { bootbox.alert("[" + param[0] + "]는(은) 이미 선택 되어 있습니다!"); return; }
                                    }
                                }

                                var v = $(this).attr('data-val').split('^');
                                for (var i = 0; i < param.length; i++) {
                                    el.parent().parent().find('[name="' + param[i] + '"]').val(v[i]);
                                }

                                _zw.formEx.exchangeInfo($('#__mainfield[name="TRIPFROM"]').val()); _zw.formEx.calcForm();
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
        "event": function (x) { //console.log(x)
            if (x) {
                if (x.name == "TRIPFROM") _zw.formEx.exchangeInfo(x.value);
                else {
                    row = x.parentNode.parentNode;
                    if (x.name == "EXPENSERULE") {
                        for (var i = row.cells.length - 2; i >= row.cells.length - 9; i--) { row.cells[i].firstChild.value = ''; }
                    } else if (x.name == "EXPENSETYPECODE") {
                        if (x.value == "CASH") {
                            for (var i = row.cells.length - 2; i >= row.cells.length - 9; i--) {
                                $(row.cells[i].firstChild).removeClass('txtRead_Right').addClass('txtDollar').prop('readonly', false).val('');
                                _zw.fn.input(row.cells[i].firstChild);
                            }
                        } else {
                            for (var i = row.cells.length - 2; i >= row.cells.length - 9; i--) {
                                if (x.value != '' && i == row.cells.length - 9) {
                                    $(row.cells[i].firstChild).removeClass('txtRead_Right').addClass('txtDollar').prop('readonly', false).val('');
                                    _zw.fn.input(row.cells[i].firstChild);
                                } else $(row.cells[i].firstChild).removeClass('txtDollar').addClass('txtRead_Right').prop('readonly', true).val('');
                            }
                        }
                    }
                }
            }

            if (!x || x.name == "TRIPFROM" || x.name == "JPSTAY") {
                var e = $('#__mainfield[name="STAY"]'), v1 = $('#__mainfield[name="TRIPPERSONID"]'), v2 = $('#__mainfield[name="TRIPPERSONDEPTID"]'), v3 = 0, v = '';

                if (v1.val() != '' && e.val() != '') {

                    var dif = _zw.ut.diff('day', $('#__mainfield[name="TRIPFROM"]').val(), '2019-03-01');
                    v3 = dif && dif < 0 ? '2' : '1';

                    $.ajax({
                        type: "POST",
                        url: "/EA/Common",
                        async: false,
                        data: '{M:"getreportsearch",body:"S", k1:"",k2:"BIZTRIP_EXPENSERULE",k3:"",v1:"' + v1.val() + '",v2:"' + v2.val() + '",v3:"' + v3 + '"}',
                        success: function (res) {
                            //if (res.substr(0, 2) == 'OK') { v = res.substr(2); }
                            //else { bootbox.alert(res); return false; }
                            v = res;
                        },
                        beforeSend: function () { }
                    });

                    if (v.substr(0, 2) == 'OK') {
                        v = v.substr(2);
                        $('#__mainfield[name="DAILYPAY"]').val(v);

                        $('#__subtable5 tr.sub_table_row').first().find('td').each(function (idx) {
                            if (idx == 1) $(this).find('input[name]').val($('#__mainfield[name="TRIPTO"]').val());
                            else if (idx == 2) $(this).find('input[name]').val($('#__mainfield[name="LOCATION"]').val());
                            else if (idx == 3) $(this).find('input[name]').val('일비');
                            else if (idx == 4) $(this).find('[name="EXPENSETYPECODE"]').val('CASH').prop('disabled', true);
                            else if (idx == 5) {
                                //dpay, dur, USD, cell
                                _zw.formEx.dailyPay(v, parseInt(e.val()), $('#__mainfield[name="EXCHANGE2"]').val(), $(this).find('input[name]'));
                            }
                            else if (idx > 5) {
                                var c = $(this).find('input[name]');
                                if (c.attr('name') != 'ETC') c.removeClass('txtDollar').addClass('txtRead').prop('readonly', true).val('');
                            }
                        });
                    } else { bootbox.alert(v); return false; }
                }
            }
            _zw.formEx.calcForm();
        },
        "dailyPay": function (v, dur, ex, tgt) {
            var jptrip = 0, jpsum = 0, s = 0, f = '0,0.[0000]';
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

            var from = $('#__mainfield[name="TRIPFROM"]'), jfrom = $('#__mainfield[name="JPTRIPFROM"]'), jto = $('#__mainfield[name="JPTRIPTO"]'),
                jstay = $('#__mainfield[name="JPSTAY"]'), jex = $('#__mainfield[name="EXCHANGE3"]'), pcheck = $('#__mainfield[name="PAYCHECK"]');

            v = v == '' ? 0 : parseInt(v); //console.log(v + " : " + dur)
            ex = parseFloat(_zw.ut.empty(ex));

            if (pcheck.val() == '일비없음') {
                tgt.val('0');
            } else {
                if (jstay.val() == '' || jstay.val() == '0') {
                    if (dur < 15) s = parseFloat(dur * v * ex);
                    else s = parseFloat(14 * v * ex) + parseFloat((dur - 14) * v * 0.9 * ex);
                } else {
                    if (dur < 15) s = ((dur - parseInt(jstay.val())) * v * ex) + (parseInt(jstay.val()) * jptrip * parseFloat(_zw.ut.empty(jex.val())));
                    else {
                        var dif = _zw.ut.diff('day', from.val(), jfrom.val());
                        jpsum = dif * parseInt(jstay.val());

                        if (dif > 14) {
                            s = parseFloat(14 * v * ex) + ((dur - parseInt(jstay.val()) - 14) * 0.9 * v * ex) + (parseInt(jstay.val()) * 0.9 * jptrip * parseFloat(_zw.ut.empty(jex.val())));
                        } else {
                            if (jpsum > 14) {
                                s = (dif * v * ex) + ((14 - dif) * jptrip * parseFloat(_zw.ut.empty(jex.val()))) + ((dur - dif - parseInt(jstay.val())) * 0.9 * v * ex) + ((parseInt(jstay.val()) - 14 + dif) * 0.9 * jptrip * parseFloat(_zw.ut.empty(jex.val())))
                            } else {
                                s = ((dur - 14) * 0.9 * v * ex) + ((14 - parseInt(jstay.val())) * v * ex) + (parseInt(jstay.val()) * jptrip * parseFloat(_zw.ut.empty(jex.val())));
                            }
                        }
                    }
                }
                if (pcheck.val() == '일비있음') tgt.val(numeral(s).format(f));
                else if (pcheck.val() == '일비50') tgt.val(numeral(s / 2).format(f));
            }
        },
        "exchangeInfo": function (dt) {
            $.ajax({
                type: "POST",
                url: "/EA/Common",
                async: false,
                data: '{M:"getoracleerp",body:"S", k1:"",k2:"exchangeinfo",k3:"",v1:"KRW",v2:"' + dt + '",v3:"' + dt + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == 'OK') {
                        var j = JSON.parse(res.substr(2)); //console.log(j)
                        var c1, c2, v, col1, col2, f = '0,0.[0000]';
                        for (var x = 2; x <= 8; x++) {
                            c1 = $('#__mainfield[name="STDCURRENCY' + x.toString() + '"]');
                            c2 = $('#__mainfield[name="STDEXCHANGE' + x.toString() + '"]');
                            v = j[c1.val()] ? j[c1.val()] : "0";
                            c2.val(numeral(_zw.ut.empty(v)).format(f)); //여기까지 기준환율

                            c1 = $('#__mainfield[name="CURRENCY' + x.toString() + '"]');
                            c2 = $('#__mainfield[name="EXCHANGE' + x.toString() + '"]');
                            v = j[c1.val()] ? j[c1.val()] : "0";
                            c2.val(numeral(_zw.ut.empty(v)).format(f));
                   
                            col1 = $('.ft-sub .f-lbl-sub :text[name="CURRENCY_' + x.toString() + '"]');
                            col2 = $('.ft-sub .f-lbl-sub :text[name="EXCHANGE_' + x.toString() + '"]');
                            for (var i = 0; i < col1.length; i++) {
                                col1[i].value = c1.val(); col2[i].value = numeral(_zw.ut.empty(v)).format(f);
                            }
                        }
                    }
                    else { bootbox.alert(res); return false; }
                }
            });
        },
        "expenseTotal": function () {
            var s1 = $('#__mainfield[name="TOTCARDCORP1"]'), s2 = $('#__mainfield[name="TOTCARDCORP2"]'), s3 = $('#__mainfield[name="TOTCARDPERSON"]'),
                s4 = $('#__mainfield[name="TOTCASH"]'), s5 = $('#__mainfield[name="TOTSUM"]'), s6 = $('#__mainfield[name="TOTCOST"]');
            var iTotCorp1 = 0, iTotCorp2 = 0, iTotPerson = 0, iTotCash = 0, iSum = 0, iHeader = 0, idx = 0;
            var c1, c2, ex, f = '0,0';

            for (var i = 1; i <= 5; i++) {
                $('#__subtable' + i.toString() + ' tr.sub_table_row').each(function () {
                    var len = $(this).find('> td').length; c1 = $(this).find('> td > select[name="EXPENSETYPECODE"]');
                    $(this).find('> td').each(function (k) {
                        if (k >= len - 9 && k < len - 1) {
                            c2 = $(this).find('input[name]'); idx = c2.attr('name').substr(c2.attr('name').length - 1);
                            ex = $('#__mainfield[name="EXCHANGE' + idx + '"]');
                            if (c2.val() != '' && c2.val() != '0') {
                                iSum += parseFloat(_zw.ut.empty(c2.val())) * parseFloat(_zw.ut.empty(ex.val()))
                            }
                        }
                    });
                    if (c1.val() == "CARDCORP1") iTotCorp1 += iSum;
                    else if (c1.val() == "CARDCORP2") iTotCorp2 += iSum;
                    else if (c1.val() == "CARDPERSON") iTotPerson += iSum;
                    else if (c1.val() == "CASH") iTotCash += iSum;
                    iSum = 0;
                });
                s1.val(numeral(iTotCorp1).format(f)); s2.val(numeral(iTotCorp2).format(f));
                s3.val(numeral(iTotPerson).format(f)); s4.val(numeral(iTotCash).format(f));

                //개인경비합계
                s5.val(numeral(iTotCorp2 + iTotPerson + iTotCash).format(f));
                //경비합계
                s6.val(numeral(iTotCorp1 + iTotCorp2 + iTotPerson + iTotCash).format(f));
            }
        }
    }
});