//집계, 대장 리스트뷰

$(function () {

    $('#__LeftMenu .sidenav-toggle').click(function (e) {
        e.preventDefault();

        $(this).next().slideToggle(300, function () {
            $(this).parent().toggleClass('open');
        });
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
        var url = '?qi=' + _zw.base64.encode(postData);

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
        //j["ttl"] = _zw.V.ttl;

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