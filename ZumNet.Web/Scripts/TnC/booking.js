$(function () {
    $('.messages-sidebox a[data-zl-menu]').click(function () {
        var mn = $(this).attr("data-zl-menu"); //console.log(mn)

        if (mn.toLowerCase() == 'list' || mn.toLowerCase() == 'mylist') {
            var encQi = '{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + _zw.V.ot + '",fdid:"' + _zw.V.fdid + '",opnode:"",ft:"' + mn + '",ttl:"' + $.trim($(this).text()) + '"}';
            window.location.href = '/TnC/Booking/List?qi=' + encodeURIComponent(_zw.base64.encode(encQi));
        }
    });

    $('a[data-zp-menu], button[data-zp-menu]').click(function () {
        var mn = $(this).attr('data-zp-menu');

        if (mn == 'prev' || mn == 'next') {
            var tgt = $(this).parent().find('span[data-for="DateDesc"]');
            _zw.V.lv.tgt = moment(tgt.attr('data-val')).add(mn == 'prev' ? -1 : 1, 'M').format('YYYY-MM-DD'); //alert(_zw.V.lv.tgt)
            tgt.attr('data-val', _zw.V.lv.tgt);

            var postData = _zw.fn.getLvQuery(true);
            var url = _zw.V.current.page + '?qi=' + encodeURIComponent(_zw.base64.encode(postData));

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
        window.location.href = '/TnC/Booking/Calendar?qi=' + encodeURIComponent(_zw.base64.encode(_zw.fn.getLvQuery()));
    });

    //popover
    $('.z-ttl .btn[data-popover="resource-info"]').on('click', function () {
        var p = $(this), tgt = $('div[data-info="resource-info"]'); //console.log(tgt.children().length)
        
        //if (tgt.children().length == 0) {
            $.ajax({
                type: "POST",
                url: "/TnC/Booking/ResourceInfo",
                data: '{M:"popover",fdid:"' + _zw.V.fdid + '",boundary:"' + _zw.V.lv.boundary + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        tgt.html(res.substr(2));
                        //p.on('shown.bs.popover', function () {//show로 할 경우 안 click 이벤트 발생X
                            //var pop = $(this)
                            //$('button[data-dismiss="popover"]').click(function () {
                            //    pop.popover('hide');
                            //});
                        p.popover({
                            html: true,
                            trigger: 'focus',
                            title: function () { return tgt.find('.header').html(); },
                            content: function () { return tgt.find('.content').html(); }
                        }).popover('show');

                    } else bootbox.alert(res);
                },
                beforeSend: function () { } //로딩 X
            });
        //}
    });

    //$('.z-ttl .btn[data-popover="resource-info"]').on('show.bs.popover', function () {

    //}).on('shown.bs.popover', function () {//show로 할 경우 안 click 이벤트 발생X
    //    var pop = $(this)
    //    $('button[data-dismiss="popover"]').click(function () {
    //        pop.popover('hide');
    //    });
    //}).popover({
    //    html: true,
    //    title: function () { return $('div[data-info="resource-info"] .header').html(); },
    //    content: function () { return $('div[data-info="resource-info"] .content').html(); }
    //});
    

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
        //alert(ca + " : " + dt + " : " + hm + " : " + pt + " : " + partid + " : " + _zw.V.current.appacl)
        //if (_zw.V.current.appacl == '') { bootbox.alert('예약하려는 자원을 선택하시기 바랍니다!'); return false; }
        ca = ca || ''; dt = dt || ''; hm = hm || ''; pt = pt || ''; partid = partid || '0';
        if (dt == '' && _zw.V.lv.tgt != '') dt = _zw.V.lv.tgt;

        _zw.V.wnd = 'modal';
        _zw.V.ot = pt;
        _zw.V.fdid = partid;
        _zw.V.lv.cd1 = hm;
        _zw.V.appid = 0; //22-09-22 추가!!!

        $.ajax({
            type: "POST",
            url: ca == 'booking' ? '/TnC/Booking/Write' : '/TnC/Schedule/Write',
            data: _zw.fn.getAppQuery(dt),
            success: function (res) {
                if (res.substr(0, 2) == 'OK') {
                    var v = res.substr(2).split(_zw.V.lv.boundary);
                    var p = $('#popForm');
                    p.html(v[0]); _zw.V.app = JSON.parse(v[1]); //console.log(_zw.V.app);

                    _zw.ut.picker('date'); _zw.ut.maxLength(); _zw.fu.bind();

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
                        _zw.fn.openResList(p);
                    });

                    p.find('.btn[data-zm-menu="save"]').click(function () {
                        _zw.fn.saveEvent();
                    });

                    p.modal();
                } else bootbox.alert(res);
            }
        });
    }

    _zw.mu.readEvent = function (ca, dt, mi, pt, partid) { //alert(ca + " : " + dt + " : " + mi + " : " + pt + " : " + partid);
        if (mi == null || mi == '' || parseInt(mi) == '0') return false;
        ca = ca || ''; pt = pt || ''; partid = partid || '0'; dt = dt || 'x'; //if (dt == '' && _zw.V.lv.tgt != '') dt = _zw.V.lv.tgt;

        _zw.V.wnd = 'modal';
        _zw.V.ot = pt;
        _zw.V.fdid = partid;
        _zw.V.appid = mi;

        $.ajax({
            type: "POST",
            url: ca == 'booking' ? '/TnC/Booking/Read' : '/TnC/Schedule/Read',
            data: _zw.fn.getAppQuery(dt),
            success: function (res) {
                if (res.substr(0, 2) == 'OK') {
                    var v = res.substr(2).split(_zw.V.lv.boundary);
                    var p = $('#popForm');
                    p.html(v[0]); _zw.V.app = JSON.parse(v[1]); //console.log(_zw.V);

                    p.find('.btn[data-zm-menu]').click(function () {
                        var mn = $(this).attr('data-zm-menu');
                        if (mn == 'delete') {
                            _zw.fn.deleteEvent(ca, dt, mi);

                        } else if (mn == 'edit') {
                            _zw.mu.editEvent(ca, dt, mi, pt, partid);

                        } else if (mn == 'layer-mod' || mn == 'layer-del') {
                            var info = $('#popBlank');
                            info.html(p.find('#_LayerRptProc').html());

                            if (mn == 'layer-mod') info.find('[data-for="rpt-modify"]').removeClass('d-none');
                            else info.find('[data-for="rpt-delete"]').removeClass('d-none');

                            info.find('.btn[data-zm-menu="confirm"]').click(function () {
                                if (mn == 'layer-mod') {
                                    _zw.mu.editEvent(ca, dt, mi, pt, partid, [info, info.find('input[name="popup_repeat_mode"]:checked').val()]);
                                } else {
                                    _zw.fn.deleteEvent(ca, dt, mi, [info, info.find('input[name="popup_repeat_del_mode"]:checked').val()]);
                                }
                            });
                            info.modal();

                        } else if (mn == 'cmnt-reg' || mn == 'cmnt-mod' || mn == 'cmnt-del' || mn == 'cmnt-cancel') {

                        }
                    });

                    _zw.fn.showContextMenu('md-context-menu');
                    p.modal();
                } else {
                    bootbox.alert(res);
                }
            }
        });
    }

    _zw.mu.editEvent = function (ca, dt, mi, pt, partid, opt) {
        if (mi == null || mi == '' || parseInt(mi) == '0') return false;
        ca = ca || ''; pt = pt || ''; partid = partid || '0'; dt = dt || ''; //if (dt == '' && _zw.V.lv.tgt != '') dt = _zw.V.lv.tgt;

        _zw.V.wnd = 'modal';
        _zw.V.ot = pt;
        _zw.V.fdid = partid;
        _zw.V.appid = mi;
        _zw.V.lv.cd1 = opt != null && opt.length > 0 ? opt[1] : '';

        $.ajax({
            type: "POST",
            url: ca == 'booking' ? '/TnC/Booking/Edit' : '/TnC/Schedule/Edit',
            data: _zw.fn.getAppQuery(dt),
            success: function (res) {
                if (res.substr(0, 2) == 'OK') {
                    var v = res.substr(2).split(_zw.V.lv.boundary);
                    var p = $('#popForm');
                    p.html(v[0]); _zw.V.app = JSON.parse(v[1]); //console.log(_zw.V);

                    _zw.ut.picker('date'); _zw.ut.maxLength(); _zw.fu.bind();

                    if (opt != null && opt.length > 0) _zw.V.app['repeat']["changeopt"] = opt[1];
                    _zw.V.app['repeat']["changedate"] = dt;

                    p.find('input[name="ckbRepeat"]').click(function () {
                        if ($(this).prop('checked')) {
                            _zw.cdr.showRepeat(p, '', 'txtStart;txtEnd', 'cbStart', 'cbEnd', _zw.V.app['repeat']);
                        } else {
                            _zw.cdr.closeRepeat(p);
                        }
                    });

                    p.find('input[name="ckbAllDay"]').click(function () {
                        $('#cbStart').prop('disabled', $(this).prop('checked')); $('#cbEnd').prop('disabled', $(this).prop('checked'));
                    });

                    $('.btn[data-zf-menu="openResList"]').click(function () {
                        _zw.fn.openResList(p);
                    });

                    p.find('.btn[data-zm-menu="save"]').click(function () {
                        if (opt != null && opt.length > 0) _zw.fn.saveEvent(dt, opt[1]);
                        else _zw.fn.saveEvent();
                    });

                    if (!p.find('input[name="ckbRepeat"]').prop('disabled') && _zw.V.app['repeat']['type'] != '0') _zw.cdr.showRepeat(p, '', 'txtStart;txtEnd', 'cbStart', 'cbEnd', _zw.V.app['repeat']);
                    
                    if (opt != null && opt.length > 0) opt[0].find("button[data-dismiss='modal']").click();
                    p.modal();
                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.saveEvent = function (dt, opt) {
        var p = $('#popForm');
        var mode = (_zw.V.appid && _zw.V.appid != '' && parseInt(_zw.V.appid) > 0) ? "edit" : "new";
        dt = dt || ''; opt = opt || '';

        if ($.trim($("#txtSubject").val()) == '') { bootbox.alert("제목을 입력하십시오!", function () { $("#txtSubject").focus(); }); return false; }
        if (!moment($("#txtStart").val()).isValid()) { bootbox.alert("시작일을 확인하십시오!", function () { $("#txtStart").focus(); }); return false; }
        if (!moment($("#txtEnd").val()).isValid()) { bootbox.alert("종료일을 확인하십시오!", function () { $("#txtEnd").focus(); }); return false; }

        var ttl = p.find('span[data-for="SelectedPartName"]').html();
        var partId = p.find('input[data-for="SelectedPartID"]').val();
        var partType = p.find('input[data-for="SelectedPartType"]').val();
        if (mode == 'new' && ($.trim(ttl) == '' || partId == '' || partId == '0')) { bootbox.alert("신청 자원이 없습니다!"); return false; }
        
        var postJson = {}; //_zw.V.app;
        //postJson["cmntlist"] = []; postJson["sharedlist"] = []; //저장 중 필요 없는 목록 제거
        postJson["repeat"] = {};
        postJson["partlist"] = [];

        postJson["mode"] = mode;
        postJson["xfalias"] = _zw.V.xfalias;
        postJson["appid"] = _zw.V.appid;

        var startTime = p.find('input[name="ckbAllDay"]').prop('checked') ? '00:00' : $("#cbStart").val();
        var endTime = p.find('input[name="ckbAllDay"]').prop('checked') ? '24:00' : $("#cbEnd").val();

        var vRRule = _zw.cdr.getRepeat(p).split('|'); //console.log(vRRule);
        var rptEnd = $("#txtRepeatEnd");
        if (vRRule == 'INTERVAL') { bootbox.alert("반복주기를 확인하십시오!"); return false; }
        else if (vRRule == 'CHECK') { bootbox.alert("반복요일을 선택하십시오!"); return false; }
        else if (vRRule == 'INVALID') { bootbox.alert("반복종료일은 확인하십시오!", function () { rptEnd.focus(); }); return false; }
        else if (vRRule == 'END') { bootbox.alert("반복종료일은 시작일 이후로 선택하십시오!", function () { rptEnd.focus(); }); return false; }

        if (mode == 'new' && ttl.indexOf('회의실') >= 0 && vRRule[0] != '0') { //2020-11-09 회의실 경우 1달 이상 되풀이 지정 불가
            //console.log(moment(rptEnd.val()).diff(moment($("#txtStart").val()), 'M', true));
            if (rptEnd.val() == '' || moment(rptEnd.val()).diff(moment($("#txtStart").val()), 'M', true) > 1) {
                bootbox.alert("[회의실] 경우 1달 이내 반복 가능합니다!", function () { rptEnd.focus(); }); return false;
            }
        }

        var rptInfo = {};
        if (mode == "edit") {
            var orgRpt = _zw.V.app["repeat"];
            rptInfo["change"] = (orgRpt["type"] != vRRule[0] || orgRpt["end"] != vRRule[1] || orgRpt["count"] != vRRule[2] || orgRpt["intervaltype"] != vRRule[3]
                || orgRpt["interval"] != vRRule[4] || orgRpt["conday"] != vRRule[5] || orgRpt["conweek"] != vRRule[6] || orgRpt["condate"] != vRRule[7]
                || $("#txtStart").val() != _zw.V.app["periodfrom"] || startTime != _zw.V.app["start"]
                || $("#txtEnd").val() != _zw.V.app["periodto"] || endTime != _zw.V.app["end"]) ? "Y" : "N";
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
        postJson["priority"] = $(':checkbox[name="ckbPrioriy"]').prop('checked') ? "H" : "";

        postJson["subject"] = $("#txtSubject").val();
        postJson["location"] = $("#txtLocation").val();
        postJson["body"] = $("#txtBody").val();
        postJson["periodfrom"] = $("#txtStart").val();
        postJson["start"] = startTime; //p.find('input[name="ckbAllDay"]').prop('checked') ? '00:00' : $("#cbStart").val();
        postJson["periodto"] = $("#txtEnd").val();
        postJson["end"] = endTime; //p.find('input[name="ckbAllDay"]').prop('checked') ? '24:00' : $("#cbEnd").val();
        postJson["term"] = moment(postJson["periodto"] + ' ' + postJson["end"]).diff(moment(postJson["periodfrom"] + ' ' + postJson["start"]), 'minutes');

        if (mode == 'new' && partId != '') {
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

        } else if (mode == 'edit') {
            postJson["partlist"] = _zw.V.app["partlist"]; //편집모드에서 자원 수정 X
        }

        postJson["alarm"] = "0";
        postJson["creurid"] = _zw.V.current.urid;
        postJson["credept"] = _zw.V.current.dept;
        postJson["credpid"] = _zw.V.current.deptid;

        postJson["attachlist"] = [];
        if (_zw.fu.fileList.length) {
            for (var i = 0; i < _zw.fu.fileList.length; i++) {
                var v = _zw.fu.fileList[i];
                if (v["attachid"] == '' || parseInt(v["attachid"]) == 0) postJson["attachlist"].push(v);
            }
        }
        postJson["attachcount"] = _zw.fu.fileList.length > 1 ? '2' : _zw.fu.fileList.length;
        postJson["taskact"] = "";

        //console.log(postJson); return

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
                                if (_zw.V.ft.toLowerCase() == 'resourceschedule') _zw.fn.loadBar();
                                else _zw.fn.loadList();
                            });
                        } else if (res.substr(0, 2) == 'NO') {
                            bootbox.alert(res.substr(2)); //중복
                        } else bootbox.alert(res);
                    }
                });
            }
        });
    }

    _zw.fn.deleteEvent = function (ca, dt, mi, opt) {
        if (_zw.V.current.operator != 'Y' && _zw.V.current.urid != _zw.V.app.creurid && _zw.V.current.appacl.substr(1, 1) != 'D') return false;

        bootbox.confirm("해당 일정을 삭제하시겠습니까?", function (rt) {
            if (rt) {
                if (opt != null && opt.length > 0) opt[0].find("button[data-dismiss='modal']").click();

                $.ajax({
                    type: "POST",
                    url: "/TnC/Booking/EventDelete",
                    data: '{mi:"' + mi + '",ot:"' + _zw.V.app.ot + '",otid:"' + _zw.V.app.otid + '",dt:"' + dt + '",opt:"' + (opt != null && opt.length > 0 ? opt[1] : '') + '"}',
                    success: function (res) {
                        if (res.substr(0, 2) == 'OK') {
                            bootbox.alert(res.substr(2), function () {
                                $('#popForm').find("button[data-dismiss='modal']").click();
                                if (_zw.V.ft.toLowerCase() == 'resourceschedule') _zw.fn.loadBar();
                                else _zw.fn.loadList();
                            });

                        } else bootbox.alert(res);
                    }
                });
            }
        });
    }

    _zw.fn.showContextMenu = function (dc) {
        dc = dc || 'vw-context-menu'
        var m = new BootstrapMenu('a[data-controls="' + dc + '"]', {
            menuEvent: 'click',
            menuSource: 'element',
            menuPosition: 'belowLeft',
            fetchElementData: function (el) {
                var j = JSON.parse(el.attr('data-val'));
                var d = _zw.ut.diff('min', j["from"], new Date()); //console.log('시간차 => ' + d);
                if (d < 0) {
                    j["state"] = -1;
                } else {
                    if (_zw.V.current.operator != 'Y') {
                        $.ajax({
                            type: "POST",
                            url: "/TnC/Booking/ResourceAcl",
                            data: '{fdid:"' + j["partid"] + '",tgtid:"' + _zw.V.current.urid + '"}',
                            async: false,
                            success: function (res) {
                                if (res == 'OK') {
                                } else if (res == 'NO') {
                                    j["state"] = 99;
                                } else console.log(res);
                            },
                            beforeSend: function () { }
                        });
                    }
                }
                //console.log('22=>' + j["state"]);
                return j
            },
            actions: [{
                name: '수락, 승인',
                iconClass: 'far fa-check-circle text-success',
                onClick: function (info) {
                    info['state'] = 7;
                    _zw.fn.popupConfirm(info, $(event.target).parent().text());
                },
                isShown: function (info) {
                    return info["state"] == -1 || info["state"] == 7 || info["state"] == 99 ? false : true;
                }
            }, {
                name: '거부, 불가',
                iconClass: 'fas fa-times-circle text-danger',
                onClick: function (info) {
                    info['state'] = 8;
                    _zw.fn.popupConfirm(info, $(event.target).parent().text());
                },
                isShown: function (info) {
                    return info["state"] == -1 || info["state"] == 8 || info["state"] == 99 ? false : true;
                }
            }, {
                name: '보류',
                iconClass: 'fas fa-stop-circle text-warning',
                onClick: function (info) {
                    info['state'] = 6;
                    _zw.fn.popupConfirm(info, $(event.target).parent().text());
                },
                isShown: function (info) {
                    return info["state"] == -1 || info["state"] == 6 || info["state"] == 99 ? false : true;
                }
            }, {
                name: '자원 담당자에게 문의하십시오!',
                iconClass: 'far fa-question-circle text-info',
                onClick: function () { },
                isShown: function (info) {
                    return info["state"] == -1 || info["state"] != 99 ? false : true;
                }
            }, {
                name: '예약시간이 경과 됐습니다!',
                iconClass: 'fas fa-clock text-danger',
                onClick: function () { },
                isShown: function (info) {
                    return info["state"] == -1 ? true : false;
                }
            }]
        });
    }

    _zw.fn.popupConfirm = function (info, txt) {
        txt = $.trim(txt);

        var s = '<div class="modal-dialog modal-sm modal-dialog-centered">'
            + '<div class="modal-content" style="box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.5)">'
            + '<div class="modal-header">'
            + '<div>' + '자원 신청 처리' + '</div>'
            + '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>'
            + '</div>'
            + '<div class="modal-body p-3">'
            + '<div class="mb-2">' + '해당 자원 사용을 "' + txt + '" 처리 합니다!' + '</div>'
            + '<div><textarea class="form-control" rows="3"></textarea></div>'
            + '</div>'
            + '<div class="modal-footer">'
            + '<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>'
            + '<button type="button" class="btn btn-primary" data-zm-menu="confirm">확인</button>'
            //+ '<input type=\"hidden\" value="' + JSON.stringify(info) + '" />'
            + '</div>'
            + '</div></div>';

        var p = $('#popBlank'); p.html(s);

        p.find('.modal-footer .btn[data-zm-menu="confirm"]').click(function () {
            //알림 링크 -> 내 예약현황
            var encQi = '{"M":"","ct":"' + _zw.V.ct + '","ctalias":"' + _zw.V.ctalias + '","ot":"","fdid":"","opnode":"","ft":"","ttl":"예약현황","tgt":"' + info['from'].substr(0, 10) + '"}'; //console.log(JSON.parse(encQi))
            info['url'] = '/TnC/Booking/List?qi=' + encodeURIComponent(_zw.base64.encode(encQi));

            var msg = info['from'] + ' 에약한 자원(' + info['part'] + ') "' + txt + '" 됐습니다.';
            if ($.trim(p.find('.modal-body textarea').val()) != '') {
                msg += '\n* 사유\n' + p.find('.modal-body textarea').val();
            }
            info['noticls'] = 'ekp/' + _zw.V.ctalias;
            info['contents'] = msg;
            console.log(info)

            $.ajax({
                type: "POST",
                url: "/TnC/Booking/ResourceConfirm",
                data: JSON.stringify(info),
                success: function (res) {
                    if (res == 'OK') {
                        p.modal('hide'); $('#popForm').modal('hide');
                        _zw.fn.loadList();

                    } else bootbox.alert(res);
                }
            });
        });

        p.on('hidden.bs.modal', function () { p.html(''); });
        p.modal();
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
                _zw.mu.readEvent(_zw.V.ctalias, $('#__ResSchedule thead span[data-for="DateDesc"]').attr('data-val')
                    , $(this).attr('data-appid'), p.attr('data-parttype'), p.attr('data-partid'));
            } else {
                _zw.mu.writeEvent(_zw.V.ctalias, $('#__ResSchedule thead span[data-for="DateDesc"]').attr('data-val')
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

    _zw.fn.openResList = function (p) {
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

                    if (_zw.V.ttl != '') {
                        window.document.title = _zw.V.ttl; $('.z-ttl span').html(_zw.V.ttl);
                    }

                    var v = res.substr(2).split(_zw.V.lv.boundary); //console.log(JSON.parse(JSON.stringify($.trim(v[0]))))
                    $('.z-list-head [data-for="DateDesc"]').html(v[1]);
                    $('#__List').html(v[0]);

                    $('[data-toggle="tooltip"][title!=""]').tooltip();
                    $('.zc-month .zc-calendar .zc-day-event a[data-toggle="tooltip"], .zc-week a[data-toggle="tooltip"], .zc-dayview a[data-toggle="tooltip"]').tooltip({
                        html: true,
                        title: function () { return $(this).next().html(); }
                    });

                    _zw.fn.showContextMenu();

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

    _zw.fn.showContextMenu();

    $('.zc-month .zc-calendar .zc-day-event a[data-toggle="tooltip"], .zc-week a[data-toggle="tooltip"], .zc-dayview a[data-toggle="tooltip"]').tooltip({
        html: true,
        title: function () { return $(this).next().html(); }
    });

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