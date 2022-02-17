$(function () {
    $('#__LeftMenu .sidenav-toggle').click(function (e) {
        e.preventDefault();

        $(this).next().slideToggle(300, function () {
            $(this).parent().toggleClass('open');
        });
    });

    _zw.fn.getToDoCount = function (tgt, mode, dt) {
        if (tgt == '') {
            $('.z-lm .sidenav-item .sidenav-link[data-for]').each(function () {
                var attr = $(this).attr("data-for");
                if (attr.indexOf('.') > 0 && attr.substr(0, 2) == 'UR') {
                    tgt += (tgt == '' ? '' : ';') + attr;;
                }
            }); //console.log(tgt)
        }

        $.ajax({
            type: "POST",
            url: '/TnC/ToDo/Count',
            data: '{tgt:"' + tgt + '",mode:"' + mode + '",date:"' + dt + '"}',
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    if (res.substr(2) != '') {
                        console.log(res.substr(2))
                        var j = JSON.parse(res.substr(2));
                        for (var i = 0; i < j.length; i++) {
                            for (key in j[i]) {
                                $('.z-lm .sidenav-item .sidenav-link[data-for="' + key + '"]').find('.z-lm-cnt').html('(<span class="text-danger">' + j[i][key][1] + '</span>/' + j[i][key][0] + ')')
                            }
                        }
                    }
                } else bootbox.alert(res);
            },
            beforeSend: function () { } //로딩 X
        });
    }


    _zw.fn.getToDoCount('', 'W', '');
});