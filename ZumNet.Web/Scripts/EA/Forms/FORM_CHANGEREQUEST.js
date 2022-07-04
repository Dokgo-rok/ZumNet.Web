$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            return true;
        },
        "make": function (f) {
        },
        "checkEvent": function (ckb, el, fld) {
            var t;
            if (fld == 'CHANGETYPE') {
                t = $('#__mainfield[name="ETCCHANGE"]');
                if (el.value == '기타1' && el.checked) t.removeClass('txtRead').addClass('txtText').prop('readonly', false).val('');
                else t.removeClass('txtText').addClass('txtRead').prop('readonly', true).val('');

            } else if (fld == 'LASTCHECK') {
                t = $('#__mainfield[name="LASTTRIPFROM"]');
                if (el.value == '필요' && el.checked) t.removeClass('txtRead').addClass('txtText').prop('readonly', false).val('').show();
                else if (el.value == '불필요' && el.checked) t.removeClass('txtText').addClass('txtRead').prop('readonly', false).val('    -  -  ').hide();

            } else if (fld == 'CHANGEREASON') {
                t = $('#__mainfield[name="ETCREASON"]');
                if (el.value == '기타2' && el.checked) t.removeClass('txtRead').addClass('txtText').prop('readonly', false).val('');
                else t.removeClass('txtText').addClass('txtRead').prop('readonly', true).val('');
            }
        },
        "calc": function (el) {
            if (el.name == "REVIEW1" || el.name == "REVIEW2" || el.name == "REVIEW3" || el.name == "REVIEW4" || el.name == "REVIEW5" || el.name == "REVIEW6" || el.name == "REVIEW7" || el.name == "REVIEW8" || el.name == "REVIEW9" || el.name == "REVIEW10" || el.name == "REVIEW11") {
                var s = _zw.ut.add(0, $('#__mainfield[name="REVIEW1"]').val(), $('#__mainfield[name="REVIEW2"]').val(), $('#__mainfield[name="REVIEW3"]').val()
                            , $('#__mainfield[name="REVIEW4"]').val(), $('#__mainfield[name="REVIEW5"]').val(), $('#__mainfield[name="REVIEW6"]').val(), $('#__mainfield[name="REVIEW7"]').val()
                            , $('#__mainfield[name="REVIEW8"]').val(), $('#__mainfield[name="REVIEW9"]').val(), $('#__mainfield[name="REVIEW10"]').val(), $('#__mainfield[name="REVIEW11"]').val());
                $('#__mainfield[name="TOTALREVIEW"]').val(numeral(s).format('0,0'));
            }
        },
        "autoCalc": function (p) {
        },
        "orgSelect": function (p, x) {
            p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
                var info = JSON.parse($(this).attr('data-attr')); //console.log(info)
                var dn = $(this).next().text();
                $('#__mainfield[name="NEXTWORKER"]').val(dn);
                $('#__mainfield[name="NEXTWORKERID"]').val(info["id"]);
                $('#__mainfield[name="NEXTWORKERDEPT"]').val(info["grdn"]);
                $('#__mainfield[name="NEXTWORKERDEPTID"]').val(info["grid"]);
            });
            p.modal('hide');
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