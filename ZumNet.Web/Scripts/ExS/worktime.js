//근무관리 메인, 리스트뷰

$(function () {

    $('#__LeftMenu .sidenav-toggle').click(function (e) {
        e.preventDefault();

        $(this).next().slideToggle(300, function () {
            $(this).parent().toggleClass('open');
        });
    });

    $('[data-zv-menu="search"]').click(function () {
        _zw.fn.goSearch();
    });

    $('#_SearchText').keyup(function (e) {
        if (e.which == 13) _zw.fn.goSearch();
    });

    $('#__List thead input:checkbox').click(function () {
        var b = $(this).prop('checked'), df = $(this).attr('data-for');
        if (df && df != '') {
            $('#__List tbody input:checkbox[data-for="' + df + '"]').each(function () {
                if (!$(this).prop('disabled'))  $(this).prop('checked', b);
            });
        } else {
            $('#__List tbody input:checkbox').each(function () {
                if (!$(this).prop('disabled'))  $(this).prop('checked', b);
            });
        }
    });

    $('.z-lv-menu .dropdown-menu[data-for] a').on('click', function (e) {
        e.preventDefault();

        var v = $(this).attr("data-val"); //console.log(v)
        $('#__List table .z-select[data-zf-field="' + $(this).parent().parent().attr("data-for") + '"]').each(function () {
            if ($(this).parent().parent().find('input[name="ckbRow"]').prop('checked')) {
                $(this).val(v);
                $(this).parent().prev().prev().find('input[data-zf-field="' + $(this).attr("data-zf-field") + '"]').val($(this).val());
                //console.log($(this).val() + " : " + $(this).attr("data-zf-field") + " : " + $(this).parent().prev().prev().find('input[data-zf-field="' + $(this).attr("data-zf-field") + '"]').val());
            }
        });
    });

    $('#__List table .z-select[data-zf-field]').change(function () {
        $(this).parent().prev().prev().find('input[data-zf-field="' + $(this).attr("data-zf-field") + '"]').val($(this).val());
        //console.log($(this).val() + " : " + $(this).attr("data-zf-field") + " : " + $(this).parent().prev().prev().find('input[data-zf-field="' + $(this).attr("data-zf-field") + '"]').val());
    });

    _zw.fn.reqCnt = function () {
        $.ajax({
            type: "POST",
            url: '/ExS/WorkTime/RequestCount',
            data: '{ur:"' + _zw.V.current.urid + '",chief:"' + _zw.V.current.chief + '",mo:"' + _zw.V.current.operator + '"}',
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    var cnt = res.substr(2).split(';');                    
                    $('.sidenav-item .z-lm-cnt').each(function () {
                        if ($(this).attr('data-for') == 'my') $(this).html('(' + cnt[0] + ')');
                        else if ($(this).attr('data-for') == 'member') $(this).html('(' + cnt[1] + ')');
                        else if ($(this).attr('data-for') == 'all') $(this).html('(' + cnt[2] + ')');
                    });

                } else bootbox.alert(res);
            },
            beforeSend: function () { }
        });
    }

    _zw.fn.viewEvent = function (ur, d, m) {
        m = m || '';
        if (m != '') {
            $.ajax({
                type: "POST",
                url: "/ExS/WorkTime/PersonStatus",
                data: '{M:"modal",tgt:"' + ur + '",vd:"' + d + '",dn:"' + m + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        var p = $('#popLayer');
                        p.html(res.substr(2));
                        p.modal();
                    } else {
                        bootbox.alert(res)
                    }
                },
                beforeSend: function () {}
            });
        } else {
            $.ajax({
                type: "POST",
                url: "/ExS/WorkTime/EventView",
                data: '{ur:"' + ur + '",wd:"' + d + '",page:"' + _zw.V.ft.toLowerCase() + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == 'OK') {
                        var p = $('#popBlank');
                        p.html(res.substr(2)).css('width', $(this).attr('data-width') + "px");

                        p.find("button[data-val]").click(function () {
                            _zw.fn.reqEvent(p.find("button[data-dismiss='modal']"), $(this).attr('data-val').split(';'));
                        });

                        p.modal();
                    }
                }
            });
        }
    }

    _zw.fn.modEvent = function (ur, d, m) {
        $.ajax({
            type: "POST",
            url: "/ExS/WorkTime/PersonStatus",
            data: '{M:"modal_mod",tgt:"' + ur + '",vd:"' + d + '",dn:"' + m + '"}',
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    var p = $('#popLayer'); p.html(res.substr(2)); p.modal();
                } else {
                    alert(res)
                }
            },
            beforeSend: function () { }
        });
    }

    _zw.fn.reqEvent = function (btn, d) {//console.log(btn)
        $.ajax({
            type: "POST",
            url: "/ExS/WorkTime/EventRequest",
            data: '{ur:"' + d[0] + '",wd:"' + d[1] + '",req:"' + d[2] + '",page:"' + _zw.V.ft.toLowerCase() + '",chief:"' + _zw.V.current["chief"] + '",mo:"' + _zw.V.current["operator"] + '"}',
            success: function (res) {
                //if (btn) btn.click();
                var p = $('#popBlank'); p.html(res.substr(2));

                p.find("button[data-zf-menu]").click(function () {
                    _zw.fn.sendReq($(this).attr('data-zf-menu'), p);
                });

                $('#_SubTable tbody tr').each(function () {
                    var wd = p.find('input[data-zf-field="workdate"]').val();
                    var ws = $(this).find('input[data-zf-field="workstatus"]').val();

                    $(this).find('input[data-zf-field="reset"]').on('click', function () {
                        if ($(this).prop('checked')) {
                            if (ws == 'A' || ws == 'Z') {
                                $(this).parent().next().html('<input class="" type="text" data-inputmask="date;yyyy-mm-dd" value="' + wd + '" style="width: 75px" />&nbsp;<input class="" type="text" data-inputmask="time;HH:MM:SS" value="" style="width: 65px" />');
                                _zw.fn.input($('#_SubTable'));
                            } else if (ws == 'B') $(this).parent().next().html('인증');
                            else if (ws == 'X') $(this).parent().next().html('승인');
                        } else {
                            $(this).parent().next().html('');
                        }
                    });
                });

                p.modal();
            }
        });
    }
        
    _zw.fn.viewWorkInfo = function (t1, t2, t3, t4, p1, p2, msg, h, d) {
        var el = event.target ? event.target : event.srcElement;

        var s = '<div class="modal-dialog">'
            + '<div class="modal-content bg-white z-list" style="box-shadow: 0px 5px 15px rgba(0,0,0,0.5)">'
            + '<div class="modal-header">'
            + '<h4 class="modal-title">' + $(el).parent().prev().text() + ' ' + d + ' 현황</h4>'
            + '<button type="button" class="close" data-dismiss="modal"><span>×</span></button>'
            + '</div>'
            + '<div class="modal-body">'

            + '<table class="table table-hover table-bordered text-center mb-0">'
            + '<thead><tr class="">'
            + '<th style="width: 40%">구분</th><th style="width: 30%">시작</th><th style="width: 30%">종료</th>'
            + '</tr></thead>'

            + '<tbody>'
            + '<tr><th>EKP 출퇴근</th><td>' + t1 + '</td><td>' + t2 + '</td>'
            + '<tr><th>세콤 출퇴근</th><td>' + t3 + '</td><td>' + t4 + '</td>'
            + '<tr><th>계획 시간</th><td>' + p1 + '</td><td>' + p2 + '</td>'
            + '<tr><th>근무시간</th><td colspan="2">' + h + ' 시간</td>'
            + '<tr><td colspan="3"><a href="javascript:" class="z-lnk-navy" onclick="_zw.fn.openEAFormSimple(' + msg + ')">관련결재문서</a></td>'

            + '</tbody>'

            + '</table>'

            + '</div>'
            + '<div class="modal-footer">'
            + '<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>'
            + '</div>'
            + '</div>'
            + '</div>'

        $('#popLayer').html(s).modal('show');
    }

    _zw.fn.sendReq = function (m, p) {//alert(m); return;
        var j = {}, s = [], iCnt = 0, ttl = '';

        if (m == 'send') {
            $('#_SubTable tbody tr input[data-zf-field="statusid"]').each(function () {
                if ($(this).prop('checked')) { iCnt++; return false; }
            });

            if (iCnt < 1) { bootbox.alert("조정 항목은 하나 이상 선택하십시오!"); return; }
            if ($('[data-zf-field="reason"]').val().trim() == '') { bootbox.alert("조정 사유를 입력 하십시오!"); return; }

            p.find('[data-zf-ftype="main"]').each(function () {
                j[$(this).attr('data-zf-field')] = $(this).val();
            });

            $('#_SubTable tbody tr').each(function () {
                var ck = $(this).find('[data-zf-field="statusid"]');
                if (ck.prop('checked')) {
                    ttl += (ttl == '' ? '' : ', ') + $(this).find('th').text();
                    var t = {};
                    $(this).find('[data-zf-ftype="sub"]').each(function () {
                        t[$(this).attr('data-zf-field')] = $(this).val();
                    });
                    s.push(t);
                }
            });
            j["subject"] = ttl + ' 조정 요청';
            j["sub"] = s;

            bootbox.confirm("선택한 항목으로 조정 요청하시겠습니까?", function (rt) {
                if (rt) {
                    $.ajax({
                        type: "POST",
                        url: "/ExS/WorkTime/SendRequest",
                        data: JSON.stringify(j),
                        success: function (res) {
                            if (res == 'OK') {
                                bootbox.alert("요청 처리 성공!", function () {
                                    //이후 처리
                                    encQi = _zw.base64.encode('{ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ttl:"근무조정 신청현황",fd:"PersonRequest"}');
                                    window.location.href = '/ExS/WorkTime?qi=' + encQi;
                                });
                                    
                            } else bootbox.alert(res);
                        }
                    });
                }
            });
        } else {
            //p.find("button[data-dismiss='modal']").click(); $('input[name="rdoSearch"]')[m == 'approval' ? 1 : 2].click(); return
            var role = p.find('input[data-zf-role="step"]').val(), msg = '';
            //var fld = role == 'D' ? 'fapvcmnt' : 'sapvcmnt';

            if (m == 'reject') {
                msg = '미승인';

                if (p.find('[data-zf-ftype="main"][data-zf-field="apvcmnt"]').val().trim() == '') { bootbox.alert("미승인 사유를 입력 하십시오!"); return; }

            } else {
                msg = '승인';

                if (role == 'A') {
                    $('#_SubTable tbody tr input[data-zf-field="statusid"]').each(function () {
                        var ws = $(this).parent().find('input[data-zf-field="workstatus"]');
                        if ($(this).prop('checked')) {
                            var c = $(this).parent().parent().find('input[data-zf-field="reset"]');
                            if (c.prop('checked')) {
                                if (ws.val() == 'A' || ws.val() == 'Z') {
                                    var fBox = c.parent().next().find('input').first(), lBox = c.parent().next().find('input').last();
                                    if ($.trim(fBox.val()) == '') { bootbox.alert("날짜를 입력 하십시오!", function () { fBox.focus(); }); iCnt = 99; return false; }
                                    else if ($.trim(lBox.val()) == '') { bootbox.alert("시간을 입력 하십시오!", function () { lBox.focus(); }); iCnt = 99; return false; }
                                }
                                iCnt++; return false;
                            }
                        }
                    });
                    if (iCnt == 99) return;
                    if (iCnt < 1) { bootbox.alert("승인 항목을 하나 이상 선택하십시오!"); return; }

                    $('#_SubTable tbody tr').each(function () {
                        var ck = $(this).find('[data-zf-field="statusid"]');
                        var ck2 = $(this).find('[data-zf-field="reset"]');
                        var ws = $(this).find('[data-zf-field="workstatus"]');

                        if (ck.prop('checked') && ck2.prop('checked')) {
                            var t = {};
                            t['resettime'] = $(this).find('[data-inputmask]').length > 0 ? $(this).find('[data-inputmask]').first().val() + ' ' + $(this).find('[data-inputmask]').last().val() : '';
                            $(this).find('[data-zf-ftype="sub"]').each(function () {
                                if ($(this).attr('data-zf-field') == 'reset') {
                                    t['reset'] = ws.val() == 'B' ? 'N' : ws.val();
                                } else t[$(this).attr('data-zf-field')] = $(this).val();
                            });
                            s.push(t);
                        }
                    });
                    j["sub"] = s;
                }
            }

            p.find('[data-zf-ftype="main"]').each(function () {
                j[$(this).attr('data-zf-field')] = $(this).val();
            });

            j["step"] = role;
            j["ss"] = m;

            bootbox.confirm("[" + msg + "] 처리 하시겠습니까?", function (rt) {
                if (rt) {
                    $.ajax({
                        type: "POST",
                        url: "/ExS/WorkTime/DoRequest",
                        data: JSON.stringify(j),
                        success: function (res) {
                            if (res == 'OK') {
                                bootbox.alert(msg + " 처리 성공!", function () {
                                    //이후 처리
                                    p.find("button[data-dismiss='modal']").click();
                                    $('input[name="rdoSearch"]')[m == 'approval' ? 1 : 2].click();
                                    _zw.fn.reqCnt(); _zw.fn.goSearch();
                                });

                            } else bootbox.alert(res);
                        }
                    });
                }
            });
        }
    }
    
    _zw.fn.setPlan = function (mn) {
        var v = [];
        if (mn == "save" || mn == "request") {
            $('#__List tbody input[name="ckbRow"]:checked').each(function () {
                var p = $(this).parent().parent();
                var s = {};
                p.find("[data-zf-field]").each(function () {
                    s[$(this).attr('data-zf-field').toLowerCase()] = $(this).val();
                });
                //s["plantype"] = ''; //임시
                v.push(s);
            });
        } else if (mn == "send") {
            $('#__List thead th[data-for]').each(function () {
                var tgtId = $(this).attr('data-for');
                var tgt = [];
                $('#__List tbody input[name="ckbRow"][data-for="' + tgtId + '"]').each(function () {
                    if ($(this).prop('checked')) {
                        var s = {};
                        $(this).parent().find("[data-zf-field]").each(function () {
                            s[$(this).attr('data-zf-field').toLowerCase()] = $(this).val();
                        });
                        tgt.push(s);
                    }
                });
                if (tgt.length > 0) {
                    var j = {}; j['ur'] = tgtId; j["req"] = tgt; v.push(j);
                }
            });

            //console.log(v); return;
        }

        var msg = '', req = '';
        if (mn == 'save') { msg = "저장"; req = "SavePlan"; }
        else if (mn == 'request') { msg = "승인 요청"; req = "SavePlan"; }
        else if (mn == 'send') { msg = "처리"; req = "DoPlan"; }

        var postData = {};
        if (v.length == 0) {
            bootbox.alert(msg + "할 일자를 선택하십시오!"); return false;
        } else {
            postData['mode'] = mn;
            postData['sub'] = v;
        }

        bootbox.confirm(msg + " 하시겠습니까?", function (rt) {
            if (rt) {
                $.ajax({
                    type: "POST",
                    url: "/ExS/WorkTime/" + req,
                    data: JSON.stringify(postData),
                    success: function (res) {
                        if (res == 'OK') {
                            bootbox.alert(msg + " 하였습니다", function () {
                                //이후 처리
                                _zw.fn.goSearch();
                            });

                        } else bootbox.alert(res);
                    }
                });
            }
        });
    }

    _zw.fn.setCode = function () {
        var el = event.target, p = el.parentNode; do { p = p.parentNode; } while ($(p).prop('tagName') != 'TR');
        var k3 = '', i1 = '', i2 = '', i3 = '', i4 = '', i5 = '';
        
        $(p).find("[data-zf-field]").each(function () {
            switch ($(this).attr('data-zf-field')) {
                case 'k3': k3 = $(this).attr('data-val'); break;
                case 'item1': i1 = $(this).val(); break;
                case 'item2': i2 = $(this).val(); break;
                case 'item3': i3 = $(this).val(); break;
            }
        });

        $.ajax({
            type: "POST",
            url: "/Common/SetCode",
            data: '{k1:"system",k2:"worktime",k3:"' + k3 + '",item1:"' + i1 + '",item2:"' + i2 + '",item3:"' + i3 + '",item4:"' + i4 + '",item5:"' + i5 + '"}',
            success: function (res) {
                if (res == "OK") bootbox.alert("저장")
                else bootbox.alert(res);
            }
        })
    }

    _zw.fn.sort = function (col) {
        var el = event.target ? event.target : event.srcElement;
        var dir = $(el).find('i').hasClass('fe-arrow-up') ? 'DESC' : 'ASC';
        _zw.fn.goSearch(col, dir);
    }
    
    _zw.fn.loadList = function () {
        var postData = _zw.fn.getLvQuery(true);
        var url = '?qi=' + _zw.base64.encode(postData); //encodeURIComponent(postData);

        $.ajax({
            type: "POST",
            url: url,
            success: function (res) {
                if (res.substr(0, 2) == "OK") {

                    $('#__List').html(res.substr(2));
                    if (_zw.V.ft == 'WorkTimeMgr') _zw.fn.input($('#__List'));

                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.goSearch = function (sort, dir) {
        _zw.fn.initLv(_zw.V.current.urid);

        sort = sort || ''; dir = dir || '';
        _zw.V.lv.sort = sort;
        _zw.V.lv.sortdir = dir;

        if (_zw.V.ft == 'PersonRequest' || _zw.V.ft == 'MemberRequest' || _zw.V.ft == 'RequestMgr') {
            _zw.V.lv.start = $('#_SearchYear').val(); _zw.V.opnode = $('input[name="rdoSearch"]:checked').val();

        } else if (_zw.V.ft == 'WorkTimeMgr') {
            _zw.V.lv.start = $('#_SearchYear').val();

        } else {
            if ($('#_SearchText').length > 0) {
                var e = $('#_SearchText');
                var s = "['\\%^&\"*]";
                var reg = new RegExp(s, 'g');
                if (e.val().search(reg) >= 0) { alert(s + " 문자는 사용될 수 없습니다!"); e.val(''); return; }

                _zw.V.lv.search = 'O'; //성명+부서
                _zw.V.lv.searchtext = e.val();
            }
            _zw.V.lv.start = $('#_SearchYear').val() + "-" + _zw.ut.zero($('#_SearchMonth').val()) + "-01"; //alert(vd)
        }
        
        _zw.fn.loadList();
    }

    _zw.fn.getLvQuery = function (lv) {
        var j = {};
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

        if (lv) {
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
        }

        //alert(j["permission"])
        return JSON.stringify(j);
    }

    _zw.fn.initLv = function (tgt) {
        //var sCnt = _zw.ut.getCookie('eaLvCount');

        _zw.V.lv.tgt = tgt;
        _zw.V.lv.page = '1';
        _zw.V.lv.count = 0;
        _zw.V.lv.sort = '';
        _zw.V.lv.sortdir = '';
        _zw.V.lv.search = '';
        _zw.V.lv.searchtext = '';
        _zw.V.lv.start = '';
        _zw.V.lv.end = '';
        _zw.V.lv.basesort = '';
    }

    if (_zw.V.ft == 'WorkTimeMgr') _zw.fn.input($('#__List'));

    _zw.fn.reqCnt();
});