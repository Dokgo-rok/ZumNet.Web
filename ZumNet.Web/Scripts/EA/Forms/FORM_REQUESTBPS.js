$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            if (_zw.V.biz == "receive") {
                var sMsg = '필수항목 [$field] 누락!';
                var el = $('#__mainfield[name="COMPLETIONDATE"]');
                if (el.length  > 0 && $.trim(el.val()) == '') { bootbox.alert(sMsg.replace('$field', 'Completion Date'), function () { try { el.focus(); } catch { } }); return false; }

                el = $('#__mainfield[name="CONTACTS"]');
                if (el.length > 0 && $.trim(el.val()) == '') { bootbox.alert(sMsg.replace('$field', 'Contacts'), function () { try { el.focus(); } catch { } }); return false; }

                el = $('#__mainfield[name="PROCESSING"]');
                if (el.length > 0 && $.trim(el.val()) == '') { bootbox.alert(sMsg.replace('$field', '처리내용'), function () { try { el.focus(); } catch { } }); return false; }
                
            }
            return true;
        },
        "make": function (f) {
            if (_zw.V.biz == "receive" && _zw.V.act == "__r") _zw.body.main(f, ["PROCESSING", "CONTACTS", "COMPLETIONDATE"]);
            else if (_zw.V.biz == "요청자") _zw.body.main(f, ["SATISFACTIONA", "SATISFACTION"]);
        },
        "checkEvent": function (ckb, el, fld) {
        },
        "calc": function (e) {
        },
        "autoCalc": function (p) {
        },
        "orgSelect": function (p) {
            p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
                //var jUser = JSON.parse($(this).attr('data-attr')); //console.log(jUser);
                $('#__mainfield[name="CONTACTS"]').val($(this).next().text());
            });
            p.modal('hide');
        },
        "optionWnd": function (pos, w, h, m, n, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.'); //console.log(arguments)
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]); //console.log(param);
            var m = '', v1 = '', v2 = '', v3 = '';
            if (vPos[0] == 'erp') {
                m = 'getoracleerp';
            } else if (vPos[0] == 'report') {
                m = 'getreportsearch';
            } else m = 'getcodedescription';

            $.ajax({
                type: "POST",
                url: "/EA/Common",
                data: '{M:"' + m + '", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",fn:"",query:"",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:""}',
                success: function (res) {
                    if (res.substr(0, 2) == 'OK') {
                        var p = $('#popBlank');
                        p.html(res.substr(2)).find('.modal-title').html(el.attr('title'));
                        if (el.attr('title') == '지급조건' || el.attr('title') == '주문유형') p.find(".modal-dialog").css("max-width", "30rem");
                        else if (m == 'getcodedescription') p.find(".modal-dialog").css("max-width", "15rem");
                        //p.find(".modal-content").css("height", h + "px")

                        p.find('.zf-modal .z-lnk-navy[data-val]').click(function () {
                            var v = $(this).attr('data-val').split('^');
                            for (var i = 0; i < param.length; i++) {
                                $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
                                //console.log(param[i] + " : " + $('#__mainfield[name="' + param[i] + '"]').val());
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