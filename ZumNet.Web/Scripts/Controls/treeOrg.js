//조직도 트리

$(function () {

    if ($('#__OrgTree').length > 0) {
        $('#__OrgTree').jstree({
            core: {
                data: _zw.V.tree.data
            },
            plugins: ["types", "wholerow"],
            types: {
                default: { icon: "fas fa-user-friends text-secondary" },
                root: { icon: "fas fa-city text-indigo" }
            }
        })
        .on('loaded.jstree', function (e, data) {
            //data.instance.open_node('1350', function () {

            //    data.instance.open_node('1354', function () {

            //    });
            //});
        })
        .on('changed.jstree', function (e, d) {
            if (d.selected.length == 1) {
                var n = d.instance.get_node(d.selected[0]);

                if ('7777.' + n.id == _zw.V.opnode) return false; //'7777.' => 부서명 Navigation에 사용
                
                if (n.li_attr.hasmember) {
                    var vPath = $("#__OrgTree").jstree("get_path", d.selected[0]);

                    _zw.V.ttl = vPath.join(' / ');
                    window.document.title = _zw.V.ttl;
                    $('.z-ttl span').html(_zw.V.ttl);

                    _zw.fn.initLv(n.id);
                    _zw.V.mode = n.li_attr.level == 0 && n.li_attr.gralias == 'Z1000' ? 'all' : ''; //크레신 클릭
                    _zw.fn.loadList();
                }
            }
        });
    }
});