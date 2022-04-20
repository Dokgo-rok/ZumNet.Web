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

    $('.pagination li a.page-link').click(function () {
        _zw.fn.goSearch($(this).attr('data-for'));
    });

    _zw.mu.exportExcel = function () {
        var d = $('#_SearchYear').val() + ($('#_SearchMonth').val().length < 2 ? '0' + $('#_SearchMonth').val() : $('#_SearchMonth').val());
        var data = "tgt=" + $('#_Target').val() + "&tgtnm=" + escape($('#_Target').children('option:selected').text()) + "&vd=" + d + "&sch=&page=&sortcol=&dir=";

        $('#hhdSearch').val(data);
        aspnetForm.action = "?M=xls";
        aspnetForm.submit();
    }

    _zw.mu.importExcel = function () {
        //var url = "/" + _ZF.V.root + "/EA/External/FileImport.aspx?M=MC_SUMMARY&cd=ce";
        //_zw.ut.openWnd(url, "fileImport", 400, 100, "fix")
    }

    _zw.mu.saveStd = function (t) {
        var pos = t ? t.attr('data-zf-menu').toLowerCase() : '';
        var ckValid = true;
        if (pos != 'savetemp') ckValid = _zw.fn.validate();

        if (ckValid) {
            var d = {};

            $('[data-zf-field]').each(function () {
                d[$(this).attr('data-zf-field').toLowerCase()] = $(this).val();
            });

            if (_zw.V.ft.toLowerCase() == "stdpaydetail") {
                var v = [];
                $('.card[data-zf-code]').each(function () {
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
            }

            var msg = pos == 'savetemp' ? '임시저장 하시겠습니까?' : '저장 하시겠습니까?';

            d["M"] = _zw.V.mode == 'add' ? 'new' : _zw.V.mode; //== 'new' && (_ZF.V.appid == '' || _ZF.V.appid == '0') ? "new" : "edit";
            d["appid"] = _zw.V.appid;
            d["ft"] = _zw.V.ft;
            d["istemp"] = pos == 'savetemp' ? 'Y' : 'N';

            //console.log(d["subtable"]); return;

            bootbox.confirm(msg, function (rt) {
                if (rt) {
                    $.ajax({
                        type: "POST",
                        url: "/ExS/MC/SaveStdPay",
                        data: JSON.stringify(d),
                        success: function (res) {
                            if (res.substr(0, 2) == "OK") {
                                bootbox.alert("저장했습니다!", function () { _zw.fn.viewStdPay(res.substr(2)); });
                            } else bootbox.alert(res);
                        }
                    });
                }
            });
        }
    }

    _zw.mu.deleteStd = function (t) {
        if (_zw.V.appid == '' || _zw.V.appid == '0') return false;

        bootbox.confirm("삭제 하시겠습니까?", function (rt) {
            if (rt) {
                $.ajax({
                    type: "POST",
                    url: "/ExS/MC/SetStdPay",
                    data: '{M:"D",appid:"' + _zw.V.appid + '",ft:"' + _zw.V.ft + '"}',
                    success: function (res) {
                        if (res.substr(0, 2) == "OK") {
                            bootbox.alert(res.substr(2), function () { _zw.fn.viewMCPage('StdPay') });
                        } else bootbox.alert(res);
                    }
                });
            }
        });
    }

    _zw.mu.reqApproval = function (t) {
        var ft = '', tp = '', sj = '', k1 = '', k2 = '';

        if (!window.confirm("결재요청 하시겠습니까?\n\r\n\r처리 중 화면을 새로고침 하지 마십시오!")) return false;

        _zw.ut.ajaxLoader(true, '양식 준비중 입니다');

        if (_zw.V.ft.toLowerCase() == 'stdpaydetail') {
            ft = 'DRAFT'; tp = 'CE'; k1 = 'MCSTDPAY'; k2 = _zw.V.appid;
            var dt = new Date($('input[data-zf-field="STDDT"]').val());
            sj = dt.getFullYear() + "년 모델별 실적원가율 " + $('[data-zf-field="XCLS"]').val() + "의 건";

            var s = '';
            $('.card[data-zf-code]').each(function () {
                if ($(this).find('input:checkbox').prop('checked')) {
                    var c = $(this).find('.card-body').clone();
                    var t = c.find('.z-grid');
                    t.removeClass('z-grid z-grid-bordered').attr({ 'cellpadding': '4px', 'cellspacing': '0', 'border': '0' }).css({ 'font-size': '13px', 'width': '1040px', 'border-top': '2px solid #666', 'border-left': '2px solid #666', 'border-right': '1px solid #666', 'border-bottom': '1px solid #666', 'text-align': 'center' });
                    t.find('colgroup').remove();

                    t.find('thead th').css('background-color', '#dff0d8');
                    t.find('th, td').removeClass('cell-read cell-input').css({ 'width': '80px', 'border-right': '1px solid #666', 'border-bottom': '1px solid #666' });
                    t.find('input:text').each(function () {
                        //$(this).parent().html($(this).val() == '' ? '&nbsp;' : $(this).val());
                        if ($(this).val() == '' || parseFloat($(this).val().replace('%', '')) == 0) $(this).parent().html('&nbsp;');
                        else $(this).parent().html($(this).val());
                    });
                    s += '<div style="margin-bottom: 20px"><div style="padding-left: 8px; margin-bottom: 6px; font-weight: 700">- ' + $(this).find('.card-header a').text() + '</div><div>' + c.html() + '</div></div>';
                }
            });

            $('#_HiddenForm .p-first').html(dt.getFullYear() + "년 " + $('#_HiddenForm .p-first').html());
            $('#_HiddenForm .p-second').html($('#_HiddenForm .p-second').html() + dt.getFullYear() + "년 " + (dt.getMonth() + 1) + "월부터 적용")

            $('#_HiddenForm .p-html').html(s); //console.log($('#_HiddenForm').html())
            $('#_HiddenFormData').val($('#_HiddenForm').html());
        }

        var qi = {};
        qi['M'] = 'new'; qi['xf'] = 'ea'; qi['fi'] = ''; qi['Tp'] = tp; qi['ft'] = ft; qi['k1'] = k1; qi['k2'] = k2; qi['sj'] = sj;
        var url = '/EA/Form?qi=' + encodeURIComponent(_zw.base64.encode(JSON.stringify(qi)));
        _zw.ut.openWnd(url, "", 800, 600, "resize");
    }

    _zw.fn.viewListItem = function (f, fld, model, t, sub) {
        var j = '', url = ''
        var d = $('#_SearchYear').val() + _zw.ut.zero($('#_SearchMonth').val());
        fld = fld || '';

        if (f == 'D') {
            url = '/ExS/MC/StdTimeDay'; d += _zw.ut.zero(t);
            j = '{cmd:"' + f + '",tgt:"' + $('#_Target').val() + '",vd:"' + d + '",model:"' + model + '"}';
        } else {
            url = '/ExS/MC/ListItem';
            j = '{cmd:"' + f + '",tgt:"' + $('#_Target').val() + '",fld:"' + fld + '",vd:"' + d + '",lvl:"' + t + '",model:"' + model + '",item:"' + sub + '"}';

            if (f == 'S' && fld == 'PCCOST') { bootbox.alert('준비중'); return false; }
        }

        if (url != '') {
            $.ajax({
                type: "POST",
                url: url,
                data: j,
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        var p = $('#popLayer');
                        p.html(res.substr(2));

                        p.find('button[data-btn]').click(function () {
                            if ($(this).attr('data-btn') == 'excel') {
                                var ttl = $(this).parent().parent().prev().prev().find('.modal-title').text();
                                //console.log(idx + ' : ' + parseInt($(this).find('td:first span').css('width')).toString())

                                var c = $(this).parent().parent().prev().clone();
                                c.find('thead tr th br').remove();
                                c.find('tbody tr').each(function (idx) {
                                    var txt = '';
                                    for (var k = 1; k < parseInt($(this).attr('lvl')); k++) txt += '&nbsp;&nbsp;&nbsp;&nbsp;';
                                    txt += $(this).find('td:first').text();
                                    $(this).find('td:first').html(txt)
                                });

                                $('#hhdTitle').val(ttl);
                                $('#hhdTable').val(c.html());
                                _HiddenForm.action = "?M=xls_modal";
                                //_HiddenForm.submit();
                                bootbox.alert('준비중!')

                            } else if ($(this).attr('data-btn') == 'unfold') {
                                _zw.fn.viewListItemChild(true, '+');
                            } else if ($(this).attr('data-btn') == 'fold') {
                                _zw.fn.viewListItemChild(true, '-');
                            }

                        });

                        p.modal();

                    } else bootbox.alert(res)
                }
            });
        }
    }

    _zw.fn.viewListItemChild = function (batch, dir) {
        var v = $('.modal-header input[type="hidden"]'), el, row, p;
        if (v.length > 0) {
            v = v.val().split('^');

            if (batch) {
                p = $('.modal-body tbody');
                var iMaxLvl = 10;

                if (dir == '+') {
                    //var d = new Date()
                    //console.log('start => ' + d.getMinutes() + ':' + d.getSeconds() + '.' + d.getMilliseconds())
                    for (var i = 1; i <= iMaxLvl; i++) {
                        if (p.find('tr[lvl="' + i + '"]').length > 0) {
                            p.find('tr[lvl="' + i + '"]').each(function () {
                                row = $(this);
                                el = $(this).find('.btn[aria-expanded]');

                                if (el.attr('aria-expanded') == 'false') {
                                    $.ajax({
                                        type: "POST",
                                        url: "/ExS/MC/ListItem",
                                        data: '{cmd:"' + v[0] + '",tgt:"' + v[1] + '",fld:"' + v[3] + '",vd:"' + v[2] + '",lvl:"' + (parseInt(row.attr('lvl')) + 1) + '",model:"' + v[4] + '",item:"' + el.val() + '"}',
                                        async: false,
                                        success: function (res) {
                                            if (res.substr(0, 2) == 'OK') {
                                                s = res.substr(2);

                                                if (s != '') {
                                                    $(s).insertAfter(row);

                                                    el.attr('aria-expanded', 'true');
                                                    el.find('i').removeClass('fa-plus').addClass('fa-minus');
                                                }

                                            } else if (res.substr(0, 2) == 'NE') { //하위 x
                                                var prev = el.prev(); el.remove(); $(res.substr(2)).insertAfter(prev);

                                            } //else alert(res);
                                        }
                                    });
                                }
                            });
                        } else {
                            break;
                        }
                    }
                } else {
                    p.find('tr').each(function () {
                        if ($(this).attr('lvl') > 1) {
                            $(this).remove();
                        } else {
                            el = $(this).find('.btn[aria-expanded]');
                            el.attr('aria-expanded', 'false');
                            el.find('i').removeClass('fa-minus').addClass('fa-plus');
                        }
                    });
                }
            } else {
                el = _zw.ut.eventBtn(), row = el.parent().parent(), p = row.parent().parent();
                if (el.attr('aria-expanded') == 'false') {
                    var s = '';
                    $.ajax({
                        type: "POST",
                        url: "/ExS/MC/ListItem",
                        data: '{cmd:"' + v[0] + '",tgt:"' + v[1] + '",fld:"' + v[3] + '",vd:"' + v[2] + '",lvl:"' + (parseInt(row.attr('lvl')) + 1) + '",model:"' + v[4] + '",item:"' + el.val() + '"}',
                        async: false,
                        success: function (res) {
                            if (res.substr(0, 2) == 'OK') {
                                s = res.substr(2);

                            } else if (res.substr(0, 2) == 'NE') { //하위 x
                                var prev = el.prev(); el.remove(); $(res.substr(2)).insertAfter(prev);

                            } else bootbox.alert(res);
                        }
                    });

                    if (s != '') {
                        $(s).insertAfter(row);

                        el.attr('aria-expanded', 'true');
                        el.find('i').removeClass('fa-plus').addClass('fa-minus');
                    }
                } else {
                    p.find('tbody tr').each(function () {
                        if ($(this).prop('rowIndex') > row.prop('rowIndex')) {
                            if ($(this).attr('lvl') > row.attr('lvl')) {
                                $(this).remove();
                            } else {
                                return false;
                            }
                        }
                    });

                    el.attr('aria-expanded', 'false');
                    el.find('i').removeClass('fa-minus').addClass('fa-plus');
                }
            }
        }
    }

    _zw.fn.viewMCPage = function (page) {
        var qi = '{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ttl:"",opnode:"",ft:"' + page + '"}';
        window.location.href = '/ExS/MC?qi=' + _zw.base64.encode(qi);
    }

    _zw.fn.viewStdPay = function (id) {
        var page = 'StdPayDetail';
        var qi = '{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ttl:"",opnode:"",ft:"' + page + '",appid:"' + id + '"}';
        window.location.href = '/ExS/MC?qi=' + _zw.base64.encode(qi);
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
        })
    }

    _zw.fn.validate = function (pos) {
        var m, s;

        if (_zw.V.ft.toLowerCase() == "stdpaydetail") {
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

    _zw.fn.sort = function (col) {
        var el = event.target ? event.target : event.srcElement;
        var dir = $(el).find('i').hasClass('fe-arrow-up') ? 'DESC' : 'ASC';
        _zw.fn.goSearch(null, col, dir);
    }

    _zw.fn.goSearch = function (page, sort, dir) {//lert(1)
        _zw.fn.initLv($('#_Target').val());

        sort = sort || ''; dir = dir || '';
        _zw.V.lv.sort = sort;
        _zw.V.lv.sortdir = dir;

        _zw.V.lv.page = (page) ? page : 1;
        _zw.V.lv.start = $('#_SearchYear').val() + _zw.ut.zero($('#_SearchMonth').val());

        var e = $('.z-lv-cond input.search-text');
        if (e.length > 0) {
            var s = "['\\%^&\"*]";
            var reg = new RegExp(s, 'g');
            if (e.val().search(reg) >= 0) { alert(s + " 문자는 사용될 수 없습니다!"); e.val(''); return; }

            if ($.trim(e.val()) != '') {
                _zw.V.lv.search = 'MODELCODE'; //모델
                _zw.V.lv.searchtext = e.val();
            }
        }

        _zw.V.lv.cd1 = $('#_Cond1').val(); _zw.V.lv.cd2 = $('#_Cond2').val(); _zw.V.lv.cd3 = $('input[name="rdoSearch"]:checked').val();

        _zw.fn.loadList();
    }

    _zw.fn.loadList = function () {
        var postData = _zw.fn.getLvQuery(true); //console.log(postData)
        var url = '?qi=' + encodeURIComponent(_zw.base64.encode(postData));

        $.ajax({
            type: "POST",
            url: url,
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    history.pushState(null, null, url);

                    var v = res.substr(2).split(_zw.V.lv.boundary); //console.log(JSON.parse(JSON.stringify($.trim(v[0]))))
                    $('#__List').html(v[0]);
                    $('#__ListCount').html(v[1]);
                    $('#__ListPage').html(v[2]);

                    $('.pagination li a.page-link').click(function () {
                        _zw.fn.goSearch($(this).attr('data-for'));
                    });

                    $('.z-lv-cnt select').change(function () {
                        _zw.fn.setLvCnt($(this).val());
                    });

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

        j["cd1"] = _zw.V.lv.cd1; j["cd2"] = _zw.V.lv.cd2; j["cd3"] = _zw.V.lv.cd3; //j["cd4"] = _zw.V.lv.cd4; j["cd5"] = _zw.V.lv.cd5; j["cd6"] = _zw.V.lv.cd6;
        //j["cd7"] = _zw.V.lv.cd7; j["cd8"] = _zw.V.lv.cd8; j["cd9"] = _zw.V.lv.cd9; j["cd10"] = _zw.V.lv.cd10; j["cd11"] = _zw.V.lv.cd11; j["cd12"] = _zw.V.lv.cd12;

        return JSON.stringify(j);
    }

    _zw.fn.initLv = function (tgt) {
        var sCnt = _zw.ut.getCookie('costLvCount');
        if ($('.z-list-page select').length > 0) sCnt = $('.z-list-page select').val();

        _zw.V.lv.tgt = tgt;
        _zw.V.lv.page = '1';
        _zw.V.lv.count = sCnt == '' ? '7' : sCnt;
        _zw.V.lv.sort = '';
        _zw.V.lv.sortdir = '';
        _zw.V.lv.search = '';
        _zw.V.lv.searchtext = '';
        _zw.V.lv.start = '';
        _zw.V.lv.end = '';
        _zw.V.lv.basesort = '';

        _zw.V.lv.cd1 = ''; _zw.V.lv.cd2 = ''; _zw.V.lv.cd3 = ''; //_zw.V.lv.cd4 = ''; _zw.V.lv.cd5 = ''; _zw.V.lv.cd6 = '';
        //_zw.V.lv.cd7 = ''; _zw.V.lv.cd8 = ''; _zw.V.lv.cd9 = ''; _zw.V.lv.cd10 = ''; _zw.V.lv.cd11 = ''; _zw.V.lv.cd12 = '';
    }
});