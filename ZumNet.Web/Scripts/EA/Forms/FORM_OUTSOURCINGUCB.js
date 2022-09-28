$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            if (cmd == "draft") { //기안
                $('#__subtable1 tr.sub_table_row').each(function (idx) {
                    if ($(this).find('td :text[name="PRICEA"]').val() != '' && $(this).find('td :text[name="PRICEB"]').val() == '' && $(this).find('td :text[name="BPANUM"]').val() == '') {
                        $(this).find('td :text[name="BPANUM"]').val('NO BPA');
                    }
                });
            }
            return true;
        },
        "make": function (f) {
            if (_zw.V.act == "_reviewer" || _zw.V.act == "__r") _zw.body.sub(f);
        },
        "checkEvent": function (ckb, el, fld) {
        },
        "calc": function (el) {
            var s = 0, f = '0,0.[00000]';
            if (el.name == "TTLLT") {
                $('#__subtable1 td :text[name="TTLLT"]').each(function (idx, e) { s += numeral(e.value).value(); })
                $('#__mainfield[name="TOTALSUM"]').val(numeral(s).format(f));

            } else if (el.name == "PRICEA" || el.name == "PRICEB" || el.name == "AMOUNT") {
                var row = $(el).parent().parent();
                s = _zw.ut.sub(5, row.find('td :text[name="PRICEB"]').val(), row.find('td :text[name="PRICEA"]').val()); console.log(row.find('td :text[name="PRICEB"]').val() + ' => ' + s)
                row.find('td :text[name="PRICEC"]').val(numeral(s).format(f)); s = 0;

                s = _zw.ut.rate(row.find('td :text[name="PRICEC"]').val(), row.find('td :text[name="PRICEA"]').val(), 5)
                row.find('td :text[name="RATE"]').val(numeral(s).format('0,0.[0]') + '%'); s = 0;

                s = parseFloat(_zw.ut.empty(row.find('td :text[name="PRICEC"]').val())) * parseFloat(_zw.ut.empty(row.find('td :text[name="AMOUNT"]').val()));
                row.find('td :text[name="PRICED"]').val(numeral(s).format('0,0')); s = 0;
            }
        },
        "autoCalc": function (p) {
            var s = 0, f = '0,0.[0000]';
            p.find('td :text[name="TTLLT"]').each(function (idx, e) { s += numeral(e.value).value(); })
            $('#__mainfield[name="TOTALSUM"]').val(numeral(s).format(f));
        },
        "date": function (el) {
            if (el.name == "APPLYPOINT") {
                var dif = _zw.ut.diff('day', _zw.V.current.date.substr(0, 10), el.value); console.log(dif + " : " + _zw.V.current.date.substr(0, 10))
                if (dif && dif < 0) { bootbox.alert('[적용시점]은 오늘 이전으로 선택하세요!', function () { el.value = ''; el.focus(); }); return false; }
            }
        },
        "optionWnd": function (pos, w, h, l, t, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.');
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]);
            var m = '', v1 = '', v2 = '', v3 = '', query = '', k3 = '', row = null;
            if (vPos[0] == 'erp') {
                m = 'getoracleerp';
                if (vPos[1] == 'bpanum') {
                    row = el.parent().parent();
                    var e = $('#__mainfield[name="PRODUCTCENTER"]');
                    if (e.val() == '') { bootbox.alert('적용사업장을 선택하십시오!'); return false; } else { query = e.val(); }

                    e = row.find('td :text[name="COMPANYCODE"]');
                    if (e.val() == '') { bootbox.alert('업체명을 선택하십시오!'); return false; } else { v1 = e.val(); }

                    e = $('#__mainfield[name="CURRENCY"]');
                    if (e.val() == '') { bootbox.alert('통화를 선택하십시오!'); return false; } else { v2 = e.val(); }

                    k3 = _zw.V.ft;
                }
            } else if (vPos[0] == 'report') m = 'getreportsearch';
            else m = 'getcodedescription';

            //data body 조건 : N(modal-body 없음), F(footer 포함)
            $.ajax({
                type: "POST",
                url: "/EA/Common",
                data: '{M:"' + m + '",body:"N", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + k3 + '",etc:"' + etc + '",fn:"",query:"' + query + '",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:""}',
                success: function (res) {
                    //res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
                    if (res.substr(0, 2) == 'OK') {
                        var j = { "close": true, "width": w, "height": h, "left": l, "top": t }
                        j["title"] = el.attr('title'); j["content"] = res.substr(2);

                        var pop = _zw.ut.popup(el[0], j);
                        //var row = vPos[1] == 'bpanum' ? el.parent().parent() : null;
                        pop.find('a[data-val]').click(function () {
                            var v = $(this).attr('data-val').split('^'); //console.log(v + " : " + param)
                            if (param == 'BPANUM' && v[1] != 'Y') {
                                bootbox.alert('BPA Status is not APPROVED!'); return false;
                            }
                            if (param == 'PRODUCTCENTER') {//구매단가 관련 사업장 변경시 테이블 정보 초기화
                                var p = $('#__subtable1');
                                p.find('tr.sub_table_row').each(function () { _zw.form.resetField($(this)); });
                                _zw.form.orderRow(p); _zw.formEx.autoCalc(p);
                            }

                            for (var i = 0; i < param.length; i++) {
                                if (row && row.length > 0) row.find('td [name="' + param[i] + '"]').val(v[i]);
                                else $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
                            }
                            pop.find('.close[data-dismiss="modal"]').click();
                        });

                        pop.find('input:text.z-input-in').keyup(function (e) {
                            if (e.which == 13) {
                                if (row && row.length > 0) row.find('td [name="' + param[0] + '"]').val($(this).val());
                                else $('#__mainfield[name="' + param[0] + '"]').val($(this).val());
                                pop.find('.close[data-dismiss="modal"]').click();
                            }
                        });

                    } else bootbox.alert(res);
                }
            });
        },
        "externalWnd": function (pos, w, h, m, n, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.'); //console.log(arguments)
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]); //console.log(param);
            var m = '', query = '', el2, v1 = '', v2 = '', v3 = '';
            if (vPos[0] == 'erp') m = 'getoracleerp';
            else if (vPos[0] == 'report') m = 'getreportsearch';
            else m = 'getcodedescription';

            if (pos == "erp.items" || pos == "erp.vendors" || pos == "erp.items1" || pos == "erp.items3") {
                el2 = $('#__mainfield[name="PRODUCTCENTER"]');
                if (el2.val() == '') { bootbox.alert('적용사업장을 선택하십시오!', function () { el2.focus(); }); return false; }

                if (pos == "erp.items3") {
                    if (el2.val() == "CD") query = "104";
                    else if (el2.val() == "CD2") query = "148";
                    else if (el2.val() == "CH") query = "102";
                    else if (el2.val() == "CT") query = "103";
                    else if (el2.val() == "IC") query = "105";
                    else if (el2.val() == "IS") query = "128";
                    else if (el2.val() == "VH") query = "108";
                    else if (el2.val() == "KH") query = "101";
                } else {
                    query = el2.val();
                }
                m = 'getoracleerp';
            }

            if (pos == 'erp.exchangerate') { //환율
                if ($('#__mainfield[name="CURRENCY"]').val() == '') { bootbox.alert('통화를 선택하십시오!', function () { }); return false; }
                v1 = $('#__mainfield[name="CURRENCY"]').val();
            }

            var sSelect = '';
            if (pos == "erp.vendors") sSelect = '<div class="input-group-prepend"><select class="form-control"><option value="VENDOR_NAME" selected>NAME</option><option value="SEGMENT1">CODE</option></select></div>'

            var s = '<div class="zf-modal modal-dialog modal-dialog-centered modal-dialog-scrollable">'
                + '<div class="modal-content" data-for="' + vPos[1] + '" style="box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.5)">'
                + '<div class="modal-header">'
                + '<div class="d-flex align-items-center w-100">'
                + '<div class="input-group w-50">'
                + sSelect
                + '<input type="text" class="form-control" placeholder="' + (el.attr('title') != '' ? el.attr('title') + ' ' : '') + '검색" value="">'
                + '<span class="input-group-append"><button class="btn btn-secondary" type="button"><i class="fe-search"></i></button></span>'
                + '</div>' //input-group
                + '<div class="ml-2 d-flex align-items-center zf-modal-page"></div>'
                + '</div>' //d-flex
                + '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>'
                + '<input type="hidden" data-for="page" value="1" /><input type="hidden" data-for="page-count" value="50" />'
                + '</div>' //modal-header
                + '<div class="modal-body"></div>'
                + '</div></div>';

            var p = $('#popBlank'); p.html(s);
            var searchBtn = p.find('.zf-modal .modal-header .input-group .btn');
            var searchTxt = $('.zf-modal .modal-header .input-group :text');

            if (pos == "erp.exchangerate") {
                p.find(".modal-dialog").css("max-width", "20rem").find(".modal-content").css("min-height", "6rem");
                searchTxt.prop('readonly', true).val(moment(_zw.V.current.date).format('YYYY-MM-DD'));

            } else p.find(".modal-dialog").css("max-width", "35rem").find(".modal-content").css("min-height", "20rem");

            searchTxt.keyup(function (e) { if (e.which == 13) { searchBtn.click(); } });
            searchBtn.click(function () {
                if ($.trim(searchTxt.val()) == '' || searchTxt.val().length < 1) { bootbox.alert('검색어를 입력하십시오!', function () { searchTxt.focus(); }); return false; }
                var exp = "['\\%^&\"*]", reg = new RegExp(exp, 'gi');
                if (searchTxt.val().search(reg) >= 0) { bootbox.alert(exp + ' 문자는 사용될 수 없습니다!', function () { searchTxt.focus(); }); return false; }

                $.ajax({
                    type: "POST",
                    url: "/EA/Common",
                    data: '{M:"' + m + '",body:"N", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",query:"' + query + '",search:"' + searchTxt.val() + '",searchcol:"' + (p.find('.modal-header select').length > 0 ? p.find('.modal-header select').val() : '') + '",page:"' + p.find('.modal-header :hidden[data-for="page"]').val() + '",count:"' + p.find('.modal-header :hidden[data-for="page-count"]').val() + '",v1:"' + v1 + '"}',
                    success: function (res) {
                        //res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
                        if (res.substr(0, 2) == 'OK') {
                            var cDel = String.fromCharCode(8);
                            if (res.substr(2).indexOf(cDel) != -1) {
                                var vRes = res.substr(2).split(cDel);
                                p.find('.modal-header .zf-modal-page').html(vRes[0]);
                                p.find('.modal-body').html(vRes[1]);
                            } else {
                                p.find('.modal-body').html(res.substr(2));
                            }

                            var row = vPos[1] == 'items' || vPos[1] == 'items3' || vPos[1] == 'vendors' ? el.parent().parent() : null;
                            p.find('.zf-modal .z-lnk-navy[data-val]').click(function () {
                                var v = $(this).attr('data-val').split('^');
                                if (vPos[1] == 'vendors') row.find('td [name="BPANUM"]').val('');

                                for (var i = 0; i < param.length; i++) {
                                    if (row) row.find('td [name="' + param[i] + '"]').val(v[i]);
                                    else $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
                                }
                                p.modal('hide');
                            });

                            p.find('.zf-modal-page .btn[data-for]').click(function () {
                                p.find('.modal-header :hidden[data-for="page"]').val($(this).attr('data-for'));
                                searchBtn.click();
                            });

                        } else bootbox.alert(res);
                    }
                });
            });

            p.on('shown.bs.modal', function () {
                if (pos == "erp.exchangerate") searchTxt.datepicker({ autoclose: true, language: $('#current_culture').val() });
                else searchTxt.focus();
            });
            p.on('hidden.bs.modal', function () { p.html(''); });
            p.modal();
        }
    }
});