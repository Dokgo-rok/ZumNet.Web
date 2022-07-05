$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            var el = null;
            if (cmd == "draft") { //기안

            } else { //결재
                if (_zw.V.biz == "의견") {
                    el = $('#__mainfield[name="CONTENTS"]');
                    if (el.length > 0 && $.trim(el.val()) == '') {
                        bootbox.alert("필수항목 [기획조정실의견] 누락!", function () { el.focus(); }); return false;
                    }
                } else if (_zw.V.biz == "등급부서" && _zw.V.act == "_approver") {
                    el = $('#__mainfield[name="GRADE"]');
                    if (el.length > 0 && $.trim(el.val()) == '') {
                        bootbox.alert("필수항목 [개발등급] 누락!", function () { el.focus(); }); return false;
                    }
                } else if (_zw.V.biz == "생산지" && _zw.V.act == "_approver") {
                    el = $('#__mainfield[name="PRODUCTCENTER"]');
                    if (el.length > 0 && $.trim(el.val()) == '') {
                        bootbox.alert("필수항목 [생산지] 누락!", function () { el.focus(); }); return false;
                    }
                }
            }
            return true;
        },
        "make": function (f) {
            if (_zw.V.biz == "등급부서" && _zw.V.act == "_approver") _zw.body.main(f, ["GRADE", "SUPERVISION"]);
            else if (_zw.V.biz == "생산지" && _zw.V.act == "_approver") _zw.body.main(f, ["PRODUCTCENTER"]);
            else if (_zw.V.biz == "의견" && _zw.V.act == "_approver") _zw.body.main(f, ["CONTENTS"]);
        },
        "checkEvent": function (ckb, el, fld) {
            if (fld == 'EXMODELYN') {
                if (el.value == 'Y' && el.checked) $('#panEXMODEL').show();
                else $('#panEXMODEL').hide().find('input:text').val('');
            }
        },
        "calc": function (el) {
            var row = $(el).parent().parent(), p = row.parent().parent(); //console.log(p)
            var s = 0, s2 = 0, f = '0,0.[0000]';

            if (el.name == "PREDICTPRICE") {
                p.find('td :text[name="PREDICTPRICE"]').each(function (idx, e) { s += numeral(e.value).value(); })
                $('#__mainfield[name="TOTALSUM"]').val(numeral(s).format(f));
                $('#__mainfield[name="PREDICTINVEST"]').val(numeral(s).format(f));

            } else if (el.name == "PREDICTPRICE2") {
                p.find('td :text[name="PREDICTPRICE2"]').each(function (idx, e) { s += numeral(e.value).value(); })
                $('#__mainfield[name="TOTALSUM2"]').val(numeral(s).format(f));

            } else if (el.name == "DEVPRICEA" || el.name == "DEVPRICEBA" || el.name == "DEVPRICEBB" || el.name == "DEVPRICEC") {
                var s = _zw.ut.add(4, $('#__mainfield[name="DEVPRICEBA"]').val(), $('#__mainfield[name="DEVPRICEBB"]').val());
                $('#__mainfield[name="DEVPRICEB"]').val(numeral(s).format(f));

                s = _zw.ut.add(4, $('#__mainfield[name="DEVPRICEA"]').val(), $('#__mainfield[name="DEVPRICEB"]').val(), $('#__mainfield[name="DEVPRICEC"]').val());
                $('#__mainfield[name="DEVELOPPRICE"]').val(numeral(s).format(f));
            }

            _zw.formEx.calcForm(el);
        },
        "autoCalc": function (p) {
            var s = 0, f = '0,0.[0000]';

            p.find('td :text[name="PREDICTPRICE"]').each(function (idx, e) { s += numeral(e.value).value(); })
            $('#__mainfield[name="TOTALSUM"]').val(numeral(s).format(f));
            $('#__mainfield[name="PREDICTINVEST"]').val(numeral(s).format(f)); s = 0;

            p.find('td :text[name="PREDICTPRICE2"]').each(function (idx, e) { s += numeral(e.value).value(); })
            $('#__mainfield[name="TOTALSUM2"]').val(numeral(s).format(f));

            _zw.formEx.calcForm();
        },
        "calcForm": function (el) {
            var el1 = $('#__mainfield[name="SALEPRICE"]'), el2 = $('#__mainfield[name="DEVELOPPRICE"]'), el3 = $('#__mainfield[name="PLANCOUNT"]'),
                el4 = $('#__mainfield[name="PREDICTINVEST"]'), el5 = $('#__mainfield[name="PREDICTPERPROFIT"]'), el6 = $('#__mainfield[name="PREDICTSALES"]'),
                el7 = $('#__mainfield[name="PREDICTPROFIT"]'), el8 = $('#__mainfield[name="PREDICTRATE"]');

            if (el1.val() != '' && el2.val() != '' && el3.val() != '' && el4.val() != '') {
                var s = _zw.ut.sub(4, el1.val(), el2.val()), f = '0,0.[0000]';
                el5.val(numeral(s).format(f));

                var v1 = numeral(el1.val()).value(), v2 = numeral(el3.val()).value(); v1 = v1 || 0; v2 = v2 || 0; s = numeral(v1).multiply(v2);
                el6.val(numeral(s).format(f));

                v1 = numeral(el5.val()).value(), v2 = numeral(el3.val()).value(); v1 = v1 || 0; v2 = v2 || 0; s = numeral(v1).multiply(v2);
                s = _zw.ut.sub(4, numeral(s).format(f), el4.val()); el7.val(numeral(s).format(f)); s = 0;

                s = _zw.ut.rate(el7.val(), el6.val(), 4); console.log(el7.val() + " : " + el6.val() + " : " + s)
                el8.val(numeral(s).format(f));
            }
        },
        "optionWnd": function (pos, w, h, l, t, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.');
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]);
            var m = '', v1 = '', v2 = '', v3 = '';
            if (vPos[0] == 'erp') m = 'getoracleerp';
            else if (vPos[0] == 'report') m = 'getreportsearch';
            else m = 'getcodedescription';

            //data body 조건 : N(modal-body 없음), F(footer 포함)
            $.ajax({
                type: "POST",
                url: "/EA/Common",
                data: '{M:"' + m + '",body:"N", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",fn:"",query:"",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:""}',
                success: function (res) {
                    //res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
                    if (res.substr(0, 2) == 'OK') {
                        //var p = $('#popBlank');
                        //p.html(res.substr(2)).find('.modal-title').html(el.attr('title'));
                        //if (m == 'getcodedescription') p.find(".modal-dialog").css("max-width", "15rem");

                        //p.find('.zf-modal .z-lnk-navy[data-val]').click(function () {
                        //    var v = $(this).attr('data-val').split('^');
                        //    for (var i = 0; i < param.length; i++) {
                        //        $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
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

                        var pop = _zw.ut.popup(el[0], j);
                        pop.find('a[data-val]').click(function () {
                            var v = $(this).attr('data-val').split('^');
                            for (var i = 0; i < param.length; i++) {
                                $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
                            }
                            pop.find('.close[data-dismiss="modal"]').click();
                        });

                        pop.find('input:text.z-input-in').keyup(function (e) {
                            if (e.which == 13) {
                                $('#__mainfield[name="' + param[0] + '"]').val($(this).val());
                                pop.find('.close[data-dismiss="modal"]').click();
                            }
                        });

                    } else bootbox.alert(res);
                }
            });
        },
        "externalWnd": function (pos, w, h, m, n, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.'); //console.log(arguments)
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]); //console.log(param);
            var m = '', v1 = '', v2 = '', v3 = '';
            if (vPos[0] == 'erp') m = 'getoracleerp';
            else if (vPos[0] == 'report') m = 'getreportsearch';
            else m = 'getcodedescription';

            if (pos == 'erp.exchangerate') { //환율
                if ($('#__mainfield[name="CURRENCY"]').val() == '') { bootbox.alert('통화를 선택하십시오!', function () { }); return false; }
                v1 = $('#__mainfield[name="CURRENCY"]').val();
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

            var p = $('#popBlank'); p.html(s);
            var searchBtn = p.find('.zf-modal .modal-header .input-group .btn');
            var searchTxt = $('.zf-modal .modal-header .input-group :text');

            if (pos == "erp.exchangerate") {
                p.find(".modal-dialog").css("max-width", "20rem").find(".modal-content").css("min-height", "6rem");
                searchTxt.prop('readonly', true).val(moment(_zw.V.current.date).format('YYYY-MM-DD'));

            } else p.find(".modal-dialog").css("max-width", "30rem").find(".modal-content").css("min-height", "20rem");

            searchTxt.keyup(function (e) { if (e.which == 13) { searchBtn.click(); } });
            searchBtn.click(function () {
                if ($.trim(searchTxt.val()) == '' || searchTxt.val().length < 1) { bootbox.alert('검색어를 입력하십시오!', function () { searchTxt.focus(); }); return false; }
                var exp = "['\\%^&\"*]", reg = new RegExp(exp, 'gi');
                if (searchTxt.val().search(reg) >= 0) { bootbox.alert(exp + ' 문자는 사용될 수 없습니다!', function () { searchTxt.focus(); }); return false; }

                $.ajax({
                    type: "POST",
                    url: "/EA/Common",
                    data: '{M:"' + m + '",body:"N", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",search:"' + searchTxt.val() + '",searchcol:"",page:"' + p.find('.modal-header :hidden[data-for="page"]').val() + '",count:"' + p.find('.modal-header :hidden[data-for="page-count"]').val() + '",v1:"' + v1 + '"}',
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