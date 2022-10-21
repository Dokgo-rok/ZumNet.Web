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
			var s = 0, f = '0,0.[0]', e1, e2, e3, e4;

			if (el.name == "REALCOST1" || el.name == "DEVCOSTS1" || el.name == "RELPRICE1") {
				e1 = $('#__mainfield[name="REALCOST1"]'); e2 = $('#__mainfield[name="DEVCOSTS1"]'); e3 = $('#__mainfield[name="RELPRICE1"]');

				if (e1.val() != '' && e2.val() != '') {
					s = _zw.ut.rate(_zw.ut.sub(4, e2.val(), e1.val()), e2.val(), 4);
					$('#__mainfield[name="BIDEVCOST1"]').val(numeral(s).format(f)); s = 0;
				}
				if (e1.val() != '' && e3.val() != '') {
					s = _zw.ut.rate(_zw.ut.sub(4, e3.val(), e1.val()), e3.val(), 4);
					$('#__mainfield[name="BIRELPRICE1"]').val(numeral(s).format(f)); s = 0;
				}
			} else if (el.name == "REALCOST2" || el.name == "DEVCOSTS2" || el.name == "RELPRICE2") {
				e1 = $('#__mainfield[name="REALCOST2"]'); e2 = $('#__mainfield[name="DEVCOSTS2"]'); e3 = $('#__mainfield[name="RELPRICE2"]');

				if (e1.val() != '' && e2.val() != '') {
					s = _zw.ut.rate(_zw.ut.sub(4, e2.val(), e1.val()), e2.val(), 4);
					$('#__mainfield[name="BIDEVCOST2"]').val(numeral(s).format(f)); s = 0;
				}
				if (e1.val() != '' && e3.val() != '') {
					s = _zw.ut.rate(_zw.ut.sub(4, e3.val(), e1.val()), e3.val(), 4);
					$('#__mainfield[name="BIRELPRICE2"]').val(numeral(s).format(f)); s = 0;
				}
			} else if (el.name == "REALCOST3" || el.name == "DEVCOSTS3" || el.name == "RELPRICE3") {
				e1 = $('#__mainfield[name="REALCOST3"]'); e2 = $('#__mainfield[name="DEVCOSTS3"]'); e3 = $('#__mainfield[name="RELPRICE3"]');

				if (e1.val() != '' && e2.val() != '') {
					s = _zw.ut.rate(_zw.ut.sub(4, e2.val(), e1.val()), e2.val(), 4);
					$('#__mainfield[name="BIDEVCOST3"]').val(numeral(s).format(f)); s = 0;
				}
				if (e1.val() != '' && e3.val() != '') {
					s = _zw.ut.rate(_zw.ut.sub(4, e3.val(), e1.val()), e3.val(), 4);
					$('#__mainfield[name="BIRELPRICE3"]').val(numeral(s).format(f)); s = 0;
				}
			} else if (el.name == "REALCOST4" || el.name == "DEVCOSTS4" || el.name == "RELPRICE4") {
				e1 = $('#__mainfield[name="REALCOST4"]'); e2 = $('#__mainfield[name="DEVCOSTS4"]'); e3 = $('#__mainfield[name="RELPRICE4"]');

				if (e1.val() != '' && e2.val() != '') {
					s = _zw.ut.rate(_zw.ut.sub(4, e2.val(), e1.val()), e2.val(), 4);
					$('#__mainfield[name="BIDEVCOST4"]').val(numeral(s).format(f)); s = 0;
				}
				if (e1.val() != '' && e3.val() != '') {
					s = _zw.ut.rate(_zw.ut.sub(4, e3.val(), e1.val()), e3.val(), 4);
					$('#__mainfield[name="BIRELPRICE4"]').val(numeral(s).format(f)); s = 0;
				}
			} else if (el.name.indexOf("REGISTCOUNT") >= 0 || el.name.indexOf("SOLVECOUNT") >= 0) {
				var i = el.name.substr(el.name.length - 1, el.name.length);
				e1 = $('#__mainfield[name="REGISTCOUNT' + i + '"]'); e2 = $('#__mainfield[name="SOLVECOUNT' + i + '"]');
				if (e1.val() != '' && e2.val() != '') {
					s = _zw.ut.rate(e2.val(), e1.val(), 4);
					$('#__mainfield[name="SOLVERATE' + i + '"]').val(numeral(s).format(f)); s = 0;
				}
			} else if (el.name.indexOf("PROCGOALRATE") >= 0 || el.name.indexOf("PROCDORATE") >= 0) {
				var i = el.name.substr(el.name.length - 1, el.name.length);
				e1 = $('#__mainfield[name="PROCGOALRATE' + i + '"]'); e2 = $('#__mainfield[name="PROCDORATE' + i + '"]');
				if (e1.val() != '' && e2.val() != '') {
					s = _zw.ut.rate(e2.val(), e1.val(), 4);
					$('#__mainfield[name="PROCRATE' + i + '"]').val(numeral(s).format(f)); s = 0;
				}
			} else if (el.name.indexOf("INVESTPRICE") >= 0 || el.name == "MOCKUPPRICE" || el.name == "QDMPRICE" || el.name == "USELESSPRICE"
				|| el.name == "ETCPRICE1" || el.name == "ETCPRICE2" || el.name == "TRIPPRICE" || el.name == "MANPRICE") {

				if (el.name == "TRIPPRICE" || el.name == "MANPRICE") {
					s = _zw.ut.add(4, $('#__mainfield[name="TRIPPRICE"]').val(), $('#__mainfield[name="MANPRICE"]').val());
					$('#__mainfield[name="SUMPRICE"]').val(numeral(s).format(f)); s = 0;
				}

				s = _zw.ut.add(4, $('#__mainfield[name="INVESTPRICE1"]').val(), $('#__mainfield[name="INVESTPRICE2"]').val(), $('#__mainfield[name="INVESTPRICE3"]').val()
					, $('#__mainfield[name="INVESTPRICE4"]').val(), $('#__mainfield[name="INVESTPRICE5"]').val(), $('#__mainfield[name="MOCKUPPRICE"]').val(), $('#__mainfield[name="QDMPRICE"]').val()
					, $('#__mainfield[name="USELESSPRICE"]').val(), $('#__mainfield[name="ETCPRICE1"]').val(), $('#__mainfield[name="ETCPRICE2"]').val(), $('#__mainfield[name="SUMPRICE"]').val());

				$('#__mainfield[name="TOTALPRICE"]').val(numeral(s).format(f));
			}
        },
        "autoCalc": function (p) {
		},
		"date": function (el) {
			var from, to;
			if (el.name == "DEVFROM" || el.name == "DEVTO") {
				from = $('#__mainfield[name="DEVFROM"]'); to = $('#__mainfield[name="DEVTO"]');
			}

			if (from && from.length > 0 && to && to.length > 0) { //console.log(from.val() + " : " + to.val())
				var dif = _zw.ut.diff('day', to.val(), from.val());
				if (dif && dif < 0) { bootbox.alert('날짜 범위 입력 오류!', function () { to.val(''); to.focus(); }); return false; }

				if (dif) { //alert(dif + " : " + (dif-1))
					var v = _zw.ut.diff('d', to.val(), from.val()); //console.log(v)
					$('#__mainfield[name="DEVYEAR"]').val(v[0]); $('#__mainfield[name="DEVMONTH"]').val(v[1]); $('#__mainfield[name="DEVDAY"]').val(v[2]);
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