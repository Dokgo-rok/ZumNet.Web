$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            return true;
        },
        "make": function (f) {
            if (_zw.V.act == "_reviewer" || _zw.V.act == "__r") _zw.body.mainCompare(f, false);
        },
        "checkEvent": function (ckb, el, fld) {
        },
        "calc": function (el) {
            var s = 0, f = '0,0.[00000]', f2 = '0,0.[00]';

            if (el.name == "PRICE1" || el.name == "UNITCOST") {
                s = _zw.ut.sub(5, $('#__mainfield[name="UNITCOST"]').val(), $('#__mainfield[name="PRICE1"]').val());
                $('#__mainfield[name="PRICE2"]').val(numeral(s).format(f)); s = 0;

                s = _zw.ut.rate($('#__mainfield[name="PRICE2"]').val(), $('#__mainfield[name="UNITCOST"]').val(), 4);
                $('#__mainfield[name="RATE1"]').val(numeral(s).format(f2));

            } else if (el.name == "PRELT" || el.name == "PROCLT" || el.name == "POSTLT") {
                s = _zw.ut.add(0, $('#__mainfield[name="PRELT"]').val(), $('#__mainfield[name="PROCLT"]').val(), $('#__mainfield[name="POSTLT"]').val());
                $('#__mainfield[name="TOTALLT"]').val(numeral(s).format('0,0'));

            } else if (el.name == "MONTHCOUNT") {
                s = parseFloat(_zw.ut.empty($('#__mainfield[name="MONTHCOUNT"]').val())) * 12;
                $('#__mainfield[name="YEARCOUNT"]').val(numeral(s).format('0,0'));

            } else if (el.name == "SUM1" || el.name == "SUM2" || el.name == "SUM4" || el.name == "SUM5" || el.name == "SUM22" || el.name == "SUM23"
                || el.name == "RATE2" || el.name == "RATE3" || el.name == "RATE4" || el.name == "RATE5" || el.name == "RATE6" || el.name == "RATE7") {

                var e11 = $('#__mainfield[name="SUM1"]'), e21 = $('#__mainfield[name="SUM2"]'), e31 = $('#__mainfield[name="SUM3"]');
                var e12 = $('#__mainfield[name="SUM4"]'), e22 = $('#__mainfield[name="SUM5"]'), e32 = $('#__mainfield[name="SUM6"]');
                var e13 = $('#__mainfield[name="SUM22"]'), e23 = $('#__mainfield[name="SUM23"]'), e33 = $('#__mainfield[name="SUM24"]');
                var e14 = $('#__mainfield[name="SUM7"]'), e24 = $('#__mainfield[name="SUM8"]'), e34 = $('#__mainfield[name="SUM9"]');//제조합
                var e15 = $('#__mainfield[name="SUM10"]'), e25 = $('#__mainfield[name="SUM11"]'), e35 = $('#__mainfield[name="SUM12"]');
                var e16 = $('#__mainfield[name="SUM13"]'), e26 = $('#__mainfield[name="SUM14"]'), e36 = $('#__mainfield[name="SUM15"]');
                var e17 = $('#__mainfield[name="SUM16"]'), e27 = $('#__mainfield[name="SUM17"]'), e37 = $('#__mainfield[name="SUM18"]');//판관합
                var e18 = $('#__mainfield[name="SUM19"]'), e28 = $('#__mainfield[name="SUM20"]'), e38 = $('#__mainfield[name="SUM21"]');//이윤
                var r11 = $('#__mainfield[name="RATE2"]'), r21 = $('#__mainfield[name="RATE3"]');
                var r12 = $('#__mainfield[name="RATE4"]'), r22 = $('#__mainfield[name="RATE5"]');
                var r13 = $('#__mainfield[name="RATE6"]'), r23 = $('#__mainfield[name="RATE7"]');//비율
                var t1 = $('#__mainfield[name="TOTALSUM1"]'), t2 = $('#__mainfield[name="TOTALSUM2"]'), t3 = $('#__mainfield[name="TOTALSUM3"]');//합계

                //차액
                s = _zw.ut.sub(5, e21.val(), e11.val()); e31.val(numeral(s).format(f)); s = 0;
                s = _zw.ut.sub(5, e22.val(), e12.val()); e32.val(numeral(s).format(f)); s = 0;
                s = _zw.ut.sub(5, e23.val(), e13.val()); e33.val(numeral(s).format(f)); s = 0;

                //제조합
                s = _zw.ut.add(5, e11.val(), e12.val(), e13.val()); e14.val(numeral(s).format(f)); s = 0;
                s = _zw.ut.add(5, e21.val(), e22.val(), e23.val()); e24.val(numeral(s).format(f)); s = 0;
                s = _zw.ut.add(5, e31.val(), e32.val(), e33.val()); e34.val(numeral(s).format(f)); s = 0;

                //판관(견적)
                if (r11.val() != "") { s = _zw.ut.percent(e14.val(), r11.val(), 4); e15.val(numeral(s).format(f)); s = 0; }
                if (r12.val() != "") { s = _zw.ut.percent(e14.val(), r12.val(), 4); e16.val(numeral(s).format(f)); s = 0; }
                s = _zw.ut.add(5, e15.val(), e16.val()); e17.val(numeral(s).format(f)); s = 0;

                //판관(네고)
                if (r21.value != "") { s = _zw.ut.percent(e24.val(), r21.val(), 4); e25.val(numeral(s).format(f)); s = 0; }
                if (r22.value != "") { s = _zw.ut.percent(e24.val(), r22.val(), 4); e26.val(numeral(s).format(f)); s = 0; }
                s = _zw.ut.add(5, e25.val(), e26.val()); e27.val(numeral(s).format(f)); s = 0;

                //판관(차액)
                s = _zw.ut.sub(5, e25.val(), e15.val()); e35.val(numeral(s).format(f)); s = 0;
                s = _zw.ut.sub(5, e26.val(), e16.val()); e36.val(numeral(s).format(f)); s = 0;
                s = _zw.ut.sub(5, e35.val(), e36.val()); e37.val(numeral(s).format(f)); s = 0;

                //이윤
                if (r13.value != "") { s = _zw.ut.percent(e14.val(), r13.val(), 4); e18.val(numeral(s).format(f)); s = 0; }
                if (r23.value != "") { s = _zw.ut.percent(e24.val(), r23.val(), 4); e28.val(numeral(s).format(f)); s = 0; }
                s = _zw.ut.sub(5, e28.val(), e18.val()); e38.val(numeral(s).format(f)); s = 0;

                //합계
                s = _zw.ut.add(5, e14.val(), e17.val(), e18.val()); t1.val(numeral(s).format(f)); s = 0;
                s = _zw.ut.add(5, e24.val(), e27.val(), e28.val()); t2.val(numeral(s).format(f)); s = 0;
                s = _zw.ut.add(5, e34.val(), e37.val(), e38.val()); t3.val(numeral(s).format(f)); s = 0;
            }
        },
        "autoCalc": function (p) {
        },
        "optionWnd": function (pos, w, h, l, t, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.'); //console.log(arguments)
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]); //console.log(param);
            var m = '', query = '', v1 = '', v2 = '', v3 = '', k3 = '';
            if (vPos[0] == 'erp') {
                m = 'getoracleerp';
                if (vPos[1] == 'bpanum') {
                    var e = $('#__mainfield[name="PRODUCTCENTER"]');
                    if (e.val() == '') { bootbox.alert('적용사업장을 선택하십시오!'); return false; } else { query = e.val(); }

                    e = $('#__mainfield[name="COMPANYCODE"]');
                    if (e.val() == '') { bootbox.alert('업체명을 선택하십시오!'); return false; } else { v1 = e.val(); }

                    e = $('#__mainfield[name="CURRENCY"]');
                    if (e.val() == '') { bootbox.alert('통화를 선택하십시오!'); return false; } else { v2 = e.val(); }

                    k3 = _zw.V.ft;
                }
            } else if (vPos[0] == 'report') m = 'getreportsearch';
            else m = 'getcodedescription';

            //data body 조건 : N(modal-body 없음), F(footer 포함)
            $.ajax({
                type: "POST",
                url: "/EA/Common",
                data: '{M:"' + m + '",body:"N", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + k3 + '",etc:"' + etc + '",query:"' + query + '",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:""}',
                success: function (res) {
                    //res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
                    if (res.substr(0, 2) == 'OK') {
                        //var p = $('#popBlank');
                        //p.html(res.substr(2)).find('.modal-title').html(el.attr('title'));
                        //if (el.attr('title') == '결제조건' || el.attr('title') == '지급조건' || el.attr('title') == '주문유형') p.find(".modal-dialog").css("max-width", "30rem");
                        //else p.find(".modal-dialog").css("max-width", "15rem");
                        ////p.find(".modal-content").css("height", h + "px")

                        //p.find('.zf-modal .z-lnk-navy[data-val]').click(function () {
                        //    var v = $(this).attr('data-val').split('^');
                        //    for (var i = 0; i < param.length; i++) {
                        //        $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
                        //        //console.log(param[i] + " : " + $('#__mainfield[name="' + param[i] + '"]').val());
                        //    }
                        //    p.modal('hide');
                        //});

                        //$('.zf-modal input:text.z-input-in').keyup(function (e) {
                        //    if (e.which == 13) {
                        //        $('#__mainfield[name="' + param[0] + '"]').val($(this).val());
                        //        p.modal('hide');
                        //    }
                        //});

                        //p.on('hidden.bs.modal', function () { p.html(''); });
                        //p.modal();

                        var j = { "close": true, "width": w, "height": h, "left": l, "top": t }
                        j["title"] = el.attr('title'); j["content"] = res.substr(2);

                        var pop = _zw.ut.popup(el[0], j); //console.log(param)
                        pop.find('a[data-val]').click(function () {
                            var v = $(this).attr('data-val').split('^');
                            if (param == 'BPANUM' && v[1] != 'Y') {
                                bootbox.alert('BPA Status is not APPROVED!'); return false;
                            }
                            for (var i = 0; i < param.length; i++) {
                                $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
                            }
                            pop.find('.close[data-dismiss="modal"]').click();
                        });

                    } else bootbox.alert(res);
                }
            });
        },
        "externalWnd": function (pos, w, h, m, n, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.'); //console.log(arguments)
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]); //console.log(param);
            var m = '', query = '', el2, v1 = '', v2 = '', v3 = '';
            if (vPos[0] == 'erp') m = 'getoracleerp';
            else if (vPos[0] == 'report') m = 'getreportsearch';
            else m = 'getcodedescription';

            if (pos == "erp.items" || pos == "erp.vendors" || pos == "erp.items1" || pos == "erp.items3") {
                el2 = $('#__mainfield[name="PRODUCTCENTER"]');
                if (el2.val() == '') { bootbox.alert('적용사업장을 선택하십시오!', function () { el2.focus(); }); return false; }

                if (pos == "erp.items3") {
                    if (el2.val() == "CD") query = "104";
                    else if (el2.val() == "CD2") query = "148";
                    else if (el2.val() == "CH") query = "102";
                    else if (el2.val() == "CT") query = "103";
                    else if (el2.val() == "IC") query = "105";
                    else if (el2.val() == "IS") query = "128";
                    else if (el2.val() == "VH") query = "108";
                    else if (el2.val() == "KH") query = "101";
                } else {
                    query = el2.val();
                }
                m = 'getoracleerp';
            }

            if (pos == 'erp.exchangerate') { //환율
                if ($('#__mainfield[name="CURRENCY"]').val() == '') { bootbox.alert('통화를 선택하십시오!', function () { }); return false; }
                v1 = $('#__mainfield[name="CURRENCY"]').val();
            }

            var sSelect = '';
            if (pos == "erp.vendors") sSelect = '<div class="input-group-prepend"><select class="form-control"><option value="VENDOR_NAME" selected>NAME</option><option value="SEGMENT1">CODE</option></select></div>'

            var s = '<div class="zf-modal modal-dialog modal-dialog-centered modal-dialog-scrollable">'
                + '<div class="modal-content" data-for="' + vPos[1] + '" style="box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.5)">'
                + '<div class="modal-header">'
                + '<div class="d-flex align-items-center w-100">'
                + '<div class="input-group w-50">'
                + sSelect
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

            var p = $('#popBlank'); p.html(s);
            var searchBtn = p.find('.zf-modal .modal-header .input-group .btn');
            var searchTxt = $('.zf-modal .modal-header .input-group :text');

            if (pos == "erp.exchangerate") {
                p.find(".modal-dialog").css("max-width", "20rem").find(".modal-content").css("min-height", "6rem");
                searchTxt.prop('readonly', true).val(moment(_zw.V.current.date).format('YYYY-MM-DD'));

            } else p.find(".modal-dialog").css("max-width", "35rem").find(".modal-content").css("min-height", "20rem");
           
            searchTxt.keyup(function (e) { if (e.which == 13) { searchBtn.click(); } });
            searchBtn.click(function () {
                if ($.trim(searchTxt.val()) == '' || searchTxt.val().length < 1) { bootbox.alert('검색어를 입력하십시오!', function () { searchTxt.focus(); }); return false; }
                var exp = "['\\%^&\"*]", reg = new RegExp(exp, 'gi');
                if (searchTxt.val().search(reg) >= 0) { bootbox.alert(exp + ' 문자는 사용될 수 없습니다!', function () { searchTxt.focus(); }); return false; }

                $.ajax({
                    type: "POST",
                    url: "/EA/Common",
                    data: '{M:"' + m + '",body:"N", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",query:"' + query + '",search:"' + searchTxt.val() + '",searchcol:"' + (p.find('.modal-header select').length > 0 ? p.find('.modal-header select').val() : '') + '",page:"' + p.find('.modal-header :hidden[data-for="page"]').val() + '",count:"' + p.find('.modal-header :hidden[data-for="page-count"]').val() + '",v1:"' + v1 + '"}',
                    success: function (res) {
                        //res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
                        if (res.substr(0, 2) == 'OK') {
                            var cDel = String.fromCharCode(8);
                            if (res.substr(2).indexOf(cDel) != -1) {
                                var vRes = res.substr(2).split(cDel);
                                p.find('.modal-header .zf-modal-page').html(vRes[0]);
                                p.find('.modal-body').html(vRes[1]);
                            } else {
                                p.find('.modal-body').html(res.substr(2));
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

            p.on('shown.bs.modal', function () {
                if (pos == "erp.exchangerate") searchTxt.datepicker({ autoclose: true, language: $('#current_culture').val() });
                else searchTxt.focus();
            });
            p.on('hidden.bs.modal', function () { p.html(''); });
            p.modal();
        }
    }
});