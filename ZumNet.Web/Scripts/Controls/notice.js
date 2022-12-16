$(function () {
    $('button[data-zv-menu="refresh"]').click(function () {
        _zw.fn.loadList();
    });

    $('.btn[data-zv-menu="deleteAll"]').click(function () {
        var s = '';
        $('#__ListView .time-line-item a[data-regid]').each(function () {
            if (s == '') s = $(this).attr('data-regid');
            else s += ';' + $(this).attr('data-regid');
        });
        if (s != '') {
            $.ajax({
                type: "POST",
                url: "/Portal/NoticeDelete",
                data: '{regid:"' + s + '",M:""}',
                success: function (res) {
                    if (res == 'OK') _zw.fn.loadList();
                    else console.log(res);
                },
                beforeSend: function () { }
            });
        }
    });    

    _zw.fn.bindCtrl = function () {
        $('#__ListView .time-line-item a[data-regid]').click(function () {
            var regid = $(this).attr('data-regid'), notiCls = $(this).attr('data-noticls'), linkInfo = $(this).attr('data-linkinfo');
            $.ajax({
                type: "POST",
                url: "/Portal/NoticeRead",
                data: '{regid:"' + regid + '",tgtid:"0"}',
                success: function (res) {
                    if (res == 'OK') {
                        if (notiCls.indexOf('/ea') > 0) {
                            //xf=ea,oi=315349,mi=333174,wi=e692a8741916498d917f73e68bb3660f
                            var temp = linkInfo.split(','); //wi->의미없음
                            _zw.fn.openXFormEx('read', temp[0].split('=')[1], temp[2].split('=')[1], temp[1].split('=')[1], '');
                            _zw.fn.loadList();

                        } else {
                            window.location.href = linkInfo;
                        }
                    } else console.log(res);
                },
                beforeSend: function () { }
            });
        });

        $('#__ListView button[data-zv-menu="delete"]').click(function () {
            $.ajax({
                type: "POST",
                url: "/Portal/NoticeDelete",
                data: '{regid:"' + $(this).prev().attr('data-regid') + '",M:""}',
                success: function (res) {
                    if (res == 'OK') _zw.fn.loadList();
                    else console.log(res);
                },
                beforeSend: function () { }
            });
        });
    }

    _zw.fn.loadList = function () {
        $.ajax({
            type: "POST",
            url: "/Portal/NoticeList",
            data: '{M:"L",wnd:"",tgtid:"' + _zw.V.current.urid + '"}', //L : 최근30일알림목록
            success: function (res) {
                if (res.substr(0, 2) == 'OK') {
                    $('#__ListView').html(res.substr(2));
                    _zw.fn.bindCtrl(); _zw.fn.notice();

                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.bindCtrl();
});