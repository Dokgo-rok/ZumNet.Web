$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
            return true;
        },
        "make": function (f) {
        },
		"checkEvent": function (ckb, el, fld) {
			$('#__subtable2 td [name="WORSTITEM"]').val('');
			$('#__subtable2 td [name="WORSTITEMEXPENSES"]').val('');
			$('#__subtable2 td [name="WORSTITEMSHAARE"]').val('');
			$('#__subtable2 td [name="CAUSE"]').val('');
			$('#__subtable2 td [name="CONTENTS"]').val('');
			$('#__subtable2 td [name="EPPLANDATE"]').val('');

			if (el.checked) $('#panWORST').show();
			else $('#panWORST').hide();
        },
		"calc": function (el) {
			var e2, seq = 0, s = 0, s2 = 0;
			if (el.name.indexOf("EXPENSES") == 0 || el.name.indexOf("SALES") == 0) {
				e2 = $('#__mainfield[name="EXCHANGERATE"]'); if ($.trim(e2.val()) == '') return;

				el.value = numeral(_zw.ut.empty(el.value) / _zw.ut.empty(e2.val())).format('0,0');

				if (el.name.indexOf("EXPENSES") >= 0) {
					seq = el.name.replace("EXPENSES", "");

					$('#__subtable1 td :text[name="' + el.name + '"]').each(function (idx, e) {
						if (idx <= 5) s += numeral(e.value).value();
						else s2 += numeral(e.value).value();
					});

					$('#__mainfield[name="INEXPENSES' + seq + '"]').val(numeral(s).format('0,0'));
					$('#__mainfield[name="OUTEXPENSES' + seq + '"]').val(numeral(s2).format('0,0'));
					$('#__mainfield[name="FAULT' + seq + '"]').val(numeral(s + s2).format('0,0'));

				} else if (el.name.indexOf("SALES") >= 0) {
					seq = el.name.replace("SALES", "");
                }
				
				s = _zw.ut.rate($('#__mainfield[name="FAULT' + seq + '"]').val(), $('#__mainfield[name="SALES' + seq + '"]').val(), 2);
				$('#__mainfield[name="SHARE' + seq + '"]').val(numeral(s).format('0,0.[00]'))
            }
        },
        "autoCalc": function (p) {
		},
		"date": function (el) {
			if (el.name == 'EXCHANGEDATE') $('#__mainfield[name="EXCHANGERATE"]').val(numeral(_zw.formEx.exchangeRate()).format('0,0.[0000]'));
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
							if (vPos[1] == 'currency') $('#__mainfield[name="EXCHANGERATE"]').val(numeral(_zw.formEx.exchangeRate()).format('0,0.[0000]'));
							pop.find('.close[data-dismiss="modal"]').click();
						});

						pop.find('input:text.z-input-in').keyup(function (e) {
							if (e.which == 13) {
								$('#__mainfield[name="' + param[0] + '"]').val($(this).val());
								if (vPos[1] == 'currency') $('#__mainfield[name="EXCHANGERATE"]').val(numeral(_zw.formEx.exchangeRate()).format('0,0.[0000]'));
								pop.find('.close[data-dismiss="modal"]').click();
							}
						});

					} else bootbox.alert(res);
				}
			});
		},
		"event": function (x) {
			var e1 = $('#__mainfield[name="CORPORATION"]'); if ($.trim(e1.val()) == '') { e1.focus(); return false; }
			var e2 = $('#__mainfield[name="STATSYEAR"]'); if ($.trim(e2.val()) == '') { e2.focus(); return false; }
			var e3 = $('#__mainfield[name="STATSMONTH"]'); if ($.trim(e3.val()) == '') { e3.focus(); return false; }
			var e4 = $('#__mainfield[name="CURRENCY"]'); if ($.trim(e4.val()) == '') { e4.focus(); return false; }
			var e5 = $('#__mainfield[name="STDCURRENCY"]'); if ($.trim(e5.val()) == '') { e5.focus(); return false; }
			var e6 = $('#__mainfield[name="EXCHANGEDATE"]'); if ($.trim(e6.val()) == '') { e6.focus(); return false; }
			var e7 = $('#__mainfield[name="EXCHANGERATE"]'); if ($.trim(e7.val()) == '') { e7.focus(); return false; }

			$.ajax({
				type: "POST",
				url: "/EA/Common",
				async: false,
				data: '{M:"checkexternalkey",ft:"' + _zw.V.def.maintable + '",fk:"' + e1.val() + '-' + e2.val() + _zw.ut.zero(e3.val()) + '"}',
				success: function (res) {
					if (res.substr(0, 2) == 'OK') {
						if (res.substr(2) == "N") { bootbox.alert("해당 [" + e2.val() + _zw.ut.zero(e3.val()) + "]의 자료는 이미 작성되었습니다!"); return false; }

						$('#__subtable1 tr').each(function () {
							$(this).find('td input').each(function () {
								//console.log($(this).attr('name') + " : " + $(this).attr('id'))
								if ($(this).attr('name') == 'FAULTITEM') {

								} else if ($(this).attr('name').indexOf("EXPENSES") >= 0) {
									if ($(this).attr('name') == 'EXPENSES' + e3.val()) {
										$(this).removeClass('txtRead_Right').addClass('txtCurrency').prop('readonly', false).val(''); _zw.fn.input($(this)[0]);
									} else {
										$(this).removeClass('txtCurrency').addClass('txtRead_Right').prop('readonly', true).val('');
                                    }
								} else if ($(this).attr('name').indexOf("ckbWORSTFILE") >= 0) {
									if ($(this).attr('name') == 'ckbWORSTFILE' + e3.val()) {
										$(this).prop('disabled', false).prop('checked', false); _zw.form.checkYN('ckbWORSTFILE' + e3.val(), $(this)[0], 'WORSTFILE' + e3.val());
									} else {
										$(this).prop('disabled', true).prop('checked', false);
									}
								} else if ($(this).attr('id') == "__mainfield") {
									if ($(this).attr('name').indexOf("SALES") >= 0) {
										if ($(this).attr('name') == "SALES" + e3.val()) {
											$(this).removeClass('txtRead_Right').addClass('txtCurrency').prop('readonly', false).val(''); _zw.fn.input($(this)[0]);
										} else {
											$(this).removeClass('txtCurrency').addClass('txtRead_Right').prop('readonly', true).val('');
										}
									} else if ($(this).attr('name').indexOf("FAULT") >= 0 || $(this).attr('name').indexOf("SHARE") >= 0) {
										$(this).val('');
									}
								}
							});
						});

						$('#btnChart').prop('disabled', false);

					} else bootbox.alert(res);
				}, beforeSend: function () { }
			});
		},
		"exchangeRate": function () {
			var e1 = $('#__mainfield[name="CURRENCY"]'), e2 = $('#__mainfield[name="STDCURRENCY"]'), e3 = $('#__mainfield[name="EXCHANGEDATE"]'), e4 = $('#__mainfield[name="RATETYPE"]');
			var rt = '';
			if (e1.val() != '' && e2.val() != '' && e3.val() != '' && e4.val() != '') {
				if (e1.val() == e2.val()) {
					rt = '1';
				} else {
					$.ajax({
						type: "POST",
						url: "/EA/Common",
						async: false,
						data: '{M:"getoracleerp",body:"N", k1:"erp",k2:"exchangerate",k3:"detail",fc:"' + e1.val() + '",tc:"' + e2.val() + '",cd:"' + e3.val() + '",ct:"' + e4.val() + '"}',
						success: function (res) {
							if (res.substr(0, 2) == 'OK') {
								var v = res.substr(2).split(String.fromCharCode(8));
								if (v[0] == 'Y') rt = v[1];
								else bootbox.alert(v[0]);
							} else bootbox.alert(res);
						}, beforeSend: function () { }
					});
                }
			}
			return rt;
		},
		"chart": function (type, id, w, h, uY) {
			var cDiv = '\n', cDel = '\t';
			var s = 0, f = '0,0.[0000]';

			el = $('#__mainfield[name="CHATY"]');
			if ($.trim(el.val()) == '') { el.focus(); return false; }
			else { uY = el.val(); }

			var e1 = $('#__mainfield[name="CORPORATION"]'); if ($.trim(e1.val()) == '') { e1.focus(); return false; }
			var e2 = $('#__mainfield[name="STATSYEAR"]'); if ($.trim(e2.val()) == '') { e2.focus(); return false; }
			var e3 = $('#__mainfield[name="STATSMONTH"]'); if ($.trim(e3.val()) == '') { e3.focus(); return false; }

			var e4 = $('#__mainfield[name="SALES' + e3.val() + '"]'); if ($.trim(e4.val()) == '') { e4.focus(); return false; }
			var e5 = $('#__mainfield[name="FAULT' + e3.val() + '"]'); if ($.trim(e5.val()) == '') { e5.focus(); return false; }
			var e6 = $('#__mainfield[name="SHARE' + e3.val() + '"]'); if ($.trim(e6.val()) == '') { e6.focus(); return false; }
			var e7 = $('#__mainfield[name="INEXPENSES' + e3.val() + '"]'); if ($.trim(e7.val()) == '') { e7.focus(); return false; }
			var e8 = $('#__mainfield[name="OUTEXPENSES' + e3.val() + '"]'); if ($.trim(e8.val()) == '') { e8.focus(); return false; }

			//console.log('{M:"getformchart",fi:"' + _zw.V.def.formid + '",ft:"' + _zw.V.def.maintable + '",ct:"' + type + '",w:"' + w + '",h:"' + h + '",uY:"' + uY + '",fk:"' + e1.val() + '-' + e2.val() + _zw.ut.zero(e3.val()) + '",v1:"' + e4.val() + '",v2:"' + e5.val() + '",v3:"' + e6.val() + '",v4:"' + e7.val() + '",v5:"' + e8.val() + '"}')
		
			$.ajax({
				type: "POST",
				url: "/EA/Common",
				data: '{M:"getformchart",fi:"' + _zw.V.def.formid + '",ft:"' + _zw.V.def.maintable + '",ct:"' + type + '",w:"' + w + '",h:"' + h + '",uY:"' + uY + '",fk:"' + e1.val() + '-' + e2.val() + _zw.ut.zero(e3.val()) + '",v1:"' + e4.val() + '",v2:"' + e5.val() + '",v3:"' + e6.val() + '",v4:"' + e7.val() + '",v5:"' + e8.val() + '"}',
				success: function (res) {
					if (res.substr(0, 2) == 'OK') {
						var vData = res.split(cDel);
						eval(vData[vData.length - 1]);

						for (var i = 1; i < jsonString.length; i++) {
							var v = jsonString[i];
							var col = document.getElementsByName(v[0]);
							for (var j = 0; j < col.length; j++) { col[j].value = v[1][j].split(';')[1]; }
						}
						for (var i = 2; i < vData.length - 1; i++) {
							var v = vData[i].split(cDiv); //console.log(i + " : " + v[0] + " : " + v[1])
							$('#__mainfield[name="' + v[0] + '"]').val(v[1]);
						}

						$('#__subtable1 tr').each(function (idx, e) {
							var s = 0;
							$(this).find('td :text[name]').each(function (idx, e) {
								if ($(this).attr('name').indexOf('EXPENSES') >= 0 || $(this).attr('name').indexOf('INEXPENSES') >= 0 || $(this).attr('name').indexOf('OUTEXPENSES') >= 0
									|| $(this).attr('name').indexOf('FAULT') >= 0 || $(this).attr('name').indexOf('SALES') >= 0 || $(this).attr('name').indexOf('SHARE') >= 0) {
									s += numeral(e.value).value();
								}
							});
							$(this).find('td:last() :text[name]').val(numeral(s).format('0,0.[00]'));
						});
						s = 0;
						s = _zw.ut.rate($('#__mainfield[name="TOTALFAULT"]').val(), $('#__mainfield[name="TOTALSALES"]').val(), 2);
						$('#__mainfield[name="TOTALSHARE"]').val(numeral(s).format('0,0.[00]'))

						$('#panChart').html(vData[1]);

					} else bootbox.alert(res);
				}
			});
		}
    }
});