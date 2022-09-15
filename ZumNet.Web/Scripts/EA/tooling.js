//금형관리 메인, 리스트뷰
$(function () {
    _zw.fn.input($('#__FormView .m'));

    if (_zw.V.mode == "read") {
        $.ajax({
            type: "POST",
            url: "/Form/ViewCount",
            data: '{xf:"' + _zw.V.xfalias + '",mi:"' + _zw.V.appid + '",actor:"' + _zw.V.current["urid"] + '",fdid:"0",wi:"",wn:"0"}',
            success: function (res) {
                if (res != "OK") bootbox.alert(res);
                //else _zw.fn.reloadList();
            },
            beforeSend: function () {//pace.js 충돌
            }
        });
    }

    var sw = window.screen.availWidth, sh = window.screen.availHeight, w = $('#__FormView .m').outerWidth() + 100;
    //console.log(sw + " : " + sh + " : " + fw)
    if (sw < 860) {
        window.moveTo(1, 1); window.resizeTo(sw, sh);
    } else if (sw < w) {
        window.moveTo(1, 10); window.resizeTo(sw, sh - 20);
    } else {
        window.moveTo(sw / 2 - w / 2, 10); window.resizeTo(w < 900 ? 900 : w, sh - 20);
    }

    _zw.fu.bind();

    $('.zf-menu .btn[data-zf-menu]').click(function () {
        var mn = $(this).attr('data-zf-menu');
        switch (mn) {
            case "preview":
                if (_zw.V.mode == 'read') {
                    var url = "/EA/Form/Preview";
                    _zw.ut.openWnd(url, "preview", $('body').outerWidth(), $('body').outerHeight(), "resize");
                }
                break;

            case "fileAttach":
                $('#popUploader').modal();
                break;

            case "update":
                var qi = '{M:"edit",mi:"' + _zw.V.appid + '",fi:"' + _zw.V.formid + '",xf:"' + _zw.V.xfalias + '"}';
                window.location.href = '?qi=' + _zw.base64.encode(qi);
                break;
            case "register":
                //console.log($('#__subtable1[name]').length)
                if (!_zw.form.validation()) return false;
                _zw.fn.sendForm();
                break;
            default:
                break;
        }
        $(this).tooltip('hide');
    });

    _zw.fn.sendForm = function () {
        var jSend = {};
        jSend["M"] = _zw.V.mode == 'new' ? 'newregisterformnotea' : 'editregisterformnotea';

        _zw.body.common(jSend);
        if (_zw.V.mode == 'edit') _zw.body.mainCompare(jSend["form"], true, ["CREATE_DATE", "MODIFY_DATE"]);
        else _zw.body.main(jSend["form"]);

        _zw.body.sub(jSend["form"]);
        _zw.body.file(jSend);
        //console.log(jSend); return

        var szMsg = _zw.V.mode == 'new' ? '등록' : '수정';
        bootbox.confirm('금형대장 ' + szMsg + ' 하시겠습니까?', function (rt) {
            if (rt) {
                $.ajax({
                    type: "POST",
                    url: "/EA/Process",
                    data: JSON.stringify(jSend),
                    success: function (res) {
                        if (res == "OK") {
                            _zw.fn.reloadList(); window.close();
                        } else bootbox.alert(res);
                    },
                    beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
                });
            }
        });
    }

    _zw.fn.orgSelect = function (p, x) {
        p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
            var info = JSON.parse($(this).attr('data-attr')); console.log(info)
            var dn = $(this).next().text();
            $('#__mainfield[name="CHARGE_USER"]').val(dn);
            $('#__mainfield[name="CHARGE_USER_ID"]').val(info["id"]);
            $('#__mainfield[name="CHARGE_USER_EMPNO"]').val(info["empid"]);
            $('#__mainfield[name="TRIPPERSONGRADE"]').val(info["grade"]);
            $('#__mainfield[name="DEPT_NAME"]').val(info["grdn"]);
            $('#__mainfield[name="DEPT_CODE"]').val(info["gralias"]);
        });
        p.modal('hide');
    }

    _zw.fn.onblur = function (e, v) {
        if (v[0] == "number" || v[0] == "number-n" || v[0] == "percent") {
            var e1, e2, e3, e4;
            var s = 0, f = '0,0.[0000]';
            if (e.name == 'PRODUCTION_COST' || e.name == 'PRODUCTION_CURRENCY') {
                e1 = $('#__mainfield[name="PRODUCTION_CURRENCY"]'); e2 = $('#__mainfield[name="PRODUCTION_COST"]');
                if (e1.val() != '' && e2.val() != '') {
                    var v = e1.val() == 'USD' ? 1 : _zw.formEx.exchangeRate('USD', e1.val(), _zw.V.current.date.substr(0, 10), 'Cost_Corporate');
                    s = parseFloat(_zw.ut.empty(e2.val())) * parseFloat(v); //console.log(s)
                    $('#__mainfield[name="EXCHANGE_USD"]').val(numeral(s).format(f)); //console.log($('#__mainfield[name="EXCHANGE_USD"]').val());
                }
            } else if (e.name == 'ABLCAVITY' || e.name == 'WATERPER' || e.name == 'CYCLETIME' || e.name == 'PRODHR') {
                e1 = $('#__mainfield[name="ABLCAVITY"]'); e2 = $('#__mainfield[name="WATERPER"]');
                e3 = $('#__mainfield[name="CYCLETIME"]'); e4 = $('#__mainfield[name="PRODHR"]');

                s = parseFloat(_zw.ut.empty(e1.val())) * parseFloat(_zw.ut.empty(e2.val())) * (parseFloat(_zw.ut.empty(e4.val())) / parseFloat(_zw.ut.empty(e3.val()))) * 60 * 60;
                $('#__mainfield[name="ONEDAY"]').val(numeral(s).format(f));

            } else if (e.name == 'ONEMON') {
                e1 = $('#__mainfield[name="ONEDAY"]'); e2 = $('#__mainfield[name="ONEMON"]');
                s = parseFloat(_zw.ut.empty(e1.val())) * parseFloat(_zw.ut.empty(e2.val()))
                $('#__mainfield[name="ONEMONCAP"]').val(numeral(s).format(f));
            }

        } else if (v[0] == "date" || v[0] == "time") {
            var from, to;
            if (e.name == "MAKE_FROM" || e.name == "MAKE_TO") {
                from = $('#__mainfield[name="MAKE_FROM"]'); to = $('#__mainfield[name="MAKE_TO"]');
            } else if (e.name == "TEST_FROM" || e.name == "TEST_TO") {
                from = $('#__mainfield[name="TEST_FROM"]'); to = $('#__mainfield[name="TEST_TO"]');
            }
            if (from && from.length > 0 && to && to.length > 0) {
                var dif = _zw.ut.diff('day', to.val(), from.val()); //console.log(dif + " : " + !(dif))
                if (dif && dif < 0) { bootbox.alert('날짜 범위 입력 오류!', function () { to.val(''); to.focus(); }); return false; }
            }
        }
    }

    _zw.fn.reloadList = function (opt) {
        try {
            if (opener != null) {
                if (opener._zw.fn.reloadList) {
                    opt = opt || 'tooling'; opener._zw.fn.reloadList(opt);
                } else if (opener._zw.fn.goSearch) {
                    opener._zw.fn.goSearch();
                } else opener.location.reload();
            }
        } catch (e) {
            //opener.location.reload();
        };
    }

    _zw.form = {
        "checkYN": function (ckb, el, fld) {
            $(':checkbox[name="' + ckb + '"]').each(function (idx, e) {
                if (el != e) { if (e.checked) e.checked = false; }
            });
            if (fld) {
                $('input[name="' + fld + '"]').val(fld != '' && el.checked ? el.value : '');
            }
            if (_zw.formEx.checkEvent) _zw.formEx.checkEvent(ckb, el, fld);
        },
        "validation": function () {
            if (!_zw.formEx.checkToolingTagNo()) return false;

            var fld = ["ORG_NAME", "DIVISION", "MODELNO", "POSSESION", "BUYER_NAME", "MAKE_SUPPLIER_NAME", "MAKE_FROM", "MAKE_TO", "PRODUCTION_COST", "CAVITY"];
            var fldLabel = ["사업장", "제작구분", "적용모델", "소유구분", "BUYER", "제작처", "제작기간(부터)", "제작기간(까지)", "제작비용", "CAVITY"];
            var sMsg = '필수항목 [$field] 누락!';
            var el;
            for (var x in fld) {
                el = fld[x] == 'MODELNO' ? $('#__subtable1[name="' + fld[x] + '"]') : $('#__mainfield[name="' + fld[x] + '"]');
                if ($.trim(el.val()) == '') { bootbox.alert(sMsg.replace('$field', fldLabel[x]), function () { try { el.focus(); } catch { } }); return false; }
            }
            return true;
        }
    }

    _zw.formEx = {
        "checkEvent": function (ckb, el, fld) {
            if (fld == 'WHOMONEY') {
                if (el.checked && el.value == '고객') $(':checkbox[name="ckbWHOMONEYDETAIL"]').prop('disabled', false).prop('checked', false);
                else $(':checkbox[name="ckbWHOMONEYDETAIL"]').prop('disabled', true).prop('checked', false);
            }
        },
        "change": function () {
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

                        var j = { "close": true, "width": w, "height": h, "left": l, "top": t }
                        j["title"] = el.attr('title'); j["content"] = res.substr(2);

                        var pop = _zw.ut.popup(el[0], j);
                        pop.find('a[data-val]').click(function () {
                            var v = $(this).attr('data-val').split('^');
                            for (var i = 0; i < param.length; i++) {
                                $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
                                if (param[i] == 'PRODUCTION_CURRENCY') _zw.fn.onblur($('#__mainfield[name="' + param[i] + '"]')[0], ['number']);
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
                + '<div class="input-group wd-70 wd-lg-60 wd-xl-60">';

            if (pos == 'erp.vendors') s += '<select class="custom-select"><option value="VENDOR_NAME">NAME</option><option value="SEGMENT1">CODE</option></select>';
            else if (pos == 'erp.vendors2') s += '<select class="custom-select"><option value="CUSTOMER_NAME">NAME</option><option value="CUSTOMER_NUMBER">CODE</option></select>';
            else if (pos == 'erp.saleitems') s += '<select class="custom-select"><option value="SEGMENT1">품번</option><option value="DESCRIPTION">품명</option></select>';
            else if (pos == 'erp.vendorcustomer') {
                var szCd = (etc == "BUYER") ? "CUSTOMER_NUMBER" : "SEGMENT1", szNm = (etc == "BUYER") ? "CUSTOMER_NAME" : "VENDOR_NAME";
                s += '<select class="custom-select"><option value="' + szNm + '">NAME</option><option value="' + szCd + '">CODE</option></select>';
            } else if (pos == 'erp.vendors2') s += '<select class="custom-select"><option value="CUSTOMER_NAME">NAME</option><option value="CUSTOMER_NUMBER">CODE</option></select>';

            s += '<input type="text" class="form-control" placeholder="' + (el.attr('title') != '' ? el.attr('title') + ' ' : '') + '검색" value="">'
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
            var searchCol = $('.zf-modal .modal-header .input-group select');

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
                    data: '{M:"' + m + '",body:"N", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",search:"' + searchTxt.val() + '",searchcol:"' + (searchCol.length > 0 ? searchCol.val() : '') + '",page:"' + p.find('.modal-header :hidden[data-for="page"]').val() + '",count:"' + p.find('.modal-header :hidden[data-for="page-count"]').val() + '",v1:"' + v1 + '"}',
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
                                var v = $(this).attr('data-val').split('^'); //console.log(param + " : " + v)
                                for (var i = 0; i < param.length; i++) {
                                    if (pos == 'erp.items') $('#__subtable1[name="' + param[i] + '"]').val(v[i]);
                                    else $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
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
        },
        "exchangeRate": function (fc, tc, cd, ct) {
            var rt = '';
            $.ajax({
                type: "POST",
                url: "/EA/Common",
                async: false,
                data: '{M:"getoracleerp",body:"N", k1:"erp",k2:"exchangerate",k3:"detail",fc:"' + fc + '",tc:"' + tc + '",cd:"' + cd + '",ct:"' + ct + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == 'OK') {
                        var v = res.substr(2).split(String.fromCharCode(8));
                        if (v[0] == 'Y') rt = v[1];
                        else bootbox.alert(v[0]);
                    } else bootbox.alert(res);
                }, beforeSend: function () {}
            });
            return rt;
        },
        "checkToolingTagNo": function () {
            var el = $('#__mainfield[name="TOOLING_TAGNO"]');
            if ($.trim(el.val()) == '' || el.val().toUpperCase() == 'NONE') return true;

            var exp = "['\\%^&\"*]", reg = new RegExp(exp, 'gi');
            if (el.val().search(reg) >= 0) { bootbox.alert(exp + ' 문자는 사용될 수 없습니다!', function () { el.focus(); }); return false; }

            var rt = false;
            $.ajax({
                type: "POST",
                url: "/EA/Common",
                async: false,
                data: '{M:"gettooling",body:"N", k1:"",k2:"CHECK_TAGNO",k3:"' + '' + '",no:"' + el.val() + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == 'OK') rt = true;
                    else if (res.substr(0, 2) == 'DU') {
                        if (_zw.V.mode == 'edit' && _zw.V.appid != '') rt = true;
                        else bootbox.alert('중복된 번호입니다!', function () { el.val(''); el.focus(); });
                    } else bootbox.alert(res);
                },
                beforeSend: function () { }
            });
            return rt;
        },
        "autoComplete": function (pos, w, h, l, t) {
            var el = event.target, vPos = pos.split('.');
            if (event.which == 40) { // 다운
            } else if (event.which == 38) { // 업
            } else if (event.which == 13) { // 엔터
            } else if (event.which == 37) { // 엔터
            } else if (event.which == 39) { // 엔터
            } else {
                if (el.value.trim() != "" && el.value.length >= 2) {
                    var exp = "['\\%^&\"*]", reg = new RegExp(exp, 'gi');
                    if (el.value.search(reg) >= 0) { bootbox.alert(exp + ' 문자는 사용될 수 없습니다!', function () { el.focus(); }); return false; }

                    $.ajax({
                        type: "POST",
                        url: "/EA/Common",
                        //async: false,
                        data: '{M:"gettooling",body:"N", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",search:"' + el.value + '"}',
                        success: function (res) {
                            if (res.substr(0, 2) == 'OK') {
                                var j = { "autoComplete": true, "width": w, "height": h, "left": l, "top": t }
                                j["content"] = res.substr(2);

                                var pop = _zw.ut.popup(el, j);

                            } else bootbox.alert(res);
                        },
                        beforeSend: function () { }
                    });
                }
            }
        },
    }

    _zw.body = {
        "common": function (j) {
            j["web"] = _zw.V["web"];
            j["root"] = _zw.V["root"];
            j["companycode"] = _zw.V["companycode"];
            j["domain"] = _zw.V["domain"];
            j["dnid"] = _zw.V["dnid"];            
            j["oid"] = _zw.V["oid"];
            j["relid"] = _zw.V["relid"];
            j["appid"] = _zw.V["appid"];
            j["formid"] = _zw.V["formid"];
            j["xfalias"] = _zw.V["xfalias"];
            j["wnid"] = _zw.V["wnid"];
            j["boundary"] = _zw.V["boundary"];

            j["current"] = {};
            j["current"]["urid"] = _zw.V.current["urid"];
            j["current"]["urcn"] = _zw.V.current["urcn"];
            j["current"]["user"] = _zw.V.current["user"];
            j["current"]["deptid"] = _zw.V.current["deptid"];
            j["current"]["deptcd"] = _zw.V.current["deptcd"];
            j["current"]["dept"] = _zw.V.current["dept"];
            j["current"]["belong"] = _zw.V.current["belong"];
            j["current"]["indate"] = _zw.V.current["indate"];

            j["attachlist"] = [];
            j["form"] = {};
        },
        "main": function (f, v) {
            var p = {}
            $('#__FormView #__mainfield').each(function () { //console.log($(this))
                var tag = $(this).prop('tagName').toLowerCase(), nm = $(this).attr('name');
                var b = nm == '' ? false : true;
                if (b && v && v.length > 0) {
                    var fld = v.find(function (element) { if (element == nm) return true; });
                    if (fld === undefined) b = false;
                }
                if (b) {
                    if (tag == "div" || tag == "span") {
                        p[nm] = $(this).html();
                    } else if (tag == "input") {
                        if ($(this).is(":checkbox") || $(this).is(":radio")) {
                            p[nm] = $(this).prop('checked') ? $(this).val() : '';
                        } else {
                            p[nm] = $(this).val();
                        }
                    } else {
                        p[nm] = $(this).val();
                    }
                }
            });
            f["maintable"] = p;
        },
        "mainCompare": function (f, comp, v) {
            var p = {};
            $('#__FormView #__mainfield').each(function () { //console.log($(this))
                var tag = $(this).prop('tagName').toLowerCase(), nm = $(this).attr('name');
                var b = nm == '' ? false : true;
                if (b) {//v : 제외 필드
                    var fld = v && v.length > 0 && v.find(function (element) { if (element == nm) return true; });
                    b = fld === undefined ? true : false;
                }
                if (b) {
                    var org = _zw.V.form.maintable[nm];
                    if (tag == "div" || tag == "span") {
                        if (!comp || ((org == null && $(this).html() != '') || (org && org != $(this).html()))) p[nm] = $(this).html();
                    } else if (tag == "input") {
                        if (!comp || ((org == null && $(this).val() != '') || (org && org != $(this).val()))) {
                            if ($(this).is(":checkbox") || $(this).is(":radio")) {
                                p[nm] = $(this).prop('checked') ? $(this).val() : '';
                            } else if ($(this).hasClass('txtDate')) {
                                if (org == null || $(this).val() != org.substr(0, 10)) p[nm] = $(this).val();
                            } else {
                                p[nm] = $(this).val();
                            }
                        }
                    } else {
                        if (!comp || ((org == null && $(this).val() != '') || (org && org != $(this).val()))) p[nm] = $(this).val();
                    }
                }
            });

            //if (_zw.V.def["webeditor"] != '' && $('#' + _zw.T.editor.holder).length > 0) p["WEBEDITOR"] = DEXT5.getBodyValue();
            f["maintable"] = p;
        },
        "sub": function (f) {
            var s = {}, v = [], e, e2, e3;

            e = $('#__subtable1[name="MODELNO"]');
            if (e.length > 0 && e.val() != '') {
                var sub = {};
                sub["CLSNAME"] = "pdmmodel";
                sub["PDMOID"] = $('#__subtable1[name="MODELOID"]').val();
                sub["PNUMBER"] = e.val();
                sub["SUBJECT"] = $('#__subtable1[name="MODELNM"]').val();
                v.push(sub);
            }
            e = null;

            $('#__subtable1_div > div').each(function () {
                var sub = {};
                $(this).find('#__subtable1[name]').each(function () {
                    if ($(this).attr('name').indexOf('PARTNO') != -1) e = $(this);
                    else if ($(this).attr('name').indexOf('PARTNM') != -1) e2 = $(this);
                    else if ($(this).attr('name').indexOf('PARTOID') != -1) e3 = $(this);
                });
                if (e && e.val() != '') {
                    sub["CLSNAME"] = "pdmpart";
                    sub["PDMOID"] = e3.val();
                    sub["PNUMBER"] = e.val();
                    sub["SUBJECT"] = e2.val();
                    v.push(sub);
                }
                e = null; e2 = null; e3 = null;
            });
            s['subtable1'] = v;
            f["subtables"] = s;
        },
        "file": function (j) {
            var fileList = DEXT5UPLOAD.GetAllFileListForJson(); //console.log(fileList)
            var fi = j["attachlist"];

            if (fileList && fileList.webFile) {
                var webFile = fileList.webFile;
                for (var i = 0; i < webFile.originalName.length; i++) {
                    if (webFile.customValue[i] == '' || webFile.customValue[i] == '0') {//기존 첨부는 담지 않음
                        var v = {};
                        var idx = webFile.uploadPath[i].lastIndexOf('/');
                        var savedName = webFile.uploadPath[i].substr(idx + 1);
                        idx = savedName.lastIndexOf('.');
                        v["attachid"] = 0;
                        v["atttype"] = "O";
                        v["seq"] = webFile.order[i];
                        v["isfile"] = "Y";
                        v["filename"] = webFile.originalName[i];
                        v["savedname"] = savedName;
                        v["ext"] = savedName.substr(idx + 1);
                        v["size"] = webFile.size[i];
                        v["filepath"] = webFile.uploadPath[i];
                        v["storagefolder"] = "";

                        fi.push(v);
                    }
                }
            }
            j["attachcount"] = DEXT5UPLOAD.GetTotalFileCount();
            j["attachsize"] = DEXT5UPLOAD.GetTotalFileSize();

            if (_zw.fu.fileList && _zw.fu.fileList.length > 0) {
                for (var x in _zw.fu.fileList) {
                    fi.push(_zw.fu.fileList[x]);
                }
            }
        }
    }
});

function DEXT5UPLOAD_BeforeAddItem(uploadID, fileName, fileSize, idx, localPath, f) {//localPath -> drag 경우 ''
    console.log("check -> " + fileName + " : " + fileSize + " : " + idx);
    var v = DEXT5UPLOAD.GetAllFileListForJson();
    if (v) {
        for (var i = 0; i < v.webFile.originalName.length; i++) {
            if (fileName == v.webFile.originalName[i]) return false;
        }
    }
    return true;
}

function DEXT5UPLOAD_AfterAddItemEndTime() {
    console.log('transfer');
    // 파일 추가후 처리할 내용
    DEXT5UPLOAD.TransferEx();
}

function DEXT5UPLOAD_OnTransfer_Start() {
    console.log('start => ' + (new Date()))
    // 업로드 시작 후 처리할 내용
    return true;
}

function DEXT5UPLOAD_OnTransfer_Complete() {
    console.log('complete => ' + (new Date()) + " : " + DEXT5UPLOAD.GetTotalFileCount() + " : " + DEXT5UPLOAD.GetTotalFileSize());
    var jsonNew = DEXT5UPLOAD.GetNewUploadListForJson();
    for (var i = 0; i < jsonNew.originalName.length; i++) {
        DEXT5UPLOAD.SetUploadedFile(jsonNew.order[i] - 1, jsonNew.order[i] - 1, jsonNew.originalName[i], jsonNew.uploadPath[i].split(':')[1], jsonNew.size[i], '', _zw.T.uploader.id);
    }
}

function DEXT5UPLOAD_CustomAction(uploadID, cmd) {
    if (cmd == 'custom_remove') {
        // 파일 삭제 전 처리할 내용
        var fileList = DEXT5UPLOAD.GetSelectedAllFileListForText();
        var newFile = fileList.newFile, webFile = fileList.webFile;
        var sId = '';

        if (webFile) {
            var vFile = webFile.split(_zw.T.uploader.df);
            for (var i = 0; i < vFile.length; i++) {
                var vInfo = vFile[i].split(_zw.T.uploader.da); //console.log(vInfo)
                if (i > 0) sId += ';';
                sId += vInfo[5];
            }
        }

        if (newFile || webFile) {
            var msg = '삭제 하시겠습니까?' + (sId != '' ? ' 기존 첨부파일은 복구되지 않습니다.' : '');
            bootbox.confirm(msg, function (rt) {
                if (rt) {
                    var bDelete = true;
                    if (sId != '') {
                        $.ajax({
                            type: "POST",
                            url: "/Common/DeleteAttach",
                            data: '{xf:"' + _zw.V.xfalias + '",appid:"' + _zw.V.appid + '",fdid:"' + _zw.V.fdid + '",tgtid:"' + sId + '"}',
                            async: false,
                            success: function (res) {
                                if (res == "OK") {
                                    //console.log('200=>' + res);
                                } else {
                                    bDelete = false; bootbox.alert(res);
                                }
                            }
                        });
                    }
                    if (bDelete) DEXT5UPLOAD.DeleteSelectedFile();
                }
            });
        }

    } else if (cmd == 'custom_up') {
        DEXT5UPLOAD.MoveForwardFile();
    } else if (cmd == 'custom_down') {
        DEXT5UPLOAD.MoveBackwardFile();
    }
}

function DEXT5UPLOAD_OnError(uploadID, code, message, uploadedFileListObj) {
    //에러 발생 후 경고창 띄어줌
    alert("Error Code : " + code + "\nError Message : " + message);
}