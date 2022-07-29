$(function () {
    _zw.formEx = {
		"validation": function (cmd) {
			var el = null, bReturn = true;
			if (cmd == "draft") { //기안
			} else { //결재
				if (_zw.V.biz == '영업수신' && _zw.V.act == '__r') {
					var e1, e2, e3, e4;
					$('#__subtable1 tr.sub_table_row .ft-sub-sub').each(function () {
						el = $(this).find('[name="POSTYPE"]');
						if (el.length > 0 && $.trim(el.val()) == '') { bootbox.alert("필수항목 [소유구분] 누락!", function () { el.focus(); }); bReturn = false; return false; }

						el = $(this).find('[name="OWNER"]');
						if (el.length > 0 && $.trim(el.val()) == '') { bootbox.alert("필수항목 [소유처] 누락!", function () { }); bReturn = false; return false; }

						e1 = $(this).find('[name="WHOMONEY"]');
						if (e1.length > 0 && $.trim(e1.val()) == '') { bootbox.alert("필수항목 [금형비부담] 누락!", function () { }); bReturn = false; return false; }

						e2 = $(this).find('[name="WHOMONEYDETAIL"]');
						e3 = $(this).find('[name="RTVLORGNM"]');
						e4 = $(this).find('[name="RTVLORGEXPDT"]');

						if (e1.val() == '고객' && e2.val() == '') { bootbox.alert("금형비부담 고객 상세 항목을 선택하십시오!", function () { }); bReturn = false; return false; }
						else if (e1.val() == '고객' && e3.val() == '') { bootbox.alert("필수항목 [비용회수사업장] 누락!", function () { }); bReturn = false; return false; }
						else if (e1.val() == '고객' && e4.val() == '') { bootbox.alert("필수항목 [비용회수예정일] 누락!", function () { }); bReturn = false; return false; }
					});
				}
			}
			return bReturn;
        },
		"make": function (f) {
			if (_zw.V.biz == '영업수신' && _zw.V.act == "__r") _zw.body.subPart(f, "1;CHARGEDEPT;CHARGEDEPTCD;CHARGEUSER;CHARGEUSERID;CHARGEUSEREMPID;WHOMONEY;WHOMONEYDETAIL;POSTYPE;OWNER;OWNERID;OWNERSITEID;RTVLORGID;RTVLORGNM;RTVLORGEXPDT")
        },
		"checkEvent": function (ckb, el, fld) {
			if (fld == 'WHOMONEY') {
				var row = $(el).parent().parent();
				if (el.checked && el.value == '고객') row.find(':checkbox[name="ckbWHOMONEYDETAIL"]').prop('disabled', false).prop('checked', false);
				else row.find(':checkbox[name="ckbWHOMONEYDETAIL"]').prop('disabled', true).prop('checked', false);
			}
        },
		"calc": function (el) {
			var e1, e2, e3, e4;
			var s = 0, v = 0, f = '0,0.[0000]';

			if (el.name == 'PRODUCTCOSTCURRENCY' || el.name == 'PRODUCTCOST' || el.name == "TOOLREQQTY") {
				var c = $(el).parent().parent().parent(); //tbody
				e1 = c.find('[name="PRODUCTCOSTCURRENCY"]'); e2 = c.find('[name="PRODUCTCOST"]');
				e3 = c.find('[name="TOOLREQQTY"]'); e4 = c.find('[name="PRODUCTCOSTSUM"]'); e5 = c.find('[name="CONVPRODUCTCOSTSUM"]');

				if (e1.val() != '') {
					v = e1.val() == 'USD' ? 1 : _zw.formEx.exchangeRate('USD', e1.val(), _zw.V.current.date.substr(0, 10), 'Cost_Corporate');
					s = parseFloat(_zw.ut.empty(e2.val())) * parseFloat(v); //console.log(s)
					c.find('[name="CONVPRODUCTCOST"]').val(numeral(s).format(f));
                }

				if (e2.val() != '') {
					s = parseFloat(_zw.ut.empty(e2.val())) * parseFloat(_zw.ut.empty(e3.val()));
					e4.val(numeral(s).format(f)); s = 0;
				
					s = parseFloat(_zw.ut.empty(e4.val())) * parseFloat(v);
					c.find('[name="CONVPRODUCTCOSTSUM"]').val(numeral(s).format(f));
				}
			}

			if (el.name == "COUNT" || el.name == "UNIT") {
				var row = $(el).parent().parent(), p = row.parent().parent();
				s = numeral(parseFloat(_zw.ut.empty(row.find(':text[name="COUNT"]').val())) * parseFloat(_zw.ut.empty(row.find(':text[name="UNIT"]').val())));
				row.find(':text[name="SUM"]').val(numeral(s).format(f)); s = 0;

				p.find(':text[name="COUNT"]').each(function (idx, e) { s += numeral(e.value).value(); })
				$('#__mainfield[name="TOTALBUL"]').val(numeral(s).format(f)); s = 0;

				p.find(':text[name="SUM"]').each(function (idx, e) { s += numeral(e.value).value(); })
				$('#__mainfield[name="TOTALSUM"]').val(numeral(s).format(f));

				_zw.formEx.calcForm();
			}
        },
		"autoCalc": function (p) {
			var s = 0, f = '0,0.[0000]';

			p.find(':text[name="COUNT"]').each(function (idx, e) { s += numeral(e.value).value(); })
			$('#__mainfield[name="TOTALBUL"]').val(numeral(s).format(f)); s = 0;

			p.find(':text[name="SUM"]').each(function (idx, e) { s += numeral(e.value).value(); })
			$('#__mainfield[name="TOTALSUM"]').val(numeral(s).format(f)); s = 0;

			p.find(':text[name="SUMKRW"]').each(function (idx, e) { s += numeral(e.value).value(); })
			$('#__mainfield[name="TOTALSUMKRW"]').val(numeral(s).format(f));
		},
		"calcForm": function (el) {
			var s = 0, f = '0,0.[0000]';
			var e1 = $('#__mainfield[name="CURRENCY"]'), e2 = $('#__mainfield[name="EXCHANGERATE"]');
			
			if (el && (el.name == 'CURRENCY' || el.name == 'EXCHANGERATE')) {
				if (e1.val() != '' && e2.val() != '') {
					_zw.V["xrate"] = _zw.formEx.exchangeInfo(e1.val(), e2.val()); //console.log(_zw.V["xrate"]);
                }
            }
			if (_zw.V["xrate"] != null) {
				var std = 'KRW';
				var rate = std == e1.val() ? 1 : parseFloat(_zw.ut.empty(_zw.V["xrate"][std]));

				$('#__subtable2 tr.sub_table_row').each(function () {
					s = rate == 0 ? 0 : parseFloat(_zw.ut.empty($(this).find('input[name="SUM"]').val())) / rate;
					$(this).find('input[name="SUMKRW"]').val(numeral(s).format('0,0'));
				});
				s = 0;

				$('#__subtable2 :text[name="SUMKRW"]').each(function (idx, e) { s += numeral(e.value).value(); })
				$('#__mainfield[name="TOTALSUMKRW"]').val(numeral(s).format('0,0'));
            }
		},
		"date": function (el) {
			var from, to;
			if (el.name == 'FROMDATE' || el.name == 'TODATE') {
				from = $('#__mainfield[name="FROMDATE"]'); to = $('#__mainfield[name="TODATE"]');
			} else if (el.name == 'MAKEFROM' || el.name == 'MAKETO') {
				row = $(el).parent().parent();
				from = row.find('input[name="MAKEFROM"]'); to = row.find('input[name="MAKETO"]');
			} else if (el.name == 'EXCHANGERATE') {
				_zw.formEx.calcForm(el);
            }
			if (from && from.val() != '' && to && to.val() != '') {
				var dif = _zw.ut.diff('day', to.val(), from.val()); //console.log(dif + " : " + !(dif))
				if (dif && dif < 0) { bootbox.alert('날짜 범위 입력 오류!', function () { to.val(''); to.focus(); }); return false; }

				if (el.name == 'FROMDATE' || el.name == 'TODATE') $('#__mainfield[name="DAYS"]').val(dif + 1);
			}
		},
		"orgSelect": function (p, x) {
			p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
				var info = JSON.parse($(this).attr('data-attr')); //console.log(info)
				var dn = $(this).next().text();
				var row = $(x).parent().parent();
				$(x).prev().val(info["grdn"] + ' ' + dn);
				row.find('input[name="CHARGEUSER"]').val(dn);
				row.find('input[name="CHARGEUSERID"]').val(info["id"]);
				row.find('input[name="CHARGEUSEREMPID"]').val(info["empid:"]);
				row.find('input[name="CHARGEDEPT"]').val(info["grdn"]);
				row.find('input[name="CHARGEDEPTCD"]').val(info["gralias:"]);
			});
			p.modal('hide');
		},
		"change": function (x) {
			var row = $(x).parent().parent(); //console.log(p)
			$(x).next().val($(x).children('option:selected').text());

			if (x.name == 'CLSCODE') {
				row.find(':checkbox[name="ckbRFID"]').each(function () {
					if ($(this).val() == 'N') $(this).prop('checked', x.value == "C" || x.value == "ETC" || x.value == "J" || x.value == "S" || x.value == "Q" ? true : false);
					else if ($(this).val() == 'Y') $(this).prop('checked', x.value != '' && x.value != "C" && x.value != "ETC" && x.value != "J" && x.value != "S" && x.value != "Q" ? true : false);
				});
				
            }
		},
		"event": function (x) {
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
		},
		"externalWnd": function (pos, w, h, m, n, etc, x) {
			var el = _zw.ut.eventBtn(), vPos = pos.split('.'); //console.log(arguments)
			var param = [x]; if (arguments.length > 7) for (var i = 7; i < arguments.length; i++) param.push(arguments[i]); //console.log(param);
			var m = '', v1 = '', v2 = '', v3 = '';
			if (vPos[0] == 'erp') m = 'getoracleerp';
			else if (vPos[0] == 'report') m = 'getreportsearch';
			else m = 'getcodedescription';

			var sAdd = '';
			if (pos == 'erp.vendors') sAdd = '<select class="custom-select"><option value="VENDOR_NAME">NAME</option><option value="SEGMENT1">CODE</option></select>';
			else if (pos == 'erp.vendors2') sAdd = '<select class="custom-select"><option value="CUSTOMER_NAME">NAME</option><option value="CUSTOMER_NUMBER">CODE</option></select>';
			else if (pos == 'erp.saleitems') sAdd = '<select class="custom-select"><option value="SEGMENT1">품번</option><option value="DESCRIPTION">품명</option></select>';
			else if (pos == 'erp.vendorcustomer') {
				var szCd = (etc == "BUYER") ? "CUSTOMER_NUMBER" : "SEGMENT1", szNm = (etc == "BUYER") ? "CUSTOMER_NAME" : "VENDOR_NAME";
				sAdd = '<select class="custom-select"><option value="' + szNm + '">NAME</option><option value="' + szCd + '">CODE</option></select>';
			} else if (pos == 'erp.vendors2') sAdd = '<select class="custom-select"><option value="CUSTOMER_NAME">NAME</option><option value="CUSTOMER_NUMBER">CODE</option></select>';

			var s = '<div class="zf-modal modal-dialog modal-dialog-centered modal-dialog-scrollable">'
				+ '<div class="modal-content" data-for="' + vPos[1] + '" style="box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.5)">'
				+ '<div class="modal-header">'
				+ '<div class="d-flex align-items-center w-100">'

			if (sAdd != '') s += '<div class="input-group wd-70 wd-lg-60 wd-xl-60">' + sAdd;
			else s += '<div class="input-group w-50">';

			s += '<input type="text" class="form-control" placeholder="' + (el.attr('title') != '' ? el.attr('title') + ' ' : '') + '검색" value="">'
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
			var searchCol = $('.zf-modal .modal-header .input-group select');

			p.find(".modal-dialog").css("max-width", "30rem").find(".modal-content").css("min-height", "20rem");

			searchTxt.keyup(function (e) { if (e.which == 13) { searchBtn.click(); } });
			searchBtn.click(function () {
				if ($.trim(searchTxt.val()) == '' || searchTxt.val().length < 1) { bootbox.alert('검색어를 입력하십시오!', function () { searchTxt.focus(); }); return false; }
				var exp = "['\\%^&\"*]", reg = new RegExp(exp, 'gi');
				if (searchTxt.val().search(reg) >= 0) { bootbox.alert(exp + ' 문자는 사용될 수 없습니다!', function () { searchTxt.focus(); }); return false; }

				$.ajax({
					type: "POST",
					url: "/EA/Common",
					data: '{M:"' + m + '",body:"N", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",search:"' + searchTxt.val() + '",searchcol:"' + (searchCol.length > 0 ? searchCol.val() : '') + '",page:"' + p.find('.modal-header :hidden[data-for="page"]').val() + '",count:"' + p.find('.modal-header :hidden[data-for="page-count"]').val() + '",v1:"' + v1 + '"}',
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

							var row = x == 'MODELNO' || x == 'SUPPLIER' || x == 'OWNER' ? el.parent().parent() : null;
							if (x == 'PARTNO') row = el.parent();

							p.find('.zf-modal .z-lnk-navy[data-val]').click(function () {
								var v = $(this).attr('data-val').split('^');
								for (var i = 0; i < param.length; i++) {
									if (row) {
										if (x == 'PARTNO') row.find('[name^="' + param[i] + '"]').val(v[i]);
										else row.find('[name="' + param[i] + '"]').val(v[i]);
									} else $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
								}

								if (x == 'BUYER') _zw.formEx.searchToolingStatus('AA', v[0], '', '');;
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
		},
		"exchangeInfo": function (tc, dt) {
			var rt;
			$.ajax({
				type: "POST",
				url: "/EA/Common",
				async: false,
				data: '{M:"getoracleerp",body:"S", k1:"",k2:"exchangeinfo",k3:"",v1:"' + tc + '",v2:"' + dt + '",v3:"' + dt + '",conver:"1005"}',
				success: function (res) {
					if (res.substr(0, 2) == 'OK') rt = JSON.parse(res.substr(2)); //console.log(j)
					else bootbox.alert(res);
				}
			});
			return rt;
		},
		"exchangeRate": function (fc, tc, cd, ct) {
			var rt = '';
			$.ajax({
				type: "POST",
				url: "/EA/Common",
				async: false,
				data: '{M:"getoracleerp",body:"N", k1:"erp",k2:"exchangerate",k3:"detail",fc:"' + fc + '",tc:"' + tc + '",cd:"' + cd + '",ct:"' + ct + '"}',
				success: function (res) {
					if (res.substr(0, 2) == 'OK') {
						var v = res.substr(2).split(String.fromCharCode(8));
						if (v[0] == 'Y') rt = v[1];
						else bootbox.alert(v[0]);
					} else bootbox.alert(res);
				}, beforeSend: function () { }
			});
			return rt;
		},
		"searchToolingStatus": function (k3, v1, v2, v5) {
			$.ajax({
				type: "POST",
				url: "/EA/Common",
				async: false,
				data: '{M:"getreportsearch",body:"S", k1:"report",k2:"SEARCH_TOOLING",k3:"' + k3 + '",v1:"' + v1 + '",v2:"' + v2 + '",v3:"",v4:"",v5:"' + v5 + '"}',
				success: function (res) {
					if (res.substr(0, 2) == 'OK') {
						var v = res.substr(2).split(','), f = '0,0.[0000]'; console.log(parseFloat(v[0]) + " : " + numeral(parseFloat(v[0])).format(f));
						$('#__mainfield[name="COMPANYSTOCKQTY"]').val(numeral(_zw.ut.empty(v[0])).format(f));
						$('#__mainfield[name="COMPANYCOSTUSD"]').val(numeral(_zw.ut.empty(v[1])).format(f));
						$('#__mainfield[name="BUYERSTOCKQTY"]').val(numeral(_zw.ut.empty(v[2])).format(f));
						$('#__mainfield[name="BUYERCOSTUSD"]').val(numeral(_zw.ut.empty(v[3])).format(f));
						$('#__mainfield[name="TOTSTOCKQTY"]').val(numeral(_zw.ut.empty(v[4])).format(f));
						$('#__mainfield[name="BUYERCHARGETYPE"]').val(numeral(_zw.ut.empty(v[5])).format(f));
						$('#__mainfield[name="BUYERCHARGESUM"]').val(numeral(_zw.ut.empty(v[6])).format(f));
						$('#__mainfield[name="BUYERRETRIEVALCNT1"]').val(numeral(_zw.ut.empty(v[7])).format(f));
						$('#__mainfield[name="BUYERRETRIEVALCNT2"]').val(numeral(_zw.ut.empty(v[8])).format(f));
						$('#__mainfield[name="BUYERRETRIEVALSUM1"]').val(numeral(_zw.ut.empty(v[9])).format(f));
						$('#__mainfield[name="BUYERRETRIEVALSUM2"]').val(numeral(_zw.ut.empty(v[10])).format(f));

					} else bootbox.alert(res);
				}
			});
		},
		"searchDrawingInfo": function (k3, v1) {
			$.ajax({
				type: "POST",
				url: "/EA/Common",
				async: false,
				data: '{M:"getreportsearch",body:"S", k1:"report",k2:"FORM_DRAWING",k3:"' + k3 + '",v1:"' + v1 + '",v2:"",v3:"",v4:"",v5:""}',
				success: function (res) {
					if (res.substr(0, 2) == 'OK') {
						var v = res.substr(2).split(String.fromCharCode(10));

					} else bootbox.alert(res);
				}
			});
		}
    }
});