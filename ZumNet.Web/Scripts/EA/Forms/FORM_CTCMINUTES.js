$(function () {
    _zw.formEx = {
		"validation": function (cmd) {
			var el = null;
			if (cmd == "draft") { //기안
			} else {
				if (_zw.V.biz == "normal" && _zw.V.act == "_approver") {
					el = $('#__mainfield[name="MDCN1"]');
					if (el && $.trim(el.val()) == '') { bootbox.alert('이관승인 결정을 하십시오!', function () { el.focus(); }); return false; }

					el = $('#__mainfield[name="MOPN1"]');
					if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [이관승인의견] 누락!', function () { el.focus(); }); return false; }

				} else if (_zw.V.biz == "last" && _zw.V.act == "_approver") {
					el = $('#__mainfield[name="MDCN2"]');
					if (el && $.trim(el.val()) == '') { bootbox.alert('최종승인 결정을 하십시오!', function () { el.focus(); }); return false; }

					el = $('#__mainfield[name="MOPN2"]');
					if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [최종의견] 누락!', function () { el.focus(); }); return false; }

				} else if (_zw.V.biz == "receive" && _zw.V.act == "_approver") {
					var row = null;
					$('#__subtable10 tr.sub_table_row').each(function (idx) {
						var c = $(this).find('input[name="PTDPID"]');
						if (c.length > 0 && c.val() == _zw.V.current.deptid) { row = $(this); return false; }
					});

					if (row && row.length > 0) {
						var idx = 0;
						row.find('input[name="S5DCN1"], input[name="S5DCN2"]').each(function () {
							if ($(this).val() != '') idx++;
						});
						if (idx == 0) { bootbox.alert('부서 검증결과를 선택하십시오!', function () { }); return false; }
						idx = 0;

						row.find('textarea[name="S5OPN1"], textarea[name="S5OPN2"]').each(function () {
							if ($(this).val() != '') idx++;
						});
						if (idx == 0) { bootbox.alert('부서 검증의견을 입력하십시오!', function () { }); return false; }
                    }
				}
            }
            return true;
        },
		"make": function (f) {
			if (_zw.V.biz == "normal" && _zw.V.act == "_approver") _zw.body.main(f, ["MDCN1", "MOPN1"]);
			else if (_zw.V.biz == "receive") _zw.body.subPart(f, "5;S5DCN1;S5DCN2;S5OPN1;S5OPN2;FILEKIND;FILEA");
        },
        "checkEvent": function (ckb, el, fld) {
        },
		"calc": function (el) {
			var e1, e2, e3, e4, row;
			var s = 0, f = '0,0.[0000]';

			if (el.name == "S2CNT1" || el.name == "S2CNT3" || el.name == "S2CNT4") {//투입 대비 불량(동작+외관)
				var c = $(el).parent(), iSeq = 0;

				c.parent().find('> td:not(.f-lbl-sub)').each(function (idx) {
					if ($(this).prop('cellIndex') == c.prop('cellIndex')) { iSeq = idx; return false; }
				});

				$('#__subtable2 tr.sub_table_row').each(function (idx) {
					$(this).find('> td:not(.f-lbl-sub)').eq(iSeq).find('[name]').each(function () {
						if ($(this).attr('name') == 'S2CNT1') e1 = $(this);
						else if ($(this).attr('name') == 'S2CNT3') e2 = $(this);
						else if ($(this).attr('name') == 'S2CNT4') e3 = $(this);
						else if ($(this).attr('name') == 'S2RATE1') e4 = $(this);
					});
				});

				if (e1 && e1.val() != '' && e1.val() != '0') {
					s = _zw.ut.rate(parseFloat(_zw.ut.empty(e2.val())) + parseFloat(_zw.ut.empty(e3.val())), parseFloat(_zw.ut.empty(e1.val())), 4);
					e4.val(numeral(s).format(f));
				}

			} else if (el.name == "EPCNT1" || el.name == "EPCNT2") {
				row = $(el).parent().parent();
				e1 = row.find('> td:not(.f-lbl-sub) [name="EPCNT1"]'); e2 = row.find('> td:not(.f-lbl-sub) [name="EPCNT2"]'); e3 = row.find('> td:not(.f-lbl-sub) [name="EPRATE"]');
				if (e1 && e1.val() != '' && e1.val() != '0') {
					s = _zw.ut.rate(e2.val(), e1.val(), 4); e3.val(numeral(s).format(f));
				}
				s = 0;

				row.parent().parent().find('td :text[name="' + el.name + '"]').each(function (idx, e) { s += numeral(e.value).value(); })
				if (el.name == "EPCNT1") $('#__mainfield[name="EPSUM1"]').val(numeral(s).format(f));
				else if (el.name == "EPCNT2") $('#__mainfield[name="EPSUM2"]').val(numeral(s).format(f));

				if ($('#__mainfield[name="EPSUM1"]').val() != '') {
					if ($('#__mainfield[name="EPSUM1"]').val() == '0') s = 0;
					else s = _zw.ut.rate($('#__mainfield[name="EPSUM2"]').val(), $('#__mainfield[name="EPSUM1"]').val(), 4);
					$('#__mainfield[name="EPTOTRATE"]').val(numeral(s).format(f));
				}

			} else if (el.name == "PPCNT1" || el.name == "PPCNT2") {
				row = $(el).parent().parent();
				e1 = row.find('> td:not(.f-lbl-sub) [name="PPCNT1"]'); e2 = row.find('> td:not(.f-lbl-sub) [name="PPCNT2"]'); e3 = row.find('> td:not(.f-lbl-sub) [name="PPRATE"]');
				if (e1 && e1.val() != '' && e1.val() != '0') {
					s = _zw.ut.rate(e2.val(), e1.val(), 4); e3.val(numeral(s).format(f));
				}
				s = 0;

				row.parent().parent().find('td :text[name="' + el.name + '"]').each(function (idx, e) { s += numeral(e.value).value(); })
				if (el.name == "PPCNT1") $('#__mainfield[name="PPSUM1"]').val(numeral(s).format(f));
				else if (el.name == "PPCNT2") $('#__mainfield[name="PPSUM2"]').val(numeral(s).format(f));

				if ($('#__mainfield[name="PPSUM1"]').val() != '') {
					if ($('#__mainfield[name="PPSUM1"]').val() == '0') s = 0;
					else s = _zw.ut.rate($('#__mainfield[name="PPSUM2"]').val(), $('#__mainfield[name="PPSUM1"]').val(), 4);
					$('#__mainfield[name="PPTOTRATE"]').val(numeral(s).format(f));
				}

			} else if (el.name == "PMPCNT1" || el.name == "PMPCNT2") {
				row = $(el).parent().parent();
				e1 = row.find('> td:not(.f-lbl-sub) [name="PMPCNT1"]'); e2 = row.find('> td:not(.f-lbl-sub) [name="PMPCNT2"]'); e3 = row.find('> td:not(.f-lbl-sub) [name="PMPRATE"]');
				if (e1 && e1.val() != '' && e1.val() != '0') {
					s = _zw.ut.rate(e2.val(), e1.val(), 4); e3.val(numeral(s).format(f));
				}
				s = 0;

				row.parent().parent().find('td :text[name="' + el.name + '"]').each(function (idx, e) { s += numeral(e.value).value(); })
				if (el.name == "PMPCNT1") $('#__mainfield[name="PMPSUM1"]').val(numeral(s).format(f));
				else if (el.name == "PMPCNT2") $('#__mainfield[name="PMPSUM2"]').val(numeral(s).format(f));

				if ($('#__mainfield[name="PMPSUM1"]').val() != '') {
					if ($('#__mainfield[name="PMPSUM1"]').val() == '0') s = 0;
					else s = _zw.ut.rate($('#__mainfield[name="PMPSUM2"]').val(), $('#__mainfield[name="PMPSUM1"]').val(), 4);
					$('#__mainfield[name="PMPTOTRATE"]').val(numeral(s).format(f));
				}

			} else if (el.name == "S4CNT1" || el.name == "S4CNT2") {//측정건수, 불량건수
				$(el).parent().parent().parent().parent().find('td :text[name="' + el.name + '"]').each(function (idx, e) { s += numeral(e.value).value(); })
				if (el.name == "S4CNT1") $('#__mainfield[name="MSUM1"]').val(numeral(s).format(f));
				else if (el.name == "S4CNT2") $('#__mainfield[name="MSUM2"]').val(numeral(s).format(f));
			}
        },
		"autoCalc": function (p) {
			var s = 0, f = '0,0.[0000]';

			if (p.attr('id') == '__subtable3') {
				p.find('td :text[name="EPCNT1"]').each(function (idx, e) { s += numeral(e.value).value(); })
				$('#__mainfield[name="EPSUM1"]').val(numeral(s).format(f)); s = 0;

				p.find('td :text[name="EPCNT2"]').each(function (idx, e) { s += numeral(e.value).value(); })
				$('#__mainfield[name="EPSUM2"]').val(numeral(s).format(f)); s = 0;

				if ($('#__mainfield[name="EPSUM1"]').val() != '') {
					if ($('#__mainfield[name="EPSUM1"]').val() == '0') s = 0;
					else s = _zw.ut.rate($('#__mainfield[name="EPSUM2"]').val(), $('#__mainfield[name="EPSUM1"]').val(), 4);
					$('#__mainfield[name="EPTOTRATE"]').val(numeral(s).format(f));
				}
				s = 0;

				p.find('td :text[name="PPCNT1"]').each(function (idx, e) { s += numeral(e.value).value(); })
				$('#__mainfield[name="PPSUM1"]').val(numeral(s).format(f)); s = 0;

				p.find('td :text[name="PPCNT2"]').each(function (idx, e) { s += numeral(e.value).value(); })
				$('#__mainfield[name="PPSUM2"]').val(numeral(s).format(f)); s = 0;

				if ($('#__mainfield[name="PPSUM1"]').val() != '') {
					if ($('#__mainfield[name="PPSUM1"]').val() == '0') s = 0;
					else s = _zw.ut.rate($('#__mainfield[name="PPSUM2"]').val(), $('#__mainfield[name="PPSUM1"]').val(), 4);
					$('#__mainfield[name="PPTOTRATE"]').val(numeral(s).format(f));
				}
				s = 0;

				p.find('td :text[name="PMPCNT1"]').each(function (idx, e) { s += numeral(e.value).value(); })
				$('#__mainfield[name="PMPSUM1"]').val(numeral(s).format(f)); s = 0;

				p.find('td :text[name="PMPCNT2"]').each(function (idx, e) { s += numeral(e.value).value(); })
				$('#__mainfield[name="PMPSUM2"]').val(numeral(s).format(f)); s = 0;

				if ($('#__mainfield[name="PMPSUM1"]').val() != '') {
					if ($('#__mainfield[name="PMPSUM1"]').val() == '0') s = 0;
					else s = _zw.ut.rate($('#__mainfield[name="PMPSUM2"]').val(), $('#__mainfield[name="PMPSUM1"]').val(), 4);
					$('#__mainfield[name="PMPTOTRATE"]').val(numeral(s).format(f));
				}

			} else if (p.attr('id') == '__subtable4') {
				p.find('td :text[name="S4CNT1"]').each(function (idx, e) { s += numeral(e.value).value(); })
				$('#__mainfield[name="MSUM1"]').val(numeral(s).format(f)); s = 0;

				p.find('td :text[name="S4CNT2"]').each(function (idx, e) { s += numeral(e.value).value(); })
				$('#__mainfield[name="MSUM2"]').val(numeral(s).format(f));
			}
		},
		"date": function (el) {
			var e1, e2, e3;
			if (el.name == "S2DT1" || el.name == "S2DT2") {//일정계획, 일정실적, 일정차이
				var c = $(el).parent(), iSeq = 0;

				c.parent().find('> td:not(.f-lbl-sub)').each(function (idx) {
					if ($(this).prop('cellIndex') == c.prop('cellIndex')) { iSeq = idx; return false; }
				});

				$('#__subtable2 tr.sub_table_row').each(function (idx) {
					$(this).find('> td:not(.f-lbl-sub)').eq(iSeq).find('[name]').each(function () {
						if ($(this).attr('name') == 'S2DT1') e1 = $(this);
						else if ($(this).attr('name') == 'S2DT2') e2 = $(this);
						else if ($(this).attr('name') == 'S2DIFF') e3 = $(this);
					});
				});
			}
			if (e1 && e1.val() != '' && e2 && e2.val() != '') {
				var dif = _zw.ut.diff('day', e2.val(), e1.val()); e3.val(numeral(dif).format('0,0'));
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
		"externalWnd": function (pos, w, h, m, n, etc, x) {
			var el = _zw.ut.eventBtn(), vPos = pos.split('.'); //console.log(arguments)
			var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]); //console.log(param);
			var m = '', v1 = '', v2 = '', v3 = '';
			if (vPos[0] == 'erp') m = 'getoracleerp';
			else if (vPos[0] == 'report') m = 'getreportsearch';
			else m = 'getcodedescription';

			var s = '<div class="zf-modal modal-dialog modal-dialog-centered modal-dialog-scrollable">'
				+ '<div class="modal-content" data-for="' + vPos[1] + '" style="box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.5)">'
				+ '<div class="modal-header">'
				+ '<div class="d-flex align-items-center w-100">'
				+ '<div class="input-group w-50">'
				+ '<input type="text" class="form-control" placeholder="' + (el.attr('title') != '' ? el.attr('title') + ' ' : '') + '검색" value="">'
				+ '<span class="input-group-append"><button class="btn btn-secondary" type="button"><i class="fe-search"></i></button></span>'
				+ '</div>' //input-group
				+ '<div class="ml-2 d-flex align-items-center zf-modal-page"></div>'
				+ '</div>' //d-flex
				+ '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>'
				+ '<input type="hidden" data-for="page" value="1" /><input type="hidden" data-for="page-count" value="50" />'
				+ '</div>' //modal-header
				+ '<div class="modal-body"></div>'
				+ '</div></div>';

			var p = $('#popBlank'); p.html(s);
			var searchBtn = p.find('.zf-modal .modal-header .input-group .btn');
			var searchTxt = $('.zf-modal .modal-header .input-group :text');

			p.find(".modal-dialog").css("max-width", "30rem").find(".modal-content").css("min-height", "20rem");

			searchTxt.keyup(function (e) { if (e.which == 13) { searchBtn.click(); } });
			searchBtn.click(function () {
				if ($.trim(searchTxt.val()) == '' || searchTxt.val().length < 1) { bootbox.alert('검색어를 입력하십시오!', function () { searchTxt.focus(); }); return false; }
				var exp = "['\\%^&\"*]", reg = new RegExp(exp, 'gi');
				if (searchTxt.val().search(reg) >= 0) { bootbox.alert(exp + ' 문자는 사용될 수 없습니다!', function () { searchTxt.focus(); }); return false; }

				$.ajax({
					type: "POST",
					url: "/EA/Common",
					data: '{M:"' + m + '",body:"N", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",search:"' + searchTxt.val() + '",searchcol:"",page:"' + p.find('.modal-header :hidden[data-for="page"]').val() + '",count:"' + p.find('.modal-header :hidden[data-for="page-count"]').val() + '",v1:"' + v1 + '"}',
					success: function (res) {
						//res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
						if (res.substr(0, 2) == 'OK') {
							var cDel = String.fromCharCode(8);
							if (res.substr(2).indexOf(cDel) != -1) {
								var vRes = res.substr(2).split(cDel);
								p.find('.modal-header .zf-modal-page').html(vRes[0]);
								p.find('.modal-body').html(vRes[1]);
							} else {
								p.find('.modal-body').html(res.substr(2));
							}

							p.find('.zf-modal .z-lnk-navy[data-val]').click(function () {
								var v = $(this).attr('data-val').split('^');
								for (var i = 0; i < param.length; i++) {
									$('#__mainfield[name="' + param[i] + '"]').val(v[i]);
								}
								p.modal('hide');
							});

							p.find('.zf-modal-page .btn[data-for]').click(function () {
								p.find('.modal-header :hidden[data-for="page"]').val($(this).attr('data-for'));
								searchBtn.click();
							});

						} else bootbox.alert(res);
					}
				});
			});

			p.on('shown.bs.modal', function () {
				if (pos == "erp.exchangerate") searchTxt.datepicker({ autoclose: true, language: $('#current_culture').val() });
				else searchTxt.focus();
			});
			p.on('hidden.bs.modal', function () { p.html(''); });
			p.modal();
		}
    }
});