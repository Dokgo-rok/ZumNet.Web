$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            var el = null;
            if (cmd == "draft") { //기안
                if ($('#__mainfield[name="LOCATION"]').val() == 'KH') {
                    el = $('#__mainfield[name="WORKDATE"]');
                    if ($.trim(el.val()) == '') { bootbox.alert('필수항목 [본사 방문계획1] 누락!', function () { el.focus(); }); return false; }

                    el = $('#__mainfield[name="WORKDATE2"]');
                    if ($.trim(el.val()) == '') { bootbox.alert('필수항목 [본사 방문계획2] 누락!', function () { el.focus(); }); return false; }
                }
            }
            return true;
        },
        "make": function (f) {
        },
        "checkEvent": function (ckb, el, fld) {
            var p;
            if (fld == 'LOCATION') {
                p = $('#panDisplay2');
                if (el.checked && el.value == 'KH') { p.show(); } else { p.hide().find('.ft #__mainfield[name]').val(''); }

            } else if (fld == 'LASTCHECK') {
                if (el.checked && el.value == '전출장유') {
                    $('#__mainfield[name="LASTTRIPFROM"]').prop('readonly', false).show();
                    $('#__mainfield[name="LASTTRIPTO"]').prop('readonly', false).show();
                    $('#__mainfield[name="LASTSTAY"]').prop('readonly', false).show();
                    $('#__mainfield[name="LASTDAY"]').prop('readonly', false).show();
                    _zw.fn.input($(el.parentNode.parentNode));
                } else {
                    $('#__mainfield[name="LASTTRIPFROM"]').prop('readonly', true).hide().val('');
                    $('#__mainfield[name="LASTTRIPTO"]').prop('readonly', true).hide().val('');
                    $('#__mainfield[name="LASTSTAY"]').prop('readonly', true).hide().val('');
                    $('#__mainfield[name="LASTDAY"]').prop('readonly', true).hide().val('');
                }

            } else if (fld == 'OUTBUDGET') {
                p = $('#panDisplay');
                if (el.checked && el.value == '필요') { p.show(); } else { p.hide().find('#__subtable1 tr.sub_table_row > td > :text[name]').val(''); }
            }
        },
        "calc": function (el) {
        },
        "autoCalc": function (p) {
        },
        "date": function (el) {
            var from, to, dif;
            if (el.name == 'TRIPFROM' || el.name == 'TRIPTO') {
                from = $('#__mainfield[name="TRIPFROM"]'); to = $('#__mainfield[name="TRIPTO"]');
                dif = _zw.ut.diff('day', to.val(), from.val());
                if (dif && dif < 0) { bootbox.alert('날짜 범위 입력 오류!', function () { to.val(''); to.focus(); }); return false; }
                if (dif) { $('#__mainfield[name="STAY"]').val(dif); $('#__mainfield[name="DAY"]').val(dif + 1); }

            } else if (el.name == 'LASTTRIPFROM' || el.name == 'LASTTRIPTO') {
                from = $('#__mainfield[name="LASTTRIPFROM"]'); to = $('#__mainfield[name="LASTTRIPTO"]');
                dif = _zw.ut.diff('day', to.val(), from.val());
                if (dif && dif < 0) { bootbox.alert('날짜 범위 입력 오류!', function () { to.val(''); to.focus(); }); return false; }
                if (dif) { $('#__mainfield[name="LASTSTAY"]').val(dif); $('#__mainfield[name="LASTDAY"]').val(dif + 1); }

            } else if (el.name == 'SECONDFROM' || el.name == 'SECONDTO') {
                from = $('#__mainfield[name="SECONDFROM"]'); to = $('#__mainfield[name="SECONDTO"]');
                dif = _zw.ut.diff('day', to.val(), from.val());
                if (dif && dif < 0) { bootbox.alert('날짜 범위 입력 오류!', function () { to.val(''); to.focus(); }); return false; }

            } else if (el.name == 'THIRDFROM' || el.name == 'THIRDTO') {
                from = $('#__mainfield[name="THIRDFROM"]'); to = $('#__mainfield[name="THIRDTO"]');
                dif = _zw.ut.diff('day', to.val(), from.val());
                if (dif && dif < 0) { bootbox.alert('날짜 범위 입력 오류!', function () { to.val(''); to.focus(); }); return false; }

            } else if (el.name == 'FORTHFROM' || el.name == 'FORTHTO') {
                from = $('#__mainfield[name="FORTHFROM"]'); to = $('#__mainfield[name="FORTHTO"]');
                dif = _zw.ut.diff('day', to.val(), from.val());
                if (dif && dif < 0) { bootbox.alert('날짜 범위 입력 오류!', function () { to.val(''); to.focus(); }); return false; }
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
        "optionWnd": function (pos, w, h, l, t, etc, x) {
            var el = _zw.ut.eventBtn(), vPos = pos.split('.');
            var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]);
            var m = '', v1 = '', v2 = '', v3 = '';
            if (vPos[0] == 'erp') m = 'getoracleerp';
            else if (vPos[0] == 'report') m = 'getreportsearch';
            else m = 'getcodedescription';

            var pOption = ['F', 'checkbox'];
            if (vPos[1] == 'currency') pOption = ['N', ''];

            //data body 조건 : N(modal-body 없음), F(footer 포함)
            $.ajax({
                type: "POST",
                url: "/EA/Common",
                data: '{M:"' + m + '",body:"' + pOption[0] + '", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",fn:"' + pOption[1] + '",query:"",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:""}',
                success: function (res) {
                    //res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
                    if (res.substr(0, 2) == 'OK') {
                        if (pOption[0] != 'N') {
                            var p = $('#popBlank');
                            p.html(res.substr(2)).find('.modal-title').html(el.attr('title'));
                            //if (m == 'getcodedescription') p.find(".modal-dialog").css("max-width", "15rem");

                            p.find('.zf-modal .modal-footer .btn[data-zm-menu="confirm"]').click(function () {
                                var v = '';
                                p.find('.modal-body td [name="ckbMultiOption"]:checked').each(function (idx) {
                                    var c = $(this).parent().next().next();
                                    v += (idx > 0 ? ',' : '') + (c.find('.z-input-in').length > 0 ? c.find('.z-input-in').val() : c.text());
                                });
                                $('#__mainfield[name="' + param[0] + '"]').val(v); _zw.formEx.event('BIZTRIP_EXPENSERULE', param[0]);
                                p.modal('hide');
                            });

                            p.on('hidden.bs.modal', function () { p.html(''); });
                            p.modal();

                        } else {
                            var j = { "close": true, "width": w, "height": h, "left": l, "top": t }
                            j["title"] = el.attr('title'); j["content"] = res.substr(2);

                            var pop = _zw.ut.popup(el[0], j);
                            pop.find('a[data-val]').click(function () {
                                var v = $(this).attr('data-val').split('^');
                                for (var i = 0; i < param.length; i++) {
                                    el.parent().parent().find('[name="' + param[i] + '"]').val(v[i]);
                                }
                                pop.find('.close[data-dismiss="modal"]').click();
                            });

                            pop.find('input:text.z-input-in').keyup(function (e) {
                                if (e.which == 13) {
                                    el.parent().parent().find('[name="' + param[0] + '"]').val($(this).val());
                                    pop.find('.close[data-dismiss="modal"]').click();
                                }
                            });
                        }

                    } else bootbox.alert(res);
                }
            });
        },
    }
});