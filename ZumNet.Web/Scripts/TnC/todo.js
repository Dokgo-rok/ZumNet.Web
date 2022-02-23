$(function () {
    $('#__LeftMenu .sidenav-toggle').click(function (e) {
        e.preventDefault();

        $(this).next().slideToggle(300, function () {
            $(this).parent().toggleClass('open');
        });
    });

    $('.z-lv-menu .btn[data-zv-menu], .z-list-head .btn[data-zv-menu]').click(function () {
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

    _zw.fn.fcDateClick = function (info) { console.log(info)
        alert('fcDateClick');
    }

    _zw.fn.fcEventClick = function (calEvent) { console.log(calEvent)
        alert('Event: ' + calEvent.event.title);
    }

    _zw.fn.viewEvent = function (dt, hm, mi) { //alert(dt + " : " + hm + " : " + mi)
        var mode = mi != null && mi != '' && mi > 0 ? 'view' : 'new';
        $.ajax({
            type: "POST",
            url: "/TnC/ToDo/EventView",
            data: '{M:"' + mode + '",dt:"' + dt + '",hm:"' + hm + '",mi:"' + mi + '"}',
            success: function (res) {
                if (res.substr(0, 2) == 'OK') {
                    var p = $('#popForm');
                    p.html(res.substr(2));

                    if (mode != 'view') {
                        _zw.ut.picker('date'); _zw.ut.maxLength();

                        p.find('input[name="ckbRepeat"]').click(function () {
                            if ($(this).prop('checked')) {
                                _zw.cdr.showRepeat(p, 'txtStart', 'cbStart', 'cbEnd');
                            } else {
                                _zw.cdr.closeRepeat(p);
                            }
                        });
                    } else {

                    }

                    p.modal();
                }
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
    }

    _zw.fn.changeConfirm = function (fld, cur, next) {
        if (_zw.V.current.appacl != 'M') return false;
        var el = event.target; do { el = el.parentNode; } while (el.tagName != 'LI');

        var mi = el.id.split('.')[1];
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