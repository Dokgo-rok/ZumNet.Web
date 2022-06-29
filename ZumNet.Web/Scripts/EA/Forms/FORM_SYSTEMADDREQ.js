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
        "date": function (el) {
            var row = $(el).parent().parent();
            var from = row.find(':text[name="FROMDATE1"]'), to = row.find(':text[name="TODATE1"]');
            var dif = _zw.ut.diff('day', from.val(), to.val()); //console.log(dif + " : " + !(dif))
            if (dif && dif > 0) { bootbox.alert('날짜 범위 입력 오류!', function () { to.val(''); to.focus(); }); return false; }
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