//근무관리 메인, 리스트뷰

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

    $('#_SearchText').keyup(function (e) {
        if (e.which == 13) _zw.fn.goSearch();
    });

    _zw.fn.reqCnt = function () {
        $.ajax({
            type: "POST",
            url: '/ExS/WorkTime/RequestCount',
            data: '{ur:"' + _zw.V.current.urid + '",chief:"' + _zw.V.current.chief + '",mo:"' + _zw.V.current.operator + '"}',
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    var cnt = res.substr(2).split(';');                    
                    $('.sidenav-item .z-lm-cnt').each(function () {
                        if ($(this).attr('data-for') == 'my') $(this).html('(' + cnt[0] + ')');
                        else if ($(this).attr('data-for') == 'member') $(this).html('(' + cnt[1] + ')');
                        else if ($(this).attr('data-for') == 'all') $(this).html('(' + cnt[2] + ')');
                    });

                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.reqCnt();
    
    _zw.fn.loadList = function () {
        var postData = _zw.fn.getLvQuery(true);
        var url = '?qi=' + _zw.base64.encode(postData); //encodeURIComponent(postData);

        $.ajax({
            type: "POST",
            url: url,
            success: function (res) {
                if (res.substr(0, 2) == "OK") {

                    $('#__ListView').html(res.substr(2));

                } else bootbox.alert(res);
            }
        });
    }
    _zw.fn.goSearch = function () {
        _zw.fn.initLv(_zw.V.current.urid);

        if (_zw.V.ft == 'PersonRequest' || _zw.V.ft == 'MemberRequest' || _zw.V.ft == 'RequestMgr') {
            _zw.V.lv.start = $('#_SearchYear').val(); _zw.V.opnode = $('input[name="rdoSearch"]:checked').val();

        } else if (_zw.V.ft == 'WorkTimeMgr') {
            _zw.V.lv.start = $('#_SearchYear').val();

        } else {
            if ($('#_SearchText').length > 0) {
                var e = $('#_SearchText');
                var s = "['\\%^&\"*]";
                var reg = new RegExp(s, 'g');
                if (e.val().search(reg) >= 0) { alert(s + " 문자는 사용될 수 없습니다!"); e.val(''); return; }

                _zw.V.lv.search = 'O'; //성명+부서
                _zw.V.lv.searchtext = e.val();
            }
            _zw.V.lv.start = $('#_SearchYear').val() + "-" + ($('#_SearchMonth').val().length == 1 ? "0" : "") + $('#_SearchMonth').val() + "-01"; //alert(vd)
        }
        
        _zw.fn.loadList();
    }

    _zw.fn.getLvQuery = function (lv) {
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

        if (lv) {
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
        }

        //alert(j["permission"])
        return JSON.stringify(j);
    }

    _zw.fn.initLv = function (tgt) {
        //var sCnt = _zw.ut.getCookie('eaLvCount');

        _zw.V.lv.tgt = tgt;
        _zw.V.lv.page = '1';
        _zw.V.lv.count = 0;
        _zw.V.lv.sort = '';
        _zw.V.lv.sortdir = '';
        _zw.V.lv.search = '';
        _zw.V.lv.searchtext = '';
        _zw.V.lv.start = '';
        _zw.V.lv.end = '';
        _zw.V.lv.basesort = '';
    }

    
});