$(function () {
    if (window.layoutHelpers) {

        // Auto update layout
        window.layoutHelpers.setAutoUpdate(true);

        // Collapse menu
        if ($('#layout-sidenav').hasClass('sidenav-horizontal') || window.layoutHelpers.isSmallScreen()) {
            return;
        }

        try {
            window.layoutHelpers.setCollapsed(true,false);
        } catch (e) { }
    }
});

$(function () {
    // Initialize sidenav
    $('#layout-sidenav').each(function () {
        new SideNav(this, {
            orientation: $(this).hasClass('sidenav-horizontal') ? 'horizontal' : 'vertical'
        });
    });

    // Initialize sidenav togglers
    $('body').on('click', '.layout-sidenav-toggle', function (e) {
        e.preventDefault();
        window.layoutHelpers.toggleCollapsed();
    });

    // Swap dropdown menus in RTL mode
    if ($('html').attr('dir') === 'rtl') {
        $('#layout-navbar .dropdown-menu').toggleClass('dropdown-menu-right');
    }

    // Message-sidebox ==========>
    $('.messages-scroll').each(function () {
        new PerfectScrollbar(this, {
            suppressScrollX: false,
            wheelPropagation: true
        });
    });

    //$('.messages-sidebox-toggler').click(function (e) {
    //    e.preventDefault();
    //    $('.messages-wrapper, .messages-card').toggleClass('messages-sidebox-open');
    //});

    $('.navbar-toggler, .messages-sidebox-toggler').click(function (e) {
        e.preventDefault();

        //alert($('.layout-content').find('.messages-wrapper').length)

        if ($('.layout-content').find('.messages-wrapper').length > 0) {
            //alert($('.messages-wrapper, .messages-card').hasClass('messages-sidebox-open'))

            if ($('.messages-wrapper, .messages-card').hasClass('messages-sidebox-open')) $('#layout-navbar-rightbar .modal-dialog').append($('.messages-sidebox .z-mobile-navbar .modal-content'));
            //else $('.messages-sidebox .z-mobile-navbar').html($('#layout-navbar-rightbar .modal-content').html());
            else {
                $('.messages-sidebox .z-mobile-navbar').append($('#layout-navbar-rightbar .modal-content')); $('[data-toggle="tooltip"]').tooltip();
            }

            $('.messages-wrapper, .messages-card').toggleClass('messages-sidebox-open');

        } else {
            $('#layout-navbar-rightbar').modal('show');
        }
    });

    //$('.messages-sidebox').on('show.bs.modal', function (e) {
    //    $('.messages-sidebox .z-mobile-navbar').html($('#layout-navbar-rightbar .modal-content').html());
    //    $(this).addClass('mobile');
    //});

    $('.messages-sidebox').on('hidden.bs.modal', function (e) {
        //$('.messages-sidebox .z-mobile-navbar').html('');
        $('#layout-navbar-rightbar .modal-dialog').append($('.messages-sidebox .z-mobile-navbar .modal-content'));

        //$(this).removeClass('mobile');
        $(this).css('display', '');
        //$(this).css('transform', 'translateX(-15%)');
        //$(this).css('-ms-transition', 'transform .2s ease-out');
        //$(this).css('-webkit-transition', 'transform .2s ease-out');

        $('.messages-wrapper, .messages-card').removeClass('messages-sidebox-open');
    });

    $('.linksite-toggler').click(function (e) {
        //e.preventDefault();
        //$('#layout-navbar-rightbar').modal('hide');
        $('#__linkSite').modal('show');
    });
    // <========== Message-sidebox

    // wave
    Waves.attach('.app-brand, .sidenav-item a, .btn, .z-wave', 'waves-light'); Waves.init();

    // bootbox
    bootbox.setDefaults({
        locale: $('#current_culture').val(), //"ko",
        //centerVertical: true,
        size: "sm"
    });

    //bootbox.setLocale({ locale: "ko", values: { OK: "확인", CANCEL: "취소", CONFIRM: "확인" }});

    // jquery ajax setup
    $.ajaxSetup({
        error: function (res) {
            if (res.status == 403) {
                //alert(JSON.parse(res.responseText));
                window.location.reload();
            } else {
                bootbox.alert({ title: "Ajax Error", message: res.responseText});
            }
        },
        failure: function (res) {
            bootbox.alert({ title: "Ajax Failure", message: res.responseText });
        },
        beforeSend: function () {
            _zw.ut.ajaxLoader(true);
        },
        complete: function (res) {
            _zw.ut.ajaxLoader(false);
        }
    });

    $('.modal-ajaxloader .modal-title').html('Loading ...');

    $('[data-toggle="popover"]').popover();
    $('[data-toggle="tooltip"]').tooltip();

    $('.sidenav-item[data-navmenu], .sidenav-header .sidenav-link[data-navmenu], .navbar-nav .nav-link[data-navmenu], .navbar-nav .dropdown-item[data-navmenu], #layout-navbar-rightbar .dropdown-item[data-navmenu], #layout-navbar-rightbar a[data-navmenu]').on('click', function () {
        switch ($(this).attr('data-navmenu')) {
            case "mail":
                _zw.ut.openWnd("https://email.cresyn.com/owa ", "owaWim");
                break;
            case "erp":
                _zw.ut.openWnd("/Portal/SSOerp", "erpWin");
                break;
            case "messenger":
                var url = "http://meeting.cresyn.com/app/?uid=";
                _zw.ut.openWnd(url, "meeting", 800, 500, "fix");
                break;
            case "external.post": //alert($('#auth_external').val()); return;
                var url = "http://192.168.100.35:8080/login?USER_ID=" + $('#auth_external').val() + "&LOGIN_DIV=S";
                _zw.ut.openWnd(url, "externalWin");
                break;
            case "edm.new":
                _zw.ut.ajaxLoader(true, "불러오는 중..")
                //bootbox.alert("문서관리 신규 문서 등록", function () { _zw.ut.ajaxLoader(false) });
                break;
            case "ea.newdoc":
                bootbox.confirm("전자결재 신규 양식 작성 하시겠습니까?", function (rt) { alert(rt) });
                break;
            case "locale": //언어설정
                $.ajax({
                    type: "POST",
                    url: "/Portal/locale",
                    data: '{locale:"' + $(this).attr('data-navval') + '"}',
                    success: function (res) {
                        if (res == "OK") window.location.reload();
                        else bootbox.alert(res);
                    }
                });
                break;
            case "workstatus": //근무상태
                $('#popWorkStatus').on('show.bs.modal', function (e) {
                    $(this).find('.btn').click(function () {
                        
                        if ($(this).attr('data-zm-menu') == 'save') {
                            bootbox.alert($(this).attr('data-zm-menu'));
                        } else if ($(this).attr('data-zm-menu') == 'form') {
                            bootbox.alert($(this).attr('data-zm-menu'));
                        } else if ($(this).attr('data-zm-menu') == 'offwork') {
                            bootbox.alert($(this).attr('data-zm-menu'));
                        }

                    });
                }).modal();
                break;
            case "phonenum": //전화번호 찾기
                bootbox.alert('준비중!');
                break;
            case "myinfo": //개인정보
                bootbox.alert('준비중!');
                break;
            case "alarm": //알람
                bootbox.alert('준비중!');
                break;
            default:
                break;
        }
    });

    //근무 시간 조회
    if (_zw.V.current && _zw.V.current.ws != 'N/A' && _zw.V.current.urid != '') {
        _zw.fn.getTotalWorkTime();
    }
});

$(function () {
    // logon page
    var userId = _zw.ut.getCookie("accountField"); //console.log('cookie -> ' + userId)
    if (userId && userId != 'null' && userId != '') {
        $("#LoginId").val(userId);
        $("#RememberMe").prop('checked', true);
        $("#Password").focus();
    } else {
        $("#LoginId").focus();
    }

    $("#loginForm").submit(function () {
        //console.log(event);

        if ($("#RememberMe").prop('checked')) {
            _zw.ut.setCookie("accountField", $("#LoginId").val(), 30); //30일
        } else {
            _zw.ut.deleteCookie("accountField");
        }

        //event.cancelBubble = true;
        //event.preventDefault();
    });

    $("[data-password]").on('click', function () {
        if ($(this).attr('data-password') == "false") {
            $(this).siblings("input").attr("type", "text");
            $(this).attr('data-password', 'true');
            $(this).addClass("show-password");
        } else {
            $(this).siblings("input").attr("type", "password");
            $(this).attr('data-password', 'false');
            $(this).removeClass("show-password");
        }
    });
});

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
        "readMsg": function (m) {
            var el, p;
            m = m || '';
            if (m == 'prev') {
                _zw.V.appid = _zw.V.app.next;
            } else if (m == 'next') {
                _zw.V.appid = _zw.V.app.prev;
            } else {
                el = event.target ? event.target : event.srcElement; //alert(el.outerHTML)
                p = $(el).parent().parent();

                _zw.V.appid = p.attr('appid');
                //_zw.V.ttl = $(el).text();
            }

            if (_zw.V.appid == '' || _zw.V.appid == '0') return false;

            var postData = _zw.fn.getAppQuery(_zw.V.fdid); //alert(encodeURIComponent(postData)); return
            console.log(postData)
            var url = _zw.V.current.page + '?qi=' + _zw.base64.encode(postData);

            if (_zw.V.current.page.toLowerCase() == '/board/read') {
                $.ajax({
                    type: "POST",
                    url: url,
                    success: function (res) {
                        if (res.substr(0, 2) == "OK") {
                            history.pushState(null, null, url);

                            var v = res.substr(2).split(_zw.V.lv.boundary);
                            $('#__FormView').html(v[0]);
                            _zw.V.app = JSON.parse(v[1]);

                            window.document.title = _zw.V.app['subject'];

                        } else bootbox.alert(res);
                    }
                });
            } else {
                _zw.V.xfalias = p.attr('xf');
                _zw.V.current.acl = p.attr('acl');

                window.location.href = '/Board/Read?qi=' + _zw.base64.encode(postData);
            }
            
        }
    };

    //함수
    _zw.fn = {
        "org": function () {
            alert("org")
        },
        "view": function () {
            $.ajax({
                type: "POST",
                url: "/Common/AddViewCount",
                data: '{xf:"' + _zw.V.xfalias + '",fdid:"' + _zw.V.fdid + '",mi:"' + _zw.V.appid + '",urid:"' + _zw.V.current.urid + '"}',
                success: function (res) {
                    if (res != "OK") console.log(res);
                }
            });
        },
        "getTotalWorkTime": function () {
            $.ajax({
                type: "POST",
                url: "/ExS/WorkTime/TotalTime",
                data: '{ur:"' + _zw.V.current.urid + '",wd:"' + _zw.V.current.date + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == 'OK') {
                        var v = res.substr(2).split('^'), txt = '';
                        var nH = 0, tH = 0, rH = 0, eH = 0;

                        $('#__CalcWorkTime span').each(function (idx, e) {
                            //console.log(idx + ' : ' + $(this).text());
                            if (idx == 0) {
                                temp = v[idx + 1].split(';'); txt = temp[0] + "시간 " + temp[1] + "분";
                                nH = _zw.ut.floor(parseFloat(parseInt(temp[0]) * 60 + parseInt(temp[1])) / 60, 1);

                            } else if (idx == 1) {
                                if (v[5].indexOf('.') >= 0) {
                                    temp = v[5].split('.'); txt = (temp[0] == '' ? "0" : temp[0]) + "시간 " + (parseFloat("0." + temp[1]) * 60).toFixed(0) + "분";
                                } else txt = (v[5] == '' ? "0" : v[5]) + "시간 0분";
                                
                            } else if (idx == 2) {
                                temp = v[2].split(';'); txt = temp[0] + "시간 " + temp[1] + "분";
                                tH = _zw.ut.floor(parseFloat(parseInt(temp[0]) * 60 + parseInt(temp[1])) / 60, 1);
                            }

                            $(this).html(txt)
                        });

                        rH = _zw.ut.floor(parseFloat(v[3]), 1);
                        eH = _zw.ut.floor(parseFloat((v[4] == '' ? "0" : v[4])), 1);
                        
                        _zw.fn.progBar(rH, eH);

                    } else console.log(res);
                },
                beforeSend: function () { //로딩 X
                }
            });
            var t = setTimeout(_zw.fn.getTotalWorkTime, 600000); //10분
        },
        "progBar": function (real, ex) {
            if (real == '' || isNaN(real)) return false;

            var min = _zw.V.current["minhour"], max = _zw.V.current["maxhour"], extra = _zw.V.current["extrahour"];

            var barLen = _zw.ut.rate(real, min, 1) + "%";
            var barText = _zw.ut.rate(real, min, 1) + "% (" + real + "h)";

            $('.progress-bar[data-for="realhour"]').css('width', barLen);
            $('.progress-bar[data-for="realhour-text"]').html(barText);

            barLen = _zw.ut.rate(ex, extra, 1);
            barText = _zw.ut.rate(ex, extra, 1) + "% (" + ex + "h)";

            var barColor = '';
            if (barLen < 51) barColor = 'progress-bar-success';
            else if (barLen < 71) barColor = 'progress-bar-warning';
            else barColor = 'progress-bar-danger';

            $('.progress-bar[data-for="extrahour-text"]').html(barText)
            $('.progress-bar[data-for="extrahour"]').addClass(barColor);

            if (barLen > 100) barLen = 100;
            $('.progress-bar[data-for="extrahour"]').css('width', barLen + '%');
        },
        "getAppQuery": function (tgt) {
            var j = {};
            j["ct"] = _zw.V.ct;
            j["ctalias"] = _zw.V.ctalias;
            j["ot"] = _zw.V.ot;
            j["alias"] = _zw.V.alias;
            j["xfalias"] = _zw.V.xfalias;
            j["fdid"] = _zw.V.fdid;
            j["appid"] = _zw.V.appid;
            j["acl"] = _zw.V.current.acl;
            j["opnode"] = _zw.V.opnode;
            j["ft"] = _zw.V.ft;
            j["ttl"] = _zw.V.ttl;


            j["tgt"] = tgt;
            j["page"] = _zw.V.lv.page;
            j["count"] = _zw.V.lv.count;
            j["sort"] = _zw.V.lv.sort;
            j["sortdir"] = _zw.V.lv.sortdir;
            j["search"] = _zw.V.lv.search;
            j["searchtext"] = _zw.V.lv.searchtext;
            j["start"] = _zw.V.lv.start;
            j["end"] = _zw.V.lv.end;
            j["basesort"] = _zw.V.lv.basesort;
            j["boundary"] = _zw.V.lv.boundary;

            //alert(j["permission"])
            return JSON.stringify(j);
        }
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
            return (parseFloat(c) * parseFloat(p) / 100).toFixed(n);
        },
        "rate": function (c, p, n) {
            return (c / p * 100).toFixed(n);
        },
        "empty": function (f) {
            f = f || '';
            var fv = f.toString().replace(/,/gi, ''); if (fv == "") { return 0; } else { return fv; }
        },
        "add": function (n) {
            var iAdd = 0; if (n == '') n = 0;
            if (arguments.length > 1) { for (var i = 1; i < arguments.length; i++) { iAdd = (parseFloat(iAdd) + parseFloat(_WTM.util.empty(arguments[i]))).toFixed(n); } }
            return iAdd;
        },
        "sub": function (n, c) {
            var iSub = (c == '') ? 0 : parseFloat(_WTM.util.empty(c)); if (n == '') n = 0;
            if (arguments.length > 2) { for (var i = 2; i < arguments.length; i++) { iSub = (parseFloat(iSub) - parseFloat(_WTM.util.empty(arguments[i]))).toFixed(n); } }
            return iSub;
        },
        "maskInput": function (e) {
            var v = $(e).attr('data-zf-inputmask').split(';');
            if (v[0] == "number" || v[0] == "percent") {
                vanillaTextMask.maskInput({
                    inputElement: e,
                    mask: textMaskAddons.createNumberMask({
                        prefix: '',
                        suffix: v[0] == "percent" ? '%' : '',
                        integerLimit: parseInt(v[1]),
                        allowDecimal: parseInt(v[2]) > 0 ? true : false,
                        decimalLimit: parseInt(v[2]) > 0 ? parseInt(v[2]) : 0,
                        allowNegative: v[3] == '-' ? true : false
                    })
                });
            } else if (v[0] == "date" || v[0] == "time") {
                var mv = [];
                if (v[0] == "date") mv = [/[1-2]/, /\d/, /\d/, /\d/, '-', /[0-1]/, /\d/, '-', /[0-3]/, /\d/];
                else if (v[0] == "time") mv = [/\d/, /\d/, ':', /\d/, /\d/, ':', /\d/, /\d/];
                vanillaTextMask.maskInput({
                    inputElement: e,
                    mask: mv,
                    pipe: textMaskAddons.createAutoCorrectedDatePipe(v[1]),
                    guide: false
                });
            }

            $(e).blur(function () {
                //_ZF.fn.onblur(e, v);
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
        "ajaxLoader": function (b) {
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
        }               
    };

    //Base64 Encode, Decode
    _zw.base64 = {
        // private property
        _keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",

        // public method for encoding
        encode: function (input) {
            var output = "";
            var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
            var i = 0;

            input = _zw.base64._utf8_encode(input);

            while (i < input.length) {

                chr1 = input.charCodeAt(i++);
                chr2 = input.charCodeAt(i++);
                chr3 = input.charCodeAt(i++);

                enc1 = chr1 >> 2;
                enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
                enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
                enc4 = chr3 & 63;

                if (isNaN(chr2)) {
                    enc3 = enc4 = 64;
                } else if (isNaN(chr3)) {
                    enc4 = 64;
                }

                output = output +
                    this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) +
                    this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);

            }

            return output;
        },

        // public method for decoding
        decode: function (input) {
            var output = "";
            var chr1, chr2, chr3;
            var enc1, enc2, enc3, enc4;
            var i = 0;

            input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

            while (i < input.length) {

                enc1 = this._keyStr.indexOf(input.charAt(i++));
                enc2 = this._keyStr.indexOf(input.charAt(i++));
                enc3 = this._keyStr.indexOf(input.charAt(i++));
                enc4 = this._keyStr.indexOf(input.charAt(i++));

                chr1 = (enc1 << 2) | (enc2 >> 4);
                chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
                chr3 = ((enc3 & 3) << 6) | enc4;

                output = output + String.fromCharCode(chr1);

                if (enc3 != 64) {
                    output = output + String.fromCharCode(chr2);
                }
                if (enc4 != 64) {
                    output = output + String.fromCharCode(chr3);
                }
            }

            output = _zw.base64._utf8_decode(output);

            return output;

        },

        // private method for UTF-8 encoding
        _utf8_encode: function (string) {
            string = string.replace(/\r\n/g, "\n");
            var utftext = "";

            for (var n = 0; n < string.length; n++) {

                var c = string.charCodeAt(n);

                if (c < 128) {
                    utftext += String.fromCharCode(c);
                }
                else if ((c > 127) && (c < 2048)) {
                    utftext += String.fromCharCode((c >> 6) | 192);
                    utftext += String.fromCharCode((c & 63) | 128);
                }
                else {
                    utftext += String.fromCharCode((c >> 12) | 224);
                    utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                    utftext += String.fromCharCode((c & 63) | 128);
                }
            }

            return utftext;
        },

        // private method for UTF-8 decoding
        _utf8_decode: function (utftext) {
            var string = "";
            var i = 0;
            var c = c1 = c2 = 0;

            while (i < utftext.length) {

                c = utftext.charCodeAt(i);

                if (c < 128) {
                    string += String.fromCharCode(c);
                    i++;
                }
                else if ((c > 191) && (c < 224)) {
                    c2 = utftext.charCodeAt(i + 1);
                    string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                    i += 2;
                }
                else {
                    c2 = utftext.charCodeAt(i + 1);
                    c3 = utftext.charCodeAt(i + 2);
                    string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                    i += 3;
                }
            }

            return string;
        }
    }

}());


