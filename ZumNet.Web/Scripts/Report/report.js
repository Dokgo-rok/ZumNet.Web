//집계, 대장 리스트뷰

$(function () {

    _zw.fn.bindCtrl = function () {
        _zw.ut.picker('date');

        $('[data-zv-menu="search"]').click(function () {
            _zw.fn.goSearch();
        });

        $('#_SearchText').keyup(function (e) {
            if (e.which == 13) _zw.fn.goSearch();
        });
        //console.log(fchart_report)
        //if (FusionCharts && fchart_report) fchart_report.render();

        $('#__ListView div[data-for="multiple-chart"]').each(function () {
            var j = $(this).next().text(), d = $(this).next().next().text();
            //console.log(j)
            var fchart = new FusionCharts(JSON.parse(j));
            fchart.setXMLData(d);
            fchart.render();
        });

        if ($('.chart-cfg-template').length > 0 && $('.chart-data-template').length > 0) {
            var j = $('.chart-cfg-template').text(), d = $('.chart-data-template').text();
            //console.log(JSON.parse(j)); console.log(d)

            //var fchart = new FusionCharts({
            //    type: 'mscombidy2d',
            //    renderAt: 'chart-container',
            //    width: '100%',
            //    height: '300px',
            //    dataFormat: 'xml'
            //});
            var fchart = new FusionCharts(JSON.parse(j));

            fchart.setXMLData(d);
            fchart.render();
        }
    }

    _zw.fn.bindCtrl();

    _zw.fn.exportExcel = function () {
        //var encQi = '{M:"xls",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",fdid:"' + _zw.V.fdid + '",opnode:"",ttl:"' + _zw.V.ttl + '"}';
        //window.open('?qi=' + encodeURIComponent(_zw.base64.encode(encQi)), 'ifrView');

        var postData = _zw.fn.getLvQuery('xls'); //console.log(postData)
        window.open('?qi=' + encodeURIComponent(_zw.base64.encode(postData)), 'ifrView');
    }

    _zw.fn.loadList = function () {
        var postData = _zw.fn.getLvQuery(); console.log(postData)
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
                    //if ($('#__ListView [data-for="list"]').length > 0) { //_zw.V.ft == 'REGISTER_EMPLOYEE_PALNT'
                    //    $('#__ListView [data-for="list"]').html(v[0]); //console.log(v[1])
                    //    fchart_report.setXMLData(v[1]);
                    //    fchart_report.render();

                    //} else {
                    //    $('#__List').html(v[0]);
                    //    $('.z-list-menu').html(v[1]);
                    //    $('#__ListPage').html(v[2]);

                    //    _zw.fn.bindCtrl();
                    //}

                    $('#__List').html(v[0]);
                    $('.z-list-menu').html(v[1]);
                    $('#__ListPage').html(v[2]);

                    //if (fchart_report) {
                    //    fchart_report.render();
                    //}

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
        if (_zw.V.ft == 'REGISTER_PRODUCT_PALNT' || _zw.V.ft == 'REGISTER_EMPLOYEE_PALNT' || _zw.V.ft == 'REGISTER_PRODUCT_PALNT_MODEL'
            || _zw.V.ft == 'REGISTER_EMPLOYEE_PALNT_MODEL' || _zw.V.ft == 'REGISTER_PROCESS_PALNT_MODEL') {
            _zw.V.lv.start = $('.z-list-search select[data-for="year"]').val();
            _zw.V.lv.end = $('.z-list-search select[data-for="month"]').val();
            _zw.V.lv.cd1 = $('.z-list-search select[data-for="cond1"]').val();

            //var postData = _zw.fn.getLvQuery(); //console.log(postData)
            //window.location.href = '?qi=' + encodeURIComponent(_zw.base64.encode(postData));

        } else {
            _zw.fn.initLv(_zw.V.current.urid);

            sort = sort || ''; dir = dir || '';
            _zw.V.lv.sort = sort;
            _zw.V.lv.sortdir = dir;
            _zw.V.lv.page = (page) ? page : 1;

            _zw.V.lv.start = $('.z-list-cond .start-date').val();
            _zw.V.lv.end = $('.z-list-cond .end-date').val();

            _zw.V.lv.cd1 = $('#_SearchSelect').val();

            if ($('#_SearchText').length > 0) {
                var e = $('#_SearchText');
                var s = "['\\%^&\"*]";
                var reg = new RegExp(s, 'g');
                if (e.val().search(reg) >= 0) { alert(s + " 문자는 사용될 수 없습니다!"); e.val(''); return; }

                _zw.V.lv.cd2 = e.val();
            }
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
        j["cd7"] = _zw.V.lv.cd7; j["cd8"] = _zw.V.lv.cd8; j["cd9"] = _zw.V.lv.cd9; j["cd10"] = _zw.V.lv.cd10; j["cd11"] = _zw.V.lv.cd11; j["cd12"] = _zw.V.lv.cd12;

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
        _zw.V.lv.cd7 = ''; _zw.V.lv.cd8 = ''; _zw.V.lv.cd9 = ''; _zw.V.lv.cd10 = ''; _zw.V.lv.cd11 = ''; _zw.V.lv.cd12 = '';
    }
});