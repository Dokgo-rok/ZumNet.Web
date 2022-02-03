$(function () {

    $('#_CALENDAR_COMPANY .card-body').datepicker({
        autoclose: true,
        todayHighlight: true,
        language: $('#current_culture').val(),
        beforeShowDay: function (d) {
            var vSchedule = ['2022-01-13', '2022-01-20', '2022-01-26']
            if (vSchedule.indexOf(moment(d).format('YYYY-MM-DD')) != -1) return { classes: 'text-danger font-weight-bold', tooltip: '일정 있음' };
            else return true;
        }
    });

    $('#_EA_COUNT a[data-box]').click(function (e) {
        e.preventDefault();

        var qi = '{ct:"109",ctalias:"ea",xfalias:"ea",ttl:"' + $(this).find('span:first').text() + '",opnode:"' + $(this).attr('data-location') + '"}'
        window.location.href = '/EA/Main/List?qi=' + _zw.base64.encode(qi);
    });

    $('#_EA_INBOX .card-header-elements a').click(function (e) {
        e.preventDefault();

        var qi = '{ct:"109",ctalias:"ea",xfalias:"ea",ttl:"' + $(this).attr('title') + '",opnode:"' + $(this).attr('data-location') + '"}'
        window.location.href = '/EA/Main/List?qi=' + _zw.base64.encode(qi);
    });

    $('#_MAIL_INBOX .card-body a[data-itemid]').click(function (e) {
        e.preventDefault();

        var url = $('#_MAIL_INBOX .card-body').attr('data-owa') + '/#viewmodel=ReadMessageItem&ItemID=' + $(this).attr('data-itemid');
        _zw.ut.openWnd(url, '', 700, 600, 'resize');
    });

    $('#_RECENT_NOTICE .card-header-elements a').click(function (e) {
        e.preventDefault();

        var qi = '{ct:"103",ctalias:"bboard",ot:"G",alias:"notice.company",xfalias:"notice",ttl:"",opnode:"0.0.12851"}'
        window.location.href = '/Board/List?qi=' + _zw.base64.encode(qi);
    });

    $('#_RECENT_BOARD .card-header-elements a').click(function (e) {
        e.preventDefault();

        var qi = '{ct:"103",ctalias:"bboard",ot:"G",alias:"notice.company",xfalias:"notice",ttl:"",opnode:"0.0.12851"}'
        window.location.href = '/Board/List?qi=' + _zw.base64.encode(qi);
    });

    $('#_EKP_KPI .card-header-elements a').click(function (e) {
        e.preventDefault();

        var qi = '{ct:"292",ctalias:"improvement",fdid:14396,ot:"L",alias:"",xfalias:"",ttl:"",opnode:"0.0.14396",ft:"INVKPI"}'
        window.location.href = '/ExS/PQm?qi=' + _zw.base64.encode(qi);
    });

    $('#_EKP_KPI_S .card-header-elements a').click(function (e) {
        e.preventDefault();

        var qi = '{ct:"292",ctalias:"improvement",fdid:14423,ot:"L",alias:"",xfalias:"",ttl:"",opnode:"0.0.14423",ft:"INVKPI_S"}'
        window.location.href = '/ExS/PQm?qi=' + _zw.base64.encode(qi);
    });

    _zw.fn.getEACount('webpart', 'ea', 'base2', '', 'N');
});