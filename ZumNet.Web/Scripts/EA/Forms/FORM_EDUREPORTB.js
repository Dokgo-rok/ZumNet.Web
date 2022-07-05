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
        "optionWnd": function (pos, w, h, l, t, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.');
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]);
            var m = '', query = '', v1 = '', v2 = '', v3 = '', v4 = '', v5 = '', k3 = '';
            if (vPos[0] == 'erp') m = 'getoracleerp';
            else if (vPos[0] == 'report') m = 'getreportsearch';
            else m = 'getcodedescription';

            if (vPos[1] == "LCM_MAIN") {
                query = $('#__mainfield[name="APPLID"]').val(); v1 = $('#__mainfield[name="STDYEAR"]').val(); v2 = $('#__mainfield[name="CLSCD1"]').val();
                k3 = x;
            }

            //data body 조건 : N(modal-body 없음), F(footer 포함)
            $.ajax({
                type: "POST",
                url: "/EA/Common",
                data: '{M:"' + m + '",body:"", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + k3 + '",etc:"' + etc + '",query:"' + query + '",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",v4:"' + v4 + '",v5:"' + v5 + '",search:""}',
                success: function (res) {
                    //res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
                    if (res.substr(0, 2) == 'OK') {
                        var p = $('#popBlank');
                        p.html(res.substr(2)).find('.modal-title').html(el.attr('title'));
                        p.find(".modal-dialog").removeClass("modal-sm").removeClass("modal-lg").css("max-width", "52rem");

                        p.find('.zf-modal .z-lnk-navy[data-val]').click(function () {//console.log($(this).attr('data-val'))
                            var v = JSON.parse($(this).attr('data-val')), pan, nm; //console.log(v);
                            if (vPos[1] == "LCM_MAIN") {
                                pan = $('#panRequest');
                                pan.find('#__mainfield[name]').each(function () {
                                    nm = $(this).attr("name");
                                    if (v[nm]) $(this).val(v[nm]);
                                });
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

                        //var j = { "close": true, "width": w, "height": h, "left": l, "top": t }
                        //j["title"] = el.attr('title'); j["content"] = res.substr(2);

                        //var pop = _zw.ut.popup(el[0], j);
                        //pop.find('a[data-val]').click(function () {
                        //    var v = $(this).attr('data-val').split('^');
                        //    for (var i = 0; i < param.length; i++) {
                        //        $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
                        //    }
                        //    pop.find('.close[data-dismiss="modal"]').click();
                        //});

                        //pop.find('input:text.z-input-in').keyup(function (e) {
                        //    if (e.which == 13) {
                        //        $('#__mainfield[name="' + param[0] + '"]').val($(this).val());
                        //        pop.find('.close[data-dismiss="modal"]').click();
                        //    }
                        //});

                    } else bootbox.alert(res);
                }
            });
        },
    }
});