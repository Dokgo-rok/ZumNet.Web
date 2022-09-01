$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            return true;
        },
        "make": function (f) {
        },
        "checkEvent": function (ckb, el, fld) {
            _zw.formEx.event(el);
        },
        "calc": function (el) {
            var row = $(el).parent().parent(), p = row.parent().parent(), e1, e2;
            var s = 0, s2 = 0, f = '0,0', f2 = '0,0.[0000]';

            if (el.name == "TRIPCOUNT" || el.name == "MONEYB") {
                e1 = row.find(':text[name="TRIPCOUNT"]'); e2 = row.find(':text[name="MONEYB"]'); if (e2.val() != '' && e1.val() == '') e1.val('1');
                //console.log(parseInt(_zw.ut.empty(e1.val())) + " : " + parseInt(_zw.ut.empty(e2.val())))
                if (parseInt(_zw.ut.empty(e1.val())) > 0 && parseInt(_zw.ut.empty(e2.val())) > 0) {
                    s = parseInt(_zw.ut.empty(e2.val())) / parseInt(_zw.ut.empty(e1.val())); //console.log(s)
                    if (numeral(s).value() > 10000) {
                        bootbox.alert('1인 식비한도가 1만원을 초과하였습니다. 식대를 초기화 합니다.', function () { e2.val(''); e2.focus(); }); return false;
                    }
                }
            } s = 0;

            if (el.name == "MONEYA" || el.name == "MONEYB" || el.name == "MONEYC" || el.name == "MONEYD" || el.name == "MONEYE") {
                p.find('td :text[name="' + el.name + '"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value))).value(); });
                $('#__mainfield[name="TOTAL' + el.name.substr(el.name.length - 1) + '"]').val(numeral(s).format(f)); s = 0;

                s = _zw.ut.add(4, row.find(':text[name="MONEYA"]').val(), row.find(':text[name="MONEYB"]').val(), row.find(':text[name="MONEYC"]').val(), row.find(':text[name="MONEYD"]').val(), row.find(':text[name="MONEYE"]').val());
                row.find(':text[name="MONEYF"]').val(numeral(s).format(f)); s = 0;

                p.find('td :text[name="MONEYF"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value))).value(); });
                $('#__mainfield[name="TOTALF"]').val(numeral(s).format(f)); s = 0;

            } else if (el.name == "TRANSMONEY") {
                p.find('td :text[name="' + el.name + '"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value))).value(); });
                $('#__mainfield[name="TOTALA1"]').val(numeral(s).format(f)); s = 0;

            } else if (el.name == "DISTANCE") {
                p.find('td :text[name="' + el.name + '"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value))).value(); });
                $('#__mainfield[name="TOTALDISTANCE"]').val(numeral(s).format(f)); s = 0;

                s = numeral(parseFloat(_zw.ut.empty(row.find(':text[name="DISTANCE"]').val())) * parseFloat(_zw.ut.empty(row.find(':text[name="FUELUNIT"]').val()))).value();
                row.find(':text[name="FUELSUM"]').val(numeral(s).format(f)); s = 0;

                p.find('td :text[name="FUELSUM"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value))).value(); });
                $('#__mainfield[name="SUM"]').val(numeral(s).format(f)); s = 0;
            }
        },
        "autoCalc": function (p) {
            var s = 0, s2 = 0, f = '0,0', f2 = '0,0.[0000]';

            if (p.find('td :text[name="MONEYA"]').length > 0) {
                p.find('td :text[name="MONEYA"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value))).value(); });
                $('#__mainfield[name="TOTALA"]').val(numeral(s).format(f)); s = 0;

                p.find('td :text[name="MONEYB"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value))).value(); });
                $('#__mainfield[name="TOTALB"]').val(numeral(s).format(f)); s = 0;

                p.find('td :text[name="MONEYC"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value))).value(); });
                $('#__mainfield[name="TOTALC"]').val(numeral(s).format(f)); s = 0;

                p.find('td :text[name="MONEYD"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value))).value(); });
                $('#__mainfield[name="TOTALD"]').val(numeral(s).format(f)); s = 0;

                p.find('td :text[name="MONEYE"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value))).value(); });
                $('#__mainfield[name="TOTALE"]').val(numeral(s).format(f)); s = 0;

                p.find('td :text[name="MONEYF"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value))).value(); });
                $('#__mainfield[name="TOTALF"]').val(numeral(s).format(f)); s = 0;

            } else if (p.find('td :text[name="TRANSMONEY"]').length > 0) {
                p.find('td :text[name="TRANSMONEY"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value))).value(); });
                $('#__mainfield[name="TOTALA1"]').val(numeral(s).format(f));

            } else if (p.find('td :text[name="DISTANCE"]').length > 0) {
                p.find('td :text[name="DISTANCE"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value))).value(); });
                $('#__mainfield[name="TOTALDISTANCE"]').val(numeral(s).format(f)); s = 0;

                p.find('td :text[name="FUELSUM"]').each(function (z, e) { s += numeral(parseFloat(_zw.ut.empty(e.value))).value(); });
                $('#__mainfield[name="SUM"]').val(numeral(s).format(f)); s = 0;
            }
        },
        "date": function (el) {
            var row = $(el).parent().parent();

            if (el.name == 'DODATE') {
                $.ajax({
                    type: "POST",
                    url: "/EA/Common",
                    data: '{M:"getreportsearch",body:"S", k1:"",k2:"REGISTER_INANDOUT",k3:"",query:"' + $('#__mainfield[name="TRIPPERSONID"]').val() + '",v1:"' + el.value + '",v2:""}',
                    success: function (res) {
                        if (res.substr(0, 2) == 'OK') { row.find(':text[name="TRANSTIME"]').val(res.substr(2)); }
                        else if (res.substr(0, 2) == 'NE' || res.substr(0, 2) == 'NO') { bootbox.alert(res.substr(2)); return false; }
                        else { bootbox.alert(res); return false; }
                    }
                });

            } else if (el.name == 'DRIVEDATE') {
                _zw.formEx.event(el);
            }
        },
        "orgSelect": function (p, x) {
            p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
                var info = JSON.parse($(this).attr('data-attr')); //console.log(info)
                var dn = $(this).next().text();
                $('#__mainfield[name="TRIPPERSON"]').val(dn);
                $('#__mainfield[name="TRIPPERSONID"]').val(info["id"]);
                $('#__mainfield[name="TRIPPERSONEMPID"]').val(info["empid"]);
                $('#__mainfield[name="TRIPPERSONGRADE"]').val(info["grade"]);
                $('#__mainfield[name="TRIPPERSONORG"]').val(info["grdn"]);
                $('#__mainfield[name="TRIPPERSONDEPTID"]').val(info["grid"]);
                $('#__mainfield[name="TRIPPERSONCORP"]').val(info["belong"]);
            });
            p.modal('hide');
        },
        "event": function (el) {
            var row = el.parentNode; do { row = row.parentNode; } while (row.tagName != 'TR'); row = $(row);

            if (el.name == 'DRIVEDATE' || el.name == 'ckbFUELKIND') {
                if (row.find(':text[name="DRIVEDATE"]').val() != '' && row.find(':hidden[name="FUELKIND"]').val() != '') {
                    $.ajax({
                        type: "POST",
                        url: "/EA/Common",
                        data: '{M:"getreportsearch",body:"S", k1:"",k2:"REGISTER_GAS",k3:"123",query:"' + row.find(':text[name="DRIVEDATE"]').val() + '",v1:"' + row.find(':hidden[name="FUELKIND"]').val() + '",v2:""}',
                        success: function (res) {
                            if (res.substr(0, 2) == 'OK') {
                                var v = res.substr(2);
                                row.find(':text[name="FUELUNIT"]').val(numeral(v).format('0,0'));

                                var s = numeral(parseFloat(_zw.ut.empty(row.find(':text[name="DISTANCE"]').val())) * parseFloat(_zw.ut.empty(row.find(':text[name="FUELUNIT"]').val()))).value();
                                row.find(':text[name="FUELSUM"]').val(numeral(s).format('0,0'));

                                _zw.formEx.autoCalc(row.parent().parent());
                            }
                            else if (res.substr(0, 2) == 'NE' || res.substr(0, 2) == 'NO') { bootbox.alert(res.substr(2)); return false; }
                            else { bootbox.alert(res); return false; }
                        },
                        beforeSend: function () { }
                    });
                }
            }
        }
    }
});