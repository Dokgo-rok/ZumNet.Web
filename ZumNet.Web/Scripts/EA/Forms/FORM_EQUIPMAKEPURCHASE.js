$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            var el = null;
            if (cmd == "draft") { //기안

            } else { //결재
                if (_zw.V.biz == "의견") {
                    el = $('#__mainfield[name="CONTENTS"]');
                    if (el.length > 0 && $.trim(el.val()) == '') {
                        bootbox.alert("필수항목 [기획조정실의견] 누락!", function () { el.focus(); }); return false;
                    }
                }
            }
            return true;
        },
        "make": function (f) {
            if (_zw.V.biz == "의견") _zw.body.main(f, ["CONTENTS"]);
        },
        "checkEvent": function (ckb, el, fld) {
        },
        "calc": function (el) {
            var row = $(el).parent().parent(), p = row.parent().parent(); //console.log(p)
            var s = 0, s2 = 0, f = '0,0.[0000]';

            if (el.name == "COUNT" || el.name == "UNITCOST2") {
                var v1 = numeral(row.find(':text[name="COUNT"]').val()).value(), v2 = numeral(row.find(':text[name="UNITCOST2"]').val()).value();
                v1 = v1 || 0; v2 = v2 || 0;
                s = numeral(v1).multiply(v2);
                row.find(':text[name="SUM"]').val(numeral(s).format(f));
                p.find('td :text[name="SUM"]').each(function (idx, e) { s2 += numeral(e.value).value(); });
                $('#__mainfield[name="TOTALSUM"]').val(numeral(s2).format(f));
            }

            if (el.name == "COUNT" || el.name == "UNITCOST2" || el.name == "SUM" || el.name == "VAT" || el.name == "TARIFF") {
                row.find(':text[name="SUM"], :text[name="VAT"], :text[name="TARIFF"]').each(function (idx, e) {
                    s += numeral(e.value).value();
                });
                row.find(':text[name="TAXSUM"]').val(numeral(s).format(f)); s = 0;
                p.find('td :text[name="TAXSUM"]').each(function (idx, e) { s += numeral(e.value).value(); })
                $('#__mainfield[name="TOTALTAX"]').val(numeral(s).format(f));
            }

            s = 0;
            if (el.name == "SUM2") {
                p.find('td :text[name="SUM2"]').each(function (idx, e) { s += numeral(e.value).value(); })
                $('#__mainfield[name="TOTALSUM2"]').val(numeral(s).format(f));
            }
        },
        "autoCalc": function (p) {
            var s = 0, f = '0,0.[0000]';
            p.find('td :text[name="SUM"]').each(function (idx, e) { s += numeral(e.value).value(); });
            $('#__mainfield[name="TOTALSUM"]').val(numeral(s).format(f)); s = 0;

            p.find('td :text[name="TAXSUM"]').each(function (idx, e) { s += numeral(e.value).value(); })
            $('#__mainfield[name="TOTALTAX"]').val(numeral(s).format(f)); s = 0;

            p.find('td :text[name="SUM2"]').each(function (idx, e) { s += numeral(e.value).value(); })
            $('#__mainfield[name="TOTALSUM2"]').val(numeral(s).format(f));
        },
        "optionWnd": function (pos, w, h, m, n, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.'); //console.log(el.attr('title'))
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]); //console.log(param);
            var m = 'getcodedescription', v1 = '', v2 = '', v3 = '';
            var ttl = el.attr('data-original-title') && el.attr('data-original-title') != '' ? el.attr('data-original-title') : el.attr('title');

            //data body 조건 : N(modal-body 없음), F(footer 포함)
            $.ajax({
                type: "POST",
                url: "/EA/Common",
                data: '{M:"' + m + '",body:"", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",fn:"",query:"",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:""}',
                success: function (res) {
                    //res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
                    if (res.substr(0, 2) == 'OK') {
                        var p = $('#popBlank');
                        p.html(res.substr(2)).find('.modal-title').html(ttl);
                        p.find(".modal-dialog").css("max-width", "15rem");
                        //p.find(".modal-content").css("height", h + "px")

                        p.find('.zf-modal .z-lnk-navy[data-val]').click(function () {
                            var v = $(this).attr('data-val').split('^');
                            for (var i = 0; i < param.length; i++) {
                                $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
                            }
                            p.modal('hide');
                        });

                        $('.zf-modal input:text.z-input-in').keyup(function (e) {
                            if (e.which == 13) {
                                $('#__mainfield[name="' + param[0] + '"]').val($(this).val());
                                p.modal('hide');
                            }
                        });

                        p.on('hidden.bs.modal', function () { p.html(''); });
                        p.modal();

                    } else bootbox.alert(res);
                }
            });
        }
    }
});