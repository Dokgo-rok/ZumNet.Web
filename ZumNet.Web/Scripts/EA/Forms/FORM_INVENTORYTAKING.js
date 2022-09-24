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
			var e1, e2, e3, e4, row;
			var s = 0, f = '0,0.[0000]';

			if (el.name == "ERPQUANTITY" || el.name == "REALQUANTITY") {
				row = $(el).parent().parent();
				e1 = row.find('> td [name="ERPQUANTITY"]'); e2 = row.find('> td [name="REALQUANTITY"]'); e3 = row.find('> td [name="DIFFERENT"]'); e4 = row.find('> td [name="MATCHPERCENT"]');
				e3.val(numeral(numeral(e2[0].value).value() - numeral(e1[0].value).value()).format('0,0.[0]'));
				if (numeral(e1[0].value) == 0) e4.val('0');
				else {
					s = _zw.ut.rate(parseFloat(_zw.ut.empty(e2.val())), parseFloat(_zw.ut.empty(e1.val())), 4);
					e4.val(numeral(s).format('0,0.[0]'));
				}
				s = 0;

				e1 = $('#__mainfield[name="TOTAL1"]'); e2 = $('#__mainfield[name="TOTAL2"]'); e3 = $('#__mainfield[name="TOTAL3"]'); e4 = $('#__mainfield[name="TOTAL4"]');

				row.parent().parent().find('td :text[name="ERPQUANTITY"]').each(function (idx, e) { s += numeral(e.value).value(); })
				e1.val(numeral(s).format(f)); s = 0;

				row.parent().parent().find('td :text[name="REALQUANTITY"]').each(function (idx, e) { s += numeral(e.value).value(); })
				e2.val(numeral(s).format(f)); s = 0;

				e3.val(numeral(numeral(e2[0].value).value() - numeral(e1[0].value).value()).format('0,0.[0]'));
				if (numeral(e1[0].value) == 0) e4.val('0');
				else {
					s = _zw.ut.rate(parseFloat(_zw.ut.empty(e2.val())), parseFloat(_zw.ut.empty(e1.val())), 4);
					e4.val(numeral(s).format('0,0.[0]'));
				}
			} else if (el.name == "ERPUSD" || el.name == "REALUSD") {
				row = $(el).parent().parent();
				e1 = row.find('> td [name="ERPUSD"]'); e2 = row.find('> td [name="REALUSD"]'); e3 = row.find('> td [name="DIFFERENTUSD"]'); e4 = row.find('> td [name="MATCHPERCENTUSD"]');
				e3.val(numeral(numeral(e2[0].value).value() - numeral(e1[0].value).value()).format('0,0.[0]'));
				if (numeral(e1[0].value) == 0) e4.val('0');
				else {
					s = _zw.ut.rate(parseFloat(_zw.ut.empty(e2.val())), parseFloat(_zw.ut.empty(e1.val())), 4);
					e4.val(numeral(s).format('0,0.[0]'));
				}
				s = 0;

				e1 = $('#__mainfield[name="TOTAL5"]'); e2 = $('#__mainfield[name="TOTAL6"]'); e3 = $('#__mainfield[name="TOTAL7"]'); e4 = $('#__mainfield[name="TOTAL8"]');

				row.parent().parent().find('td :text[name="ERPUSD"]').each(function (idx, e) { s += numeral(e.value).value(); })
				e1.val(numeral(s).format(f)); s = 0;

				row.parent().parent().find('td :text[name="REALUSD"]').each(function (idx, e) { s += numeral(e.value).value(); })
				e2.val(numeral(s).format(f)); s = 0;

				e3.val(numeral(numeral(e2[0].value).value() - numeral(e1[0].value).value()).format('0,0.[0]'));
				if (numeral(e1[0].value) == 0) e4.val('0');
				else {
					s = _zw.ut.rate(parseFloat(_zw.ut.empty(e2.val())), parseFloat(_zw.ut.empty(e1.val())), 4);
					e4.val(numeral(s).format('0,0.[0]'));
				}
			} else if (el.name == "INVENTORYQU" || el.name == "COMPLETEINVEN") {
				e1 = $('#__mainfield[name="INVENTORYQU"]'); e2 = $('#__mainfield[name="COMPLETEINVEN"]'); e3 = $('#__mainfield[name="PERCENT1"]');
				if (numeral(e1[0].value) == 0) e4.val('0%');
				else {
					s = _zw.ut.rate(parseFloat(_zw.ut.empty(e2.val())), parseFloat(_zw.ut.empty(e1.val())), 4);
					e3.val(numeral(s).format('0,0.0') + '%');
				}
			}
        },
		"autoCalc": function (p) {
			var e1, e2, e3, e4;
			var s = 0, f = '0,0.[0000]';

			if (p.attr('id') == '__subtable1') {
				e1 = $('#__mainfield[name="TOTAL1"]'); e2 = $('#__mainfield[name="TOTAL2"]'); e3 = $('#__mainfield[name="TOTAL3"]'); e4 = $('#__mainfield[name="TOTAL4"]');

				p.find('td :text[name="ERPQUANTITY"]').each(function (idx, e) { s += numeral(e.value).value(); })
				e1.val(numeral(s).format(f)); s = 0;

				p.find('td :text[name="REALQUANTITY"]').each(function (idx, e) { s += numeral(e.value).value(); })
				e2.val(numeral(s).format(f)); s = 0;

				e3.val(numeral(numeral(e2[0].value).value() - numeral(e1[0].value).value()).format('0,0.[0]'));
				if (numeral(e1[0].value) == 0) e4.val('0');
				else {
					s = _zw.ut.rate(parseFloat(_zw.ut.empty(e2.val())), parseFloat(_zw.ut.empty(e1.val())), 4);
					e4.val(numeral(s).format('0,0.[0]'));
				}
				s = 0;

				e1 = $('#__mainfield[name="TOTAL5"]'); e2 = $('#__mainfield[name="TOTAL6"]'); e3 = $('#__mainfield[name="TOTAL7"]'); e4 = $('#__mainfield[name="TOTAL8"]');

				p.find('td :text[name="ERPUSD"]').each(function (idx, e) { s += numeral(e.value).value(); })
				e1.val(numeral(s).format(f)); s = 0;

				p.find('td :text[name="REALUSD"]').each(function (idx, e) { s += numeral(e.value).value(); })
				e2.val(numeral(s).format(f)); s = 0;

				e3.val(numeral(numeral(e2[0].value).value() - numeral(e1[0].value).value()).format('0,0.[0]'));
				if (numeral(e1[0].value) == 0) e4.val('0');
				else {
					s = _zw.ut.rate(parseFloat(_zw.ut.empty(e2.val())), parseFloat(_zw.ut.empty(e1.val())), 4);
					e4.val(numeral(s).format('0,0.[0]'));
				}
			}
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
							_zw.formEx.chart('', '', 0, 168, 0);
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
		},
		"chart": function (type, id, w, h, uY) {
			var cDiv = '\n', cDel = '\t';
			var s = 0, f = '0,0.[0000]';

			var e1 = $('#__mainfield[name="CORPORATION"]'); if ($.trim(e1.val()) == '') { e1.focus(); return false; }
			var e2 = $('#__mainfield[name="STATSYEAR"]'); if ($.trim(e2.val()) == '') { e2.focus(); return false; }
			var e3 = $('#__mainfield[name="STATSMONTH"]'); if ($.trim(e3.val()) == '') { e3.focus(); return false; }

			$('#__subtable1 td [name="DIFFERENTUSD"]').each(function (idx, e) {
				var c = $(this).parent().parent().find('[name="ITEMTYPE"]');
				if (c.length > 0 && (c.val() == '원자재' || c.val() == '반제품' || c.val() == '완제품' || c.val() == '외주')) s += numeral(e.value).value();
			});

			$.ajax({
				type: "POST",
				url: "/EA/Common",
				data: '{M:"getformchart",fi:"' + _zw.V.def.formid + '",ft:"' + _zw.V.def.maintable + '",ct:"' + type + '",w:"' + w + '",h:"' + h + '",uY:"' + uY + '",fk:"' + e1.val() + '-' + e2.val() + _zw.ut.zero(e3.val()) + '",v1:"' + numeral(s).format('0,0') + '"}',
				success: function (res) {
					if (res.substr(0, 2) == 'OK') {
						if (res.substr(2) != '') {
							var v = res.substr(2).split(cDel);
							$('#__fc_chart').parent().html(v[0]); $('#__fc_table').parent().html(v[1]);
						} else {
							var el1 = $('#__fc_chart')[0];
							for (var i = 0; i < el1.rows[0].cells.length; i++) {
								el1.rows[0].cells[i].innerHTML = '&nbsp;';
								if (i == 0) el1.rows[0].cells[i].style.height = '';
							}

							if (el1.rows.length > 2) {
								for (var i = 0; i < el1.rows[2].cells.length; i++) {
									//if (i == 0) el1.rows[2].cells[i].outerHTML = '<td class="axis-y" style="height: 50%">&nbsp;</td>';
									if (i == 0) { el1.rows[2].cells[i].innerHTML = '&nbsp;'; el1.rows[2].cells[i].style.height = '50%' }
									else if (i == 1) el1.rows[2].cells[i].innerHTML = '<div class="lbl">전년</div>';
									else if (i == 2) el1.rows[2].cells[i].innerHTML = '<div class="lbl">금년</div>';
									else el1.rows[2].cells[i].innerHTML = '<div class="lbl">' + (i - 2).toString() + '월</div>';
								}
							}

							for (var i = 1; i < el2.rows[1].cells.length; i++) el2.rows[1].cells[i].innerHTML = '';
                        }
					} else bootbox.alert(res);
				}
			});
		}
    }
});