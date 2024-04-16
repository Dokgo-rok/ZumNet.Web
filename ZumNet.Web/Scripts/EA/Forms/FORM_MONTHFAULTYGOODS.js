$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
			var el = null;
			if (_zw.V.biz == "의견") {
				el = $('#__mainfield[name="CONTENTS"]');
				if (el.length > 0 && $.trim(el.val()) == '') {
					bootbox.alert("필수항목 [기획조정실의견] 누락!", function () { el.focus(); }); return false;
				}
			}
			return true;
        },
        "make": function (f) {
        },
		"checkEvent": function (ckb, el, fld) {//console.log(fld + " : " + el.name)
			if (fld == "METHOD1" || fld == "METHOD2" || fld == "METHOD3" || fld == "METHOD4") {
				_zw.formEx.calcForm($(el).parent().parent().find('input[name="' + fld + '"]')[0]);
            }
        },
		"calc": function (el) {
			var s = 0;

			_zw.formEx.calcForm(el);

			if (el.name == "TOTAMOUNT" || el.name == "FLAWAMOUNT" || el.name == "FLAWRATE") {
				var row = $(el).parent().parent(), e2 = $('#__mainfield[name="TOTAMOUNT"]');
				if (e2.val() != '' && e2.val() != '0') {
					s = _zw.ut.rate($('#__mainfield[name="FLAWAMOUNT"]').val(), e2.val(), 4);
					$('#__mainfield[name="FLAWRATE"]').val(numeral(s).format('0,0.[0]'))
				} else {
					$('#__mainfield[name="FLAWRATE"]').val('');
                }
			}
        },
		"autoCalc": function (p) {
			_zw.formEx.calcForm();
		},
		"calcForm": function (el) {
			var p, row, e2, e3, e4, s = 0, s1 = 0, s2 = 0, f = '0,0.[0000]';
			if (el) {
				if (el.name == "COUNT13") {
					$('#__subtable1 td :text[name="COUNT13"]').each(function (idx, e) { s += numeral(e.value).value(); });
					$('#__mainfield[name="WRBCNT3"]').val(numeral(s).format('0,0')); s = 0;

				} else if (el.name == "COUNT23") {
					$('#__subtable2 td :text[name="COUNT23"]').each(function (idx, e) { s += numeral(e.value).value(); });
					$('#__mainfield[name="WARCNT3"]').val(numeral(s).format('0,0')); s = 0;

				} else if (el.name == "COUNT33") {
					$('#__subtable3 td :text[name="COUNT33"]').each(function (idx, e) { s += numeral(e.value).value(); });
					$('#__mainfield[name="WASCNT3"]').val(numeral(s).format('0,0')); s = 0;

				} else if (el.name == "COUNT43") {
					$('#__subtable4 td :text[name="COUNT43"]').each(function (idx, e) { s += numeral(e.value).value(); });
					$('#__mainfield[name="WAFCNT3"]').val(numeral(s).format('0,0')); s = 0;
				}

				if (el.name == "SUM12" || el.name == "METHOD1") {
					row = $(el).parent().parent();
					if (row.find('td :text[name="SUM12"]').val() != '') {
						$('#__subtable1 td :text[name="SUM12"]').each(function (idx, e) {
							if ($(this).parent().parent().find('td :hidden[name="METHOD1"]').val() == '폐기') s += numeral(e.value).value();
						});
						$('#__mainfield[name="WRBSUM2"]').val(numeral(s).format(f)); s = 0;
					}
				} else if (el.name == "SUM22" || el.name == "METHOD2") {
					row = $(el).parent().parent();
					if (row.find('td :text[name="SUM22"]').val() != '') {
						$('#__subtable2 td :text[name="SUM22"]').each(function (idx, e) {
							if ($(this).parent().parent().find('td :hidden[name="METHOD2"]').val() == '폐기') s += numeral(e.value).value();
						});
						$('#__mainfield[name="WARSUM2"]').val(numeral(s).format(f)); s = 0;
					}
				} else if (el.name == "SUM32" || el.name == "METHOD3") {
					row = $(el).parent().parent();
					if (row.find('td :text[name="SUM32"]').val() != '') {
						$('#__subtable3 td :text[name="SUM32"]').each(function (idx, e) {
							if ($(this).parent().parent().find('td :hidden[name="METHOD3"]').val() == '폐기') s += numeral(e.value).value();
						});
						$('#__mainfield[name="WASSUM2"]').val(numeral(s).format(f)); s = 0;
					}
				} else if (el.name == "SUM42" || el.name == "METHOD4") {
					row = $(el).parent().parent();
					if (row.find('td :text[name="SUM42"]').val() != '') {
						$('#__subtable4 td :text[name="SUM42"]').each(function (idx, e) {
							if ($(this).parent().parent().find('td :hidden[name="METHOD4"]').val() == '폐기') s += numeral(e.value).value();
						});
						$('#__mainfield[name="WAFSUM2"]').val(numeral(s).format(f)); s = 0;
					}
				} else if (el.name == "WRBGONGSU1" || el.name == "WRBGONGSU2" || el.name == "WRBGONGSU3") {//2015-03-05 추가
					e2 = $('#__mainfield[name="WRBGONGSURATE"]');
					$('#__mainfield[name="WRBGONGSUCOST1"]').val(numeral(parseFloat(_zw.ut.empty($('#__mainfield[name="WRBGONGSU1"]').val())) * parseFloat(_zw.ut.empty(e2.val()))).format('0,0'))
					$('#__mainfield[name="WRBGONGSUCOST2"]').val(numeral(parseFloat(_zw.ut.empty($('#__mainfield[name="WRBGONGSU2"]').val())) * parseFloat(_zw.ut.empty(e2.val()))).format('0,0'))
					$('#__mainfield[name="WRBGONGSUCOST3"]').val(numeral(parseFloat(_zw.ut.empty($('#__mainfield[name="WRBGONGSU3"]').val())) * parseFloat(_zw.ut.empty(e2.val()))).format('0,0'))

					s = _zw.ut.add(4, $('#__mainfield[name="WRBGONGSU1"]').val(), $('#__mainfield[name="WRBGONGSU2"]').val(), $('#__mainfield[name="WRBGONGSU3"]').val());
					$('#__mainfield[name="TOTLOSSGONGSU2"]').val(numeral(s).format('0,0'));

					s = _zw.ut.add(4, $('#__mainfield[name="WRBGONGSUCOST1"]').val(), $('#__mainfield[name="WRBGONGSUCOST2"]').val(), $('#__mainfield[name="WRBGONGSUCOST3"]').val());
					$('#__mainfield[name="TOTLOSSMONEY2"]').val(numeral(s).format('0,0'));
				}
				s = 0;
				if (el.name == "BUYSUM" || el.name == "WRBSUM1" || el.name == "WARSUM1" || el.name == "WASSUM1" || el.name == "WAFSUM1" || el.name == "TOTLOSSMONEY" || el.name == "WRBGONGSU1" || el.name == "WRBGONGSU2" || el.name == "WRBGONGSU3") {
					e2 = $('#__mainfield[name="BUYSUM"]');
					if (el.name == "WRBSUM0" || el.name == "SUM10" || el.name == "SUM11" || el.name == "WRBSUM1" || el.name == "TOTLOSSMONEY" || el.name == "WRBGONGSU1" || el.name == "WRBGONGSU2" || el.name == "WRBGONGSU3") {
						s = parseFloat(_zw.ut.empty($('#__mainfield[name="WRBSUM1"]').val()));
					}
					//if (e2.val() != '') $('#__mainfield[name="RATE1"]').val(numeral(s * parseFloat(_zw.ut.empty(e2.val()))).format('0,0.[00]'))
					if (e2.val() != '') $('#__mainfield[name="RATE1"]').val(numeral(_zw.ut.rate(s, parseFloat(_zw.ut.empty(e2.val())), 4)).format('0,0.[00]'));
					$('#__mainfield[name="OCCURSUMQ"]').val(numeral(s).format('0,0')); s = 0;
                }

			} else {
				$('#__subtable1 td :text[name="COUNT13"]').each(function (idx, e) { s += numeral(e.value).value(); });
				$('#__mainfield[name="WRBCNT3"]').val(numeral(s).format('0,0')); s = 0;

				$('#__subtable2 td :text[name="COUNT23"]').each(function (idx, e) { s += numeral(e.value).value(); });
				$('#__mainfield[name="WARCNT3"]').val(numeral(s).format('0,0')); s = 0;

				$('#__subtable3 td :text[name="COUNT33"]').each(function (idx, e) { s += numeral(e.value).value(); });
				$('#__mainfield[name="WASCNT3"]').val(numeral(s).format('0,0')); s = 0;

				$('#__subtable4 td :text[name="COUNT43"]').each(function (idx, e) { s += numeral(e.value).value(); });
				$('#__mainfield[name="WAFCNT3"]').val(numeral(s).format('0,0')); s = 0;

				$('#__subtable1 td :text[name="SUM12"]').each(function (idx, e) {
					if ($(this).parent().parent().find('td :hidden[name="METHOD1"]').val() == '폐기') s += numeral(e.value).value();
				});
				$('#__mainfield[name="WRBSUM2"]').val(numeral(s).format(f)); s = 0;

				$('#__subtable1 td :text[name="SUM22"]').each(function (idx, e) {
					if ($(this).parent().parent().find('td :hidden[name="METHOD2"]').val() == '폐기') s += numeral(e.value).value();
				});
				$('#__mainfield[name="WARSUM2"]').val(numeral(s).format(f)); s = 0;

				$('#__subtable1 td :text[name="SUM32"]').each(function (idx, e) {
					if ($(this).parent().parent().find('td :hidden[name="METHOD3"]').val() == '폐기') s += numeral(e.value).value();
				});
				$('#__mainfield[name="WASSUM2"]').val(numeral(s).format(f)); s = 0;

				$('#__subtable1 td :text[name="SUM42"]').each(function (idx, e) {
					if ($(this).parent().parent().find('td :hidden[name="METHOD4"]').val() == '폐기') s += numeral(e.value).value();
				});
				$('#__mainfield[name="WAFSUM2"]').val(numeral(s).format(f)); s = 0;

				e2 = $('#__mainfield[name="BUYSUM"]');
				s = parseFloat(_zw.ut.empty($('#__mainfield[name="WRBSUM1"]').val()));
				if (e2.val() != '') $('#__mainfield[name="RATE1"]').val(numeral(s * parseFloat(_zw.ut.empty(e2.val()))).format('0,0.[00]'))
				$('#__mainfield[name="OCCURSUMQ"]').val(numeral(s).format('0,0')); s = 0;
			}
			//console.log('여기')

			if (el && _zw.V.def.ver == '5') {
				if (el.name == 'WRBSUM1') _zw.formEx.chart('', '', 0, 176, 0);
				else if (el.name == 'BUYSUM') {
					//차트초기화
					$('#__mainfield[name="WRBSUM1"]').val(''); $('#__mainfield[name="OCCURSUMQ"]').val(''); _zw.formEx.chart('', '', 0, 176, 0);
				}
            }
		},
		"change": function (x, fld) {
			_zw.formEx.event(x);
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
						var row = vPos[1] == 'wastereason' ? el.parent().parent() : null;
						pop.find('a[data-val]').click(function () {
							var v = $(this).attr('data-val').split('^');
							for (var i = 0; i < param.length; i++) {
								if (row) row.find('td [name="' + param[i] + '"]').val(v[i]);
								else $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
							}
							
							pop.find('.close[data-dismiss="modal"]').click();
							if (vPos[1] == 'groupcode') {
								_zw.formEx.event($('#__mainfield[name="' + param[0] + '"]')[0]);
								//_zw.formEx.chart('', '', 0, 176, 0);
							}
						});

						pop.find('input:text.z-input-in').keyup(function (e) {
							if (e.which == 13) {
								if (row) row.find('td [name="' + param[0] + '"]').val($(this).val());
								else $('#__mainfield[name="' + param[0] + '"]').val($(this).val());
								pop.find('.close[data-dismiss="modal"]').click();
							}
						});

					} else bootbox.alert(res);
				}
			});
		},
		"event": function (x) {
			var e1, e2, e3, e4, e5, col;
			if (x && (x.name == "CORPORATION" || x.name == "STATSYEAR" || x.name == "STATSMONTH")) {
				e1 = $('#__mainfield[name="STATSYEAR"]'); e2 = $('#__mainfield[name="STATSMONTH"]'); e3 = $('#__mainfield[name="CORPORATION"]');
				e4 = $('#__mainfield[name="COERPID"]'); e5 = $('#__mainfield[name="COERPSUBID"]');

				if (e1.val() == '' || e2.val() == '' || e3.val() == '') return false;

				col = "BUYSUM;OCCURSUMQ;RATE1;WRBGONGSU1;WRBGONGSU2;WRBGONGSU3;WRBGONGSUCOST1;WRBGONGSUCOST2;WRBGONGSUCOST3;TOTLOSSGONGSU2;TOTLOSSMONEY2".split(';');
				for (var i = 0; i < col.length; i++) { p = $('#__mainfield[name="' + col[i] + '"]'); p.val(''); if (i == 0) { _zw.formEx.calcForm(p[0]); } }
				col = null;

				//표부분 초기화
				$('#__subtable1 tr.sub_table_row').each(function () { _zw.form.resetField($(this)); });
				$('#__subtable2 tr.sub_table_row').each(function () { _zw.form.resetField($(this)); });
				$('#__subtable3 tr.sub_table_row').each(function () { _zw.form.resetField($(this)); });
				$('#__subtable4 tr.sub_table_row').each(function () { _zw.form.resetField($(this)); });

				//console.log('COERPID : ' + e4.val())
				if (e4.val() != '') {
					$.ajax({
						type: "POST",
						url: "/EA/Common",
						data: '{M:"getoracleerp",body:"N", k1:"erp",k2:"monfaulty",k3:"detail",fc:"' + e1.val() + '",tc:"' + e2.val() + '",ct:"' + e4.val() + '",cd:"' + e5.val() + '"}',
						async: false,
						success: function (res) {//console.log(res)
							if (res.substr(0, 2) == 'OK') {
								var cDel = String.fromCharCode(8), iPos = 0;
								res = res.substr(2); iPos = res.indexOf(cDel);
								if (res.substr(0, iPos) == 'Y') col = res.substr(iPos + 1).split(';');
								else bootbox.alert(res.substr(iPos + 1));

							} else bootbox.alert(res);
						}
					});
				}

				if (col && e3.val() != 'KH' && e3.val() != 'IS' && e3.val() != 'CL') { //2015-03-05 IS,CL 경우 제외
					$('#__mainfield[name="WRBCNT1"]').val(numeral(parseFloat(_zw.ut.empty(col[0]))).format('0,0')).prop('readonly', true).removeClass('txtDollar').addClass('txtRead_Right');
					$('#__mainfield[name="WRBCNT2"]').val(numeral(parseFloat(_zw.ut.empty(col[1]))).format('0,0')).prop('readonly', true).removeClass('txtDollar').addClass('txtRead_Right');

					if (col[0] == '') {
						$('#__subtable1 tr.sub_table_row').each(function () { _zw.form.resetField($(this)); });
						$('#__mainfield[name="WRBSUM1"]').prop('readonly', true).removeClass('txtDollar').addClass('txtRead_Right');
					} else {
						$('#__mainfield[name="WRBSUM1"]').prop('readonly', false).removeClass('txtRead_Right').addClass('txtDollar');
						//console.log($('#__mainfield[name = "WRBSUM1"]')[0])
						_zw.fn.input($('#__mainfield[name="WRBSUM1"]')[0]);
					}

					$('#__mainfield[name="WARCNT1"]').val(numeral(parseFloat(_zw.ut.empty(col[2]))).format('0,0')).prop('readonly', true).removeClass('txtDollar').addClass('txtRead_Right');
					$('#__mainfield[name="WARCNT2"]').val(numeral(parseFloat(_zw.ut.empty(col[3]))).format('0,0')).prop('readonly', true).removeClass('txtDollar').addClass('txtRead_Right');

					if (col[0] == '') {
						$('#__subtable2 tr.sub_table_row').each(function () { _zw.form.resetField($(this)); });
						$('#__mainfield[name="WARSUM1"]').prop('readonly', true).removeClass('txtDollar').addClass('txtRead_Right');
					} else {
						$('#__mainfield[name="WARSUM1"]').prop('readonly', false).removeClass('txtRead_Right').addClass('txtDollar');
						_zw.fn.input($('#__mainfield[name="WARSUM1"]')[0]);
					}

					$('#__mainfield[name="WASCNT1"]').val(numeral(parseFloat(_zw.ut.empty(col[2]))).format('0,0')).prop('readonly', true).removeClass('txtDollar').addClass('txtRead_Right');
					$('#__mainfield[name="WASCNT2"]').val(numeral(parseFloat(_zw.ut.empty(col[3]))).format('0,0')).prop('readonly', true).removeClass('txtDollar').addClass('txtRead_Right');

					if (col[0] == '') {
						$('#__subtable3 tr.sub_table_row').each(function () { _zw.form.resetField($(this)); });
						$('#__mainfield[name="WASSUM1"]').prop('readonly', true).removeClass('txtDollar').addClass('txtRead_Right');
					} else {
						$('#__mainfield[name="WASSUM1"]').prop('readonly', false).removeClass('txtRead_Right').addClass('txtDollar');
						_zw.fn.input($('#__mainfield[name="WASSUM1"]')[0]);
					}

					$('#__mainfield[name="WAFCNT1"]').val(numeral(parseFloat(_zw.ut.empty(col[2]))).format('0,0')).prop('readonly', true).removeClass('txtDollar').addClass('txtRead_Right');
					$('#__mainfield[name="WAFCNT2"]').val(numeral(parseFloat(_zw.ut.empty(col[3]))).format('0,0')).prop('readonly', true).removeClass('txtDollar').addClass('txtRead_Right');

					if (col[0] == '') {
						$('#__subtable4 tr.sub_table_row').each(function () { _zw.form.resetField($(this)); });
						$('#__mainfield[name="WAFSUM1"]').prop('readonly', true).removeClass('txtDollar').addClass('txtRead_Right');
					} else {
						$('#__mainfield[name="WAFSUM1"]').prop('readonly', false).removeClass('txtRead_Right').addClass('txtDollar');
						_zw.fn.input($('#__mainfield[name="WAFSUM1"]')[0]);
					}

				} else {
					e5 = $('#__mainfield[name="WRBCNT1"]'); e5.prop('readonly', false).removeClass('txtRead_Right').addClass('txtDollar'); _zw.fn.input(e5[0]);
					e5 = $('#__mainfield[name="WRBCNT2"]'); e5.prop('readonly', false).removeClass('txtRead_Right').addClass('txtDollar'); _zw.fn.input(e5[0]);
					e5 = $('#__mainfield[name="WRBSUM1"]'); e5.prop('readonly', false).removeClass('txtRead_Right').addClass('txtDollar'); _zw.fn.input(e5[0]);
					e5 = $('#__mainfield[name="WARCNT1"]'); e5.prop('readonly', false).removeClass('txtRead_Right').addClass('txtDollar'); _zw.fn.input(e5[0]);
					e5 = $('#__mainfield[name="WARCNT2"]'); e5.prop('readonly', false).removeClass('txtRead_Right').addClass('txtDollar'); _zw.fn.input(e5[0]);
					e5 = $('#__mainfield[name="WARSUM1"]'); e5.prop('readonly', false).removeClass('txtRead_Right').addClass('txtDollar'); _zw.fn.input(e5[0]);
					e5 = $('#__mainfield[name="WASCNT1"]'); e5.prop('readonly', false).removeClass('txtRead_Right').addClass('txtDollar'); _zw.fn.input(e5[0]);
					e5 = $('#__mainfield[name="WASCNT2"]'); e5.prop('readonly', false).removeClass('txtRead_Right').addClass('txtDollar'); _zw.fn.input(e5[0]);
					e5 = $('#__mainfield[name="WASSUM1"]'); e5.prop('readonly', false).removeClass('txtRead_Right').addClass('txtDollar'); _zw.fn.input(e5[0]);
					e5 = $('#__mainfield[name="WAFCNT1"]'); e5.prop('readonly', false).removeClass('txtRead_Right').addClass('txtDollar'); _zw.fn.input(e5[0]);
					e5 = $('#__mainfield[name="WAFCNT2"]'); e5.prop('readonly', false).removeClass('txtRead_Right').addClass('txtDollar'); _zw.fn.input(e5[0]);
					e5 = $('#__mainfield[name="WAFSUM1"]'); e5.prop('readonly', false).removeClass('txtRead_Right').addClass('txtDollar'); _zw.fn.input(e5[0]);
				}

				if (e3.val() == 'KH' || e3.val() == 'IS' || e3.val() == 'CL') {
					e5 = $('#__mainfield[name="WRBGONGSU1"]'); e5.prop('readonly', false).removeClass('txtRead_Right').addClass('txtDollar'); _zw.fn.input(e5[0]);
				} else {
					e5 = $('#__mainfield[name="WRBGONGSU1"]'); e5.prop('readonly', true).removeClass('txtDollar').addClass('txtRead_Right');
				}

				if (col && col[8]) {
					s = parseFloat(_zw.ut.empty(col[8]));
					$('#__mainfield[name="WRBGONGSU1"]').val(numeral(s).format('0,0')); s = 0;
					s = parseFloat(_zw.ut.empty(col[8])) * parseFloat(_zw.ut.empty($('#__mainfield[name="WRBGONGSURATE"]').val()));;
					$('#__mainfield[name="WRBGONGSUCOST1"]').val(numeral(s).format('0,0')); s = 0;

					s = _zw.ut.add(4, $('#__mainfield[name="WRBGONGSU1"]').val(), $('#__mainfield[name="WRBGONGSU2"]').val(), $('#__mainfield[name="WRBGONGSU3"]').val());
					$('#__mainfield[name="TOTLOSSGONGSU2"]').val(numeral(s).format('0,0'));

					s = _zw.ut.add(4, $('#__mainfield[name="WRBGONGSUCOST1"]').val(), $('#__mainfield[name="WRBGONGSUCOST2"]').val(), $('#__mainfield[name="WRBGONGSUCOST3"]').val());
					$('#__mainfield[name="TOTLOSSMONEY2"]').val(numeral(s).format('0,0'));
				}
			}
		},
		"chart": function (type, id, w, h, uY) {//console.log('------')
			var cDiv = '\n', cDel = '\t';
			var s = 0, f = '0,0.[0000]';

			var e1 = $('#__mainfield[name="CORPORATION"]'); if ($.trim(e1.val()) == '') { e1.focus(); return false; }
			var e2 = $('#__mainfield[name="STATSYEAR"]'); if ($.trim(e2.val()) == '') { e2.focus(); return false; }
			var e3 = $('#__mainfield[name="STATSMONTH"]'); if ($.trim(e3.val()) == '') { e3.focus(); return false; }

			$.ajax({
				type: "POST",
				url: "/EA/Common",
				data: '{M:"getformchart",fi:"' + _zw.V.def.formid + '",ft:"' + _zw.V.def.maintable + '",ct:"' + type + '",w:"' + w + '",h:"' + h + '",uY:"' + uY + '",fk:"' + e1.val() + '-' + e2.val() + _zw.ut.zero(e3.val()) + '",v1:"' + $('#__mainfield[name="OCCURSUMQ"]').val() + '"}',
				success: function (res) {
					if (res.substr(0, 2) == 'OK') {
						el1 = $('#__fc_chart')[0]; el2 = $('#__fc_table')[0];

						for (var i = 0; i < el1.rows[0].cells.length; i++) el1.rows[0].cells[i].innerHTML = '';
						for (var i = 1; i < el2.rows[1].cells.length; i++) el2.rows[1].cells[i].innerHTML = '&nbsp;';

						if (res.substr(2) != '') {
							var vData = res.substr(2).split('^');

							for (var i = 0; i < vData.length; i++) {
								t = vData[i].split(';');

								if (t[0] != '' && t[0] != '0') {
									if (i == 0) {
										el1.rows[0].cells[i].innerHTML = '<div class="plus" style="bottom: ' + (parseInt(t[0].split('/')[1]) - 8) + 'px">' + t[0].split('/')[0] + '</div>'
											+ '<div class="plus" style="bottom: ' + (parseInt(t[1].split('/')[1]) - 8) + 'px">' + t[1].split('/')[0] + '</div>'
											+ '<div class="plus" style="bottom: ' + (parseInt(t[2].split('/')[1]) - 8) + 'px">' + t[2].split('/')[0] + '</div>'
											+ '<div class="plus" style="bottom: ' + (parseInt(t[3].split('/')[1]) - 8) + 'px">' + t[3].split('/')[0] + '</div>'
											+ '<div class="zero" style="bottom: 0">0</div>';
									} else if (i == 1) {
										el1.rows[0].cells[i].innerHTML = '<div class="bar prev" style="height: ' + t[1] + 'px"></div><div class="lbl-value" style="bottom: ' + (parseInt(t[1]) + 4) + 'px">' + t[0] + '</div>';
									} else if (i == 2) {
										el1.rows[0].cells[i].innerHTML = '<div class="bar now" style="height: ' + t[1] + 'px"></div><div class="lbl-value" style="bottom: ' + (parseInt(t[1]) + 4) + 'px">' + t[0] + '</div>';
									} else {
										el1.rows[0].cells[i].innerHTML = '<div class="bar" style="height: ' + t[1] + 'px"></div><div class="lbl-value" style="bottom: ' + (parseInt(t[1]) + 4) + 'px">' + t[0] + '</div>';
									}
								}
								if (i > 0) el2.rows[1].cells[i].innerHTML = (t[0] != '' && t[0] != '0') ? t[0] : '&nbsp;';
							}
						}
					} else bootbox.alert(res);
				}
			});
		}
    }
});