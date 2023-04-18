// Auto update layout
if (window.layoutHelpers) {
    window.layoutHelpers.setAutoUpdate(true);
}

$(function () {
    // Initialize sidenav
    $('#layout-sidenav').each(function () {
        new SideNav(this, {
            orientation: $(this).hasClass('sidenav-horizontal') ? 'horizontal' : 'vertical'
        });
    });

    // wave
    Waves.attach('.app-brand, .sidenav-item a, .btn, .z-wave', 'waves-light'); Waves.init();

    // bootbox
    bootbox.setDefaults({
        locale: "ko",
        size: "sm"
    });

    //bootbox.setLocale({ locale: "ko", values: { OK: "확인", CANCEL: "취소", CONFIRM: "확인" }});

    // jquery ajax setup
    $.ajaxSetup({
        error: function (res) {
            if (res.status == 403) {

            } else {
                bootbox.alert({ title: "Ajax Error", message: res.responseText });
            }
        },
        failure: function (res) {
            bootbox.alert({ title: "Ajax Failure", message: res.responseText });
        },
        //beforeSend: function () {
        //    _zw.ut.ajaxLoader(true);
        //},
        complete: function (res) {
            _zw.ut.ajaxLoader(false);
        }
    });

    $('.modal-ajaxloader .modal-title').html('Loading ...');

    // Initialize sidenav togglers
    $('body').on('click', '.layout-sidenav-toggle', function (e) {
        e.preventDefault();
        window.layoutHelpers.toggleCollapsed();
    });

    // Swap dropdown menus in RTL mode
    if ($('html').attr('dir') === 'rtl') {
        $('#layout-navbar .dropdown-menu').toggleClass('dropdown-menu-right');
    }

    $('[data-toggle="popover"]').popover();
    $('[data-toggle="tooltip"]').tooltip();

    $('.messages-scroll').each(function () {
        new PerfectScrollbar(this, {
            suppressScrollX: true,
            wheelPropagation: true
        });
    });

    $('.messages-sidebox-toggler').click(function (e) {
        e.preventDefault();
        $('.messages-wrapper, .messages-card').toggleClass('messages-sidebox-open');
    });
});

// Korean
var dataTable_lang_kor = {
    "decimal": "",
    "emptyTable": "데이터가 없습니다.",
    "info": "_START_ - _END_ (총 _TOTAL_ 명)",
    "infoEmpty": "0명",
    "infoFiltered": "(전체 _MAX_ 명 중 검색결과)",
    "infoPostFix": "",
    "thousands": ",",
    "lengthMenu": "_MENU_ 개씩 보기",
    "loadingRecords": "로딩중...",
    "processing": "처리중...",
    "search": "검색 : ",
    "zeroRecords": "검색된 데이터가 없습니다.",
    "paginate": {
        "first": "첫 페이지",
        "last": "마지막 페이지",
        "next": "다음",
        "previous": "이전"
    },
    "aria": {
        "sortAscending": " :  오름차순 정렬",
        "sortDescending": " :  내림차순 정렬"
    }
};

(function () {
    var root = this;
    var version = '1.0';
    var _zw;

    if (typeof exports !== 'undefined') {
        _zw = exports;
    } else {
        _zw = root._zw = {};
    }

    _zw.V = {};     //사용할 변수, 데이터

    //메뉴
    _zw.mu = {

    };

    //함수
    _zw.fn = {
        "org": function (tgt, multi, el) {//tgt : user, group, all, multi : y, n
            var boundary = _zw.V.boundary || _zw.V.lv.boundary;

            $.ajax({
                type: "POST",
                url: "/Organ/Plate",
                data: '{M:"' + tgt + '",multi:"' + multi + '",boundary:"' + boundary + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        var v = res.substr(2).split(boundary); //console.log(JSON.parse(v[1]))
                        var p = $('#popBlank'); p.html(v[0]); //body 없는 modal 경우 show.bs.modal 사용시 버튼 이벤트 안됨

                        new PerfectScrollbar(p.find('.zf-org .tab-content .tab-pane')[0]);
                        new PerfectScrollbar(p.find('.zf-org .zf-org-list')[0]);
                        new PerfectScrollbar(p.find('.zf-org .zf-org-select')[0]);

                        p.find('#__OrgMapTree').jstree({
                            core: {
                                data: JSON.parse(v[1]).data,
                                multiple: false
                            },
                            plugins: ["types", "wholerow"],
                            types: {
                                default: { icon: "fas fa-user-friends text-secondary" },
                                root: { icon: "fas fa-city text-indigo" }
                            }
                        })
                            .on('select_node.jstree', function (e, d) {
                                if (d.selected.length == 1) {
                                    var n = d.instance.get_node(d.selected[0]);
                                    if ('7777.' + n.id == _zw.V.opnode) return false; //'7777.' => 부서명 Navigation에 사용
                                    if (n.li_attr.hasmember == 'Y') {
                                        $.ajax({
                                            type: "POST",
                                            url: "/Organ/Plate",
                                            data: '{M:"member",grid:"' + n.id + '",boundary:"' + boundary + '"}',
                                            success: function (res) {
                                                if (res.substr(0, 2) == "OK") {
                                                    p.find('.zf-org .zf-org-list').html(res.substr(2));
                                                    _zw.fn.orgUserClick(p, multi);
                                                } else bootbox.alert(res);
                                            },
                                            beforeSend: function () { } //로딩 X
                                        });
                                    }
                                }
                            });

                        //p.find('.zf-org .nav .nav-link').on('shown.bs.tab', function (e) {
                        //    if ($(e.target).attr('aria-controls') == 'orgmaptree') {
                        //    }
                        //    //console.log(e.relatedTarget)
                        //});

                        p.find('#__OrgMapSearch input[data-for]').keyup(function (e) {
                            if (e.which == 13) p.find('#__OrgSearch .btn-outline-success').click();
                        });

                        p.find('#__OrgMapSearch .btn-outline-success').click(function () {
                            var j = {}; j['M'] = 'search'; j['boundary'] = boundary;
                            if (p.find('#orgmapsearch').hasClass('active')) {//검색창 활성화 여부
                                p.find('#__OrgMapSearch [data-for]').each(function () {
                                    j[$(this).attr('data-for')] = $(this).val();
                                });
                            }
                            $.ajax({
                                type: "POST",
                                url: "/Organ/Plate",
                                data: JSON.stringify(j),
                                success: function (res) {
                                    if (res.substr(0, 2) == "OK") {
                                        p.find('.zf-org .zf-org-list').html(res.substr(2));
                                        _zw.fn.orgUserClick(p, multi);
                                    } else bootbox.alert(res);
                                },
                                beforeSend: function () { } //로딩 X
                            });
                            return false;
                        });

                        _zw.fn.orgUserClick(p, multi);

                        p.find('.btn[data-zm-menu]').click(function () {
                            var mn = $(this).attr('data-zm-menu');
                            if (mn == 'addUser') {
                                if (multi == 'n') $('.zf-org .zf-org-select div.d-flex').remove();

                                $('.zf-org .zf-org-list input:checkbox:checked').each(function () {
                                    var jUser = JSON.parse($(this).attr('data-attr')); //console.log(jUser); return;

                                    if ($('.zf-org .zf-org-select input:checkbox[data-for="' + $(this).attr('data-for') + '"]').length > 0) {
                                        bootbox.alert("중복된 사용자 입니다!");
                                    } else {
                                        var s = $('.zf-org-template').html();
                                        s = s.replace("{$id}", $(this).attr('data-for'));
                                        //s = s.replace("{$attr}", $(this).attr('data-attr'));
                                        s = s.replace("{$user}", $(this).next().text());
                                        s = s.replace("{$grade}", $(this).parent().parent().next().text())
                                        s = s.replace("{$dept}", jUser['grdn'])

                                        $('.zf-org .zf-org-select').append(s);
                                        $('.zf-org .zf-org-select input:checkbox[data-for="' + $(this).attr('data-for') + '"]').attr('data-attr', $(this).attr('data-attr'));
                                    }
                                    $(this).prop('checked', false);
                                });
                            } else if (mn == 'addGroup') {
                                if (p.find('.zf-org .nav-tabs-top .tab-pane.active').attr('id') == 'orgmaptree') {
                                    if (multi == 'n') $('.zf-org .zf-org-select div.d-flex').remove();

                                    var selected = p.find('#__OrgMapTree').jstree('get_selected', true);
                                    if (selected.length > 0) {
                                        var info = selected[0].li_attr; //console.log(info)
                                        if ($('.zf-org .zf-org-select input:checkbox[data-for="' + info["id"] + '"]').length > 0) {
                                            bootbox.alert("중복된 부서 입니다!");
                                        } else {
                                            var s = $('.zf-org-template-group').html();
                                            s = s.replace("{$id}", 'gr.' + info["id"]).replace("{$group}", selected[0].text);

                                            $('.zf-org .zf-org-select').append(s);
                                            //$('.zf-org .zf-org-select input:checkbox[data-for="' + info["id"] + '"]').attr('data-attr', '{"id":"' + info["id"] + '","gralias":"' + info["gralias"] + '", "hasmember": "' + info["hasmember"] + '","level":"' + info["level"] + '"}');
                                            $('.zf-org .zf-org-select input:checkbox[data-for="gr.' + info["id"] + '"]').attr('data-attr', JSON.stringify(info));
                                        }
                                    }
                                }
                            } else if (mn == 'removeUser' || mn == 'removeGroup') {
                                $('.zf-org .zf-org-select input:checkbox:checked').each(function () {
                                    $(this).parent().parent().parent().remove();
                                });
                            } else if (mn == 'confirm') {
                                if (_zw.fn.orgSelect) _zw.fn.orgSelect(p, el);
                            }
                        });

                        //p.find('.zf-org-menu .btn[data-toggle="tooltip"][title!=""]').tooltip(); //<--적용X
                        p.on('hidden.bs.modal', function () { p.html(''); });
                        p.modal();
                    } else bootbox.alert(res);
                }
            });
        },
        "orgUserClick": function (p, multi) {
            p.find('.zf-org .zf-org-list input:checkbox').click(function () {
                if ($(this).prop('checked')) {
                    if (multi == 'n') {
                        p.find('.zf-org .zf-org-list input:checkbox[data-for!="' + $(this).attr('data-for') + '"]:checked').prop('checked', false);
                    }

                    var jUser = JSON.parse($(this).attr('data-attr'));
                    $.ajax({
                        type: "POST",
                        url: "/Organ/Plate",
                        data: '{M:"userinfo",urid:"' + jUser['id'] + '",grid:"' + jUser['grid'] + '"}',
                        success: function (res) {
                            if (res.substr(0, 2) == "OK") p.find('.zf-org .zf-org-info .table tbody').html(res.substr(2));
                            else bootbox.alert(res);
                        },
                        beforeSend: function () { } //로딩 X
                    });
                }
            });
        },
    };

    //유틸
    _zw.ut = {
        "round": function (val, precision) {
            val = val * Math.pow(10, precision);
            val = Math.round(val);
            return val / Math.pow(10, precision);
        },
        "floor": function (val, precision) {
            val = val * Math.pow(10, precision);
            val = Math.floor(val);
            return val / Math.pow(10, precision);
        },
        "percent": function (c, p, n) {
            return (parseFloat(_zw.ut.empty(c)) * parseFloat(_zw.ut.empty(p)) / 100).toFixed(n);
        },
        "rate": function (c, p, n) {
            return p == '' || parseFloat(_zw.ut.empty(p)) == 0 ? 0 : (parseFloat(_zw.ut.empty(c)) / parseFloat(_zw.ut.empty(p)) * 100).toFixed(n);
        },
        "empty": function (f) {
            f = f || '';
            var fv = f.toString().replace(/,/gi, ''); if (fv == "") { return 0; } else { return fv; }
        },
        "add": function (n) {
            var iAdd = 0; if (n == '') n = 0;
            if (arguments.length > 1) { for (var i = 1; i < arguments.length; i++) { iAdd = (parseFloat(iAdd) + parseFloat(_zw.ut.empty(arguments[i]))).toFixed(n); } }
            return iAdd;
        },
        "sub": function (n, c) {
            var iSub = (c == '') ? 0 : parseFloat(_zw.ut.empty(c)); if (n == '') n = 0;
            if (arguments.length > 2) { for (var i = 2; i < arguments.length; i++) { iSub = (parseFloat(iSub) - parseFloat(_zw.ut.empty(arguments[i]))).toFixed(n); } }
            return iSub;
        },
        "zero": function (num) {
            if (num < 10) { num = "0" + num; }
            return num;
        },
        "picker": function (kind, p) {
            if (kind == 'date') {
                if ($('.input-daterange').length > 0) {
                    $('.input-daterange').datepicker({
                        autoclose: true,
                        inputs: $('.input-daterange input[type="text"]'),
                        //format: "yyyy-mm-dd",
                        todayHighlight: true, //22-07-14 보류
                        language: $('#current_culture').val()
                    });
                }

                if ($('.datepicker, .datepicker-ko, .datepicker-slash').length > 0) {
                    $('.datepicker').datepicker({
                        autoclose: true,
                        //format: "yyyy-mm-dd",
                        todayHighlight: true, //22-07-14 보류
                        language: $('#current_culture').val()
                    }).on('changeDate', function (e) {
                        if (_zw.fn.onblur) _zw.fn.onblur(e.target, ['date']);
                    });

                    $('.datepicker-slash').datepicker({
                        autoclose: true,
                        format: "yyyy/mm/dd",
                        todayHighlight: true, //22-07-14 보류
                        language: $('#current_culture').val()
                    }).on('changeDate', function (e) {
                        if (_zw.fn.onblur) _zw.fn.onblur(e.target, ['date']);
                    });

                    $('.datepicker-ko').datepicker({
                        autoclose: true,
                        format: "yyyy년 mm월 dd일",
                        todayHighlight: true, //22-07-14 보류
                        language: $('#current_culture').val()
                    }).on('changeDate', function (e) {
                        if (_zw.fn.onblur) _zw.fn.onblur(e.target, ['date']);
                    });
                }
            }
        },
        "maxLength": function (pos) {
            $('.bootstrap-maxlength').each(function () {
                $(this).maxlength({
                    alwaysShow: true,
                    warningClass: 'text-muted',
                    limitReachedClass: 'text-danger',
                    validate: true,
                    placement: pos && pos != '' ? pos : 'top-right-inside',
                    threshold: +this.getAttribute('maxlength')
                });
            });
        },
        "maskInput": function (e) {
            var v = $(e).attr('data-inputmask').split(';'); //console.log('v[0] => ' + v[0])
            if (v[0] == "number" || v[0] == "percent" || v[0] == "number-n" || v[0] == "month") {
                if (v[0] == "month") {
                    vanillaTextMask.maskInput({
                        inputElement: e,
                        mask: textMaskAddons.createNumberMask({
                            prefix: '',
                            suffix: '',
                            integerLimit: 2,
                            allowDecimal: false,
                            decimalLimit: 0
                        })
                    });
                } else {
                    vanillaTextMask.maskInput({
                        inputElement: e,
                        mask: textMaskAddons.createNumberMask({
                            prefix: '',
                            suffix: v[0] == "percent" ? '%' : '',
                            includeThousandsSeparator: v[0] == "number-n" ? false : true,
                            integerLimit: parseInt(v[1]),
                            allowDecimal: parseInt(v[2]) > 0 ? true : false,
                            decimalLimit: parseInt(v[2]) > 0 ? parseInt(v[2]) : 0,
                            allowNegative: v[3] && v[3] == '-' ? true : false
                        })
                    });
                }
            } else if (v[0] == "date" || v[0] == "time" || v[0] == "year") {
                var mv = [];
                if (v[0] == "date") {
                    if (v[1] == 'yyyy') mv = [/[1-2]/, /\d/, /\d/, /\d/];
                    else if (v[1] == 'yyyy/MM/dd') mv = [/[1-2]/, /\d/, /\d/, /\d/, '/', /[0-1]/, /\d/, '/', /[0-3]/, /\d/];
                    else mv = [/[1-2]/, /\d/, /\d/, /\d/, '-', /[0-1]/, /\d/, '-', /[0-3]/, /\d/];
                } else if (v[0] == "time") {
                    mv = v[1] == 'HH:MM' ? [/\d/, /\d/, ':', /\d/, /\d/] : [/\d/, /\d/, ':', /\d/, /\d/, ':', /\d/, /\d/];
                }
                vanillaTextMask.maskInput({
                    inputElement: e,
                    mask: mv,
                    pipe: textMaskAddons.createAutoCorrectedDatePipe(v[1]),
                    guide: false
                });
            }

            $(e).blur(function () {
                _zw.fn.onblur(e, v);
            });
        },
        "destroyInput": function (e) {
            var m = vanillaTextMask.maskInput({ inputElement: e }); m.destroy();
        },
        "hasArrayDupl": function (v) {
            var t = [];
            for (var i in v) {
                if (t.indexOf(v[i]) !== -1) return false;
                t.push(v[i]);
            }
            return true;
        },
        "date": function (d, f, r) {
            if (moment(d).isValid()) {
                return moment(d).format(f);
            } else if (r && r != undefined && r != '' && moment(r).isValid()) {
                return moment(r).format(f);
            } else {
                return '';
            }
        },
        "dateLocale": function (d, f) {
            var rt = '';
            if (moment(d).isValid()) {
                if (f == 'ko') rt = _zw.ut.date(d, 'YYYY년 MM월 DD일');
                else if (f == 'en') {
                    moment.locale('en');
                    rt = _zw.ut.date(d, 'MMMM DD, YYYY');
                    moment.locale($('#current_culture').val());
                } else rt = _zw.ut.date(d, f);
            }
            return rt;
        },
        "diff": function (f, s, e) {
            if (f == 'day') {//console.log(s + " : " + e)
                if (moment(s).isValid() && moment(e).isValid()) return moment(s).diff(moment(e), 'days');
            } else if (f == 'd') {
                if (moment(s).isValid() && moment(e).isValid()) {
                    var d = moment.duration(moment(s).diff(moment(e), 'days'), 'd'); //console.log(d);
                    return [d.years(), d.months(), d.days()];
                }
            } else if (f == 'min') {
                if (moment(s).isValid() && moment(e).isValid()) return moment(s).diff(moment(e), 'minutes');
            }
        },
        "toBR": function (s) {
            return s.replace(/ /gim, '&nbsp;').replace(/\n/gim, '<br />');
        },
        "emSpace": function (s) {
            if (s && $.trim(s) != '') {
                var r = /\t/gi; s = s.replace(r, ' '); //1차 탭 -> 공백
                r = /\n/gi; s = s.replace(r, ' '); //2차 줄바꿈 -> 공백
                r = /  /gi; s = s.replace(r, ' '); //3차 2개연속 공백 -> 공백
                r = /  /gi; s = s.replace(r, ' '); //4차 2개연속 공백 -> 공백
            } else s = '';
            return s;
        },
        "getCookie": function (name) {
            name = name + '=';
            var cookieData = document.cookie;
            var start = cookieData.indexOf(name);
            var cookieValue = '';
            if (start != -1) {
                start += name.length;
                var end = cookieData.indexOf(';', start);
                if (end == -1) end = cookieData.length;
                cookieValue = cookieData.substring(start, end);
            }

            return unescape(cookieValue);
            //var value = document.cookie.match('(\;|^)[^;]*(' + name + ')\=([^;]*)(;|$)'); alert(value)
            //return value ? value[2] : null;
        },
        "setCookie": function (name, value, exp) {
            //var date = new Date();
            //date.setTime(date.getTime() + exp * 24 * 60 * 60 * 1000);
            //document.cookie = name + '=' + value + ';expires=' + date.toUTCString() + ';path=/';

            var exdate = new Date();
            exdate.setDate(exdate.getDate() + exp);
            var cookieValue = escape(value) + ((exp == null) ? "" : "; expires=" + exdate.toGMTString());
            document.cookie = name + "=" + cookieValue;
        },
        "deleteCookie": function (name) {
            //document.cookie = name + '=; expires=Thu, 01 Jan 1999 00:00:10 GMT;';
            var expireDate = new Date();
            expireDate.setDate(expireDate.getDate() - 1);
            document.cookie = name + "= " + "; expires=" + expireDate.toGMTString();
        },
        "openWnd": function (url, wnd, w, h, etc) {
            w = w || 0; h = h || 0;

            if (w == 0 || h == 0) {
                window.open(url, wnd);

            } else {
                var sx = window.screen.width / 2 - w / 2, sy = window.screen.height / 2 - h / 2 - 40;

                if (etc == 'fix') {
                    etcParam = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0";
                } else {
                    etcParam = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1";
                }

                if (sy < 0) sy = 0;
                var sz = ",top=" + sy + ",left=" + sx;

                if (wnd == "newMessageWindow") {
                    wnd = new String(Math.round(Math.random() * 100000));
                }
                window.open(url, wnd, etcParam + ",width=" + w + ",height=" + h + sz);
            }
        },
        "hideRightBar": function () {
            if ($('.messages-wrapper, .messages-card').hasClass('messages-sidebox-open')) $('.z-mobile-navbar button.close').click();
            if ($('#layout-navbar-rightbar').hasClass('show')) $('#layout-navbar-rightbar').modal('hide');
        },
        "ctrls": function () {
            var el = _zw.ut.eventBtn(), ctrl = el.attr('aria-controls');
            if (ctrl != '') {
                var tgt = $('[data-controls="' + ctrl + '"]');

                if (ctrl == 'vw-full-fill') {
                    if (tgt.hasClass('modal')) {
                        tgt.removeClass('modal'); $(el).find('i').removeClass('fa-compress').addClass('fa-expand');
                    } else {
                        tgt.addClass('modal'); $(el).find('i').removeClass('fa-expand').addClass('fa-compress');
                    }
                    if (_zw.Fc) _zw.Fc.updateSize();
                } else if (ctrl == 'vw-search-cond') {
                    tgt.toggleClass('d-none');
                    if ($(el).find('i').hasClass('fa-angle-down')) $(el).find('i').removeClass('fa-angle-down').addClass('fa-angle-up');
                    else $(el).find('i').removeClass('fa-angle-up').addClass('fa-angle-down');
                }
            }
        },
        "eventBtn": function () {//버튼 클릭시 버튼요소 반환
            var el = $(event.target); if (el.prop('tagName') == 'I' || el.prop('tagName') == 'SPAN') el = el.parent();
            return el;
        },
        "ajaxLoader": function (b, s) {
            if (b) {
                var ttl = s && s != '' ? s : 'Loading ...';
                $('#ajaxLoader .modal-title').html(ttl);
            }

            b ? $('#ajaxLoader').modal('show') : $('#ajaxLoader').modal('hide');

            //아래 구문 ajax event 미동작
            //if (b) {
            //    bootbox.dialog({
            //        message: $('.modal-ajaxloader').html(),
            //        closeButton: false,
            //        className: 'bootbox-ajax',
            //        centerVertical: true
            //    });
            //} else {
            //    bootbox.hideAll();
            //}
        },
        "isMobile": function () {
            return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Windows Phone|Opera Mini/i.test(navigator.userAgent);
        },
        "popup": function (el, option) {// p : 팝업창 기준 요소(예: $('#__FormView .z-list-scroll'))
            var autoComplete = option.autoComplete || false;
            if (autoComplete && $('.z-pop').length > 0) { //자동완성 경우 여러번 ajax 호출이 일어나게 됨
                $('.z-pop .z-pop-body > div').html(option.content);
                return $('.z-pop');
            }

            var ttl = option.title ? option.title : '';
            var bClose = option.close || false;
            var footer = option.footer ? option.footer : '';

            var w = option.width, h = option.height + 40, l = option.left || 0;
            var offset = $(el).offset(); //console.log($(el).offsetParent())
            var p = $('body');
            var iST = p.scrollTop(), iSL = p.scrollLeft();
            var iBH = p.outerHeight(), iBW = p.outerWidth();
            //var iT = offset.top, iL = offset.left;

            //var iH = iT + iST - 20, iW = iL + iSL - 8;
            //iH = iBH - 40 - h + iST; iW = iW = iBW - 16 - w;
            //if (iT + h > iBH) { iH = iBH - 40 - h; } //else if (iH < 0) { iH = iT; }
            //if (iL + w > iBW) { iW = iBW - 16 - w + iSL; } //else if (iW < 0) { iW = iL; }

            var iT = offset.top + $(el).outerHeight() - iST, iL = offset.left - iSL;
            if (iT + h > iBH) { iT = iBH - h; } else if (iT < 0) { iT = 0; }
            if (iL + w > iBW) { iL = iBW - w; } else if (iL < 0) { iW = 0; }
            //iH -= h / 2; iW -= w / 2;

            //console.log(iST + " : " + iSL + " : " + iBH + " : " + iBW + " : " + iT + " : " + iL + " : " + iH + " : " + iW)
            var back = '<div class="modal-backdrop fade show"></div>';
            var s = '<div class="z-pop" role="modal" tabindex="-1">';
            if (ttl != '' || bClose) {
                s += '<div class="z-pop-header">';
                s += '<div class="z-pop-title">' + ttl + '</div>';
                if (bClose) s += '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>';
                s += '</div>';
            }
            s += '<div class="z-pop-body"><div style="overflow-y: auto; max-height: ' + (autoComplete ? h - 6 : h - 40) + 'px">' + option.content + '</div></div>';
            if (footer != '') s += '<div class="z-pop-footer">' + footer + '</div>';
            s += '</div>';

            var m = $(s).css({ "top": iT, "left": iL + l, "width": w, "height": h }).show();
            m.find('.close[data-dismiss="modal"]').click(function () { $('.modal-backdrop').remove(); m.remove(); });

            if (autoComplete) {
                p.append(m); m.on('mouseover', function () { m.focus(); }); m.blur(function () { m.remove(); });
                //$(el).blur(function () { m.remove(); });
            } else p.append(back).append(m);

            m.draggable();
            return m;
        }
    };

}());
