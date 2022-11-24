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
        "orgSelect": function (p, x) {
            p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
                var info = JSON.parse($(this).attr('data-attr')); //console.log(info)
                //$('#__mainfield[name="TRIPPERSONID"]').val(info["id"]);

                $.ajax({
                    type: "POST",
                    url: "/EA/Common",
                    data: '{M:"getreportsearch",body:"S", k1:"",k2:"DOCWORKSTATE",k3:"",v1:"' + info["id"] + '",v2:"",v3:""}',
                    success: function (res) {
                        if (res.substr(0, 2) == 'OK') {
                            v = res.substr(2).split(',');
                            var person = [];
                            for (var i = 0; i < v.length; i++) { var d = v[i].split(':'); person[d[0]] = d[1]; }

                            $('#__mainfield[name="APPLICANTEMPNO"]').val(person.APPLICANTEMPNO);
                            $('#__mainfield[name="APPLICANTID"]').val(person.APPLICANTID);
                            $('#__mainfield[name="APPLICANTDEPTID"]').val(person.APPLICANTDEPTID);
                            //성명 
                            $('#__mainfield[name="APPLICANT"]').val(person.APPLICANT);
                            $('#__mainfield[name="ENGNM"]').val(person.ENGNM);
                            $('#__mainfield[name="APPLICANT"]').parent().find('span').html(person.ENGNM + " (" + person.APPLICANT + ")");
                            //부서
                            $('#__mainfield[name="APPLICANTDEPT"]').val(person.APPLICANTDEPT);
                            $('#__mainfield[name="ENGDEPTNM"]').val(person.ENGDEPTNM);
                            $('#__mainfield[name="APPLICANTDEPT"]').parent().find('span').html(person.ENGDEPTNM + " (" + person.APPLICANTDEPT + ")");
                            //직위
                            $('#__mainfield[name="APPLICANTGRADE"]').val(person.APPLICANTGRADE);
                            $('#__mainfield[name="ENGGRADENM"]').val(person.ENGGRADENM);
                            $('#__mainfield[name="APPLICANTGRADE"]').parent().find('span').html(person.ENGGRADENM + " (" + person.APPLICANTGRADE + ")");
                            //생년월일
                            $('#__mainfield[name="BIRTHDATE"]').val(person.BIRTHDATE);
                            //$('#__mainfield[name="BIRTHDATE"]').parent().find('span').html(convertDate2(person.BIRTHDATE, "en") + " (" + convertDate2(person.BIRTHDATE, "ko") + ")");
                            $('#__mainfield[name="BIRTHDATE"]').parent().find('span').html(_zw.ut.dateLocale(person.BIRTHDATE, 'en') + ' (' + _zw.ut.dateLocale(person.BIRTHDATE, 'ko') + ')');
                            //입사일
                            var enddate =  person.LEAVEDATE=="" ? f.document.getElementById("REQUESTDATE").value : person.LEAVEDATE;
                            $('#__mainfield[name="INDATE"]').val(person.INDATE);
                            $('#__mainfield[name="LEAVEDATE"]').val(enddate);
                            //$('#__mainfield[name="INDATE"]').parent().find('span').html(convertDate2(person.INDATE, "en") + " ~ " + convertDate2($('#__mainfield[name="REQUESTDATE").value, "en") + "\n (" + convertDate2(person.INDATE, "ko") + " ~ " + convertDate2($('#__mainfield[name="REQUESTDATE"]').val(), "ko") + ")");
                            $('#__mainfield[name="INDATE"]').parent().find('span').html(_zw.ut.dateLocale(person.INDATE, "en") + " ~ " + _zw.ut.dateLocale(enddate, "en") + "<br />(" + _zw.ut.dateLocale(person.INDATE, "ko") + " ~ " + _zw.ut.dateLocale(enddate, "ko") + ")");
                        }
                        else if (res.substr(0, 2) == 'ND') { bootbox.alert(res.substr(2)); return false; }
                        else { bootbox.alert(res); return false; }
                    }
                });
            });
            p.modal('hide');
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
                                var v = $(this).attr('data-val').split(',');
                                var person = [];
                                for (var i = 0; i < v.length; i++) { var d = v[i].split(':'); person[d[0]] = d[1]; } console.log(person)

                                $('#__mainfield[name="APPLICANTEMPNO"]').val(person.APPLICANTEMPNO);
                                $('#__mainfield[name="APPLICANTID"]').val(person.APPLICANTID);
                                $('#__mainfield[name="APPLICANTDEPTID"]').val(person.APPLICANTDEPTID);
                                //성명 
                                $('#__mainfield[name="APPLICANT"]').val(person.APPLICANT);
                                $('#__mainfield[name="ENGNM"]').val(person.ENGNM);
                                $('#__mainfield[name="APPLICANT"]').parent().find('span').html(person.ENGNM + " (" + person.APPLICANT + ")");
                                //부서
                                $('#__mainfield[name="APPLICANTDEPT"]').val(person.APPLICANTDEPT);
                                $('#__mainfield[name="ENGDEPTNM"]').val(person.ENGDEPTNM);
                                $('#__mainfield[name="APPLICANTDEPT"]').parent().find('span').html(person.ENGDEPTNM + " (" + person.APPLICANTDEPT + ")");
                                //직위
                                $('#__mainfield[name="APPLICANTGRADE"]').val(person.APPLICANTGRADE);
                                $('#__mainfield[name="ENGGRADENM"]').val(person.ENGGRADENM);
                                $('#__mainfield[name="APPLICANTGRADE"]').parent().find('span').html(person.ENGGRADENM + " (" + person.APPLICANTGRADE + ")");
                                //생년월일
                                $('#__mainfield[name="BIRTHDATE"]').val(person.BIRTHDATE);
                                //$('#__mainfield[name="BIRTHDATE"]').parent().find('span').html(convertDate2(person.BIRTHDATE, "en") + " (" + convertDate2(person.BIRTHDATE, "ko") + ")");
                                $('#__mainfield[name="BIRTHDATE"]').parent().find('span').html(_zw.ut.dateLocale(person.BIRTHDATE, 'en') + ' (' + _zw.ut.dateLocale(person.BIRTHDATE, 'ko') + ')');
                                //입사일
                                var enddate = person.LEAVEDATE == "" ? f.document.getElementById("REQUESTDATE").value : person.LEAVEDATE;
                                $('#__mainfield[name="INDATE"]').val(person.INDATE);
                                $('#__mainfield[name="LEAVEDATE"]').val(enddate);
                                //$('#__mainfield[name="INDATE"]').parent().find('span').html(convertDate2(person.INDATE, "en") + " ~ " + convertDate2($('#__mainfield[name="REQUESTDATE").value, "en") + "\n (" + convertDate2(person.INDATE, "ko") + " ~ " + convertDate2($('#__mainfield[name="REQUESTDATE"]').val(), "ko") + ")");
                                $('#__mainfield[name="INDATE"]').parent().find('span').html(_zw.ut.dateLocale(person.INDATE, "en") + " ~ " + _zw.ut.dateLocale(enddate, "en") + "<br />(" + _zw.ut.dateLocale(person.INDATE, "ko") + " ~ " + _zw.ut.dateLocale(enddate, "ko") + ")");

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