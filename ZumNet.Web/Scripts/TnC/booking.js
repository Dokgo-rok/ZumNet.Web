$(function () {
    $('.messages-sidebox a[data-zl-menu]').click(function () {
        var mn = $(this).attr("data-zl-menu"); console.log(mn)

        if (mn.toLowerCase() == 'list' || mn.toLowerCase() == 'mylist') {
            var encQi = '{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + _zw.V.ot + '",fdid:"' + _zw.V.fdid + '",opnode:"",ft:"' + mn + '",ttl:"' + $.trim($(this).text()) + '"}';
            window.location.href = '/TnC/Booking/List?qi=' + _zw.base64.encode(encQi);
        }
    });

    $('a[data-zp-menu], button[data-zp-menu]').click(function () {
        var mn = $(this).attr('data-zp-menu');

        if (mn == 'prev' || mn == 'next') {
            var tgt = $(this).parent().find('span[data-for="DateDesc"]');
            _zw.V.lv.tgt = moment(tgt.attr('data-val')).add(mn == 'prev' ? -1 : 1, 'M').format('YYYY-MM-DD'); //alert(_zw.V.lv.tgt)
            tgt.attr('data-val', _zw.V.lv.tgt);

            var postData = _zw.fn.getLvQuery(true);
            var url = _zw.V.current.page + '?qi=' + _zw.base64.encode(postData);

            $.ajax({
                type: "POST",
                url: url,
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        history.pushState(null, null, url);

                        var v = res.substr(2).split(_zw.V.lv.boundary);
                        tgt.html(v[1]); $('#__List').html(v[0]);

                        $('[data-toggle="tooltip"][title!=""]').tooltip();

                    } else bootbox.alert(res);
                }
            });
        }
    });

    $('.z-list-head .btn[data-zv-menu]').click(function () {
        var mn = $(this).attr("data-zv-menu");
        if (mn == 'prev' || mn == 'next') {
            var format = 'M', iAdd = (mn == 'prev') ? -1 : 1;
            if (_zw.V.ft.toLowerCase() == 'day' || _zw.V.ft.toLowerCase() == 'week') {
                format = 'd';
                if (_zw.V.ft.toLowerCase() == 'week') iAdd = mn == 'prev' ? -7 : 7;
            }
            var tgt = moment(_zw.V.lv.tgt).add(iAdd, format);

            _zw.V.lv.tgt = tgt.format('YYYY-MM-DD');
            _zw.V.ttl = '';
            _zw.fn.loadList();
        }
    });

    $('.z-list-head a[data-zc-menu]').click(function () {
        var mn = $(this).attr("data-zc-menu");
        _zw.V.ttl = ''; _zw.V.ft = mn;
        window.location.href = '/TnC/Booking/Calendar?qi=' + _zw.base64.encode(_zw.fn.getLvQuery());
    });

    $('#ddlSchType').on('change', function () {
        _zw.V.ttl = ''; _zw.V.lv.sort = $(this).val();
        _zw.fn.loadList();
    });

    $('.zc-dayview .zc-daygrid .zc-col-header .switcher-input').on('change', function () {
        if ($(this).prop('checked')) $('.zc-dayview .zc-daygrid .zc-timegrid-body .zc-timegrid-outtime').removeClass('d-table-row');
        else $('.zc-dayview .zc-daygrid .zc-timegrid-body .zc-timegrid-outtime').addClass('d-table-row');
    });

    $('#__CtDashboard #ddlResClass').on('change', function () { //console.log(_zw.cdr.res["cls_" + $(this).val()])
        var s = '', t = '';
        if ($(this).val() != '') {
            $.each(_zw.cdr.res["cls_" + $(this).val()], function (idx, d) {
                s += '<option value="' + d['oid'] + '">' + d['name'] + '</option>';
            });

            if (s != '') {
                s = '<option value="ALL">전체</option>' + s;
                $('#__CtDashboard #ddlResList').html(s);
            }
        } else {
            $('#__CtDashboard #ddlResList').html('<option value="">자원 분류를 선택하세요..</option>');
        }
    });

    $('#__CtDashboard .btn[data-zv-menu="search"]').click(function () {
        _zw.fn.loadBar();
    });

    _zw.mu.writeEvent = function (ca, dt, hm, pt, partid) { //일정, 자원예약
        //alert(ca + " : " + dt + " : " + hm + " : " + pt + " : " + partid)
        ca = ca || ''; dt = dt || ''; hm = hm || ''; pt = pt || ''; partid = partid || '0';
        if (dt == '' && _zw.V.lv.tgt != '') dt = _zw.V.lv.tgt;

        _zw.V.wnd = 'modal';
        _zw.V.ot = pt;
        _zw.V.fdid = partid;
        _zw.V.lv.cd1 = hm;

        $.ajax({
            type: "POST",
            url: ca == 'booking' ? '/TnC/Booking/Write' : '/TnC/Schedule/Write',
            data: _zw.fn.getAppQuery(dt),
            success: function (res) {
                if (res.substr(0, 2) == 'OK') {
                    var v = res.substr(2).split(_zw.V.lv.boundary);
                    var p = $('#popForm');
                    p.html(v[0]); _zw.V.app = JSON.parse(v[1]); //console.log(_zw.V.app);

                    _zw.ut.picker('date'); _zw.ut.maxLength();

                    p.find('.btn[data-toggle="popover"]').popover({
                        html: true,
                        content: function () { return p.find('[data-help="file"]').html(); }
                    });

                    p.find('input[name="ckbRepeat"]').click(function () {
                        if ($(this).prop('checked')) {
                            _zw.cdr.showRepeat(p, 'init', 'txtStart;txtEnd', 'cbStart', 'cbEnd');
                        } else {
                            _zw.cdr.closeRepeat(p);
                        }
                    });

                    p.find('input[name="ckbAllDay"]').click(function () {
                        $('#cbStart').prop('disabled', $(this).prop('checked')); $('#cbEnd').prop('disabled', $(this).prop('checked'));
                    });

                    $('.btn[data-zf-menu="openResList"]').click(function () {
                        $.ajax({
                            type: "POST",
                            url: '/TnC/Booking/ResourceList',
                            data: '{ct:"' + _zw.V.ct + '",operator:"' + _zw.V.current.operator + '"}',
                            success: function (res) {
                                if (res.substr(0, 2) == 'OK') {
                                    var resWnd = $('#popBlank');
                                    resWnd.html(res.substr(2));

                                    resWnd.find('.accordion .card-body .btn[data-val]').click(function () {
                                        var v = $(this).attr('data-val').split(';');
                                        var partid = v[1].split('.');
                                        var ttl = $(this).parent().parent().prev().find('a[data-toggle]').text() + ' / ' + $(this).text();

                                        if (v[0] == p.find('input[data-for="SelectedPartType"]').val() && partid[2] == p.find('input[data-for="SelectedPartID"]').val()) {
                                            bootbox.alert('이미 선택된 자원입니다!');
                                        } else {
                                            //console.log(ttl + " : " + partid[2] + " : " + v[2])
                                            p.find('span[data-for="SelectedPartName"]').html(ttl);
                                            p.find('input[data-for="SelectedPartID"]').val(partid[2]);
                                            p.find('input[data-for="SelectedPartType"]').val(v[0]);
                                            p.find('input[data-for="SelectedApproval"]').val(v[2]);

                                            resWnd.find("button[data-dismiss='modal']").click();
                                        }
                                    });

                                    resWnd.modal();

                                } else {
                                    bootbox.alert(res);
                                }
                            }
                        });
                    });

                    p.find('.btn[data-zm-menu]').click(function () {
                        var mn = $(this).attr('data-zm-menu');
                        if (mn == 'delete') {
                            _zw.fn.deleteEvent([p], mi, dt);

                        } else if (mn == 'edit') {
                            

                        } else if (mn == 'layer-mod' || mn == 'layer-del') {
                            var info = $('#popBlank');
                            info.html(p.find('#_LayerRptProc').html());

                            if (mn == 'layer-mod') info.find('[data-for="rpt-modify"]').removeClass('d-none');
                            else info.find('[data-for="rpt-delete"]').removeClass('d-none');

                            info.find('.btn[data-zm-menu="confirm"]').click(function () {
                                if (mn == 'layer-mod') {
                                    _zw.fn.viewEvent(info, dt, '', mi, info.find('input[name="popup_repeat_mode"]:checked').val());
                                } else {
                                    _zw.fn.deleteEvent([info, p], mi, dt, info.find('input[name="popup_repeat_del_mode"]:checked').val())
                                }
                            });
                            info.modal();

                        } else if (mn == 'cmnt-reg' || mn == 'cmnt-mod' || mn == 'cmnt-del' || mn == 'cmnt-cancel') {

                        }
                    });

                    p.modal();
                }
            }
        });
    }

    _zw.mu.readEvent = function (ca, mi, pt, partid) { //alert(ca + " : " + mi + " : " + pt + " : " + partId); return
        if (mi == null || mi == '' || parseInt(mi) == '0') return false;
        ca = ca || ''; pt = pt || ''; partid = partid || '0';

        _zw.V.wnd = 'modal';
        _zw.V.ot = pt;
        _zw.V.appid = mi;

        $.ajax({
            type: "POST",
            url: ca == 'booking' ? '/TnC/Booking/Read' : '/TnC/Schedule/Read',
            data: _zw.fn.getAppQuery(),
            success: function (res) {
                if (res.substr(0, 2) == 'OK') {
                    var v = res.substr(2).split(_zw.V.lv.boundary);
                    var p = $('#popForm');
                    p.html(v[0]); _zw.V.app = JSON.parse(v[1]); console.log(_zw.V.app);


                    p.modal();
                } else {
                    bootbox.alert(res);
                }
            }
        });
    }

    _zw.fn.saveEvent = function (dt, opt) {
        var p = $('#popForm');
        dt = dt || ''; opt = opt || '';

        if ($.trim($("#txtSubject").val()) == '') { bootbox.alert("제목을 입력하십시오!", function () { $("#txtSubject").focus(); }); return false; }
        if (!moment($("#txtStart").val()).isValid()) { bootbox.alert("시작일을 확인하십시오!", function () { $("#txtStart").focus(); }); return false; }
        if (!moment($("#txtEnd").val()).isValid()) { bootbox.alert("종료일을 확인하십시오!", function () { $("#txtEnd").focus(); }); return false; }

        var mode = (_zw.V.app && _zw.V.app != '' && parseInt(_zw.V.app) > 0) ? "edit" : "new";
        var postJson = {}; //_zw.V.app;
        //postJson["cmntlist"] = []; postJson["sharedlist"] = []; //저장 중 필요 없는 목록 제거
        postJson["repeat"] = {};
        postJson["partlist"] = [];
        postJson["attachlist"] = [];

        postJson["mode"] = mode;
        postJson["appid"] = _zw.V.appid;

        var vRRule = _zw.cdr.getRepeat(p).split('|'); console.log(vRRule);
        var rptEnd = $("#txtRepeatEnd");
        if (vRRule == 'CHECK') { bootbox.alert("반복요일을 선택하십시오!"); return false; }
        else if (vRRule == 'INVALID') { bootbox.alert("반복종료일은 확인하십시오!", function () { rptEnd.focus(); }); return false; }
        else if (vRRule == 'END') { bootbox.alert("반복종료일은 시작일 이후로 선택하십시오!", function () { rptEnd.focus(); }); return false; }

        var ttl = p.find('span[data-for="SelectedPartName"]').html();
        var partId = p.find('input[data-for="SelectedPartID"]').val();
        var partType = p.find('input[data-for="SelectedPartType"]').val();

        if (ttl.indexOf('회의실') >= 0 && vRRule[0] != '0') { //2020-11-09 회의실 경우 1달 이상 되풀이 지정 불가
            console.log(moment(rptEnd.val()).diff(moment($("#txtStart").val()), 'M', true));
            if (rptEnd.val() == '' || moment(rptEnd.val()).diff(moment($("#txtStart").val()), 'M', true) > 1) {
                bootbox.alert("[회의실] 경우 1달 이내 반복 가능합니다!", function () { rptEnd.focus(); }); return false;
            }
        }

        var rptInfo = {};
        if (mode == "edit") {
            rptInfo["change"] = ($("#hdRepeatType").val() != vRRule[0] || $("#hdInterval").val() != vRRule[4] || $("#hdConDay").val() != vRRule[5] || $("#hdRepeatEnd").val() != vRRule[1]
                || $("#txtStart").val() != $("#hdPeriodFrom").val() || $("#cbStart").val() != $("#hdStartTime").val() || $("#cbEnd").val() != $("#hdEndTime").val()) ? "Y" : "N";
        }
        
        rptInfo["type"] = vRRule[0];
        rptInfo["end"] = vRRule[1];
        rptInfo["count"] = vRRule[2];
        rptInfo["intervaltype"] = vRRule[3];
        rptInfo["interval"] = vRRule[4];
        rptInfo["conday"] = vRRule[5];
        rptInfo["conweek"] = vRRule[6];
        rptInfo["condate"] = vRRule[7];
        rptInfo["changeopt"] = opt;
        rptInfo["changedate"] = dt;
        postJson["repeat"] = rptInfo;

        postJson["ot"] = mode == 'new' ? 'UR' : _zw.V.ot;
        postJson["otid"] = mode == 'new' ? _zw.V.current.urid : _zw.V.fdid;
        postJson["schtype"] = $('#ddlSchType').val();
        postJson["task"] = "0";
        postJson["inherited"] = "Y";
        postJson["state"] = "0";
        postJson["priority"] = $("#ckbPrioriy").prop('checked') ? "H" : "";

        postJson["subject"] = $("#txtSubject").val();
        postJson["location"] = $("#txtLocation").val();
        postJson["body"] = $("#txtBody").val();
        postJson["periodfrom"] = $("#txtStart").val();
        postJson["start"] = p.find('input[name="ckbAllDay"]').prop('checked') ? '00:00' : $("#cbStart").val();
        postJson["periodto"] = $("#txtEnd").val();
        postJson["end"] = p.find('input[name="ckbAllDay"]').prop('checked') ? '24:00' : $("#cbEnd").val();
        postJson["term"] = moment(postJson["periodto"] + ' ' + postJson["end"]).diff(moment(postJson["periodfrom"] + ' ' + postJson["start"]), 'minutes');

        if (partId != '') {
            var partInfo = {};
            partInfo["ot"] = 'FD';
            partInfo["partid"] = partId;
            partInfo["partdn"] = ttl;
            partInfo["partmail"] = '';
            partInfo["parttype"] = partType;
            partInfo["state"] = '0';
            partInfo["confirmed"] = 'N';
            partInfo["sendmail"] = 'N';
            partInfo["approval"] = p.find('input[data-for="SelectedApproval"]').val();
            postJson["partlist"].push(partInfo);
        }

        postJson["alarm"] = "0";
        postJson["creurid"] = _zw.V.current.urid;
        postJson["credept"] = _zw.V.current.dept;
        postJson["credpid"] = _zw.V.current.deptid;

        var fi = $.trim($("#FILEINFO").val()), nCnt = 0, rt = '';
        if (fi.length > 0) {
            //rt = moveFileToStorage(fi); //파일정보 xml 문자열로 반환
            //if (rt.substr(0, 2) == "OK") { rt = rt.substr(2); } else { alert(rt); return; }
            //nCnt = (fi.split(String.fromCharCode(8)).length > 1) ? 2 : 1;
        }
        postJson["attachcount"] = nCnt; // 0, 1, 2
        //postJson["attachlist"] = [];
        postJson["taskact"] = "";

        console.log(postJson);

        bootbox.confirm("저장 하시겠습니까?", function (rt) {
            if (rt) {
                $.ajax({
                    type: "POST",
                    url: "/TnC/Booking/EventSave",
                    data: JSON.stringify(postJson),
                    success: function (res) {
                        if (res.substr(0, 2) == 'OK') {
                            bootbox.alert(res.substr(2), function () {
                                if (p) p.find("button[data-dismiss='modal']").click();
                                location.reload();
                            });

                        } else bootbox.alert(res);
                    }
                });
            }
        });
    }

    _zw.fn.bindBarCtrl = function () {
        $('[data-toggle="tooltip"][title!=""]').tooltip();

        $('.zc-bar .zc-bar-middle .zc-bar-fill').tooltip({
            html: true,
            title: function () { return $(this).next().html(); }
        });

        $('#__ResSchedule .btn[data-zv-menu]').click(function () {
            var mn = $(this).attr("data-zv-menu"), tgt = $(this).parent().find('span[data-for="DateDesc"]');
            if (mn == 'prev' || mn == 'next') {
                $('#__CtDashboard input.start-date').val(moment(tgt.attr('data-val')).add(mn == 'prev' ? -1 : 1, 'd').format('YYYY-MM-DD'))
                _zw.fn.loadBar();
            }
        });

        $('.zc-bar .zc-bar-unfill, .zc-bar .zc-bar-fill').click(function () {
            var p = $(this).parent(); do { p = p.parent(); } while (!p.hasClass('zc-bar'));
            if ($(this).hasClass('zc-bar-fill') && $(this).attr('data-appid')) {
                _zw.mu.readEvent('booking', $(this).attr('data-appid'), p.attr('data-parttype'), p.attr('data-partid'));
            } else {
                _zw.mu.writeEvent('booking', $('#__ResSchedule thead span[data-for="DateDesc"]').attr('data-val')
                    , $(this).parent().parent().attr('data-time'), p.attr('data-parttype'), p.attr('data-partid'));
            }
        });
    }

    _zw.fn.loadBar = function () {
        if ($('#__CtDashboard #ddlResClass').val() != '') {
            //var rm = $('#__CtDashboard #ddlResList').val().indexOf('') > 0 ? '' : $('#__CtDashboard #ddlResList').children('option:selected').text();

            var j = {};
            j['cls'] = $('#__CtDashboard #ddlResClass').val();
            j['dt'] = $('#__CtDashboard input.start-date').val();
            j['res'] = [];

            if ($('#__CtDashboard #ddlResList').val() == 'ALL') {
                j['res'] = _zw.cdr.res['cls_' + $('#__CtDashboard #ddlResClass').val()];
            } else {
                var v = _zw.cdr.res['cls_' + $('#__CtDashboard #ddlResClass').val()].find(function (element) {
                    if (element.oid == $('#__CtDashboard #ddlResList').val()) return true;
                });
                j['res'].push(v);
            }
            //console.log(JSON.stringify(j));

            $.ajax({
                type: "POST",
                url: "/TnC/Booking/ResourceSchedule",
                data: JSON.stringify(j),
                success: function (res) {
                    if (res.substr(0, 2) == 'OK') {
                        $('#__ResSchedule').html(res.substr(2)); _zw.fn.bindBarCtrl();
                    } else bootbox.alert(res);
                }
            });
        }
    }

    _zw.fn.loadList = function () {
        var postData = _zw.fn.getLvQuery(true); //console.log(postData)
        var url = '?qi=' + _zw.base64.encode(postData);

        $.ajax({
            type: "POST",
            url: url,
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    history.pushState(null, null, url);

                    var v = res.substr(2).split(_zw.V.lv.boundary); //console.log(JSON.parse(JSON.stringify($.trim(v[0]))))
                    $('.z-list-head [data-for="DateDesc"]').html(v[1]);
                    $('#__List').html(v[0]);

                    $('[data-toggle="tooltip"][title!=""]').tooltip();
                    $('.zc-month .zc-calendar .zc-day-event a[data-toggle="tooltip"], .zc-week a[data-toggle="tooltip"], .zc-dayview a[data-toggle="tooltip"]').tooltip({
                        html: true,
                        title: function () { return $(this).next().html(); }
                    });

                } else bootbox.alert(res);
            }
        });
    }

    $('.zc-month .zc-calendar .zc-day-event a[data-toggle="tooltip"], .zc-week a[data-toggle="tooltip"], .zc-dayview a[data-toggle="tooltip"]').tooltip({
        html: true,
        title: function () { return $(this).next().html(); }
    });

    _zw.fn.getLvQuery = function () {
        var j = {};
        j["M"] = _zw.V.mode;
        j["ct"] = _zw.V.ct;
        j["ctalias"] = _zw.V.ctalias;
        j["ot"] = _zw.V.ot;
        j["fdid"] = _zw.V.fdid;
        j["alias"] = _zw.V.alias;
        j["xfalias"] = _zw.V.xfalias;
        j["acl"] = _zw.V.current.acl;
        j["appacl"] = _zw.V.current.appacl;
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

        return JSON.stringify(j);
    }

    if (_zw.V.current.page.toLowerCase().indexOf('tnc/booking') >= 0) {
        if (_zw.V.opnode.indexOf('0.0.') >= 0) _zw.fn.bindBarCtrl();
    }

    if ($('.zc-month').length > 0) {
        //var list = [
        //    { title: 'All Day Event', start: '2022-02-11' },
        //    {
        //        groupId: 999,
        //        title: 'Repeating Event',
        //        start: '2022-02-18 16:00:00',
        //        end: '2022-02-18 21:30:00'
        //    }
        //]
        //_zw.Fc.setEvents(list);
        //console.log(_zw.Fc.getEvents());
        //_zw.Fc.render(_zw.V.lv.tgt); //_zw.fn.renderFullCalendar(_zw.V.lv.tgt);
    }
});