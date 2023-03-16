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

			$.ajax({
				type: "POST",
				url: "/EA/Common",
				data: '{M:"' + m + '",body:"' + sBody + '", k1:"' + vPos[0] + '",k2:"' + vPos[1] + '",k3:"' + '' + '",etc:"' + etc + '",fn:"",query:"",v1:"' + v1 + '",v2:"' + v2 + '",v3:"' + v3 + '",search:""}',
				success: function (res) {
					//res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
					if (res.substr(0, 2) == 'OK') {
						var j = { "close": true, "width": w, "height": h, "left": l, "top": t }
						j["title"] = el.attr('title'); j["content"] = res.substr(2);

						var pop = _zw.ut.popup(el[0], j);
						var row = x == 'SALESCURRENCY' ? el.parent().parent() : null;
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

							var row = (x == 'MOVEPLACE' || x == 'MOVEPLACE2') ? el.parent().parent() : null;
							console.log(row)
							p.find('.zf-modal .z-lnk-navy[data-val]').click(function () {
								var v = $(this).attr('data-val').split('^');
								for (var i = 0; i < param.length; i++) {
									if (row) row.find('[name="' + param[i] + '"]').val(v[i]);
									else $('#__mainfield[name="' + param[i] + '"]').val(v[i]);
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
		},
		"reportWnd": function (ft, body, page, sort, dir) {
			//data body 조건 : N(modal-body 없음), F(footer 포함)
			body = body || ''; sort = sort || ''; dir = dir || '';

			var postData = {};
			postData["ft"] = ft; postData["body"] = body; postData["tgt"] = _zw.V.current.urid; postData["basesort"] = '';
			postData["page"] = (page) ? page : 1; postData["count"] = ''; postData["sort"] = sort; postData["sortdir"] = dir;

			if (body == '') {
				var el = _zw.ut.eventBtn(); do { el = el.parent(); } while (el && el.length > 0 && !el.hasClass('sub_table_row')); //alert(el.find('td:first-child').find('input[name="ROWSEQ"]').val()); return
				postData["pos"] = el.find('td:first-child').find('input[name="ROWSEQ"]').val(); //table row

				postData["start"] = ''; postData["end"] = ''; postData["cd1"] = ''; postData["cd2"] = '';
				postData["cd4"] = ''; postData["cd5"] = ''; postData["cd8"] = ''; postData["cd9"] = '';
			} else {
				var p = $('#popBlank');
				postData["start"] = p.find('.modal-header .start-date').val();
				postData["end"] = p.find('.modal-header .end-date').val();
				p.find('.modal-header .table td [data-for]').each(function () {
					postData[$(this).attr('data-for')] = $(this).val();
				});
				//console.log(postData)
			}

			$.ajax({
				type: "POST",
				url: "/Report/Modal",
				data: JSON.stringify(postData),
				success: function (res) {
					//res = $.trim(res); //cshtml 사용 경우 앞에 공백이 올수 있음 -> 서버에서 문자열 TrimStart() 사용
					if (res.substr(0, 2) == 'OK') {
						var p = $('#popBlank');
						if (body == '') {
							p.html(res.substr(2));
							_zw.ut.picker('date');

							p.find('.modal-header .btn[data-zm-menu="search"]').click(function () {
								_zw.formEx.reportWnd(ft, 'N');
							});

							p.find('.modal-footer .btn[data-zm-menu="confirm"]').click(function () {
								var n = p.find('.modal-body table :radio[name="rdoRow"]:checked');
								if (n.length > 0) {
									bootbox.confirm('현 금형을 선택하시겠습니까?', function (rt) {
										if (rt) {
											//alert(n.parent().parent().attr('id'));
											$.ajax({
												type: "POST",
												url: "/EA/Common",
												data: '{M:"gettooling",k1:"",k2:"TOOLING_DATA",mi:"' + n.parent().parent().attr('id') + '",xf:"tooling",fi:"' + ft + '"}',
												success: function (res) {
													if (res.substr(0, 2) == 'OK') {
														//_zw.formEx.insertToolingData(p.find('.modal-header :hidden[data-for="pos"]').val(), res.substr(2).split(String.fromCharCode(10)));
														_zw.formEx.insertToolingData(p.find('.modal-header :hidden[data-for="pos"]').val(), res.substr(2));
														p.modal('hide');
													} else bootbox.alert(res);
												}
											});
										}
									});
								}
							});

						} else {
							var cDel = String.fromCharCode(8);
							if (res.substr(2).indexOf(cDel) != -1) {
								var vRes = res.substr(2).split(cDel);
								p.find('.modal-header .zf-modal-page').html(vRes[0]);
								p.find('.modal-body').html(vRes[1]);
							} else {
								p.find('.modal-body').html(res.substr(2));
							}
						}

						p.find('.zf-modal-page .btn[data-for]').click(function () {
							p.find('.modal-header :hidden[data-for="page"]').val($(this).attr('data-for'));
							_zw.formEx.reportWnd(ft, 'N', $(this).attr('data-for'));
						});

						p.find('.modal-body .table thead a[data-val]').click(function () {
							var t = $(event.target); sortCol = t.attr('data-val'), sortDir = '';
							t.parent().parent().find('a[data-val]').each(function () {
								if ($(this).attr('data-val') == sortCol) {
									var c = $(this).find('i');
									if (c.hasClass('fe-arrow-up')) {
										c.removeClass('fe-arrow-up').addClass('fe-arrow-down'); sortDir = 'DESC';
									} else {
										c.removeClass('fe-arrow-down').addClass('fe-arrow-up'); sortDir = 'ASC';
									}
								} else {
									$(this).find('i').removeClass();
								}
							});
							_zw.formEx.reportWnd(ft, 'N', null, sortCol, sortDir);
						});

						p.on('hidden.bs.modal', function () { p.html(''); });
						p.modal();

					} else bootbox.alert(res);
				}
			});
		},
		"openXForm": function () {
			var el = _zw.ut.eventBtn(), row = el.parent().parent(), x = 0, y = 0, winName = '', url = '', sResize = '', sId = '', qi;
			sId = row.attr('id');
			x = 900; y = 600; qi = '{M:"read",mi:"' + sId + '",oi:"",wi:"",fi:"REGISTER_TOOLING",xf:"tooling"}';
			url = '/EA/Form?qi=' + _zw.base64.encode(qi);
			if (url != '') _zw.ut.openWnd(url, winName, x, y, sResize);
		},
		"insertToolingData": function (pos, res) {
			if (parseInt(pos) > 0 && res.length > 0) {
				$('#__subtable1 tr.sub_table_row').each(function () {
					var c = $(this).find('td:first-child');
					if (c.find('input[name="ROWSEQ"]').val() == pos) {
						var c1 = String.fromCharCode(10), c2 = String.fromCharCode(9), vModel = '', vPart = '';
						var v1 = res.split(c1), v2 = null, el = null;

						var t = c.next().find('table.ft-sub-sub');
						for (var i = 0; i < v1.length; i++) {
							if (v1[i].length > 0) {
								v2 = v1[i].split(c2);
								if (i == 0) {console.log(v2)
									el = t.find('[name="TOOLINGNUMBER"]'); if (el && el.length > 0) el.val(v2[0]);
									el = t.find('[name="STOREPLACE"]'); if (el && el.length > 0) el.val(v2[1]);
									el = t.find('[name="STOREPLACEID"]'); if (el && el.length > 0) el.val(v2[2]);
									el = t.find('[name="STOREPLACESITEID"]'); if (el && el.length > 0) el.val(v2[3]);
									el = t.find('[name="OWNER"]'); if (el && el.length > 0) el.val(v2[4]);
									el = t.find('[name="OWNERID"]'); if (el && el.length > 0) el.val(v2[5]);
									el = t.find('[name="OWNERSITEID"]'); if (el && el.length > 0) el.val(v2[6]);
									el = t.find('[name="SETUPPLACE"]'); if (el && el.length > 0) el.val(v2[7]);
									el = t.find('[name="CAVITY"]'); if (el && el.length > 0) el.val(v2[8]);

									el = t.find('[name="CAVITYA"]'); if (el && el.length > 0) el.val(v2[22]);
									el = t.find('[name="USABLECAVITYA"]'); if (el && el.length > 0) el.val(v2[23]);
									el = t.find('[name="USABLECAVITY"]'); if (el && el.length > 0) el.val(v2[24]);

									el = t.find('[name="SHOT"]'); if (el && el.length > 0) el.val(v2[9]);
									el = t.find('[name="EXPIREDSHOT"]'); if (el && el.length > 0) el.val(v2[10]);
									el = t.find('[name="COMPLETEDATE"]'); if (el && el.length > 0) el.val(v2[11]);

									el = t.find('[name="PREPLACE"]'); if (el && el.length > 0) el.val(v2[19]);
									el = t.find('[name="FROMDATE"]'); if (el && el.length > 0) el.val(v2[20]);
									el = t.find('[name="TODATE"]'); if (el && el.length > 0) el.val(v2[21]);

									el = t.find('[name="MAKESUPPLIER"]'); if (el && el.length > 0) el.val(v2[15]);
									el = t.find('[name="MAKESUPPLIERID"]'); if (el && el.length > 0) el.val(v2[16]);
									el = t.find('[name="MAKESUPPLIERSITEID"]'); if (el && el.length > 0) el.val(v2[17]);
									el = t.find('[name="CMNTYPE"]'); if (el && el.length > 0) el.val(v2[18]);
								} else {
									if (v2[0] == "pdmmodel") {//console.log(v2)
										vModel = v2[1] + c2 + v2[2] + c2 + v2[3];
									} else if (v2[0] == "pdmpart") {//console.log(v2)
										if (vPart != '') vPart += c1;
										vPart += v2[1] + c2 + v2[2] + c2 + v2[3];
									}
								}
							}
						}
						var el2 = t.find('[name="MODELOID"]'); if (el2 && el2.length > 0) el2.val('');
						var el3 = t.find('[name="MODELNO"]'); if (el3 && el3.length > 0) el3.val('');
						var el4 = t.find('[name="MODELNM"]'); if (el4 && el4.length > 0) el4.val('');
						if (vModel != '') {
							vModel = vModel.split(c2);
							if (el2) el2.val(vModel[0]); if (el3) el3.val(vModel[1]); if (el4) el4.val(vModel[2]);
						}

						el = t.find('[name="PARTNO1"]');
						if (el && el.length > 0) {
							var n = el.parent().parent(); //div class=subtbl_div
							n.find('> div:gt(1)').remove();
							n.find('> div').find("input").val('');

							if (vPart != '') {
								vPart = vPart.split(c1);
								for (var i = 0; i < vPart.length; i++) {
									v2 = vPart[i].split(c2); //console.log(v2)
									if (i == 0) {
										n.find("input[name]").each(function () {
											//console.log('name=>' + $(this).attr('name'))
											if ($(this).attr('name').indexOf('PARTOID') >= 0) $(this).val(v2[0]);
											else if ($(this).attr('name').indexOf('PARTNO') >= 0) $(this).val(v2[1]);
											else if ($(this).attr('name').indexOf('PARTNM') >= 0) $(this).val(v2[2]);
										});
									} else {
										var str = "<div><input type='text' name='PARTNO" + (i + 1).toString() + "' style='width:250px' class='txtRead' readonly='readonly' value='" + v2[1] + "' />"
											+ "&nbsp;(<input type='text' name='PARTNM" + (i + 1).toString() + "' style='width:335px' class='txtRead' readonly='readonly' value='" + v2[2] + "' />)"
											+ "<input type='hidden' name='PARTOID" + (i + 1).toString() + "' value='" + v2[0] + "' /></div>";
										n.append(str);
									}
								}
							}
						}
					}
				});
			}
		}
    }
});