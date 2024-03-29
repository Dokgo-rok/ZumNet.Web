function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo) {
    //console.log(roadFullAddr + ' : ' + roadAddrPart1 + ' : ' + addrDetail + ' : ' + roadAddrPart2 + ' : ' + engAddr + ' : ' + jibunAddr + ' : ' + zipNo);
    $('.card-body :text[data-for="ZipCode1"]').val(zipNo);
    $('.card-body :text[data-for="Address1"]').val(roadAddrPart1);
    $('.card-body :text[data-for="DetailAddress1"]').val(addrDetail);
}

$(function () {
    //개인정보
    $('.btn[data-zp-menu="savePersonInfo"]').click(function () {
        var jSend = {};
        $('.card-body input[data-for], .card-body textarea[data-for]').each(function () {
            if ($(this).is(":checkbox")) jSend[$(this).attr('data-for')] = $(this).prop('checked') ? 'Y' : 'N';
            else {
                if ($(this).attr('data-for') == 'BirthDay' || $(this).attr('data-for') == 'MarriedDate') jSend[$(this).attr('data-for')] = _zw.ut.date($(this).val(), 'YYYY-MM-DD');
                else jSend[$(this).attr('data-for')] = $.trim($(this).val());
            }
        });
        console.log(jSend)
        bootbox.confirm('저장 하시겠습니까?', function (rt) {
            if (rt) {
                $.ajax({
                    type: "POST",
                    url: "/Env/SavePersonInfo",
                    data: JSON.stringify(jSend),
                    success: function (res) {
                        if (res == "OK") window.location.reload();
                        else bootbox.alert(res);
                    },
                    beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
                });
            }
        });
    });

    //부재설정
    $('.btn[data-zp-menu="savePersonAbsent"]').click(function () {
        if ($('.card-body :checkbox[data-for="IsAbsent"]').prop('checked')) {
            if ($('.card-body input[data-for="AbsentDate1"]').val() == '' || $('.card-body input[data-for="AbsentDate2"]').val() == '') {
                bootbox.alert('부재기간을 선택하십시오!'); return false;
            }

            if ($('.card-body :radio[name="rdoAbsentType"]:checked').length == 0) {
                bootbox.alert('부재유형을 선택하십시오!'); return false;
            }
        }

        if ($('.card-body :checkbox[data-for="UseDeputy"]').prop('checked')) {
            if ($('.card-body input[data-for="RepresentorName"]').val() == '') {
                bootbox.alert('대결자를 선택하십시오!'); return false;
            }
        }

        var jSend = {};
        $('.card-body input[data-for], .card-body textarea[data-for]').each(function () {
            if ($(this).is(":checkbox")) jSend[$(this).attr('data-for')] = $(this).prop('checked') ? 'Y' : 'N';
            else {
                if ($(this).attr('data-for') == 'AbsentDate1' || $(this).attr('data-for') == 'AbsentDate2') jSend[$(this).attr('data-for')] = _zw.ut.date($(this).val(), 'YYYY-MM-DD');
                else jSend[$(this).attr('data-for')] = $.trim($(this).val());
            }
        });

        jSend['AbsentType'] = $('.card-body :radio[name="rdoAbsentType"]:checked').length > 0 ? $('.card-body :radio[name="rdoAbsentType"]:checked').val() : '';
        jSend['UserID'] = _zw.V.current.urid;
        jSend['LogonID'] = _zw.V.current.urcn;
        console.log(jSend)

        bootbox.confirm('저장 하시겠습니까?', function (rt) {
            if (rt) {
                $.ajax({
                    type: "POST",
                    url: "/Env/SavePersonAbsent",
                    data: JSON.stringify(jSend),
                    success: function (res) {
                        if (res == "OK") window.location.reload();
                        else bootbox.alert(res);
                    },
                    beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
                });
            }
        });
    });

    $('.card-body :checkbox[data-for="IsAbsent"]').click(function () {
        if (!$(this).prop('checked')) {
            $('.card-body input[data-for], .card-body textarea[data-for]').val('');
            $('.card-body :radio[name="rdoAbsentType"]').prop('checked', false);
            $('.card-body :checkbox[data-for="UseDeputy"]').prop('checked', false);
        }
    });

    $('.card-body :checkbox[data-for="UseDeputy"]').click(function () {
        if (!$(this).prop('checked')) {
            $('.card-body input[data-for="RepresentorName"]').val('');
            $('.card-body :hidden[data-for="Deputy"]').val('');
            $('.card-body :hidden[data-for="DeputyDeptCode"]').val('');
        }
    });

    $('.btn[data-zp-menu="deleteDeputy"]').click(function () {
        $('.card-body input[data-for="RepresentorName"]').val('');
        $('.card-body :hidden[data-for="Deputy"]').val('');
        $('.card-body :hidden[data-for="DeputyDeptCode"]').val('');
    });

    _zw.fn.orgSelect = function (p, x) {
        p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
            var info = JSON.parse($(this).attr('data-attr')); //console.log(info)
            var dn = $(this).next().text();
            $('.card-body input[data-for="RepresentorName"]').val(dn);
            $('.card-body :hidden[data-for="Deputy"]').val(info["logonid"]);
            $('.card-body :hidden[data-for="DeputyDeptCode"]').val(info["gralias"]);
        });
        p.modal('hide');
    }

    //암호 설정
    $("[data-password]").on('click', function () {
        if ($(this).attr('data-password') == "false") {
            $(this).siblings("input").attr("type", "text");
            $(this).attr('data-password', 'true');
            $(this).addClass("show-password");
        } else {
            $(this).siblings("input").attr("type", "password");
            $(this).attr('data-password', 'false');
            $(this).removeClass("show-password");
        }
    });

    $('.btn[data-zp-menu="changePwd"]').click(function () {
        var curPwd = $('.card-body input[data-for="pwd-current"]'),
            newPwd = $('.card-body input[data-for="pwd-new"]'),
            cfmPwd = $('.card-body input[data-for="pwd-confirm"]');

        if ($.trim(curPwd.val()) == '') {
            bootbox.alert('현재 비밀번호 누락!', function () { curPwd.focus(); }); return false;
        }

        var rt = _zw.ut.checkPwd(_zw.V.current.urcn, newPwd.val(), 8, 20, 3);
        if (rt != '') {
            bootbox.alert(rt, function () { newPwd.focus(); }); return false;
        }

        if (newPwd.val() != cfmPwd.val()) {
            bootbox.alert('비밀번호가 일치하지 않습니다!', function () { cfmPwd.focus(); }); return false;
        }

        $.ajax({
            type: "POST",
            url: "/Env/PwdChange",
            data: '{urid:"' + _zw.V.current.urid + '",logonid:"' + _zw.V.current.urcn + '",cur:"' + curPwd.val() + '",new:"' + newPwd.val() + '",cfm:"' + cfmPwd.val() + '"}',
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    if (res == 'OK') bootbox.alert('설정됐습니다!', function () { window.location.href = '/Account/Logout'; });
                    else bootbox.alert('타시스템 비밀번호 변경 오류!<br />' + res.substr(2), function () { window.location.href = '/Account/Logout'; }); //ekp 비밀번호 변경 성공

                } else bootbox.alert(res);
            },
            beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
        });
    });

    $('.btn[data-zp-menu="useEAPwd"]').click(function () {
        var usePwd = $('.card-body :checkbox[data-for="UseEAPwd"]').prop('checked') ? 'Y' : 'N';

        $.ajax({
            type: "POST",
            url: "/Env/UseEAPassword",
            data: '{urid:"' + _zw.V.current.urid + '",usepwd:"' + usePwd + '"}',
            success: function (res) {
                if (res == "OK") bootbox.alert('설정됐습니다!');
                else bootbox.alert(res);
            },
            beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
        });
    });

    $('.btn[data-zp-menu="changeEAPwd"]').click(function () {
        var curPwd = $('.card-body input[data-for="eapwd-current"]'),
            newPwd = $('.card-body input[data-for="eapwd-new"]'),
            cfmPwd = $('.card-body input[data-for="eapwd-confirm"]');

        if ($.trim(curPwd.val()) == '') {
            bootbox.alert('현재 비밀번호 누락!', function () { newPwd.focus(); }); return false;
        }

        var rt = _zw.ut.checkPwd('', newPwd.val(), 1, 20, 2);
        if (rt != '') {
            bootbox.alert(rt, function () { newPwd.focus(); }); return false;
        }

        if (newPwd.val() != cfmPwd.val()) {
            bootbox.alert('비밀번호가 일치하지 않습니다!', function () { cfmPwd.focus(); }); return false;
        }

        $.ajax({
            type: "POST",
            url: "/Env/EAPwdChange",
            data: '{urid:"' + _zw.V.current.urid + '",logonid:"' + _zw.V.current.urcn + '",cur:"' + curPwd.val() + '",new:"' + newPwd.val() + '",cfm:"' + cfmPwd.val() + '"}',
            success: function (res) {
                if (res == "OK") bootbox.alert('설정됐습니다!', function () { window.location.reload(); });
                else if (res == "NO") bootbox.alert('비밀번호가 일치하지 않습니다!', function () { curPwd.focus(); });
                else bootbox.alert(res);
            },
            beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
        });
    });

    $('.card-body input[data-for="pwd-confirm"]').keyup(function (e) {
        if (e.which == 13) $('.btn[data-zp-menu="changePwd"]').click();
    });

    $('.card-body input[data-for="eapwd-confirm"]').keyup(function (e) {
        if (e.which == 13) $('.btn[data-zp-menu="changeEAPwd"]').click();
    });
});