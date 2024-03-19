//전자결재 메인, 리스트뷰

$(function () {

    $('#__LeftMenu .sidenav-toggle').click(function (e) {
        e.preventDefault();

        $(this).next().slideToggle(300, function () {
            $(this).parent().toggleClass('open');
        });
    });

    $('#__LeftMenu li[data-box] .sidenav-link').click(function (e) {
        e.preventDefault();

        _zw.V.opnode = $(this).parent().attr('data-location');
        _zw.V.ttl = $(this).find('span:first').text();

        //window.location.href = '/EA/Main/List?qi=' + encodeURIComponent(_zw.fn.getLvQuery(false));

        if (_zw.V.current.page.toLowerCase() == '/ea/main/list') {

            $('#__LeftMenu li[data-box] .sidenav-link').each(function () {
                $(this).parent().removeClass('active');
            });

            $(this).parent().addClass('active');

            _zw.fn.initLv('');
            _zw.fn.loadList();

        } else {
            //window.location.href = '/EA/Main/List?qi=' + encodeURIComponent(_zw.fn.getLvQuery(false));
            window.location.href = '/EA/Main/List?qi=' + _zw.base64.encode(_zw.fn.getLvQuery(false));
        }
    });

    //$('.z-lv-cond input[data-val]').on('keyup', function () {
    //    $.ajax({
    //        type: "POST",
    //        url: "/EA/Main/AutoSearch",
    //        data: _zw.V.xfalias + ',' + _zw.V.opnode.split('/')[0] + ',' + _zw.V.current.urid + ',' + $(this).attr('data-val').toLowerCase() + ',' + $(this).val(),
    //        success: function (res) {
    //            console.log(res.result)

    //        },
    //        beforeSend: function () {}
    //    });
    //});

    //$('.z-lv-cond input[data-val]').autoComplete({
    //    minLength: 1,
    //    resolver: 'custom',
    //    formatResult: function (item) {
    //        console.log(item)
    //        return {
    //            value: item.name,
    //            text: item.name + '(' + item.count + ')',
    //            html: '<li>' + item.name + '(' + item.count + ')' + '</li>'
    //        }
    //    },
    //    events: {
    //        search: function (qry) {
    //            $.ajax({
    //                type: "POST",
    //                url: "/EA/Main/AutoSearch",
    //                data: _zw.V.xfalias + ',' + _zw.V.opnode.split('/')[0] + ',' + _zw.V.current.urid + ',' + 'docname' + ',' + qry,
    //                success: function (res, callback) {
    //                    var jRes = JSON.parse(res); //console.log(jRes)
    //                    if (jRes.result == 'OK') {
    //                        //callback(jRes.data);
    //                    }
    //                },
    //                beforeSend: function () { }
    //            });
    //        }
    //    }
    //});

    //$('.z-lv-cond input[data-val]').typeahead({
    //    hint: true,
    //    highlight: true,
    //    minLength: 0
    //}, {
    //    name: 'AutoSearch',
    //    source: function (query, syncResults, asyncResults) {
    //        return $.ajax({
    //            type: "POST",
    //            url: "/EA/Main/AutoSearch",
    //            data: _zw.V.xfalias + ',' + _zw.V.opnode.split('/')[0] + ',' + _zw.V.current.urid + ',' + 'docname' + ',' + query,
    //            success: function (res) {
    //                console.log(res.result)
    //                return asyncResults(res.data);
    //            }
    //        })
    //    }
    //});

    _zw.mu.transfer = function () {
        var tgt = $('#__ListView .z-lv-row :checkbox:checked'), app = ''
        tgt.each(function (idx) {
            var temp = $(this).parent().parent().parent().attr('app');
            if (temp.length > 0) { app = temp.split('^')[0]; return; }
        });
        if (app == '') {
            return;
        } else if (app == "ea" || app == "tooling") {
            var rt = '';
            tgt.each(function (idx) {
                var temp = $(this).parent().parent().parent().attr('app');
                if (temp.length > 0) {
                    if (temp.split('^')[0] == app) {
                        rt += ',' + $(this).parent().parent().parent().attr('id').substr(1).split(".")[0];
                    } else {
                        bootbox.alert("[할일이관]은 [동일 유형]만 가능합니다!"); rt = '';  return;
                    }
                }
            });

            if (rt != '') {
                _zw.fn.org('user', 'n', rt.substr(1));
            }

        } else if (app == "ecnplan") {
            bootbox.alert("[할일이관]은 [결재문서, 금형대장]만 가능합니다!"); return;
        }
    }

    _zw.fn.orgSelect = function (p, v) {
        p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
            var info = JSON.parse($(this).attr('data-attr')); //console.log(info)
            var dn = $(this).next().text();
            var j = {};
            j["M"] = "transferworknotice";  j["post"] = v;  j["tgturid"] = info["id"]; j["tgtname"] = dn; j["tgtcode"] = info["logonid"]; j["tgtmail"] = info["smail"];
            //console.log(j); return
            bootbox.confirm('선택한 [할일]을 [' + info["grdn"] + '.' + info["grade"] + '.' + dn + ']에게 이관하시겠습니까?', function (rt) {
                if (rt) {
                    $.ajax({
                        type: "POST",
                        url: "/EA/Common",
                        data: JSON.stringify(j),
                        success: function (res) {
                            if (res == "OK") _zw.mu.refresh();
                            else bootbox.alert(res);
                        }
                    });
                }
            });
        });
        p.modal('hide');
    }

    _zw.fn.getEACount('', 'ea', 'base2', '', 'N');

    _zw.fn.readMark = function (opt) {
        var tgt = $('#__ListView .z-lv-row :checkbox:checked'), v = ''
        tgt.each(function (idx) {
            var temp = $(this).parent().parent().parent().attr('id').substr(1).split(".");
            v += (idx == 0 ? '' : ',') + temp[0];
        });
        if (v != '') {
            $.ajax({
                type: "POST",
                url: "/Form/Read",
                data: '{M:"' + opt + '",xf:"' + _zw.V.xfalias + '",mi:"' + v + '"}',
                success: function (res) {
                    if (res == "OK") {
                        tgt.each(function () {
                            $(this).parent().parent().parent().toggleClass('font-weight-bold');
                            $(this).prop('checked', false);
                            $('.z-lv-hdr input:checkbox').prop('checked', false);
                        });
                    } else bootbox.alert(res);
                }
            });
        }
    }

    _zw.fn.cancelSend = function () {
        var evt = _zw.ut.eventBtn(); //alert(evt.prop('tagName'))
        var row = evt.parent().parent().parent(); //alert(row.prop('tagName'))
        var temp = row.attr('id').substr(1).split(".");
        var cmd = '', szMsg = '', postData = ''; //alert(_zw.V.opnode + " : " + _zw.V.ft); return // opnode => go//101374

        if (_zw.V.opnode.substr(0, 2) == 'wt') {
            cmd = 'cancelservicequeue'; postData = '{M:"' + cmd + '",mi:"' + temp[0] + '",oi:"' + temp[1] + '",svc:"' + temp[2] + '"}'
            szMsg = '해당 문서에 대한 처리 요청을 취소하시겠습니까?';
        } else if (_zw.V.opnode.substr(0, 2) == 'go') {
            cmd = 'canceldraft'; postData = '{M:"' + cmd + '",oi:"' + temp[1] + '",wi:"' + temp[2] + '"}';
            szMsg = '해당 문서를 회수하시겠습니까?<br />다음 결재자가 해당 문서를 열람한 경우 회수가 되지 않습니다.';
        }

        if (cmd != '') {
            bootbox.confirm(szMsg, function (rt) {
                if (rt) {
                    $.ajax({
                        type: "POST",
                        url: "/EA/Process",
                        data: postData,
                        success: function (res) {
                            //if (res == "OK") bootbox.alert('처리 하였습니다.', function () { _zw.fn.getEACount('', 'ea', 'base2', '', 'N'); _zw.mu.refresh(); });
                            if (res == "OK") { _zw.mu.refresh(); _zw.fn.getEACount('', 'ea', 'base2', '', 'N'); }
                            else bootbox.alert(res);
                        }
                    });
                }
            });
        }
    }

    _zw.fn.loadList = function () {
        var postData = _zw.fn.getLvQuery(true); //console.log(postData);
        var url = '/EA/Main/List?qi=' + _zw.base64.encode(postData); //encodeURIComponent(postData);
        //if (_zw.V.alias == "ea.form.report") url = '/Report?qi=' + encodeURIComponent(postData);
        //else url = '/EA/Main/List?qi=' + encodeURIComponent(postData); //_zw.base64.encode(postData);

        if ($('.messages-wrapper, .messages-card').hasClass('messages-sidebox-open')) $('.z-mobile-navbar button.close').click();

        $.ajax({
            type: "POST",
            url: url,
            success: function (res) {
                
                if (res.substr(0, 2) == "OK") {
                    history.pushState(null, null, url);

                    window.document.title = _zw.V.ttl;
                    $('.z-ttl span').html(_zw.V.ttl);

                    var v = res.substr(2).split(_zw.V.lv.boundary);
                    $('#__ListHead').html(v[0]);
                    $('#__ListView').html(v[1]);
                    $('#__ListCount').html(v[2]);
                    $('#__ListMenuSearch').html(v[3]);
                    $('#__ListViewPage').html(v[4]);

                    $('.z-lv-menu .btn[data-zv-menu], .z-lv-search .btn[data-zv-menu]').click(function () {
                        var mn = $(this).attr('data-zv-menu');
                        if (mn != '') _zw.mu[mn]();
                    });

                    $('.z-lv-search input.search-text').keyup(function (e) {
                        if (e.which == 13) _zw.mu.search();
                    });

                    $('.pagination li a.page-link').click(function () {
                        _zw.mu.search($(this).attr('data-for'));
                    });

                    $('.z-lv-cnt select').change(function () {
                        _zw.fn.setLvCnt($(this).val());
                    });

                    _zw.ut.picker('date');

                    $('#__ListView .z-lv-row [data-toggle="tooltip"][title!=""]').tooltip();

                    $('.z-lv-hdr a[data-val]').click(function () {
                        var t = $(this); _zw.V.lv.sort = t.attr('data-val');
                        $('.z-lv-hdr a[data-val]').each(function () {
                            if ($(this).attr('data-val') == _zw.V.lv.sort) {
                                var c = t.find('i');
                                if (c.hasClass('fe-arrow-up')) {
                                    c.removeClass('fe-arrow-up').addClass('fe-arrow-down'); _zw.V.lv.sortdir = 'DESC';
                                } else {
                                    c.removeClass('fe-arrow-down').addClass('fe-arrow-up'); _zw.V.lv.sortdir = 'ASC';
                                }
                            } else {
                                $(this).find('i').removeClass();
                            }
                        });
                        //console.log('::' + JSON.stringify(_zw.V))
                        _zw.V.lv.tgt = _zw.V.fdid;
                        _zw.fn.loadList();
                    });

                    $('.z-lv-hdr input:checkbox').click(function () {
                        var b = $(this).prop('checked');
                        $('#__ListView input:checkbox').each(function () {
                            $(this).prop('checked', b);
                        });
                    });

                } else bootbox.alert(res);
            }
        });
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

        //console.log(_zw.V.lv);
        return JSON.stringify(j);
    }

    _zw.fn.initLv = function (tgt) {
        $('.z-lv-date .start-date').val('');
        $('.z-lv-date .end-date').val('');
        $('.z-lv-search select').val('');
        $('.z-lv-search .search-text').val('');

        $('.z-lv-hdr a[data-val]').each(function () {
            $(this).find('i').removeClass();
        });

        var sCnt = _zw.ut.getCookie('eaLvCount') || $('.z-lv-page select').val();

        _zw.V.lv.tgt = tgt;
        _zw.V.lv.page = '1';
        _zw.V.lv.count = sCnt == undefined || sCnt == '' ? '20' : sCnt;
        _zw.V.lv.sort = '';
        _zw.V.lv.sortdir = '';
        _zw.V.lv.search = '';
        _zw.V.lv.searchtext = '';
        _zw.V.lv.start = '';
        _zw.V.lv.end = '';
        _zw.V.lv.basesort = '';
    }
});