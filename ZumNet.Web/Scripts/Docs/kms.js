//문서관리 리스트뷰

$(function () {

    _zw.mu.writeMsg = function (xf) {
        _zw.V.mode = '';
        _zw.V.wnd = 'popup';
        _zw.V.appid = 0;
        _zw.V.xfalias = xf;

        var postData = _zw.fn.getAppQuery(_zw.V.fdid);
        var url = '/Docs/Kms/Write?qi=' + encodeURIComponent(_zw.base64.encode(postData));
        _zw.ut.openWnd(url, "popupform", 800, 800, "resize");
    }

    _zw.mu.editMsg = function (xf) { //alert(_zw.V.appid)
        _zw.V.mode = '';
        _zw.V.wnd = 'popup';
        _zw.V.xfalias = xf;

        var postData = _zw.fn.getAppQuery(_zw.V.fdid);
        var url = '/Docs/Kms/Edit?qi=' + encodeURIComponent(_zw.base64.encode(postData));
        _zw.ut.openWnd(url, "popupform", 800, 800, "resize");
    }

    _zw.mu.deleteMsg = function () {

    }

    _zw.mu.previewMsg = function () {

    }

    _zw.mu.cancelMsg = function () {
        //history.back(); //<- 읽기 창에서 새글 갔다 오면 appid=0으로 돼 이후 수정, 답글 클릭시 오류 발생!!
        if (_zw.V.mode != 'reply' && _zw.V.current.page.toLowerCase() == '/docs/kms/write') {
            if (_zw.V.wnd == 'popup') window.close();
            else _zw.mu.goList();
        } else history.back();
    }

    _zw.mu.goList = function () {
        var postData = _zw.fn.getLvQuery();
        window.location.href = '/Docs/Kms/List?qi=' + encodeURIComponent(_zw.base64.encode(postData));
    }

    _zw.fn.loadList = function () {
        var postData = _zw.fn.getLvQuery(); //console.log(postData);
        var url = '/Docs/Kms/List?qi=' + encodeURIComponent(_zw.base64.encode(postData)); //encodeURIComponent(postData);

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
                    $('#__ListMenu').html(v[2]);
                    $('#__ListViewPage').html(v[3]);

                    $('.pagination li a.page-link').click(function () {
                        _zw.mu.search($(this).attr('data-for'));
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

        //alert(j["permission"])
        return JSON.stringify(j);
    }

    _zw.fn.initLv = function (tgt) {
        $('.z-lv-date .start-date').val('');
        $('.z-lv-date .end-date').val('');
        $('.z-lv-search select').val('');
        $('.z-lv-search .search-text').val('');

        $('.z-lv-hdr a[data-val]').each(function () {
            $(this).find('i').removeClass();
        });

        var sCnt = _zw.ut.getCookie('docLvCount') || $('.z-lv-page select').val();

        _zw.V.lv.tgt = tgt;
        _zw.V.lv.page = '1';
        _zw.V.lv.count = sCnt == undefined || sCnt == '' ? '20' : sCnt;
        _zw.V.lv.sort = 'CreateDate';
        _zw.V.lv.sortdir = 'DESC';
        _zw.V.lv.search = '';
        _zw.V.lv.searchtext = '';
        _zw.V.lv.start = '';
        _zw.V.lv.end = '';
        _zw.V.lv.basesort = '';
    }
});