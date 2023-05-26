//집계, 대장 리스트뷰

$(function () {

    $('#__LeftMenu .sidenav-toggle').click(function (e) {
        e.preventDefault();

        $(this).next().slideToggle(300, function () {
            $(this).parent().toggleClass('open');
        });
    });

    $('a[data-zf-menu], button[data-zf-menu]').click(function () {
        var mn = $(this).attr('data-zf-menu');
        if (mn != '') _zw.mu[mn]($(this));
    });

    $('[data-zv-menu="search"]').click(function () {
        _zw.fn.goSearch();
    });

    $('.z-lv-cond input.search-text').keyup(function (e) {
        if (e.which == 13) _zw.fn.goSearch();
    });

    _zw.mu.exportExcel = function () {
    }

    _zw.mu.importExcel = function () {
        //var url = "/" + _ZF.V.root + "/EA/External/FileImport.aspx?M=MC_SUMMARY&cd=ce";
        //_zw.ut.openWnd(url, "fileImport", 400, 100, "fix")
    }

    _zw.mu.saveTemp = function (t) {
        _zw.mu.saveStd(t);
    }

    _zw.mu.saveStd = function (t) {
        var pos = t ? t.attr('data-zf-menu').toLowerCase() : '';
        var page = _zw.V.current.page.toLowerCase() == "grid" ? _zw.V.current.page.toLowerCase() : _zw.V.ft.toLowerCase();
        var ckValid = true;
        if (pos != 'savetemp') ckValid = _zw.fn.validate();

        if (ckValid) {
            var d = {};

            if (page == "grid") {
                //grid : 부문, 부품명, 업체명 있는 경우 저장

                $('[data-zf-ftype="MAINFIELD"][data-zf-field]').each(function () {
                    d[$(this).attr('data-zf-field').toLowerCase()] = $(this).val().replace('%', '');
                });

            } else {
                $('[data-zf-field]').each(function () {
                    if ($(this).attr('data-zf-field') == 'USD_EUR') {
                        d[$(this).attr('data-zf-field').toLowerCase()] = numeral(1 / numeral($('input[data-zf-field="EUR_USD"]').val()).value()).format('0,0.0000');
                    } else {
                        d[$(this).attr('data-zf-field').toLowerCase()] = $(this).val();
                    }
                });
            }

            if (page == "stdpaydetail") {
                //                    var gc = _ZF.TUG.getColumns();
                //                    var gd = _ZF.TUG.getData();
                //                    //var cv = _ZF.TUG.getColumnValues('CORP');
                //                    //alert(t[5]["ROWSEQ"]); return false;
                //                    
                //                    var v = [];
                //                    for(var i = 0; i < gd.length; i++) {
                //                        var s = {};
                //                        for(var j = 0; j < gc.length; j++) {
                //                            if (gc[j].name == 'ROWSEQ') s[gc[j].name.toLowerCase()] = (i + 1).toString();
                //                            else s[gc[j].name.toLowerCase()] = gd[i][gc[j].name] && gd[i][gc[j].name] != '' ? gd[i][gc[j].name].replace('%', '') : '';
                //                        }
                //                        v.push(s);
                //                    }
                var v = [];
                $('#_Corp_SMT .z-grid tbody > tr').each(function () {
                    var s = {};
                    $(this).find('input[data-column]').each(function () {
                        s[$(this).attr('data-column').toLowerCase()] = $(this).val().replace('%', '');

                    });
                    v.push(s);
                });

                $('.accordion .card[data-zf-code]').each(function () {
                    if ($(this).find('input:checkbox').prop('checked')) {
                        $(this).find('.z-grid tbody > tr').each(function () {
                            var s = {}, bSave = false;

                            $(this).find('input[data-column]').each(function () {
                                if ($(this).attr('data-column') != 'CORP' && $(this).attr('data-column') != 'BUYER' && $(this).attr('data-column') != 'ITEMCLS'
                                    && $(this).attr('data-column') != 'ROWSEQ' && $(this).attr('data-column') != 'CURRENCY') {

                                    if ($(this).val().replace('%', '') != '') { bSave = true; return false; }
                                }
                            });

                            if (bSave) {
                                $(this).find('input[data-column]').each(function () {
                                    //console.log($(this).attr('data-column') + " : " + $(this).val());
                                    s[$(this).attr('data-column').toLowerCase()] = $(this).val().replace('%', '');

                                });
                                v.push(s);
                            }
                        });
                    }
                });

                d["sub"] = v;

            } else if (page == "grid") {
                //grid                  
                var gc = _zw.G.getColumns();
                var gd = _zw.G.getData();
                //var cv = _ZF.TUG.getColumnValues('CORP');
                //alert(t[5]["ROWSEQ"]); return false;

                var p = {}, v = [], iSeq = 1;
                for (var i = 0; i < gd.length; i++) {
                    var s = {};
                    if (gd[i]["CLSCD"] != null && gd[i]["CLSCD"] != '' &&
                        ((gd[i]["ITEMNO"] != null && gd[i]["ITEMNO"] != '') || (gd[i]["ITEMNM"] != null && gd[i]["ITEMNM"] != ''))
                    ) { //부문코드, (품번 또는 부품명) 필수 

                        for (var j = 0; j < gc.length; j++) {
                            if (gc[j].name == 'ROWSEQ') s[gc[j].name.toLowerCase()] = iSeq;
                            else s[gc[j].name.toLowerCase()] = gd[i][gc[j].name] && gd[i][gc[j].name] != '' ? gd[i][gc[j].name].replace('%', '') : '';
                        }
                        iSeq++;
                    }
                    v.push(s);
                }
                p["grid"] = v;

                //alert(JSON.stringify(v)); return;

                //sub : 1st cell 값 있으면 저장
                $('.z-grid[data-zf-subtable]').each(function (tIdx) {
                    var sub = $(this), nm = sub.attr('data-zf-subtable'), v2 = [];

                    sub.find('tbody > tr').each(function (rIdx, e) {
                        if (e.cells[0].firstChild.value != '') {
                            var s = {};
                            $(this).find('[data-zf-ftype="SUBFIELD"]').each(function () {
                                s[$(this).attr('data-zf-field').toLowerCase()] = $(this).val().replace('%', '');
                            });
                            v2.push(s);
                        }
                    });
                    p[nm.toLowerCase()] = v2;
                });

                d["subtables"] = p;
            }

            var msg = pos == 'savetemp' ? '임시저장 하시겠습니까?' : '저장 하시겠습니까?';

            d["M"] = _zw.V.mode == 'add' ? 'new' : _zw.V.mode; //== 'new' && (_ZF.V.appid == '' || _ZF.V.appid == '0') ? "new" : "edit";
            d["appid"] = _zw.V.appid;
            d["page"] = page;
            d["rptmode"] = _zw.V.rptmode;
            d["rptid"] = _zw.V.rptid;
            d["istemp"] = pos == 'savetemp' ? 'Y' : 'N';

            console.log(d);

            bootbox.confirm(msg, function (rt) {
                if (rt) {
                    $.ajax({
                        type: "POST",
                        url: "/ExS/CE/SaveStd",
                        data: JSON.stringify(d),
                        success: function (res) {
                            if (res.substr(0, 2) == "OK") {
                                if (res.substr(2).indexOf('^') > 0) {
                                    _zw.V.checkunload = false;

                                    var r = res.substr(2).split('^');
                                    if (r[0] != '' && r[0] != '0') _zw.V.appid = r[0];
                                    bootbox.alert(r[1], function () { _zw.mu.goList(page == 'grid' ? 'grid' : _zw.V.ft.replace('Detail', '')); });

                                } else {
                                    bootbox.alert(res.substr(2));
                                }

                            } else bootbox.alert(res);
                        }
                    });
                }
            });
        }
    }

    _zw.mu.deleteStd = function (t) {
        if (_zw.V.appid == '' || _zw.V.appid == '0') return false;

        var d = {};
        d["appid"] = _zw.V.appid;
        d["page"] = _zw.V.current.page;
        d["ft"] = _zw.V.ft;

        bootbox.confirm("삭제 하시겠습니까?", function (rt) {
            if (rt) {
                $.ajax({
                    type: "POST",
                    url: "/ExS/CE/DeleteStd",
                    data: JSON.stringify(d),
                    success: function (res) {
                        if (res.substr(0, 2) == "OK") {
                            bootbox.alert(res.substr(2));
                        } else bootbox.alert(res);
                    }
                });
            }
        });
    }

    _zw.mu.changeState = function (t) {
        if (_zw.V.appid == '' || _zw.V.appid == '0') return false;

        var d = {};
        d["appid"] = _zw.V.appid;
        d["page"] = _zw.V.current.page;
        d["ft"] = _zw.V.ft;
        d["state"] = '7';

        bootbox.confirm("완료처리 하시겠습니까?\n\n처리 후 변경, 삭제 할 수 없습니다!", function (rt) {
            if (rt) {
                $.ajax({
                    type: "POST",
                    url: "/ExS/CE/ChangeState",
                    data: JSON.stringify(d),
                    success: function (res) {
                        if (res.substr(0, 2) == "OK") {
                            bootbox.alert(res.substr(2));
                        } else bootbox.alert(res);
                    }
                });
            }
        });
    }

    _zw.mu.reqApproval = function (t) {
        var ft = '', tp = '', sj = '', k1 = '', k2 = '';

        if (_zw.V.current.page == 'grid') {
            if ($.trim($('input[data-zf-field="TOTALCOST"]').val()) == '') { alert('[총원가]란은 필수입니다!'); $('input[data-zf-field="TOTALCOST"]').focus(); return false; }
            if ($.trim($('input[data-zf-field="EXSALEPRICE"]').val()) == '') { alert('[판매예정가]란은 필수입니다!'); $('input[data-zf-field="EXSALEPRICE"]').focus(); return false; }
        }

        if (_zw.V.ft.toLowerCase() == 'report') {
            $(':checked[data-toggle="reqApproval"]').each(function () {
                k2 += ',' + $(this).val();
            });
            if (k2 == '') { bootbox.alert('결재요청 대상 견적표를 선택하십시오!'); return false; }
        }

        if (!window.confirm("결재요청 하시겠습니까?\n\r\n\r처리 중 화면을 새로고침 하지 마십시오!")) return false;

        _zw.ut.ajaxLoader(true, '양식 준비중 입니다');

        if (_zw.V.ft.toLowerCase() == 'stdexchangedetail') {
            ft = 'DRAFT'; tp = 'CE'; k1 = 'XRATE'; k2 = _zw.V.appid;

            var dt = new Date($('input[data-zf-field="STDDT"]').val()); //alert(dt.getFullYear() + " : " + (dt.getMonth() + 1))
            sj = dt.getFullYear() + "년 " + (dt.getMonth() + 1) + "월 본사 기준환율 " + $('[data-zf-field="XCLS"]').val() + "의 건";

            $('#__List .mt-2 table').each(function (i) {
                var ht = $('#_HiddenForm table')[i];
                $(this).find('tbody tr').each(function (j, row) {
                    var col = row.cells, hc = ht.rows[j + 1].cells;
                    for (var x = 0; x < col.length; x++) {
                        var v = ($(col[x]).find('input').length > 0) ? $(col[x]).find('input').val() : $(col[x]).text();

                        if (j == 2 && numeral(v).value() < 0) $(hc[x]).css('color', '#a94442');
                        $(hc[x]).text(v);
                    }
                });
            });

            var t = $('#__List .row .col-md-10 span');
            //var s = $(t[0]).text() + ' (기준환산율 대비 ' + $(t[1]).text() + '%';
            //if (numeral($(t[1]).text()).value() > 0) s += ' 높음)';
            //else if (numeral($(t[1]).text()).value() < 0) s += ' 낮음)';
            //else s += ')';

            //$('#_HiddenForm table').last().find('td').last().text(s); //console.log($('#_HiddenForm').html())
            $('#_HiddenFormData').val($('#_HiddenForm').html())

        } else if (_zw.V.ft.toLowerCase() == 'stdpaydetail') {
            ft = 'DRAFT'; tp = 'CE'; k1 = 'STDPAY'; k2 = _zw.V.appid;
            var dt = new Date($('input[data-zf-field="STDDT"]').val());
            sj = dt.getFullYear() + "년 기준율 " + $('[data-zf-field="XCLS"]').val() + "의 건";

            var s = ''
            $('.card[data-zf-code]').each(function () {
                if ($(this).find('input:checkbox').prop('checked')) {
                    var c = $(this).find('.card-body').clone();
                    var t = c.find('.z-grid');
                    t.removeClass('z-grid z-grid-bordered').attr({ 'cellpadding': '4px', 'cellspacing': '0', 'border': '0' }).css({ 'font-size': '13px', 'width': '1040px', 'border-top': '2px solid #666', 'border-left': '2px solid #666', 'border-right': '1px solid #666', 'border-bottom': '1px solid #666', 'text-align': 'center' });
                    t.find('colgroup').remove();

                    t.find('thead th').css('background-color', '#dff0d8');
                    t.find('th, td').removeClass('cell-read cell-input').css({ 'width': '80px', 'border-right': '1px solid #666', 'border-bottom': '1px solid #666' });
                    t.find('input:text').each(function () {
                        $(this).parent().html($(this).val() == '' ? '&nbsp;' : $(this).val());
                    });
                    s += '<div style="margin-bottom: 20px"><div style="padding-left: 8px; margin-bottom: 6px; font-weight: 700">- ' + $(this).find('.card-header a').text() + '</div><div>' + c.html() + '</div></div>';
                }
            });

            $('#_Corp_SMT').each(function () {
                var c = $(this).find('div').clone();
                var t = c.find('.z-grid');
                t.removeClass('z-grid z-grid-bordered').attr({ 'cellpadding': '4px', 'cellspacing': '0', 'border': '0' }).css({ 'font-size': '13px', 'width': '1040px', 'border-top': '2px solid #666', 'border-left': '2px solid #666', 'border-right': '1px solid #666', 'border-bottom': '1px solid #666', 'text-align': 'center' });
                t.find('colgroup').remove();

                t.find('thead th').css('background-color', '#dff0d8');
                t.find('th, td').removeClass('cell-read cell-input').css({ 'width': '80px', 'border-right': '1px solid #666', 'border-bottom': '1px solid #666' });
                t.find('input:text').each(function () {
                    $(this).parent().html($(this).val() == '' ? '&nbsp;' : $(this).val());
                });
                s += '<div style="margin-bottom: 20px"><div style="padding-left: 8px; margin-bottom: 6px; font-weight: 700">- SMT</div><div>' + c.html() + '</div></div>';
            });

            $('#_HiddenForm .p-first').html(dt.getFullYear() + "년 " + $('#_HiddenForm .p-first').html());
            $('#_HiddenForm .p-second').html($('#_HiddenForm .p-second').html() + dt.getFullYear() + "년 " + (dt.getMonth() + 1) + "월부터 적용");

            $('#_HiddenForm .p-html').html(s); //console.log($('#_HiddenForm').html())
            $('#_HiddenFormData').val($('#_HiddenForm').html());

        } else if (_zw.V.current.page == 'grid') {
            ft = _zw.V.rptmode < 3 ? 'PRIMECOSTESTIMATECHART' : 'PRIMECOSTESTIMATEPART';
            tp = 'CE_MAIN'; k1 = $('input[data-zf-field="MODEL"]').val(); k2 = _zw.V.appid;

        } else if (_zw.V.ft.toLowerCase() == 'report') {
            ft = 'PRIMECOSTESTIMATECHART'; tp = 'CE_MAIN'; k2 = escape(k2.substr(1));

            var fst = $('.z-list-body .table tbody tr[aria-level="' + $(':checked[data-toggle="reqApproval"]').attr('aria-posinset') + '"]:first');
            k1 = fst.find('td:nth-child(2)').text();
        }

        var qi = {};
        qi['M'] = 'new'; qi['xf'] = 'ea'; qi['fi'] = ''; qi['Tp'] = tp; qi['ft'] = ft; qi['k1'] = k1; qi['k2'] = k2; qi['sj'] = sj;
        var url = '/EA/Form?qi=' + encodeURIComponent(_zw.base64.encode(JSON.stringify(qi)));
        _zw.ut.openWnd(url, "", 800, 600, "resize");
    }

    _zw.mu.goList = function (page) {
        var qi = '{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ttl:"",opnode:"",ft:"' + page + '"}';
        window.location.href = '/ExS/CE?qi=' + _zw.base64.encode(qi);
    }

    _zw.fn.viewListItem = function (f, fld, model, t, sub) {
        
    }

    _zw.fn.viewListItemChild = function (batch, dir) {
        
    }

    _zw.fn.viewStdSimple = function (m, id) {
        m = m || 'StdExchange';
        $.ajax({
            type: "POST",
            url: "/ExS/CE/SimpleView",
            data: '{M:"' + m + '",ri:"' + id + '"}',
            success: function (res) {
                if (res.substr(0, 2) == "OK") $('#_SimpleView').html(res.substr(2));
                else bootbox.alert(res);
            },
            beforeSend: function () { } //로딩 X
        });
    }

    _zw.fn.viewStdInfo = function (id) {
        var page = _zw.V.ft + 'Detail';
        var qi = '{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ttl:"",opnode:"",ft:"' + page + '",appid:"' + id + '"}';
        window.location.href = '/ExS/CE?qi=' + _zw.base64.encode(qi);
    }

    _zw.fn.modalStdInfo = function (cls, id) {
        var url = '', w = 0, v = null;
        if (cls == 'XR') { url = 'StdExchange.aspx?M=modal'; w = 350; v = ($('#ddlXRATEDT').length > 0 && $('#ddlXRATEDT').val() != '') ? $('#ddlXRATEDT').val().split('_') : _zw.V.stdInfo['xrate']; }
        else if (cls == 'SP') { url = 'StdPay.aspx?M=modal'; w = 500; v = ($('#ddlSTDPAYDT').length > 0 && $('#ddlSTDPAYDT').val() != '') ? $('#ddlSTDPAYDT').val().split('_') : _zw.V.stdInfo['stdpay']; }
        else if (cls == 'OP') { url = 'OutPay.aspx?M=modal'; w = 500; v = ($('#ddlOUTPAYDT').length > 0 && $('#ddlOUTPAYDT').val() != '') ? $('#ddlOUTPAYDT').val().split('_') : _zw.V.stdInfo['outpay']; }

        id = v[0];

        if (url != '') {
            $.ajax({
                type: "POST",
                url: url,
                data: '{ri:"' + id + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        //_ZF.util.modal("_Modal", res.substr(2), w);
                    } else bootbox.alert(res)
                },
                beforeSend: function () { } //로딩 X
            });
        }
    }

    _zw.fn.modalERP = function (req, page, s) {
        if (req == 'model' && $('#ddlCORP').val() == '') { bootbox.alert('[생산지]를 먼저 선택하십시오!', function () { $('#ddlCORP').focus(); }); return false; }
        var param = '';
        if (arguments[3] && typeof arguments[3] === 'object') {
            for (var i in arguments[3]) {
                if (i == 0) param = ',rowkey:"' + arguments[3][i] + '"';
                else param += ',param' + i.toString() + ':"' + arguments[3][i] + '"';
            }
        } //alert(param); return;

        $.ajax({
            type: "POST",
            url: "/ExS/CE/ModelVendor", //getoracleerp
            data: '{req:"' + req + '",page:"' + page + '",search:"' + s + '"' + param + '}',
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    //_ZF.util.modal("_Modal", res.substr(2), 500);
                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.getUnitPrice = function (idx, p1, p2, p3) {
        if (p1 && p1 != '' && p2 && p2 != '' && p3 && p3 != '') {
            $.ajax({
                type: "POST",
                url: "/ExS/CE/UnitPrice", //getunitprice
                data: '{orgid:"' + p1 + '",itemno:"' + p2 + '",vendor:"' + p3 + '"}',
                success: function (res) { //alert(res)
                    if (res.substr(0, 2) == "OK") {
                        var v = res.substr(2).split(';');
                        _zw.G.setValue(idx, 'CURRENCY', v[0]);
                        _zw.G.setValue(idx, 'PRICE', numeral(v[1]).format('0,0.0000'));
                        _zw.G.setValue(idx, 'USDEX', v[0] == 'USD' ? '1.0000' : numeral(_zw.V.stdRate['USD_' + v[0]]).format('0,0.0000'));
                        _zw.G.setValue(idx, 'DESC', 'ERP 단가');

                    } else if (res.substr(0, 2) == "NO") {
                        bootbox.alert(res.substr(2));
                    } else {
                        bootbox.alert(res);
                    }
                }
            });
        }
    }

    _zw.fn.getUnitPrice = function (req, idx, p1, p2) {
        if (p1 && p1 != '' && p2 && p2 != '' && req && req != '') {
            $.ajax({
                type: "POST",
                url: "/ExS/CE/VendorUnitPrice", //getvendorunitprice
                data: '{req:"' + req + '",rowkey:"' + idx + '",orgid:"' + p1 + '",itemno:"' + p2 + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        //_ZF.util.modal("_Modal", res.substr(2), 500);
                    } else if (res.substr(0, 2) == "NO") {
                        bootbox.alert(res.substr(2));
                    } else {
                        bootbox.alert(res);
                    }
                }
            });
        }
    }

    _zw.fn.getModelBOM = function (p1, p2) {
        $.ajax({
            type: "POST",
            url: "/ExS/CE/ModelBom", //getmodelbom
            data: '{orgid:"' + p1 + '",model:"' + p2 + '"}',
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    $('.z-ce-layout-hhd').fadeIn("slow", function () {
                        var p = $(this);
                        p.html(res.substr(2)); //alert(p.html())

                        if (!p.hasClass("show")) {
                            p.removeClass("fade").addClass("show");
                        }

                        p.find("button[data-dismiss='modal']").click(function () {
                            p.html('').removeClass("show").addClass("fade").fadeOut();
                        });

                        p.find('thead input[name="ckbAll"]').on('click', function () {
                            var b = $(this).prop('checked')
                            p.find('tbody input[name="ckbRow"]').each(function () {
                                $(this).prop('checked', b);
                            });
                        });

                        p.find('.modal-footer .btn-success').on('click', function () {
                            p.find('tbody input[name="ckbRow"]:checked').each(function () {
                                var rows = _zw.G.findRows({
                                    //'ITEMID': $(this).val(),
                                    'ITEMNO': $(this).parent().next().next().text()
                                });
                                if (rows.length > 0) {
                                    //if (window.confirm('품목 [' + $(this).parent().next().text() + '](이)가 이미 존재합니다. 덮어씌우겠습니까?')) {
                                    _zw.G.setValue(rows[0].rowKey, 'ITEMID', $(this).val());
                                    _zw.G.setValue(rows[0].rowKey, 'ITEMNO', $(this).parent().next().next().text());
                                    _zw.G.setValue(rows[0].rowKey, 'ITEMNM', $(this).parent().next().next().next().text());
                                    if ($.trim($(this).parent().next().next().next().next().text()) != '') _zw.G.setValue(rows[0].rowKey, 'STDDESC', $(this).parent().next().next().next().next().text());

                                    _zw.G.setValue(rows[0].rowKey, 'DESC', rows.length + '개 중복');
                                    //}
                                } else {
                                    _zw.G.appendRow({
                                        'ITEMID': $(this).val(),
                                        'ITEMNO': $(this).parent().next().next().text(),
                                        'ITEMNM': $(this).parent().next().next().next().text(),
                                        'STDDESC': $(this).parent().next().next().next().next().text()
                                    });
                                }
                            });

                            _zw.ut.calcGridRow();
                        });
                    });

                } else if (res.substr(0, 2) == "NO") {
                    bootbox.alert(res.substr(2));
                } else {
                    bootbox.alert(res);
                }
            }
        });
    }

    _zw.fn.validate = function (pos) {
        var m, s;

        if (_zw.V.ft.toLowerCase() == "stdexchangedetail" || _zw.V.ft.toLowerCase() == "stdpaydetail" || _zw.V.ft.toLowerCase() == "outpaydetail") {
            m = ["STDDT;적용시점", "XCLS;구분"];

            for (var i in m) {
                var v = m[i].split(';');
                var f = $('[data-zf-field="' + v[0] + '"]');
                if (f.val() == '') {
                    bootbox.alert("필수항목[" + v[1] + "] 입력 누락!", function () { f.focus(); }); return false;
                }
            }
        }
        return true;
    }

    _zw.fn.showGridRowDesc = function (req, rowKey) {
        var s = '<div class="modal-dialog modal-dialog-scrollable">'
            + '<div class="modal-content" data-for="grid-row-desc">'
            + '<div class="modal-header">'
            + '<h4 class="modal-title">산출내역</h4>'
            + '<button type="button" class="close" data-dismiss="modal"><span>×</span></button>'
            + '</div>'
            + '<div class="modal-body">'
            + '<form>'
            + '<input type="hidden" data-zf-field="modal_req" value="' + req + '" />'
            + '<input type="hidden" data-zf-field="modal_rowkey" value="' + rowKey + '" />'
            + '<table class="table table-striped table-condensed">'
            + '<tbody>'
            + '<tr><td style="width: 80%">ERP 단가</td><td><button type="button" class="btn btn-success modal-inline-btn"><i class="glyphicon glyphicon-ok"></i></button></td></tr>'
            + '<tr><td>개발구매 입수단가</td><td><button type="button" class="btn btn-success modal-inline-btn"><i class="glyphicon glyphicon-ok"></i></button></td></tr>'
            + '<tr><td>설계 계산단가</td><td><button type="button" class="btn btn-success modal-inline-btn"><i class="glyphicon glyphicon-ok"></i></button></td></tr>'
            + '<tr><td>업체 견적단가</td><td><button type="button" class="btn btn-success modal-inline-btn"><i class="glyphicon glyphicon-ok"></i></button></td></tr>'
            + '<tr><td><input type="text" class="form-control modal-inline-input" /></td><td><button type="button" class="btn btn-success modal-inline-btn"><i class="glyphicon glyphicon-ok"></i></button></td></tr>'
            + '</tbody>'
            + '</table>'
            + '</form>'
            + '</div>'
            + '<div class="modal-footer">'
            + '<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>'
            + '</div></div></div>';

        //_ZF.util.modal("_Modal", s);
    }

    _zw.fn.onblurCategory = function (e, v) { //console.log(e); console.log(v);
        if (_zw.V.ft.toLowerCase() == 'stdexchangedetail') { //기준환율
            if ($(e).attr('data-zf-field') != 'S_USD_IDR') {
                var idx = parseInt($(e).parent().prop('cellIndex')) + 1;
                e1 = $(e).parent().parent().prev().find('td:nth-child(' + idx + ')');
                e2 = $(e).parent().parent().next().find('td:nth-child(' + idx + ')').find('input');

                e2.val(numeral(numeral(numeral(e.value).value() - numeral(e1.text()).value()).value() / numeral(e1.text()).value() * 100).format('0,0.00'));
            }

            if ($(e).attr('data-zf-field') == 'USD_IDR' || $(e).attr('data-zf-field') == 'S_USD_IDR') {
                e3 = $('input[data-zf-field="USD_IDR"]'); e4 = $('input[data-zf-field="S_USD_IDR"]'); e5 = e4.parent().next().find('input');

                e5.val(numeral(numeral(numeral(e4.val()).value() - numeral(e3.val()).value()).value() / numeral(e3.val()).value() * 100).format('0,0.00'));
            }
        } else if (_zw.V.ft.toLowerCase() == 'stdpaydetail') { //기준임율
            var e1 = $(e).parent().parent(); //row
            var val = e1.find('input[data-column="CORP"]').val();
            if (val == 'CD_SMT' || val == 'VH_SMT') {
                e2 = 0;
                e1.find('td').each(function (idx, e) {
                    if (e.firstChild.getAttribute('data-column') != 'SMT_COST') {
                        e2 += numeral(e.firstChild.value).value();
                    }
                });
                //console.log(numeral(e2).format('0,0.00000'))
                if (numeral(e2).value() != 0) e1.find('input[data-column="SMT_COST"]').val(numeral(e2).format('0,0.00000'));
            }

        } else if (_zw.V.ft.toLowerCase() == 'outpaydetail') { //외주임율
            var idx = parseInt($(e).parent().prop('cellIndex')) + 1;
            e1 = $(e).parent().parent().prev().find('td:nth-child(' + idx + ')').find('input');
            e2 = $(e).parent().parent().next().find('td:nth-child(' + idx + ')').find('input');

            e2.val(numeral(numeral(e.value).value() / numeral(_zw.V.stdrate['USD_' + e1.val()]).value()).format('0,0.0000'));

        } else if (_zw.V.ft.toLowerCase() == 'grid') { //견적표
            desc = $(e).parent().parent().parent().parent().attr('data-zf-subtable'); //alert(desc)

            if (desc == 'CE_COST_PC' && $(e).attr('data-zf-field') == 'MPNT') {//가공비 구분
                e1 = numeral(numeral($(e).val()).value() * numeral($(e).parent().next().children('input').val()).value()).format('0,0.0000');
                $(e).parent().next().next().children('input').val(e1);

                calcCost(2);

            } else if (desc == 'CE_COST_SGA' && $(e).attr('data-zf-field') == 'SUM') {//판관비
                //                    e1 = 0;
                //                    $('table[data-zf-subtable="CE_COST_SGA"] input[data-zf-ftype="SUBFIELD"]').each(function() {
                //                        if ($(this).attr('data-zf-field') == 'SUM') e1 += numeral($(this).val()).value();
                //                    });
                //                    if (e1 && e1 != 0) $('input[data-zf-field="SGACOST"]').val(numeral(e1).format('0,0.00'));

                calcCost(3);

            } else if ($(e).attr('data-zf-field') == 'EXSALEPRICE') {//판매예정가
                calcCost(4);
            } else if ($(e).attr('data-zf-field') == 'EXOPPROFITRT') {//예상영업이익이익율
                var i = numeral($('input[data-zf-field="TOTALCOST"]').val()).value(); //총원가
                $('input[data-zf-field="EXSALEPRICE"]').val(numeral(i / (1 - numeral($(e).val()).value())).format('0,0.0000'));
                calcCost(4);
            }
        }
    }

    _zw.fn.setCode = function (m, p, cd, row) {
        var v = cd.split('.'), k3 = '', i1 = '', i2 = '', i3 = '', i4 = '', i5 = '';
        if (m == 'save') m = row.find('input[data-zf-field="k3"]').prop('readonly') === true ? "U" : "I";
        else if (m == 'delete') m = 'D';

        row.find('input[data-zf-field]').each(function () {
            switch ($(this).attr('data-zf-field')) {
                case 'k3': k3 = $(this).val(); break;
                case 'item1': i1 = $(this).val(); break;
                case 'item2': i2 = $(this).val(); break;
                case 'item3': i3 = $(this).val(); break;
                case 'item4': i4 = $(this).val(); break;
                case 'item5': i5 = $(this).val(); break;
            }
        });

        if (m == 'D' && k3 == '' && i1 == '' && i2 == '' && i3 == '') { row.remove(); return false; }

        $.ajax({
            type: "POST",
            url: "/ExS/MC/SetCode",
            data: '{M:"' + m + '",k1:"' + v[0] + '",k2:"' + v[1] + '",k3:"' + k3 + '",item1:"' + i1 + '",item2:"' + i2 + '",item3:"' + i3 + '",item4:"' + i4 + '",item5:"' + i5 + '"}',
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    p.find('table').remove(); p.append(res.substr(2));
                    p.find('table tbody button[data-btn="del"]').on('click', function () {
                        _zw.fn.setCode('delete', p, cd, $(this).parent().parent().parent());
                    });
                    p.find('table tbody button[data-btn="save"]').on('click', function () {
                        _zw.fn.setCode('save', p, cd, $(this).parent().parent().parent());
                    });
                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.sort = function (col) {
        var el = event.target ? event.target : event.srcElement;
        var dir = $(el).find('i').hasClass('fe-arrow-up') ? 'DESC' : 'ASC';
        _zw.fn.goSearch(null, col, dir);
    }

    _zw.fn.goSearch = function (page, sort, dir) {//lert(1)
        _zw.fn.initLv();

        sort = sort || ''; dir = dir || '';
        _zw.V.lv.sort = sort;
        _zw.V.lv.sortdir = dir;

        _zw.V.lv.page = (page) ? page : 1;
        _zw.V.lv.start = $('#_SearchYear').val();

        var e = $('.z-lv-cond input.search-text');
        if (e.length > 0) {
            var s = "['\\%^&\"*]";
            var reg = new RegExp(s, 'g');
            if (e.val().search(reg) >= 0) { alert(s + " 문자는 사용될 수 없습니다!"); e.val(''); return; }

            if ($.trim(e.val()) != '') {
                _zw.V.lv.search = 'M'; //모델 + 고객
                _zw.V.lv.searchtext = e.val();
            }
        }

        _zw.V.lv.cd1 = $('input[name="rdoSearch"]:checked').val() || '';

        _zw.fn.loadList();
    }

    _zw.fn.loadList = function () {
        var postData = _zw.fn.getLvQuery(true); console.log(postData)
        var url = '?qi=' + encodeURIComponent(_zw.base64.encode(postData));

        $.ajax({
            type: "POST",
            url: url,
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    history.pushState(null, null, url);

                    $('#__List').html(res.substr(2));

                } else bootbox.alert(res);
            }
        });
    }
    
    _zw.fn.getLvQuery = function () {
        var j = {};
        j["ct"] = _zw.V.ct;
        j["ctalias"] = _zw.V.ctalias;
        j["ot"] = _zw.V.ot;
        j["alias"] = _zw.V.alias;
        j["xfalias"] = _zw.V.xfalias;
        j["fdid"] = _zw.V.fdid;
        j["acl"] = _zw.V.current.acl;
        j["opnode"] = _zw.V.opnode;
        j["ft"] = _zw.V.ft;
        j["ttl"] = _zw.V.ttl;

        j["tgt"] = _zw.V.lv.tgt;
        j["page"] = _zw.V.lv.page;
        j["count"] = _zw.V.lv.count;
        j["sort"] = _zw.V.lv.sort;
        j["sortdir"] = _zw.V.lv.sortdir;
        j["search"] = _zw.V.lv.search;
        j["searchtext"] = _zw.V.lv.searchtext;
        j["start"] = _zw.V.lv.start;
        j["end"] = _zw.V.lv.end;
        j["basesort"] = _zw.V.lv.basesort;
        j["boundary"] = _zw.V.lv.boundary;

        j["cd1"] = _zw.V.lv.cd1; j["cd2"] = _zw.V.lv.cd2; j["cd3"] = _zw.V.lv.cd3;

        return JSON.stringify(j);
    }

    _zw.fn.initLv = function (tgt) {
        var sCnt = _zw.ut.getCookie('costLvCount');
        //if ($('.z-list-page select').length > 0) sCnt = $('.z-list-page select').val();

        //_zw.V.lv.tgt = tgt;
        _zw.V.lv.page = '1';
        _zw.V.lv.count = sCnt == '' ? '20' : sCnt;
        _zw.V.lv.sort = '';
        _zw.V.lv.sortdir = '';
        _zw.V.lv.search = '';
        _zw.V.lv.searchtext = '';
        _zw.V.lv.start = '';
        _zw.V.lv.end = '';
        _zw.V.lv.basesort = '';

        _zw.V.lv.cd1 = ''; _zw.V.lv.cd2 = ''; _zw.V.lv.cd3 = '';
    }

    _zw.ut.calcGridRow = function () {
        $('span[data-for="_rowCount"]').text('(' + _zw.G.getRowCount() + '행)');
        var v = $('select[data-zf-field="XCLS"]').val();
        if (v !== undefined && (v == '기구' || v == '회로' || v == '음향')) {
            for (var x = 0; x < _zw.G.getRowCount(); x++) {
                var cv = _zw.G.getValue(x, 'CLS');
                if (cv == null || cv == '') _zw.G.setValue(x, 'CLS', v);
            }
        }
    }
});