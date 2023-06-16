//폴더트리

$(function () {
    //폴더트리
    if ($('#__FolderTree').length > 0) {

        //$.ajax({
        //    type: 'POST',
        //    url: '/Common/Tree',
        //    data: '{ct:103,selected:"",seltype:"",lvl:0,open:""}',
        //    dataType: 'text',
        //    success: function (res) {
        //        var j = JSON.parse(res); //alert(j[0]["id"])


        //        $('#__FolderTree').jstree({
        //            'core': {
        //                'data': j
        //            },
        //            plugins: ["wholerow"]
        //        })
        //        .on('loaded.jstree', function (e, d) {

        //        })
        //    },
        //    error: function (xhr, ajaxOptions, thrownError) {
        //        //var j = xhr.responseJSON; alert(j[0]['id'])
        //        alert(xhr.status + ' : ' + xhr.responseText);
        //        alert(thrownError);
        //    }
        //});

        //$('#__FolderTree').jstree({
        //    core: {
        //        check_callback: true,
        //        data: _zw.V.tree.data,
        //    },
        //    plugins: ["wholerow"]

        //}).on('loaded.jstree', function (e, data) {
        //    var p = $('#__FolderTree').jstree("get_node", "0.0.13257");
        //    p.state.loaded = true;
        //});

        $('#__FolderTree').jstree(
            _zw.T.tree
        )
        .on('loaded.jstree', function (e, d) {
            //if (d.selected && d.selected.length == 1) {
            //    var n = d.instance.get_node(d.selected[0]);
            //    n.find("a").attr('aria-selected', true); n.find("a").addClass('jstree-clicked');
            //}
            //alert(_zw.V.tree.selected)
            //data.instance.open_node('1350', function () {

            //    data.instance.open_node('1354', function () {

            //    });
            //});
        })
        .on('changed.jstree', function (e, d) {//2022-03-29 막음
            if (d.selected.length == 1) {
                var n = d.instance.get_node(d.selected[0]); //alert(n.a_attr.url + " : " + n.li_attr.objecttype)
                //alert(n.li_attr.objecttype + ' : ' + n.li_attr.alias + ' : ' + n.li_attr.xfalias + ' : ' + n.li_attr.acl.substr(n.li_attr.acl.length-1, 1))
                var vId = n.id.split('.');

                if (vId[vId.length - 1] == _zw.V.fdid) return false;
                //console.log('changed.jstree => ' + d.selected.length)

                _zw.fn.clickTreeNode(d, n);
            }
        })
        .on("select_node.jstree", function (e, d) {
            //console.log('select_node.jstree')
            var n = d.instance.get_node(d.selected);
            _zw.fn.clickTreeNode(d, n);
        })
        .on("open_node.jstree", function (e, d) {
            //$("#" + d.node.id).find('i').eq(1).toggleClass('fa-folder', 'fa-folder-open');
            //var p = d.instance.get_node(d.node.id);
            ////p.remove(p.children);
            //p.state.loaded = true; //중요 !!!!!!!
            //p.state.opened = true;

            ////var isOpen = $('#__FolderTree').jstree("is_open", p); //alert(isOpen)
            ////alert(isOpen)
            ////if (isOpen) {
            ////    $('#__FolderTree').jstree("close_node", p);
            ////}
            ////else {
            ////    $('#__FolderTree').jstree("open_node", p);
            ////}
            ////insertNode(d)
            //$.ajax({
            //    type: 'POST',
            //    url: '/Common/Tree',
            //    data: '{ct:103,selected:"' + d.node.id + '",seltype:"",lvl:1,open:""}',
            //    dataType: 'text',
            //    success: function (res) {//alert(res)
            //        var c = JSON.parse(res);
            //        //var tree = $('#__FolderTree').jstree(true);
            //        //tree.deselect_all();
            //        //var sel = tree.create_node(d.node.id, c);
            //        //tree.select_node(sel);



            //        //$('#__FolderTree').jstree("create_node", d.node.id, c, "last", function () { alert('done') }, true);
            //        //var newNode = { data: c };
            //        //$('#__FolderTree').jstree("create_node", d.node.id, newNode, "last", false, false);



            //        //_zw.V.tree.data.push[c];

            //        //$('#__FolderTree').jstree().refresh();

            //        $.each(c, function (k, v) {
            //            $('#__FolderTree').jstree().create_node(v.parent, v, "last");
            //        });



            //    },
            //    error: function (request, status, error) { //error 시
            //        alert("status:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            //        //error메세지
            //    }
            //});
        });

        //$('#__FolderTree')
        //    .jstree({
        //        core: {
        //            check_callback: true,
        //            //data: _zw.V.tree.data
        //            data: {
        //                type: 'POST',
        //                url: '/Common/Tree',
        //                data: '{ct:103,selected:"",seltype:"",lvl:0,open:""}',
        //                dataType: 'json',
        //            }
        //        },
        //        plugins: ["wholerow"]
        //        //plugins: ["dnd", "massload", "search", "state", "types", "unique", "wholerow", "changed", "conditionalselect"]
        //    })
        //    .on('loaded.jstree', function (e, data) {
        //        //data.instance.open_node('1350', function () {

        //        //    data.instance.open_node('1354', function () {

        //        //    });
        //        //});
        //    })
        //    .on('before_open.jstree', function (node) {
        //        alert(2)
        //    })
        //    .on('open_node.jstree', function (node) {
        //        alert(3)
        //    })
        //    .on('after_open.jstree', function (node) {
        //        alert(3)
        //    })
        //    .on('changed.jstree', function (e, d) {
        //        alert(4)
        //        if (d.selected.length == 1) {
        //            var vPath = $("#__FolderTree").jstree("get_path", d.selected[0]);
        //            $('.z-ttl span').html(vPath.join(' / '));

        //              var n = data.instance.get_node(data.selected[0]);
        //            var vId = n.id.split('.');
        //            if (n.li_attr.hassub) {
        //                $.ajax({
        //                    type: "POST",
        //                    url: "?qi=",
        //                    data: '{page:1,count:20,tgt:"' + vId[vId.length - 1] + '"}',
        //                    success: function (res) {
        //                        if (res.substr(0, 2) == "OK") $('#__ListView').html(res.substr(2));
        //                        else alert(res);
        //                    }
        //                });
        //            }
        //        }
        //    });


        _zw.fn.clickTreeNode = function (d, n) {
            var vId = n.id.split('.');
            var vPath = d.instance.get_path(d.selected[0]); //console.log(vPath)
            var encQi = '', ttl = vPath.join(' / ');

            if (n.li_attr.acl.substr(n.li_attr.acl.length - 1, 1) == 'V' && n.li_attr.objecttype == 'G') {
                //alert('{ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + n.li_attr.objecttype + '",alias:"' + n.li_attr.alias + '",xfalias:"' + n.li_attr.xfalias + '",fdid:"' + vId[vId.length - 1] + '",opnode:"' + n.id + '",ttl:"' + ttl + '",acl:"' + n.li_attr.acl + '"}')
                //encQi = encodeURIComponent('{ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + n.li_attr.objecttype + '",alias:"' + n.li_attr.alias + '",xfalias:"' + n.li_attr.xfalias + '",fdid:"' + vId[vId.length - 1] + '",opnode:"' + n.id + '",ttl:"' + ttl + '",acl:"' + n.li_attr.acl + '"}');
                encQi = _zw.base64.encode('{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + n.li_attr.objecttype + '",alias:"' + n.li_attr.alias + '",xfalias:"' + n.li_attr.xfalias + '",fdid:"' + vId[vId.length - 1] + '",opnode:"' + n.id + '",ttl:"' + ttl + '",acl:"' + n.li_attr.acl + '"}');
                //encQi = encQi.replace(/ /gi, '+');
                switch (n.li_attr.xfalias) {
                    case "notice":
                    case "bbs":
                    case "file":
                        //window.location.href = '/Board/List?qi=' + encQi;
                        if (_zw.V.current.page.toLowerCase() == '/board/list') {
                            _zw.V.ot = n.li_attr.objecttype;
                            _zw.V.alias = n.li_attr.alias;
                            _zw.V.xfalias = n.li_attr.xfalias;
                            _zw.V.fdid = vId[vId.length - 1];
                            _zw.V.current.acl = n.li_attr.acl;
                            _zw.V.opnode = n.id;
                            _zw.V.ttl = ttl;

                            _zw.fn.initLv(_zw.V.fdid);
                            _zw.fn.loadList();

                        } else {
                            window.location.href = '/Board/List?qi=' + encodeURIComponent(encQi);
                        }
                        break;
                    case "album":
                        bootbox.alert('준비중!');
                        break;
                    case "anonymous":
                        if (_zw.V.current.page.toLowerCase() == '/board/anonymous') {
                            _zw.V.ot = n.li_attr.objecttype;
                            _zw.V.alias = n.li_attr.alias;
                            _zw.V.xfalias = n.li_attr.xfalias;
                            _zw.V.fdid = vId[vId.length - 1];
                            _zw.V.current.acl = n.li_attr.acl;
                            _zw.V.opnode = n.id;
                            _zw.V.ttl = ttl;

                            _zw.fn.initLv(_zw.V.fdid);
                            _zw.fn.loadList();

                        } else {
                            window.location.href = '/Board/Anonymous?qi=' + encodeURIComponent(encQi);
                        }
                        break;
                    case "linksite":
                        bootbox.alert('준비중!');
                        break;
                    case "knowledge":
                        if (_zw.V.current.page.toLowerCase() == '/docs/kms/list') {
                            _zw.V.mode = '';
                            _zw.V.ot = n.li_attr.objecttype;
                            _zw.V.alias = n.li_attr.alias;
                            _zw.V.xfalias = n.li_attr.xfalias;
                            _zw.V.fdid = vId[vId.length - 1];
                            _zw.V.current.acl = n.li_attr.acl;
                            _zw.V.opnode = n.id;
                            _zw.V.ttl = ttl;

                            _zw.fn.initLv(_zw.V.fdid);
                            _zw.fn.loadList();

                        } else {
                            window.location.href = '/Docs/Kms/List?qi=' + encodeURIComponent(encQi);
                        }
                        break;
                    default:
                        //window.location.href = '/Docs/Edm/List?qi=' + encQi;
                        //아래 처리를 위해서는 _zw.V json 값 셋팅이 필요
                        if (_zw.V.current.page.toLowerCase() == '/docs/edm/list') {
                            _zw.V.ot = n.li_attr.objecttype;
                            _zw.V.alias = n.li_attr.alias;
                            _zw.V.xfalias = n.li_attr.xfalias;
                            _zw.V.fdid = vId[vId.length - 1];
                            _zw.V.current.acl = n.li_attr.acl;
                            _zw.V.opnode = n.id;
                            _zw.V.ttl = ttl;

                            _zw.fn.initLv(_zw.V.fdid);
                            _zw.fn.loadList();

                        } else {
                            window.location.href = '/Docs/Edm/List?qi=' + encodeURIComponent(encQi);
                        }
                        break;
                }

                //window.location.href = '?qi=' + window.atob(_zw.V.qi)
                //$.ajax({
                //    type: "POST",
                //    url: "/Common/List",
                //    data: '{ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + n.li_attr.objecttype + '",xf:"' + n.li_attr.xfalias
                //            + '",permission:"' + n.li_attr.permission + '",page:1,count:20,tgt:"' + vId[vId.length - 1]
                //        + '",sort:"' + _zw.V.lv.sort + '",sortdir:"' + _zw.V.lv.sort + '",search:"' + _zw.V.lv.sort + '",searchtext:"",start:"",end:""}',
                //    success: function (res) {
                //        if (res.substr(0, 2) == "OK") {
                //            $('#__ListView').html(res.substr(2));
                //            $('#__CtDashboard').addClass('d-none');
                //            $('#__ListView').removeClass('d-none');
                //        } else alert(res);
                //    }                        
                //});
            } else if (n.li_attr.objecttype == 'B') { //자원예약
                if (_zw.V.current.page.toLowerCase() == '/tnc/booking/calendar') {
                    _zw.V.ot = "FD";
                    _zw.V.alias = n.li_attr.alias;
                    _zw.V.xfalias = n.li_attr.xfalias;
                    _zw.V.fdid = vId[vId.length - 1];
                    _zw.V.current.acl = n.li_attr.acl;
                    _zw.V.opnode = n.id;
                    _zw.V.ttl = ttl;

                    _zw.fn.loadList();

                } else {
                    encQi = _zw.base64.encode('{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"FD",alias:"' + n.li_attr.alias + '",xfalias:"' + n.li_attr.xfalias + '",fdid:"' + vId[vId.length - 1] + '",opnode:"' + n.id + '",ttl:"' + ttl + '",acl:"' + n.li_attr.acl + '"}');
                    window.location.href = '/TnC/Booking/Calendar?qi=' + encodeURIComponent(encQi);
                }
            } else if (n.li_attr.objecttype == 'S') { //일정
                bootbox.alert('준비중!');
            } else if (n.li_attr.objecttype == 'C') { //동호회
                bootbox.alert('준비중!');
            } else if (n.li_attr.objecttype == 'F') { //폴더분류
                if (n.a_attr.url.length > 0) {
                    if (n.a_attr.url == 'SEARCH_EADOC' || n.a_attr.url == 'SEARCH_DEVPRODUCT') {
                        if (_zw.V.current.page.toLowerCase() == '/report') {
                            _zw.V.ot = n.li_attr.objecttype;
                            _zw.V.alias = n.li_attr.alias;
                            _zw.V.xfalias = n.li_attr.xfalias;
                            _zw.V.fdid = vId[vId.length - 1];
                            _zw.V.current.acl = n.li_attr.acl;
                            _zw.V.opnode = n.id;
                            _zw.V.ft = n.a_attr.url;
                            _zw.V.ttl = ttl;

                            _zw.fn.initLv(_zw.V.current.urid);
                            _zw.fn.loadList();
                        } else {
                            //encQi = encodeURIComponent('{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + n.li_attr.objecttype + '",alias:"' + n.li_attr.alias + '",xfalias:"' + n.li_attr.xfalias + '",fdid:"' + vId[vId.length - 1] + '",opnode:"' + n.id + '",ft:"' + n.a_attr.url + '",ttl:"' + ttl + '",acl:"' + n.li_attr.acl + '"}');
                            encQi = _zw.base64.encode('{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + n.li_attr.objecttype + '",alias:"' + n.li_attr.alias + '",xfalias:"' + n.li_attr.xfalias + '",fdid:"' + vId[vId.length - 1] + '",opnode:"' + n.id + '",ft:"' + n.a_attr.url + '",ttl:"' + ttl + '",acl:"' + n.li_attr.acl + '"}');
                            window.location.href = '/Report?qi=' + encodeURIComponent(encQi);
                        }
                    } else if (n.a_attr.url.toLowerCase().indexOf('extensionservice/lcm') >= 0) { //Lcm
                        var vUrl = n.a_attr.url.split('/');
                        var pageLcm = vUrl[vUrl.length - 1].split('.')[0].toUpperCase(), ft = ''; //alert("page => " + pageLcm)

                        if (pageLcm == 'LCM_120') ft = 'LCM_COURSE';            //교육과정관리
                        else if (pageLcm == 'LCM_130') ft = 'LCM_INSTRUCTOR';   //사내교육강사현황
                        else if (pageLcm == 'LCM_200') ft = 'LCM_MAIN';         //개인신청현황
                        else if (pageLcm == 'LCM_300') ft = 'LCM_ADMIN';        //교육진행현황
                        else if (pageLcm == 'LCM_310') ft = 'LCM_EDUPOINT';     //결과집계현황 

                        if (ft == '') return false;
                        encQi = _zw.base64.encode('{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + n.li_attr.objecttype + '",alias:"' + n.li_attr.alias + '",xfalias:"' + n.li_attr.xfalias + '",fdid:"' + vId[vId.length - 1] + '",opnode:"' + n.id + '",ft:"' + ft + '",ttl:"' + ttl + '",acl:"' + n.li_attr.acl + '"}');
                        window.location.href = '/ExS/Lcm?qi=' + encodeURIComponent(encQi);

                    } else if (n.a_attr.url.toLowerCase().indexOf('/schedule/booking') >= 0) { //Booking
                        encQi = _zw.base64.encode('{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + n.li_attr.objecttype + '",alias:"' + n.li_attr.alias + '",xfalias:"' + n.li_attr.xfalias + '",fdid:"' + vId[vId.length - 1] + '",opnode:"' + n.id + '",ttl:"' + ttl + '",acl:"' + n.li_attr.acl + '"}');
                        window.location.href = '/TnC/Booking?qi=' + encodeURIComponent(encQi);

                    } else {
                        //encQi = encodeURIComponent('{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + n.li_attr.objecttype + '",alias:"' + n.li_attr.alias + '",xfalias:"' + n.li_attr.xfalias + '",fdid:"' + vId[vId.length - 1] + '",opnode:"' + n.id + '",ttl:"' + ttl + '",acl:"' + n.li_attr.acl + '"}');
                        encQi = _zw.base64.encode('{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + n.li_attr.objecttype + '",alias:"' + n.li_attr.alias + '",xfalias:"' + n.li_attr.xfalias + '",fdid:"' + vId[vId.length - 1] + '",opnode:"' + n.id + '",ttl:"' + ttl + '",acl:"' + n.li_attr.acl + '"}');
                        window.location.href = n.a_attr.url + '?qi=' + encodeURIComponent(encQi);
                    }
                }
            } else if (n.li_attr.objecttype == 'L') { //링크
                if (n.a_attr.url.indexOf('http://') >= 0 || n.a_attr.url.indexOf('https://') >= 0) {
                    window.location.href = n.a_attr.url;
                } else if (n.a_attr.url.toLowerCase().indexOf('extensionservice/pqm') >= 0) { //PQm
                    var vUrl = n.a_attr.url.split('/');
                    var ft = vUrl[vUrl.length - 1].split('.')[0].toUpperCase(); //alert(ft)

                    if (_zw.V.current.page.toLowerCase() == '/exs/pqm__') {
                        _zw.V.ot = n.li_attr.objecttype;
                        _zw.V.alias = n.li_attr.alias;
                        _zw.V.xfalias = n.li_attr.xfalias;
                        _zw.V.fdid = vId[vId.length - 1];
                        _zw.V.current.acl = n.li_attr.acl;
                        _zw.V.opnode = n.id;
                        _zw.V.ft = ft;
                        _zw.V.ttl = ttl;

                        _zw.fn.initLv(_zw.V.current.urid);
                        _zw.fn.loadList();
                    } else {
                        encQi = _zw.base64.encode('{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + n.li_attr.objecttype + '",alias:"' + n.li_attr.alias + '",xfalias:"' + n.li_attr.xfalias + '",fdid:"' + vId[vId.length - 1] + '",opnode:"' + n.id + '",ft:"' + ft + '",ttl:"' + ttl + '",acl:"' + n.li_attr.acl + '"}');
                        window.location.href = '/ExS/PQm?qi=' + encodeURIComponent(encQi);
                    }

                } else if (n.a_attr.url.toLowerCase().indexOf('extensionservice/num') >= 0) { //Num
                    var vUrl = n.a_attr.url.split('?');
                    var ft = vUrl[vUrl.length - 1].split('=')[1].toUpperCase(); //alert(ft); return

                    if (_zw.V.current.page.toLowerCase() == '/exs/num') {
                        _zw.V.ot = n.li_attr.objecttype;
                        _zw.V.alias = n.li_attr.alias;
                        _zw.V.xfalias = n.li_attr.xfalias;
                        _zw.V.fdid = vId[vId.length - 1];
                        _zw.V.current.acl = n.li_attr.acl;
                        _zw.V.opnode = n.id;
                        _zw.V.ft = ft;
                        _zw.V.ttl = ttl;

                        _zw.fn.initLv(_zw.V.current.urid);
                        _zw.fn.loadList();
                    } else {
                        encQi = _zw.base64.encode('{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + n.li_attr.objecttype + '",alias:"' + n.li_attr.alias + '",xfalias:"' + n.li_attr.xfalias + '",fdid:"' + vId[vId.length - 1] + '",opnode:"' + n.id + '",ft:"' + ft + '",ttl:"' + ttl + '",acl:"' + n.li_attr.acl + '"}');
                        window.location.href = '/ExS/Num?qi=' + encodeURIComponent(encQi);
                    }

                } else if (n.a_attr.url.toLowerCase().indexOf('extensionservice/voc') >= 0) { //VOC
                    if (_zw.ut.isMobile()) { bootbox.alert('모바일 환경에서는 지원되지 않습니다!'); return false; }

                    var vUrl = n.a_attr.url.split('/');
                    var page = vUrl[vUrl.length - 1].split('.')[0].toUpperCase(); //alert(page)
                    var w = window.screen.width, h = window.screen.height;
                    w = w >= 1600 ? parseInt(w * 0.85) : w; h = h >= 900 ? parseInt(h * 0.85) : h;
                    encQi = encodeURIComponent(_zw.base64.encode('{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + n.li_attr.objecttype + '",alias:"' + n.li_attr.alias + '",xfalias:"' + n.li_attr.xfalias + '",fdid:"' + vId[vId.length - 1] + '",opnode:"",ttl:"' + ttl + '",acl:"' + n.li_attr.acl + '"}'));

                    if (page == 'REPORT') _zw.ut.openWnd('/ExS/Voc/Ledger?qi=' + encQi, 'VocReport', w, h, 'resize');
                    else if (page == 'STATISTICS') _zw.ut.openWnd('/ExS/Voc/Statistics?qi=' + encQi, 'VocStatistics', w, h, 'resize');

                } else {
                    //console.log(n.li_attr.alias + " : " + n.a_attr.url)
                    if (n.li_attr.alias == "ea.form.select") {
                        _zw.fn.openNewEAForm(n.a_attr.url);

                    } else if (n.li_attr.alias.indexOf("ea.form.report") >= 0) {
                        //console.log(ttl);
                        if (_zw.V.current.page.toLowerCase() == '/report') {
                            _zw.V.ot = n.li_attr.objecttype;
                            _zw.V.alias = n.li_attr.alias;
                            _zw.V.xfalias = n.li_attr.xfalias;
                            _zw.V.fdid = vId[vId.length - 1];
                            _zw.V.current.acl = n.li_attr.acl;
                            _zw.V.opnode = n.id;
                            _zw.V.ft = n.a_attr.url;
                            _zw.V.ttl = ttl;

                            _zw.fn.initLv(_zw.V.current.urid);
                            _zw.fn.loadList();
                        } else {
                            //encQi = encodeURIComponent('{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + n.li_attr.objecttype + '",alias:"' + n.li_attr.alias + '",xfalias:"' + n.li_attr.xfalias + '",fdid:"' + vId[vId.length - 1] + '",opnode:"' + n.id + '",ft:"' + n.a_attr.url + '",ttl:"' + ttl + '",acl:"' + n.li_attr.acl + '"}');
                            encQi = _zw.base64.encode('{M:"",ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + n.li_attr.objecttype + '",alias:"' + n.li_attr.alias + '",xfalias:"' + n.li_attr.xfalias + '",fdid:"' + vId[vId.length - 1] + '",opnode:"' + n.id + '",ft:"' + n.a_attr.url + '",ttl:"' + ttl + '",acl:"' + n.li_attr.acl + '"}');
                            window.location.href = '/Report?qi=' + encodeURIComponent(encQi);
                        }
                    }
                }
            }

            _zw.ut.hideRightBar();
        }
    }
});