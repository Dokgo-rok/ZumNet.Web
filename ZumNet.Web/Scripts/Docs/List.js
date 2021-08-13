//문서관리 리스트뷰

$(function () {

    $('.datepicker').datepicker({
        autoclose: true,
        //format: "yyyy-mm-dd",
        language: $('#current_culture').val()
    });

    _zw.fn.loadList = function () {

        //var sJson = '{ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + _zw.V.ot + '",xfalias:"' + _zw.V.xfalias + '",permission:"' + _zw.V.current.acl + '",tgt:"' + _zw.V.lv.tgt
        //    + '",page:' + _zw.V.lv.page + ',count:' + _zw.V.lv.count + ',sort:"' + _zw.V.lv.sort + '",sortdir:"' + _zw.V.lv.sortdir + '",search:"' + _zw.V.lv.search
        //    + '",searchtext:"' + _zw.V.lv.searchtext + '",start:"' + _zw.V.lv.start + '",end:"' + _zw.V.lv.end + '",boundary:"' + _zw.V.lv.boundary + '"}';

        //var j = JSON.parse(sJson);
        //console.log(j.ctalias);

        var postData = _zw.fn.getLvQuery();
        var url = '/Docs/Edm/List?qi=' + encodeURIComponent(postData); //_zw.base64.encode(postData);

        $.ajax({
            type: "POST",
            url: url,
            //data: _zw.fn.getLvQuery(),
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