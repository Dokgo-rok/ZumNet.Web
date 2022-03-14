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
                    p.html(v[0]); _zw.V.app = JSON.parse(v[1]); console.log(_zw.V.app);

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
                                            console.log(ttl + " : " + partid[2] + " : " + v[2])
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

                    p.modal();
                }
            }
        });
    }

    _zw.mu.readEvent = function (ca, mi, pt, partId) { //alert(ca + " : " + mi + " : " + pt + " : " + partId); return
        if (mi == null || mi == '' || parseInt(mi) == '0') return false;
        ca = ca || ''; pt = pt || ''; partid = partid || '';

        $.ajax({
            type: "POST",
            url: "/TnC/Booking/EventView",
            data: '{M:"' + mode + '",ct:"' + _zw.V.ct + '",ot:"' + ot + '",partid:"' + partId + '",dt:"' + dt + '",mi:"' + mi + '",opt:"' + opt + '"}',
            success: function (res) {
                if (res.substr(0, 2) == 'OK') {
                    var p = $('#popForm');
                    p.html(res.substr(2));


                    p.modal();
                }
            }
        });
    }

    _zw.fn.saveEvent = function () {
        var p = $('#popForm');
        var vRRule = _zw.cdr.getRepeat(p); console.log(vRRule);
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