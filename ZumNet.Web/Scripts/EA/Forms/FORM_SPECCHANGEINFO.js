$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            return true;
        },
        "make": function (f) {
        },
        "checkEvent": function (ckb, el, fld) {
        },
        "calc": function (el) {
        },
        "autoCalc": function (p) {
        },
        "orgSelect": function (p, x) {
            p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
                var info = JSON.parse($(this).attr('data-attr')); console.log(info)
                var dn = $(this).next().text();
                $('#__mainfield[name="NEXTWORKER"]').val(dn);
                $('#__mainfield[name="NEXTWORKERID"]').val(info["id"]);
                $('#__mainfield[name="NEXTWORKERDEPT"]').val(info["grdn"]);
                $('#__mainfield[name="NEXTWORKERDEPTID"]').val(info["grid"]);
            });
            p.modal('hide');
        },
        "optionWnd": function (pos, w, h, m, n, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.'); //console.log(arguments)
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]); //console.log(param);
            var m = 'getcodedescription', v1 = '', v2 = '', v3 = '';

            //data body 조건 : N(modal-body 없음), F(footer 포함)
            $.ajax({
                type: "POST",
                url: "/EA/Common",
                data: '{M:"' + m + '",body:"F", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",query:"",fn:"checkbox",search:""}',
                success: function (res) {
                    //res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
                    if (res.substr(0, 2) == 'OK') {
                        var p = $('#popBlank');
                        p.html(res.substr(2)).find('.modal-title').html(el.attr('title'));
                        p.find(".modal-dialog").css("max-width", "15rem");

                        p.find('.modal-footer .btn[data-zm-menu="confirm"]').click(function () {
                            var rt = '';
                            p.find('.modal-body :checkbox[name="ckbMultiOption"]').each(function () {
                                if ($(this).prop('checked')) rt += (rt != '' ? ',' : '') + $(this).parent().next().next().text();
                            });
                            $('#__mainfield[name="' + param[0] + '"]').val(rt);
                            p.modal('hide');
                        });

                        p.on('hidden.bs.modal', function () { p.html(''); });
                        p.modal();

                    } else bootbox.alert(res);
                }
            });
        },
        "externalWnd": function (pos, w, h, m, n, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.'); //console.log(arguments)
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]); //console.log(param);
            var m = '', v1 = '', v2 = '', v3 = '';
            if (vPos[0] == 'erp') {
                m = 'getoracleerp';
            } else if (vPos[0] == 'report') {
                m = 'getreportsearch';
            }
            var s = '<div class="zf-modal modal-dialog modal-dialog-centered modal-dialog-scrollable">'
                + '<div class="modal-content" data-for="' + vPos[1] + '" style="box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.5)">'
                + '<div class="modal-header">'
                + '<div class="d-flex align-items-center w-100">'
                + '<div class="input-group w-50">'
                + '<input type="text" class="form-control" placeholder="' + (el.attr('title') != '' ? el.attr('title') + ' ' : '') + '검색" value="">'
                + '<span class="input-group-append"><button class="btn btn-secondary" type="button"><i class="fe-search"></i></button></span>'
                + '</div>' //input-group
                + '<div class="ml-2 d-flex align-items-center zf-modal-page"></div>'
                + '</div>' //d-flex
                + '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>'
                + '<input type="hidden" data-for="page" value="1" /><input type="hidden" data-for="page-count" value="50" />'
                + '</div>' //modal-header
                + '<div class="modal-body"></div>'
                + '</div></div>';

            var p = $('#popBlank');
            p.html(s).find(".modal-content").css("min-height", "20rem");
            if (vPos[1] == 'SEARCH_ECNNO') p.find(".modal-dialog").css("max-width", "42rem")
            else p.find(".modal-dialog").css("max-width", "30rem")

            var searchBtn = p.find('.zf-modal .modal-header .input-group .btn');
            var searchTxt = $('.zf-modal .modal-header .input-group :text');

            searchTxt.keyup(function (e) { if (e.which == 13) { searchBtn.click(); } });
            searchBtn.click(function () {
                if ($.trim(searchTxt.val()) == '' || searchTxt.val().length < 1) { bootbox.alert('검색어를 입력하십시오!', function () { searchTxt.focus(); }); return false; }
                var exp = "['\\%^&\"*]", reg = new RegExp(exp, 'gi');
                if (searchTxt.val().search(reg) >= 0) { bootbox.alert(exp + ' 문자는 사용될 수 없습니다!', function () { searchTxt.focus(); }); return false; }

                $.ajax({
                    type: "POST",
                    url: "/EA/Common",
                    data: '{M:"' + m + '",body:"N", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",search:"' + searchTxt.val() + '",searchcol:"",page:"' + p.find('.modal-header :hidden[data-for="page"]').val() + '",count:"' + p.find('.modal-header :hidden[data-for="page-count"]').val() + '"}',
                    success: function (res) {
                        //res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
                        if (res.substr(0, 2) == 'OK') {
                            var cDel = String.fromCharCode(8);
                            var vRes = res.substr(2).split(cDel);

                            if (res.substr(2).indexOf(cDel) > 0) {
                                p.find('.modal-header .zf-modal-page').html(vRes[0]);
                                p.find('.modal-body').html(vRes[1]);
                            } else {
                                p.find('.modal-body').html(vRes[0]);
                            }

                            p.find('.zf-modal .z-lnk-navy[data-val]').click(function () {
                                var v = $(this).attr('data-val').split('^');
                                for (var i = 0; i < param.length; i++) {
                                    $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
                                }

                                if (vPos[1] == 'items' && param[0] == 'PARTNUM') {
                                    $.ajax({
                                        type: "POST",
                                        url: "/EA/Common",
                                        data: '{M:"' + m + '",body:"N",k1:"erp",k2:"specchange",k3:"detail",fc:"' + v[0] + '"}',
                                        success: function (res) {
                                            if (res.substr(0, 2) == 'OK') {
                                                res = res.substr(2); var iPos = res.indexOf(cDel);
                                                var v = res.substr(iPos + 1).split(';'); //console.log(v)
                                                var fld = ['CCD', 'CCH', 'CCt', 'CVH', 'CIC', 'CIS'];
                                                if (res.substr(0, 1) == 'Y') {
                                                } else {
                                                    $('#__mainfield[name="' + param[i] + '"]')
                                                }
                                            } else bootbox.alert(res);
                                        },
                                        beforeSend: function () { }
                                    });
                                }

                                p.modal('hide');
                            });

                            p.find('.zf-modal-page .btn[data-for]').click(function () {
                                p.find('.modal-header :hidden[data-for="page"]').val($(this).attr('data-for'));
                                searchBtn.click();
                            });
                        } else bootbox.alert(res);
                    }
                });
            });

            p.on('shown.bs.modal', function () { searchTxt.focus(); });
            p.on('hidden.bs.modal', function () { p.html(''); });
            p.modal();
        }
    }
});