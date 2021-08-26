//전자결재 메인, 리스트뷰

$(function () {

    $('#__LeftMenu .sidenav-toggle').click(function (e) {
        e.preventDefault();

        $(this).next().slideToggle(300, function () {
            $(this).parent().toggleClass('open');
        });
    });

    $('#__LeftMenu li[data-box] .sidenav-link').click(function (e) {
        e.preventDefault();

        var encQi = encodeURIComponent('{ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"",xfalias:"' + _zw.V.xfalias + '",fdid:"",opnode:"' + _zw.V.opnode + '",ttl:"' + ttl + '",acl:"' + _zw.V.current.acl + '"}');

        if (_zw.V.current.page.toLowerCase() == '/ea/main/list') {

        } else {
            window.location.href = '/EA/Main/List?qi=' + encQi;
        }
    });
    
    _zw.fn.viewCount = function (xf, loc, ar, admin) {
        $.ajax({
            type: "POST",
            url: '/EA/Main/Count',
            data: xf + ',' + loc + ',' + ar + ',' + _zw.V.current.urid + ',' + _zw.V.current.deptid + ',' + admin,
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    var c1 = String.fromCharCode(12);
                    var c2 = String.fromCharCode(11);

                    var vLoc = res.substr(2).split(c2);
                    for (var i in vLoc) {
                        var vCnt = vLoc[i].split(c1);
                        var tgt = $('li[data-box="node.' + vCnt[0] + '"]');
                        //console.log(i + ' : ' + vCnt + ' : ' + tgt.length)
                        if (tgt.length > 0) {
                            if (vCnt[1].indexOf('/') < 0) tgt.find('.z-lm-cnt').html('(' + vCnt[1] + ')');
                            else tgt.find('.z-lm-cnt').html('(<span class="text-danger">' + vCnt[1].split('/')[0] + '</span>/' + vCnt[1].split('/')[1] + ')');
                        }
                    }

                } else console.log(res);
            },
            beforeSend: function () { //로딩 X
            }
        });
        var t = setTimeout("_zw.fn.viewCount('" + xf + "', '" + loc + "', '" + ar + "', '" + admin + "')", 60000);
    }

    _zw.fn.viewCount('ea', 'base2', '', 'N');

    _zw.fn.loadList = function () {
        var postData = _zw.fn.getLvQuery();
        var url = '/EA/Main/List?qi=' + encodeURIComponent(postData); //_zw.base64.encode(postData);

        $.ajax({
            type: "POST",
            url: url,
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    history.pushState(null, null, url);

                    window.document.title = _zw.V.ttl;
                    $('.z-ttl span').html(_zw.V.ttl);

                    var v = res.substr(2).split(_zw.V.lv.boundary);
                    $('#__ListView').html(v[0]);
                    $('#__ListCount').html(v[1]);
                    $('#__ListPage').html(v[2]);

                } else bootbox.alert(res);
            }
        });
    }
    _zw.fn.goSearch = function () {
        alert(1)
    }

    _zw.fn.getLvQuery = function () {
        //alert(encodeURIComponent(_zw.V.ttl))
        var j = {};
        j["ct"] = _zw.V.ct;
        j["ctalias"] = _zw.V.ctalias;
        j["ot"] = _zw.V.ot;
        j["xfalias"] = _zw.V.xfalias;
        j["fdid"] = _zw.V.fdid;
        j["acl"] = _zw.V.current.acl;
        j["opnode"] = _zw.V.opnode;
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

        //alert(j["permission"])

        return JSON.stringify(j);
    }

    _zw.fn.initLv = function (tgt) {
        var sCnt = _zw.ut.getCookie('bbsLvCount');
        sCnt = $('.z-lv-page select').val();

        _zw.V.lv.tgt = tgt;
        _zw.V.lv.page = '1';
        _zw.V.lv.count = sCnt == '' ? '20' : sCnt;
        _zw.V.lv.sort = 'SeqID';
        _zw.V.lv.sortdir = 'DESC';
        _zw.V.lv.search = '';
        _zw.V.lv.searchtext = '';
        _zw.V.lv.start = '';
        _zw.V.lv.end = '';
        _zw.V.lv.basesort = '';
    }
});