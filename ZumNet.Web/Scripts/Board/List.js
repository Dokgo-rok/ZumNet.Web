//게시판 리스트뷰

$(function () {

    _zw.fn.loadList = function () {

        $.ajax({
            type: "POST",
            url: "?qi=",
            data: '{permission:"' + _zw.V.current.acl + '",page:' + _zw.V.lv.page + ',count:' + _zw.V.lv.count + ',tgt:' + _zw.V.lv.tgt
                + ',sort:"' + _zw.V.lv.sort + '",sortdir:"' + _zw.V.lv.sortdir + '",search:"' + _zw.V.lv.search
                + '",searchtext:"' + _zw.V.lv.searchtext + '",start:"' + _zw.V.lv.start + '",end:"' + _zw.V.lv.end + '"}',
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    $('.z-ttl span').html(_zw.V.ttl);
                    $('#__ListView').html(res.substr(2));
                    //$('#__CtDashboard').addClass('d-none');
                    //$('#__ListView').removeClass('d-none');

                } else bootbox.alert(res);
            }
        });
    }
    _zw.fn.goSearch = function () {
        alert(1)
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