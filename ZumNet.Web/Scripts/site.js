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
        $('#__linkSite').on('hidden.bs.modal', function (e) {
            _zw.ut.hideRightBar();
        }).modal();
    });
    // <========== Message-sidebox

    // wave
    Waves.attach('.app-brand, .sidenav-item a, .btn:not(.zc-bar .btn), .z-wave', 'waves-light'); Waves.init();

    // bootbox
    bootbox.setDefaults({
        locale: $('#current_culture').val(), //"ko",
        //centerVertical: true,
        size: "sm"
    });

    // moment
    moment.locale($('#current_culture').val());

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
    $('.modal:not(.modal-ajaxloader)').draggable({ handle: ".modal-header" });

    $('[data-toggle="popover"]').popover();
    $('[data-toggle="tooltip"][title!=""]').tooltip();

    $('.sidenav-item[data-navmenu], .sidenav-header .sidenav-link[data-navmenu], .navbar-nav .nav-link[data-navmenu], .navbar-nav .dropdown-item[data-navmenu], #layout-navbar-rightbar .dropdown-item[data-navmenu], #layout-navbar-rightbar a[data-navmenu]').on('click', function () {
        switch ($(this).attr('data-navmenu')) {
            case "mail":
                _zw.ut.openWnd("https://mail.cresyn.com/owa ", "owaWim");
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
                _zw.mu.writeMsg('doc');
                //bootbox.alert("문서관리 신규 문서 등록", function () { _zw.ut.ajaxLoader(false) });
                break;
            case "ea.newdoc":
                _zw.fn.newEAForm();
                break;
            case "locale": //언어설정
                $.ajax({
                    type: "POST",
                    url: "/Portal/locale",
                    data: '{locale:"' + $(this).attr('data-navval') + '"}',
                    success: function (res) {
                        if (res == "OK") window.location.reload();
                        else bootbox.alert(res);
                    },
                    beforeSend: function () { } //로딩 X
                });
                break;
            case "workstatus": //근무상태
                //_zw.fn.autoWorkStatus();
                _zw.fn.openWorkStatus();
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

        _zw.ut.hideRightBar();
    });

    //ListView Menu
    _zw.ut.picker('date');

    _zw.ut.maxLength();

    //if ($('.datepicker').length > 0) {
    //    $('.datepicker').datepicker({
    //        autoclose: true,
    //        //format: "yyyy-mm-dd",
    //        language: $('#current_culture').val()
    //    });
    //}

    //$('.bootstrap-maxlength').each(function () {
    //    $(this).maxlength({
    //        alwaysShow: true,
    //        warningClass: 'text-muted',
    //        limitReachedClass: 'text-danger',
    //        validate: true,
    //        placement: 'top-right-inside',
    //        threshold: +this.getAttribute('maxlength')
    //    });
    //});

    $('.z-lv-menu .btn[data-zv-menu], .z-lv-search .btn[data-zv-menu]').click(function () {
        var mn = $(this).attr('data-zv-menu');
        if (mn != '') _zw.mu[mn]();
    });

    $('.z-lv-search input.search-text').keyup(function (e) {
        if (e.which == 13) _zw.mu.search();
    });

    $('#__ListViewPage li a.page-link').click(function () {//.pagination => #__ListViewPage (리스트뷰 경우 적용)
        _zw.mu.search($(this).attr('data-for'));
    });

    $('.z-lv-cnt select').change(function () {
        _zw.fn.setLvCnt($(this).val());
    });

    $('.z-lv-hdr input:checkbox').click(function () {
        var b = $(this).prop('checked');
        $('#__ListView input:checkbox').each(function () {
            $(this).prop('checked', b);
        });
    });

    $('.z-lv-hdr a[data-val]').click(function () {
        var t = $(this); _zw.V.lv.sort = t.attr('data-val');
        $('.z-lv-hdr a[data-val]').each(function () {
            if ($(this).attr('data-val') == _zw.V.lv.sort) {
                var c = t.find('i');
                if (c.hasClass('fe-arrow-up')) {
                    c.removeClass('fe-arrow-up').addClass('fe-arrow-down'); _zw.V.lv.sortdir = 'DESC';
                } else {
                    c.removeClass('fe-arrow-down').addClass('fe-arrow-up'); _zw.V.lv.sortdir = 'ASC';
                }
            } else {
                $(this).find('i').removeClass();
            }
        });
        //console.log('::' + JSON.stringify(_zw.V))
        _zw.V.lv.tgt = _zw.V.fdid;
        _zw.fn.loadList();
    });

    //Common Form Menu
    //_zw.fn.input();
    
    $('.btn[data-zf-menu="openClassWnd"]').click(function () {
        var ttl = $(this).prev().html();

        $('#popLayer').on('show.bs.modal', function (e) {
            //var w = ''
            //if ($(this).attr("data-width") && parseInt($(this).attr("data-width")) > 0) w = ' style="width: ' + $(this).attr("data-width") + 'px;"';
            //var s = '<div class="modal-dialog modal-dialog-scrollable"' + w + '>'
            //    + '<div class="modal-content">'
            //    + '<div class="modal-header">'
            //    + '<h6 class="modal-title">' + ttl + '</h6>'
            //    + '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>'
            //    + '</div>'
            //    + '<div class="modal-body"><div id="__ClassTree"></div></div>'
            //    + '<div class="modal-footer">'
            //    + '<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>'
            //    + '<button type="button" class="btn btn-primary">Understood</button>'
            //    + '</div>'
            //    + '</div>'
            //    + '</div>'
            //$(this).html(s);

            $(this).find('.modal-title').html(ttl);
            $(this).find('.modal-body').html('<div id="__ClassTree"></div>');
            var pAdd = $(this).find('.modal-footer div[data-for="zf-addinfo"]');
            pAdd.html('<input type="text" class="form-control text-danger" data-for="addinfo" value="" /><input type="hidden" data-for="addinfo2" value="" /><input type="hidden" data-for="addinfo3" value="" />');

            if ($(this).attr("data-width") && parseInt($(this).attr("data-width")) > 0) $(this).find(".modal-dialog").css("width", $(this).attr("data-width") + "px");

            var cSelect = pAdd.find('input[data-for="addinfo"]'), cSelect2 = pAdd.find('input[data-for="addinfo2"]'), cSelect3 = pAdd.find('input[data-for="addinfo3"]');

            $('#__ClassTree').jstree(_zw.T.tree)
                .on("select_node.jstree", function (e, d) {
                    var n = d.instance.get_node(d.selected);
                    var vId = n.id.split('.');
                    var vPath = d.instance.get_path(d.selected[0]).join(' / ');

                    //console.log(vPath + " : " + n.li_attr.objecttype + " : " + n.li_attr.acl.substr(10, 1) + " : " + n.li_attr.xfalias)

                    if (n.li_attr.objecttype == 'G' && n.li_attr.acl.substr(10, 1) == 'W'
                        && ((_zw.V.xfalias == '' && (n.li_attr.xfalias == 'notice' || n.li_attr.xfalias == 'bbs'))
                            || (_zw.V.xfalias == n.li_attr.xfalias)
                        )) {

                        if (_zw.V.current.operator == 'Y' || n.li_attr.acl.substr(10, 1) == 'W') {
                            cSelect.val(vPath); cSelect2.val(vId[vId.length - 1]); cSelect3.val(n.li_attr.xfalias);
                        } else {
                            cSelect.val('Not Permission!'); cSelect2.val(''); cSelect3.val('');
                        }
                    } else {
                        cSelect.val('Mismatched Folder!!'); cSelect2.val(''); cSelect3.val('');
                    }
            })

            $(this).find('.btn[data-zm-menu="confirm"]').click(function () {
                $('#__FormView input[data-for="SelectedFolderPath"]').val(cSelect.val());
                $('#__FormView input[data-for="SelectedFolder"]').val(cSelect2.val());
                $('#__FormView input[data-for="SelectedXFAlias"]').val(cSelect3.val());

                $('#popLayer').modal('hide');
            });
        }).modal();
    });    

    //메인창에서만 실행!!!!!
    if ($('#layout-navbar').length > 0) {
        //근무 시간 조회, 근무 상태 자동 알림
        if (_zw.V.current && _zw.V.current != undefined && _zw.V.current.ws != undefined && _zw.V.current.ws != 'N/A' && _zw.V.current.urid != '') {
            _zw.fn.getTotalWorkTime(); _zw.fn.autoWorkStatus();
            //console.log('timer => getTotalWorkTime + autoWorkStatus')
        }

        //Browser Resize
        $(window).resize(function () {
            //console.log('resize : ' + $(this).height())
            //if ($('#__DextEditor').length > 0) {//editor position
            //    _zw.T.editor.top = $('.zf-editor').prev().outerHeight() + 8;
            //    $('#__DextEditor').css('top', _zw.T.editor.top + 'px');
            //}
        });
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

    $("#loginForm").submit(function() {
        //console.log(event);

        if ($("#RememberMe").prop('checked')) {
            _zw.ut.setCookie("accountField", $("#LoginId").val(), 30); //30일
        } else {
            _zw.ut.deleteCookie("accountField");
        }

        //event.cancelBubble = true;
        //event.preventDefault();
    });

    $("[data-password]").on('click', function() {
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

    _zw.T = {   //사용할 템플릿, 값
        "tree": {
            core: {
                check_callback: true,
                data: {
                    type: 'POST',
                    url: '/Common/Tree',
                    data: function (node) {
                        var lvl = node.id == '#' ? '0' : node.li_attr.level;
                        var selType = node.id == '#' ? '' : node.li_attr.objecttype;
                        var acl = node.id == '#' ? _zw.V.current.acl : node.li_attr.acl;
                        var openNode = '';
                        if (_zw.V.opnode != '' && _zw.V.opnode.indexOf('.') != -1) {
                            var v = _zw.V.opnode.split('.');
                            openNode = node.id == v[v.length - 1] ? '' : _zw.V.opnode;
                        }

                        return '{ct:"' + _zw.V.ct + '",selected:"' + node.id + '",seltype:"' + selType + '",lvl:"' + lvl + '",open:"' + openNode + '",acl:"' + acl + '"}'
                    },
                    dataType: 'json',
                    beforeSend: function () { } //로딩 X
                }
            },
            plugins: ["types", "wholerow"],
            //plugins: ["dnd", "massload", "search", "state", "types", "unique", "wholerow", "changed", "conditionalselect"]
            types: {
                default: { icon: "fas fa-folder" },
                folder: { icon: "fas fa-folder text-warning" },
                //fdopen: { icon: "fas fa-folder-open text-warning" },
                group: { icon: "fas fa-user-friends text-facebook" },
                user: { icon: "fas fa-user" },
                cat: { icon: "fas fa-desktop text-indigo" },
                res: { icon: "fas fa-chalkboard text-danger" },
                sch: { icon: "fas fa-calendar-alt text-danger" },
                lnk: { icon: "fas fa-globe text-blue" },
                short: { icon: "fas fa-folder" },
                fav: { icon: "fas fa-star text-warning" },
                shared: { icon: "fas fa-share-square text-teal" }
            }
        },
        "editor": {
            "id": "dext5editor",
            "top": ""
        },
        "uploader": {
            "id": "dext5upload",
            "df": "\u000B", //파일구분자
            "da": "\u000C" //속성구분자
        },
        "worktime": {
            "STD_HOUR": [8, 19],//기준 시각
            "STD_MIN": 15,      //시작 분
            "STD_ITV": 20,      //간격(분)
            "STD_LIMIT": 5,     //타이머(분)
            "STD_TIME": "",     //상태유지 타이머 기준시각
            "CUR_TIME": "",     //현시각
            "POP_TIME": ""      //팝업시각
        }
    };

    _zw.C = [];     //사용되는 차트 배열
    _zw.G = null;   //사용되는 그리드
    _zw.Fc = {      //Full Calendar
        _inst: null,
        _events: [],
        "setEvents": function (list) {
            this._events = list;
        },
        "getEvents": function () {
            return this._events;
        },
        "render": function (initDate) {
            this._inst = new Calendar($('#__fcView')[0], {
                locale: $('#current_culture').val(),
                height: '100%',
                plugins: [
                    calendarPlugins.bootstrap,
                    calendarPlugins.dayGrid,
                    calendarPlugins.timeGrid,
                    calendarPlugins.interaction
                ],

                //themeSystem: 'cosmo', //'bootstrap',

                headerToolbar: false,

                initialDate: initDate,
                //selectable: true,
                nowIndicator: true, // Show "now" indicator
                businessHours: {
                    dow: [1, 2, 3, 4, 5], // Monday - Friday
                    start: '9:00',
                    end: '18:00',
                },
                editable: true,
                //dayMaxEventRows: true, // allow "more" link when too many events
                events: this._events,

                //views: {
                //    dayGridMonth: {
                //        dayMaxEventRows: 5,
                //    }
                //},

                dayCellContent: function (arg, createElement) {
                    //console.log(arg)
                    //arg.date, arg.dayNumberText
                    //return createElement('div', { 'class': 'text-danger' }, arg.dayNumberText);
                    //return '<div class="d-flex"><div class="flex-grow-1 text-info">2h</div><div><span class="">(1.5)</span><span>' + arg.date.getDate() + '</span></div></div>';
                    //var d = $('<div class="d-flex justify-content-between"><div class="text-info">2h</div><div><span class="">(1.5)</span><span>' + arg.date.getDate() + '</span></div></div>');
                    //return { domNodes: d };
                    return arg.date.getDate(); // fc-daygrid-day-number
                },
                
                eventContent: function (arg, eventElement) {
                    console.log(arg.event)
                    //var d = $('<div class="d-flex justify-content-between"><div class="text-info">2h</div><div><span class="">(1.5)</span><span>' + arg.event.title + '</span></div></div>');
                    //return { domNodes: d };
                },

                select: function (arg) {
                    console.log(arg);
                },

                dateClick: function (arg) {
                    console.log(arg.event)
                    if (_zw.fn.fcDateClick) _zw.fn.fcDateClick(arg);
                },

                eventClick: function (arg) {
                    console.log(arg.event.title + " : " + arg.event.start + " : " + arg.event.end)
                    //if (_zw.fn.fcEventClick) _zw.fn.fcEventClick(calEvent);
                }
            });

            this._inst.render();
        },
        "updateSize": function () {
            if (this._inst) this._inst.updateSize();
        }
    }; 

    //메뉴
    _zw.mu = {
        "refresh": function () {
            _zw.fn.initLv(_zw.V.fdid);
            _zw.fn.loadList();
        },
        "search": function (page) {
            var e1 = $('.z-lv-date .start-date');
            var e2 = $('.z-lv-date .end-date');
            var e3 = $('.z-lv-search select');
            var e4 = $('.z-lv-search .search-text');

            if (!page && e1.val() == '' && e2.val() == '' && $.trim(e4.val()) == '') {
                bootbox.alert("검색 조건이 누락됐습니다!"); return;
            }

            var s = "['\\%^&\"*]";
            var reg = new RegExp(s, 'g');
            if (e3.val() != '' && e4.val().search(reg) >= 0) { bootbox.alert(s + " 문자는 사용될 수 없습니다!", function () { e4.val(''); e4.focus(); }); return; }

            _zw.V.lv.tgt = _zw.V.fdid;
            _zw.V.lv.page = (page) ? page : 1;
            _zw.V.lv.start = e1.val();
            _zw.V.lv.end = e2.val();
            _zw.V.lv.search = e3.val();
            _zw.V.lv.searchtext = ($.trim(e4.val()) == '') ? '' : e4.val();

            _zw.fn.loadList();
        },
        "readMsg": function (m) {
            var el, p, postData, tgtPage, stdPage;
            m = m || '';

            if (_zw.V.xfalias == 'knowledge') stdPage = '/Docs/Kms/Read';
            else if (_zw.V.xfalias == 'doc') stdPage = '/Docs/Edm/Read';
            else stdPage = '/Board/Read';

            if (m == 'reload') {
                if (_zw.V.mode == 'popup') {
                    window.location.reload(); return false;
                }
                postData = _zw.fn.getAppQuery(_zw.V.fdid);
                tgtPage = _zw.V.current.page;

            } else if (m == 'popup') {
                el = event.target ? event.target : event.srcElement;
                p = $(el).parent().parent();
                if (p.attr('xf') == undefined) p = $(el).parent().parent().parent();

                postData = '{M:"' + m + '",ct:"' + (p.attr('ctid') != undefined ? p.attr('ctid') : _zw.V.ct) + '",ctalias:"",ot:"",alias:"",xfalias:"' + p.attr('xf')
                    + '",fdid:"' + (p.attr('fdid') != undefined ? p.attr('fdid') : _zw.V.fdid) + '",appid:"' + p.attr('appid') + '",opnode:"",ttl:"",acl:"'
                    + '",appacl:"' + (p.attr('acl') != undefined ? p.attr('acl') : '') + '",sort:"SeqID",sortdir:"DESC",boundary:"' + _zw.V.lv.boundary + '"}';
                tgtPage = stdPage;
                //alert(postData); return

            } else {
                if (m == 'prev') {
                    _zw.V.appid = _zw.V.app.next;
                } else if (m == 'next') {
                    _zw.V.appid = _zw.V.app.prev;
                } else {
                    el = event.target ? event.target : event.srcElement;
                    p = $(el).parent().parent();

                    _zw.V.appid = p.attr('appid');
                    _zw.V.xfalias = p.attr('xf');
                    //_zw.V.ttl = $(el).text();
                    _zw.V.current.appacl = p.attr('acl');
                }

                if (_zw.V.appid == '' || _zw.V.appid == '0') return false;

                postData = _zw.fn.getAppQuery(_zw.V.fdid); //alert(encodeURIComponent(postData)); return
                //alert(postData);
                tgtPage = _zw.V.current.page;
            }
            
            var url = tgtPage + '?qi=' + _zw.base64.encode(postData);

            if (m == 'popup') {
                _zw.ut.openWnd(url, "popupform", 800, 650, "resize");

            } else if (tgtPage.toLowerCase() == stdPage.toLowerCase()) {
                $.ajax({
                    type: "POST",
                    url: url,
                    success: function (res) {
                        if (res.substr(0, 2) == "OK") {
                            var v = res.substr(2).split(_zw.V.lv.boundary);

                            if (m == 'modal') {
                                $('#popForm .modal-body').html(v[0]);

                                $('#popForm').modal('show');

                            } else {
                                history.pushState(null, null, url);
                                
                                $('#__FormView').html(v[0]);
                                _zw.V.app = JSON.parse(v[1]);

                                window.document.title = _zw.V.app['subject'];
                            }
                        } else bootbox.alert(res);
                    }
                });
            } else {
                _zw.V.xfalias = p.attr('xf');
                _zw.V.current.acl = p.attr('acl');

                window.location.href = stdPage + '?qi=' + _zw.base64.encode(postData);
            }
        },
        "writeMsg": function (xf, m) {
            if (xf == 'doc') {

            }
        },
        "setComment": function (seq) {
            var p = $('#__CommentList div[data-for="comment_' + seq.toString() + '"]');
            var txt = p.find('[data-column="Comment"]');
            if ($.trim(txt.val()) == '') { bootbox.alert('입력값이 없습니다!', function () { txt.focus(); }); return false; }

            var jPost = {};
            jPost["xfalias"] = _zw.V.xfalias;
            jPost["msgid"] = _zw.V.appid;
            jPost["seqid"] = seq;
            jPost["creurid"] = p.find('[data-column="CreatorID"]').text();
            jPost["creur"] = p.find('[data-column="Creator"]').text();
            jPost["comment"] = txt.val();

            //alert(JSON.stringify(jPost)); return

            $.ajax({
                type: "POST",
                url: "/Common/AddComment",
                data: JSON.stringify(jPost),
                dataType: "text",
                contentType: "application/json; charset=utf-8",
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        _zw.mu.readMsg('reload');

                    } else bootbox.alert(res);
                }
            });
        },
        "editComment": function (seq) {
            var el = event.target ? event.target : event.srcElement;
            $(el).parent().hide();

            var p = $('#__CommentList div[data-for="comment_' + seq.toString() + '"]');
            p.find('p').hide();
            p.find('p').next().removeClass('d-none');
        },
        "cancelComment": function (seq) {
            var el = event.target ? event.target : event.srcElement;
            var p = $(el).parent().parent();
            p.addClass('d-none');
            p.prev().show();
            p.prev().prev().children().last().show();
        },
        "deleteComment": function (seq) {
            var p = $('#__CommentList div[data-for="comment_' + seq.toString() + '"]');

            bootbox.confirm("삭제하시겠습니까?", function (rt) {
                if (rt) {
                    $.ajax({
                        type: "POST",
                        url: "/Common/deleteComment",
                        data: '{xfalias:"' + _zw.V.xfalias + '",msgid:"' + _zw.V.appid + '",seqid:"' + seq.toString() + '"}',
                        success: function (res) {
                            if (res.substr(0, 2) == "OK") {
                                _zw.mu.readMsg('reload');

                            } else bootbox.alert(res);
                        }
                    });
                }
            });
        },
        "preview": function () {
            var url = "/Common/Preview?ctalias=" + _zw.V.ctalias + "&xfalias=" + _zw.V.xfalias;
            _zw.ut.openWnd(url, "preview", 800, 600, "resize");
        },
        "saveWorkStatus": function () {
            var n = $('#popWorkStatus input:radio[name="rdoWorkStatus"]:checked');
            if (n.val() != _zw.V.current["ws"]) {
                bootbox.confirm("근무상태를 변경하시겠습니까?", function (rt) {
                    if (rt) {
                        $.ajax({
                            type: "POST",
                            url: "/ExS/WorkTime/StatusEvent",
                            data: '{ss:"' + n.val() + '"}',
                            success: function (res) {
                                if (res.substr(0, 2) == "OK") {
                                    if (res.substr(2) != '') {
                                        $('.sidenav-header a[data-navmenu="workstatus"] span:last-child').html(res.substr(2));
                                    }
                                    _zw.V.current["ws"] = n.val(); $('#popWorkStatus').modal('hide');
                                } else bootbox.alert(res);
                            }
                        });
                    }
                });
            }
        },
        "saveAutoNotice": function (opt) {
            var ss = opt && opt == 'auto' ? 'B' : 'N';
            $.ajax({
                type: "POST",
                url: "/ExS/WorkTime/StatusEvent",
                data: '{ss:"' + ss + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        var p = $('#popWorkStatus');
                        if (opt == 'auto') {
                            p.find('#lblChangeTime').html(moment().format('HH:mm:ss'));
                            p.find('div[data-for="step1"]').addClass('d-none');
                            p.find('div[data-for="step2"]').removeClass('d-none')
                            p.find('.modal-footer div[data-for="step2"]').addClass('d-flex');
                        }
                        if (res.substr(2) != '') {
                            $('.sidenav-header a[data-navmenu="workstatus"] span:last-child').html(res.substr(2));
                        }
                        _zw.V.current["ws"] = ss;
                        if (opt != 'auto') p.modal('hide');

                    } else {
                        if (opt != 'auto') bootbox.alert(res);
                    }
                },
                beforeSend: function () { } //로딩 X
            });
        },
        "offwork": function () {
            bootbox.confirm("퇴근 처리 하시겠습니까?", function (rt) {
                if (rt) {
                    $.ajax({
                        type: "POST",
                        url: "/ExS/WorkTime/StatusEvent",
                        data: '{ss:"Z",off:"Y"}',
                        success: function (res) {
                            if (res.substr(0, 2) == "OK") {
                                window.location.href = "/Account/Logout";
                            } else bootbox.alert(res);
                        }
                    });
                }
            });
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
                },
                beforeSend: function () { } //로딩 X
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

                        $('#__CalcWorkTime span[data-for]').each(function (idx, e) {
                            //console.log(idx + ' : ' + $(this).text());
                            if (idx == 0) {
                                temp = v[idx + 1].split(';'); txt = temp[0] + "h " + temp[1] + "m";
                                nH = _zw.ut.floor(parseFloat(parseInt(temp[0]) * 60 + parseInt(temp[1])) / 60, 1);

                            } else if (idx == 1) {
                                if (v[5].indexOf('.') >= 0) {
                                    temp = v[5].split('.'); txt = (temp[0] == '' ? "0" : temp[0]) + "h " + (parseFloat("0." + temp[1]) * 60).toFixed(0) + "m";
                                } else txt = (v[5] == '' ? "0" : v[5]) + "h 0m";
                                
                            } else if (idx == 2) {
                                temp = v[2].split(';'); txt = temp[0] + "h " + temp[1] + "m";
                                tH = _zw.ut.floor(parseFloat(parseInt(temp[0]) * 60 + parseInt(temp[1])) / 60, 1);
                            }
                            $(this).html(txt);
                        });

                        rH = _zw.ut.floor(parseFloat(v[3]), 1);
                        eH = _zw.ut.floor(parseFloat((v[4] == '' ? "0" : v[4])), 1);
                        
                        _zw.fn.progBar(rH, eH);

                    } else console.log(res);
                },
                beforeSend: function () { } //로딩 X
            });
            var t = setTimeout(_zw.fn.getTotalWorkTime, 600000); //10분
        },
        "autoWorkStatus": function () {
            _zw.T.worktime["CUR_TIME"] = moment();
            var y = _zw.T.worktime["CUR_TIME"].year();
            var M = _zw.T.worktime["CUR_TIME"].month()
            var d = _zw.T.worktime["CUR_TIME"].date()
            var h = _zw.T.worktime["CUR_TIME"].hour();
            var m = _zw.T.worktime["CUR_TIME"].minute();
            var s = _zw.T.worktime["CUR_TIME"].second();

            //console.log(y + " : " + M + " : " + d + " : " + h + " : " + m + " : " + s);
            var bOpen = _zw.fn.checkTimeInterval(h, m, s); //bOpen = true;
            if (_zw.V.current["ws"] == 'N' && bOpen) {
                _zw.T.worktime["STD_TIME"] = moment([y, M, d, h, m + _zw.T.worktime["STD_LIMIT"], s]);
                _zw.T.worktime["POP_TIME"] = _zw.T.worktime["CUR_TIME"];

                $.ajax({
                    type: "POST",
                    url: "/ExS/WorkTime/AutoNotice",
                    data: '{ws:"' + _zw.V.current.ws + '",poptime:"' + _zw.T.worktime["POP_TIME"] + '"}',
                    success: function (res) {
                        if (res.substr(0, 2) == "OK") {
                            var p = $('#popWorkStatus');
                            p.html(res.substr(2)).addClass('modal-fill-in');

                            p.find('div[data-for="step2"]').removeClass('d-flex').addClass('d-none');
                            p.find('#lblTimer').html(_zw.ut.zero(_zw.T.worktime["STD_LIMIT"]) + ' : 00');

                            //시계
                            var _clock = setInterval(function () {
                                p.find('#lblClock').html(moment().format('HH:mm:ss'));
                            }, 1000);

                            //타이머
                            var leftTime = _zw.T.worktime["STD_TIME"].unix() - _zw.T.worktime["CUR_TIME"].unix();
                            var duration = moment.duration(leftTime, 'seconds'); //console.log('1 => ' + duration + " : " + leftTime)
                            var _timer = setInterval(function () {
                                if (duration.asSeconds() <= 1 || _zw.T.worktime["CUR_TIME"].unix() >= _zw.T.worktime["STD_TIME"].unix()) {
                                    clearInterval(_timer);
                                    _zw.mu.saveAutoNotice('auto');
                                } else {
                                    duration = moment.duration(duration.asSeconds() - 1, 'seconds');
                                    p.find('#lblTimer').html(_zw.ut.zero(duration.minutes()) + ' : ' + _zw.ut.zero(duration.seconds()));
                                }
                            }, 1000);

                            p.on('hide.bs.modal', function () {
                                clearTimeout(_clock); p.html('').removeClass('modal-fill-in');
                            }).modal();

                        } else bootbox.alert(res);
                    },
                    beforeSend: function () { } //로딩 X
                });
            }
            var t = setTimeout(_zw.fn.autoWorkStatus, 1000);
        },
        "checkTimeInterval": function (h, m, s) {
            //return ((h == _zw.T.worktime["STD_HOUR"][0] || h == _zw.T.worktime["STD_HOUR"][1]) && (m + _zw.T.worktime["STD_MIN"]) % _zw.T.worktime["STD_ITV"] == 10 && s == 0) ? true : false;
            //return ((h == _zw.T.worktime["STD_HOUR"][0] || h == _zw.T.worktime["STD_HOUR"][1]) && (m == 15 || m == 35 || m == 55) && s == 0) ? true : false;

            //return ((m == 5 || m == 15 || m == 25 || m == 35 || m == 45 || m == 55) && s >= 0 && s < 1) ? true : false;
            //return ((m % 10 == 0) && s >= 0 && s < 1) ? true : false; //테스트용
		    return ((h == _zw.T.worktime["STD_HOUR"][0]) && (m == 10 || m == 30) && s >= 0 && s < 1) ? true : false;
        },
        "openWorkStatus": function () {
            $.ajax({
                type: "POST",
                url: "/ExS/WorkTime/StatusWnd",
                data: '{ws:"' + _zw.V.current.ws + '",intime:"' + _zw.V.current.intime + '",outtime:"' + _zw.V.current.outtime + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        var p = $('#popWorkStatus');
                        p.html(res.substr(2));

                        p.find('input:radio[name="rdoWorkStatus"]').click(function () {
                            p.find('input:radio[name="rdoWorkStatus"]').each(function () {
                                if ($(this).prop('checked')) $(this).parent().removeClass('text-light font-weight-light');
                                else $(this).parent().addClass('text-light font-weight-light');
                            });
                        });

                        //시계
                        var _clock = setInterval(function () {
                            $('#lblClock').html(moment().format('HH:mm:ss'));
                        }, 1000);

                        p.on('hide.bs.modal', function () {
                            clearInterval(_clock); p.html('');
                        }).modal();

                    } else bootbox.alert(res);
                },
                beforeSend: function () { } //로딩 X
            });
        },
        "viewWorkEvent": function (ur, d) {
            $.ajax({
                type: "POST",
                url: "/ExS/WorkTime/EventView",
                data: '{ur:"' + ur + '",wd:"' + d + '",page:"' + _zw.V.ft.toLowerCase() + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == 'OK') {
                        var p = $('#popBlank');
                        p.html(res.substr(2)).css('width', $(this).attr('data-width') + "px");
                        p.modal();
                    }
                }
            });
        },
        "progBar": function (real, ex) {
            if (real == '' || isNaN(real)) return false;

            var min = _zw.V.current["minhour"], max = _zw.V.current["maxhour"], extra = _zw.V.current["extrahour"];

            var barLen = _zw.ut.rate(real, min, 1) + "%";
            var barText = _zw.ut.rate(real, min, 1) + "% (" + real + "h)";

            //console.log("real => " + barLen + " : " + barText);

            $('.progress-bar[data-for="realhour"]').css('width', barLen);
            $('.progress-bar[data-for="realhour-text"]').html(barText);

            barLen = _zw.ut.rate(ex, extra, 1);
            barText = _zw.ut.rate(ex, extra, 1) + "% (" + ex + "h)";

            //console.log("rate => " + barLen + " : " + barText);

            var barColor = '';
            if (barLen < 51) barColor = 'progress-bar-success';
            else if (barLen < 71) barColor = 'progress-bar-warning';
            else barColor = 'progress-bar-danger';

            $('.progress-bar[data-for="extrahour-text"]').html(barText)
            $('.progress-bar[data-for="extrahour"]').addClass(barColor);

            if (barLen > 100) barLen = 100;
            $('.progress-bar[data-for="extrahour"]').css('width', barLen + '%');
        },
        "viewUserSimpleInfo": function (urId) {
            $.ajax({
                type: "POST",
                url: "/Organ/PersonSimpleInfo/" + urId,
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        $('#popBlank').html(res.substr(2));
                        $('#popBlank').modal('show');

                    } else bootbox.alert(res);
                },
                beforeSend: function () { } //로딩 X
            });
        },
        "getEACount": function (pos, xf, loc, ar, admin) {
            $.ajax({
                type: "POST",
                url: '/EA/Main/Count',
                data: xf + ',' + loc + ',' + ar + ',' + _zw.V.current.urid + ',' + _zw.V.current.deptid + ',' + admin,
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        var c1 = String.fromCharCode(12);
                        var c2 = String.fromCharCode(11);

                        var vLoc = res.substr(2).split(c2);
                        for (var i in vLoc) {
                            var vCnt = vLoc[i].split(c1);
                            var tgt = pos == 'webpart' ? $('#_EA_COUNT [data-box="node.' + vCnt[0] + '"]') : $('#__LeftMenu li[data-box="node.' + vCnt[0] + '"]');
                            //console.log(i + ' : ' + vCnt + ' : ' + tgt.length)
                            if (tgt.length > 0) {
                                if (vCnt[1].indexOf('/') < 0) tgt.find('.z-lm-cnt').html('(' + vCnt[1] + ')');
                                else tgt.find('.z-lm-cnt').html('(<span class="text-danger">' + vCnt[1].split('/')[0] + '</span>/' + vCnt[1].split('/')[1] + ')');
                            }
                        }

                    } else console.log(res);
                },
                beforeSend: function () { //로딩 X
                }
            });
            //var t = setTimeout("_zw.fn.getEACount('', '" + xf + "', '" + loc + "', '" + ar + "', '" + admin + "')", 60000);
        },
        "getAppQuery": function (tgt) {
            var j = {};
            j["M"] = _zw.V.mode;
            j["wnd"] = _zw.V.wnd; //창 모드 ('', popup, modal)
            j["ct"] = _zw.V.ct;
            j["ctalias"] = _zw.V.ctalias;
            j["ot"] = _zw.V.ot;
            j["alias"] = _zw.V.alias;
            j["xfalias"] = _zw.V.xfalias;
            j["fdid"] = _zw.V.fdid;
            j["appid"] = _zw.V.appid;
            j["acl"] = _zw.V.current.acl;
            j["appacl"] = _zw.V.current.appacl;
            j["opnode"] = _zw.V.opnode;
            j["ft"] = _zw.V.ft;
            j["ttl"] = ''; //_zw.V.ttl;

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

            j["cd1"] = _zw.V.lv.cd1;
            j["cd2"] = _zw.V.lv.cd2;

            //alert(j["permission"])
            return JSON.stringify(j);
        },
        "setLvCnt": function (cnt) {
            var cookieName = '';
            if (_zw.V.ctalias == 'ea') cookieName = 'eaLvCount';
            else if (_zw.V.ctalias == 'doc' || _zw.V.ctalias == 'knowledge') cookieName = 'docLvCount';
            else if (_zw.V.ctalias == 'orgmap') cookieName = 'orgLvCount';
            else if (_zw.V.ctalias == 'MC' || _zw.V.ctalias == 'CE') cookieName = 'costLvCount';
            else cookieName = 'bbsLvCount';

            _zw.V.lv.count = cnt;
            _zw.V.lv.page = 1;
            _zw.ut.setCookie(cookieName, cnt, 365);
            _zw.mu.search(1);
        },
        "modalMsg": function (xf, appid, fdid) {
            var postData = '{ct:"' + _zw.V.ct + '",ctalias:"",ot:"",alias:"",xfalias:"' + xf + '",fdid:"' + fdid + '",appid:"' + appid + '",opnode:"",ttl:"",acl:"' + '",appacl:"",sort:"SeqID",sortdir:"DESC",boundary:"' + _zw.V.lv.boundary + '"}';

            $.ajax({
                type: "POST",
                url: "/Board/Modal?qi=" + _zw.base64.encode(postData),
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        var v = res.substr(2).split(_zw.V.lv.boundary);
                        $('#popForm').on('show.bs.modal', function (e) {
                            $(this).find('.modal-title').html(v[1]);
                            $(this).find('.modal-body').html(v[0])
                        }).modal();

                    } else bootbox.alert(res);
                }
            });
        },
        "newEAForm": function (tab) {
            tab = tab || '';

            $.ajax({
                type: "POST",
                url: "/EA/Main/NewDocument",
                data: '{tab:"' + tab + '",boundary:"' + _zw.V.lv.boundary + '"}',
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        //var v = res.substr(2).split(_zw.V.lv.boundary);
                        
                        var p = $('#popBlank');
                        p.html(res.substr(2));
                        //$(this).find('.modal-title').html(v[0]);
                        //$(this).find('.modal-body').addClass('p-3').html(v[1])

                        //new PerfectScrollbar(document.getElementById('__ClassTree'));

                        $('#__ClassTree').jstree({"core": {"multiple": false}
                        }).on("select_node.jstree", function (e, d) {
                            var n = d.instance.get_node(d.selected);

                            _zw.fn.selectNewEAForm(null);
                            
                            p.find('.z-lv-newform .card-header').html(d.instance.get_path(d.selected[0]));
                            p.find('.z-lv-newform .tab-pane.active').removeClass('active');
                            p.find('#' + n.li_attr.tgt).addClass('active');
                        });

                        p.find('.z-lv-newform a.list-group-item').on('click', function () {
                            event.preventDefault(); _zw.fn.selectNewEAForm($(this));
                        });

                        p.find('.z-lv-formsearch input[type="search"]').keyup(function (e) {
                            if (e.which == 13) p.find('.z-lv-formsearch .btn').click();
                        });

                        p.find('.z-lv-formsearch .btn').click(function () {
                            var txt = p.find('.z-lv-formsearch input[type="search"]'); if ($.trim(txt.val()) == '') return false;
                            var s = "['\\%^&\"*]";
                            var reg = new RegExp(s, 'g');
                            if (txt.val() != '' && txt.val().search(reg) >= 0) { bootbox.alert(s + " 문자는 사용될 수 없습니다!", function () { txt.val(''); txt.focus(); }); return; }

                            var tabSearch = p.find('.z-lv-newform #class_search');
                            tabSearch.find('.list-group').html('');

                            _zw.fn.selectNewEAForm(null);

                            var iCnt = 0;
                            p.find('.z-lv-newform .tab-pane:not(#class_search) a.list-group-item:contains("' + txt.val() + '")').each(function () {
                                $(this).clone().appendTo('.z-lv-newform #class_search .list-group').on('click', function () {
                                    _zw.fn.selectNewEAForm($(this));
                                }).on('dblclick', function () {
                                    _zw.fn.openNewEAForm($(this).attr('data-val')); p.modal('hide');
                                });
                                iCnt++;
                            });

                            p.find('.z-lv-newform .card-header').html('검색 (' + iCnt.toString() + '개)');
                            p.find('.z-lv-newform .tab-pane.active').removeClass('active');
                            tabSearch.addClass('active');
                        });

                        p.find('.modal-footer .btn[data-zm-menu="confirm"]').click(function () {
                            var formId = p.find('.z-lv-newform .tab-pane.active a.list-group-item.active').attr('data-val');
                            if (formId) { _zw.fn.openNewEAForm(formId); p.modal('hide'); }
                        });
                        p.find('.z-lv-newform a.list-group-item').on('dblclick', function () {
                            _zw.fn.openNewEAForm($(this).attr('data-val')); p.modal('hide');
                        });

                        if (tab && tab != '') $('#popWorkStatus').modal('hide');
                        p.modal('show');
                        p.on('hidden.bs.modal', function (event) {
                            p.html('');
                        })

                    } else bootbox.alert(res);
                }
            });
        },
        "selectNewEAForm": function (fm) {
            var p = $('#popBlank'), formId = fm ? fm.attr('data-val') : 'x';

            p.find('.z-lv-newform .tab-pane a.list-group-item').each(function () {
                var t = $(this).parent().parent(), icon2 = $(this).find('i');
                if (t.hasClass('active') && formId == $(this).attr('data-val')) {
                    icon2.removeClass(icon2.attr('aria-controls'));
                } else {
                    icon2.addClass(icon2.attr('aria-controls')); $(this).removeClass('active');
                }
            });

            var v = jFormList.find( //배열 검색
                function (e) {
                    if (e.fid === formId) {
                        return true;
                    }
                }
            );
            //console.log(JSON.stringify(v))
            
            var sGR = '', sUR = '';
            if (v && v["chargelist"].length > 0) {
                for (var i = 0; i < v["chargelist"].length; i++) {
                    var c = v["chargelist"][i];
                    if (c["ot"] == 'UR') sUR += (sUR == '' ? '' : "\n") + c["name"];
                    else if (c["ot"] == 'GR') sGR = c["name"];
                }
            }
            p.find('.z-lv-forminfo .form-group [data-for]').each(function () {
                if (v) {
                    if ($(this).attr('data-for') == 'DocName') $(this).val(v["docname"]);
                    else if ($(this).attr('data-for') == 'File') $(this).val(v["file"]);
                    else if ($(this).attr('data-for') == 'Description' && v["fid"].length > 30) $(this).val(v["desc"]);
                    else if ($(this).attr('data-for') == 'ChargeDept') $(this).val(sGR);
                    else if ($(this).attr('data-for') == 'ChargeUser') $(this).val(sUR);
                } else {
                    $(this).val('');
                }
            });
        },
        "openNewEAForm": function (formId, tp) {
            if (formId == '' && tp == null) return false;

            var qi = {};
            qi['M'] = 'new'; qi['xf'] = 'ea';

            if (formId != '') {
                qi['fi'] = formId;
            } else if (tp && tp.length > 0) {
                qi['fi'] = ''; qi['ft'] = tp[0]; qi['k1'] = tp[1]; qi['Tp'] = tp[2];
            }
            //console.log(qi)
            var url = '/EA/Form?qi=' + _zw.base64.encode(JSON.stringify(qi));
            _zw.ut.openWnd(url, "eaform", 800, 600, "resize");
        },
        "openEAForm": function (opt) {
            var el = event.target, p = el.parentNode; do { p = p.parentNode; } while (!$(p).hasClass('z-lv-row'));
            var vId = p.id.substr(1).split('.'); //console.log(vId)

            var xfAlias = _zw.V.xfalias == '' ? 'ea' : _zw.V.xfalias;
            var qi = '', eaWndNm = '', app;

            if (_zw.V.opnode != '') {
                if (_zw.V.opnode.substr(0, 2) == 'do') {
                    if (opt == 'app') {
                        app = p.getAttribute("app").split('^');
                        if (app[0] == 'ea') {
                            qi = '{M:"new",fi:"' + app[1] + '",wn:"' + p.id.substr(1) + '",xf:"' + xfAlias + '"}';

                        } else if (app[0] == 'tooling' || app[0] == 'ecnplan') {
                            qi = '{M:"edit",xf:"' + app[0] + '",fi:"' + app[1] + '",mi:"' + app[2] + '",wn:"' + p.id.substr(1) + '"}'; eaWndNm = 'noteaform';
                        }

                    } else if (opt == 'preapp') {
                        app = p.getAttribute("preapp").split('^');
                        if (app[0] == 'ea') {
                            qi = '{M:"read",mi:"' + app[2] + '",oi:"' + app[3] + '",xf:"' + xfAlias + '"}';
                        }
                    }

                } else if (_zw.V.opnode.substr(0, 2) == 'te') {
                    qi = '{M:"edit",mi:"' + vId[0] + '",xf:"' + xfAlias + '"}'; eaWndNm = 'eaform';
                } else if (_zw.V.opnode.substr(0, 2) == 'dl' || _zw.V.opnode.substr(0, 2) == 'cf') {
                    qi = '{M:"read",mi:"' + vId[0] + '",oi:"' + vId[1] + '",cab:"' + vId[2] + '",xf:"' + xfAlias + '"}';
                } else if (_zw.V.opnode.substr(0, 2) == 'wt') {
                    qi = '{M:"read",mi:"' + vId[0] + '",oi:"' + vId[1] + '",svc:"' + vId[2] + '",xf:"' + xfAlias + '"}';
                } else {
                    qi = '{M:"read",mi:"' + vId[0] + '",oi:"' + vId[1] + '",wi:"' + (vId[2] && vId[2] != undefined ? vId[2] : '') + '",xf:"' + xfAlias + '"}'; //console.log(qi)
                }
            } else {
                qi = '{M:"read",mi:"' + vId[0] + '",oi:"' + vId[1] + '",wi:"' + (vId[2] && vId[2] != undefined ? vId[2] : '') + '",xf:"' + xfAlias + '"}';
            }

            var url = '/EA/Form?qi=' + _zw.base64.encode(qi);
            _zw.ut.openWnd(url, eaWndNm, 800, 600, "resize");
        },
        "openEAFormSimple": function (mi) {
            var qi = '{M:"read",mi:"' + mi + '",oi:"",wi:"",xf:"ea"}';
            var url = '/EA/Form?qi=' + _zw.base64.encode(qi);
            _zw.ut.openWnd(url, '', 800, 600, "resize");
        },
        "input": function (e, p) {
            if (e) {
                if ($(e).prop('tagName').toUpperCase() == 'INPUT') {
                    if (!$(e).prop('readonly') && !$(e).prop('disabled')) _zw.ut.maskInput(e);
                } else {
                    e.find('input[data-inputmask]').each(function () {
                        if (!$(this).prop('readonly') && !$(this).prop('disabled')) _zw.ut.maskInput($(this)[0]);
                    });
                }
                
            } else {
                if (p && p.length > 0) {
                    p.each(function () {
                        if (!$(this).prop('readonly') && !$(this).prop('disabled')) _zw.ut.maskInput($(this)[0]);
                    });
                } else {
                    $('input[data-inputmask]').each(function () {
                        if (!$(this).prop('readonly') && !$(this).prop('disabled')) _zw.ut.maskInput($(this)[0]);
                    });
                }
            }
        },
        "onblur": function (e, v) {
            var dec = '', e1, e2, e3, e4, e5;

            if (e.value != '' && (v[0] == 'number' || v[0] == 'percent')) {
                if (v[2] && parseInt(v[2]) > 0) {
                    for (var i = 0; i < parseInt(v[2]); i++) { dec += '0'; }
                }
                if (dec != '') dec = '.' + dec;
                e.value = numeral(e.value.replace('%', '')).format('0,0' + dec);
                if (v[0] == 'percent') e.value += '%';
            }
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
        "picker": function (kind) {
            if (kind == 'date') {
                $('.input-daterange').datepicker({
                    autoclose: true,
                    inputs: $('.input-daterange input[type="text"]'),
                    //format: "yyyy-mm-dd",
                    language: $('#current_culture').val()
                });

                $('.datepicker').datepicker({
                    autoclose: true,
                    //format: "yyyy-mm-dd",
                    language: $('#current_culture').val()
                });
            }
        },
        "maxLength": function () {
            $('.bootstrap-maxlength').each(function () {
                $(this).maxlength({
                    alwaysShow: true,
                    warningClass: 'text-muted',
                    limitReachedClass: 'text-danger',
                    validate: true,
                    placement: 'top-right-inside',
                    threshold: +this.getAttribute('maxlength')
                });
            });
        },
        "maskInput": function (e) {
            var v = $(e).attr('data-inputmask').split(';');
            if (v[0] == "number" || v[0] == "percent") {
                vanillaTextMask.maskInput({
                    inputElement: e,
                    mask: textMaskAddons.createNumberMask({
                        prefix: '',
                        suffix: v[0] == "percent" ? '%' : '',
                        integerLimit: parseInt(v[1]),
                        allowDecimal: parseInt(v[2]) > 0 ? true : false,
                        decimalLimit: parseInt(v[2]) > 0 ? parseInt(v[2]) : 0,
                        allowNegative: v[3] && v[3] == '-' ? true : false
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
        "toBR": function (s) {
            //s.replace(/\n/gi, '<br />')
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
                }
            }
        },
        "eventBtn": function () {//버튼 클릭시 버튼요소 반환
            var el = $(event.target); if (el.prop('tagName') == 'I') el = el.parent();
            return el;
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

    //Calendar (일정,일지,자원 관련 공통 함수)
    _zw.cdr = {
        "weekOfMonth": function (d) {//특정일이 해당월 몇주차 인지 그리고 마지막 주차인지
            var m = moment(d); //console.log((m.month() == moment(d).add(7, 'd').month()).toString() + " : " + m.format('MM DD Do dddd'))
            //var nth = m.week() - m.startOf('month').week() + 1;
            //var isLast = m.month() == moment(d).add(7, 'd').month() ? 'N' : 'Y';
            return (m.week() - m.startOf('month').week() + 1).toString() + ';' + (m.month() == moment(d).add(7, 'd').month() ? 'N' : 'Y');
        },
        "showRepeat": function (p, m, from, st, et) { // p => modal wnd, fromdate, starttime, endtime
            var el = p.find('#cbRepeatType'), ckRptEnd = p.find('input[name="ckbRepeatEnd"]'), rptEnd = p.find('#txtRepeatEnd');
            var end = '';
            if (from.indexOf(';') > 0) {
                end = from.split(';')[1]; from = from.split(';')[0];
            }

            el.on('change', function () {
                p.find('#sPerDay input, #sPerWeek input').val(1);
                
                //alert($(this).val() + " : " + p.find('#' + from).val() + " : " + p.find('#' + st).val());

                if ($(this).val() == 1) {//day
                    if (m == 'init') {
                        _zw.cdr.initRepeattDay(p, 0);
                        ckRptEnd.prop('checked', false); rptEnd.val(moment(p.find('#' + from).val()).add(1, 'M').format('YYYY-MM-DD')).prop('disabled', false);
                    }
                    p.find('#sPerDay').removeClass('d-none').addClass('d-flex');
                    p.find('#sPerWeek').removeClass('d-flex').addClass('d-none');
                    p.find('#sPerMonth').removeClass('d-flex').addClass('d-none');
                    p.find('[data-for="rpt-day"]').addClass('d-none');
                    p.find('[data-for="rpt-monthyear"]').addClass('d-none');

                } else if ($(this).val() == 2) {//weekday
                    if (m == 'init') {
                        _zw.cdr.initRepeattDay(p, 1);
                        ckRptEnd.prop('checked', true); rptEnd.val('').prop('disabled', true);
                    }
                    p.find('#sPerDay').removeClass('d-flex').addClass('d-none');
                    p.find('#sPerWeek').removeClass('d-none').addClass('d-flex');
                    p.find('#sPerMonth').removeClass('d-flex').addClass('d-none');
                    p.find('[data-for="rpt-day"]').addClass('d-none');
                    p.find('[data-for="rpt-monthyear"]').addClass('d-none');

                } else if ($(this).val() == 3) {//week
                    if (m == 'init') {
                        _zw.cdr.initRepeattDay(p, 3, moment(p.find('#' + from).val()).day());
                        ckRptEnd.prop('checked', true); rptEnd.val('').prop('disabled', true);
                    }
                    p.find('#sPerDay').removeClass('d-flex').addClass('d-none');
                    p.find('#sPerWeek').removeClass('d-none').addClass('d-flex');
                    p.find('#sPerMonth').removeClass('d-flex').addClass('d-none');
                    p.find('[data-for="rpt-day"]').removeClass('d-none');
                    p.find('[data-for="rpt-monthyear"]').addClass('d-none');

                } else if ($(this).val() == 4) {//month
                    if (m == 'init') {
                        _zw.cdr.initRepeattMonthYear(p, 0, p.find('#' + from).val());
                        ckRptEnd.prop('checked', true); rptEnd.val('').prop('disabled', true);
                    }
                    p.find('#sPerDay').removeClass('d-flex').addClass('d-none');
                    p.find('#sPerWeek').removeClass('d-flex').addClass('d-none');
                    p.find('#sPerMonth').removeClass('d-none').addClass('d-flex');
                    p.find('[data-for="rpt-day"]').addClass('d-none');
                    p.find('[data-for="rpt-monthyear"]').removeClass('d-none');

                } else if ($(this).val() == 5) {//year
                    if (m == 'init') {
                        _zw.cdr.initRepeattMonthYear(p, 1, p.find('#' + from).val());
                        ckRptEnd.prop('checked', true); rptEnd.val('').prop('disabled', true);
                    }
                    p.find('#sPerDay').removeClass('d-flex').addClass('d-none');
                    p.find('#sPerWeek').removeClass('d-flex').addClass('d-none');
                    p.find('#sPerMonth').removeClass('d-flex').addClass('d-none');
                    p.find('[data-for="rpt-day"]').addClass('d-none');
                    p.find('[data-for="rpt-monthyear"]').removeClass('d-none');
                }
            });

            p.find('#' + from).on('blur', function () {
                if (end != '') {
                    p.find('#' + end).val($(this).val());
                    //p.find('#' + end).datepicker('update', $(this).val());
                }
                if (el.val() == 4 || el.val() == '5') {
                    _zw.cdr.initRepeattMonthYear(p, el.val() - 4, $(this).val());
                    ckRptEnd.prop('checked', true); rptEnd.val('').prop('disabled', true);
                }
            });

            p.find('#' + from).datepicker().on('changeDate', function (e) {
                //console.log($(this).val());
                if (end != '') {
                    p.find('#' + end).val($(this).val());
                    //p.find('#' + from).datepicker('update', $(this).val());
                }
                //p.find('#' + from).data('datepicker').setStartDate($(this).val());
                //p.find('#' + from).data('datepicker').setEndDate($(this).val());

                if (el.val() == 4 || el.val() == '5') {
                    _zw.cdr.initRepeattMonthYear(p, el.val() - 4, $(this).val());
                    ckRptEnd.prop('checked', true); rptEnd.val('').prop('disabled', true);
                }
            });

            ckRptEnd.on('click', function () {
                if ($(this).prop('checked')) {
                    rptEnd.val('').prop('disabled', true);
                } else {
                    rptEnd.val(moment(p.find('#' + from).val()).add(1, 'M').format('YYYY-MM-DD')).prop('disabled', false);
                }
            });

            p.find('#sPerDay a[data-val], #sPerWeek a[data-val], #sPerMonth a[data-val]').click(function () {
                $(this).parent().find('input').val($(this).attr('data-val'));
            });

            if (m == 'init') el.val(3);
            el.change();
            _zw.fn.input(p);

            p.find('[data-for="rpt-setting"], [data-for="rpt-rule"], [data-for="rpt-end"]').removeClass('d-none');
        },
        "closeRepeat": function (p) {
            p.find('[data-for="rpt-setting"], [data-for="rpt-rule"], [data-for="rpt-day"], [data-for="rpt-end"]').addClass('d-none');
        },
        "initRepeattDay": function (p, m, n) {
            var iCkbDay = p.find('[data-for="rpt-day"] input[name="ckbDay"]').length;
            p.find('[data-for="rpt-day"] input[name="ckbDay"]').each(function (i, e) {
                $(this).next().html(moment.weekdaysMin(i));
                if (m == 0) {
                    e.checked = false;
                } else if (m == 1) {//평일
                    e.checked = i > 0 && i < iCkbDay - 1 ? true :false;
                } else if (m == 2) {//주말
                    e.checked = i > 0 && i < iCkbDay - 1 ? false : true;
                } else {
                    e.checked = i == n - 1 ? true : false;
                }
                //console.log(iCkbDay + " : " + i + " : " + e.checked);
            });
            //console.log(m + " : " + p.find('[data-for="rpt-day"] input[name="ckbDay"]:checked').length)
        },
        "initRepeattMonthYear": function (p, m, d) {
            var nth = _zw.cdr.weekOfMonth(d).split(';'), fromDate = moment(d); //console.log(nth + " :" + fromDate.format('YYYY-MM-DD'));
            if (nth[1] == 'Y') p.find('[data-for="rpt-monthyear"] label.custom-radio:last').removeClass('d-none');
            else p.find('[data-for="rpt-monthyear"] label.custom-radio:last').addClass('d-none');

            var txt = [], vlu = [], ckDay = '';
            for (var i = 0; i < 7; i++) { ckDay += fromDate.weekday() == i ? 'o' : 'x'; }

            txt[0] = m == 0 ? fromDate.date() + '일' : fromDate.month() + 1 + '월 ' + fromDate.date() + '일';
            txt[1] = (m == 1 ? fromDate.month() + 1 + '월 ' : '') + nth[0] + '번째 ' + fromDate.format('dddd');
            txt[2] = (m == 1 ? fromDate.month() + 1 + '월 ' : '') + '마지막 ' + fromDate.format('dddd');

            vlu[0] = m == 0 ? fromDate.date() : fromDate.month() + 1 + ';' + fromDate.date();
            vlu[1] = (m == 1 ? fromDate.month() + 1 + ';' : '') + nth[0] + ';' + ckDay;
            vlu[2] = (m == 1 ? fromDate.month() + 1 + ';' : '') + '9' + ';' + ckDay;

            p.find('div[data-for="rpt-monthyear"] :radio[name="rdoMonthYear"]').each(function (idx, e) {
                var n = $(this).next(); //console.log(idx + " : " + n[0].outerHTML)
                if (idx == 0) e.checked = true;
                n.attr('data-val', vlu[idx]); n.html(txt[idx]);
            });
        },
        "getRepeat": function (p) { // p => modal wnd
            if (p.find('input[name="ckbRepeat"]').prop('checked')) {
                var sRType = p.find('#cbRepeatType').val(), sRCount = '', sRIntType = '', sRInterval = 0, sRDay = '', sRWeek = '', sRDate = '';
                if (sRType == 1) {
                    sRInterval = p.find("#sPerDay input").val();
                } else if (sRType == 2 || sRType == 3) {
                    sRInterval = p.find("#sPerWeek input").val();
                    p.find('[data-for="rpt-day"] input[name="ckbDay"]').each(function (i, e) {
                        sRDay += e.checked ? "o" : "x"; // xoxxxxx
                    });
                    if (sRDay.indexOf('o') == -1) return 'CHECK';
                } else if (sRType == 4 || sRType == 5) {
                    var rdoMonYear = p.find('div[data-for="rpt-monthyear"] :radio[name="rdoMonthYear"]:checked'), vlu = rdoMonYear.next().attr('data-val').split(';');
                    sRIntType = rdoMonYear.val();

                    if (sRType == 4) {
                        sRInterval = p.find("#sPerMonth input").val();
                        if (sRIntType == 'A') {
                            sRDate = vlu;
                        } else if (sRIntType == 'B') {
                            sRDay = vlu[1]; sRWeek = vlu[0];
                        }
                    } else {
                        sRInterval = vlu[0];
                        if (sRIntType == 'A') {
                            sRDate = vlu[1];
                        } else if (sRIntType == 'B') {
                            sRDay = vlu[2]; sRWeek = vlu[1];
                        }
                    }
                }
                if (sRType >= 3) sRType--;

                if (!$('input[name="ckbRepeatEnd"]').prop('checked')) {
                    if (!moment($('#txtRepeatEnd').val()).isValid()) return 'INVALID';
                    if (moment($('#txtRepeatEnd').val() + ' 00:00:00').diff(moment($('#txtStart').val() + ' 00:00:00')) <= 0) return 'END';
                }
                //return sRType + "|" + sRInterval + "|" + sRDay + "|" + $("#txtRepeatEnd").val();

                //repeat_type, end, count, interval_type, interval, cond_day, cond_week, cond_date
                return sRType + '|' + $("#txtRepeatEnd").val() + '|' + sRCount + '|' + sRIntType + '|' + sRInterval + '|' + sRDay + '|' + sRWeek + '|' + sRDate;

            } else {
                return '0|||||||';
            }
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

    _zw.dext5 = {
        "transferFile": function (currUploadID) {// 전송시작
            if (currUploadID) {
                DEXT5UPLOAD.Transfer(currUploadID);
            } else {
                DEXT5UPLOAD.Transfer(_zw.T.uploader.id);
            }
        },
        "openFileDialog": function (currUploadID) {// 파일추가 대화창
            if (currUploadID) {
                DEXT5UPLOAD.OpenFileDialog(currUploadID);
            } else {
                DEXT5UPLOAD.OpenFileDialog(_zw.T.uploader.id);
            }
        },
        "deleteAllFile": function (currUploadID) {// 모든 파일삭제
            if (currUploadID) {
                DEXT5UPLOAD.DeleteAllFile(currUploadID);
            } else {
                DEXT5UPLOAD.DeleteAllFile(_zw.T.uploader.id);
            }
        },
        "deleteSelectedFile": function (currUploadID) {// 선택한 파일삭제
            if (currUploadID) {
                DEXT5UPLOAD.DeleteSelectedFile(currUploadID);
            } else {
                DEXT5UPLOAD.DeleteSelectedFile(_zw.T.uploader.id);
            }
        },
        "downloadFile": function  (currUploadID) {// 선택한 파일 다운로드
            if (currUploadID) {
                DEXT5UPLOAD.DownloadFile(currUploadID);
            } else {
                DEXT5UPLOAD.DownloadFile(_zw.T.uploader.id);
            }
        },
        "downloadAllFile": function (currUploadID) {// 모든파일 다운로드
            if (currUploadID) {
                DEXT5UPLOAD.DownloadAllFile(currUploadID);
            } else {
                DEXT5UPLOAD.DownloadAllFile(_zw.T.uploader.id);
            }
        },
        "getTotalFileCount": function (currUploadID) {// 전체 파일개수
            if (currUploadID) {
                alert(DEXT5UPLOAD.GetTotalFileCount(currUploadID));
            } else {
                alert(DEXT5UPLOAD.GetTotalFileCount(_zw.T.uploader.id));
            }
        },
        "getTotalFileSize": function (currUploadID) {// 전체 파일크기(Bytes)
            if (currUploadID) {
                alert(DEXT5UPLOAD.GetTotalFileSize(currUploadID));
            } else {
                alert(DEXT5UPLOAD.GetTotalFileSize(_zw.T.uploader.id));
            }
        },
        "setUploadMode": function (mode, currUploadID) {// 업로드 모드 변경
            // mode : edit / view / open / download
            if (currUploadID) {
                DEXT5UPLOAD.SetUploadMode(mode, currUploadID);
            } else {
                DEXT5UPLOAD.SetUploadMode(mode, _zw.T.uploader.id);
            }
        },
        "uploadShow": function (currUploadID) {// 업로드 보이기
            if (currUploadID) {
                DEXT5UPLOAD.Show(currUploadID);
            } else {
                DEXT5UPLOAD.Show(_zw.T.uploader.id);
            }
        },
        "uploadHidden": function (currUploadID) {// 업로드 숨기기
            if (currUploadID) {
                DEXT5UPLOAD.Hidden(currUploadID);
            } else {
                DEXT5UPLOAD.Hidden(_zw.T.uploader.id);
            }
        },
        "setSkinColor": function (currUploadID) {// 업로드 스킨설정
            if (currUploadID) {
                DEXT5UPLOAD.SetSkinColor('#ff0000', '#f7f140', '#33e8f5', '#c2ffd0', currUploadID);
            } else {
                DEXT5UPLOAD.SetSkinColor('#ff0000', '#f7f140', '#33e8f5', '#c2ffd0', _zw.T.uploader.id);
            }
        }
    }
}());