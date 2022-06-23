$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            return true;
        },
        "make": function (f) {
        },
        "checkEvent": function (ckb, el, fld) {
        },
        "calc": function (e) {
        },
        "autoCalc": function (p) {
        },
        "orgSelect": function (p, x) {
            if (typeof (x) === 'object') {
                //$(x).prev();
                p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
                    //console.log($(this).attr('data-attr'))
                    var info = JSON.parse($(this).attr('data-attr')); //console.log(info)
                    var dn = $(this).next().text();

                    $.ajax({
                        type: "POST",
                        url: "/EA/Common",
                        data: '{M:"gettopgroup",gid:"' + info["id"] + '"}',
                        success: function (res) {
                            if (res.substr(0, 2) == 'OK') {
                                $(x).prev().val(dn);
                                $(x).parent().prev().find(':text[name="CORPORATION"]').val(res.substr(2));
                            }
                            else bootbox.alert(res);
                        }
                    });
                });
            }
            p.modal('hide');
        }
    }
});