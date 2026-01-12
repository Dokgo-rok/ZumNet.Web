$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            var rt = true;
            if (cmd == "draft") { //기안
                var eType = $('#__mainfield[name="CLIENT_TYPE"]'), eType2, eCT = $('#__mainfield[name="COUNTRY_TYPE"]');
                if (eCT.length > 0 && $.trim(eCT.val()) == '') { bootbox.alert("필수항목 [국내외구분] 누락!"); rt = false; return false; }

                var v, e, f, v1, v2, chk = $('#__mainfield[name="CLIENT_NUMBER"]');
                if (eType.val() == 'CUST') { //고객
                    eType2 = $('#__mainfield[name="CUST_TYPE"]');
                    if (eType2.length > 0 && $.trim(eType2.val()) == '') { bootbox.alert("필수항목 [고객구분] 누락!"); rt = false; return false; }

                    if (eCT.val() == 'LO') { //국내
                        if (eType2.val() == 'COMPANY') v = 'COUNTRY;국가^CLIENT_NUMBER;사업자등록번호^INDUSTRY_CLASS;업태^INDUSTRY_SUBCLASS;업종^TAXBLE_PERSON;대표자^ADDRES;주소^TAXMANAGER;세금계산서담당자^TAXEMAIL;메일'.split('^');
                        else if (eType2.val() == 'PEOPLE') { v = 'COUNTRY;국가^SOCIAL_NUMBER;주민등록번호^ADDRES;주소^TAXMANAGER;세금계산서담당자^TAXEMAIL;메일'.split('^'); chk = $('#__mainfield[name="SOCIAL_NUMBER"]'); }
                        else if (eType2.val() == 'PUBLIC') v = 'COUNTRY;국가^CLIENT_NUMBER;고유번호(사업자등록번호)^TAXBLE_PERSON;대표자^ADDRES;주소^TAXMANAGER;세금계산서담당자^TAXEMAIL;메일'.split('^');
                    } else if (eCT.val() == 'DI') { //국외
                        v = 'COUNTRY;국가^TAXBLE_PERSON;대표자^ADDRES;주소'.split('^');
                    }

                    v1 = 'C';
                    
                } else if (eType.val() == 'PROD') { //공급자
                    eType2 = $('#__mainfield[name="PRODUCER_TYPE"]');
                    if (eType2.length > 0 && $.trim(eType2.val()) == '') { bootbox.alert("필수항목 [공급자구분] 누락!"); rt = false; return false; }

                    if (eCT.val() == 'LO') { //국내
                        if (eType2.val() == 'SUPPLIER' || eType2.val() == 'OSP') v = 'COUNTRY;국가^CLIENT_NUMBER;사업자등록번호^INDUSTRY_CLASS;업태^INDUSTRY_SUBCLASS;업종^TAXBLE_PERSON;대표자^ADDRES;주소^TAXRATE;세금구분^CUST_PAYMENT;결제조건^TAXEXPL;세목^PAYMENTMTD;지급수단^CURRENCY2;통화^ACCOUNTDN2;채무계정^PAYMENT_BANK;지급은행^ACCOUNT_DOMESTIC;계좌번호^BANK_CALLDATE;수취인명^MANAGER;영업담당자^EMAIL;메일^TEL;연락처'.split('^');
                        else if (eType2.val() == 'EMPLOYEE') v = 'COUNTRY;국가^PAYMENT_BANK;지급은행^ACCOUNT_DOMESTIC;계좌번호^BANK_CALLDATE;수취인명'.split('^');
                    } else if (eCT.val() == 'DI') { //국외
                        if (eType2.val() == 'SUPPLIER' || eType2.val() == 'OSP') v = 'COUNTRY;국가^TAXBLE_PERSON;대표자^ADDRES;주소^CUST_PAYMENT;결제조건^PAYMENTMTD;지급수단^CURRENCY2;통화^ACCOUNTDN2;채무계정^PAYMENT_BANK;지급은행^ACCOUNT_DOMESTIC;계좌번호^BANK_CALLDATE;수취인명^ACCOUNT_FOREIGN;SWIFT CODE^MANAGER;영업담당자^EMAIL;메일^TEL;연락처'.split('^');
                        else if (eType2.val() == 'EMPLOYEE') v = 'COUNTRY;국가^CURRENCY2;통화^ACCOUNTDN2;채무계정^PAYMENT_BANK;지급은행^ACCOUNT_DOMESTIC;계좌번호^BANK_CALLDATE;수취인명^ACCOUNT_FOREIGN;SWIFT CODE'.split('^');
                    }

                    v1 = 'V';
                }

                for (var i = 0; i < v.length; i++) {
                    f = v[i].split(';'); //console.log(i + " : " + f);
                    e = $('#__mainfield[name="' + f[0] + '"]');
                    if (e.length > 0 && $.trim(e.val()) == '') { bootbox.alert("필수항목 [" + f[1] + "] 누락!", function () { e.focus(); }); rt = false; return false; }

                }

                //사업자번호(고유번호) 또는 주민번호 중복 체크
                v2 = $('#__mainfield[name="COMPANYCODE"]').val();
                if (chk.length > 0 && chk.val() != '') {
                    $.ajax({
                        type: "POST",
                        url: "/EA/Common",
                        data: '{M:"getreportsearch",body:"S", k1:"report",k2:"ERP_CHKBIZNUM",k3:"' + '' + '",etc:"",query:"",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + chk.val() + '",search:""}',
                        async: false,
                        success: function (res) {
                            if (res == "OK") rt = true;
                            else { bootbox.alert(res, function () { chk.focus(); }); rt = false; }
                        },
                        beforeSend: function () { } //로딩 X
                    });
                }
            }
            return rt;
        },
        "make": function (f) {
        },
        "checkEvent": function (ckb, el, fld) {
            //console.log(ckb + " : " + fld + " : " + el.value)
            //if (fld == 'CLIENT_TYPE') {
            //    var bCheck = el.checked;
            //    if (el.value == 'CUST') {
            //        $(':checkbox[name="ckbPRODUCER_TYPE"]').prop('checked', false).prop('disabled', bCheck);
            //        $('#__mainfield[name="PRODUCER_TYPE"]').val('');

            //        $(':checkbox[name="ckbCUST_TYPE"]').prop('checked', false).prop('disabled', false);
            //        $('#__mainfield[name="CUST_TYPE"]').val('');
            //    } else if (el.value == 'PROD') {
            //        $(':checkbox[name="ckbPRODUCER_TYPE"]').prop('checked', false).prop('disabled', false);
            //        $('#__mainfield[name="PRODUCER_TYPE"]').val('');

            //        $(':checkbox[name="ckbCUST_TYPE"]').prop('checked', false).prop('disabled', bCheck);
            //        $('#__mainfield[name="CUST_TYPE"]').val('');
            //    }
            //} else if (fld == 'BILLTO') {
            //    if (el.checked) {
            //        $('#__mainfield[name="COUNTRY2"]').val($('#__mainfield[name="COUNTRY"]').val());
            //        $('#__mainfield[name="COUNTRYCODE2"]').val($('#__mainfield[name="COUNTRYCODE"]').val());
            //        $('#__mainfield[name="CLIENT_NAME2"]').val($('#__mainfield[name="CLIENT_NAME"]').val());
            //        $('#__mainfield[name="ADDRES2"]').val($('#__mainfield[name="ADDRES"]').val());
            //        $('#__mainfield[name="SOCIAL_NUMBER"]').val($('#__mainfield[name="CLIENT_NUMBER"]').val());
            //    } else {
            //        $('#__mainfield[name="COUNTRY2"]').val(''); $('#__mainfield[name="COUNTRYCODE2"]').val(''); $('#__mainfield[name="CLIENT_NAME2"]').val('');
            //        $('#__mainfield[name="ADDRES2"]').val(''); $('#__mainfield[name="SOCIAL_NUMBER"]').val('');
            //    }
            //}

            if (fld == 'PRODUCER_TYPE') {
                var b = $('#btnOrganChart');
                if (el.value == 'EMPLOYEE') {
                    $('#__mainfield[name="CLIENT_NAME"]').css('width', '90%').prop('readonly', true).val('');
                    b.removeClass('d-none');
                } else {
                    if (!b.hasClass('d-none')) b.addClass('d-none');
                    $('#__mainfield[name="CLIENT_NAME"]').css('width', '100%').prop('readonly', false).val('');
                }
            }
        },
        "calc": function (e) {
        },
        "autoCalc": function (p) {
        },
        "orgSelect": function (p, x) {
            p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
                var info = JSON.parse($(this).attr('data-attr')); //console.log(info)
                var dn = $(this).next().text();
                $('#__mainfield[name="CLIENT_NAME"]').val(info["empid"] + "-" + dn);
            });
            p.modal('hide');
        },
        "change": function (x, fld) {
            $('#__mainfield[name="' + fld + '"]').val($(x).children('option:selected').text());

            var s = $(x).val(), eCust = $('.m [data-for="CUST"]'), eProd = $('.m [data-for="PROD"]');
            if (s == 'CUST') {
                if (eCust.hasClass('d-none')) eCust.removeClass('d-none');
                if (!eProd.hasClass('d-none')) eProd.addClass('d-none');
            } else if (s == 'PROD') {
                if (!eCust.hasClass('d-none')) eCust.addClass('d-none');
                if (eProd.hasClass('d-none')) eProd.removeClass('d-none');
            } else {
                if (!eCust.hasClass('d-none')) eCust.addClass('d-none');
                if (!eProd.hasClass('d-none')) eProd.addClass('d-none');
            }

            eCust.find('#__mainfield').val(''); eCust.find('input[type="checkbox"]').prop('checked', false);
            eProd.find('#__mainfield').val(''); eProd.find('input[type="checkbox"]').prop('checked', false);

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

            //data body 조건 : N(modal-body 없음), F(footer 포함)
            $.ajax({
                type: "POST",
                url: "/EA/Common",
                data: '{M:"' + m + '",body:"", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",query:"",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:""}',
                success: function (res) {
                    //res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
                    if (res.substr(0, 2) == 'OK') {
                        var p = $('#popBlank');
                        p.html(res.substr(2)).find('.modal-title').html(el.attr('title'));
                        if (el.attr('title') == '결제조건' || el.attr('title') == '지급조건' || el.attr('title') == '주문유형') p.find(".modal-dialog").css("max-width", "30rem");
                        else p.find(".modal-dialog").css("max-width", "15rem");
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
                + '</div>'
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

                if (vPos[1] == 'ERP_COUNTRY2') searchTxt.val(searchTxt.val().toUpperCase());

                $.ajax({
                    type: "POST",
                    url: "/EA/Common",
                    data: '{M:"' + m + '",body:"N", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",fn:"",query:"",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:"' + searchTxt.val() + '"}',
                    success: function (res) {
                        //res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
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