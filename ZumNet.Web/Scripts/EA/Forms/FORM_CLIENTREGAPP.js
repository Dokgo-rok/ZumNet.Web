$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            return true;
        },
        "make": function (f) {
        },
        "checkEvent": function (ckb, el, fld) { console.log(ckb + " : " + fld)
            if (fld == 'CLIENT_TYPE') {
                var bCheck = el.checked;
                if (el.value == 'CUST') {
                    $(':checkbox[name="ckbPRODUCER_TYPE"]').prop('checked', false).prop('disabled', bCheck);
                    $('#__mainfield[name="PRODUCER_TYPE"]').val('');

                    $(':checkbox[name="ckbCUST_TYPE"]').prop('checked', false).prop('disabled', false);
                    $('#__mainfield[name="CUST_TYPE"]').val('');
                } else if (el.value == 'PROD') {
                    $(':checkbox[name="ckbPRODUCER_TYPE"]').prop('checked', false).prop('disabled', false);
                    $('#__mainfield[name="PRODUCER_TYPE"]').val('');

                    $(':checkbox[name="ckbCUST_TYPE"]').prop('checked', false).prop('disabled', bCheck);
                    $('#__mainfield[name="CUST_TYPE"]').val('');
                }
            } else if (fld == 'BILLTO') {
                if (el.checked) {
                    $('#__mainfield[name="COUNTRY2"]').val($('#__mainfield[name="COUNTRY"]').val());
                    $('#__mainfield[name="COUNTRYCODE2"]').val($('#__mainfield[name="COUNTRYCODE"]').val());
                    $('#__mainfield[name="CLIENT_NAME2"]').val($('#__mainfield[name="CLIENT_NAME"]').val());
                    $('#__mainfield[name="ADDRES2"]').val($('#__mainfield[name="ADDRES"]').val());
                    $('#__mainfield[name="SOCIAL_NUMBER"]').val($('#__mainfield[name="CLIENT_NUMBER"]').val());
                } else {
                    $('#__mainfield[name="COUNTRY2"]').val(''); $('#__mainfield[name="COUNTRYCODE2"]').val(''); $('#__mainfield[name="CLIENT_NAME2"]').val('');
                    $('#__mainfield[name="ADDRES2"]').val(''); $('#__mainfield[name="SOCIAL_NUMBER"]').val('');
                }
            }
        },
        "calc": function (e) {
        },
        "autoCalc": function (p) {
        },
        "optionWnd": function (pos, w, h, m, n, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.'); //console.log(arguments)
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]); //console.log(param);
            var m = '', v1 = '', v2 = '', v3 = '';
            if (vPos[0] == 'erp') {
                m = 'getoracleerp';
            } else if (vPos[0] == 'report') {
                m = 'getreportsearch';
                if (vPos[1] != 'ERP_FACTORY') {
                    v1 = $('#__mainfield[name="COMPANYCODE"]').val();
                    if (v1 == '') { bootbox.alert('법인코드를 입력하세요!'); return false; }
                }
            } else m = 'getcodedescription';

            $.ajax({
                type: "POST",
                url: "/EA/Common",
                data: '{M:"' + m + '", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",fn:"",query:"",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:""}',
                success: function (res) {
                    if (res.substr(0, 2) == 'OK') {
                        var p = $('#popBlank');
                        p.html(res.substr(2)).find('.modal-title').html(el.attr('title'));
                        if (el.attr('title') == '지급조건' || el.attr('title') == '주문유형') p.find(".modal-dialog").css("max-width", "30rem");
                        else if (m == 'getcodedescription') p.find(".modal-dialog").css("max-width", "15rem");
                        //p.find(".modal-content").css("height", h + "px")

                        p.find('.zf-modal .z-lnk-navy[data-val]').click(function () {
                            var v = $(this).attr('data-val').split('^');
                            for (var i = 0; i < param.length; i++) {
                                $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
                                //console.log(param[i] + " : " + $('#__mainfield[name="' + param[i] + '"]').val());
                            }
                            p.modal('hide');
                        });

                        $('.zf-modal input:text.z-input-in').keyup(function (e) {
                            if (e.which == 13) {
                                $('#__mainfield[name="' + param[0] + '"]').val($(this).val());
                                p.modal('hide');
                            }
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
            var m = 'getreportsearch', v1 = '', v2 = '', v3 = '';

            var s = '<div class="zf-modal modal-dialog modal-dialog-centered modal-dialog-scrollable">'
                + '<div class="modal-content" data-for="' + vPos[1] + '" style="box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.5)">'
                + '<div class="modal-header">'
                + '<div class="input-group w-50">'
                + '<input type="text" class="form-control" placeholder="' + (el.attr('title') != '' ? el.attr('title') + ' ' : '' ) + '검색" value="">'
                + '<span class="input-group-append"><button class="btn btn-secondary" type="button"><i class="fe-search"></i></button></span>'
                + '</div>'
                + '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>'
                + '</div >'
                + '<div class="modal-body"></div>'
                + '</div></div>';

            var p = $('#popBlank');
            p.html(s).find(".modal-dialog").css("max-width", "30rem").find(".modal-content").css("min-height", "20rem");

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
                    data: '{M:"' + m + '",only:"", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",fn:"",query:"",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:"' + searchTxt.val() + '"}',
                    success: function (res) {
                        if (res.substr(0, 2) == 'OK') {
                            p.find('.modal-body').html(res.substr(2));

                            p.find('.zf-modal .z-lnk-navy[data-val]').click(function () {
                                var v = $(this).attr('data-val').split('^');
                                for (var i = 0; i < param.length; i++) {
                                    $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
                                }
                                p.modal('hide');
                            });

                            $('.zf-modal input:text.z-input-in').keyup(function (e) {
                                if (e.which == 13) {
                                    $('#__mainfield[name="' + param[0] + '"]').val($(this).val());
                                    p.modal('hide');
                                }
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