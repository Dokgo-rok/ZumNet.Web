$(function () {
    _zw.fn.bindCtrl = function () {
        _zw.ut.picker('date');

        $('.total-search-result .list-group-item div[data-for="body"]').each(function () {
            var txt = $(this).text();
            $(this).html(txt.length > 200 ? txt.substr(0, 200) + '...' : txt); $(this).removeClass('d-none');
        });

        $('#__SearchViewPage li a.page-link').click(function () {
            _zw.fn.goSearch($(this).attr('data-for'));
        });
    }

    $('.total-search input[type="text"]').keyup(function (e) {
        if (e.which == 13) _zw.fn.goSearch();
    });

    $('.total-search .input-group .btn').click(function (e) {
        _zw.fn.goSearch();
    });

    $('.total-search-result a.nav-link').click(function () {
        $('.total-search-result a.nav-link').removeClass('active');
        $(this).addClass('active');

        _zw.fn.goSearch();
    });

    _zw.fn.bindCtrl();

    _zw.fn.readSearchForm = function (fdId, msgId, ctId, xf, acl, fd, sys) {
        //console.log(fdId + '==' + msgId + '==' + ctId + '==' + xf + '==' + acl + '==' + fd + '==' + sys)

        if (sys == 'PDM') return;

        var sortCol = '', sortType = '';
        if (sortCol == '') {
            if (_zw.V.xfalias == 'knowledge') sortCol = 'CreateDate';
            else if (_zw.V.xfalias == 'doc') sortCol = 'CreateDate';
            else sortCol = 'SeqID';
        }
        if (sortType == '') sortType = 'DESC'

        var postData = '{wnd:"popup",ct:"' + ctId + '",ctalias:"",ot:"",alias:"",xfalias:"' + xf + '",fdid:"' + fdId + '",appid:"' + msgId
                + '",opnode:"",ttl:"",acl:"'+ '",appacl:"' + acl + '",sort:"' + sortCol + '",sortdir:"' + sortType + '",boundary:"' + _zw.V.lv.boundary + '"}';

        var tgtPage = '';
        if (xf == 'knowledge') tgtPage = '/Docs/Kms/Read';
        else if (xf == 'doc') tgtPage = '/Docs/Edm/Read';
        else tgtPage = '/Board/Read';

        var url = tgtPage + '?qi=' + encodeURIComponent(_zw.base64.encode(postData));

        if (xf == 'doc') _zw.ut.openWnd(url, "popupform" + '_' + xf, 500, 500, "resize");
        else _zw.ut.openWnd(url, "popupform" + '_' + xf, 800, 800, "resize");
    }

    _zw.fn.loadList = function () {
        var postData = _zw.fn.getLvQuery(); //console.log(postData)
        var url = '?qi=' + encodeURIComponent(_zw.base64.encode(postData));

        $.ajax({
            type: "POST",
            url: url,
            success: function (res) { //console.log(res)
                if (res.substr(0, 2) == "OK") {
                    history.pushState(null, null, url);

                    var v = res.substr(2).split(_zw.V.lv.boundary);

                    $('#__SearchView').html(v[0]);
                    $('#__SearchViewPage').html(v[1]);

                    _zw.fn.bindCtrl();

                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.goSearch = function (page, sort, dir) {
        _zw.fn.initLv(0);

        sort = sort || ''; dir = dir || '';
        _zw.V.lv.sort = sort;
        _zw.V.lv.sortdir = dir;
        _zw.V.lv.page = (page) ? page : 1;

        var e = $('.total-search-result a.nav-link.active');
        _zw.V.ct = e.attr('data-val');

        e = $('.total-search .form-control');
        var s = "['\\%^&\"*]";
        var reg = new RegExp(s, 'g');
        if (e.val().search(reg) >= 0) { bootbox.alert(s + " 문자는 사용될 수 없습니다!", function () { e.val(''); e.focus(); }); return false; }
        if ($.trim(e.val()) == '') { bootbox.alert('검색어를 입력하십시오!', function () { e.focus(); }); return false; }

        _zw.V.lv.searchtext = e.val();
        _zw.V.lv.start = $('.total-search-detail .start-date').val();
        _zw.V.lv.end = $('.total-search-detail .end-date').val();

        _zw.fn.loadList();
    }

    _zw.fn.getLvQuery = function (m) {
        var j = {}; m = m || '';
        j["M"] = m;
        j["ct"] = _zw.V.ct;
        j["ctalias"] = _zw.V.ctalias;
        j["ft"] = _zw.V.ft;
        j["ttl"] = _zw.V.ttl;

        j["tgt"] = _zw.V.lv.tgt;
        j["page"] = _zw.V.lv.page;
        j["count"] = _zw.V.lv.count;
        j["sort"] = _zw.V.lv.sort == '' ? 'CreateDate' : _zw.V.lv.sort;
        j["sortdir"] = _zw.V.lv.sortdir == '' ? 'DESC' : _zw.V.lv.sortdir;
        j["search"] = _zw.V.lv.search == '' ? 'Subject' : _zw.V.lv.search;
        j["searchtext"] = _zw.V.lv.searchtext;
        j["start"] = _zw.V.lv.start;
        j["end"] = _zw.V.lv.end;
        j["boundary"] = _zw.V.lv.boundary;

        return JSON.stringify(j);
    }

    _zw.fn.initLv = function (tgt) {
        _zw.V.lv.tgt = tgt;
        _zw.V.lv.page = '1';
        _zw.V.lv.count = '20';
        _zw.V.lv.sort = '';
        _zw.V.lv.sortdir = '';
        _zw.V.lv.search = '';
        _zw.V.lv.searchtext = '';
        _zw.V.lv.start = '';
        _zw.V.lv.end = '';
    }
});