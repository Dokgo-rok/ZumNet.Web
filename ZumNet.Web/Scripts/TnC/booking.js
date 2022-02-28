$(function () {
    
    $('.z-list-head .btn[data-zv-menu]').click(function () { //.z-lv-menu .btn[data-zv-menu]
        var mn = $(this).attr("data-zv-menu");
        if (mn == 'prev' || mn == 'next') {
            var tgt = '';
            if (mn == 'prev') {
                tgt = moment(_zw.V.lv.tgt).add(_zw.V.ft.toLowerCase() == 'week' ? -7 : -1, _zw.V.ft.toLowerCase() == 'week' ? 'd' : 'M');
            } else if (mn == 'next') {
                tgt = moment(_zw.V.lv.tgt).add(_zw.V.ft.toLowerCase() == 'week' ? 7 : 1, _zw.V.ft.toLowerCase() == 'week' ? 'd' : 'M');
            }
            _zw.V.lv.tgt = tgt.format('YYYY-MM-DD');

            _zw.fn.loadList();
        }
    });

    $('#__CtDashboard #ddlResClass').on('change', function () { console.log(_zw.cdr.res["cls_" + $(this).val()])
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
            //console.log(JSON.stringify(j)); return;

            $.ajax({
                type: "POST",
                url: "/TnC/Booking/ResourceSchedule",
                data: JSON.stringify(j),
                success: function (res) {
                    if (res.substr(0, 2) == 'OK') {
                        $('#__ResSchedule').html(res.substr(2));
                    } else bootbox.alert(res);
                }
            });
        }
    });

    _zw.fn.viewEvent = function (pm, ot, partId, dt, mi, opt) { //alert(dt + " : " + hm + " : " + mi)
        var mode = mi != null && mi != '' && mi > 0 ? 'view' : 'new';
        if (pm && mode == 'view') mode = 'edit';

        dt = dt || ''; opt = opt || '';

        $.ajax({
            type: "POST",
            url: "/TnC/Booking/EventView",
            data: '{M:"' + mode + '",ot:"' + ot + '",partid:"' + partId + '",dt:"' + dt + '",mi:"' + mi + '",opt:"' + opt + '"}',
            success: function (res) {
                if (res.substr(0, 2) == 'OK') {
                    var p = $('#popForm');
                    p.html(res.substr(2));

                   
                    p.modal();
                }
            }
        });
    }

    _zw.fn.saveEvent = function (p, mi, dt, opt) {
        opt = opt || ''; dt = dt || '';

        //console.log($("#txtStart").val() + ' ' + $("#cbEnd").val() + " : " + $("#txtStart").val() + ' ' + $("#cbStart").val()); return;
        //alert(moment($("#txtStart").val() + ' ' + $("#cbEnd").val()).diff(moment($("#txtStart").val() + ' ' + $("#cbStart").val()), 'minutes')); return;

        if ($.trim($("#txtSubject").val()) == '') { bootbox.alert("일지 내용을 입력하십시오!", function () { $("#txtSubject").focus(); }); return false; }
        if (!moment($("#txtStart").val()).isValid()) { bootbox.alert("일지 시작일을 확인하십시오!", function () { $("#txtStart").focus(); }); return false; }

        var mode = (mi && mi != '' && mi != '0') ? "edit" : "new";
        var postJson = {};
        postJson["mode"] = mode;
        postJson["messageid"] = mi;
        postJson["objecttype"] = _zw.V.ot;
        postJson["objectid"] = _zw.V.fdid;
        postJson["schtype"] = "tk";
        postJson["taskid"] = "0";
        postJson["inherited"] = "Y";
        postJson["subject"] = $("#txtSubject").val();
        postJson["body"] = $("#txtBody").val();
        postJson["location"] = "";
        postJson["state"] = $('input[name="rdoState"]:checked').val();

        postJson["priority"] = $("#ckbPrioriy").prop('checked') ? "H" : "";
        postJson["periodfrom"] = $("#txtStart").val();
        postJson["periodto"] = $("#txtStart").val();
        postJson["starttime"] = $("#cbStart").val();
        postJson["endtime"] = $("#cbEnd").val();

        postJson["term"] = moment($("#txtStart").val() + ' ' + $("#cbEnd").val()).diff(moment($("#txtStart").val() + ' ' + $("#cbStart").val()), 'minutes');

        //console.log(postJson); return

        var vRRule = _zw.cdr.getRepeat(p).split('|');
        //2018-09-07 반복유효체크
        if (vRRule == 'CHECK') { bootbox.alert("반복요일을 선택하십시오!"); return false; }
        else if (vRRule == 'INVALID') { bootbox.alert("반복종료일은 확인하십시오!", function () { $("#txtRepeatEnd").focus(); }); return false; }
        else if (vRRule == 'END') { bootbox.alert("반복종료일은 시작일 이후로 선택하십시오!", function () { $("#txtRepeatEnd").focus(); }); return false; }

        if (mode == "edit") {
            postJson["repeatchange"] = ($("#hdRepeatType").val() != vRRule[0] || $("#hdInterval").val() != vRRule[1] || $("#hdConDay").val() != vRRule[2] || $("#hdRepeatEnd").val() != vRRule[3]
                || $("#txtStart").val() != $("#hdPeriodFrom").val() || $("#cbStart").val() != $("#hdStartTime").val() || $("#cbEnd").val() != $("#hdEndTime").val()) ? "Y" : "N";
        }
        postJson["repeattype"] = vRRule[0]; //0, 1, 2, 3, 4
        postJson["interval"] = vRRule[1];
        postJson["repeatday"] = vRRule[2];
        postJson["repeatend"] = vRRule[3];

        postJson["repeatchangeoption"] = opt;
        postJson["repeatchangedate"] = dt;

        //alert(vRRule + " : " + postJson["repeatchange"]); return;

        postJson["alarm"] = "0";
        postJson["creatorid"] = "";
        postJson["creatordept"] = "";
        postJson["creatordeptid"] = "";

        var fi = $.trim($("#FILEINFO").val()), nCnt = 0, rt = '';
        if (fi.length > 0) {
            //rt = moveFileToStorage(fi); //파일정보 xml 문자열로 반환
            //if (rt.substr(0, 2) == "OK") { rt = rt.substr(2); } else { alert(rt); return; }
            //nCnt = (fi.split(String.fromCharCode(8)).length > 1) ? 2 : 1;
        }
        postJson["isfile"] = nCnt; // 0, 1, 2
        postJson["fileinfo"] = rt;
        postJson["taskactivity"] = "";

        bootbox.confirm("저장 하시겠습니까?", function (rt) {
            if (rt) {
                $.ajax({
                    type: "POST",
                    url: "/TnC/ToDo/EventSave",
                    data: JSON.stringify(postJson),
                    success: function (res) {
                        if (res.substr(0, 2) == 'OK') {
                            bootbox.alert(res.substr(2), function () {
                                if (p) p.find("button[data-dismiss='modal']").click();
                                _zw.fn.getToDoCount('', 'W', ''); _zw.fn.loadList();
                            });

                        } else bootbox.alert(res);
                    }
                });
            }
        });
    }

    _zw.fn.deleteEvent = function (p, mi, dt, opt) {
        if (_zw.V.current.appacl != 'A') return false;

        bootbox.confirm("해당 일지를 삭제하시겠습니까?", function (rt) {
            if (rt) {
                $.ajax({
                    type: "POST",
                    url: "/TnC/ToDo/EventDelete",
                    data: '{mi:"' + mi + '",dt:"' + dt + '",opt:"' + opt + '"}',
                    success: function (res) {
                        if (res.substr(0, 2) == 'OK') {
                            bootbox.alert(res.substr(2), function () {
                                if (p) {
                                    if (p.length && p.length > 0) {
                                        for (var i = 0; i < p.length; i++) {
                                            p[i].find("button[data-dismiss='modal']").click();
                                        }
                                    } else {
                                        p.find("button[data-dismiss='modal']").click();
                                    }
                                }
                                _zw.fn.getToDoCount('', 'W', ''); _zw.fn.loadList();
                            });

                        } else bootbox.alert(res);
                    }
                });
            }
        });
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

                    if ($('.zc-month').length > 0) {
                        //_zw.fn.renderFullCalendar(_zw.V.lv.tgt);
                        //_zw.Fc.render(_zw.V.lv.tgt);
                        $('#__List').html(v[0]);

                    } else {
                        $('#__List').html(v[0]);
                    }

                    $('.zc-month .zc-calendar .zc-day-event a[data-toggle="tooltip"]').tooltip({
                        html: true,
                        title: function () { return $(this).next().html(); }
                    });

                } else bootbox.alert(res);
            }
        });
    }

    $('.zc-month .zc-calendar .zc-day-event a[data-toggle="tooltip"]').tooltip({
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