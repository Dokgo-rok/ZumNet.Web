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

        $('#__ListView thead input:checkbox').click(function () {
            var b = $(this).prop('checked');
            $('#__ListView tbody input:checkbox').each(function () {
                if (!$(this).prop('disabled')) $(this).prop('checked', b);
            });
        });
    }

    _zw.fn.bindCtrl();

    _zw.fn.viewCard = function (m, id) {
        var mode = '', oId = 0;
        if (m == 'V') {
            oId = _zw.ut.eventBtn().parent().parent().attr('id').split('_')[1];
            mode = 'view';
        } else if (m == 'M') {
            oId = id;
            mode = 'edit';
        } else if (m == 'N') {
            mode = 'new';
        } else return false;

        $.ajax({
            type: 'POST',
            url: '/ExS/CorpCard/CardView',
            data: '{M:"' + mode + '",oid:"' + oId + '",ft:"' + _zw.V.ft + '",fdid:"' + _zw.V.fdid + '",operator:"' + _zw.V.current.operator + '",acl:"' + _zw.V.current.acl + '"}',
            success: function (res) {
                if (res.substr(0, 2) == 'OK') {
                    var p = $('#popForm');
                    p.html(res.substr(2));

                    _zw.ut.picker('date'); _zw.ut.maxLength(); _zw.fn.input(p.find('.modal-body'));

                    p.find('.btn[data-zm-menu]').click(function () {
                        var btn = $(this);
                        var mn = btn.attr('data-zm-menu');
                        if (mn == 'edit') {
                            _zw.fn.viewCard('M', oId);

                        } else if (mn == 'save') {
                            _zw.fn.saveCard(p, oId);

                        } else if (mn == 'link') {
                            _zw.fn.linkCard(p, oId);

                        } else if (mn == 'delete') {
                            bootbox.confirm('해당 카드를 삭제 하시겠습니까?<br />* 이 작업은 되돌릴 수 없습니다', function (rt) {
                                if (rt) {
                                    var res = _zw.ut.ajaxSync('/ExS/CorpCard/CardDelete', '{M:"F",ccid:"' + oId + '"}');
                                    if (res == 'OK') {
                                        p.modal('hide'); _zw.fn.loadList();
                                    } else bootbox.alert(res);
                                }
                            });

                        } else if (mn == 'ealink') {
                            var linkId = p.find('input[name="RegChangeData"][data-field="ea_msgid"]').val();
                            if (linkId == '' || linkId == '0') {
                                $.ajax({
                                    type: "POST",
                                    url: "/EA/Common",
                                    data: '{M:"getreportsearch",body:"F", k1:"report",k2:"FORM_CORPORATECARDREQ",k3:""}',
                                    success: function (res) {
                                        if (res.substr(0, 2) == 'OK') {
                                            var lst = $('#popBlank');
                                            lst.html(res.substr(2)).find('.modal-title').html(btn.attr('title'));
                                            lst.find(".modal-dialog").removeClass("modal-sm").removeClass("modal-lg").css("max-width", "35rem");

                                            lst.find('.btn[data-zm-menu="confirm"]').click(function () {
                                                var lnk = lst.find('.modal-body input[name="rdoEARow"]:checked'); console.log('checked : ' + lnk.val())
                                                if (lnk.length > 0) {
                                                    bootbox.confirm('카드와 결재문서를 연결하시겠습니까?<br />* 카드사용자 정보가 변경됩니다', function (rt) {
                                                        if (rt) {
                                                            var info = lnk.val().split(';');
                                                            p.find('input[name="RegChangeData"][data-field="ea_msglink"]').val('1'); //추가
                                                            p.find('input[name="RegChangeData"][data-field="ea_msgid"]').val(info[0]);
                                                            p.find('input[name="RegChangeData"][data-field="piend"]').val(info[1]);

                                                            p.find('#_cardUser').val(lnk.next().text());
                                                            btn.before('<a class="z-lnk-navy" href="javascript:" onclick="_zw.fn.openEAFormSimple(' + info[0] + ');">' + info[1] + '</a>');
                                                            btn.find('i').removeClass('fa-link').addClass('fa-unlink');

                                                            lst.modal('hide');
                                                        }
                                                    });
                                                } else bootbox.alert('연결할 문서를 선택하십시오!');
                                            });

                                            lst.on('hidden.bs.modal', function () { lst.html(''); });
                                            lst.modal();

                                        } else bootbox.alert(res);
                                    }
                                });
                            } else {
                                p.find('input[name="RegChangeData"][data-field="usenm"]').val('');
                                p.find('input[name="RegChangeData"][data-field="useid"]').val('');
                                p.find('input[name="RegChangeData"][data-field="useempid"]').val('');
                                p.find('input[name="RegChangeData"][data-field="usedept"]').val('');
                                p.find('input[name="RegChangeData"][data-field="usedeptid"]').val('');
                                p.find('#_cardUser').val('');

                                p.find('input[name="RegChangeData"][data-field="pilink"]').val('');
                                p.find('input[name="RegChangeData"][data-field="pistate"]').val('');
                                p.find('input[name="RegChangeData"][data-field="pistart"]').val('');
                                p.find('input[name="RegChangeData"][data-field="piend"]').val('');
                                p.find('input[name="RegChangeData"][data-field="ea_msglink"]').val('2');  //제거
                                p.find('input[name="RegChangeData"][data-field="ea_msgid"]').val('');
                                btn.prev().remove();
                                btn.find('i').removeClass('fa-unlink').addClass('fa-link');
                            }

                        } else if (mn == 'del-use') {
                            p.find('input[name="RegChangeData"][data-field="usenm"]').val('');
                            p.find('input[name="RegChangeData"][data-field="useid"]').val('');
                            p.find('input[name="RegChangeData"][data-field="useempid"]').val('');
                            p.find('input[name="RegChangeData"][data-field="usedept"]').val('');
                            p.find('input[name="RegChangeData"][data-field="usedeptid"]').val('');
                            p.find('#_cardUser').val('');

                        } else if (mn == 'del-pos') {
                            p.find('input[name="RegChangeData"][data-field="posur"]').val('');
                            p.find('input[name="RegChangeData"][data-field="posurid"]').val('');
                            p.find('input[name="RegChangeData"][data-field="posdept"]').val('');
                            p.find('input[name="RegChangeData"][data-field="posdeptid"]').val('');
                            p.find('#_cardPosUr').val('');

                        } else if (mn == 'save-auth') {
                            //권한자
                            if (p.find('#_cardAuthUr input:checkbox[data-pos!=""]').length > 0) {
                                var carduser = _zw.ut.empty(p.find('[name="RegChangeData"][data-field="useid"]').val()); //alert(carduser);
                                if (carduser > 0) {
                                    var sAdd = '', sDell = '';
                                    p.find('#_cardAuthUr input:checkbox[data-pos="add"]').each(function () {
                                        if (sAdd != '') sAdd += ';';
                                        sAdd += $(this).attr('data-for');
                                    });
                                    p.find('#_cardAuthUr input:checkbox[data-pos="del"]').each(function () {
                                        if (sDell != '') sDell += ';';
                                        sDell += $(this).attr('data-for');
                                    });

                                    var postJson = {};
                                    postJson["useid"] = carduser;
                                    postJson["mgrid"] = p.find('[name="RegChangeData"][data-field="mgrid"]').val();
                                    postJson["mgrnm"] = p.find('[name="RegChangeData"][data-field="mgrnm"]').val();
                                    postJson["mgrdept"] = p.find('[name="RegChangeData"][data-field="mgrdept"]').val();
                                    postJson["add"] = sAdd;
                                    postJson["del"] = sDell;
                                    console.log(postJson);

                                    bootbox.confirm("권한자 정보를 저장하시겠습니까?", function (rt) { 
                                        if (rt) {
                                            $.ajax({
                                                type: "POST",
                                                url: "/ExS/CorpCard/AuthSave",
                                                data: JSON.stringify(postJson),
                                                success: function (res) {
                                                    if (res == 'OK') {
                                                        p.modal('hide'); _zw.fn.loadList();
                                                    } else bootbox.alert(res);
                                                }
                                            });
                                        }
                                    });


                                } else {
                                    bootbox.alert("카드사용자가 지정 되어야 합니다!"); return false;
                                }
                            }

                        } else if (mn == 'del-auth') {
                            p.find('#_cardAuthUr input:checkbox:checked').each(function () {
                                $(this).attr('data-pos', 'del'); $(this).parent().parent().parent().removeClass('d-flex').addClass('d-none');
                            });
                        }
                    });
                    p.modal();
                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.viewCardAck = function (m, id) {
        var mode = '', oId = 0;
        if (m == 'V') {
            oId = _zw.ut.eventBtn().parent().parent().attr('id').split('_')[1];
            mode = 'view';
        
        } else return false;

        $.ajax({
            type: 'POST',
            url: '/ExS/CorpCard/CardAck',
            data: '{M:"' + mode + '",oid:"' + oId + '",ft:"' + _zw.V.ft + '",fdid:"' + _zw.V.fdid + '",operator:"' + _zw.V.current.operator + '",acl:"' + _zw.V.current.acl + '"}',
            success: function (res) {
                if (res.substr(0, 2) == 'OK') {
                    var p = $('#popForm');
                    p.html(res.substr(2));

                    p.find('.btn[data-zm-menu]').click(function () {
                        var mn = $(this).attr('data-zm-menu');
                        if (mn == 'memo') {
                            var postJson = {};
                            p.find('[name="RegChangeData"]').each(function () {
                                var fld = $(this).attr('data-field');
                                if (fld && fld != '') postJson[fld] = $(this).val();
                            });
                            postJson["exceptproc"] = p.find('#chkExceptPro').prop('checked') ? "Y" : "";
                            //console.log(postJson)
                            var msg = "저장 하시겠습니까?";
                            bootbox.confirm(msg, function (rt) {
                                if (rt) {
                                    $.ajax({
                                        type: "POST",
                                        url: "/ExS/CorpCard/CardAckMemo",
                                        data: JSON.stringify(postJson),
                                        success: function (res) {
                                            if (res.substr(0, 2) == "OK") { p.modal('hide'); _zw.fn.loadList(); }
                                            else bootbox.alert(res);
                                        }
                                    });
                                }
                            });
                        }
                    });
                    p.modal();
                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.viewVch = function (m, id) {
        var mode = '', oId = 0;
        if (m == 'V') {
            oId = _zw.ut.eventBtn().parent().parent().attr('id').split('.')[1];
            mode = 'view';

        } else return false;

        $.ajax({
            type: 'POST',
            url: '/ExS/CorpCard/VchInfo',
            data: '{M:"' + mode + '",oid:"' + oId + '",ft:"' + _zw.V.ft + '",fdid:"' + _zw.V.fdid + '",operator:"' + _zw.V.current.operator + '",acl:"' + _zw.V.current.acl + '"}',
            success: function (res) {
                if (res.substr(0, 2) == 'OK') {
                    var p = $('#popForm');
                    p.html(res.substr(2));

                    p.modal();
                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.saveCard = function (p, id) {
        var postJson = {}, bReg = true;
        var mode = id && id != '' && parseInt(id) > 0 ? 'edit' : 'new';

        p.find('[name="RegChangeData"]').each(function () {
            var fld = $(this).attr('data-field'); //console.log($(this))
            if (fld && fld != '') {
                if ($.trim($(this).val()) == '') {
                    if (fld == "cardcorp") { alert("필수항목[카드사]이 누락됐습니다!"); $(this).focus(); bReg = false; return false; }
                    else if (fld == "cardnum") { alert("필수항목[카드번호]이 누락됐습니다!"); $(this).focus(); bReg = false; return false; }
                    else if (fld == "cardstat") { alert("필수항목[상태]이 누락됐습니다!"); $(this).focus(); bReg = false; return false; }
                    else if (fld == "isudate") { alert("필수항목[발급일]이 누락됐습니다!"); $(this).focus(); bReg = false; return false; }
                    //else if (fld == "usenm") { alert("필수항목[사용자]이 누락됐습니다!"); $(this).focus(); bReg = false; return false; }
                }
                if (fld == "cardnum") {
                    var v = $(this).val().replace(/_/gi, '').replace(/-/gi, ''); // '_', '-' 제거
                    if (v.length < 15) { alert("[카드번호] 형식이 잘못됐습니다!"); $(this).focus(); bReg = false; return false; }
                    postJson[fld] = v;

                } else if (fld == "cardprid") {
                    var v = $(this).val().replace(/_/gi, '').replace(/\//gi, ''); // '_', '/' 제거
                    if (v.length != 4) { alert("[유효기간] 형식이 잘못됐습니다!"); $(this).focus(); bReg = false; return false; }
                    postJson[fld] = '20' + v; //v.substr(2, 2) + v.substr(0, 2);

                }  else if (fld == "limitamt") postJson[fld] = parseFloat(_zw.ut.empty($(this).val())) * 1000; //천원단위->원단위
                else if (fld == "reqdate" || fld == "isudate" || fld == "rtndate") postJson[fld] = $(this).val().replace(/-/gi, ''); // 날짜 '-' 제거)
                else postJson[fld] = $(this).val();
            }
        }); //console.log(postJson)
        if (!bReg) return false;

        //권한자
        if ($('#_cardAuthUr input:checkbox[data-for]').length > 0) {
            var carduser = _zw.ut.empty(p.find('[name="RegChangeData"][data-field="useid"]').val()); //alert(carduser);
            if (carduser > 0) {
                var sAuth = '';
                $('#_cardAuthUr input:checkbox[data-for]').each(function () {
                    if (sAuth != '') sAuth += ';';
                    sAuth += $(this).attr('data-for');
                });
                postJson["ackauth"] = sAuth;
            } else {
                bootbox.alert("권한자 추가는 카드사용자가 지정 되어야 합니다!"); return false;
            }
        }

        //카드번호 중복 체크
        var res = _zw.ut.ajaxSync('/EA/Common', '{M:"getreportsearch",body:"S", k1:"report",k2:"' + _zw.V.ft + '",v1:"' + postJson['cardcorp'] + '",v2:"' + postJson['cardnum'] + '",v3:"' + id + '"}');
        if (res != "OK")  { alert(res); p.find('[name="RegChangeData"][data-field="cardnum"]').focus(); bReg = false; }
        if (!bReg) return false;

        postJson["M"] = mode;
        postJson["ccid"] = id;
        postJson["ft"] = _zw.V.ft;
        postJson["operator"] = _zw.V.current.operator;
        postJson["acl"] = _zw.V.current.acl;
        //console.log(postJson);

        var msg = mode == "edit" ? "카드정보을 변경하시겠습니까?" : "카드정보를 등록하시겠습니까?";
        bootbox.confirm(msg, function (rt) { //console.log(postJson);
            if (rt) {
                $.ajax({
                    type: "POST",
                    url: "/ExS/CorpCard/CardSave",
                    data: JSON.stringify(postJson),
                    success: function (res) {
                        if (res.substr(0, 2) == "OK") {
                            //id = res.substr(2)
                            //bootbox.alert("저장했습니다!", function () {
                            p.modal('hide'); _zw.fn.loadList();
                            //});
                        } else bootbox.alert(res);
                    }
                });
            }
        });
    }

    _zw.fn.linkCard = function (p, id) {
        var postJson = {};
        $('[name="RegChangeData"]').each(function () {
            var fld = $(this).attr('data-field');
            if (fld && fld != '') {
                postJson[fld] = $(this).val();
            }
        });

        postJson["ccid"] = id;
        postJson["ft"] = _zw.V.ft;
        postJson["operator"] = _zw.V.current.operator;
        postJson["acl"] = _zw.V.current.acl;
        //console.log(postJson);

        var msg = "저장 하시겠습니까?";
        bootbox.confirm(msg, function (rt) { 
            if (rt) {
                $.ajax({
                    type: "POST",
                    url: "/ExS/CorpCard/CardLink",
                    data: JSON.stringify(postJson),
                    success: function (res) {
                        if (res.substr(0, 2) == "OK") {
                            //bootbox.alert("저장했습니다!", function () {
                            p.modal('hide'); _zw.fn.loadList();
                            //});
                        } else bootbox.alert(res);
                    }
                });
            }
        });
    }

    _zw.fn.orgSelect = function (p, x) {
        p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
            var info = JSON.parse($(this).attr('data-attr')); //console.log(info);
            var dn = $(this).next().text();

            if (x == 'auth') {
                if ($('#_cardAuthUr input:checkbox[data-for="' + info["id"] + '"]').length > 0) {
                    bootbox.alert("중복된 사용자 입니다!"); return false;
                } else {
                    var s = $('.zf-auth-template').html();
                    s = s.replace("{$mode}", "add").replace("{$id}", info["id"]).replace("{$user}", dn).replace("{$grade}", info["grade"]).replace("{$dept}", info['grdn']);

                    $('#_cardAuthUr').append(s);
                }

            } else if (x == 'use' || x == 'pos') {
                if (info['empid'] != null) {
                    if (x == 'use') {
                        $('input[name="RegChangeData"][data-field="usenm"]').val(dn);
                        $('input[name="RegChangeData"][data-field="useid"]').val(info["id"]);
                        $('input[name="RegChangeData"][data-field="useempid"]').val(info["empid"]);
                        $('input[name="RegChangeData"][data-field="usedept"]').val(info["grdn"]);
                        $('input[name="RegChangeData"][data-field="usedeptid"]').val(info["grid"]);
                        $('#_cardUser').val(info["grdn"] + '. ' + dn);

                    } else if (x == 'pos') {
                        $('input[name="RegChangeData"][data-field="posur"]').val(dn);
                        $('input[name="RegChangeData"][data-field="posurid"]').val(info["id"]);
                        $('input[name="RegChangeData"][data-field="posdept"]').val(info["grdn"]);
                        $('input[name="RegChangeData"][data-field="posdeptid"]').val(info["grid"]);
                        $('#_cardPosUr').val(info["grdn"] + '. ' + dn);
                    }

                } else {
                    if (x == 'use') {
                        $('input[name="RegChangeData"][data-field="usenm"]').val(dn);
                        $('input[name="RegChangeData"][data-field="useid"]').val('');
                        $('input[name="RegChangeData"][data-field="useempid"]').val('');
                        $('input[name="RegChangeData"][data-field="usedept"]').val(dn);
                        $('input[name="RegChangeData"][data-field="usedeptid"]').val(info["id"]);
                        $('#_cardUser').val(dn);

                    } else if (x == 'pos') {
                        $('input[name="RegChangeData"][data-field="posur"]').val(dn);
                        $('input[name="RegChangeData"][data-field="posurid"]').val('');
                        $('input[name="RegChangeData"][data-field="posdept"]').val(dn);
                        $('input[name="RegChangeData"][data-field="posdeptid"]').val(info["id"]);
                        $('#_cardPosUr').val(dn);
                    }
                }
            }
        });
        p.modal('hide');
    }

    _zw.fn.exportExcel = function () {
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

    _zw.fn.loadList = function () {
        var postData = _zw.fn.getLvQuery(); //console.log(postData); return
        var url = '?qi=' + encodeURIComponent(_zw.base64.encode(postData));

        $.ajax({
            type: "POST",
            url: url,
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    history.pushState(null, null, url);

                    window.document.title = _zw.V.ttl;
                    $('.z-ttl span').html(_zw.V.ttl);

                    var v = res.substr(2).split(_zw.V.lv.boundary); //alert(v[2])
                    $('#__List').html(v[0]);
                    $('.z-list-menu').html(v[1]);
                    $('#__ListPage').html(v[2]);

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
        _zw.fn.initLv(_zw.V.current.urid);

        sort = sort || ''; dir = dir || '';
        _zw.V.lv.sort = sort;
        _zw.V.lv.sortdir = dir;
        _zw.V.lv.page = (page) ? page : 1;

        _zw.V.lv.start = $('.z-list-cond .start-date').val();
        _zw.V.lv.end = $('.z-list-cond .end-date').val();

        _zw.V.lv.cd1 = $('#_SearchSelect').val();

        if ($('#_SearchText').length > 0) {
            var e = $('#_SearchText');
            var s = "['\\%^&\"*]";
            var reg = new RegExp(s, 'g');
            if (e.val().search(reg) >= 0 || e.val().search(/\\/) >= 0) { bootbox.alert(s + " 문자는 사용될 수 없습니다!", function () { e.val(''); e.focus(); }); return false; }

            _zw.V.lv.cd2 = e.val();

            if (_zw.V.ft == 'CC_CARDBASE') {
                _zw.V.lv.cd3 = $('.z-list-cond [data-for="search-cond3"] input:radio:checked').val();
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
        j["start"] = _zw.V.lv.start;
        j["end"] = _zw.V.lv.end;
        j["basesort"] = _zw.V.lv.basesort;
        j["boundary"] = _zw.V.lv.boundary;

        j["cd1"] = _zw.V.lv.cd1; j["cd2"] = _zw.V.lv.cd2; j["cd3"] = _zw.V.lv.cd3; j["cd4"] = _zw.V.lv.cd4; j["cd5"] = _zw.V.lv.cd5;
        //console.log(j)
        return JSON.stringify(j);
    }

    _zw.fn.initLv = function (tgt) {
        _zw.V.lv.tgt = tgt;
        _zw.V.lv.page = '1';
        _zw.V.lv.count = '50';
        _zw.V.lv.sort = '';
        _zw.V.lv.sortdir = '';
        _zw.V.lv.search = '';
        _zw.V.lv.searchtext = '';
        _zw.V.lv.start = '';
        _zw.V.lv.end = '';
        _zw.V.lv.basesort = '';

        _zw.V.lv.cd1 = ''; _zw.V.lv.cd2 = ''; _zw.V.lv.cd3 = ''; _zw.V.lv.cd4 = ''; _zw.V.lv.cd5 = '';
    }
});