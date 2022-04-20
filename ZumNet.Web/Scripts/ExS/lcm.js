$(function () {

    $('[data-zv-menu="search"]').click(function () {
        _zw.fn.goSearch();
    });

    $('#_SearchText').keyup(function (e) {
        if (e.which == 13) _zw.fn.goSearch();
    });

    _zw.fn.viewLcmInfo = function (m, ft) {
        bootbox.alert('준비중!')
    }

    _zw.fn.sort = function (col) {
        var el = event.target ? event.target : event.srcElement;
        var dir = $(el).find('i').hasClass('fe-arrow-up') ? 'DESC' : 'ASC';
        _zw.fn.goSearch(null, col, dir);
    }

    _zw.fn.goSearch = function (page, sort, dir) {//alert(1)
        var tgt = '0';
        if (_zw.V.ft == 'LCM_MAIN') {
            if ($('#_Target').val() == 'PR') tgt = _zw.V.current.urid;
            else if ($('#_Target').val() == 'PD') tgt = _zw.V.current.deptid;

            _zw.V.mode = $('#_Target').val();
        }

        _zw.fn.initLv(tgt);

        sort = sort || ''; dir = dir || '';
        _zw.V.lv.sort = sort;
        _zw.V.lv.sortdir = dir;

        _zw.V.lv.page = (page) ? page : 1;
        _zw.V.lv.start = $('.z-lv-cond .datepicker .start-date').val();
        _zw.V.lv.end = $('.z-lv-cond .datepicker .end-date').val();

        var e = $('#_SearchText');
        if ($('#_Search').val()  != '' && e.length > 0) {
            var s = "['\\%^&\"*]";
            var reg = new RegExp(s, 'g');
            if (e.val().search(reg) >= 0) { alert(s + " 문자는 사용될 수 없습니다!"); e.val(''); return; }

            if ($.trim(e.val()) != '') {
                _zw.V.lv.search = $('#_Search').val();
                _zw.V.lv.searchtext = e.val();
            }
        }

        _zw.V.lv.cd1 = $('#_Cond1').val(); _zw.V.lv.cd2 = $('#_Cond2').val(); _zw.V.lv.cd3 = $('#_Cond3').val();
        _zw.V.lv.cd4 = $('#_Cond4').val(); _zw.V.lv.cd5 = $('#_Cond5').val();

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

                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.getLvQuery = function () {
        var j = {};
        j["M"] = _zw.V.mode;
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

        j["cd1"] = _zw.V.lv.cd1; j["cd2"] = _zw.V.lv.cd2; j["cd3"] = _zw.V.lv.cd3; j["cd4"] = _zw.V.lv.cd4; j["cd5"] = _zw.V.lv.cd5; j["cd6"] = _zw.V.lv.cd6; j["cd7"] = _zw.V.lv.cd7;

        return JSON.stringify(j);
    }

    _zw.fn.initLv = function (tgt) {
        var sCnt = 50; //_zw.ut.getCookie('costLvCount');
        if ($('.z-list-page select').length > 0) sCnt = $('.z-list-page select').val();

        _zw.V.lv.tgt = tgt;
        _zw.V.lv.page = '1';
        _zw.V.lv.count = sCnt;
        _zw.V.lv.sort = '';
        _zw.V.lv.sortdir = '';
        _zw.V.lv.search = '';
        _zw.V.lv.searchtext = '';
        _zw.V.lv.start = '';
        _zw.V.lv.end = '';
        //_zw.V.lv.basesort = '';

        _zw.V.lv.cd1 = ''; _zw.V.lv.cd2 = ''; _zw.V.lv.cd3 = ''; _zw.V.lv.cd4 = ''; _zw.V.lv.cd5 = ''; _zw.V.lv.cd6 = ''; _zw.V.lv.cd7 = '';
    }
});