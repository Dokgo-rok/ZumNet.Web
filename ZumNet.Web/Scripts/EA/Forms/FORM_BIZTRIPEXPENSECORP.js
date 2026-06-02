//const { alphaNumerate } = require("chartist");

$(function () {
    var CURRENCY_CNT = 9;   //전체 통화(국가) 수
    var BASE_ACNT = { "A2": {}, "A4": {} };     //기본 계정과목 정보
    //var CARD_ACK = [];  //카드사용현황

    //removeCardAck = function (ack) {
    //    if (ack && ack != '') {
    //        for (var i = 0; i < CARD_ACK.length; i++) {
    //            if (CARD_ACK[i]['ACKID'] == ack) { CARD_ACK.splice(i, 1); break; }
    //        }
    //    }
    //}

    //checkCardAck = function (ack) {
    //    if (ack && ack != '') {
    //        for (var i = 0; i < CARD_ACK.length; i++) {
    //            if (CARD_ACK[i]['ACKID'] == ack) return true;
    //        }
    //    }
    //    return false;
    //}

    _zw.formEx = {
        "init": function () { //초기 설정 : 하단 호출
            if (_zw.V.apvmode == 'draft') {
                var d = moment(_zw.V.current.date).subtract(1, 'M').format('YYYY-MM') + '-01'; //AP일자 : 전월 1일
                $('.datepicker[name="APDATE"]').datepicker('setStartDate', d);

                _zw.formEx.event('supplier', $('#__mainfield[name="TRIPPERSONEMPID"]').val());

                $('.fm [aria-controls="vw-move-toolbar"] button:first')[0].click();
            }
        },
        "addRow": function (row) { //26-02-19 추가
            if (row.is('[data-ackid]')) row.attr('data-ackid', '')
            if (row.is('[data-attr]')) row.attr('data-attr', '')
            if (row.is('[data-pos]')) row.attr('data-pos', '');
            row.find('td > [name!="ROWSEQ"]').each(function () {
                if ($(this).attr('placeholder') !== undefined) $(this).attr('placeholder', '');
                $(this).val('').prop('disabled', false);
            }); _zw.fn.input(row);

            //var p = $("#__subtable3").parent().parent().parent().parent(), offset = p.offset();
            //var css = {};
            //css['position'] = 'absolute';
            //css['top'] = offset.top + 'px';
            //css['left'] = offset.left + 'px';
            //css['width'] = p.width() + 'px';
            //css['height'] = p.height() + 'px';
            //$('#tbl_mask_3').css({ 'position': 'absolute', 'top': (offset.top - 47.2 + $('.z-list-scroll').scrollTop()) + 'px', 'left': (offset.left-8) + 'px', 'width': p.width() + 'px', 'height': p.height() + 'px' });
            //$('#tbl_mask_1').css(css);
            //var offset = p.offset(); console.log(offset.top, offset.left, p.width(), p.height(), $('.z-list-scroll').scrollTop());

            return row;
        },
        "checkCardAck": function (ack) {
            if (ack && ack != '') {
                if ($('tr.sub_table_row[data-ackid="' + ack + '"]').length > 0) return true;
            }
            return false;
        },
        "appVchTbl": function (m) {
            var p = $('#__subtable6'), subSeq = $('div[aria-controls="vw-move-toolbar"] .btn:disabled').attr('data-for').split('_')[1];
            _zw.formEx.initVchTbl(p, subSeq);

            var subId = '__subtable' + subSeq.toString(), tbl = $('#' + subId);
            if (m && m == 'cancel') { _zw.formEx.disableForm(tbl, false); return false; }

            tbl.find('tr.sub_table_row').each(function () {
                var e1, e2, e3, e4, e5, sum = 0, etcVal = '', bCheck = false;
                e1 = $(this).find('td [name="EXPENSETYPECODE"]'); sum = _zw.formEx.calcRowSum($(this)); //console.log(e1.val() + " : " + sum.toString());
                if (e1.val() != '' && sum > 0) { //구분, 금액 있는 경우 적용 대상
                    if (subSeq.toString() == '1') {//숙박비
                        e2 = $(this).find('td [name="FROMDATE"]'); e3 = $(this).find('td [name="TODATE"]');
                        e4 = $(this).find('td [name="LOCATION"]'); e5 = $(this).find('td [name="HOTEL"]');

                        if (e1.val() != '' && e2.val() != '' && e3.val() != '' && e4.val() != '' && e5.val() != '' && sum > 0) {
                            etcVal = "(" + e2.val() + ") " + e4.val() + " " + e5.val();
                            bCheck = true;
                        }

                    } else if (subSeq.toString() == '2') {//교통비
                        e2 = $(this).find('td [name="EXPENSEDATE"]'); e3 = $(this).find('td [name="VEHICLES"]');
                        e4 = $(this).find('td [name="SECTION"]');

                        if (e1.val() != '' && e2.val() != '' && e3.val() != '' && e4.val() != '' && sum > 0) {
                            etcVal = "(" + e2.val() + ") " + e4.val();
                            bCheck = true;
                        }

                    } else if (subSeq.toString() == '3') {//식비
                        e2 = $(this).find('td [name="EXPENSEDATE"]'); e3 = $(this).find('td [name="LOCATION"]');
                        e4 = $(this).find('td [name="EXPENSERULE"]'); e5 = $(this).find('td [name="COMMENT"]');

                        if (e1.val() != '' && e2.val() != '' && e3.val() != '' && e4.val() != '' && sum > 0) {
                            etcVal = "(" + e2.val() + ") " + e3.val() + " " + e4.val() + " " + e5.val();
                            bCheck = true;
                        }

                    } else if (subSeq.toString() == '4' || subSeq.toString() == '5') {//접대비, 기타
                        e2 = $(this).find('td [name="EXPENSEDATE"]'); e3 = $(this).find('td [name="LOCATION"]');
                        e4 = $(this).find('td [name="COMMENT"]');

                        if (e1.val() != '' && e2.val() != '' && e3.val() != '' && e4.val() != '' && sum > 0) {
                            etcVal = "(" + e2.val() + ") " + e4.val();
                            bCheck = true;
                        }
                    }

                    if (bCheck) { _zw.formEx.insertVchInfo(p, subSeq, $(this), sum, etcVal); }
                    else { bootbox.alert('필수항목 누락!'); return false; }
                }
            });

            _zw.formEx.disableForm(tbl, true);
        },
        "initVchTbl": function (p, subSeq) {           
            var row = p.find('tr.sub_table_row'), tgt = p.find('tr.sub_table_row[data-pos="' + subSeq.toString() + '"]');
            if (tgt.length > 0) {
                var iBaseRowCnt = 5, iDiff = row.length - iBaseRowCnt; //console.log(iBaseRowCnt + " : " + iDiff)
                $(tgt.get().reverse()).each(function (idx) {
                    if (idx < iDiff) $(this).remove();
                    else { _zw.form.resetField($(this)); $(this).attr('data-pos', ''); }
                });
                _zw.form.orderRow(p);
            }
        },
        "calcRowSum": function (row) {
            var len = row.find('> td').length; c1 = row.find('> td > select[name="EXPENSETYPECODE"]'), iSum = 0;
            row.find('> td').each(function (k) {
                if (k >= len - (CURRENCY_CNT + 1) && k < len - 1) {
                    c2 = $(this).find('input[name]'); idx = c2.attr('name').substr(c2.attr('name').length - 1);
                    ex = $('#__mainfield[name="EXCHANGE' + idx + '"]');
                    if (c2.val() != '' && c2.val() != '0') {
                        iSum += parseFloat(_zw.ut.empty(c2.val())) * parseFloat(_zw.ut.empty(ex.val()))
                    }
                }
            });
            return iSum;
        },
        "insertVchInfo": function (p, subSeq, row, s, etc) {
            var tgt = p.find('tr.sub_table_row[data-pos=""]').first(), code = row.find('td [name="EXPENSETYPECODE"]').val(), f = '0,0'; //console.log("p : " + p.id);
            if (tgt.length == 0) tgt = _zw.form.addRow(p.attr('id'));

            tgt.attr('data-pos', subSeq.toString());
            tgt.find('td [name="LINKROW"]').val(subSeq.toString() + '.' + row.find('td [name="ROWSEQ"]').val());
            tgt.find('td [name="EXPENSETYPE"]').val(row.find('td [name="EXPENSETYPE"]').val());
            tgt.find('td [name="EXPENSETYPECODE"]').val(code);

            if (subSeq != '5') {
                var jAcnt = subSeq == '4' ? BASE_ACNT['A2'] : BASE_ACNT['A4'];
                tgt.find('td [name="ACNTNM"]').val(jAcnt['nm']);
                tgt.find('td [name="ACNTDPCD"]').val(jAcnt['dpcd']);
                tgt.find('td [name="ACNTMAIN"]').val(jAcnt['main']);
                tgt.find('td [name="ACNTSUB"]').val(jAcnt['sub']);
                tgt.find('td [name="ACNTID"]').val(jAcnt['id']);
                tgt.find('td [name="ACNTCLS"]').val(jAcnt['cls']);
                tgt.find('td [name="ACNTCLSNM"]').val(jAcnt['clsnm']);

                if (subSeq != '4') {
                    tgt.find('td [name="DETAILINFO1"]').val($('#__mainfield[name="TRIPFROM"]').val());
                    tgt.find('td [name="DETAILINFO2"]').val($('#__mainfield[name="TRIPTO"]').val());
                }
            }            

            if (code != 'CARDCORP1') {
                tgt.find('td [name="SUPPLIERDEPTCD"]').val($('#__mainfield[name="SUPPLIERDEPTCD"]').val());
                tgt.find('td [name="SUPPLIERDEPT"]').val($('#__mainfield[name="SUPPLIERDEPT"]').val());
            }

            tgt.find('td [name="TAXRATE"]').val('Except Declare');
            tgt.find('td [name="TAXRATECODE"]').val('EN');
            tgt.find('td [name="TAXEXPL"]').val('신고제외');
            tgt.find('td [name="TAXEXPLCODE"]').val('EN');
            tgt.find('td [name="TAXNONDEDU"]').val('.'); //불공제사유
            tgt.find('td [name="TAXNONDEDUCODE"]').val(' ');
            tgt.find('td [name="ETC"]').val(etc);

            if (code != 'CARDCORP2') {
                tgt.find('td [name="MERCTAXKINDCODE"]').val('99'); _zw.formEx.change(tgt.find('td [name="MERCTAXKINDCODE"]')[0]);
                tgt.find('td [name="ACKAMT"]').val(numeral(s).format(f));
                tgt.find('td [name="VALSUPPLY"]').val(numeral(s).format(f));
                tgt.find('td [name="VAT"]').val('0');
                tgt.find('td [name="REQAMT"]').val(numeral(s).format(f));
            } else {
                var j = JSON.parse(row.attr('data-attr'));
                for (var x in j) {
                    if (x == 'REQAMT') tgt.find('td [name="' + x + '"]').val(numeral(s).format(f));
                    else tgt.find('td [name="' + x + '"]').val(j[x]);
                }
                if (j["PURCHASEFLAG"] == '04') {
                    tgt.find('td [name="ACKAMT"], td [name="VALSUPPLY"], td [name="VAT"], td [name="REQAMT"]').addClass('text-danger');
                } else {
                    tgt.find('td [name="ACKAMT"], td [name="VALSUPPLY"], td [name="VAT"], td [name="REQAMT"]').removeClass('text-danger');
                }
                _zw.formEx.change(tgt.find('td [name="MERCTAXKINDCODE"]')[0]);

                tgt.find('td [name="AQUIDATE"], td [name="CARDNUM"], td [name="ACKNO"], td [name="MERCNAME"], td [name="MERCSOCNO"]').prop('disabled', true);
            }
        },
        "disableForm": function (t, b) {
            var ifixed = t.attr('fixed') !== undefined ? parseInt(t.attr('fixed')) - 1 : -1;
            if (ifixed >= 0) t.find('tr.sub_table_row:gt(' + ifixed.toString() + ') td [name]').prop('disabled', b);
            else t.find('tr.sub_table_row td [name]').prop('disabled', b);

            var p = t.parent().parent().parent().parent();
            p.find('.fm-button .btn').prop('disabled', b);
            if (b) p.find('a').addClass('d-none');
            else p.find('a').removeClass('d-none');
        },
        "validation": function (cmd) {
            var rt = true;
            if (cmd == "draft") { //기안
                var el, el2, e, v, s, s2, f, to = 0;
                s = 'CARDNUM;카드번호^ACKNO;승인번호^MERCNAME;가맹점명^MERCSOCNO;사업자번호^ACKAMT;승인금액^VALSUPPLY;공급가액^VAT;부가세^REQAMT;인정금액^MERCTAXKINDCODE;과세구분^TAXRATE;세금구분^TAXEXPL;세목^ETC;적요';
                s2 = 'MERCNAME;가맹점명^MERCSOCNO;사업자번호^ACKAMT;승인금액^VALSUPPLY;공급가액^VAT;부가세^REQAMT;인정금액^MERCTAXKINDCODE;과세구분^TAXRATE;세금구분^TAXEXPL;세목^ETC;적요';

                $('#__subtable6 tr.sub_table_row').each(function (idx) {
                    el = $(this).find('[name="EXPENSETYPECODE"]');
                    if (el.val() != '') {
                        if (el.val() == 'CARDCORP1' || el.val() == 'CARDCORP2' || el.val() == 'CARDPERSON') v = s.split('^');
                        else if (el.val() == 'CASH') v = s2.split('^');

                        for (var i = 0; i < v.length; i++) {
                            f = v[i].split(';');
                            e = $(this).find('[name="' + f[0] + '"]');
                            if (e.length > 0 && $.trim(e.val()) == '') { bootbox.alert("필수항목 [" + f[1] + "] 누락!", function () { e.focus(); }); rt = false; return false; }
                        }

                        if ($(this).find('[name="TAXEXPLCODE"]').val() == 'S2') {
                            e = $(this).find('[name="TAXNONDEDU"]');
                            if (e.length > 0 && $.trim(e.val()) == '') { bootbox.alert("[불공제사유]를 선택하십시오!", function () { e.focus(); }); rt = false; return false; }
                        }

                        //금액 확인(인정금액 <= 승인금액)
                        if (_zw.ut.sub(0, $(this).find('[name="REQAMT"]').val(), $(this).find('[name="ACKAMT"]').val()) > 0) {
                            bootbox.alert("[인정금액]은 [승인금액] 보다 클 수 없습니다!"); rt = false; return false;
                        }

                        el2 = $(this).find('[name="ACNTCLS"]'); //계정분류코드
                        if (el2.val() == 'A1') to = 5;
                        else if (el2.val() == 'A2') to = 8;
                        else if (el2.val() == 'A3' || el2.val() == 'B3' || el2.val() == 'D1') to = 1;
                        else if (el2.val() == 'A4' || el2.val() == 'B1' || el2.val() == 'B2' || el2.val() == 'C1') to = 2;
                        else to = 0;

                        for (var i = 1; i <= to; i++) {
                            e = $(this).find('[name="DETAILINFO' + i.toString() + '"]');
                            if (e.length > 0 && $.trim(e.val()) == '') { bootbox.alert("필수항목 [세부정보] 누락!"); rt = false; return false; }
                        }
                    }
                });
            }
            return rt;
        },
        "make": function (f) {
        },
        "checkEvent": function (ckb, el, fld) {
            _zw.formEx.event($('#__mainfield[name="TRIPFROM"]')[0]);
        },
        "calc": function (el) {
            if (el.name == "EXCHANGE2" || el.name == "EXCHANGE3" || el.name == "EXCHANGE4" || el.name == "EXCHANGE5" || el.name == "EXCHANGE6" || el.name == "EXCHANGE7" || el.name == "EXCHANGE8" || el.name == "EXCHANGE9") {
                if (el.value != '') {
                    $('#__FormView .f-lbl-sub [name="' + el.name.replace("EXCHANGE", "EXCHANGE_") + '"]').each(function () {
                        $(this).val(el.value);
                    });
                    if (el.name == "EXCHANGE2" || el.name == "EXCHANGE3") {
                        _zw.formEx.dailyPay(parseInt($('#__mainfield[name="DAILYPAY"]').val()), parseInt($('#__mainfield[name="STAY"]').val()), $('#__mainfield[name="EXCHANGE2"]').val(), $('#__subtable5 tr.sub_table_row').first().find('td:nth-child(6)'));
                    }
                    _zw.formEx.calcForm();
                }
            } else if (el.name == "CARDNUM" || el.name == "ACKNO" || el.name == "MERCSOCNO") {

            } else {
                if (el.value != '') {
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
            }
        },
        "autoCalc": function (p, row) {
            //console.log(row)
            _zw.formEx.calcForm();
        },
        "calcForm": function (el) {
            var p, row, el1, el2, el3, el4, el5;
            var s = 0, idx = 0, prefix = '', iStd = 0, f = '0,0';
            if (el) {
                p = el.parentNode.parentNode;
                idx = el.name.substr(el.name.length - 1); prefix = el.name.substr(0, 1);
                el1 = $('#__mainfield[name="CURRENCY' + idx + '"]'); el2 = $('#__mainfield[name="EXCHANGE' + idx + '"]'); ex = $('#__mainfield[name="EXCHANGE2"]');
                el3 = p.cells[p.cells.length - (CURRENCY_CNT + 2)].firstChild; //console.log(el1.val() + " : " + el2.val() + " : " + el3.value)

                if (prefix == 'C') {
                    el4 = p.cells[3].firstChild; el5 = p.cells[4].firstChild;
                    if (el4.value == '') { bootbox.alert("식비구분을 선택하십시오!", function () { el4.focus(); el.value = ''; }); return; }
                    if (el5.value == '' || el5.value == '0') { bootbox.alert("인원수를 입력하십시오!", function () { el5.focus(); el.value = ''; }); return; }

                    if (el4.value == "갑지1") iStd = 24 * parseFloat(_zw.ut.empty(ex.val())) * parseFloat(_zw.ut.empty(el5.value));
                    else if (el4.value == "갑지2") iStd = 12 * parseFloat(_zw.ut.empty(ex.val())) * parseFloat(_zw.ut.empty(el5.value));
                    else if (el4.value == "을지") iStd = 12 * parseFloat(_zw.ut.empty(ex.val())) * parseFloat(_zw.ut.empty(el5.value));
                    else if (el4.value == "일본") iStd = 1500 * parseFloat(_zw.ut.empty($('#__mainfield[name="EXCHANGE3"]').val())) * parseFloat(_zw.ut.empty(el5.value));

                    s = parseFloat(_zw.ut.empty(el.value)) * parseFloat(_zw.ut.empty(el2.val()));
                    iStd = iStd.toFixed(0); s = s.toFixed(0); //console.log(iStd + " : " + s)
                    if (s - iStd > 0) { bootbox.alert("식비한도(" + el4.value + " " + numeral(iStd).format(f) + "원)를 초과할 수 없습니다!", function () { el.value = ''; el.focus(); }); return; }
                }
                s = 0;
                if (el1.val() != '' && el2.val() != '' && el3.value != '') {
                    do { p = p.parentNode; } while (p.tagName != 'TABLE'); //console.log(p.tagName + " : " + el2.val());

                    $(p).find('td :text[name="' + el.name + '"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value)) * parseFloat(_zw.ut.empty(el2.val()))).value(); });
                    $('#__mainfield[name="' + prefix + 'SUM' + idx + '"]').val(numeral(s).format(f));

                    s = 0;
                    for (var x = 1; x <= CURRENCY_CNT; x++) { s += numeral($('#__mainfield[name="' + prefix + 'SUM' + x.toString() + '"]').val()).value(); }
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
                        if (k >= len - (CURRENCY_CNT + 1) && k < len - 1) {
                            el1 = $(this).find('input[name]'); idx = el1.attr('name').substr(el1.attr('name').length - 1); prefix = el1.attr('name').substr(0, 1);
                            ex = $('#__mainfield[name="EXCHANGE' + idx + '"]');

                            s = 0; //console.log(idx + ' : el1 => ' + el1.attr('name'))
                            p.find('td :text[name="' + el1.attr('name') + '"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value)) * parseFloat(_zw.ut.empty(ex.val()))).value(); })
                            $('#__mainfield[name="' + prefix + 'SUM' + idx + '"]').val(numeral(s).format(f));
                        }
                    });
                    
                    s = 0;
                    for (var x = 1; x <= CURRENCY_CNT; x++) { s += numeral($('#__mainfield[name="' + prefix + 'SUM' + x.toString() + '"]').val()).value(); }
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
        "authSelect": function (p, info, x) {
            $('#__mainfield[name="TRIPPERSON"]').val(info["name"]);
            $('#__mainfield[name="TRIPPERSONID"]').val(info["id"]);
            $('#__mainfield[name="TRIPPERSONEMPID"]').val(info["empid"]);
            $('#__mainfield[name="TRIPPERSONGRADE"]').val(info["grade"]);
            $('#__mainfield[name="TRIPPERSONORG"]').val(info["grdn"]);
            $('#__mainfield[name="TRIPPERSONDEPTID"]').val(info["grid"]);

            _zw.formEx.event(''); //일비 가져오기
            _zw.formEx.event('supplier', info["empid"]);

            p.modal('hide');
        },
        "change": function (x, fld) {
            $(x).next().val($(x).children('option:selected').text());
            _zw.formEx.event(x);
        },
        "popupWnd": function (pos, w, subSeq) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.');
            var m = '', opt = 'F', ttl = el.attr('title'), v1 = '', v2 = '', v3 = '', query = '', row = el.parent().parent().parent();

            if (vPos[0] == 'report') m = 'getreportsearch';
            else m = 'getcodedescription';

            if (vPos[1] == 'CC_CARDACK') {
                query = $('#__mainfield[name="TRIPPERSONID"]').val();
                ttl = el.text();
            } else if (vPos[1] == 'CC_ACCOUNTDETAILWND') {
                v1 = row.find('td [name="ACNTCLS"]').val();
                if (v1 == '') { bootbox.alert('보여줄 세부정보가 없습니다.'); return false; }
            }

            $.ajax({
                type: "POST",
                url: "/EA/Common",
                data: '{M:"' + m + '",body:"' + opt + '", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",query:"' + query + '",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:""}',
                success: function (res) {
                    if (res.substr(0, 2) == 'OK') {
                        var p = $('#popLayer');
                        p.html(res.substr(2)).find(".modal-dialog").css("max-width", w).find('.modal-title').html(ttl);

                        _zw.ut.picker('date'); _zw.ut.maxLength(); _zw.fn.input(p.find('.modal-body'));

                        if (vPos[1] == 'CC_ACCOUNTDETAILWND') {
                            p.find('.modal-body [data-for]').each(function () {
                                $(this).val(row.find('td [name="' + $(this).attr('data-for') + '"]').val());
                            });
                        }

                        p.find('.modal-footer .btn[data-zm-menu="confirm"]').click(function () {
                            if (vPos[1] == 'CC_CARDACK') {
                                var col = p.find('.modal-body :checkbox:checked'); //console.log(col[0])
                                if (col.length < 1) bootbox.alert('카드사용내역을 선택하십시오!');
                                else {
                                    var subId = '__subtable' + subSeq.toString(), tbl = $('#' + subId), iRowCnt = 0, iRowCnt2 = 0, bDuple = false;;

                                    //동일 승인번호 체크
                                    col.each(function (idx) {
                                        var ckRow = $(this).parent().parent();
                                        //var filter = CARD_ACK.find(function (element) { if (element.ACKNO === ckRow.find(':hidden[data-for="ACKNO"]').val()) return true; });
                                        //if (filter) {
                                        //    bootbox.alert('"가맹점 : ' + ckRow.find(':hidden[data-for="MERCNAME"]').val() + ', 승인금액 : ' + ckRow.find(':hidden[data-for="ACKAMT"]').val() + '"건은 이미 선택된 항목입니다!');
                                        //    bDuple = true; return false;
                                        //}
                                        if (_zw.formEx.checkCardAck(ckRow.find(':hidden[data-for="ACKID"]').val())) {
                                            bootbox.alert('"가맹점 : ' + ckRow.find(':hidden[data-for="MERCNAME"]').val() + ', 승인금액 : ' + ckRow.find(':hidden[data-for="ACKAMT"]').val() + '"건은 이미 선택된 항목입니다!');
                                            bDuple = true; return false;
                                        }
                                        if (bDuple) return false;
                                    });
                                    if (bDuple) return false;

                                    tbl.find('tr.sub_table_row').has('> td :checkbox[name="ROWSEQ"]').each(function () { //체크 위치
                                        if ($(this).find('td [name="ROWSEQ"]').prop('checked')) {
                                            var temp = $(this).find('td [name="EXPENSETYPECODE"]').val();
                                            if (col.length > iRowCnt) {
                                                //removeCardAck($(this).attr('data-ackid')); //배열정보 삭제
                                                if (temp != 'CARDCORP2') _zw.form.resetField($(this));
                                                _zw.formEx.event(vPos[1], $(this), $(col[iRowCnt]).parent().parent(), subSeq);
                                                iRowCnt++;
                                            }
                                        }
                                    });
                                    tbl.find('tr.sub_table_row td [name="ROWSEQ"]').prop('checked', false); //체크 해제

                                    if (col.length > iRowCnt) {
                                        tbl.find('tr.sub_table_row').has('> td :checkbox[name="ROWSEQ"]').each(function () { //구분값 '' 또는 구분값 '개인법인' 위치
                                            //var linkRow = subSeq.toString() + '.' + $(this).find('td [name="ROWSEQ"]').val();
                                            var temp = $(this).find('td [name="EXPENSETYPECODE"]').val();
                                            //var temp2 = checkCardAck($(this).attr('data-ackid')); //CARD_ACK.find(function (element) { if (element.LINKROW === linkRow) return true; });

                                            //console.log($(this).find('td [name="ROWSEQ"]').val() + " : " + temp + " : " + typeof (temp2) + " : " + linkRow)
                                            //if (temp == '' || (temp == 'CARDCORP2' && typeof temp2 === 'undefined')) {
                                            if (temp == '' || (temp == 'CARDCORP2' && $(this).attr('data-ackid') == '')) {
                                                if (col.length > iRowCnt + iRowCnt2) {
                                                    if (temp != 'CARDCORP2') _zw.form.resetField($(this));
                                                    _zw.formEx.event(vPos[1], $(this), $(col[iRowCnt + iRowCnt2]).parent().parent(), subSeq);
                                                    iRowCnt2++;
                                                }
                                            }
                                        });
                                    } //console.log(subId + " : " + iRowCnt + " : " + iRowCnt2)

                                    var iDiff = col.length - (iRowCnt + iRowCnt2);
                                    if (iDiff > 0) {
                                        for (var i = 0; i < iDiff; i++) { //row 추가
                                            var newRow = _zw.form.addRow(subId); //console.log(newRow)                                            
                                            _zw.formEx.event(vPos[1], newRow, $(col[iRowCnt + iRowCnt2 + i]).parent().parent(), subSeq);
                                        }
                                    }

                                    p.modal('hide');
                                }

                            } else if (vPos[1] == 'CC_ACCOUNTDETAILWND') {
                                p.find('.modal-body [data-for]').each(function () {
                                    row.find('td [name="' + $(this).attr('data-for') + '"]').val($(this).val());
                                });
                                p.modal('hide');
                            }
                        });
                        p.modal();
                    } else bootbox.alert(res);
                }
            });
        },
        "optionWnd": function (pos, w, h, l, t, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.');
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]);
            var m = '', ttl = '', v1 = '', v2 = '', v3 = '', query = '', k3 = '', row = el.parent().parent();
            if (vPos[0] == 'erp') m = 'getoracleerp';
            else if (vPos[0] == 'report') m = 'getreportsearch';
            else m = 'getcodedescription';

            ttl = vPos[1] == 'cc_cardcorp' ? '카드사' : el.attr('title');

            var pOption = ['N', ''];
            if (vPos[1] == 'centercode2') pOption = ['F', 'checkbox'];
            else if (vPos[1] == 'cc_cardcorp' || vPos[1] == 'ERP_TAXCODE' || vPos[1] == 'ERP_TAXEXPL' || vPos[1] == 'ERP_TAXNONDEDU' || vPos[1] == 'ERP_TAXNONDEDU') {
                pOption = ['', ''];
                if (vPos[1] == 'ERP_TAXCODE') v1 = 'KH';
                else if (vPos[1] == 'ERP_TAXEXPL') v1 = 'EKP';
                else v1 = '';
            } else {
                var n = $('#__mainfield[name="LOCATION"]');
                if (n && $.trim(n.val()) == '') { bootbox.alert('출장지를 선택 하십시오!'); return false; }

                n = $('#__mainfield[name="TRIPFROM"]');
                if (n && $.trim(n.val()) == '') { bootbox.alert('출장시작일을 입력 하십시오!'); return false; }
            }

            //data body 조건 : N(modal-body 없음), F(footer 포함)
            $.ajax({
                type: "POST",
                url: "/EA/Common",
                data: '{M:"' + m + '",body:"' + pOption[0] + '", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + k3 + '",etc:"' + etc + '",fn:"' + pOption[1] + '",query:"' + query + '",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:""}',
                success: function (res) {
                    //res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
                    if (res.substr(0, 2) == 'OK') {
                        if (pOption[0] != 'N') {
                            var p = $('#popBlank');
                            p.html(res.substr(2)).find('.modal-title').html(ttl);
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

                            p.find('.zf-modal .z-lnk-navy[data-val]').click(function () {
                                var v = $(this).attr('data-val').split('^');
                                for (var i = 0; i < param.length; i++) {
                                    if (vPos[1] == 'ERP_CORPVEHICLE') row.find('[data-for="' + param[i] + '"]').val(v[i]);
                                    else if (row) row.find('td [name="' + param[i] + '"]').val(v[i]);
                                    else $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
                                }
                                p.modal('hide');
                            });

                            p.on('hidden.bs.modal', function () { p.html(''); });
                            p.modal();

                        } else {
                            var j = { "close": true, "width": w, "height": h, "left": l, "top": t }
                            j["title"] = ttl; j["content"] = res.substr(2);

                            var pop = _zw.ut.popup(el[0], j);
                            pop.find('a[data-val]').click(function () {
                                if (param[0].indexOf('CURRENCY') != -1) {
                                    for (var i = 1; i <= CURRENCY_CNT; i++) {
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
        "externalWnd": function (pos, w, h, m, n, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.'); //console.log(arguments)
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]); //console.log(param);
            var m = 'getreportsearch', v1 = '', v2 = '', v3 = '', row = el.parent().parent();

            if (vPos[1] == 'ERP_DEPARTMENT' && row.find('td [name="EXPENSETYPECODE"]').val() == 'CARDCORP1') {
                _zw.formEx.optionWnd('external.cc_cardcorp', $(el), 0, 0, 0, '', 'SUPPLIERDEPTCD', 'SUPPLIERDEPT'); return false;
            }

            var s = '<div class="zf-modal modal-dialog modal-dialog-centered modal-dialog-scrollable">'
                + '<div class="modal-content" data-for="' + vPos[1] + '" style="box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.5)">'
                + '<div class="modal-header">'
                + '<div class="input-group w-50">'
                + '<input type="text" class="form-control" placeholder="' + (el.attr('title') != '' ? el.attr('title') + ' ' : '') + '검색" value="">'
                + '<span class="input-group-append"><button class="btn btn-secondary" type="button"><i class="fe-search"></i></button></span>'
                + '</div>'

            if (vPos[1] == 'ERP_ACCOUNTCLS') {
                s += '<div class="input-group w-50 pl-2 pt-2">'
                    + '<label class="custom-control custom-checkbox">'
                    + '<input type="checkbox" class="custom-control-input" id="customCheck1">'
                    + '<span class="custom-control-label" for="customCheck1">타 부서 조회</span>'
                    + '</label>'
                    + '</div>';
            }

            s += '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>'
                + '</div>'
                + '<div class="modal-body"></div>'
                + '</div></div>';

            var p = $('#popBlank');
            p.html(s).find(".modal-dialog").css("max-width", "30rem").find(".modal-content").css("min-height", "20rem");

            var searchBtn = p.find('.zf-modal .modal-header .input-group .btn');
            var searchTxt = $('.zf-modal .modal-header .input-group :text');

            searchTxt.keyup(function (e) { if (e.which == 13) { searchBtn.click(); } });
            searchBtn.click(function () {
                if ($.trim(searchTxt.val()) == '' || searchTxt.val().length < 1) { bootbox.alert('검색어를 입력하십시오!', function () { searchTxt.focus(); }); return false; }
                var exp = "['\\%^&\"*]", reg = new RegExp(exp, 'gi');
                if (searchTxt.val().search(reg) >= 0 || searchTxt.val().search(/\\/) >= 0) { bootbox.alert(exp + ' 문자는 사용될 수 없습니다!', function () { searchTxt.focus(); }); return false; }

                if (vPos[1] == 'ERP_ACCOUNTCLS') { v1 = $('.zf-modal .modal-header .input-group :checkbox').prop('checked') ? '' : $('#__mainfield[name="SUPPLIERDEPTCD"]').val(); }

                $.ajax({
                    type: "POST",
                    url: "/EA/Common",
                    data: '{M:"' + m + '",body:"N", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",fn:"",query:"",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:"' + searchTxt.val() + '"}',
                    success: function (res) {
                        if (res.substr(0, 2) == 'OK') {
                            p.find('.modal-body').html(res.substr(2));

                            if (vPos[1] == 'ERP_ACCOUNTCLS') p.find(".modal-dialog").css("max-width", "40rem");

                            //var row = vPos[1] == 'ERP_ACCOUNTCLS' || vPos[1] == 'ERP_DEPARTMENT' ? el.parent().parent() : null;
                            p.find('.zf-modal .z-lnk-navy[data-val]').click(function () {
                                var v = $(this).attr('data-val').split('^');
                                for (var i = 0; i < param.length; i++) {
                                    if (vPos[1] == 'REGISTER_PROJECTIDREGISTRATION') row.find('[data-for="' + param[i] + '"]').val(v[i]);
                                    else if (row) row.find('td [name="' + param[i] + '"]').val(v[i]);
                                    else $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
                                }

                                if (vPos[1] == 'ERP_ACCOUNTCLS') { //계정과목 선택 후 세부정보 초기화
                                    for (var i = 1; i <= 12; i++) {
                                        row.parent().find('td [name="DETAILINFO' + i.toString() + '"]').val('');
                                    }
                                }
                                p.modal('hide');
                            });
                        } else bootbox.alert(res);
                    }
                });
            });

            p.on('shown.bs.modal', function () { searchTxt.focus(); });
            p.on('hidden.bs.modal', function () { p.html(''); });
            p.modal();
        },
        "event": function (x) { //console.log(x)
            if (x) {
                if (x.name == "TRIPFROM") {
                    _zw.formEx.exchangeInfo(x.value);
                } else if (x == 'supplier') {
                    var sDept = '';
                    var res = _zw.ut.ajaxSync('/EA/Common', '{M:"getreportsearch",body:"S", k1:"report",k2:"ERP_SUPPLIER",v1:"' + arguments[1] + '",v2:"",v3:""}');
                    if (res.substr(0, 2) == 'OK') {
                        var info = res.substr(2).split(String.fromCharCode(8));
                        $('#__mainfield[name="SUPPLIERID"]').val(info[0]);
                        $('#__mainfield[name="SUPPLIER"]').val(info[1]);
                        $('#__mainfield[name="SUPPLIEREMPNO"]').val(info[2]);
                        $('#__mainfield[name="SUPPLIERDEPTCD"]').val(info[3]);
                        $('#__mainfield[name="SUPPLIERGLC"]').val(info[4]);
                        $('#__mainfield[name="SUPPLIERDEPT"]').val(info[5]);
                        sDept = info[3];

                        var acntNm = '여비교통비(해외)';
                        res = _zw.ut.ajaxSync('/EA/Common', '{M:"getreportsearch",body:"S", k1:"report",k2:"ERP_ACCOUNTONE",v1:"' + sDept + '",v2:"' + acntNm + '",v3:""}');
                        if (res.substr(0, 2) == 'OK') {
                            info = res.substr(2).split(String.fromCharCode(8));
                            var jTemp = {};
                            jTemp["nm"] = info[0];
                            jTemp["dpcd"] = info[1];
                            jTemp["main"] = info[2];
                            jTemp["sub"] = info[3];
                            jTemp["id"] = info[4];
                            jTemp["cls"] = info[5];
                            jTemp["clsnm"] = info[6];
                            BASE_ACNT["A4"] = jTemp;

                            acntNm = '접대비(법인카드)';
                            res = _zw.ut.ajaxSync('/EA/Common', '{M:"getreportsearch",body:"S", k1:"report",k2:"ERP_ACCOUNTONE",v1:"' + sDept + '",v2:"' + acntNm + '",v3:""}');
                            if (res.substr(0, 2) == 'OK') {
                                info = res.substr(2).split(String.fromCharCode(8));
                                var jTemp = {};
                                jTemp["nm"] = info[0];
                                jTemp["dpcd"] = info[1];
                                jTemp["main"] = info[2];
                                jTemp["sub"] = info[3];
                                jTemp["id"] = info[4];
                                jTemp["cls"] = info[5];
                                jTemp["clsnm"] = info[6];
                                BASE_ACNT["A2"] = jTemp;

                            } else {
                                if (res == 'NO') bootbox.alert('접대비(법인카드) 계정 정보가 없습니다!');
                                else bootbox.alert(res);
                            }

                        } else {
                            if (res == 'NO') bootbox.alert('여비교통비(해외) 계정 정보가 없습니다!');
                            else bootbox.alert(res);
                        }
                        console.log(BASE_ACNT);

                    } else {
                        $('#__mainfield[name="SUPPLIERID"]').val('');
                        $('#__mainfield[name="SUPPLIER"]').val('');
                        $('#__mainfield[name="SUPPLIEREMPNO"]').val('');
                        $('#__mainfield[name="SUPPLIERDEPTCD"]').val('');
                        $('#__mainfield[name="SUPPLIERGLC"]').val('');
                        $('#__mainfield[name="SUPPLIERDEPT"]').val('');

                        if (res == 'NO') bootbox.alert('Supplier 정보가 없습니다!');
                        else bootbox.alert(res);
                    }

                } else if (x == 'CC_CARDACK') { //카드사용내역 테이블 > 열(row) > 필드 채우기
                    var col = arguments[1], info = arguments[2], tblSeq = arguments[3];
                    col.find('td [name="EXPENSETYPECODE"]').val('CARDCORP2'); _zw.formEx.change(col.find('td [name="EXPENSETYPECODE"]')[0]);
                    //col.find('td [name="EXPENSETYPE"]').val(col.find('td [name="EXPENSETYPECODE"]').children('option:selected').text());
                    
                    var fAmt = col[0].cells[col[0].cells.length - (CURRENCY_CNT + 1)].firstChild; fAmt.value = info.find(':hidden[data-for="REQAMT"]').val();
                    fAmt.setAttribute('placeholder', fAmt.value);

                    var j = {};
                    info.find(':hidden[data-for]').each(function () {
                        j[$(this).attr('data-for')] = $(this).val();
                        if ($(this).attr('data-for') == 'ACKID') col.attr('data-ackid', $(this).val());
                    });
                    //j['LINKROW'] = subSeq + '.' + col.find('td [name="ROWSEQ"]').val(); //console.log(j);
                    //CARD_ACK.push(j); console.log(CARD_ACK);
                    col.attr('data-attr', JSON.stringify(j)); //console.log(JSON.parse(col.attr('data-attr')));

                    if (tblSeq && parseInt(tblSeq) > 0) {
                        if (tblSeq == 1) {
                            col.find('td [name="HOTEL"]').val(j['MERCNAME']);
                        } else if (tblSeq > 2) {
                            col.find('td [name="LOCATION"]').val(j['MERCNAME']);
                        }
                    }

                } else {
                    row = x.parentNode.parentNode;
                    var iTo = row.cells.length - (CURRENCY_CNT + 1);
                    if (x.name == "EXPENSERULE") {
                        for (var i = row.cells.length - 2; i >= iTo; i--) { row.cells[i].firstChild.value = ''; }
                    } else if (x.name == "EXPENSETYPECODE") {
                        if (x.value == "CASH") {
                            for (var i = row.cells.length - 2; i >= iTo; i--) {
                                $(row.cells[i].firstChild).removeClass('txtRead_Right').addClass('txtDollar').prop('readonly', false).val('');
                                _zw.fn.input(row.cells[i].firstChild);
                                if (i == iTo) row.cells[i].firstChild.setAttribute('placeholder', '');
                            }
                        } else {
                            for (var i = row.cells.length - 2; i >= iTo; i--) {
                                if (x.value != '' && i == iTo) {
                                    $(row.cells[i].firstChild).removeClass('txtRead_Right').addClass('txtDollar').prop('readonly', false).val('');
                                    _zw.fn.input(row.cells[i].firstChild);
                                } else $(row.cells[i].firstChild).removeClass('txtDollar').addClass('txtRead_Right').prop('readonly', true).val('');
                                if (i == iTo) row.cells[i].firstChild.setAttribute('placeholder', '');
                            }
                        }
                        $(row).attr('data-ackid', '').attr('data-attr', '');
                        //removeCardAck($(row).attr('data-ackid')); $(row).attr('data-ackid', ''); console.log(CARD_ACK);
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
                            else if (idx == 4) { var ddl = $(this).find('[name="EXPENSETYPECODE"]'); ddl.val('CASH').prop('disabled', true); $(this).find('[name="EXPENSETYPE"]').val(ddl.children('option:selected').text()); }
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
                data: '{M:"getoracleerp",body:"S", k1:"erp",k2:"exchangeinfo",k3:"",v1:"KRW",v2:"' + dt + '",v3:"' + dt + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == 'OK') {
                        var j = JSON.parse(res.substr(2)); //console.log(j)
                        var c1, c2, v, col1, col2, f = '0,0.[0000]';
                        for (var x = 2; x <= CURRENCY_CNT; x++) {
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
                        if (k >= len - (CURRENCY_CNT + 1) && k < len - 1) {
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

    _zw.formEx.init();
});