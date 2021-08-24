//전자결재 메인, 리스트뷰

$(function () {

    $('#__LeftMenu .sidenav-toggle').click(function (e) {
        e.preventDefault();
        
        $(this).next().slideToggle(300, function() {
            $(this).parent().toggleClass('open');
        });
    });
    
    _zw.fn.viewCount = function (xf, loc, ar, admin) {
        $.ajax({
            type: "POST",
            url: '/EA/Main/Count',
            data: xf + ',' + loc + ',' + ar + ',' + _zw.V.current.urid + ',' + _zw.V.current.deptid + ',' + admin,
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    var cFirstDel = String.fromCharCode(12);
                    var cSecondDel = String.fromCharCode(11);

                    var vLocCount = res.substr(2).split(cSecondDel);
                    alert(vLocCount)

                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.viewCount('ea', 'base2', '', 'N');
});