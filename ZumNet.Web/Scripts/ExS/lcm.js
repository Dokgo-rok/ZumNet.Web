$(function () {

    $('[data-zv-menu="search"]').click(function () {
        _zw.fn.goSearch();
    });

    $('#_SearchText').keyup(function (e) {
        if (e.which == 13) _zw.fn.goSearch();
    });

    _zw.fn.viewCourse = function (m, id) {
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
            url: '/ExS/Lcm/CourseView',
            data: '{M:"' + mode + '",oid:"' + oId + '",ft:"' + _zw.V.ft + '",fdid:"' + _zw.V.fdid + '",operator:"' + _zw.V.current.operator + '",acl:"' + _zw.V.current.acl + '"}',
            success: function (res) {
                if (res.substr(0, 2) == 'OK') {
                    var p = $('#popForm');
                    p.html(res.substr(2));

                    _zw.ut.picker('date'); _zw.ut.maxLength(); _zw.fn.input(p.find('.modal-body')); _zw.fu.bind();

                    p.find('.custom-select[name="RegChangeData"]').on('change', function () {
                        var fld = $(this).attr('data-field');
                        if (fld == 'ClsCD1' || fld == 'ClsCD2' || fld == 'ClsCD3' || fld == 'ClsCD4') {
                            var fld2 = p.find('input[name="RegChangeData"][data-field="ClsDN' + fld.replace('ClsCD', '') + '"]');
                            if (fld == 'ClsCD4') {
                                if ($(this).val() == '--WRITE--') { fld2.val(''); fld2.show(); }
                                else { fld2.val($(this).children('option:selected').text()); fld2.hide(); }
                            } else {
                                fld2.val($(this).children('option:selected').text());
                            }
                            //console.log($(this).val() + " : " + fld2.val())

                            if (fld == 'ClsCD1') {
                                if (fld2.val() == '사내') {
                                    p.find('#_row_clscd1').show();
                                } else {
                                    p.find('#_row_clscd1').hide();
                                    p.find('input[name="RegChangeData"][data-field="InstructorID"]').val('');
                                    p.find('input[name="RegChangeData"][data-field="Instructor"]').val('');
                                    p.find('input[name="RegChangeData"][data-field="InstructorInfo1"]').val('');
                                    p.find('input[name="RegChangeData"][data-field="InstructorInfo2"]').val('');
                                }
                            }
                        }
                    });

                    p.find('.btn[data-zm-menu]').click(function () {
                        var mn = $(this).attr('data-zm-menu');
                        if (mn == 'delete' || mn == 'restore') {
                            var cmd = mn == 'restore' ? 'S' : 'D';
                            _zw.fn.deleteCourse(p, cmd, oId);
                        } else if (mn == 'edit') {
                            _zw.fn.viewCourse('M', oId);
                        } else if (mn == 'save') {
                            _zw.fn.saveCourse(p, oId);
                        }
                    });
                    p.modal();
                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.viewLcmInfo = function (m, ft) {
        m = m || '';
        var row = _zw.ut.eventBtn().parent().parent();
        var oId = row.attr('id').split('_')[1], courseId = row.attr('csid').split('_')[1];

        $.ajax({
            type: 'POST',
            url: '/ExS/Lcm/LcmInfo',
            data: '{M:"' + m + '",oid:"' + oId + '",csi:"' + courseId + '",ft:"' + ft + '",fdid:"' + _zw.V.fdid + '",operator:"' + _zw.V.current.operator + '",acl:"' + _zw.V.current.acl + '"}',
            success: function (res) {
                if (res.substr(0, 2) == 'OK') {
                    var p = $('#popForm');
                    p.html(res.substr(2));




                    p.modal();
                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.showInstLayer = function () {
        bootbox.alert('준비중!')
    }

    _zw.fn.saveCourse = function (p, id) {
        var postJson = {}, bReg = true;
        $('[name="RegChangeData"]').each(function () {
            var fld = $(this).attr('data-field');
            if (fld && fld != '') {
                if ($.trim($(this).val()) == '') {
                    if (fld == "ClsCD1") { bootbox.alert("필수항목[사내외]이 누락됐습니다!", function () { $(this).focus(); }); bReg = false; return false; }
                    else if (fld == "ClsCD2") { bootbox.alert("필수항목[교육방식]이 누락됐습니다!", function () { $(this).focus(); }); bReg = false; return false; }
                    else if (fld == "ClsCD3") { bootbox.alert("필수항목[교육유형]이 누락됐습니다!", function () { $(this).focus(); }); bReg = false; return false; }
                    else if (fld == "ClsDN4") { bootbox.alert("필수항목[교육분야]이 누락됐습니다!", function () { $(this).focus(); }); bReg = false; return false; }
                    else if (fld == "CourseDN") { bootbox.alert("필수항목[과정명]이 누락됐습니다!", function () { $(this).focus(); }); bReg = false; return false; }
                    else if (fld == "FromDate") { bootbox.alert("필수항목[교육시작일]이 누락됐습니다!", function () { $(this).focus(); }); bReg = false; return false; }
                    else if (fld == "ToDate") { bootbox.alert("필수항목[교육종료일]이 누락됐습니다!", function () { $(this).focus(); }); bReg = false; return false; }

                    if (fld == "Instructor" && $('[name="RegChangeData"][data-field="ClsCD1"]').val() == 'A10') {
                        bootbox.alert("사내교육 경우 [교육강사]를 선택하여야 합니다!", function () { $(this).focus(); }); bReg = false; return false;
                    }
                }
                postJson[fld] = fld == "ClsCD4" ? '' : $(this).val();
            }
        });
        if (!bReg) return false;

        postJson["attachlist"] = [];
        if (_zw.fu.fileList.length) {
            for (var i = 0; i < _zw.fu.fileList.length; i++) {
                var v = _zw.fu.fileList[i];
                if (v["attachid"] == '' || parseInt(v["attachid"]) == 0) postJson["attachlist"].push(v);
            }
        }
        postJson["attachcount"] = _zw.fu.fileList.length;
        postJson["M"] = id != '' && parseInt(id) > 0 ? 'M' : 'I'; //I(신규), M(수정)
        postJson["xfalias"] = 'lcm';
        postJson["oid"] = id;
        postJson["ft"] = _zw.V.ft;
        postJson["fdid"] = _zw.V.fdid;
        postJson["operator"] = _zw.V.current.operator;
        postJson["acl"] = _zw.V.current.acl;
        postJson["mail"] = '';

        //console.log(postJson);; return

        var msg = id != '' && parseInt(id) > 0 ? "해당 내용을 변경하시겠습니까?" : "해당 과정을 등록하시겠습니까?";
        bootbox.confirm(msg, function (rt) {
            if (rt) {
                var bGo = true;
                if (postJson["M"] == 'M') {//변경 가능 여부 체크
                    $.ajax({
                        type: "POST",
                        url: "/ExS/Lcm//CourseSave",
                        data: '{M:"CHECK",oid:"' + id + '",ft:"' + _zw.V.ft + '",fdid:"' + _zw.V.fdid + '",operator:"' + _zw.V.current.operator + '",acl:"' + _zw.V.current.acl + '"}',
                        async: false,
                        success: function (res) {
                            if (res != 'Y') {
                                if (res.substr(0, 1) == "A") {
                                    if (window.confirm(res.substr(1))) { //bootbox 경우 아래가 바로 실행됨!!
                                        postJson["mail"] = 'OK';
                                        
                                    } else bGo = false;
                                } else {
                                    bootbox.alert(res); bGo = false;
                                }
                            }
                        }
                    });
                }

                if (bGo) {
                    $.ajax({
                        type: "POST",
                        url: "/ExS/Lcm//CourseSave",
                        data: JSON.stringify(postJson),
                        success: function (res) {
                            if (res.substr(0, 2) == "OK") {
                                bootbox.alert(res.substr(2), function () {
                                    _zw.fn.initLv(); _zw.fn.loadList(); p.find("button[data-dismiss='modal']").click();
                                });
                            } else bootbox.alert(res);
                        }
                    });
                }
            }
        });
    }

    _zw.fn.deleteCourse = function (p, m, id) {
        if (id != '' && parseInt(id) > 0) {
            var msg = (m == 'S') ? '복구' : '삭제';
            bootbox.confirm("해당 과정을 " + msg + " 하시겠습니까?", function (rt) {
                if (rt) {
                    $.ajax({
                        type: "POST",
                        url: "/ExS/Lcm//CourseDelete",
                        data: '{M:"' + m + '",oid:"' + id + '",ft:"' + _zw.V.ft + '",fdid:"' + _zw.V.fdid + '",operator:"' + _zw.V.current.operator + '",acl:"' + _zw.V.current.acl + '"}',
                        success: function (res) {
                            if (res == "OK") {
                                bootbox.alert(msg + ' 하였습니다!', function () {
                                    _zw.fn.initLv(); _zw.fn.loadList(); p.find("button[data-dismiss='modal']").click();
                                });
                            } else bootbox.alert(res);
                        }
                    });
                }
            });
        }
    }

    _zw.fn.exportExcel = function () {
        var encQi = '{M:"xls",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",fdid:"' + _zw.V.fdid + '",opnode:"' + _zw.V.opnode + '",ft:"' + _zw.V.ft + '",ttl:"' + _zw.V.ttl + '"}';
        window.open('?qi=' + encodeURIComponent(_zw.base64.encode(encQi)), 'ifrView');
        //window.open('?qi=' + encodeURIComponent(_zw.base64.encode(encQi)));
    }

    _zw.fn.importFile = function () {
        bootbox.alert('준비중!')
    }

    _zw.fn.sendMail = function () {
        bootbox.alert('준비중!')
    }

    _zw.fn.sort = function (col) {
        var el = event.target ? event.target : event.srcElement;
        var dir = $(el).find('i').hasClass('fe-arrow-up') ? 'DESC' : 'ASC';
        _zw.fn.goSearch(null, col, dir);
    }

    _zw.fn.goSearch = function (page, sort, dir) {//alert(1)
        var tgt = '0';
        if (_zw.V.ft == 'LCM_MAIN') {
            if ($('#_Target').val() == 'PR') tgt = _zw.V.current.urid;
            else if ($('#_Target').val() == 'PD') tgt = _zw.V.current.deptid;

            _zw.V.mode = $('#_Target').val();
        }

        _zw.fn.initLv(tgt);

        sort = sort || ''; dir = dir || '';
        _zw.V.lv.sort = sort;
        _zw.V.lv.sortdir = dir;

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
        _zw.V.lv.cd4 = $('#_Cond4').val(); _zw.V.lv.cd5 = $('#_Cond5').val();

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

        j["cd1"] = _zw.V.lv.cd1; j["cd2"] = _zw.V.lv.cd2; j["cd3"] = _zw.V.lv.cd3; j["cd4"] = _zw.V.lv.cd4; j["cd5"] = _zw.V.lv.cd5; j["cd6"] = _zw.V.lv.cd6; j["cd7"] = _zw.V.lv.cd7;

        return JSON.stringify(j);
    }

    _zw.fn.initLv = function (tgt) {
        var sCnt = 50; //_zw.ut.getCookie('costLvCount');
        if ($('.z-list-page select').length > 0) sCnt = $('.z-list-page select').val();

        _zw.V.lv.tgt = tgt;
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
        //$('#_Cond1').val(''); $('#_Cond2').val(''); $('#_Cond3').val(''); $('#_Cond4').val(''); $('#_Cond5').val('');
        _zw.V.lv.cd1 = ''; _zw.V.lv.cd2 = ''; _zw.V.lv.cd3 = ''; _zw.V.lv.cd4 = ''; _zw.V.lv.cd5 = ''; _zw.V.lv.cd6 = ''; _zw.V.lv.cd7 = '';
    }
});