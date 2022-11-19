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
			var s = 0, f = '0,0.0';
			if (el.name == "CRREGISTER" || el.name == "MAREGISTER" || el.name == "MIREGISTER" || el.name == "CRSOLVE" || el.name == "MASOLVE" || el.name == "MISOLVE") {
				if (el.name == "CRREGISTER" || el.name == "CRSOLVE") {
					s = _zw.ut.rate($('#__mainfield[name="CRSOLVE"]').val(), $('#__mainfield[name="CRREGISTER"]').val(), 4);
					$('#__mainfield[name="CRPERCENT"]').val(numeral(s).format(f));

				} else if (el.name == "MAREGISTER" || el.name == "MASOLVE") {
					s = _zw.ut.rate($('#__mainfield[name="MASOLVE"]').val(), $('#__mainfield[name="MAREGISTER"]').val(), 4);
					$('#__mainfield[name="MAPERCENT"]').val(numeral(s).format(f));

				} else if (el.name == "MIREGISTER" || el.name == "MISOLVE") {
					s = _zw.ut.rate($('#__mainfield[name="MISOLVE"]').val(), $('#__mainfield[name="MIREGISTER"]').val(), 4);
					$('#__mainfield[name="MIPERCENT"]').val(numeral(s).format(f));
				}

				s = _zw.ut.add(4, $('#__mainfield[name="CRREGISTER"]').val(), $('#__mainfield[name="MAREGISTER"]').val(), $('#__mainfield[name="MIREGISTER"]').val());
				$('#__mainfield[name="ALLREGISTER"]').val(numeral(s).format('0,0'));

				s = _zw.ut.add(4, $('#__mainfield[name="CRSOLVE"]').val(), $('#__mainfield[name="MASOLVE"]').val(), $('#__mainfield[name="MISOLVE"]').val());
				$('#__mainfield[name="ALLSOLVE"]').val(numeral(s).format('0,0'));

				s = _zw.ut.rate($('#__mainfield[name="ALLSOLVE"]').val(), $('#__mainfield[name="ALLREGISTER"]').val(), 4);
				$('#__mainfield[name="ALLPERCENT"]').val(numeral(s).format(f));

			} else if (el.name == "ROHSBAD" || el.name == "HFBAD" || el.name == "ETCBAD" || el.name == "ROHSFIND" || el.name == "HFFIND" || el.name == "ETCFIND") {
				if (el.name == "ROHSBAD") {
					if (el.value == '0') $('#__mainfield[name="ROHSRESULT"]').val('PASS');
					else if (el.value != '0' && el.value != '') $('#__mainfield[name="ROHSRESULT"]').val('FAIL');
					else $('#__mainfield[name="ROHSRESULT"]').val('');

				} else if (el.name == "HFBAD") {
					if (el.value == '0') $('#__mainfield[name="HFRESULT"]').val('PASS');
					else if (el.value != '0' && el.value != '') $('#__mainfield[name="HFRESULT"]').val('FAIL');
					else $('#__mainfield[name="HFRESULT"]').val('');

				} else if (el.name == "ETCBAD") {
					if (el.value == '0') $('#__mainfield[name="ETCRESULT"]').val('PASS');
					else if (el.value != '0' && el.value != '') $('#__mainfield[name="ETCRESULT"]').val('FAIL');
					else $('#__mainfield[name="ETCRESULT"]').val('');
				}

				s = _zw.ut.add(4, $('#__mainfield[name="ROHSFIND"]').val(), $('#__mainfield[name="HFFIND"]').val(), $('#__mainfield[name="ETCFIND"]').val());
				$('#__mainfield[name="ALLFIND"]').val(numeral(s).format('0,0'));

				var v1 = $('#__mainfield[name="ROHSBAD"]').val(), v2 = $('#__mainfield[name="HFBAD"]').val(), v3 = $('#__mainfield[name="ETCBAD"]').val();

				s = _zw.ut.add(4, v1, v2, v3); $('#__mainfield[name="ALLBAD"]').val(numeral(s).format('0,0'));

				if (v1 == '0' && v2 == '0' && v3 == '0') $('#__mainfield[name="ALLRESULT"]').val('PASS');
				else if ((v1 != '0' && v1 != '') || (v2 != '0' && v2 != '') || (v3 != '0' && v3 != '')) $('#__mainfield[name="ALLRESULT"]').val('FAIL');
				else $('#__mainfield[name="ALLRESULT"]').val('');
            }
        },
        "autoCalc": function (p) {
        },
		"optionWnd": function (pos, w, h, l, t, etc, x) {
			var el = _zw.ut.eventBtn(), vPos = pos.split('.');
			var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]);
			var m = '', v1 = '', v2 = '', v3 = '';
			if (vPos[0] == 'erp') m = 'getoracleerp';
			else if (vPos[0] == 'report') m = 'getreportsearch';
			else m = 'getcodedescription';

			//data body 조건 : N(modal-body 없음), F(footer 포함)
			$.ajax({
				type: "POST",
				url: "/EA/Common",
				data: '{M:"' + m + '",body:"N", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",fn:"",query:"",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:""}',
				success: function (res) {
					//res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
					if (res.substr(0, 2) == 'OK') {
						var j = { "close": true, "width": w, "height": h, "left": l, "top": t }
						j["title"] = el.attr('title'); j["content"] = res.substr(2);

						var pop = _zw.ut.popup(el[0], j);
						pop.find('a[data-val]').click(function () {
							var v = $(this).attr('data-val').split('^');
							for (var i = 0; i < param.length; i++) {
								$('#__mainfield[name="' + param[i] + '"]').val(v[i]);
							}
							pop.find('.close[data-dismiss="modal"]').click();
						});

						pop.find('input:text.z-input-in').keyup(function (e) {
							if (e.which == 13) {
								$('#__mainfield[name="' + param[0] + '"]').val($(this).val());
								pop.find('.close[data-dismiss="modal"]').click();
							}
						});

					} else bootbox.alert(res);
				}
			});
		}
    }
});