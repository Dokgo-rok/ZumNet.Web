$(function () {
    _zw.formEx = {
        "init": function () { //초기 설정 : 하단 호출
            if (_zw.V.apvmode == 'draft') {
                var d = moment(_zw.V.current.date).subtract(1, 'M').format('YYYY-MM') + '-01'; //AP일자 : 전월 1일
                $('.datepicker[name="APDATE"]').datepicker('setStartDate', d);

                _zw.formEx.event('supplier', $('#__mainfield[name="APPLICANTEMPNO"]').val());
            }
        },
        "addRow": function (row) { //26-02-19 추가
            var icnt = 0;
            $('#__subtable1 tr.sub_table_row').each(function (idx) {
                $(this).find('input[name]', 'select[name]').each(function (idx) {
                    if ($(this).attr('name') != 'ROWSEQ' && $(this).val() != '') icnt++;
                })
            });
            console.log('cnt : ' + icnt);

            row.find('td > [name]').each(function () { $(this).val('').prop('disabled', false); }); _zw.fn.input(row);
            return row;
        },
        "validation": function (cmd) {
            var rt = true;
            if (cmd == "draft") { //기안
                var el, el2, e,  v, s, s2, f, to = 0;
                s = 'CARDNUM;카드번호^ACKNO;승인번호^MERCNAME;가맹점명^MERCSOCNO;사업자번호^ACKAMT;승인금액^VALSUPPLY;공급가액^VAT;부가세^REQAMT;인정금액^MERCTAXKINDCODE;과세구분^TAXRATE;세금구분^TAXEXPL;세목';
                s2 = 'MERCNAME;가맹점명^MERCSOCNO;사업자번호^ACKAMT;승인금액^VALSUPPLY;공급가액^VAT;부가세^REQAMT;인정금액^MERCTAXKINDCODE;과세구분^TAXRATE;세금구분^TAXEXPL;세목';

                $('#__subtable1 tr.sub_table_row').each(function (idx) {
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
        },
        "calc": function (el) {
            var s1, s2, row;
            if (el.name == 'REQAMT') {
                s1 = parseFloat(_zw.ut.empty($(el).parent().parent().find('td input[name = "ACKAMT"]').val()));
                s2 = parseFloat(_zw.ut.empty(el.value)); //console.log(s1 + " : " + s2)
                if (s1 - s2 < 0) {
                    bootbox.alert('"인정금액"은 "승인금액" 보다 클 수 없습니다!', function () { el.value = ''; el.focus(); });
                    return false;
                }
            } else if (el.name == 'CARDNUM' && el.value != '') {
                row = $(el).parent().parent();
                if (row.find('td [name = "EXPENSETYPECODE"]').val() == 'CARDCORP1') {
                    if (row.find('td [name = "SUPPLIERDEPTCD"]').val() == '') {
                        bootbox.alert('[Supplier(카드사)]를 선택하십시오!', function () { el.value = ''; }); return false;
                    }
                    var res = _zw.ut.ajaxSync('/EA/Common', '{M:"getreportsearch",body:"S", k1:"report",k2:"CC_CARDBASE",v1:"' + row.find('td [name = "SUPPLIERDEPTCD"]').val() + '",v2:"' + el.value.replace(/_/gi, '').replace(/-/gi, '') + '",v3:""}');
                    if (res == "OK") {
                        bootbox.alert('미등록 카드입니다. 관리자에게 문의하십시오', function () { el.value = ''; }); return false;
                    }
                } else {
                    bootbox.alert('[구분] 값 누락', function () { el.value = ''; }); return false;
                }
            }
        },
        "autoCalc": function (p) {
        },
        "date": function (el) {
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
                $('#__mainfield[name="APPLICANTDEPTID"]').val(info["grid"]);
                $('#__mainfield[name="APPLICANTORG"]').val(info["belong"]);

                _zw.formEx.event('supplier', info["empid"]);
            });
            p.modal('hide');
        },
        "change": function (x, fld) {
            $(x).next().val($(x).children('option:selected').text()); //console.log($(x).attr("name") + " : " + $(x).val())

            if ($(x).attr("name") == 'EXPENSETYPECODE') {
                var row = $(x).parent().parent();
                var v = "ACKID;PURCHASEFLAG;AQUIDATE;CARDNUM;ACKNO;MERCTAXKIND;MERCTAXKINDCODE;MERCNAME;MERCSOCNO;ACKAMT;VALSUPPLY;VAT;REQAMT;CURRENCY".split(';');

                if ($(x).val() == 'CARDCORP2') {
                    if (row.find('td > [name="ACKID"]').val() == '') {
                        row.find('td > [name]').each(function () {
                            if (v.indexOf($(this).attr('name')) != -1) {
                                $(this).val(''); if ($(this).attr('name') != 'REQAMT') $(this).prop('disabled', true);
                            }
                        });
                    }
                } else {
                    row.find('td > [name]').each(function () {
                        if (v.indexOf($(this).attr('name')) != -1) $(this).val('').prop('disabled', false);
                    });
                }

                if ($(x).val() == 'CARDCORP1') { //회사법인
                    _zw.formEx.optionWnd('external.cc_cardcorp', $(x), 0, 0, 0, '', 'SUPPLIERDEPTCD', 'SUPPLIERDEPT');
                } else {
                    row.find('td > [name="SUPPLIERDEPTCD"]').val($('#__mainfield[name="SUPPLIERDEPTCD"]').val());
                    row.find('td > [name="SUPPLIERDEPT"]').val($('#__mainfield[name="SUPPLIERDEPT"]').val());
                }
            }

            //_zw.formEx.event(x);
        },
        "event": function (x) {
            if (x == 'supplier') {
                var res = _zw.ut.ajaxSync('/EA/Common', '{M:"getreportsearch",body:"S", k1:"report",k2:"ERP_SUPPLIER",v1:"' + arguments[1] + '",v2:"",v3:""}');
                if (res.substr(0, 2) == 'OK') {
                    var info = res.substr(2).split(String.fromCharCode(8));
                    $('#__mainfield[name="SUPPLIERID"]').val(info[0]);
                    $('#__mainfield[name="SUPPLIER"]').val(info[1]);
                    $('#__mainfield[name="SUPPLIEREMPNO"]').val(info[2]);
                    $('#__mainfield[name="SUPPLIERDEPTCD"]').val(info[3]);
                    $('#__mainfield[name="SUPPLIERGLC"]').val(info[4]);
                    $('#__mainfield[name="SUPPLIERDEPT"]').val(info[5]);
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
                var col = arguments[1], info = arguments[2];
                col.each(function () {
                    var fld = info.find(':hidden[data-for="' + $(this).attr('name') + '"]');
                    if (fld && fld.length > 0) {
                        $(this).val(fld.val()); if ($(this).attr('name') != 'REQAMT') $(this).prop('disabled', true);
                        
                    }
                    if ($(this).attr('name') == 'EXPENSETYPECODE') { $(this).val('CARDCORP2'); _zw.formEx.change($(this)[0]); }
                    else if ($(this).attr('name') == 'MERCTAXKINDCODE') _zw.formEx.change($(this)[0]);
                    else if ($(this).attr('name') == 'SUPPLIERDEPTCD') $(this).val($('#__mainfield[name="SUPPLIERDEPTCD"]').val());
                    else if ($(this).attr('name') == 'SUPPLIERDEPT') $(this).val($('#__mainfield[name="SUPPLIERDEPT"]').val());
                });
            }
        },
        "popupWnd": function (pos, w) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.');
            var m = '', opt = 'F', ttl = el.attr('title'), v1 = '', v2 = '', v3 = '', query = '', row = el.parent().parent().parent();

            if (vPos[0] == 'report') m = 'getreportsearch';
            else m = 'getcodedescription';

            if (vPos[1] == 'CC_CARDACK') {
                query = $('#__mainfield[name="APPLICANTID"]').val();
                ttl = el.text();
            } else if (vPos[1] == 'CC_ACCOUNTDETAILWND') {
                v1 = row.find('td [name="ACNTCLS"]').val(); v2 = _zw.V.mode;
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
                                    var subId = '__subtable1', tbl = $('#' + subId), iRowCnt = 0, iRowCnt2 = 0, bDuple = false;;

                                    //동일 승인번호 체크
                                    col.each(function (idx) {
                                        var ckRow = $(this).parent().parent();
                                        tbl.find('tr.sub_table_row td [name="ACKNO"]').each(function () {
                                            if ($(this).val() == ckRow.find(':hidden[data-for="ACKNO"]').val()) {
                                                bootbox.alert('"가맹점 : ' + ckRow.find(':hidden[data-for="MERCNAME"]').val() + ', 승인금액 : ' + ckRow.find(':hidden[data-for="ACKAMT"]').val() + '"건은 이미 선택된 항목입니다!');
                                                bDuple = true; return false;
                                            }
                                        });
                                        if (bDuple) return false;
                                    });
                                    if (bDuple) return false;

                                    tbl.find('tr.sub_table_row').each(function () { //체크 위치
                                        if ($(this).find('td [name="ROWSEQ"]').prop('checked')) {
                                            if (col.length > iRowCnt) {
                                                _zw.form.resetField($(this)); _zw.formEx.event(vPos[1], $(this).find('td [name]'), $(col[iRowCnt]).parent().parent());
                                                iRowCnt++;
                                            }
                                        }
                                    });
                                    tbl.find('tr.sub_table_row td [name="ROWSEQ"]').prop('checked', false); //체크 해제

                                    if (col.length > iRowCnt) {
                                        tbl.find('tr.sub_table_row').each(function () { //구분값 '' 또는 구분값 '개인법인' 위치
                                            var temp = $(this).find('td [name="EXPENSETYPECODE"]').val(), temp2 = $(this).find('td [name="ACKID"]').val();
                                            if (temp == '' || (temp == 'CARDCORP2' && temp2 == '')) {
                                                if (col.length > iRowCnt + iRowCnt2) {
                                                    _zw.form.resetField($(this)); _zw.formEx.event(vPos[1], $(this).find('td [name]'), $(col[iRowCnt + iRowCnt2]).parent().parent());
                                                    iRowCnt2++;
                                                }
                                            }
                                        });
                                    }// console.log(iRowCnt + " : " + iRowCnt2)

                                    var iDiff = col.length - (iRowCnt + iRowCnt2);
                                    if (iDiff > 0) {
                                        for (var i = 0; i < iDiff; i++) { //row 추가
                                            var newRow = _zw.form.addRow(subId); //console.log(newRow)                                            
                                            _zw.formEx.event(vPos[1], newRow.find('td [name]'), $(col[iRowCnt + iRowCnt2 + i]).parent().parent());
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
            var el = _zw.ut.eventBtn(), vPos = pos.split('.'); //console.log(el)
            if (pos == 'external.cc_cardcorp') el = w;

            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]);
            var m = '', opt = '', ttl = '', v1 = '', v2 = '', v3 = '', query = '', k3 = '', row = el.parent().parent();
            if (vPos[0] == 'report') m = 'getreportsearch';
            else m = 'getcodedescription';

            ttl = vPos[1] == 'cc_cardcorp' ? '카드사' : el.attr('title');

            if (vPos[1] == 'ERP_TAXCODE') v1 = 'KH';
            else if (vPos[1] == 'ERP_TAXEXPL') v1 = 'EKP';
            else v1 = '';

            //data body 조건 : N(modal-body 없음), F(footer 포함)
            $.ajax({
                type: "POST",
                url: "/EA/Common",
                data: '{M:"' + m + '",body:"' + opt + '", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + k3 + '",etc:"' + etc + '",fn:"",query:"' + query + '",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:""}',
                success: function (res) {
                    if (res.substr(0, 2) == 'OK') {
                        var p = $('#popBlank');
                        p.html(res.substr(2)).find('.modal-title').html(ttl);

                        p.find('.zf-modal .z-lnk-navy[data-val]').click(function () {
                            var v = $(this).attr('data-val').split('^');
                            for (var i = 0; i < param.length; i++) {
                                //console.log(vPos[1] + " : " + param[i] + " : " + v[i])
                                if (vPos[1] == 'ERP_CORPVEHICLE') row.find('[data-for="' + param[i] + '"]').val(v[i]);
                                else if (row) row.find('td [name="' + param[i] + '"]').val(v[i]);
                                else $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
                            }
                            p.modal('hide');
                        });

                        p.on('hidden.bs.modal', function () { p.html(''); });
                        p.modal();

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
                + '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>'
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
                                        row.find('td [name="DETAILINFO' + i.toString() + '"]').val('');
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
        }
    }

    _zw.formEx.init();
});