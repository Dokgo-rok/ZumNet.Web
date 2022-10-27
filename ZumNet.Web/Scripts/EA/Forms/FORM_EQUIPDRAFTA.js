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
			var s = 0, f = '0,0';
			if (el.name == "UNITCOST1") {
				$('#__subtable1 td :text[name="UNITCOST1"]').each(function (idx, e) { s += numeral(e.value).value(); })
				$('#__mainfield[name="UNITSUM1"]').val(numeral(s).format(f));
			} else if (el.name == "COUNT" || el.name == "UNITCOST2") {
				var row = $(el).parent().parent();
				s = parseFloat(_zw.ut.empty(row.find('td :text[name="COUNT"]').val())) * parseFloat(_zw.ut.empty(row.find('td :text[name="UNITCOST2"]').val()));
				row.find('td :text[name="SUM"]').val(numeral(s).format(f)); s = 0;

				$('#__subtable1 td :text[name="UNITCOST2"]').each(function (idx, e) { s += numeral(e.value).value(); })
				$('#__mainfield[name="UNITSUM2"]').val(numeral(s).format(f)); s = 0;

				$('#__subtable1 td :text[name="SUM"]').each(function (idx, e) { s += numeral(e.value).value(); })
				$('#__mainfield[name="TOTALSUM"]').val(numeral(s).format(f));
			}
        },
		"autoCalc": function (p) {
			var s = 0, f = '0,0';

			$('#__subtable1 td :text[name="UNITCOST1"]').each(function (idx, e) { s += numeral(e.value).value(); })
			$('#__mainfield[name="UNITSUM1"]').val(numeral(s).format(f)); s = 0;

			$('#__subtable1 td :text[name="UNITCOST2"]').each(function (idx, e) { s += numeral(e.value).value(); })
			$('#__mainfield[name="UNITSUM2"]').val(numeral(s).format(f)); s = 0;

			$('#__subtable1 td :text[name="SUM"]').each(function (idx, e) { s += numeral(e.value).value(); })
			$('#__mainfield[name="TOTALSUM"]').val(numeral(s).format(f));
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