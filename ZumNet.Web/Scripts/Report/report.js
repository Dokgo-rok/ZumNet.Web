//집계, 대장 리스트뷰

$(function () {

    _zw.fn.bindCtrl = function () {
        _zw.ut.picker('date');

        $('[data-zv-menu="search"]').click(function () {
            _zw.fn.goSearch();
        });

        $('#_SearchText').keyup(function (e) {
            if (e.which == 13) _zw.fn.goSearch();
        });

        $('.pagination li a.page-link').click(function () {
            _zw.fn.goSearch($(this).attr('data-for'));
        });

        //console.log(fchart_report)
        //if (FusionCharts && fchart_report) fchart_report.render();

        $('#__ListView div[data-for="multiple-chart"]').each(function () {
            var j = $(this).next().text(), d = $(this).next().next().text();
            //console.log(j)
            var fchart = new FusionCharts(JSON.parse(j));
            fchart.setXMLData(d);
            fchart.render();
        });

        if ($('.chart-cfg-template').length > 0 && $('.chart-data-template').length > 0) {
            var j = $('.chart-cfg-template').text(), d = $('.chart-data-template').text();
            //console.log(JSON.parse(j)); console.log(d)

            //var fchart = new FusionCharts({
            //    type: 'mscombidy2d',
            //    renderAt: 'chart-container',
            //    width: '100%',
            //    height: '300px',
            //    dataFormat: 'xml'
            //});
            var fchart = new FusionCharts(JSON.parse(j));

            fchart.setXMLData(d);
            fchart.render();
        }

        if (_zw.V.ft == 'FORM_BIZTRIPPLAN') {
            $('#__ListView td[data-for="popup"]').on('mouseover', function () {
                $(this).addClass('table-primary');
            }).on('mouseout', function () {
                $(this).removeClass('table-primary');
            }).on('click', function () {
                var el = $(this), row = el.parent();
                $.ajax({
                    type: "POST",
                    url: "/Report/Modal",
                    data: '{M:"' + el.attr('data-for') + '",ft:"' + _zw.V.ft + '",mi:"' + row.attr('id').substr(1) + '", ri:"' + row.attr('regid') + '",st:"' + row.attr('step') + '"}',
                    success: function (res) {
                        //if (res.substr(0, 2) == 'OK') {
                        //    var j = { "close": true, "width": 500, "height": (row.attr('regid') == '' || row.attr('regid') == '0' ? 154 : 300), "left": -200, "top": 0 }
                        //    j["title"] = '출장기간 변경'; j["content"] = res.substr(2);

                        //    var pop = _zw.ut.popup(el[0], j);
                        //    _zw.ut.picker('date');

                        //} else bootbox.alert(res);
                        var p = $('#popBlank');
                        p.html(res).find('.modal-title').html('출장기간 변경');
                        _zw.ut.picker('date'); _zw.ut.maxLength(); _zw.fn.input(p.find('.modal-body'));

                        p.find('.btn[data-zm-menu="confirm"]').click(function () {
                            var e1 = p.find('[data-for="ChangeStart"]'), e2 = p.find('[data-for="ChangeEnd"]'), e3 = p.find('[data-for="ChangeReason"]');
                            if (e1.val() == '' && e2.val() == '') { bootbox.alert("변경할 출장일을 입력하십시오!", function () { e1.focus(); }); return false; }
                            if ($.trim(e3.val()) == '') { bootbox.alert("출장기간 변경사유를 입력하십시오!", function () { e3.focus(); }); return false; }

                            bootbox.confirm("출장 기간을 변경하시겠습니까?", function (rt) {
                                if (rt) {
                                    var j = {};
                                    j["M"] = "change-date"; j["ft"] = _zw.V.ft; j["mi"] = row.attr('id').substr(1);
                                    j["st"] = row.attr('step'); j["cs"] = e1.val(); j["ce"] = e2.val(); j["cr"] = e3.val();

                                    $.ajax({
                                        type: "POST",
                                        url: "/Report/Modal",
                                        data: JSON.stringify(j),
                                        success: function (res) {
                                            if (res.substr(0, 2) == "OK") _zw.fn.loadList();
                                            else bootbox.alert(res);

                                            p.modal('hide');
                                        }
                                    });
                                }
                            });
                            
                        });

                        p.on('hidden.bs.modal', function () { p.html(''); });
                        p.modal();
                    }
                });
            });
        }
    }

    _zw.fn.bindCtrl();

    _zw.fn.openXFormEx = function () {
        var el = _zw.ut.eventBtn(), row = el.parent().parent(), x = 0, y = 0, winName = '', url = '', sResize = '', sId = '', qi;
        if (row.prop('tagName') == 'TR') {
            if (_zw.V.ft == 'SEARCH_EADOC') {
                if (arguments[0] == "PDM") {
                    x = 750; y = 600; winName = "pdmview";
                    url = "/Portal/SSOpdm?target=" + arguments[2] + "&oid=" + arguments[1]; //alert(url)
                } else {
                    x = 640; y = 600; winName = "popupform_doc"; szResize = "resize";
                    qi = '{wnd:"' + m + '",ct:"' + _zw.V.ct + '",ctalias:"",ot:"",alias:"",xfalias:"' + 'doc'
                        + '",fdid:"' + _zw.V.fdid + '",appid:"' + row.attr('id').split('_')[1] + '",opnode:"",ttl:"",acl:"'
                        + '",appacl:"",sort:"' + _zw.V.lv.sort + '",sortdir:"' + _zw.V.lv.sortdir + '",boundary:"' + _zw.V.lv.boundary + '"}';
                    url = '/Docs/Edm/Read?qi=' + encodeURIComponent(_zw.base64.encode(qi));
                }
            } else if (_zw.V.ft == 'REGISTER_TOOLING' || _zw.V.ft == 'SEARCH_TOOLING_STATE' || _zw.V.ft == 'REGISTER_TOOLINGDAILYUSE') {
                if (arguments[0] == "pdmmodel" || arguments[0] == "pdmpart") {
                    x = 750; y = 600; winName = arguments[0];
                    url = "/Portal/SSOpdm?target=prodview&oid=" + arguments[1];
                } else {
                    sId = _zw.V.ft == 'SEARCH_TOOLING_STATE' ? arguments[0] : row.attr('id');
                    x = 900; y = 600; qi = '{M:"read",mi:"' + sId + '",oi:"",wi:"",fi:"REGISTER_TOOLING",xf:"tooling"}'; console.log(qi)
                    url = '/EA/Form?qi=' + _zw.base64.encode(qi);
                }
            } else if (_zw.V.ft == 'REGISTER_GONGGA') {
                sId = row.attr('id').split('_')[1].substring(row.attr('id').split('_')[1].length, row.attr('id').split('_')[1].length - 6);
                x = 900; y = 600; qi = '{M:"read",mi:"' + sId + '",oi:"",wi:"",xf:"ea"}';
                url = '/EA/Form?qi=' + _zw.base64.encode(qi);
            } 
        } else {
            if (arguments[0]) {
                x = 900; y = 600; qi = '{M:"read",mi:"' + arguments[0] + '",oi:"",wi:"",xf:"ea"}';
                url = '/EA/Form?qi=' + _zw.base64.encode(qi);
            } else {
                if (_zw.V.ft == 'REGISTER_TOOLING') {
                    x = 900; y = 600; qi = '{M:"new",mi:"",oi:"",wi:"",fi:"REGISTER_TOOLING",xf:"tooling"}';
                    url = '/EA/Form?qi=' + _zw.base64.encode(qi);
                }
            }
        }
        if (url != '') _zw.ut.openWnd(url, winName, x, y, sResize);
    }

    _zw.fn.exportExcel = function () {
        //var encQi = '{M:"xls",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",fdid:"' + _zw.V.fdid + '",opnode:"",ttl:"' + _zw.V.ttl + '"}';
        //window.open('?qi=' + encodeURIComponent(_zw.base64.encode(encQi)), 'ifrView');

        var postData = _zw.fn.getLvQuery('xls'); console.log(postData)
        window.open('?qi=' + encodeURIComponent(_zw.base64.encode(postData)), 'ifrView');
        //window.open('?qi=' + encodeURIComponent(_zw.base64.encode(postData)));
    }

    _zw.fn.importFile = function (cd) {
        cd = cd || '';
        var url = '/Common/FileImport?M=' + _zw.V.ft + '&sy=' + _zw.V.lv.start + '&cd=' + cd;
        $.ajax({
            type: "POST",
            url: url,
            success: function (res) {
                var p = $('#popBlank');
                p.html(res); _zw.fu.bind();
                fm = p.find('#uploadForm')[0].action = url;

                p.on('hidden.bs.modal', function () { p.html(''); });
                p.modal();
            }
        });
    }

    _zw.fn.complete = function (msg) {
        var p = $('#popBlank');
        p.find('.zf-upload #uploadForm')[0].reset();

        var rt = decodeURIComponent(msg).replace(/\+/gi, ' ');
        if (rt.substr(0, 2) == 'OK') {
            var footer = '<div class="modal-footer justify-content-center">'
                + '<button type="button" class="btn btn-primary" data-zm-menu="confirm">확인</button>'
                + '<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>'
                + '</div>';

            p.find('.zf-upload .zf-upload-list').html(rt.substr(2)).removeClass('d-none');
            p.find('.modal-content').append(footer);

            p.find('.modal-footer .btn[data-zm-menu="confirm"]').click(function () {
                p.modal('hide'); _zw.fn.loadList();
            });

        } else {
            p.find('.zf-upload .zf-upload-list').html(rt).removeClass('d-none');
        }
        p.find('.zf-upload .zf-upload-bar').addClass('d-none');
        if (p.find('.modal-dialog').hasClass('modal-sm')) p.find('.modal-dialog').removeClass('modal-sm');
    }

    _zw.fn.optionWnd = function (pos, w, h, l, t, etc, x) {
        var el = _zw.ut.eventBtn();
        var j = { "close": true, "width": w, "height": h, "left": l, "top": t }
        j["title"] = el.attr('title'); j["content"] = el.next().html();
        var pop = _zw.ut.popup(el[0], j);
    }

    _zw.fn.externalWnd = function (pos, w, h, m, n, etc, x) {
        var el = _zw.ut.eventBtn(), vPos = pos.split('.'); //console.log(arguments)
        var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]);
        var m = '', query = '', v1 = '', v2 = '', v3 = '';
        if (vPos[0] == 'erp') m = 'getoracleerp';
        else if (vPos[0] == 'report') m = 'getreportsearch';
        else m = 'getcodedescription';

        var sSelect = '';
        if (_zw.V.ft == 'FORM_DRAWING') {
            $('#_SearchText').val(''); $('#_SearchCond3').val('');
        }

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

        p.find(".modal-dialog").css("max-width", "35rem").find(".modal-content").css("min-height", "20rem");

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
                            var v = $(this).attr('data-val').split('^'); console.log(v)
                            //$('#_SearchText').val(v[0]);
                            //if (_zw.V.ft == 'FORM_DRAWING') _zw.V.lv["cd3"] = v[1];
                            for (var i = 0; i < param.length; i++) {
                                $('#' + param[i]).val(v[i]);
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
            searchTxt.focus();
        });
        p.on('hidden.bs.modal', function () { p.html(''); });
        p.modal();
    }

    _zw.fn.requestApproval = function () {
    }

    _zw.fn.loadList = function () {
        var postData = _zw.fn.getLvQuery(); //console.log(postData)
        var url = '?qi=' + encodeURIComponent(_zw.base64.encode(postData));

        $.ajax({
            type: "POST",
            url: url,
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    history.pushState(null, null, url);

                    window.document.title = _zw.V.ttl;
                    $('.z-ttl span').html(_zw.V.ttl);

                    var v = res.substr(2).split(_zw.V.lv.boundary);
                    //if ($('#__ListView [data-for="list"]').length > 0) { //_zw.V.ft == 'REGISTER_EMPLOYEE_PALNT'
                    //    $('#__ListView [data-for="list"]').html(v[0]); //console.log(v[1])
                    //    fchart_report.setXMLData(v[1]);
                    //    fchart_report.render();

                    //} else {
                    //    $('#__List').html(v[0]);
                    //    $('.z-list-menu').html(v[1]);
                    //    $('#__ListPage').html(v[2]);

                    //    _zw.fn.bindCtrl();
                    //}

                    $('#__List').html(v[0]);
                    $('.z-list-menu').html(v[1]);
                    $('#__ListPage').html(v[2]);

                    //if (fchart_report) {
                    //    fchart_report.render();
                    //}

                    _zw.fn.bindCtrl();

                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.sort = function (col) {
        var t = $(event.target); sortCol = t.attr('data-val'), sortDir = '';

        t.parent().parent().find('a[data-val]').each(function () {
            if ($(this).attr('data-val') == sortCol) {
                var c = $(this).find('i');
                if (c.hasClass('fe-arrow-up')) {
                    c.removeClass('fe-arrow-up').addClass('fe-arrow-down'); sortDir = 'DESC';
                } else {
                    c.removeClass('fe-arrow-down').addClass('fe-arrow-up'); sortDir = 'ASC';
                }
            } else {
                $(this).find('i').removeClass();
            }
        });

        _zw.fn.goSearch(null, sortCol, sortDir);
    }

    _zw.fn.goSearch = function (page, sort, dir) {
        if (_zw.V.ft == 'REGISTER_PRODUCT_PALNT' || _zw.V.ft == 'REGISTER_EMPLOYEE_PALNT' || _zw.V.ft == 'REGISTER_PRODUCT_PALNT_MODEL'
            || _zw.V.ft == 'REGISTER_EMPLOYEE_PALNT_MODEL' || _zw.V.ft == 'REGISTER_PROCESS_PALNT_MODEL' || _zw.V.ft == 'FORM_MONTHLOSSCHART') {
            _zw.V.lv.start = $('.z-list-search select[data-for="year"]').val();
            _zw.V.lv.end = $('.z-list-search select[data-for="month"]').val();
            _zw.V.lv.cd1 = $('.z-list-search select[data-for="cond1"]').val();

            //var postData = _zw.fn.getLvQuery(); //console.log(postData)
            //window.location.href = '?qi=' + encodeURIComponent(_zw.base64.encode(postData));

        //} else if (_zw.V.ft == 'FORM_DRAWING') {

        } else {
            _zw.fn.initLv(_zw.V.current.urid);

            sort = sort || ''; dir = dir || '';
            _zw.V.lv.sort = sort;
            _zw.V.lv.sortdir = dir;
            _zw.V.lv.page = (page) ? page : 1;

            _zw.V.lv.start = $('.z-list-cond .start-date').val();
            _zw.V.lv.end = $('.z-list-cond .end-date').val();

            if (_zw.V.ft == 'REGISTER_TOOLING') {
                $('.z-list-cond table td [data-for]').each(function () {
                    if ($.trim($(this).val()) != '') _zw.V.lv[$(this).attr('data-for')] = $(this).val();
                });
                //console.log(_zw.V.lv)
            } else {
                _zw.V.lv.cd1 = $('#_SearchSelect').val();

                if ($('#_SearchText').length > 0) {
                    var e = $('#_SearchText');
                    var s = "['\\%^&\"*]";
                    var reg = new RegExp(s, 'g');
                    if (e.val().search(reg) >= 0) { bootbox.alert(s + " 문자는 사용될 수 없습니다!", function () { e.val(''); e.focus(); }); return false; }

                    _zw.V.lv.cd2 = e.val();

                    if (_zw.V.ft == 'FORM_DRAWING') {
                        if ($.trim(e.val()) == '') { bootbox.alert('모델번호 또는 부품번호를 입력하십시오!', function () { e.focus(); }); return false; }
                        _zw.V.lv.cd3 = $('#_SearchCond3').val();
                    }
                }
            }
        }
        _zw.fn.loadList();
    }

    _zw.fn.getLvQuery = function (m) {
        var j = {}; m = m || '';
        j["M"] = m;
        j["ct"] = _zw.V.ct;
        j["ctalias"] = _zw.V.ctalias;
        j["ot"] = _zw.V.ot;
        j["alias"] = _zw.V.alias;
        j["xfalias"] = _zw.V.xfalias;
        j["fdid"] = _zw.V.fdid;
        j["acl"] = _zw.V.current.acl;
        j["opnode"] = _zw.V.opnode;
        j["ft"] = _zw.V.ft;
        j["ttl"] = _zw.V.ttl;

        j["tgt"] = _zw.V.lv.tgt;
        j["page"] = _zw.V.lv.page;
        j["count"] = _zw.V.lv.count;
        j["sort"] = _zw.V.lv.sort;
        j["sortdir"] = _zw.V.lv.sortdir;
        j["search"] = _zw.V.lv.search;
        j["searchtext"] = _zw.V.lv.searchtext;
        j["start"] = _zw.ut.date(_zw.V.lv.start, 'YYYY-MM-DD');
        j["end"] = _zw.ut.date(_zw.V.lv.end, 'YYYY-MM-DD') ;
        j["basesort"] = _zw.V.lv.basesort;
        j["boundary"] = _zw.V.lv.boundary;

        j["cd1"] = _zw.V.lv.cd1; j["cd2"] = _zw.V.lv.cd2; j["cd3"] = _zw.V.lv.cd3; j["cd4"] = _zw.V.lv.cd4; j["cd5"] = _zw.V.lv.cd5; j["cd6"] = _zw.V.lv.cd6;
        j["cd7"] = _zw.V.lv.cd7; j["cd8"] = _zw.V.lv.cd8; j["cd9"] = _zw.V.lv.cd9; j["cd10"] = _zw.V.lv.cd10; j["cd11"] = _zw.V.lv.cd11; j["cd12"] = _zw.V.lv.cd12;
        console.log(j)
        return JSON.stringify(j);
    }

    _zw.fn.initLv = function (tgt) {
        var sCnt = _zw.ut.getCookie('docLvCount');
        if ($('.z-list-page select').length > 0) sCnt = $('.z-list-page select').val();

        _zw.V.lv.tgt = tgt;
        _zw.V.lv.page = '1';
        _zw.V.lv.count = sCnt == '' ? '20' : sCnt;
        _zw.V.lv.sort = '';
        _zw.V.lv.sortdir = '';
        _zw.V.lv.search = '';
        _zw.V.lv.searchtext = '';
        _zw.V.lv.start = '';
        _zw.V.lv.end = '';
        _zw.V.lv.basesort = '';

        _zw.V.lv.cd1 = ''; _zw.V.lv.cd2 = ''; _zw.V.lv.cd3 = ''; _zw.V.lv.cd4 = ''; _zw.V.lv.cd5 = ''; _zw.V.lv.cd6 = '';
        _zw.V.lv.cd7 = ''; _zw.V.lv.cd8 = ''; _zw.V.lv.cd9 = ''; _zw.V.lv.cd10 = ''; _zw.V.lv.cd11 = ''; _zw.V.lv.cd12 = '';
    }
});