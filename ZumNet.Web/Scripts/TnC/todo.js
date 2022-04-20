$(function () {
    $('#__LeftMenu .sidenav-toggle').click(function (e) {
        e.preventDefault();

        $(this).next().slideToggle(300, function () {
            $(this).parent().toggleClass('open');
        });
    });

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

    _zw.fn.renderFullCalendar = function (initDate, eventList) {
        _zw.Fc = new Calendar($('#__fcView')[0], {
            locale: $('#current_culture').val(),
            height: '100%',
            plugins: [
                calendarPlugins.bootstrap,
                calendarPlugins.dayGrid,
                calendarPlugins.timeGrid,
                calendarPlugins.interaction
            ],

            //themeSystem: 'cosmo', //'bootstrap',

            headerToolbar: false,

            initialDate: initDate,
            //selectable: true,
            nowIndicator: true, // Show "now" indicator
            businessHours: {
                dow: [1, 2, 3, 4, 5], // Monday - Friday
                start: '9:00',
                end: '18:00',
            },
            editable: true,
            //dayMaxEventRows: true, // allow "more" link when too many events
            events: eventList,

            //views: {
            //    dayGrid: {
            //        dayMaxEventRows: 5
            //    }
            //},

            dayCellContent: function (arg, createElement) {
                //console.log(arg)
                //arg.date, arg.dayNumberText
                //return createElement('div', { 'class': 'text-danger' }, arg.dayNumberText);
                //return '<div class="d-flex"><div class="flex-grow-1 text-info">2h</div><div><span class="">(1.5)</span><span>' + arg.date.getDate() + '</span></div></div>';
                //var d = $('<div class="d-flex justify-content-between"><div class="text-info">2h</div><div><span class="">(1.5)</span><span>' + arg.date.getDate() + '</span></div></div>');
                //return { domNodes: d };
                return arg.date.getDate(); // fc-daygrid-day-number
            },

            select: function (selectionData) {
                alert(selectionData);
            },

            dateClick: function (info) {
                alert(info)
            },

            eventClick: function (calEvent) {
                bootbox.alert('Event: ' + calEvent.event.title);
            }
        });

        _zw.Fc.render();
    }

    _zw.fn.fcDateClick = function (info) {
        console.log(info)
        alert('fcDateClick');
    }

    _zw.fn.fcEventClick = function (calEvent) {
        console.log(calEvent)
        alert('Event: ' + calEvent.event.title);
    }

    _zw.fn.viewEvent = function (pm, dt, hm, mi, opt) { //alert(dt + " : " + hm + " : " + mi)
        var mode = mi != null && mi != '' && mi > 0 ? 'view' : 'new';
        if (pm && mode == 'view') mode = 'edit';
        
        dt = dt || ''; hm = hm || ''; opt = opt || '';

        if (mode != 'view' && _zw.V.current.appacl != 'A') return false;

        $.ajax({
            type: "POST",
            url: "/TnC/ToDo/EventView",
            data: '{M:"' + mode + '",dt:"' + dt + '",hm:"' + hm + '",mi:"' + mi + '",opt:"' + opt + '"}',
            success: function (res) {
                if (res.substr(0, 2) == 'OK') {
                    var p = $('#popForm');
                    p.html(res.substr(2));

                    if (mode != 'view') {
                        _zw.ut.picker('date'); _zw.ut.maxLength();

                        p.find('.btn[data-toggle="popover"]').popover({
                            html: true,
                            content: function () { return p.find('[data-help="file"]').html(); }
                        });

                        p.find('input[name="ckbRepeat"]').click(function () {
                            if ($(this).prop('checked')) {
                                _zw.cdr.showRepeat(p, 'init', 'txtStart', 'cbStart', 'cbEnd');
                            } else {
                                _zw.cdr.closeRepeat(p);
                            }
                        });

                        if (mode == 'edit' && p.find('input[name="ckbRepeat"]').prop('checked')) _zw.cdr.showRepeat(p, '', 'txtStart', 'cbStart', 'cbEnd');
                    }

                    p.find('.btn[data-zm-menu]').click(function () {
                        var mn = $(this).attr('data-zm-menu');
                        if (mn == 'save') {
                            _zw.fn.saveEvent(p, mi, dt, opt);

                        } else if (mn == 'delete') {
                            _zw.fn.deleteEvent([p], mi, dt);

                        } else if (mn == 'edit') {
                            _zw.fn.viewEvent(p, dt, '', mi);

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

                    if (pm && opt != '') pm.find("button[data-dismiss='modal']").click();
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

        var vRRule = _zw.cdr.getRepeat(p).split('|'); //repeat_type, end, count, interval_type, interval, cond_day, cond_week, cond_date
        //2018-09-07 반복유효체크
        if (vRRule == 'CHECK') { bootbox.alert("반복요일을 선택하십시오!"); return false; }
        else if (vRRule == 'INVALID') { bootbox.alert("반복종료일은 확인하십시오!", function () { $("#txtRepeatEnd").focus(); }); return false; }
        else if (vRRule == 'END') { bootbox.alert("반복종료일은 시작일 이후로 선택하십시오!", function () { $("#txtRepeatEnd").focus(); }); return false; }

        if (mode == "edit") {
            postJson["repeatchange"] = ($("#hdRepeatType").val() != vRRule[0] || $("#hdInterval").val() != vRRule[4] || $("#hdConDay").val() != vRRule[5] || $("#hdRepeatEnd").val() != vRRule[1]
                || $("#txtStart").val() != $("#hdPeriodFrom").val() || $("#cbStart").val() != $("#hdStartTime").val() || $("#cbEnd").val() != $("#hdEndTime").val()) ? "Y" : "N";
        }
        postJson["repeattype"] = vRRule[0]; //0, 1, 2, 3, 4
        postJson["interval"] = vRRule[4];
        postJson["repeatday"] = vRRule[5];
        postJson["repeatend"] = vRRule[1];

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

    _zw.fn.getToDoCount = function (tgt, mode, dt) {
        if (tgt == '') {
            $('.z-lm .sidenav-item .sidenav-link[data-for]').each(function () {
                var attr = $(this).attr("data-for");
                if (attr.indexOf('.') > 0 && attr.substr(0, 2) == 'UR') {
                    tgt += (tgt == '' ? '' : ';') + attr;;
                }
            }); //console.log(tgt)
        }

        $.ajax({
            type: "POST",
            url: '/TnC/ToDo/Count',
            data: '{tgt:"' + tgt + '",mode:"' + mode + '",date:"' + dt + '"}',
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    if (res.substr(2) != '') {
                        //console.log(res.substr(2))
                        var j = JSON.parse(res.substr(2));
                        for (var i = 0; i < j.length; i++) {
                            for (key in j[i]) {
                                $('.z-lm .sidenav-item .sidenav-link[data-for="' + key + '"]').find('.z-lm-cnt').html('(<span class="text-danger">' + j[i][key][1] + '</span>/' + j[i][key][0] + ')')
                            }
                        }
                    }
                } else bootbox.alert(res);
            },
            beforeSend: function () { } //로딩 X
        });
    }

    _zw.fn.changeState = function (fld, cur, next) {
        if (_zw.V.current.appacl != 'A') return false;
        var el = event.target; do { el = el.parentNode; } while (el.tagName != 'LI');
        var mi = el.id.split('.')[1];

        //console.log('{mi:"' + mi + '",rpt:"' + el.getAttribute("data-repeat") + '",from:"' + el.getAttribute("data-from") + '",fld:"' + fld + '",vlu:"' + next + '"}'); return

        $.ajax({
            type: "POST",
            url: '/TnC/ToDo/EventState',
            data: '{mi:"' + mi + '",rpt:"' + el.getAttribute("data-repeat") + '",from:"' + el.getAttribute("data-from") + '",fld:"' + fld + '",vlu:"' + next + '"}',
            success: function (res) {
                if (res == "OK") {
                    if (fld == 'priority' && el.getAttribute("data-repeat") != '0') {
                        _zw.fn.loadList();
                    } else {
                        _zw.fn.getEventBar(el, mi, el.getAttribute("data-from"));
                    }
                } else bootbox.alert(res);
            },
            beforeSend: function () { } //로딩 X
        });
    }

    _zw.fn.changeConfirm = function (fld, cur, next) {
        if (_zw.V.current.appacl != 'M') return false;
        var el = event.target; do { el = el.parentNode; } while (el.tagName != 'LI');
        var mi = el.id.split('.')[1];

        //console.log('{mi:"' + mi + '",rpt:"' + el.getAttribute("data-repeat") + '",from:"' + el.getAttribute("data-from") + '",fld:"' + fld + '",vlu:"' + next + '"}'); return

        $.ajax({
            type: "POST",
            url: '/TnC/ToDo/EventState',
            data: '{mi:"' + mi + '",rpt:"' + el.getAttribute("data-repeat") + '",from:"' + el.getAttribute("data-from") + '",fld:"' + fld + '",vlu:"' + next + '"}',
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    _zw.fn.getEventBar(el, mi, el.getAttribute("data-from"));
                    if (next.toString() == '7' || next.toString() == '4') _zw.fn.getToDoCount(_zw.V.ot + '.' + _zw.V.fdid.toString(), 'W', '');

                } else bootbox.alert(res);
            },
            beforeSend: function () { } //로딩 X
        });
    }

    _zw.fn.getEventBar = function (p, mi, d) {
        if (p) {
            $.ajax({
                type: "POST",
                url: '/TnC/ToDo/EventBar',
                data: '{mi:"' + mi + '",dt:"' + d + '",acl:"' + _zw.V.current.appacl + '",page:"' + _zw.V.ft + '"}',
                async: false,
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        if (res == "OK") { _zw.fn.loadList(); } else { $(p).html(res.substr(2)); }
                    } else bootbox.alert(res);
                },
                beforeSend: function () { } //로딩 X
            });
        } else { _zw.fn.loadList(); }
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

    _zw.fn.getToDoCount('', 'W', '');

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