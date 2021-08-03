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

        $('#__FolderTree').jstree({
            core: {
                check_callback: true,
                data: {
                    type: 'POST',
                    url: '/Common/Tree',
                    data: function (node) {
                        var lvl = node.id == '#' ? '0' : node.li_attr.level;
                        var selType = node.id == '#' ? '' : node.li_attr.objecttype;
                        //console.log(JSON.stringify(node));
                        //console.log('id => ' + node.id + ' : selType => ' + selType + ' : level => ' + lvl);

                        return '{ct:"' + _zw.V.ct + '",selected:"' + node.id + '",seltype:"' + selType + '",lvl:"' + lvl + '",open:"' + _zw.V.opnode + '"}'
                    },
                    dataType: 'json',
                    beforeSend: function () {//jstree ajax event와 충돌하는 듯....pace.js가 이벤트 종료가 안됨!!
                        //$('#ajaxLoader').modal('show');
                    },
                }
            },
            plugins: ["types", "wholerow"]
            //plugins: ["dnd", "massload", "search", "state", "types", "unique", "wholerow", "changed", "conditionalselect"]
        })
        .on('loaded.jstree', function (e, data) {
            //alert(_zw.V.tree.selected)
            //data.instance.open_node('1350', function () {

            //    data.instance.open_node('1354', function () {

            //    });
            //});
        })
        .on('changed.jstree', function (e, d) {
            if (d.selected.length == 1) {
                //var vPath = $("#__FolderTree").jstree("get_path", d.selected[0]);
                var vPath = d.instance.get_path(d.selected[0]);
                $('.z-ttl span').html(vPath.join(' / '));

                var n = d.instance.get_node(d.selected[0]);
                //alert(n.li_attr.objecttype + ' : ' + n.li_attr.alias + ' : ' + n.li_attr.xfalias + ' : ' + n.li_attr.permission.substr(n.li_attr.permission.length-1, 1))
                var vId = n.id.split('.');
                if (n.li_attr.permission.substr(n.li_attr.permission.length - 1, 1) == 'V' && n.li_attr.objecttype == 'G') {
                    $.ajax({
                        type: "POST",
                        url: "/Common/List",
                        data: '{ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + n.li_attr.objecttype + '",xf:"' + n.li_attr.xfalias
                            + '",permission:"' + n.li_attr.permission + '",page:1,count:20,tgt:"' + vId[vId.length - 1] + '"}',
                        success: function (res) {
                            if (res.substr(0, 2) == "OK") {
                                $('#__ListView').html(res.substr(2));
                                $('#__CtDashboard').addClass('d-none');
                                $('#__ListView').removeClass('d-none');
                            } else alert(res);
                        }                        
                    });
                }
            }
        })
        .on("open_node.jstree", function (e, d) {
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

    }
});