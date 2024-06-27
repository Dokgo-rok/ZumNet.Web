$(function () {

    $('[data-zv-menu="search"]').click(function () {
        _zw.fn.goSearch();
    });

    $('#_SearchText').keyup(function (e) {
        if (e.which == 13) _zw.fn.goSearch();
    });

    _zw.fn.sort = function (col) {
        var el = event.target ? event.target : event.srcElement;
        var dir = $(el).find('i').hasClass('fe-arrow-up') ? 'DESC' : 'ASC';
        _zw.fn.goSearch(null, col, dir);
    }

    $('#__ListCount select').change(function () {
        _zw.V.lv.count = $(this).val(); _zw.V.lv.page = 1;
        _zw.fn.goSearch(1);
    });

    $('.pagination li a.page-link').click(function () {//.pagination => #__ListViewPage (리스트뷰 경우 적용)
        _zw.fn.goSearch($(this).attr('data-for'));
    });

    _zw.fn.viewEvent = function (m) {
        var mode = '', oId = 0;
        if (m == 'V') {
            var row = _zw.ut.eventBtn().parent().parent(); //console.log(row)
            oId = row.attr('id').split('_')[1];
            mode = 'view';

        } else if (m == 'N') {
            //alert(_zw.V.current.acl.substr(6, 1))
            if (_zw.V.current.operator != 'Y' && _zw.V.current.acl.substr(6, 1) != 'S') {
                bootbox.alert('No Permission!'); return false;
            }
            mode = 'new';

        } else return false;

        $.ajax({
            type: 'POST',
            url: '/ExS/Voc/EventView',
            data: '{M:"' + mode + '",oid:"' + oId + '",fdid:"' + _zw.V.fdid + '",operator:"' + _zw.V.current.operator + '",acl:"' + _zw.V.current.acl + '"}',
            success: function (res) {
                if (res.substr(0, 2) == 'OK') {
                    var p = $('#popLayer');
                    p.html(res.substr(2));

                    _zw.ut.picker('date'); _zw.ut.maxLength();

                    p.find('select[data-field]').change(function () {
                        var fld = $(this).attr('data-field'), vlu = $(this).val();

                        if (fld == 'REQUEST') {
                            p.find('select[data-field="KIND"]').val(vlu == '방문' ? '수리 요청' : '');

                        } else if (fld == 'MODELNMA') {
                            $.ajax({
                                type: "POST",
                                url: '/ExS/Voc/ModelInfo',
                                data: '{model:"' + vlu + '"}',
                                async: false,
                                success: function (res) {
                                    if (res.substr(0, 2) == "OK") {
                                        var v = res.substr(2).split(String.fromCharCode(7));
                                        p.find('select[data-field="MODELCOLOR"]').html(v[0]);

                                        p.find(':checkbox[name="REASON"]').each(function () {
                                            if (v[1].indexOf(';') < 0) {
                                                $(this).prop('disabled', false);
                                            } else {
                                                $(this).prop('disabled', v[1].indexOf($(this).val() + ';') >= 0 ? false : true);
                                            }
                                        });

                                    } else bootbox.alert(res);
                                },
                                beforeSend: function () { } //로딩 X
                            });
                        }

                        if ((fld == 'MODELNMA' || fld == 'MODELNMB' || fld == 'MODELCOLOR') && vlu == '_ETC_') {
                            $(this).hide(); $(this).next().show();
                        }
                    });

                    p.find('.input-group .btn[data-for]').click(function () {
                        $(this).prev().val(''); $(this).parent().hide(); $(this).parent().prev().prop('selectedIndex', 0); $(this).parent().prev().show();
                    });

                    p.find('#ckb_99').click(function () {
                        var txt = $(this).parent().find('[data-field="REASONC"]');
                        txt.val(''); txt.prop('disabled', !$(this).prop('checked'))
                    });

                    p.find('.modal-footer .btn[data-zm-menu]').click(function () {
                        var mn = $(this).attr('data-zm-menu');
                        if (mn == 'save')  _zw.fn.saveVoc(p, m, oId);
                        else if (mn == 'delete') _zw.fn.deleteVoc(p, 'D', oId);
                        else if (mn == 'restore') _zw.fn.deleteVoc(p, 'S', oId);
                        else if (mn == 'remove') _zw.fn.deleteVoc(p, 'R', oId);
                    });

                    p.modal();
                }
            }
        });
    }

    _zw.fn.saveVoc = function (p, m, oid) { //alert(m + " : " + oid);
        var postJson = {}, iCnt = 0;
        p.find('[name="RegChangeData"]').each(function () {
            var fld = $(this).attr('data-field');
            if (fld && fld != '') {
                if ($.trim($(this).val()) == '') {
                    if (fld == "REQUEST") { bootbox.alert("필수항목[구분]이 누락됐습니다!", function () { $(this).focus(); });  return false; }
                    else if (fld == "KIND") { bootbox.alert("필수항목[VOC]이 누락됐습니다!", function () { $(this).focus(); }); return false; }
                    //else if (fld == "TROUBLE") {bootbox.alert("필수항목[불량유형]이 누락됐습니다!", function () { $(this).focus(); }); return false; }
                    //else if (fld == "MODELNMA") {bootbox.alert("필수항목[품명A]이 누락됐습니다!", function () { $(this).focus(); }); return false; }
                    //else if (fld == "PURCHDT") {bootbox.alert("필수항목[구입일자]이 누락됐습니다!", function () { $(this).focus(); }); return false; }
                    //else if (fld == "CUSTOMER") { bootbox.alert("필수항목[고객명]이 누락됐습니다!", function () { $(this).focus(); }); return false; }
                    //else if (fld == "CONTACT") { bootbox.alert("필수항목[연락처]이 누락됐습니다!", function () { $(this).focus(); }); return false; }
                } else if (fld == "MODELNMA" || fld == "MODELNMB" || fld == "MODELCOLOR") {
                    if ($(this).val() == '_ETC_') {
                        var etcText = $(this).next().find('input');
                        if ($.trim(etcText.val()) == '') { bootbox.alert("[기타] 선택 경우 항목을 기입하십시오!", function () { etcText.focus(); }); return false; }
                    }
                }
                if ((fld == "MODELNMA" || fld == "MODELNMB" || fld == "MODELCOLOR") && $(this).val() == '_ETC_') {
                    postJson[fld] = $(this).next().find('input').val();
                } else {
                    postJson[fld] = $(this).val();
                }
            }
        });

        p.find(':checkbox[name="REASON"]:checked').each(function () {
            if ($(this).val() == '99') {
                var txt = $(this).parent().find('[data-field="REASONC"]'); iCnt++;
                if ($.trim(txt.val()) == '') { bootbox.alert("[기타] 선택 경우 항목을 기입하십시오!", function () { txt.focus(); }); return false; }
            } else {
                iCnt++;
            }
        });
        //if (iCnt == 0) {bootbox.alert("[고장원인]을 한개 이상 선택 하십시오!"); return false;}

        var reasonVal = '';
        p.find(':checkbox[name="REASON"]:checked').each(function () {
            reasonVal += $(this).val() + ';';
        });
        postJson["REASON"] = reasonVal;
        postJson["M"] = m == 'V' && oid != '' && oid != '0' ? 'M' : 'N';
        postJson["oid"] = oid;
        postJson["fdid"] = _zw.V.fdid;
        postJson["operator"] = _zw.V.current.operator;
        postJson["acl"] = _zw.V.current.acl;

        //console.log(postJson);

        var msg = (m == 'V' && oid != '' && oid) ? "해당 접수사항을 변경하시겠습니까?" : "해당 사항을 접수하시겠습니까?";
        bootbox.confirm(msg, function (rt) {
            if (rt) {
                $.ajax({
                    type: 'POST',
                    url: '/ExS/Voc/Save',
                    data: JSON.stringify(postJson),
                    success: function (res) {
                        if (res.substr(0, 2) == 'OK') {
                            bootbox.alert(res.substr(2), function () {
                                p.find("button[data-dismiss='modal']").click(); _zw.mu.refresh();
                            });
                        } else bootbox.alert(res);
                    }
                });
            }
        });
    }

    _zw.fn.deleteVoc = function (p, m, oid) { //alert(m + " : " + oid); return
        if (oid == null || oid == '' || oid == '0') return false;

        if (m == 'S') msg = '해당 등록건을 복구 하시겠습니까?'
        else if (m == 'D') msg = '해당 등록건을 삭제 하시겠습니까?';
        else if (m == 'R') msg = '해당 등록건을 제거 하시겠습니까?\n\r제거 경우 다시 복구 할 수 없습니다!';

        bootbox.confirm(msg, function (rt) {
            if (rt) {
                $.ajax({
                    type: 'POST',
                    url: '/ExS/Voc/Delete',
                    data: '{M:"' + m + '",oid:"' + oid + '",fdid:"' + _zw.V.fdid + '",operator:"' + _zw.V.current.operator + '",acl:"' + _zw.V.current.acl + '"}',
                    success: function (res) {
                        if (res.substr(0, 2) == 'OK') {
                            bootbox.alert(res.substr(2), function () {
                                p.find("button[data-dismiss='modal']").click(); _zw.mu.refresh();
                            });

                        } else bootbox.alert(res);
                    }
                });
            }
        });
    }

    _zw.fn.exportExcel = function () {
        var encQi = '{M:"xls",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",fdid:"' + _zw.V.fdid + '",opnode:"",ttl:"' + _zw.V.ttl + '"}';
        window.open('?qi=' + encodeURIComponent(_zw.base64.encode(encQi)), 'ifrView');
    }

    _zw.fn.goSearch = function (page, sort, dir) {//alert(1)
        //_zw.fn.initLv();

        sort = sort || ''; dir = dir || '';
        _zw.V.lv.sort = sort; _zw.V.lv.sortdir = dir;

        _zw.V.lv.page = (page) ? page : 1;
        _zw.V.lv.start = $('.z-lv-cond .datepicker .start-date').val();
        _zw.V.lv.end = $('.z-lv-cond .datepicker .end-date').val();

        var e = $('#_SearchText');
        if ($('#_Search').val()  != '' && e.length > 0) {
            var s = "['\\%^&\"*]";
            var reg = new RegExp(s, 'g');
            if (e.val().search(reg) >= 0) { alert(s + " 문자는 사용될 수 없습니다!"); e.val(''); return; }

            if ($.trim(e.val()) != '') {
                _zw.V.lv.search = $('#_Search').val();
                _zw.V.lv.searchtext = e.val();
            }
        }

        _zw.V.lv.cd1 = $('#_Cond1').val(); _zw.V.lv.cd2 = $('#_Cond2').val(); _zw.V.lv.cd3 = $('#_Cond3').val();
        _zw.V.lv.cd4 = $('#_Cond4').val(); _zw.V.lv.cd5 = $('#_Cond5').val(); _zw.V.lv.cd6 = $('#_Cond6').val();
        _zw.V.lv.cd7 = $('#_Cond7').val(); _zw.V.lv.cd8 = $('#_Cond8').val(); _zw.V.lv.cd9 = $('#_Cond9').val();

        _zw.fn.loadList();
    }

    _zw.fn.loadList = function () {
        var postData = _zw.fn.getLvQuery(true); //console.log(postData)
        var url = '?qi=' + encodeURIComponent(_zw.base64.encode(postData));

        $.ajax({
            type: "POST",
            url: url,
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    history.pushState(null, null, url);

                    var v = res.substr(2).split(_zw.V.lv.boundary); //console.log(JSON.parse(JSON.stringify($.trim(v[0]))))
                    $('#__List').html(v[0]);
                    $('#__ListCount').html(v[1]);
                    $('.pagination').html(v[2]);

                    $('#__ListCount select').change(function () {
                        _zw.V.lv.count = $(this).val(); _zw.V.lv.page = 1;
                        _zw.fn.goSearch(1);
                    });

                    $('.pagination li a.page-link').click(function () {
                        _zw.fn.goSearch($(this).attr('data-for'));
                    });

                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.getLvQuery = function () {
        var j = {};
        j["M"] = _zw.V.mode;
        j["ct"] = _zw.V.ct;
        j["ctalias"] = _zw.V.ctalias;
        j["ot"] = _zw.V.ot;
        j["alias"] = _zw.V.alias;
        j["xfalias"] = _zw.V.xfalias;
        j["fdid"] = _zw.V.fdid;
        j["acl"] = _zw.V.current.acl;
        j["opnode"] = _zw.V.opnode;
        j["ft"] = _zw.V.ft;
        //j["ttl"] = _zw.V.ttl;

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
        j["cd6"] = _zw.V.lv.cd6; j["cd7"] = _zw.V.lv.cd7; j["cd8"] = _zw.V.lv.cd8; j["cd9"] = _zw.V.lv.cd9;

        return JSON.stringify(j);
    }

    _zw.fn.initLv = function () {
        var sCnt = 50; //_zw.ut.getCookie('costLvCount');
        if ($('.z-list-page select').length > 0) sCnt = $('.z-list-page select').val();

        _zw.V.lv.tgt = '';
        _zw.V.lv.page = '1';
        _zw.V.lv.count = sCnt;
        _zw.V.lv.sort = '';
        _zw.V.lv.sortdir = '';
        _zw.V.lv.search = '';
        _zw.V.lv.searchtext = '';
        _zw.V.lv.start = '';
        _zw.V.lv.end = '';
        //_zw.V.lv.basesort = '';

        $('#_Search').val(''); $('#_SearchText').val('');
        $('#_Cond1').val(''); $('#_Cond2').val(''); $('#_Cond3').val(''); $('#_Cond4').val(''); $('#_Cond5').val('');
        $('#_Cond6').val(''); $('#_Cond7').val(''); $('#_Cond8').val(''); $('#_Cond9').val('');

        _zw.V.lv.cd1 = ''; _zw.V.lv.cd2 = ''; _zw.V.lv.cd3 = ''; _zw.V.lv.cd4 = ''; _zw.V.lv.cd5 = '';
        _zw.V.lv.cd6 = ''; _zw.V.lv.cd7 = ''; _zw.V.lv.cd8 = ''; _zw.V.lv.cd9 = '';
    }
});