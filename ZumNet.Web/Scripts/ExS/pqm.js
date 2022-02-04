//집계, 대장 리스트뷰

$(function () {

    $('[data-zv-menu="search"]').click(function () {
        _zw.fn.goSearch();
    });

    $('.z-list-date .start-date').keyup(function (e) {
        if (e.which == 13) _zw.fn.goSearch();
    });

    _zw.mu.changeWeek = function () {
        var el = $(event.target);
        if (el.val().indexOf('_')) {
            var v = el.val().split('_');
            $.ajax({
                type: "POST",
                url: '/ExS/PQm/KpiTable',
                data: '{ft:"' + _zw.V.ft + '",year:"' + v[0] + '",week:"' + v[1] + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        $('#chart-list').html(res.substr(2));
                    } else bootbox.alert(res);
                }
            });
        }
    }

    _zw.fn.loadList = function () {
        var postData = _zw.fn.getLvQuery(true);
        var url = '?qi=' + _zw.base64.encode(postData);

        $.ajax({
            type: "POST",
            url: url,
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    history.pushState(null, null, url);

                    var v = res.substr(2).split(_zw.V.lv.boundary); //console.log(JSON.parse(JSON.stringify($.trim(v[0]))))
                    var jChart = JSON.parse($.trim(v[0])); //console.log(jChart) //eval(v[0]);
                    for (var i = 0; i < jChart.length; i++) {
                        _zw.C[i].data.labels = jChart[i].labels;
                        _zw.C[i].data.datasets = jChart[i].datasets;
                        _zw.C[i].update();
                    }

                    $('#__ListCount').html('<i class="fe-chevron-right"></i> ' + v[1]);
                    $('#chart-list').html(v[2]);
                    $('#ddlWeek').html(v[3]);

                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.goSearch = function () {
        _zw.fn.initLv(_zw.V.current.urid);
        _zw.V.lv.start = $('.z-list-date .start-date').val();

        _zw.fn.loadList();
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

        //j["cd1"] = _zw.V.lv.cd1; j["cd2"] = _zw.V.lv.cd2; j["cd3"] = _zw.V.lv.cd3; j["cd4"] = _zw.V.lv.cd4; j["cd5"] = _zw.V.lv.cd5; j["cd6"] = _zw.V.lv.cd6;
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

        //_zw.V.lv.cd1 = ''; _zw.V.lv.cd2 = ''; _zw.V.lv.cd3 = ''; _zw.V.lv.cd4 = ''; _zw.V.lv.cd5 = ''; _zw.V.lv.cd6 = '';
        //_zw.V.lv.cd7 = ''; _zw.V.lv.cd8 = ''; _zw.V.lv.cd9 = ''; _zw.V.lv.cd10 = ''; _zw.V.lv.cd11 = ''; _zw.V.lv.cd12 = '';
    }
});