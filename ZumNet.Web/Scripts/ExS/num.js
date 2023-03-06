//집계, 대장 리스트뷰

$(function () {

    _zw.fn.bindCtrl = function () {
        $('[data-zv-menu="search"]').click(function () {
            _zw.fn.goSearch();
        });

        $('#_SearchText').keyup(function (e) {
            if (e.which == 13) _zw.fn.goSearch();
        });

        $('.pagination li a.page-link').click(function () {
            _zw.fn.goSearch($(this).attr('data-for'));
        });
    };

    _zw.fn.exportExcel = function () {
        var postData = _zw.fn.getLvQuery('xls'); console.log(postData)
        window.open('?qi=' + encodeURIComponent(_zw.base64.encode(postData)), 'ifrView');
        //window.open('?qi=' + encodeURIComponent(_zw.base64.encode(postData)));
    }

    _zw.fn.openSheet = function () {
        var el = _zw.ut.eventBtn();
        if (_zw.V.ft == 'NUM_ME') {
            var w = window.screen.width, h = window.screen.height;
            w = w >= 1600 ? parseInt(w * 0.85) : w; h = h >= 900 ? parseInt(h * 0.85) : h;
            var encQi = _zw.base64.encode('{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + _zw.V.ot + '",alias:"' + _zw.V.alias + '",xfalias:"' + _zw.V.xfalias + '",fdid:"' + _zw.V.fdid + '",opnode:"' + _zw.V.opnode + '",ft:"' + _zw.V.ft + '",ttl:"",acl:"' + _zw.V.current.acl + '"}');
            _zw.ut.openWnd('/ExS/Num/Sheet?qi=' + encQi, 'NumSheet', w, h, 'resize');

        } else {
            var j = { "close": true, "width": 600, "height": 250, "left": -40, "top": 0 }
            j["content"] = $('.zf-num-template').html();
            j["footer"] = '<button type="button" class="btn btn-primary mr-1" data-zm-menu="confirm">저장</button><button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>';

            var pop = _zw.ut.popup(el[0], j);
            pop.find('.z-pop-footer .btn[data-dismiss="modal"]').click(function () { $('.modal-backdrop').remove(); pop.remove(); });

            pop.find('.z-pop-body table tr[data-for="num"] input[data-for]').css('cursor', 'pointer').click(function () {
                var tgt = $(this), attr = tgt.attr('data-for').split(';');
                var jc = { "close": true, "width": 300, "height": parseInt(attr[1]), "left": 0, "top": 0 };
                jc["content"] = $('.zf-numcode-template[data-for="' + attr[0] + '"]').html();

                var pc = _zw.ut.popup(tgt[0], jc);
                pc.find('a[data-val]').click(function () {
                    var v = $(this).attr('data-val'); tgt.val(v);
                    if (_zw.V.ft == 'NUM_WI' && attr[0] == 'color') {
                        var sPartNo = '', pos = null;
                        tgt.parent().parent().find('input').each(function (idx) {
                            sPartNo += $.trim($(this).val());
                            if (idx == 8) pos = $(this);
                        });
                        $.post("/ExS/Num/LastNum", '{"ft":"' + _zw.V.ft + '","part":"' + sPartNo.substr(0, 8) + '"}', function (res) {
                            if (res.substr(0, 2) == 'OK') pos.val(res.substr(2));
                            else bootbox.alert(res);
                            pc.find('.close[data-dismiss="modal"]').click();
                        });
                    } else pc.find('.close[data-dismiss="modal"]').click();
                });
            });

            pop.find('.z-pop-footer .btn[data-zm-menu="confirm"]').click(function () {
                var sPartNo = '';
                pop.find('.z-pop-body table tr[data-for="num"] td input').each(function () {
                    sPartNo += $.trim($(this).val());
                });
                if ((_zw.V.ft == 'NUM_WI' && sPartNo.length != 15)
                    || (_zw.V.ft == 'NUM_PG' && sPartNo.length < 12)
                    || (_zw.V.ft == 'NUM_BT' && sPartNo.length != 16)) {
                    bootbox.alert("채번오류 : 미입력 번호가 있습니다"); return false;
                } else {
                    var postData = {};
                    postData['ft'] = _zw.V.ft;
                    postData['part'] = sPartNo;
                    postData['ur'] = _zw.V.current.user;
                    postData['urid'] = _zw.V.current.urid;
                    postData['dept'] = _zw.V.current.dept;
                    postData['deptid'] = _zw.V.current.deptid;
                    postData['model'] = pop.find('.z-pop-body table tr td input[data-column="MODEL"]').val();
                    postData['item'] = pop.find('.z-pop-body table tr td input[data-column="ITEM"]').val();
                    postData['etc'] = pop.find('.z-pop-body table tr td input[data-column="ETC"]').val();

                    $.post("/ExS/Num/SetNum", JSON.stringify(postData), function (res) {
                        if (res.substr(0, 2) == 'OK') {
                            bootbox.alert(res.substr(2));
                            pop.find('.close[data-dismiss="modal"]').click();
                        } else bootbox.alert(res);
                    });
                }
            });

            _zw.fn.input(pop);
        }
    }

    _zw.fn.bindCtrl();

    _zw.fn.loadList = function () {
        var postData = _zw.fn.getLvQuery(''); console.log(postData);
        var url = '?qi=' + encodeURIComponent(_zw.base64.encode(postData));

        $.ajax({
            type: "POST",
            url: url,
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    history.pushState(null, null, url);

                    window.document.title = _zw.V.ttl;
                    $('.z-ttl span').html(_zw.V.ttl);

                    var v = res.substr(2).split(_zw.V.lv.boundary);
                    $('#__List').html(v[0]);
                    $('.z-list-menu').html(v[1]);
                    $('#__ListPage').html(v[2]);

                    _zw.fn.bindCtrl();

                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.sort = function (col) {
        var t = $(event.target); sortCol = t.attr('data-val'), sortDir = '';

        t.parent().parent().find('a[data-val]').each(function () {
            if ($(this).attr('data-val') == sortCol) {
                var c = $(this).find('i');
                if (c.hasClass('fe-arrow-up')) {
                    c.removeClass('fe-arrow-up').addClass('fe-arrow-down'); sortDir = 'DESC';
                } else {
                    c.removeClass('fe-arrow-down').addClass('fe-arrow-up'); sortDir = 'ASC';
                }
            } else {
                $(this).find('i').removeClass();
            }
        });

        _zw.fn.goSearch(null, sortCol, sortDir);
    }

    _zw.fn.goSearch = function (page, sort, dir) {
        _zw.fn.initLv(_zw.V.current.urid);

        sort = sort || ''; dir = dir || '';
        _zw.V.lv.sort = sort;
        _zw.V.lv.sortdir = dir;
        _zw.V.lv.page = (page) ? page : 1;

        $('.z-list-cond .z-list-search [data-for]').each(function () {
            if ($.trim($(this).val()) != '') _zw.V.lv[$(this).attr('data-for')] = $(this).val();
        });

        if ($('#_SearchSelect').val() != '' && $('#_SearchText').length > 0) {
            var e = $('#_SearchText');
            var s = "['\\%^&\"*]";
            var reg = new RegExp(s, 'g');
            if (e.val().search(reg) >= 0) { bootbox.alert(s + " 문자는 사용될 수 없습니다!", function () { e.val(''); e.focus(); }); return false; }

            _zw.V.lv.search = $('#_SearchSelect').val();
            _zw.V.lv.searchtext = e.val();
        }

        _zw.fn.loadList();
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

        j["cd1"] = _zw.V.lv.cd1; j["cd2"] = _zw.V.lv.cd2; j["cd3"] = _zw.V.lv.cd3; j["cd4"] = _zw.V.lv.cd4; j["cd5"] = _zw.V.lv.cd5; j["cd6"] = _zw.V.lv.cd6;
        //j["cd7"] = _zw.V.lv.cd7; j["cd8"] = _zw.V.lv.cd8; j["cd9"] = _zw.V.lv.cd9; j["cd10"] = _zw.V.lv.cd10; j["cd11"] = _zw.V.lv.cd11; j["cd12"] = _zw.V.lv.cd12;

        return JSON.stringify(j);
    }

    _zw.fn.initLv = function (tgt) {
        var sCnt = _zw.ut.getCookie('docLvCount');
        if ($('.z-list-page select').length > 0) sCnt = $('.z-list-page select').val();

        _zw.V.lv.tgt = tgt;
        _zw.V.lv.page = '1';
        _zw.V.lv.count = sCnt == '' ? '20' : sCnt;
        _zw.V.lv.sort = '';
        _zw.V.lv.sortdir = '';
        _zw.V.lv.search = '';
        _zw.V.lv.searchtext = '';
        _zw.V.lv.start = '';
        _zw.V.lv.end = '';
        _zw.V.lv.basesort = '';

        _zw.V.lv.cd1 = ''; _zw.V.lv.cd2 = ''; _zw.V.lv.cd3 = ''; _zw.V.lv.cd4 = ''; _zw.V.lv.cd5 = ''; _zw.V.lv.cd6 = '';
        //_zw.V.lv.cd7 = ''; _zw.V.lv.cd8 = ''; _zw.V.lv.cd9 = ''; _zw.V.lv.cd10 = ''; _zw.V.lv.cd11 = ''; _zw.V.lv.cd12 = '';
    }
});