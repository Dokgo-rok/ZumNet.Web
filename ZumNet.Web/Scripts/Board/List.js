//게시판 리스트뷰

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

        $.ajax({
            type: "POST",
            url: "?qi=",
            data: _zw.fn.getLvQuery(),
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    $('.z-ttl span').html(_zw.V.ttl);

                    var v = res.substr(2).split(_zw.V.lv.boundary);
                    $('#__ListView').html(v[0]);
                    $('#__ListPage').html(v[1]);

                } else bootbox.alert(res);
            }
        });
    }
    _zw.fn.goSearch = function () {
        alert(1)
    }

    _zw.fn.getLvQuery = function () {
        var j = {};
        j["ct"] = _zw.V.ct;
        j["ctalias"] = _zw.V.ctalias;
        j["ot"] = _zw.V.ot;
        j["xfalias"] = _zw.V.xfalias;
        j["permission"] = _zw.V.current.acl;
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
        _zw.V.lv.tgt = tgt;
        _zw.V.lv.page = '1';
        _zw.V.lv.count = '20';
        _zw.V.lv.sort = 'SeqID';
        _zw.V.lv.sortdir = 'DESC';
        _zw.V.lv.search = '';
        _zw.V.lv.searchtext = '';
        _zw.V.lv.start = '';
        _zw.V.lv.end = '';
        _zw.V.lv.basesort = '';
    }
    

});