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

    _zw.fn.bindCtrl = function () {
        _zw.fn.openGrid();

        $('.z-list-body :checkbox[aria-posinset]').on('click', function () {
            var seq = $(this).attr('aria-posinset'), tgl = $(this).attr('data-toggle');

            if ($(this).prop('checked')) {
                $('.z-list-body :checkbox[aria-posinset]').each(function () {
                    if ($(this).attr('aria-posinset') != seq || $(this).attr('data-toggle') != tgl) {
                        if ($(this).prop('checked')) $(this).prop('checked', false);
                    }
                });

                $('.z-lv-menu a[data-zf-menu]').each(function () {
                    if ($(this).attr('data-zf-menu') == tgl) $(this).removeClass('text-muted').addClass('z-lnk-navy-n').prop('disabled', false);
                    else $(this).removeClass('z-lnk-navy-n').addClass('text-muted').prop('disabled', true);
                });
            } else {
                var bCheck = false;
                $('.z-list-body :checkbox[aria-posinset]').each(function () {
                    if ($(this).prop('checked')) { bCheck = true; return false; }
                });
                if (!bCheck) $('.z-lv-menu a[data-zf-menu]').removeClass('z-lnk-navy-n').addClass('text-muted').prop('disabled', true);
            }
        });

        $('.z-list-body .table .btn[aria-expanded]').on('click', function () {
            var row = $(this).parent().parent();

            if (_zw.V.ft.toLowerCase() == 'report') {
                var lvl = row.attr('aria-level');
                var fst = $('.z-list-body .table tbody tr[aria-level="' + lvl + '"]:first'); //alert($(this).attr('data-value'))
                var idx = fst.find('th[rowspan]').prop('rowspan'); //alert(idx)

                if ($(this).attr('aria-expanded') == 'false') {
                    var s = '';
                    var res = _zw.ut.ajaxSync("/ExS/CE/ChildList", '{ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",pntid:"' + $(this).val() + '",page:"' + _zw.V.ft.toLowerCase() + '",mo:"' + _zw.V.current.operator + '",acl:"' + _zw.V.current.acl + '"}');
                    if (res.substr(0, 2) == "OK") s = res.substr(2);
                    else bootbox.alert(res);

                    if (s != '') {
                        s = '<tr><td colspan="11" class="table-active"" style="padding: 6px">' + s + '</td></tr>';
                        $(s).insertAfter(row);
                        fst.find('th[rowspan], td[rowspan]').prop('rowspan', idx + 1);

                        $(this).attr('aria-expanded', 'true');
                        $(this).find('i').removeClass('fa-plus').addClass('fa-minus');

                        _zw.fn.openGrid();
                    }

                } else {
                    row.next().remove();
                    fst.find('th[rowspan], td[rowspan]').prop('rowspan', idx - 1);

                    $(this).attr('aria-expanded', 'false');
                    $(this).find('i').removeClass('fa-minus').addClass('fa-plus');
                }

            } else if (_zw.V.ft.toLowerCase() == 'list' || _zw.V.ft.toLowerCase() == 'mylist' || _zw.V.ft.toLowerCase() == 'deptlist') {
                if ($(this).attr('aria-expanded') == 'false') {
                    var s = '';
                    var res = _zw.ut.ajaxSync("/ExS/CE/ChildList", '{ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",pntid:"' + $(this).val() + '",page:"' + _zw.V.ft.toLowerCase() + '",mo:"' + _zw.V.current.operator + '",acl:"' + _zw.V.current.acl + '"}');
                    if (res.substr(0, 2) == "OK") s = res.substr(2);
                    else bootbox.alert(res);

                    if (s != '') {
                        s = '<tr><td colspan="9" class="table-active"" style="padding: 6px">' + s + '</td></tr>';
                        $(s).insertAfter(row);
                        row.find('td:nth-child(1), td:nth-child(2), td:nth-child(3)').prop('rowspan', 2);

                        $(this).attr('aria-expanded', 'true');
                        $(this).find('i').removeClass('fa-plus').addClass('fa-minus');

                        _zw.fn.openGrid();

                        row.next().find('.btn[data-btn="revise"]').on('click', function () {
                            var sPnt = $(this).val(), sID = '';
                            $(this).parent().parent().parent().find(':checked').each(function () {
                                sID += ';' + $(this).val()
                            }); //alert(sPnt + " : " + sID); return false;
                            if (sID != '') {
                                //window.location.href = "Grid.aspx?M=renew&lv=list&app=" + sPnt + "&Rp=" + escape(sID.substr(1));
                                var qi = '{M:"renew",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ttl:"",opnode:"",ft:"Grid",appid:"' + sPnt + '",rptid:"' + sID.substr(1) + '"}';
                                _zw.fn.openGrid('?qi=' + encodeURIComponent(_zw.base64.encode(qi)));
                            } else bootbox.alert('개정에 포함할 부문견적표를 선택하십시오!');
                        });

                        //row.next().find('.btn[data-btn="showCompTable"]').on('click', function() {
                        //    _ZF.menu.showCompTable($(this).val());
                        //});
                    }

                } else {
                    row.next().remove();
                    row.find('td:nth-child(1), td:nth-child(2), td:nth-child(3)').prop('rowspan', 1);

                    $(this).attr('aria-expanded', 'false');
                    $(this).find('i').removeClass('fa-minus').addClass('fa-plus');
                }
            }
        });
    }

    _zw.mu.exportExcel = function () {
        var qi = '{M:"xls",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ttl:"",opnode:"' + $('input[data-zf-field="STDDT"]').val() + '",ft:"' + _zw.V.ft + '",appid:"' + _zw.V.appid + '"}';
        //window.open('?qi=' + encodeURIComponent(_zw.base64.encode(qi)));
        window.open('?qi=' + encodeURIComponent(_zw.base64.encode(qi)), 'ifrView');
    }

    _zw.mu.importExcel = function () {
        var url = '/Common/FileImport?M=CE_STDPAY&sy=&cd=';
        $.ajax({
            type: "POST",
            url: url,
            success: function (res) {
                var p = $('#popBlank');
                p.html(res); _zw.fu.bind();
                fm = p.find('#uploadForm')[0].action = url;

                p.on('hidden.bs.modal', function () { p.html(''); });
                p.modal();
            }
        });
    }

    _zw.fn.complete = function (msg) {
        var p = $('#popBlank');
        p.find('.zf-upload #uploadForm')[0].reset();

        var rt = decodeURIComponent(msg).replace(/\+/gi, ' ');
        if (rt.substr(0, 2) == 'OK') {
            var footer = '<div class="modal-footer justify-content-center">'
                + '<button type="button" class="btn btn-primary" data-zm-menu="confirm">확인</button>'
                + '<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>'
                + '</div>';

            p.find('.zf-upload .zf-upload-list').html(rt.substr(2)).removeClass('d-none');
            p.find('.modal-content').append(footer);

            p.find('.modal-footer .btn[data-zm-menu="confirm"]').click(function () {
                p.modal('hide');

                $('#_Corp_StdPay').html(p.find('#__RESULTINFO').html()); _zw.fn.input();

                $('.accordion .card[data-zf-code] .card-header :checkbox').click(function () {
                    var lnk = $(this).parent().parent().prev();
                    if ($(this).prop('checked')) {
                        bootbox.confirm('해당 생산지 임율 정보를 저장할 수 있습니다. 계속하시겠습니까?', function () {
                            lnk.attr('data-toggle', 'collapse'); $(lnk.attr('data-target')).collapse('show'); //console.log(lnk.attr('data-target'))
                        });

                    } else {
                        bootbox.confirm('해당 생산지 신규 또는 변경 임율 정보가 저장되지 않습니다. 계속하시겠습니까?', function () {
                            lnk.attr('data-toggle', ''); $(lnk.attr('data-target')).collapse('hide');
                        });
                    }
                });

            });

        } else {
            p.find('.zf-upload .zf-upload-list').html(rt).removeClass('d-none');
        }
        p.find('.zf-upload .zf-upload-bar').addClass('d-none');
        if (p.find('.modal-dialog').hasClass('modal-sm')) p.find('.modal-dialog').removeClass('modal-sm');
    }

    _zw.mu.saveTemp = function (t) {
        _zw.mu.saveStd(t);
    }

    _zw.mu.saveStd = function (t) {
        var pos = t ? t.attr('data-zf-menu').toLowerCase() : '';
        //var page = _zw.V.current.page.toLowerCase() == "grid" ? _zw.V.current.page.toLowerCase() : _zw.V.ft.toLowerCase();
        var page = _zw.V.ft.toLowerCase();
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
                    } else if ($(this).attr('data-zf-field') == 'STDDT') {
                        d[$(this).attr('data-zf-field').toLowerCase()] = _zw.ut.date($(this).val(), 'YYYY-MM-DD');
                    } else {
                        d[$(this).attr('data-zf-field').toLowerCase()] = $(this).val();
                    }
                });
            }

            if (page == "stdpaydetail") {
                //                    var gc = _zw.G.getColumns();
                //                    var gd = _zw.G.getData();
                //                    //var cv = _zw.G.getColumnValues('CORP');
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
                //var cv = _zw.G.getColumnValues('CORP');
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
                                    bootbox.alert(r[1], function () {
                                        if (page == 'grid') {
                                            if (opener) opener.location.reload();
                                            window.close();
                                        } else _zw.mu.goList(_zw.V.ft.replace('Detail', ''));
                                    });

                                } else {
                                    bootbox.alert(res.substr(2));
                                }

                            } else bootbox.alert(res);
                        },
                        beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
                    });
                }
            });
        }
    }

    _zw.mu.deleteStd = function (t) {
        if (_zw.V.appid == '' || _zw.V.appid == '0') return false;
        var page = _zw.V.ft.replace('Detail', '').toLowerCase();
        var d = {};
        d["M"] = 'D';
        d["appid"] = _zw.V.appid;
        d["page"] = page;
        d["state"] = '';

        bootbox.confirm("삭제 하시겠습니까?", function (rt) {
            if (rt) {
                $.ajax({
                    type: "POST",
                    url: "/ExS/CE/SetStd",
                    data: JSON.stringify(d),
                    success: function (res) {
                        if (res.substr(0, 2) == "OK") {
                            bootbox.alert(res.substr(2), function () {
                                if (page == 'grid') {
                                    opener.location.reload(); window.close();
                                } else _zw.mu.goList(page);
                            });
                        } else bootbox.alert(res);
                    },
                    beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
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
                    },
                    beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
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
        //_zw.ut.ajaxLoader(true);

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

        } else if (_zw.V.ft.toLowerCase() == 'grid') {
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

    _zw.mu.reportGrid = function () {
        var sID = ''
        $(':checkbox[aria-posinset]').each(function () {
            if ($(this).prop('checked')) { sID += ';' + $(this).val() }
        });
        if (sID != '') {
            sID = sID.substr(1);
            var qi = '{M:"new",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ttl:"",opnode:"",ft:"Grid",appid:"0",rptid:"' + sID + '"}';
            _zw.fn.openGrid('?qi=' + encodeURIComponent(_zw.base64.encode(qi)));
        }
    }

    _zw.mu.copyGrid = function () {
        var sID = $(':checked[aria-posinset]').val();
        if (sID !== undefined && sID != '') {
            $.ajax({
                type: "POST",
                url: "/ExS/CE/GridCopy",
                data: '{appid:"' + sID + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        var p = $('#popBlank'); p.html(res.substr(2));

                        p.find("select[data-modal-column='BUYERCLS']").on('change', function (e) {
                            e.preventDefault();

                            var n = p.find("input[data-modal-column='BUYER']");
                            if ($(this).val() != '기타') n.val($(this).val()).prop('readonly', true);
                            else n.val('').prop('readonly', false);
                        });

                        p.find("input[data-modal-column='MODEL'], input[data-modal-column='MODELNM'], input [data-modal-column='BUYER']").on('blur', function (e) {
                            $(this).val(function (i, val) {
                                return val.toUpperCase();
                            });
                        });

                        p.find('.modal-footer .btn[data-btn="send"]').click(function () {
                            var d = {}, msg = '', b = true;
                            p.find("[data-modal-column]").each(function () {
                                if ($(this).attr('data-modal-column') != 'DSCPT' && $.trim($(this).val()) == '') {
                                    bootbox.alert('[' + $(this).parent().prev().text() + ']란은 필수입니다!', function () { $(this).focus(); });  b = false; return false;
                                }
                                if ($(this).attr('data-modal-column') == 'MODEL') msg = $(this).val();
                                d[$(this).attr('data-modal-column').toLowerCase()] = $(this).val();
                            }); //alert(JSON.stringify(d))

                            if (b) {
                                bootbox.confirm('[' + msg + '] 모델 견적표를 복사하시겠습니까?', function (rt) {
                                    if (rt) {
                                        $.ajax({
                                            type: "POST",
                                            url: "/ExS/CE/CopyGrid",
                                            data: JSON.stringify(d),
                                            success: function (res) {
                                                if (res.substr(0, 2) == "OK") {
                                                    var r = res.substr(2).split('^'); //alert(r[1]); window.location.href = "Grid.aspx?M=edit&app=" + r[0];
                                                    bootbox.alert(r[1], function () { window.location.reload(); });
                                                } else bootbox.alert(res);
                                            },
                                            beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
                                        });
                                    }
                                }); 
                            }
                        });

                        p.on('hidden.bs.modal', function () { p.html(''); });
                        p.modal();

                    } else bootbox.alert(res);
                }
            });
        }
    }

    _zw.mu.showGridDscpt = function () {
        var txt = $('textarea[data-zf-field="DSCPT"]').val();

        var s = '<div class="modal-dialog modal-sm">'
            + '<div class="modal-content" data-for="grid-dscpt">'
            + '<div class="modal-header">'
            + '<h4 class="modal-title">특기사항</h4>'
            + '<button type="button" class="close" data-dismiss="modal"><span>×</span></button>'
            + '</div>'
            + '<div class="modal-body">'
            + '<form>'
            + '<textarea class="form-control" rows="10">' + txt + '</textarea>'
            + '</form>'
            + '</div>'
            + '<div class="modal-footer">';

        if (_zw.V.mode == '' || _zw.V.mode == 'simul' || _zw.V.mode == 'read') s += '<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>';
        else s += '<button type="button" class="btn btn-success" data-btn="send">저장</button><button type="button" class="btn btn-default" data-dismiss="modal">취소</button>';

        s += '</div></div></div>';

        var p = $('#popBlank'); p.html(s);
        p.find('.modal-footer .btn[data-btn="send"]').click(function () {
            $('textarea[data-zf-field="DSCPT"]').val($(this).parent().prev().find('textarea').val());
            p.modal('hide');
        });

        p.on('hidden.bs.modal', function () { p.html(''); });
        p.modal();
    }

    //_zw.mu.reqReview = function () {
    //    $.ajax({
    //        type: "POST",
    //        url: "/ExS/CE/StateLine",
    //        data: '{mode:"V",appid:"' + _zw.V.appid + '",nested:"' + _zw.V.nsstatus + '"}',
    //        success: function (res) {
    //            if (res.substr(0, 2) == "OK") {
    //                var p = $('#popBlank'); p.html(res.substr(2));
    //                p.on('hidden.bs.modal', function () { p.html(''); });
    //                p.modal();
    //            } else bootbox.alert(res);
    //        }
    //    });
    //}

    _zw.mu.viewConfirm = function () {
        $.ajax({
            type: "POST",
            url: "/ExS/CE/StateLine",
            data: '{mode:"",appid:"' + _zw.V.appid + '",chief:"' + _zw.V.current.chief + '",nested:"' + _zw.V.nsstatus + '"}',
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    var p = $('#popBlank'); p.html(res.substr(2));

                    p.find(".modal-body table .btn[data-btn='send'][data-for]").click(function () {
                        var d = {}, msg = '';
                        d["appid"] = _zw.V.appid;

                        if ($(this).attr('data-for') == 'REQSTATE') {
                            var cmnt = $(this).parent().prev().find('textarea');
                            if ($.trim(cmnt.val()) == '') { bootbox.alert("요청 사유을 입력하십시오!", function () { cmnt.focus(); }); return false; }

                            d["mode"] = "V";
                            d["ss"] = '6';
                            d["reqcmnt"] = cmnt.val();
                            msg = "재검토 요청을 하시겠습니까?\n처리 후 변경 할 수 없습니다!"

                        } else if ($(this).attr('data-for') == 'FCFMSS') {
                            d["mode"] = "F";
                            if ($(':hidden[data-zf-ftype="MAINFIELD"][data-zf-field="FCFMSS"]').val() == 'Y') {
                                d["ss"] = 'N'; msg = "작성 확인 취소 하시겠습니까?";
                            } else {
                                d["ss"] = 'Y'; msg = "작성 확인 하시겠습니까?";
                            }

                        } else if ($(this).attr('data-for') == 'SCFMSS') {
                            d["mode"] = "S";
                            if ($(':hidden[data-zf-ftype="MAINFIELD"][data-zf-field="SCFMSS"]').val() == 'Y') {
                                d["ss"] = 'N'; msg = "부서장 확인 취소 하시겠습니까?";
                            } else {
                                d["ss"] = 'Y'; msg = "부서장 확인 하시겠습니까?";
                            }
                        }

                        bootbox.confirm(msg, function (rt) {
                            if (rt) {
                                $.ajax({
                                    type: "POST",
                                    url: "/ExS/CE/RequestReview",
                                    data: JSON.stringify(d),
                                    success: function (res) {
                                        if (res.substr(0, 2) == "OK") {
                                            bootbox.alert(res.substr(2), function () { window.location.reload(); });
                                        } else bootbox.alert(res);
                                    },
                                    beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
                                });
                            }
                        });
                    });

                    p.on('hidden.bs.modal', function () { p.html(''); });
                    p.modal();
                } else bootbox.alert(res);
            }
        });
    }

    _zw.mu.viewChiefCfm = function () {
        var sID = ''
        $(':checkbox[aria-posinset]').each(function () {
            if ($(this).prop('checked')) { sID += ',' + $(this).val() }
        });
        if (sID != '') {
            sID = sID.substr(1);

            bootbox.confirm("선택한 견적표에 대한 부서장 [확인]을 하시겠습니까?<br />[확인 취소]는 개별 견적표에서 가능합니다", function (rt) {
                if (rt) {
                    $.ajax({
                        type: "POST",
                        url: "/ExS/CE/ConfirmChief",
                        data: '{mode:"",appid:"' + sID + '",chief:"' + _zw.V.current.chief + '",ss:"Y"}',
                        success: function (res) {
                            if (res.substr(0, 2) == "OK") {
                                bootbox.alert(res.substr(2), function () { window.location.reload(); });
                            } else bootbox.alert(res);
                        },
                        beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
                    });
                }
            });
        }
    }

    _zw.mu.showHistory = function () {
        var sID = typeof arguments[0] === 'string' ? arguments[0] : _zw.V.appid;

        $.ajax({
            type: "POST",
            url: "/ExS/CE/HistoryInfo",
            data: '{mode:"",appid:"' + sID + '",page:"' + _zw.V.ft.toLowerCase() + '",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '"}',
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    var p = $('#popBlank'); p.html(res.substr(2));
                    p.on('hidden.bs.modal', function () { p.html(''); });
                    p.modal();
                } else bootbox.alert(res);
            }
        });
    }

    _zw.mu.showCompTable = function () {
        var sID = typeof arguments[0] === 'string' ? arguments[0] : _zw.V.appid;

        $.ajax({
            type: "POST",
            url: "/ExS/CE/CompTable",
            data: '{mode:"",appid:"' + sID + '",page:"' + _zw.V.ft.toLowerCase() + '",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '"}',
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    var p = $('#popBlank'); p.html(res.substr(2));

                    p.find('.modal-body a[data-query]').click(function () {
                        if (_zw.V.ft.toLowerCase() == 'grid') window.location.href = _zw.V.current.page + $(this).attr("data-query");
                        else _zw.fn.openGrid($(this).attr("data-query"));
                        p.modal('hide');
                    });

                    p.on('hidden.bs.modal', function () { p.html(''); });
                    p.modal();
                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.openGrid = function (qi) {
        if (qi && qi != '' && qi.indexOf('?') >= 0) {
            var w = window.screen.width, h = window.screen.height;
            w = w >= 1600 ? parseInt(w * 0.85) : w; h = h >= 900 ? parseInt(h * 0.85) : h; //console.log($(this).attr('data-query'))

            _zw.ut.openWnd('/ExS/CE/Grid' + qi, 'CEGrid', w, h, 'resize');

        } else {
            $('.z-list-body a[data-query]').on('click', function () {
                if (_zw.ut.isMobile()) { bootbox.alert('모바일 환경에서는 지원되지 않습니다!'); return false; }

                var w = window.screen.width, h = window.screen.height;
                w = w >= 1600 ? parseInt(w * 0.85) : w; h = h >= 900 ? parseInt(h * 0.85) : h; //console.log($(this).attr('data-query'))

                _zw.ut.openWnd('/ExS/CE/Grid' + $(this).attr('data-query'), 'CEGrid', w, h, 'resize');
            });
        }
    }

    _zw.mu.previewGrid = function () {
        var url = "/ExS/CE/GridPreview?Xc=" + ($('[data-zf-field="XCLS"]').val() == 'ALL' ? '' : encodeURI(_zw.base64.encode($('[data-zf-field="XCLS"]').val())));
        var w = window.screen.width, h = window.screen.height;
        w = w >= 1600 ? parseInt(w * 0.85) : w; h = h >= 900 ? parseInt(h * 0.85) : h; //console.log($(this).attr('data-query'))

        _zw.ut.openWnd(url, 'CEGridPreview', w, h, 'resize');
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
        var v = null;
        if (cls == 'XR') { v = ($('#ddlXRATEDT').length > 0 && $('#ddlXRATEDT').val() != '') ? $('#ddlXRATEDT').val().split('_') : _zw.V.stdinfo['xrate']; }
        else if (cls == 'SP') { v = ($('#ddlSTDPAYDT').length > 0 && $('#ddlSTDPAYDT').val() != '') ? $('#ddlSTDPAYDT').val().split('_') : _zw.V.stdinfo['stdpay']; }
        else if (cls == 'OP') { v = ($('#ddlOUTPAYDT').length > 0 && $('#ddlOUTPAYDT').val() != '') ? $('#ddlOUTPAYDT').val().split('_') : _zw.V.stdinfo['outpay']; }

        id = v[0];

        if (id != '') {
            $.ajax({
                type: "POST",
                url: "/ExS/CE/SimpleView",
                data: '{M:"' + cls + '",ri:"' + id + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        var p = $('#popBlank'); p.html(res.substr(2));
                        p.on('hidden.bs.modal', function () { p.html(''); });
                        p.modal();

                    }  else bootbox.alert(res);
                },
                beforeSend: function () { } //로딩 X
            });
        }
    }

    _zw.fn.modalERP = function (req, page, s) {
        if (req == 'model' && $('#ddlCORP').val() == '') { bootbox.alert('[생산지]를 선택하십시오!', function () { $('#ddlCORP').focus(); }); return false; }
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
                    var p = $('#popBlank'); p.html(res.substr(2));
                    var searchBtn = p.find('.modal-header .input-group .btn');
                    var searchTxt = $('.modal-header .input-group :text');

                    searchTxt.keyup(function (e) { if (e.which == 13) { searchBtn.click(); } });
                    searchBtn.click(function () {
                        var sReq = $(".modal-header :hidden[data-zf-field='modal_req']").val();
                        var pg = $('.modal-header :hidden[data-zf-field="modal_page"]');
                        var iPage = pg.length > 0 ? pg.val() : 1;

                        var v = null;
                        if (sReq == 'itemno') {
                            v = [$(".modal-header :hidden[data-zf-field='modal_rowkey']").val(), $(".modal-header :hidden[data-zf-field='modal_param1']").val()];
                        } else if (sReq == 'vendor') {
                            v = [$(".modal-header :hidden[data-zf-field='modal_rowkey']").val()];
                        }

                        _zw.fn.modalERP(sReq, iPage, $(".modal-header input[data-zf-field='modal_searchtext']").val(), v);
                    });

                    p.find('.zf-modal-page .btn[data-for]').click(function () {
                        p.find('.modal-header :hidden[data-zf-field="modal_page"]').val($(this).attr('data-for'));
                        searchBtn.click();
                    });

                    p.find('.modal-body table a.z-lnk-navy').click(function () {
                        var sReq = $(".modal-header :hidden[data-zf-field='modal_req']").val();
                        if (sReq == 'model') {
                            //모델명 기존 견적표와 중복 체크
                            var res = _zw.ut.ajaxSync("/ExS/CE/CheckDuplModel", '{model:"' + $(this).text() + '",appid:"' + _zw.V.appid + '"}');
                            if (res.substr(0, 2) == "OK") { }
                            else if (res.substr(0, 2) == 'NO') { if (!window.confirm(res.substr(2) + '\n\r' + '계속하시겠습니까?')) { return false; } }
                            else bootbox.alert(res);

                            $('input[data-zf-ftype="MAINFIELD"][data-zf-field="MODEL"]').val($(this).text());
                            $('input[data-zf-ftype="MAINFIELD"][data-zf-field="MODELNM"]').val($(this).parent().next().text().split('.')[0]);

                            //BOM 가져오기
                            _zw.fn.getModelBOM($('input[data-zf-field="CORPID"]').val(), $(this).text());

                        } else if (sReq == 'submodel') {
                            $('input[data-zf-ftype="MAINFIELD"][data-zf-field="SUBMODEL"]').val($(this).text());

                        } else if (sReq == 'itemno') {
                            var rowKey = $(".modal-header :hidden[data-zf-field='modal_rowkey']").val();
                            var desc = $(this).parent().next().next().text()
                            var idx = desc.indexOf('.');

                            //기존값과 비교 20-10-20
                            if (_zw.G.getValue(rowKey, 'ITEMNO') != $(this).text() || _zw.G.getValue(rowKey, 'ITEMID') != $(this).parent().next().text()) {
                                _zw.G.setValue(rowKey, 'IID', '');
                            }

                            _zw.G.setValue(rowKey, 'ITEMNO', $(this).text());
                            _zw.G.setValue(rowKey, 'ITEMID', $(this).parent().next().text());
                            _zw.G.setValue(rowKey, 'ITEMNM', idx < 0 ? desc : desc.substr(0, idx));
                            _zw.G.setValue(rowKey, 'STDDESC', idx < 0 ? '' : desc.substr(idx + 1));

                            _zw.fn.getUnitPrice(rowKey, $('input[data-zf-field="CORPID"]').val(), _zw.G.getValue(rowKey, 'ITEMID'), _zw.G.getValue(rowKey, 'VENDORCODE'));

                        } else if (sReq == 'vendor') {
                            var rowKey = $(".modal-header :hidden[data-zf-field='modal_rowkey']").val();

                            _zw.G.setValue(rowKey, 'VENDOR', $(this).text());
                            _zw.G.setValue(rowKey, 'VENDORID', $(this).parent().next().text());
                            _zw.G.setValue(rowKey, 'VENDORCODE', $(this).parent().next().next().text());

                            _zw.fn.getUnitPrice(rowKey, $('input[data-zf-field="CORPID"]').val(), _zw.G.getValue(rowKey, 'ITEMID'), _zw.G.getValue(rowKey, 'VENDORCODE'));

                        } else if (sReq == 'vendor_unit_price') {
                            var rowKey = $(".modal-header :hidden[data-zf-field='modal_rowkey']").val();

                            _zw.G.setValue(rowKey, 'VENDOR', $(this).text());
                            _zw.G.setValue(rowKey, 'CURRENCY', $(this).parent().next().text());
                            _zw.G.setValue(rowKey, 'PRICE', numeral($(this).parent().next().next().text()).format('0,0.0000'));
                            _zw.G.setValue(rowKey, 'USDEX', $(this).parent().next().text() == 'USD' ? '1.0000' : numeral(_zw.V.stdRate['USD_' + $(this).parent().next().text()]).format('0,0.0000'));

                            if ($(this).parent().next().next().text() != null && $(this).parent().next().next().text() != '') _zw.G.setValue(rowKey, 'DESC', 'ERP 단가');
                        }

                        p.modal('hide');
                    });
                    
                    p.on('hidden.bs.modal', function () { p.html(''); });
                    p.modal();

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

    _zw.fn.getVendorUnitPrice = function (req, idx, p1, p2) {
        if (p1 && p1 != '' && p2 && p2 != '' && req && req != '') {
            $.ajax({
                type: "POST",
                url: "/ExS/CE/VendorUnitPrice", //getvendorunitprice
                data: '{req:"' + req + '",rowkey:"' + idx + '",orgid:"' + p1 + '",itemno:"' + p2 + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        var p = $('#popBlank'); p.html(res.substr(2));
                        p.find('.modal-body table a.z-lnk-navy').click(function () {
                            _zw.G.setValue(idx, 'VENDOR', $(this).text());
                            _zw.G.setValue(idx, 'CURRENCY', $(this).parent().next().text());
                            _zw.G.setValue(idx, 'PRICE', numeral($(this).parent().next().next().text()).format('0,0.0000'));
                            _zw.G.setValue(idx, 'USDEX', $(this).parent().next().text() == 'USD' ? '1.0000' : numeral(_zw.V.stdRate['USD_' + $(this).parent().next().text()]).format('0,0.0000'));

                            if ($(this).parent().next().next().text() != null && $(this).parent().next().next().text() != '') _zw.G.setValue(idx, 'DESC', 'ERP 단가');

                            p.modal('hide');
                        });

                        p.on('hidden.bs.modal', function () { p.html(''); });
                        p.modal();

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
                    var p = $('#popBlank'); p.html(res.substr(2));

                    p.find('thead input[name="ckbAll"]').on('click', function () {
                        var b = $(this).prop('checked')
                        p.find('tbody input[name="ckbRow"]').each(function () {
                            $(this).prop('checked', b);
                        });
                    });

                    p.find('.modal-footer .btn[data-zm-menu="apply"]').on('click', function () {
                        p.find('tbody input[name="ckbRow"]:checked').each(function (idx) {
                            var cell = $(this).parent().parent(); console.log(idx + " : " + cell.next().next().text())
                            var rows = _zw.G.findRows({
                                //'ITEMID': $(this).val(),
                                'ITEMNO': cell.next().next().text()
                            });
                            if (rows.length > 0) {
                                //if (window.confirm('품목 [' + $(this).parent().next().text() + '](이)가 이미 존재합니다. 덮어씌우겠습니까?')) {
                                _zw.G.setValue(rows[0].rowKey, 'ITEMID', $(this).val());
                                _zw.G.setValue(rows[0].rowKey, 'ITEMNO', cell.next().next().text());
                                _zw.G.setValue(rows[0].rowKey, 'ITEMNM', cell.next().next().next().text());
                                if ($.trim(cell.next().next().next().next().text()) != '') _zw.G.setValue(rows[0].rowKey, 'STDDESC', cell.next().next().next().next().text());

                                _zw.G.setValue(rows[0].rowKey, 'DESC', rows.length + '개 중복');
                                //}
                            } else {
                                _zw.G.appendRow({
                                    'ITEMID': $(this).val(),
                                    'ITEMNO': cell.next().next().text(),
                                    'ITEMNM': cell.next().next().next().text(),
                                    'STDDESC': cell.next().next().next().next().text()
                                });
                            }
                        });

                        _zw.fn.calcGridRow();
                    });

                    p.on('hidden.bs.modal', function () { p.html(''); });
                    p.modal();

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

        if (_zw.V.ft.toLowerCase() == "grid") {
            m = ["XCLS;구분", "CORP;생산지", "MODEL;모델번호", "ITEMCLS;품목분류", "BUYER;BUYER", "BUYERCLS;BUYER분류", "SUBJECT;시트명"];

            //if (_ZF.V.rptMode > 2) {//if (pos == 'grid') {
            for (var i in m) {
                var v = m[i].split(';');
                var f = $('[data-zf-ftype="MAINFIELD"][data-zf-field="' + v[0] + '"]');
                if (f.val() == '') {
                    if (v[0] == 'SUBJECT') { if (pos != 'grid') { bootbox.alert("필수항목[" + v[1] + "] 입력 누락!", function () { f.focus(); }); return false; } }
                    else { bootbox.alert("필수항목[" + v[1] + "] 입력 누락!", function () { f.focus(); }); return false; }
                }
            }
            //}

            if (_zw.V.calcpay['변동원가'] === undefined) {
                bootbox.alert('기준임율 정보가 없습니다. 확인하기 바랍니다!'); return false;
            }

            if (pos != 'grid') {
                var g = ["CLSCD;부문코드", "ITEMNM;부품명", "CURRENCY;통화", "PRICE;단가", "CNT;수량", "SUM;합계", "USDEX;USD환율", "USDSUM;USD금액"];
                for (var i in g) {
                    var v = g[i].split(';');
                    if (_zw.G.getValue(0, v[0]) == null || _zw.G.getValue(0, v[0]) == '') {
                        bootbox.alert("품목표 첫줄 [" + v[1] + "] 항목은 필수 입니다!"); return false;
                    }
                }

                if ($('[data-zf-ftype="MAINFIELD"][data-zf-field="XCLS"]').val() == '회로' || $('[data-zf-ftype="MAINFIELD"][data-zf-field="XCLS"]').val() == '음향') {
                    if ($('[data-zf-ftype="MAINFIELD"][data-zf-field="SUBMODEL"]').val() == '') {
                        bootbox.alert('"' + $('[data-zf-ftype="MAINFIELD"][data-zf-field="XCLS"]').val() + '" 선택 경우 [품목번호] 입력은 필수입니다!', function () { $('[data-zf-ftype="MAINFIELD"][data-zf-field="SUBMODEL"]').focus(); }); return false;
                    }
                }

                if (_zw.V.mode == 'reuse' || _zw.V.mode == 'renew') {
                    if ($('[data-zf-ftype="MAINFIELD"][data-zf-field="DSCPT"]').val() == '') {
                        bootbox.alert('재사용 또는 개정 경우 [특기사항] 입력은 필수입니다!', function () { _zw.mu.showGridDscpt(); }); return false;
                    }
                }
            }

        } else if (_zw.V.ft.toLowerCase() == "stdexchangedetail" || _zw.V.ft.toLowerCase() == "stdpaydetail" || _zw.V.ft.toLowerCase() == "outpaydetail") {
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
        var s = '<div class="modal-dialog modal-sm">'
            + '<div class="modal-content" data-for="grid-row-desc">'
            + '<div class="modal-header">'
            + '<h4 class="modal-title">산출내역</h4>'
            + '<button type="button" class="close" data-dismiss="modal"><span>×</span></button>'
            + '</div>'
            + '<div class="modal-body p-3">'
            //+ '<input type="hidden" data-zf-field="modal_req" value="' + req + '" />'
            //+ '<input type="hidden" data-zf-field="modal_rowkey" value="' + rowKey + '" />'
            + '<table class="table table-striped mb-0">'
            + '<tbody>'
            + '<tr><td style="width: 80%">ERP 단가</td><td><button type="button" class="btn btn-success btn-sm"><i class="fas fa-check"></i></button></td></tr>'
            + '<tr><td>개발구매 입수단가</td><td><button type="button" class="btn btn-success btn-sm"><i class="fas fa-check"></i></button></td></tr>'
            + '<tr><td>설계 계산단가</td><td><button type="button" class="btn btn-success btn-sm"><i class="fas fa-check"></i></button></td></tr>'
            + '<tr><td>업체 견적단가</td><td><button type="button" class="btn btn-success btn-sm"><i class="fas fa-check"></i></button></td></tr>'
            + '<tr><td><input type="text" class="form-control modal-inline-input" /></td><td><button type="button" class="btn btn-success btn-sm"><i class="fas fa-check"></i></button></td></tr>'
            + '</tbody>'
            + '</table>'
            + '</div>'
            + '<div class="modal-footer">'
            + '<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>'
            + '</div></div></div>';

        var p = $('#popBlank'); p.html(s);
        p.find(".modal-body table .btn").click(function () {
            //var sReq = p.find(".modal-body :hidden[data-zf-field='modal_req']").val(), rowKey = p.find(".modal-body :hidden[data-zf-field='modal_rowkey']").val();
            var c = $(this).parent().prev(), v = c.find('input').val() || c.text(); //alert(sReq + " : " + rowKey + " : " + v)

            _zw.G.setValue(rowKey, req, v);
            p.modal('hide');
        });

        p.on('hidden.bs.modal', function () { p.html(''); });
        p.modal();
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
            },
            beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
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
        var postData = _zw.fn.getLvQuery(); //console.log(postData)
        var url = '?qi=' + encodeURIComponent(_zw.base64.encode(postData));

        $.ajax({
            type: "POST",
            url: url,
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    history.pushState(null, null, url);

                    $('#__List').html(res.substr(2));

                    _zw.fn.bindCtrl();

                } else bootbox.alert(res);
            }
        });
    }
    
    _zw.fn.getLvQuery = function (m) {
        var j = {}; m = m || '';
        j["M"] = m;
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

    _zw.fn.calcGridRow = function () {
        $('span[data-for="_rowCount"]').text('(' + _zw.G.getRowCount() + '행)');
        var v = $('select[data-zf-field="XCLS"]').val();
        if (v !== undefined && (v == '기구' || v == '회로' || v == '음향')) {
            for (var x = 0; x < _zw.G.getRowCount(); x++) {
                var cv = _zw.G.getValue(x, 'CLS');
                if (cv == null || cv == '') _zw.G.setValue(x, 'CLS', v);
            }
        }
    }

    _zw.fn.bindCtrl();
});