$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            return true;
        },
        "make": function (f) {
        },
        "checkEvent": function (ckb, el, fld) {
        },
        "calc": function (el) {
        },
        "autoCalc": function (p) {
        },
        "orgSelect": function (p, x) {
            p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
                var info = JSON.parse($(this).attr('data-attr')); console.log(info)
                var dn = $(this).next().text();

                $.ajax({
                    type: "POST",
                    url: "/EA/Common",
                    data: '{M:"getreportsearch",body:"S", k1:"report", k2:"' + _zw.V.ft + '", v1:"' + info["id"] + '"}',
                    async: false,
                    success: function (res) {
                        if (res.substr(0, 2) == 'OK') {
                            var vRes = res.substr(2).split(',');
                            for (var s in vRes) {
                                var v = vRes[s].split(':'); console.log(v)
                                if (v[0] == 'BIRTHDATE') {
                                    $('#__mainfield[name="THENAME"]').val(dn);
                                    $('#__mainfield[name="THEIN"]').val(info["indate"]);
                                    $('#__mainfield[name="THEBIRTH"]').val(v[1]);
                                    break;
                                }
                            }
                        } else bootbox.alert(res.substr(2));
                    },
                    beforeSend: function () { }
                });
            });
            p.modal('hide');
        }
    }
});