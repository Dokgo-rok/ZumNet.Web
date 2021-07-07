//조직도 트리

$(function () {

    if ($('#__OrgTree').length > 0) {
        $('#__OrgTree').jstree({
            core: {
                data: _zw.V.tree.data
            },
            plugins: ["wholerow"]
        })
        .on('loaded.jstree', function (e, data) {
            //data.instance.open_node('1350', function () {

            //    data.instance.open_node('1354', function () {

            //    });
            //});
        })
        .on('changed.jstree', function (e, data) {
            if (data.selected.length == 1) {
                var vPath = $("#__OrgTree").jstree("get_path", data.selected[0]);
                $('.z-ttl span').html(vPath.join(' / '));

                var n = data.instance.get_node(data.selected[0]);
                if (n.li_attr.hasmember) {
                    $.ajax({
                        type: "POST",
                        url: "?qi=",
                        data: '{page:1,count:50,tgt:"' + n.id + '"}',
                        success: function (res) {
                            if (res.substr(0, 2) == "OK") $('#__OrgList').html(res.substr(2));
                            else alert(res);
                        },
                        beforeSend: function () {//jstree ajax event와 충돌하는 듯....pace.js가 이벤트 종료가 안됨!!
                            //$('#ajaxLoader').modal('show');
                        }
                    });
                }
            }
        });
    }
    


});