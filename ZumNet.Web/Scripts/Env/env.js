function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo) {
    //console.log(roadFullAddr + ' : ' + roadAddrPart1 + ' : ' + addrDetail + ' : ' + roadAddrPart2 + ' : ' + engAddr + ' : ' + jibunAddr + ' : ' + zipNo);
    $('.card-body :text[data-for="ZipCode1"]').val(zipNo);
    $('.card-body :text[data-for="Address1"]').val(roadAddrPart1);
    $('.card-body :text[data-for="DetailAddress1"]').val(addrDetail);
}

$(function () {
    $('.btn[data-zp-menu="savePersonInfo"]').click(function () {
        var jSend = {};
        $('.card-body input[data-for], .card-body textarea[data-for]').each(function () {
            if ($(this).is(":checkbox")) jSend[$(this).attr('data-for')] = $(this).prop('checked') ? 'N' : 'Y';
            else jSend[$(this).attr('data-for')] = $.trim($(this).val());
        });
        console.log(jSend)
        bootbox.confirm('저장 하시겠습니까?', function (rt) {
            if (rt) {
                $.ajax({
                    type: "POST",
                    url: "/Env/SavePersonInfo",
                    data: JSON.stringify(jSend),
                    success: function (res) {
                        if (res.substr(0, 2) == "OK") {
                            bootbox.alert('저장 되었습니다?');
                        } else bootbox.alert(res);
                    },
                    beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
                });
            }
        });
    });
});