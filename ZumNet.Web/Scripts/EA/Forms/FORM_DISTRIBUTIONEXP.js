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
			var s = 0, s2 = 0, s3 = 0, s4 = 0, f = '0,0.[00000]';
			var p1 = $('#__subtable1'), p2 = $('#__subtable2'), row = null, c = null;

			if (el.name == "COUNT" || el.name == "COUNTTWO") {
				p1.find('td :text[name="COUNT"]').each(function (idx, e) { s += numeral(e.value).value(); });
				$('#__mainfield[name="SUBONECOUNT"]').val(numeral(s).format(f));

				p2.find('td :text[name="COUNTTWO"]').each(function (idx, e) { s2 += numeral(e.value).value(); });
				$('#__mainfield[name="SUBTWOCOUNT"]').val(numeral(s2).format(f));

				$('#__mainfield[name="TOTALCOUNT"]').val(numeral(s + s2).format(f)); s = 0; s2 = 0;

			} else if (el.name == "PRICE" || el.name == "PRICETWO") {
				p1.find('td :text[name="PRICE"]').each(function (idx, e) { s += numeral(e.value).value(); });
				$('#__mainfield[name="SUBONEPRICE"]').val(numeral(s).format(f));

				p2.find('td :text[name="PRICETWO"]').each(function (idx, e) { s2 += numeral(e.value).value(); });
				$('#__mainfield[name="SUBTWOPRICE"]').val(numeral(s2).format(f));

				$('#__mainfield[name="TOTALPRICE"]').val(numeral(s + s2).format(f)); s = 0; s2 = 0;

			} else if (el.name == "USDPRICE" || el.name == "USDPRICETWO" || el.name == "USDEARN" || el.name == "USDEARNTWO") {
				if (el.name == "USDPRICE" || el.name == "USDEARN") {
					row = $(el).parent().parent(); c = numeral(row.find(':text[name="USDEARN"]').val()).value();
					if (c > 0) s = _zw.ut.rate(row.find(':text[name="USDPRICE"]').val(), c, 4);
					else s = 0;
					row.find(':text[name="USDDISPER"]').val(numeral(s).format(f)); s = 0;

				} else if (el.name == "USDPRICETWO" || el.name == "USDEARNTWO") {
					row = $(el).parent().parent(); c = numeral(row.find(':text[name="USDEARNTWO"]').val()).value();
					if (c > 0) s = _zw.ut.rate(row.find(':text[name="USDPRICETWO"]').val(), c, 4);
					else s = 0;
					row.find(':text[name="USDDISPERTWO"]').val(numeral(s).format(f)); s = 0;
				}

				p1.find('td :text[name="USDPRICE"]').each(function (idx, e) { s += numeral(e.value).value(); });
				$('#__mainfield[name="SUBONEUSDPRICE"]').val(numeral(s).format(f));

				p1.find('td :text[name="USDEARN"]').each(function (idx, e) { s2 += numeral(e.value).value(); });
				$('#__mainfield[name="SUBONEUSDEARN"]').val(numeral(s2).format(f));

				if (s2 > 0) $('#__mainfield[name="SUBONEUSDDISPER"]').val(numeral(_zw.ut.rate(s, s2, 4)).format(f));
				else $('#__mainfield[name="SUBONEUSDDISPER"]').val('0');

				p2.find('td :text[name="USDPRICETWO"]').each(function (idx, e) { s3 += numeral(e.value).value(); });
				$('#__mainfield[name="SUBTWOUSDPRICE"]').val(numeral(s3).format(f));

				p2.find('td :text[name="USDEARNTWO"]').each(function (idx, e) { s4 += numeral(e.value).value(); });
				$('#__mainfield[name="SUBTWOUSDEARN"]').val(numeral(s4).format(f));

				if (s4 > 0) $('#__mainfield[name="SUBTWOUSDDISPER"]').val(numeral(_zw.ut.rate(s3, s4, 4)).format(f));
				else $('#__mainfield[name="SUBTWOUSDDISPER"]').val('0');

				$('#__mainfield[name="TOTALUSDPRICE"]').val(numeral(s + s3).format(f));
				$('#__mainfield[name="TOTALUSDEARN"]').val(numeral(s2 + s4).format(f));

				if (s2 + s4 > 0) $('#__mainfield[name="TOTALUSDDISPER"]').val(numeral(_zw.ut.rate((s + s3), (s2 + s4), 4)).format(f));
				else $('#__mainfield[name="TOTALUSDDISPER"]').val('0');
			}

        },
		"autoCalc": function (p) {
			var s = 0, s2 = 0, s3 = 0, s4 = 0, f = '0,0.[00000]';
			var p1 = $('#__subtable1'), p2 = $('#__subtable2');

			p1.find('td :text[name="COUNT"]').each(function (idx, e) { s += numeral(e.value).value(); });
			$('#__mainfield[name="SUBONECOUNT"]').val(numeral(s).format(f));

			p2.find('td :text[name="COUNTTWO"]').each(function (idx, e) { s2 += numeral(e.value).value(); });
			$('#__mainfield[name="SUBTWOCOUNT"]').val(numeral(s2).format(f));

			$('#__mainfield[name="TOTALCOUNT"]').val(numeral(s + s2).format(f)); s = 0; s2 = 0;

			p1.find('td :text[name="PRICE"]').each(function (idx, e) { s += numeral(e.value).value(); });
			$('#__mainfield[name="SUBONEPRICE"]').val(numeral(s).format(f));

			p2.find('td :text[name="PRICETWO"]').each(function (idx, e) { s2 += numeral(e.value).value(); });
			$('#__mainfield[name="SUBTWOPRICE"]').val(numeral(s2).format(f));

			$('#__mainfield[name="TOTALPRICE"]').val(numeral(s + s2).format(f)); s = 0; s2 = 0;

			p1.find('td :text[name="USDPRICE"]').each(function (idx, e) { s += numeral(e.value).value(); });
			$('#__mainfield[name="SUBONEUSDPRICE"]').val(numeral(s).format(f));

			p1.find('td :text[name="USDEARN"]').each(function (idx, e) { s2 += numeral(e.value).value(); });
			$('#__mainfield[name="SUBONEUSDEARN"]').val(numeral(s2).format(f));

			if (s2 > 0) $('#__mainfield[name="SUBONEUSDDISPER"]').val(numeral(_zw.ut.rate(s, s2, 4)).format(f)); //
			else $('#__mainfield[name="SUBONEUSDDISPER"]').val('0');

			p2.find('td :text[name="USDPRICETWO"]').each(function (idx, e) { s3 += numeral(e.value).value(); });
			$('#__mainfield[name="SUBTWOUSDPRICE"]').val(numeral(s3).format(f));

			p2.find('td :text[name="USDEARNTWO"]').each(function (idx, e) { s4 += numeral(e.value).value(); });
			$('#__mainfield[name="SUBTWOUSDEARN"]').val(numeral(s4).format(f));

			if (s4 > 0) $('#__mainfield[name="SUBTWOUSDDISPER"]').val(numeral(_zw.ut.rate(s3, s4, 4)).format(f));
			else $('#__mainfield[name="SUBTWOUSDDISPER"]').val('0');

			$('#__mainfield[name="TOTALUSDPRICE"]').val(numeral(s + s3).format(f));
			$('#__mainfield[name="TOTALUSDEARN"]').val(numeral(s2 + s4).format(f));

			if (s2 + s4 > 0) $('#__mainfield[name="TOTALUSDDISPER"]').val(numeral(_zw.ut.rate((s + s3), (s2 + s4), 4)).format(f));
			else $('#__mainfield[name="TOTALUSDDISPER"]').val('0');

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
						var row = x == 'MONEYTYPE' || x == 'MONEYTYPETWO' ? el.parent().parent() : null;
						pop.find('a[data-val]').click(function () {
							var v = $(this).attr('data-val').split('^');
							for (var i = 0; i < param.length; i++) {
								if (row) row.find('[name="' + param[i] + '"]').val(v[i]);
								else $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
							}
							pop.find('.close[data-dismiss="modal"]').click();
						});

						pop.find('input:text.z-input-in').keyup(function (e) {
							if (e.which == 13) {
								if (row) row.find('[name="' + param[0] + '"]').val($(this).val());
								else $('#__mainfield[name="' + param[0] + '"]').val($(this).val());
								pop.find('.close[data-dismiss="modal"]').click();
							}
						});

					} else bootbox.alert(res);
				}
			});
		}
    }
});