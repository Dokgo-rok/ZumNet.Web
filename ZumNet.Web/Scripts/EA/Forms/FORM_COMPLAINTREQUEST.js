$(function () {
    _zw.formEx = {
        "validation": function (cmd) {
			var el = null;
            if (cmd == "draft") { //기안
            } else {
				if (_zw.V.biz == "application" && _zw.V.act == "_approver") {
                    el = $('#__mainfield[name="FAULTFACTORY"]');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [귀책공장] 누락!', function () { el.focus(); }); return false; }

				//} else if ((_zw.V.biz == "application" && _zw.V.act == "_approver") || (_zw.V.biz == "gwichaek" && (_zw.V.act == "__r" || _zw.V.act == "_reviewer")) || (_zw.V.biz == "receive" && _zw.V.act == "__r") || (_zw.V.biz == "receive" && _zw.V.act == "_reviewer")) {
				} else if (_zw.V.biz == "receive" && _zw.V.act == "_approver") {
                    el = $('#__mainfield[name="BADSAMPLE"]');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [불량샘플유/무] 누락!', function () { el.focus(); }); return false; }

                    var el2 = $('#__mainfield[name="RECEIVEDATE"]');
                    if (el && el.val() == '유') {
                        if (el2 && $.trim(el2.val()) == '') { bootbox.alert('필수항목 [불량샘플접수일] 누락!', function () { el2.focus(); }); return false; }
                    }

                    el = $('#__mainfield[name="LOSSYN"]');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [손실발생유/무] 누락!', function () { el.focus(); }); return false; }

                    el = $('#__mainfield[name="LOSSAMOUNT"]');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [손실금액] 누락!', function () { el.focus(); }); return false; }

                    el = $('#__mainfield[name="CHECKDATE"]');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [효과성검증일] 누락!', function () { el.focus(); }); return false; }

                    el = $('#__mainfield[name="CHECKCOUNT2"]');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [효과성확인수량] 누락!', function () { el.focus(); }); return false; }

                    el = $('#__mainfield[name="ETC"]');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [효과성확인결과] 누락!', function () { el.focus(); }); return false; }

                    el = $('#__mainfield[name="RESPONSEDATE"]');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [고객대응완료일] 누락!', function () { el.focus(); }); return false; }

                    el = $('#__mainfield[name="BADCOUNT2"]');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [비고] 누락!', function () { el.focus(); }); return false; }

                    el = $('#__mainfield[name="REASON"]');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [발생원인] 누락!', function () { el.focus(); }); return false; }

                    el = $('#__mainfield[name="STEPDESC"]');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [개선대책] 누락!', function () { el.focus(); }); return false; }

                    el = $('#__mainfield[name="DEVDESC"]');
                    if (el && $.trim(el.val()) == '') { bootbox.alert('필수항목 [수평전개] 누락!', function () { el.focus(); }); return false; }
                }
            }
			return true;
        },
        "make": function (f) {
            if ((_zw.V.biz == "application" && _zw.V.act == "_approver") || (_zw.V.biz == "gwichaek" && (_zw.V.act == "__r" || _zw.V.act == "_reviewer")) || (_zw.V.biz == "receive" && _zw.V.act == "__r") || (_zw.V.biz == "receive" && _zw.V.act == "_reviewer")) {
                _zw.body.main(f, ["FAULTFACTORY", "BADSAMPLE", "RECEIVEDATE", "LOSSYN", "LOSSAMOUNT", "CHECKDATE", "CHECKCOUNT2", "BADCOUNT2", "RESPONSEDATE", "ETC", "REASON", "STEPDESC", "DEVDESC", "DESCRIPTION", "PHOTORIGHTA", "PHOTORIGHTB", "PHOTORIGHTC"]);
            }
            else if (_zw.V.biz == "confirm" && _zw.V.act == "_approver") _zw.body.main(f, ["FAULTFACTORY"]);
        },
        "checkEvent": function (ckb, el, fld) {
        },
        "calc": function (el) {
            var s = 0, f = '0,0.[0]';

            if (el.name == "CHECKCOUNT" || el.name == "BADCOUNT") {
				s = _zw.ut.rate(parseFloat(_zw.ut.empty($('#__mainfield[name="BADCOUNT"]').val())), parseFloat(_zw.ut.empty($('#__mainfield[name="CHECKCOUNT"]').val())), 4);
				$('#__mainfield[name="BADRATE"]').val(numeral(s).format(f) + '%');
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