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
			var m = '', v1 = '', v2 = '', v3 = '';
			if (vPos[0] == 'erp') m = 'getoracleerp';
			else if (vPos[0] == 'report') m = 'getreportsearch';
			else m = 'getcodedescription';

			//data body 조건 : N(modal-body 없음), F(footer 포함)
			var sBody = 'N';
			if (vPos[1] == 'SEARCH_TOOLING') { sBody = ''; v1 = x; }

			$.ajax({
				type: "POST",
				url: "/EA/Common",
				data: '{M:"' + m + '",body:"' + sBody + '", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",fn:"",query:"",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:""}',
				success: function (res) {
					//res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
					if (res.substr(0, 2) == 'OK') {
						if (vPos[1] == 'SEARCH_TOOLING') {
							var p = $('#popBlank');
							p.html(res.substr(2)).find('.modal-title').html(el.attr('title'));
							p.find(".modal-dialog").removeClass("modal-sm").removeClass("modal-lg").css("max-width", "52rem");

							p.on('hidden.bs.modal', function () { p.html(''); });
							p.modal();

						} else {
							var j = { "close": true, "width": w, "height": h, "left": l, "top": t }
							j["title"] = el.attr('title'); j["content"] = res.substr(2);

							var pop = _zw.ut.popup(el[0], j);
							var row = x == 'RTVLORGNM' || x == 'PRODUCTCOSTCURRENCY' ? el.parent().parent() : null;
							pop.find('a[data-val]').click(function () {
								var v = $(this).attr('data-val').split('^');
								for (var i = 0; i < param.length; i++) {
									if (row) row.find('[name="' + param[i] + '"]').val(v[i]);
									else $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
								}
								pop.find('.close[data-dismiss="modal"]').click();

								if (x == 'PRODUCTCOSTCURRENCY') _zw.formEx.calc(row.find('[name="' + x + '"]')[0]);
								else if (x == 'CURRENCY') _zw.formEx.calcForm($('#__mainfield[name="' + x + '"]')[0]);
							});

							pop.find('input:text.z-input-in').keyup(function (e) {
								if (e.which == 13) {
									if (row) row.find('[name="' + param[0] + '"]').val($(this).val());
									else $('#__mainfield[name="' + param[0] + '"]').val($(this).val());
									pop.find('.close[data-dismiss="modal"]').click();

									if (x == 'PRODUCTCOSTCURRENCY') _zw.formEx.calc(row.find('[name="' + x + '"]')[0]);
									else if (x == 'CURRENCY') _zw.formEx.calcForm($('#__mainfield[name="' + x + '"]')[0]);
								}
							});
						}
					} else bootbox.alert(res);
				}
			});
		}
    }
});