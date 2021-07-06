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
    Waves.attach('a, .btn', 'waves-light'); Waves.init();

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

    $('.sidenav-item[data-navmenu]').on('click', function () {
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
            default:
                break;
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

    };

    //함수
    _zw.fn = {

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
            
        }
    };

}());
