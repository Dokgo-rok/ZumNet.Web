//전자결재 메인, 리스트뷰
$(function () {

    _zw.fn.input($('#__FormView .m'));

    if (_zw.V.mode == "read") {
        $.ajax({
            type: "POST",
            url: "/Form/ViewCount",
            data: '{xf:"' + _zw.V.xfalias + '",mi:"' + _zw.V.appid + '",actor:"' + _zw.V.current["urid"] + '",fdid:"' + _zw.V.fdid + '",wi:"' + _zw.V.wid + '",wn:"' + _zw.V.prevwork + '"}',
            success: function (res) {
                if (res != "OK") bootbox.alert(res);
                else _zw.fn.reloadList();
            },
            beforeSend: function () {//pace.js 충돌
            }
        });
    }

    $('.zf-menu .btn[data-zf-menu]').click(function () {
        var mn = $(this).attr('data-zf-menu');
        switch (mn) {
            case "toggleEditor":
                var vText = $(this).attr('aria-label').split('|'), vIcon = ['fas fa-arrow-down', 'fas fa-arrow-up'];
                var p = $('#__FormView .m');
                var orgHeight = p.find('.fm-editor').outerHeight(), maxHeight = p.outerHeight() - p.find('.fh').outerHeight(); //alert(orgHeight + " : " + maxHeight)

                if ($(this).attr('aria-expanded') == 'false') {
                    $(this).attr('data-original-title', vText[1]).attr('aria-expanded', true).find('i').removeClass(vIcon[1]).addClass(vIcon[0]);
                    p.find('.fm-editor').css('height', maxHeight + 'px'); p.find('.ff, .fb, .fm, .fm-lines, .fm-file').hide();
                } else {
                    $(this).attr('data-original-title', vText[0]).attr('aria-expanded', false).find('i').removeClass(vIcon[0]).addClass(vIcon[1]);
                    p.find('.fm-editor').css('height', ''); p.find('.ff, .fb, .fm, .fm-lines, .fm-file').show();
                }
                break;

            case "saveTemp":
                var btn = {};
                if (_zw.V.mode == 'edit' && _zw.V.appid != '') {
                    btn = {
                        cancel: { label: '취소', className: 'btn-default', callback: function () { } },
                        save: { label: '저장', className: 'btn-primary', callback: function () { _zw.fn.saveTemp('save'); } },
                        saveas: { label: '새로 저장', className: 'btn-info', callback: function () { _zw.fn.saveTemp('saveas'); } }
                    }
                } else {
                    btn = {
                        cancel: { label: '취소', className: 'btn-default', callback: function () { } },
                        save: { label: '저장', className: 'btn-primary', callback: function () { _zw.fn.saveTemp('saveas'); } }
                    }
                }

                bootbox.dialog({
                    //title: "전자결재",
                    message: "저장하시겠습니까?",
                    size: "small",
                    buttons: btn
                });
                break;

            case "saveFile":
                if (_zw.V.mode == 'read') {
                    var qi = '{mi:"' + _zw.V.appid + '",oi:"' + _zw.V.oid + '",xf:"' + _zw.V.xfalias + '"}';
                    var url = '/EA/Form/Save?qi=' + _zw.base64.encode(qi);
                    window.open(url);
                }
                break;

            case "preview":
                if (_zw.V.mode == 'read') {
                    var url = "/EA/Form/Preview";
                    _zw.ut.openWnd(url, "preview", $('body').outerWidth(), $('body').outerHeight(), "resize");
                }
                break;

            case "showHelp":
                var url = '/Storage/' + _zw.V.companycode + '/Help/' + _zw.V.ft + '_help.html';
                _zw.ut.openWnd(url, 'EAHelp', 700, 550, 'resize');
                break;

            case "docProp":
                var jPost = {}, ttl = $(this).text();
                jPost["M"] = _zw.V.mode; jPost["inherited"] = _zw.V.inherited; jPost["priority"] = _zw.V.priority; jPost["secret"] = _zw.V.secret;
                jPost["tms"] = _zw.V.tms; jPost["doclevel"] = _zw.V.doclevel; jPost["keepyear"] = _zw.V.keepyear; jPost["category"] = _zw.V.category;
                //console.log(jPost)
                $.ajax({
                    type: "POST",
                    url: "/EA/Form/DocProp",
                    data: JSON.stringify(jPost),
                    success: function (res) {
                        if (res.substr(0, 2) == "OK") {
                            var p = $('#popLayer');
                            p.find('.modal-title').html(ttl);
                            p.find('.modal-body').html(res.substr(2));

                            if (_zw.V.mode == 'read') p.find('.btn[data-zm-menu="confirm"]').hide();

                            p.find('.btn[data-zm-menu="confirm"]').click(function () {
                                //문서분류, 보안등급, 보존년한 외 설정
                                _zw.V.priority = p.find('.modal-body .custom-select[data-for="priority"]').val();
                                _zw.V.secret = p.find('.modal-body .custom-select[data-for="secret"]').val();
                                _zw.V.inherited = p.find('.modal-body .custom-select[data-for="inherited"]').val();
                                //alert(_zw.V.priority + " : " + _zw.V.secret + " : " + _zw.V.inherited)
                                $(this).off('click'); //if none, loop
                                p.modal('hide');
                            });

                            p.modal();
                        } else bootbox.alert(res);
                    }
                });
                break;

            case "linkDoc":
                if (_zw.V.mode == 'new' || _zw.V.mode == 'edit') {
                    var jPost = {};
                    jPost["M"] = ''; jPost["ct"] = 108; jPost["page"] = 1; jPost["count"] = 10; jPost["sort"] = ''; jPost["sortdir"] = '';
                    jPost["search"] = ''; jPost["searchtext"] = ''; jPost["start"] = ''; jPost["end"] = '';

                    $.ajax({
                        type: "POST",
                        url: "/EA/Form/DocLink",
                        data: JSON.stringify(jPost),
                        success: function (res) {
                            if (res.substr(0, 2) == "OK") {
                                var p = $('#popBlank');
                                p.html(res.substr(2));

                                p.find('.z-lv-cond input.search-text').keyup(function (e) {
                                    if (e.which == 13) _zw.fn.searchLinkedDoc(p, jPost);
                                });

                                p.find('.z-lv-cond .btn[data-zm-menu="search"]').click(function () {
                                    _zw.fn.searchLinkedDoc(p, jPost);
                                });

                                p.find('.pagination li a.page-link').click(function () {
                                    _zw.fn.searchLinkedDoc(p, jPost, $(this).attr('data-for'));
                                });

                                p.find('.z-lv-hdr a[data-val]').click(function () {
                                    var t = $(this); jPost["sort"] = t.attr('data-val');
                                    $('.z-lv-hdr a[data-val]').each(function () {
                                        if ($(this).attr('data-val') == jPost["sort"]) {
                                            var c = t.find('i');
                                            if (c.hasClass('fe-arrow-up')) {
                                                c.removeClass('fe-arrow-up').addClass('fe-arrow-down'); jPost["sortdir"] = 'DESC';
                                            } else {
                                                c.removeClass('fe-arrow-down').addClass('fe-arrow-up'); jPost["sortdir"] = 'ASC';
                                            }
                                        } else {
                                            $(this).find('i').removeClass();
                                        }
                                    });
                                    _zw.fn.searchLinkedDoc(p, jPost);
                                });

                                p.find('.z-lv-row a[href]').click(function () {
                                    _zw.fn.getLinkedDocFile(p, $(this));
                                });

                                p.find('.btn[data-zm-menu="confirm"]').click(function () {
                                    p.find('.zf-linked-list > div[fi]').each(function () {
                                        var fi = $(this);
                                        var lnk = _zw.V.linkeddoc.find(function (element) { if (element.xfalias == fi.attr('xf') && element.msgid == fi.attr('fi')) return true; });
                                        if (lnk == undefined) {
                                            var temp = {};
                                            temp["xfalias"] = fi.attr('xf'); temp["msgid"] = fi.attr('fi');
                                            temp["reserved1"] = decodeURIComponent(fi.attr('fp')); temp["reserved2"] = decodeURIComponent(fi.attr('fn'));
                                            temp["subject"] = fi.find('a[href]').html();

                                            _zw.V.linkeddoc.push(temp); //console.log(_zw.V.linkeddoc);
                                        }
                                    });
                                    //console.log(_zw.V.linkeddoc)
                                    p.modal('hide');
                                });

                                _zw.ut.picker('date');
                                if (_zw.V.linkeddoc.length > 0) {
                                    $.each(_zw.V.linkeddoc, function (idx, v) {
                                        var iPos = v['reserved2'].lastIndexOf('.');
                                        var s = "<div class=\"d-flex align-items-center mb-1\" fi=\"" + v['msgid'] + "\" xf=\"" + v['xfalias'] + "\" fn=\"" + encodeURIComponent(v['reserved2']) + "\" fp=\"" + encodeURIComponent(v['reserved1']) + "\">"
                                            + "<div class=\"mr-1\"><i class=\"" + _zw.fu.fileExt(v['reserved2'].substr(iPos + 1)) + "\"></i></div>"
                                            + "<div class=\"mr-1\"><a class=\"z-lnk-navy\" href=\"/Common/DownloadV?fn=" + encodeURIComponent(_zw.base64.encode(v['reserved2'])) + "&fp=" + encodeURIComponent(_zw.base64.encode(v['reserved1'])) + "\" target=\"_blank\">" + v['subject'] + "</a></div>"
                                            + "<div class=\"text-muted\"><button class=\"btn btn-default btn-sm btn-18\"><i class=\"fe-x\"></i></button></div>"
                                            + "</div>";
                                        p.find('.zf-linked-list').append(s);
                                    });
                                }

                                p.find('.zf-linked-list > div[fi] .btn').click(function () {
                                    var fi = $(this).parent().parent();
                                    var idx = _zw.V.linkeddoc.findIndex(function (element) { if (element.xfalias == fi.attr('xf') && element.msgid == fi.attr('fi')) return true; });
                                    if (idx > -1) _zw.V.linkeddoc.splice(idx, 1); //console.log(_zw.V.linkeddoc);
                                    fi.remove();
                                });

                                p.on('hidden.bs.modal', function () { p.html(''); });
                                p.modal();
                            } else bootbox.alert(res);
                        }
                    });

                } else {
                    var s = '', iCnt = _zw.V.linkeddoc.length;
                    if (_zw.V.linkeddoc.length > 0) {
                        $.each(_zw.V.linkeddoc, function (idx, v) {
                            var iPos = v['reserved2'].lastIndexOf('.');
                            s += "<div class=\"d-flex align-items-center my-2\" fi=\"" + v['msgid'] + "\" xf=\"" + v['xfalias'] + "\" fn=\"" + encodeURIComponent(v['reserved2']) + "\" fp=\"" + encodeURIComponent(v['reserved1']) + "\">"
                                + "<div class=\"mr-1\"><i class=\"" + _zw.fu.fileExt(v['reserved2'].substr(iPos + 1)) + "\"></i></div>"
                                + "<div class=\"mr-1\"><a class=\"z-lnk-navy\" href=\"/Common/DownloadV?fn=" + encodeURIComponent(_zw.base64.encode(v['reserved2'])) + "&fp=" + encodeURIComponent(_zw.base64.encode(v['reserved1'])) + "\" target=\"_blank\">" + v['subject'] + "</a></div>"
                                //+ "<div class=\"text-muted\"><button class=\"btn btn-default btn-sm btn-18\"><i class=\"fe-x\"></i></button></div>"
                                + "</div>";
                        });
                    } else {
                        s = "<div class=\"w-100 text-center py-3\">표시할 항목이 없습니다.</div>";
                    }

                    s = "<div class=\"zf-linked-list overflow-auto h-100 p-2\">" + s + "</div>";

                    var h = iCnt <= 3 ? 105 : (iCnt > 5 ? 175 : iCnt * 35);
                    var j = { "close": true, "width": 550, "height": h, "left": -200, "top": 0 }
                    j["title"] = '관련문서'; j["content"] = s;

                    var pop = _zw.ut.popup($(this)[0], j);
                }
                break;

            case "fileAttach":
                $('#popUploader').modal();
                break;

            case "signLine":
            case "reject":
                var cmd = mn == 'reject' ? mn : _zw.V.apvmode;
                //if (_zw.V.mode == 'new' || _zw.V.mode == 'edit' || _zw.V.mode == 'reuse') cmd = 'draft';
                //else {
                //    if (_zw.V.wid != '' && (_zw.V.partid.indexOf("__") >= 0 || (_zw.V.partid.indexOf("__") < 0 && _zw.V.partid == _zw.V.current.urid))) cmd = 'approval';
                //    else cmd = 'read';
                //}
                var jPost = {};
                jPost["M"] = cmd; jPost["multi"] = 'y'; jPost["boundary"] = _zw.V.boundary; jPost["xf"] = _zw.V.xfalias;
                jPost["fi"] = _zw.V.def.formid; jPost["def"] = _zw.V.def.processid; jPost["oi"] = _zw.V.oid
                jPost["wi"] = _zw.V.wid; jPost["appid"] = _zw.V.appid; jPost["tp"] = _zw.V.tp;

                if (cmd == 'approval') {//SignLine.cshtml > RenderMenuSchemaInfo 위치, 병렬(curprogress) 조건 제외
                    var iCurPart = 0;
                    for (var i = 0; i < _zw.V.process.signline.length; i++) {
                        var n = _zw.V.process.signline[i];
                        if (n["activityid"] == _zw.V.actid && n["viewstate"] != '6') iCurPart++; //주의 curactid X
                    }
                    jPost["curpart"] = iCurPart;
                    //jPost["signline"] = _zw.V.process.signline; jPost["attributes"] = _zw.V.process.attributes;
                }
                _zw.signline.open(cmd, 'y', jPost);
                break;

            case "sendDL":
                var jPost = {};
                jPost["M"] = 'dl'; jPost["multi"] = 'y'; jPost["boundary"] = _zw.V.boundary; jPost["xf"] = _zw.V.xfalias;
                jPost["appid"] = _zw.V.appid; jPost["oi"] = _zw.V.oid; jPost["docstatus"] = _zw.V.docstatus;

                _zw.signline.open('dl', 'y', jPost);
                break;

            case "reuse":
                var qi = '{M:"reuse",mi:"' + _zw.V.appid + '",oi:"' + _zw.V.oid + '",wi:"' + _zw.V.wid + '",xf:"' + _zw.V.xfalias + '"}';
                //console.log(location)
                window.location.href = '?qi=' + _zw.base64.encode(qi);
                break;

            case "draft":
            case "approval":
            case "preApproval":
            case "cancelPreApproval":
                _zw.fn.showSignPlate(mn.toLowerCase());
                break;

            default:
                break;
        }
        $(this).tooltip('hide');
    });

    _zw.fn.searchLinkedDoc = function (p, j, page) {
        j["M"] = 'search';

        var e1 = p.find('.z-lv-cond .start-date');
        var e2 = $('.z-lv-cond .end-date');
        var e3 = $('.z-lv-cond select');
        var e4 = $('.z-lv-cond .search-text');

        if (!page && e1.val() == '' && e2.val() == '' && $.trim(e4.val()) == '') {
            bootbox.alert("검색 조건이 누락됐습니다!"); return;
        }
        var s = "['\\%^&\"*]";
        var reg = new RegExp(s, 'g');
        if (e3.val() != '' && e4.val().search(reg) >= 0) { bootbox.alert(s + " 문자는 사용될 수 없습니다!", function () { e4.val(''); e4.focus(); }); return; }

        j["page"] = page || 1; j["start"] = e1.val(); j["end"] = e2.val();
        j["search"] = $.trim(e4.val()) != '' ? e3.val() : ''; j["searchtext"] = $.trim(e4.val()) != '' ? e4.val() : '';

        $.ajax({
            type: "POST",
            url: "/EA/Form/DocLink",
            data: JSON.stringify(j),
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    p.find('.modal-body').html(res.substr(2));

                    _zw.ut.picker('date');

                    p.find('.z-lv-cond input.search-text').keyup(function (e) {
                        if (e.which == 13) _zw.fn.searchLinkedDoc(p, j);
                    });

                    p.find('.z-lv-cond .btn[data-zm-menu="search"]').click(function () {
                        _zw.fn.searchLinkedDoc(p, j);
                    });

                    p.find('.pagination li a.page-link').click(function () {
                        _zw.fn.searchLinkedDoc(p, j, $(this).attr('data-for'));
                    });

                    p.find('.z-lv-hdr a[data-val]').click(function () {
                        var t = $(this); j["sort"] = t.attr('data-val');
                        $('.z-lv-hdr a[data-val]').each(function () {
                            if ($(this).attr('data-val') == j["sort"]) {
                                var c = t.find('i');
                                if (c.hasClass('fe-arrow-up')) {
                                    c.removeClass('fe-arrow-up').addClass('fe-arrow-down'); j["sortdir"] = 'DESC';
                                } else {
                                    c.removeClass('fe-arrow-down').addClass('fe-arrow-up'); j["sortdir"] = 'ASC';
                                }
                            } else {
                                $(this).find('i').removeClass();
                            }
                        });
                        _zw.fn.searchLinkedDoc(p, j);
                    });

                    p.find('.z-lv-row a[href]').click(function () {
                        _zw.fn.getLinkedDocFile(p, $(this));
                    });
                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.getLinkedDocFile = function (p, el) {
        if (el.attr('acl').charAt(4) != "R") { bootbox.alert('권한이 없습니다!'); return; }
        if (el.attr('sys') == 'PDM') { bootbox.alert('지원하지 않습니다!'); return; }
        
        $.ajax({
            type: "POST",
            url: "/EA/Form/DocLinkFile",
            data: '{M:"",xf:"' + el.attr('xf') + '",mi:"' + el.attr('mi') + '"}',
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    var cDel = String.fromCharCode(8);
                    var v = res.substr(2).split(cDel);

                    var j = { "close": true, "width": 450, "height": (parseInt(v[0]) > 5 ? 175 : parseInt(v[0]) * 35), "left": -50, "top": 0 }
                    j["title"] = ''; j["content"] = v[1];

                    var pop = _zw.ut.popup(el[0], j);
                    pop.find('.btn[data-zm-menu="select"]').click(function () {
                        var fi = $(this);
                        var lnk = _zw.V.linkeddoc.find(function (element) { if (element.xfalias == fi.attr('xf') && element.msgid == fi.attr('fi')) return true; });
                        if (lnk != undefined) {
                            alert('이미 선택되었습니다!');
                        } else {
                            var clone = fi.parent().prev().find('a[href]').clone(true);
                            clone.text(decodeURIComponent(fi.attr('fn')) + ' (' + el.text() + ')');
                            var iPos = fi.attr('fn').lastIndexOf('.'); //console.log(temp["reserved2"].substr(iPos))
                            var s = "<div class=\"d-flex align-items-center mb-1\" fi=\"" + fi.attr('fi') + "\" xf=\"" + fi.attr('xf') + "\" fn=\"" + fi.attr('fn') + "\" fp=\"" + fi.attr('fp') + "\">"
                                + "<div class=\"mr-1\"><i class=\"" + _zw.fu.fileExt(fi.attr('fn').substr(iPos + 1)) + "\"></i></div>"
                                + "<div class=\"mr-1\">" + clone[0].outerHTML + "</div>"
                                + "<div class=\"text-muted\"><button class=\"btn btn-default btn-sm btn-18\"><i class=\"fe-x\"></i></button></div>"
                                + "</div>";
                            p.find('.zf-linked-list').append(s);

                            p.find('.zf-linked-list > div[fi] .btn').click(function () {
                                var fi = $(this).parent().parent();
                                var idx = _zw.V.linkeddoc.findIndex(function (element) { if (element.xfalias == fi.attr('xf') && element.msgid == fi.attr('fi')) return true; });
                                if (idx > -1) _zw.V.linkeddoc.splice(idx, 1); //console.log(_zw.V.linkeddoc);
                                fi.remove();
                            });
                        }
                        pop.find('.close[data-dismiss="modal"]').click();
                    });
                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.showSignPlate = function (cmd) {
        if (cmd == 'draft' || cmd == 'approval') {
            //_zw.form.make('approval', {}); return
            //_zw.signline.make(mn, {}, ''); return;

            var rt = _zw.signline.validation(cmd);
            if (rt == 'N') { $('.zf-menu .btn[data-zf-menu="signLine"]').click(); return false; }
            else if (rt == 'F') return false;

            if (!_zw.form.validation(cmd)) return false;;
        }

        var p = $('#popSignPlate');

        //console.log(p.find('.zf-sl input:radio[name="rdoSignStatus"]:first()'))
        p.find('.zf-sl input:radio[name="rdoSignStatus"]:first()').prop('checked', true);

        p.find('.zf-sl .btn[data-zm-mmenu="send"]').click(function () {
            _zw.fn.sendForm(p, cmd); //$(this).off('click');
        });

        p.on('hide.bs.modal', function () {
            p.find('.zf-sl .btn[data-zm-mmenu="send"]').off('click');
        });
        p.modal();
    }

    _zw.fn.saveTemp = function (cmd) {
        var jSend = {};
        _zw.form.make("draft", jSend);

        if (cmd == 'saveas') jSend["M"] = "savenewtemporary";
        else jSend["M"] = "savetemporary";
        //console.log(jSend); return

        $.ajax({
            type: "POST",
            url: "/EA/Process",
            data: JSON.stringify(jSend),
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    _zw.fn.reloadList(); window.close();
                } else bootbox.alert(res);
            },
            beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
        });
    }

    _zw.fn.sendForm = function (p, cmd) {
        p = p || $('#popSignPlate');

        var eStatus = p.find('.zf-sl input[name="rdoSignStatus"]:checked');
        var eCmnt = p.find('.zf-sl #sp_Comment'), ePwd = p.find('.zf-sl #sp_Password');
        var ss = eStatus.val(), ssText = eStatus.next().text(), szMsg = '';
        var tgt4Back = {};

        if (ss == 'back') {
            var iCheck = p.find('.zf-sl-list input:checkbox:checked').length;
            if (iCheck < 1) { bootbox.alert('반려 대상을 지정 하십시오!'); return false; }
            if (iCheck > 1) { bootbox.alert('반려 대상을 2개 이상 선택할 수 없습니다!'); return false; }

            var row = p.find('.zf-sl-list input:checkbox:checked').parent().parent().parent().parent(); //console.log(row)
            if (row && row.length > 0) {
                tgt4Back["wid"] = row.attr('wid');
                tgt4Back["partid"] = row.attr('partid').indexOf('_') > 0 ? row.attr('partid').split('_')[0] : row.attr('partid');

                szMsg = _zw.parse.bizRole(row.attr('bizrole')) + ' ' + _zw.parse.actRole(row.attr('actrole')) + ' "' + row.find(' > div > div:nth-child(4)').text() + '"에게로 [' + ssText + '] 처리하시겠습니까?';
            }
        }

        if ((ss == 'reject' || ss == 'reserve' || ss == 'disagree') && $.trim(eCmnt.val()) == '') {
            bootbox.alert(ssText + ' 경우는 의견을 반드시 입력해야 합니다!', function () { eCmnt.focus(); }); return false;
        }

        if (!ePwd.prop('disabled') && _zw.V.checkpwd == 'T') {
            if (ePwd.val() == '') { bootbox.alert('결재인증 암호를 입력하십시오!', function () { ePwd.focus(); }); return false; }
            if (!_zw.fn.checkApprovalPassword(ePwd)) return false;
        }
        //alert(ss + " : " + ssText + " : " + eCmnt.val());

        if (ss != 'back') szMsg = '[' + ssText + '] 처리하시겠습니까?';
        bootbox.confirm(szMsg, function (rt) {
            if (rt) {
                var jSend = {};
                if (cmd == 'preapproval' || cmd == 'cancelpreapproval') {
                    jSend["M"] = 'preapproval';
                    jSend["mi"] = _zw.V.appid;
                    jSend["fi"] = _zw.V.def["formid"];
                    jSend["wi"] = _zw.V.wid;
                    jSend["ss"] = ss;
                    jSend["cmnt"] = eCmnt.val();
                    jSend["sign"] = '';
                    jSend["rd"] = '';

                } else {
                    if (ss == 'reject' || ss == 'back' || ss == 'reserve') {
                        _zw.form.make(ss, jSend);
                        _zw.signline.make(ss, jSend["process"], eCmnt.val()); //console.log(tgt4Back)

                        if (ss == 'back' && tgt4Back) jSend["process"]["target"] = tgt4Back;

                        jSend["M"] = ss;
                        jSend["mi"] = _zw.V.appid;
                        jSend["fi"] = _zw.V.def["formid"];
                        jSend["wid"] = _zw.V.wid;
                        jSend["ss"] = ss;
                        jSend["cmnt"] = eCmnt.val();

                    } else {
                        _zw.form.make(cmd, jSend);
                        _zw.signline.make(cmd, jSend["process"], eCmnt.val());

                        jSend["wid"] = _zw.V.wid;
                        jSend["ss"] = ss;
                        jSend["cmnt"] = eCmnt.val();
                        jSend["rd"] = '';

                        jSend["M"] = cmd;
                        if (cmd == 'draft') jSend["M"] = 'newdraft';
                    }
                }
                //console.log(jSend); return

                $.ajax({
                    type: "POST",
                    url: "/EA/Process",
                    data: JSON.stringify(jSend),
                    success: function (res) {
                        if (res.substr(0, 2) == "OK") {
                            //interface 처리 -> agent에서
                            if (res != 'OK') {
                                //var r = res.substr(2).split(String.fromCharCode(8));
                                //$.post("/EA/Process", '{M:"interface", timestamp:"' + r[0] + '"}', function (data, status) {
                                    
                                //});
                            } else {                                
                            }
                            //bootbox.alert('[' + ssText + '] 처리 하였습니다.', function () {
                            //    _zw.fn.reloadList('count'); window.close();
                            //});
                            _zw.fn.reloadList('count'); window.close();
                        } else bootbox.alert(res);
                    },
                    beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
                });
            }
        });
    }

    _zw.fn.checkApprovalPassword = function (pwd) {
        var rt = false;
        $.ajax({
            type: "POST",
            url: "/EA/Process",
            data: '{M:"chkpwd", pwd:"' + pwd.val() + '"}',
            async: false,
            success: function (res) {
                if (res != 'T') {
                    if (res == 'F') { bootbox.alert('인증에 실패 했습니다. 암호를 재입력 하십시오!', function () { pwd.val(''); pwd.focus(); }); }
                    else bootbox.alert(res);
                    rt = false;
                } else rt = true;
            },
            beforeSend: function () {}
        });
        return rt;
    }

    _zw.fn.orgSelect = function (p, el) { if (_zw.formEx.orgSelect) _zw.formEx.orgSelect(p, el); }
    _zw.fn.onblur = function (e, v) {
        if (v[0] == "month") {
            if (parseInt(e.value) < 1 || parseInt(e.value) > 12) { e.value = ''; e.focus(); return false; }
            if (_zw.formEx.calc) _zw.formEx.calc(e, v);
        }
        else if (v[0] == "number" || v[0] == "number-n" || v[0] == "percent") { if (_zw.formEx.calc) _zw.formEx.calc(e, v); }
        else if (v[0] == "date" || v[0] == "time") {
            if (v[1] && v[1] == "yyyy") {
                if (parseInt(e.value) < 1970 || parseInt(e.value) > 2099) { e.value = ''; e.focus(); return false; }
            }
            if (_zw.formEx.date) _zw.formEx.date(e, v);
        }
    }

    _zw.fn.reloadList = function (opt) {
        try {
            if (opener != null) {
                if (opener._zw.fn.reloadList) {
                    opt = opt || 'ea'; opener._zw.fn.reloadList(opt);

                } else if (opener._zw.mu.search) {
                    if (opener._zw.V.ctalias == 'ea') opener._zw.mu.search(opener._zw.V.lv.page, 'count'); //부모창이 결재인 경우만 우선 적용
                }
            } //else opener.location.reload();
        } catch (e) {
            //opener.location.reload();
        };
    }

    _zw.fn.importFile = function (cd) {
        cd = cd || '';
        var url = '/Common/FileImport?M=' + _zw.V.def.maintable + '&sy=&cd=' + cd;
        if (_zw.V.ft == 'SHIPMENTUC') url += "&gg=" + $('#__mainfield[name="PRODUCTCENTER"]').val() + "&gg2=" + $('#__mainfield[name="SALECENTER"]').val() + "&gg3=" + $('#__mainfield[name="CURRENCY"]').val() + "&gg4=" + $('#__mainfield[name="VENDOR_CODE"]').val();

        $.ajax({
            type: "POST",
            url: url,
            success: function (res) {
                var p = $('#popBlank');
                p.html(res); _zw.fu.bind();
                p.find('#uploadForm')[0].action = url;

                p.on('hidden.bs.modal', function () { p.html(''); });
                p.modal();
            }
        });
    }

    _zw.fn.complete = function (msg) {
        var p = $('#popBlank');
        p.find('.zf-upload #uploadForm')[0].reset();

        var rt = decodeURIComponent(msg).replace(/\+/gi, ' ');
        if (rt.substr(0, 2) == 'OK') {
            var footer = '<div class="modal-footer justify-content-center">'
                + '<button type="button" class="btn btn-primary" data-zm-menu="confirm">확인</button>'
                + '<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>'
                + '</div>';

            p.find('.zf-upload .zf-upload-list').html(rt.substr(2)).removeClass('d-none');
            p.find('.modal-content').append(footer);

            p.find('.modal-footer .btn[data-zm-menu="confirm"]').click(function () {
                var rt = p.find('.zf-upload .zf-upload-list #__RESULTINFO');
                if (rt.length > 0 && rt.html != '') {
                    //console.log(p.find('.zf-upload .zf-upload-list #__RESULTINFO').html())
                    var j = JSON.parse(p.find('.zf-upload .zf-upload-list #__RESULTINFO').html()); console.log(j)
                    if (j.length > 0) { //console.log(j[0][0] + " : " + j[1][0])
                        var tbl = $('#__subtable1'), len = tbl.find('tr.sub_table_row').length;
                        tbl.find('tr.sub_table_row').each(function () {
                            _zw.form.resetField($(this));
                        });
                        if (j.length - 1 > len) {
                            for (var i = 0; i < j.length - 1 - len; i++) _zw.form.addRow('__subtable1');
                        }
                        tbl.find('tr.sub_table_row').each(function (idx) {
                            if (idx >= j.length - 1) return false;
                            for (var i = 0; i < j[0].length; i++) {
                                $(this).find('td [name="' + j[0][i] + '"]').val(j[idx + 1][i]);
                            }
                        });
                    }
                }
                p.modal('hide');
            });

        } else {
            p.find('.zf-upload .zf-upload-list').html(rt).removeClass('d-none');
        }
        p.find('.zf-upload .zf-upload-bar').addClass('d-none');
        if (p.find('.modal-dialog').hasClass('modal-sm')) p.find('.modal-dialog').removeClass('modal-sm');
    }

    _zw.signline = {
        "open": function (m, multi, postData) {
            var p = $('#popSignLine');

            if (m == 'draft' || m == 'approval' || m == 'dl') {
                if (p.find('.zf-sl[data-for="' + m + '"]').length > 0) { //console.log('1111')
                    _zw.signline.render(p, m);
                    p.modal('show');

                } else {
                    $.ajax({
                        type: "POST",
                        url: "/EA/Form/SignLine",
                        data: JSON.stringify(postData),
                        success: function (res) {
                            if (res.substr(0, 2) == "OK") {
                                var v = res.substr(2).split(_zw.V.boundary); //console.log(JSON.parse(v[1]))
                                p.html(v[0]);

                                if (p.find('#sl_orgmaptree').length > 0) new PerfectScrollbar(p.find('#sl_orgmaptree')[0]);
                                if (p.find('#personline').length > 0) new PerfectScrollbar(p.find('#personline')[0]);
                                new PerfectScrollbar(p.find('.zf-sl .zf-sl-member .card:first-child .card-body')[0]);
                                if (p.find('.zf-sl .zf-sl-member .card').length > 1) new PerfectScrollbar(p.find('.zf-sl .zf-sl-member .card:last-child .card-body')[0]);
                                if (p.find('.zf-sl .zf-sl-list').length > 0) new PerfectScrollbar(p.find('.zf-sl .zf-sl-list .card-body')[0]);
                                if (p.find('.zf-sl .zf-dl-list').length > 0) new PerfectScrollbar(p.find('.zf-sl .zf-dl-list .card-body')[0]);

                                p.find('.nav-tabs-top a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                                    var s = e.target.getAttribute('aria-controls');
                                    if (s == 'personline') {
                                        p.find('.zf-sl .zf-sl-member .card:first-child').addClass('d-none');
                                        p.find('.zf-sl .zf-sl-member .card:last-child').removeClass('d-none');
                                    } else {
                                        if (p.find('.zf-sl .zf-sl-member .card').length > 1) {
                                            p.find('.zf-sl .zf-sl-member .card:first-child').removeClass('d-none');
                                            p.find('.zf-sl .zf-sl-member .card:last-child').addClass('d-none');
                                        }
                                    }
                                    p.find('.zf-sl .zf-sl-member .card-body').html('');
                                });

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
                                }).on('select_node.jstree', function (e, d) {
                                    if (d.selected.length == 1) {
                                        var n = d.instance.get_node(d.selected[0]);
                                        if ('7777.' + n.id == _zw.V.opnode) return false; //'7777.' => 부서명 Navigation에 사용
                                        if (n.li_attr.hasmember == 'Y') {
                                            $.ajax({
                                                type: "POST",
                                                url: "/Organ/Plate",
                                                data: '{M:"member",grid:"' + n.id + '",boundary:"' + _zw.V.boundary + '"}',
                                                success: function (res) {
                                                    if (res.substr(0, 2) == "OK") {
                                                        p.find('.zf-sl .zf-sl-member .card:first-child .card-body').html(res.substr(2));
                                                        _zw.signline.userInfo(p, multi);
                                                    } else bootbox.alert(res);
                                                },
                                                beforeSend: function () { } //로딩 X
                                            });
                                        }
                                    }
                                });

                                p.find('#__OrgMapSearch input[data-for]').keyup(function (e) {
                                    if (e.which == 13) p.find('#__OrgMapSearch .btn-outline-success').click();
                                });

                                p.find('#__OrgMapSearch .btn-outline-success').click(function () {
                                    var j = {}; j['M'] = 'search'; j['boundary'] = _zw.V.boundary;
                                    var bSearch = false;

                                    if (p.find('#sl_orgmapsearch').hasClass('active')) {//검색창 활성화 여부
                                        var s = "['\\%^&\"*]";
                                        var reg = new RegExp(s, 'g');

                                        p.find('#__OrgMapSearch [data-for]').each(function () {
                                            if ($(this).val() != '') {
                                                if ($(this).val().search(reg) >= 0) {
                                                    //bootbox.alert(s + " 문자는 사용될 수 없습니다!", function () { $(this).val(''); $(this).focus(); });
                                                    alert(s + " 문자는 사용될 수 없습니다!");
                                                    $(this).val(''); $(this).focus();
                                                    return false;
                                                } else bSearch = true;
                                            }
                                        });
                                    }

                                    if (bSearch) {
                                        p.find('#__OrgMapSearch [data-for]').each(function () {
                                            j[$(this).attr('data-for')] = $(this).val();
                                        });

                                        $.ajax({
                                            type: "POST",
                                            url: "/Organ/Plate",
                                            data: JSON.stringify(j),
                                            success: function (res) {
                                                if (res.substr(0, 2) == "OK") {
                                                    p.find('.zf-sl .zf-sl-member .card:first-child .card-body').html(res.substr(2));
                                                    _zw.signline.userInfo(p, multi);
                                                } else bootbox.alert(res);
                                            },
                                            beforeSend: function () { } //로딩 X
                                        });
                                    }
                                });

                                p.find('#personline :checkbox').click(function () {
                                    var id = $(this).parent().attr('id');
                                    if ($(this).prop('checked')) {
                                        p.find('#personline :checkbox').each(function () {
                                            if ($(this).parent().attr('id') != id) $(this).prop('checked', false);
                                        });
                                        $.ajax({
                                            type: "POST",
                                            url: "/EA/Form/SignLine",
                                            data: '{M:"personlinedetail",lineid:"' + id.split('_')[1] + '"}',
                                            success: function (res) {
                                                if (res.substr(0, 2) == "OK") {
                                                    p.find('.zf-sl .zf-sl-member .card:last-child .card-body').html(res.substr(2));
                                                    _zw.signline.userInfo(p, multi);
                                                } else bootbox.alert(res);
                                            },
                                            beforeSend: function () { } //로딩 X
                                        });
                                    } else {
                                        p.find('.zf-sl .zf-sl-member .card:last-child .card-body').html('');
                                    }
                                });

                                p.find('.zf-sl .zf-sl-menu .btn[data-zm-menu]').click(function () {
                                    var mn = $(this).attr('data-zm-menu'), cmd = $(this).attr('data-val'); //alert(mn + " : " + vlu)
                                    var tab = p.find('.nav-tabs-top .tab-pane.active').attr('id');
                                    var eTargetActivity = null, vPartType = null;

                                    if (mn == 'addUser') {
                                        if (tab != 'personline') {
                                            var bDL = false;

                                            if (cmd && cmd != '') {
                                                if (cmd == "mail_dl" || cmd == "xform_dl" || cmd == "xform_cf") bDL = true;
                                                else eTargetActivity = _zw.V.schema.find(function (element) { if (element.actid === cmd) return true; });
                                            } else {
                                                eTargetActivity = _zw.V.schema.find(function (element) { if (element.bizrole === _zw.V.curbiz && element.actrole === '_reviewer') return true; });
                                            }

                                            if (eTargetActivity) vPartType = eTargetActivity["parttype"].split('_');
                                            else if (!bDL) return false;

                                            p.find('.zf-sl .zf-sl-member .card:first-child .card-body input:checkbox:checked').each(function () {
                                                var jUser = JSON.parse($(this).attr('data-attr')); //console.log(jUser); return;

                                                if (bDL || vPartType[1] == 'h') { //2014-06-30 배포,참조 외 결재자 중복 가능하게
                                                    if (!_zw.signline.check(p, 'ur', eTargetActivity, jUser.id, cmd)) {
                                                        bootbox.alert('중복된 사용자는 추가 할 수 없습니다!'); return false;
                                                    }
                                                }
                                                _zw.signline.add(p, bDL || vPartType[1] == 'h' ? cmd : '', 'ur', eTargetActivity, jUser, $(this).next().text());
                                            });
                                        }
                                    } else if (mn == 'addGroup') {
                                        if (tab == 'sl_orgmaptree') {
                                            var selected = p.find('#__OrgMapTree').jstree('get_selected', true); //console.log(selected)
                                            if (selected.length > 0) {
                                                var info = selected[0].li_attr; //alert(selected[0].text)
                                                //2012-01-09 3단계 아래만 선택하게, 2015-09-02 1단계부터 선택하게
                                                if (parseInt(info["level"]) < 1) { bootbox.alert('선택된 부서는 추가 할 수 없습니다!'); return false; }
                                                //2016-04-22 문서수신정책 적용
                                                if (info["rcv"] && info["rcv"] == 'N') { bootbox.alert('선택된 부서는 추가 할 수 없습니다!'); return false; }

                                                var bAdd = true;
                                                if (cmd == "mail_dl" || cmd == "xform_dl") {
                                                    if (!_zw.signline.check(p, 'gr', null, info["id"], cmd)) bAdd = false;
                                                } else {
                                                    eTargetActivity = _zw.V.schema.find(function (element) { if (element.actid === cmd) return true; });
                                                    if (eTargetActivity) vPartType = eTargetActivity["parttype"].split('_');
                                                    else return false;

                                                    if (info["hasmember"] == 'Y') {
                                                        if (!_zw.signline.check(p, 'gr', eTargetActivity, info["id"], cmd)) bAdd = false;
                                                    } else bAdd = false;
                                                }

                                                if (!bAdd) { bootbox.alert('중복된 부서는 추가 할 수 없습니다!'); return false; }

                                                _zw.signline.add(p, cmd == "mail_dl" || cmd == "xform_dl" || vPartType[1] == 'h' ? cmd : '', 'gr', eTargetActivity, info, selected[0].text);
                                            }
                                        }
                                    } else if (mn == 'insertPersonLine') {
                                        if (tab == 'personline') {
                                            bootbox.alert('준비중')
                                        }
                                    } else if (mn == 'addUser_dl') {
                                        p.find('.zf-sl .zf-sl-member .card:first-child .card-body input:checkbox:checked').each(function () {
                                            var jUser = JSON.parse($(this).attr('data-attr')); //console.log(jUser); return;
                                            if ($('.zf-sl .zf-dl-list .zf-sl-line li[pt="ur"][partid="' + jUser.id + '"]').length > 0) {
                                                bootbox.alert('중복된 사용자는 추가 할 수 없습니다!'); return false;
                                            }

                                            var temp = p.find('.zf-dl-template').html();
                                            temp = temp.replace("{$pt}", "ur");
                                            temp = temp.replace("{$ptid}", jUser.id);
                                            temp = temp.replace("{$code}", jUser.logonid);
                                            temp = temp.replace("{$mail}", jUser.smail);
                                            temp = temp.replace("{$pn}", $(this).next().text());

                                            $('.zf-sl .zf-dl-list .zf-sl-line').append(temp);
                                        });

                                    } else if (mn == 'addGroup_dl') {
                                        var selected = p.find('#__OrgMapTree').jstree('get_selected', true); //console.log(selected)
                                        if (selected.length > 0) {
                                            var info = selected[0].li_attr; //alert(selected[0].text)
                                            if (parseInt(info["level"]) < 1) { bootbox.alert('선택된 부서는 추가 할 수 없습니다!'); return false; }
                                            if (info["rcv"] && info["rcv"] == 'N') { bootbox.alert('선택된 부서는 추가 할 수 없습니다!'); return false; }

                                            if ($('.zf-sl .zf-dl-list .zf-sl-line li[pt="gr"][partid="' + info["id"] + '"]').length > 0) {
                                                bootbox.alert('중복된 부서는 추가 할 수 없습니다!'); return false;
                                            }

                                            var temp = p.find('.zf-dl-template').html();
                                            temp = temp.replace("{$pt}", "gr");
                                            temp = temp.replace("{$ptid}", info["id"]);
                                            temp = temp.replace("{$code}", info["gralias"]);
                                            temp = temp.replace("{$mail}", info["gralias"] + '@' + _zw.V.domain);
                                            temp = temp.replace("{$pn}", selected[0].text);

                                            $('.zf-sl .zf-dl-list .zf-sl-line').append(temp);
                                        }
                                    }
                                });

                                p.find('.zf-sl .zf-sl-submenu .btn[data-zm-menu]').click(function () {
                                    var mn = $(this).attr('data-zm-menu'); //alert(mn)
                                    if (mn == 'refresh') {
                                        _zw.signline.render(p, m);

                                    } else if (mn == 'delete') {
                                        p.find('.zf-sl-list input:checkbox:checked').each(function () {
                                            var row = $(this).parent().parent().parent().parent(), rowParent = row.parent(); //console.log(row)
                                            if (row.attr('wid') != '') _zw.signline.putDeleteLine(row.attr('wid'));
                                            row.remove();
                                            _zw.signline.setOrder(p, rowParent.find(' > li'));
                                        });

                                        p.find('.zf-dl-list input:checkbox:checked').each(function () {
                                            var row = $(this).parent().parent().parent().parent(); row.remove();
                                        });

                                    } else if (mn == 'up' || mn == 'down') {
                                        _zw.signline.move(p, mn);
                                    }
                                });

                                p.find('.modal-header .btn[data-zm-menu="confirm"]').click(function () {
                                    _zw.V.templine["signline"] = []; //초기화
                                    _zw.V.templine["attributes"] = []; //초기화

                                    _zw.signline.composeLine(p, '.zf-sl-list .zf-sl-line > li');
                                    _zw.signline.composeLine(p, '.zf-sl-list .zf-sl-subline > li');
                                    _zw.signline.composeAttr(p);

                                    _zw.signline.space(_zw.V.templine["signline"]); //console.log(_zw.formEx)
                                    _zw.signline.toFormBody(_zw.V.templine["signline"]);

                                    //console.log(_zw.V.templine);
                                    p.modal('hide');
                                });

                                p.find('.modal-header .btn[data-zm-menu="send"]').click(function () {
                                    var vlu = '';
                                    p.find('.zf-dl-list li.zf-dl-add').each(function () {
                                        vlu += '<part partid="' + $(this).attr('partid') + '" pt="' + $(this).attr('pt') + '" pc="' + $(this).attr("pc") + '">'
                                            + '<pn>' + $(this).find("div > div:nth-child(2)").text() + '</pn><pm>' + $(this).attr("pm") + '</pm></part>';
                                    });
                                    //console.log(vlu)
                                    if (vlu != '') {
                                        bootbox.confirm('현 문서를 추가된 목록에 배포하시겠습니까?', function (rt) {
                                            if (rt) {
                                                var jSend = {};
                                                jSend["xf"] = _zw.V.xfalias; jSend["mi"] = _zw.V.appid; jSend["oi"] = _zw.V.oid;
                                                jSend["dt"] = 'xform_dl'; jSend["dp"] = ''; jSend["vlu"] = '<partinfo>' + vlu + '</partinfo>';
                                                jSend["sdid"] = _zw.V.current.urid; jSend["sd"] = _zw.V.current.user;
                                                jSend["sdmail"] = ''; jSend["sddept"] = _zw.V.current.dept; jSend["rsvd"] = '';
                                                //console.log(jSend); return

                                                $.ajax({
                                                    type: "POST",
                                                    url: "/EA/Form/SendDL",
                                                    data: JSON.stringify(jSend),
                                                    success: function (res) {
                                                        if (res == "OK") window.close();
                                                        else bootbox.alert(res);
                                                    },
                                                    beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
                                                });
                                            }
                                        });

                                    }
                                });

                                if (p.find('.zf-sl-template-part').length > 0) {
                                    var jPart = JSON.parse(p.find('.zf-sl-template-part').text()); //console.log(jPart);
                                    for (var i = jPart.length - 1; i >= 0; i--) {
                                        //22-07-13 조건 추가 (크레신 "마스터파일변경의뢰서" 프로세스 처리에 필요)
                                        var ln = _zw.V.process.signline.find(function (element) { if (element.activityid == jPart[i]["activityid"] && element.partid.split('_')[0] == jPart[i]["partid"] && element.viewstate == '3') return true; })
                                        //console.log(jPart[i]["activityid"] + " : " + jPart[i]["partid"]); console.log(ln);
                                        if (typeof ln === 'undefined') _zw.V.process.signline.push(jPart[i]);
                                    }
                                }

                                if (p.find('.zf-sl-template-attr').length > 0) {
                                    var jAttr = JSON.parse(p.find('.zf-sl-template-attr').text());
                                    for (var i = 0; i < jAttr.length; i++) _zw.V.process.attributes.push(jAttr[i]);
                                    //console.log(_zw.V.process.attributes);
                                }

                                if (m != 'dl') {
                                    if (!_zw.V.templine) _zw.V["templine"] = JSON.parse('{"signline":[],"attributes":[],"deleted":""}');
                                    //console.log(_zw.V.process["signline"]);

                                    _zw.signline.render(p, m);
                                    _zw.signline.userInfo(p, multi);
                                }

                                p.modal('show');
                            } else bootbox.alert(res);
                        }
                    });
                }

            } else if (m == 'read' || m == 'reject') {
                if (p.find('.zf-sl[data-for="' + m + '"]').length > 0) {
                    _zw.signline.render(p, m);
                    p.modal('show');

                } else {
                    $.ajax({
                        type: "POST",
                        url: "/EA/Form/SignLine",
                        data: JSON.stringify(postData),
                        success: function (res) {
                            if (res.substr(0, 2) == "OK") {
                                p.html(res.substr(2));

                                new PerfectScrollbar(p.find('.zf-sl .zf-sl-list .card-body')[0]);

                                if (p.find('.zf-sl-template-part').length > 0) {
                                    var jPart = JSON.parse(p.find('.zf-sl-template-part').text()); //console.log(jPart);
                                    for (var i = jPart.length - 1; i >= 0; i--) _zw.V.process.signline.push(jPart[i]);
                                }

                                p.find('.zf-sl .btn[data-zm-menu="send"]').click(function () {
                                    _zw.fn.sendForm(p, m);
                                });

                                _zw.ut.maxLength('bottom-right-inside');
                                _zw.signline.render(p, m);

                                p.modal('show');
                            } else bootbox.alert(res);
                        }
                    });
                }
            }
        },
        "render": function (p, m) {
            p.find('.zf-sl-list .zf-sl-line').html(''); p.find('.zf-sl-attr .tab-pane').html('');

            var signLine = _zw.V.templine && _zw.V.templine.signline.length > 0 ? _zw.V.templine.signline : _zw.V.process.signline;
            var attrList = _zw.V.templine && _zw.V.templine.attributes.length > 0 ? _zw.V.templine.attributes : _zw.V.process.attributes;
            
            var ln = signLine.filter(function (element) { if (element.parent === '') return true; }); //console.log(ln);
            var curln = _zw.V.act != '' && _zw.V.wid != '' ? signLine.find(function (element) { if (element.wid === _zw.V.wid) return true; }) : null; //console.log(curln);
            var pfln = _zw.V.pwid != '' ? signLine.find(function (element) { if (element.wid === _zw.V.pwid) return true; }) : null; //console.log(pfln);

            var temp = p.find('.zf-sl-template').html();
            for (var i = 0; i < ln.length; i++) {
                var sub = signLine.filter(function (element) {
                    if (element.parent != '' && element.parent === ln[i].wid) return true;
                }); //console.log(sub)

                p.find('.zf-sl-list .zf-sl-line').append(_zw.signline.template(m, temp, ln[i], curln, pfln, sub));

                if (sub && sub.length > 0) {
                    p.find('.zf-sl-list .zf-sl-line > li[wid="' + ln[i].wid + '"]').append('<ul class="zf-sl-subline pb-0"></ul>');
                    for (var j = 0; j < sub.length; j++) {
                        p.find('.zf-sl-list .zf-sl-line > li[wid="' + ln[i].wid + '"] .zf-sl-subline').append(_zw.signline.template(m, temp, sub[j], curln, pfln, null));
                    }
                }
            }

            for (var i = 0; i < attrList.length; i++) {
                var att = attrList[i].att;
                if (att != 'mail_dl') {
                    $(attrList[i].value).find('part').each(function (idx) {
                        var sId = '', sHtml = '';
                        if (att.indexOf('xform_') >= 0) {
                            sId = $(this).attr('pt') + "." + $(this).attr('partid');
                            sHtml = '<button class="btn rounded btn-outline-secondary px-2 py-1 m-1" id="' + sId + '" code="' + $(this).attr('pc') + '" mail="' + $(this).find('pm').text() + '" pn="' + $(this).find('pn').text() + '">' + $(this).find('pn').text() + '</button>';
                        } else {
                            sId = $(this).attr('type') + "." + $(this).attr('partid');
                            sHtml = '<button class="btn rounded btn-outline-secondary p-1 m-1" id="' + sId + '" code="' + $(this).attr('code') + '" dc="' + $(this).attr('dc') + '" pn="' + $(this).find('pn').text() + '">' + $(this).find('dn').text() + '<i class="fe-x ml-1"></i></button>';
                        }
                        var query = '.zf-sl-attr #attList_' + (att.indexOf('xform_') >= 0 ? att : attrList[i].actid);
                        p.find(query).append(sHtml); //console.log(p.find(query))
                    });
                }
            }

            p.find('.zf-sl-list .zf-sl-line .btn[aria-expanded]').click(function () {
                var row = $(this).parent().parent().parent();
                if ($(this).attr('aria-expanded') == 'false') {
                    $(this).attr('aria-expanded', 'true');
                    $(this).find('i').removeClass('fa-minus').addClass('fa-plus');
                    row.find('ul.zf-sl-subline').hide();
                } else {
                    $(this).attr('aria-expanded', 'false');
                    $(this).find('i').addClass('fa-minus').removeClass('fa-plus');
                    row.find('ul.zf-sl-subline').show();
                }
            });

            p.find('.zf-sl-list .zf-sl-line a[data-toggle="popover"]').popover({
                html: true,
                //trigger: 'focus',
                title: function () { return $(this).text(); },
                content: function () {
                    var row = $(this).parent().parent().parent(); //console.log(row.find('div[title]'))
                    var s = '<table class="table table-bordered table-sm mb-0" style="min-width: 15rem">'
                        + '<tbody>'
                        + '<tr><th style="width: 30%">결재상태</th><td style="width: 70%">' + _zw.parse.signStatus(row.attr("signstatus")) + ' (' + _zw.parse.workItemState(row.attr("state")) + ')</td></tr>'
                        + '<tr><th>받은시각</th><td>' + row.find('div[title]')[1].getAttribute('title') + '</td></tr>'
                        + '<tr><th>결재시각</th><td>' + row.find('div[title]')[0].getAttribute('title') + '</td></tr>'
                        + '<tr><th colspan="2">의견</th></tr>'
                        + '<tr><td colspan="2" style="height: 3rem">' + row.find('div.d-flex div:last-child').html() + '</td></tr>'
                        + '</tbody>'
                        + '</table>';
                    return s;
                }
            });

            p.find('.zf-sl-attr .tab-pane .btn:has(i.fe-x)').click(function () {
                $(this).remove();
            });
        },
        "add": function (p, cmd, ot, act, info, nm) { //console.log(info);
            var query = '';
            if (cmd != '') {
                var code = ot == 'gr' ? info["gralias"] : info["logonid"];
                var mail = (ot == 'gr' ? info["gralias"] + '@' + _zw.V.domain : info["smail"]) + ';' + nm;
                var dp = ot == 'gr' ? nm : info["grdn"] + '.' + nm;
                sHtml = '<button class="btn rounded btn-outline-secondary p-1 m-1" id="' + ot + '.' + info["id"] + '" code="' + code
                    + '" mail="' + mail + '" dc="' + info["gralias"] + '" pn="' + nm + '">' + dp + '<i class="fe-x ml-1"></i></button>';

                p.find('.zf-sl-attr #attList_' + cmd).append(sHtml);
                p.find('.zf-sl-attr .tab-pane .btn:has(i.fe-x)').click(function () {
                    $(this).remove();
                });

            } else if (act != null) {
                var eCurActivity = _zw.V.schema.find(function (element) { if (element.actid === _zw.V.curactid) return true; });
                var tgtList = null, rowTarget = null;
                var iStep = parseInt(act["step"]), iCurrent = 0;

                //결재자를 추가할 위치 찾기 start => 2010-09-03 변경
                if (act["parentactid"] == eCurActivity["parentactid"]) {
                    query = eCurActivity["parentactid"] != '' && _zw.V.pwid != '' ? '.zf-sl-line > li[wid="' + _zw.V.pwid + '"] .zf-sl-subline > li' : '.zf-sl-line > li';
                    tgtList = p.find(query);
                    tgtList.each(function (idx) {
                        if ($(this).hasClass('zf-sl-current')) { iCurrent = idx; return false; }
                    });
                } else {
                    query = '.zf-sl-line > li';
                    tgtList = p.find(query);
                    tgtList.each(function (idx) {
                        if ($(this).attr('actid') == eCurActivity["parentactid"]) { iCurrent = idx; return false; }
                    });
                }
                //console.log(act["parentactid"] + " : " +  eCurActivity["parentactid"])

                if (act["random"] == 'Y' && act["progress"] != 'serial') {
                    for (var i = iCurrent; i < tgtList.length; i++) {
                        if (tgtList[i].getAttribute('actid') == act["actid"]) { bootbox.alert('지정할 수 없는 단계입니다!'); return false; }
                    }
                    tgtList.each(function (idx) {
                        if (idx <= iCurrent) {
                            if ($(this).attr('actid') == act["actid"]) { rowTarget = $(this); return false; }
                        }
                    });
                }
                if (rowTarget == null) {
                    tgtList.each(function (idx) {
                        if (idx <= iCurrent) {
                            rowTarget = $(this);
                            var tgtAct = _zw.V.schema.find(function (element) { if (element.actid === rowTarget.attr('actid')) return true; });
                            if (tgtAct && parseInt(tgtAct["step"]) <= iStep) return false;
                        }
                    });
                } //console.log(rowTarget)

                if (rowTarget == null) { bootbox.alert("추가 할 위치가 적절치 않거나 위치가 지정되지 않았습니다!\n**초기화 버튼을 클릭하시기 바랍니다!"); return false; }
                var bClone = rowTarget.attr('actid') == act["actid"] && rowTarget.attr('partid') == '' ? false : true;
                
                if (rowTarget.attr('partid') != '' && act["progress"] == '' && rowTarget.attr('actid') == act["actid"]) {
                    if (ot == 'ur' && (rowTarget.attr('state') == '2' || rowTarget.attr('state') == '7')) return false;
                    if (!window.confirm("선택된 단계는 이미 지정되어 있습니다! 변경하시겠습니까?")) return false;
                    else bClone = false;
                    _zw.signline.putDeleteLine(rowTarget.attr('wid'));
                }

                var sOrderNo = '', vOrderNo = rowTarget.find(' > div > div:nth-child(2)').text().split('.'); //console.log(rowTarget.find(' > div > div:nth-child(2)'))
                if (bClone) {
                    if (act["progress"] == 'parallel') {
                        if (rowTarget.attr('actid') == act["actid"]) sOrderNo = vOrderNo[0] + "." + (parseInt(vOrderNo[1]) + 1);
                        else sOrderNo = (parseInt(vOrderNo[0]) + 1) + "." + 1;
                    } else {
                        sOrderNo = parseInt(vOrderNo[0]) + 1; //alert(sOrderNo)
                    }
                } else {
                    sOrderNo = rowTarget.find('div div:nth-child(2)').text();
                }

                var temp = p.find('.zf-sl-template').html(), sHtml = '';
                var pwid = _zw.V.pwid != "" && act["parentactid"] == eCurActivity["parentactid"] ? _zw.V.pwid : '';
                //s, orderNo, parent, partId, actId, bizRole, actRole, partType, part2, part5, partName, dept, deptCode
                if (ot == 'gr') sHtml = _zw.signline.template2(temp, sOrderNo, pwid, info["id"], act["actid"], act["bizrole"], act["actrole"], act["parttype"], info["gralias"], '', nm, '', info["gralias"]);
                else sHtml = _zw.signline.template2(temp, sOrderNo, pwid, info["id"], act["actid"], act["bizrole"], act["actrole"], act["parttype"], info["logonid"], info["grade"], nm, info["grdn"], info["gralias"]);
                if (bClone) rowTarget.before(sHtml);
                else rowTarget.replaceWith(sHtml);

                _zw.signline.setOrder(p, p.find(query), rowTarget);
            }
        },
        "move": function (p, dir) {
            var iCheck = p.find('.zf-sl-list input:checkbox:checked').length;
            if (iCheck < 1) return false;
            if (iCheck > 1) { bootbox.alert('결재선을 2개 이상 선택할 수 없습니다!'); return false; }

            var row = p.find('.zf-sl-list input:checkbox:checked').parent().parent().parent().parent(), rowParent = row.parent();; //console.log(row)
            var eSelectedAct = _zw.V.schema.find(function (element) { if (element.actid === row.attr('actid')) return true; });
            if (eSelectedAct["random"] == 'N' && (eSelectedAct["progress"] == '' || eSelectedAct["parttype"].split('_')[1] == 'h')) {
                bootbox.alert('선택된 사용자(부서)는 이동할 수 없습니다!'); return false;
            }

            var rowTarget = dir == 'up' ? row.prev() : row.next(); //console.log(rowTarget)
            if (rowTarget == null || rowTarget == undefined || rowTarget.length == 0 || rowTarget.attr('actid') == undefined || rowTarget.hasClass('zf-sl-current')) return false;

            var eTargetAct = _zw.V.schema.find(function (element) { if (element.actid === rowTarget.attr('actid')) return true; });
            if (rowTarget.hasClass('zf-sl-read')) {
                //랜덤이고 단계가 같은 경우는 이동 가능
                if (eSelectedAct["random"] == 'N' || eTargetAct["random"] == 'N' || eSelectedAct["step"] != eTargetAct["step"]) return false;
            }

            if (row.attr('actid') == rowTarget.attr('actid')) {
                //서로 같은 단계는 순차,병렬일 경우 이동 가능하다.
                var c = row.find(' > div > div:nth-child(2) span.custom-control-label').length > 0 ? row.find(' > div > div:nth-child(2) span.custom-control-label') : row.find(' > div > div:nth-child(2)');
                var t = rowTarget.find(' > div > div:nth-child(2) span.custom-control-label').length > 0 ? rowTarget.find(' > div > div:nth-child(2) span.custom-control-label') : rowTarget.find(' > div > div:nth-child(2)');
                var szNo = t.text();
                t.text(c.text()); c.text(szNo);
                if (dir == 'up') { row.after(rowTarget); } else { row.before(rowTarget); }
            } else {
                //서로 다른 단계에서는 서로 Random일 경우만 이동 가능하다.
                if (eSelectedAct["random"] == 'N' || eTargetAct["random"] == 'N') {
                    //alert("이동할 수 없습니다!");
                } else {
                    //추후 적용
                }
            }
        },
        "check": function (p, ot, act, partid, att) {//console.log(ot + " : " + partid + " : " + att)
            var bRt = true;
            if (act != null) {
                var vPartType = act.parttype.split('_');
                if (vPartType[1] == 'h') {
                    p.find('.zf-sl-attr a[href="#attList_' + act.actid + '"]').tab('show');
                    p.find('.zf-sl-attr #attList_' + act.actid).children().each(function (idx, el) {
                        if (ot + '.' + partid == el.id) { bRt = false; return false; }
                    });
                } else {
                    if (ot == 'gr') {
                        if (p.find('.zf-sl-list .zf-sl-line li[bizrole="' + act.bizrole + '"][partid="' + partid.split('_')[0] + '"]').length > 0) { bRt = false; return false; }
                    }
                }

            } else if (att != null && (att == 'mail_dl' || att == 'xform_dl' || att == 'xform_cf')) {
                p.find('.zf-sl-attr a[href="#attList_' + att + '"]').tab('show');
                p.find('.zf-sl-attr #attList_' + att).children().each(function (idx, el) {
                    if (ot + '.' + partid == el.id) { bRt = false; return false;}
                });
            }
            return bRt;
        },
        "composeLine": function (p, query) {
            var vOrderNo = null, vDate = null, srcln = null;
            var wid = '', sPartName = '', sPartDept = '', sPos = '', sReceived = '', sCompleted = '', sInterval = '';
            var iStep, iSubStep = 0, iSeq = 0, iPos = 0;
            var jLine = {};

            p.find(query).each(function (idx) {
                vOrderNo = $(this).find(' > div > div:nth-child(2)').text().split('.');
                iStep = parseInt(vOrderNo[0]);
                iSubStep = vOrderNo[1] ? parseInt(vOrderNo[1]) : 0;
                iSeq = vOrderNo[2] ? parseInt(vOrderNo[2]) : parseInt($(this).attr('seq'));//2010-08-26 변경

                wid = $(this).attr('wid');
                if (wid == '') {
                    sPartName = $(this).find(' > div > div:nth-child(4)').text();
                    if ($(this).attr('parttype').charAt(0) == 'u') {
                        iPos = sPartName.lastIndexOf('.');
                        sPartDept = sPartName.substr(0, iPos); sPartName = sPartName.substr(iPos + 1);
                    } else {
                        sPartDept = sPartName;
                    }

                    vDate = $(this).find(' > div > div[title]');
                    if (vDate.length > 0) {
                        sCompleted = vDate[0].getAttribute("title"); sReceived = vDate[1].getAttribute("title"); sInterval = vDate[2].getAttribute("title");
                    } else {
                        sCompleted = ''; sReceived = ''; sInterval = '';
                    }
                    //console.log(sPartDept + " : " + sPartName + " : " + sCompleted + " : " + sReceived);
                    jLine = _zw.parse.signJson($(this).attr('mode'), $(this).attr('wid'), $(this).attr('parent'), iStep, iSubStep, iSeq
                        , $(this).attr('state'), $(this).attr('signstatus'), $(this).attr('signkind'), ''
                        , '', '', $(this).attr('bizrole'), $(this).attr('actrole')
                        , $(this).attr('actid'), $(this).attr('partid'), $(this).attr('parttype'), $(this).attr('deptcode')
                        , '', '', sReceived, '', sCompleted, sInterval, sPartName, sPartDept, $(this).attr('part2')
                        , '', '', $(this).attr('part5'), '', '', '', '', '');

                } else {
                    srcln = _zw.V.process.signline.find(function (element) { if (element.wid === wid) return true; });
                    jLine = _zw.parse.signJson(srcln["mode"], srcln["wid"], srcln["parent"], iStep, iSubStep, iSeq
                        , srcln["state"], srcln["signstatus"], srcln["signkind"], srcln["viewstate"]
                        , srcln["flag"], srcln["designator"], srcln["bizrole"], srcln["actrole"]
                        , srcln["activityid"], srcln["partid"], srcln["parttype"], srcln["deptcode"]
                        , srcln["competency"], srcln["point"], srcln["received"], srcln["view"]
                        , srcln["completed"], srcln["interval"], srcln["partname"], srcln["part1"], srcln["part2"]
                        , srcln["part3"], srcln["part4"], srcln["part5"], srcln["part6"]
                        , srcln["sign"], srcln["comment"], srcln["reserved1"], srcln["reserved2"]);
                }
                _zw.V.templine["signline"].push(jLine);
            });
        },
        "composeAttr": function (p) { //console.log(_zw.V.process.attributes)
            p.find('.zf-sl-attr .tab-pane').each(function () {
                var att = $(this).attr("id").replace("attList_", ""), dp = '', vlu = '', dataType = '';
                var jAttr = {}, srcAttr = null, vId = null;

                if (att == 'mail_dl') {
                    $(this).find('.btn').each(function (idx) {
                        dp += (idx > 0 ? ', ' : '') + $(this).text();
                        vlu += (idx > 0 ? ', ' : '') + $(this).attr('mail');
                    });
                    if (vlu != '') {
                        dataType = 'M';
                        jAttr['actid'] = _zw.V.wid; jAttr['att'] = att;
                        jAttr['dtype'] = dataType = 'D';; jAttr['flag'] = '';
                        jAttr['display'] = dp; jAttr['value'] = vlu;

                        _zw.V.templine["attributes"].push(jAttr);
                    }
                } else if (att == 'xform_dl' || att == 'xform_cf') {
                    srcAttr = _zw.V.process.attributes.find(function (element) { if (element.att === att) return true; });
                    $(this).find('.btn').each(function (idx) {
                        vId = $(this).attr("id").split('.');
                        var bInsert = (srcAttr && srcAttr.length > 0 && $(srcAttr.value).find('part[partid="' + vId[1] + '"][pt="' + vId[0] + '"]').length > 0) ? false : true;
                        if (bInsert) {
                            vlu += '<part partid="' + vId[1] + '" pt="' + vId[0] + '" pc="' + $(this).attr("code") + '">'
                                + '<pn>' + $(this).attr("pn") + '</pn><pm>' + $(this).attr("mail") + '</pm></part>';
                        }
                    });
                    if (vlu != '') {
                        dataType = 'D';
                        jAttr['actid'] = _zw.V.pwid ? _zw.V.pwid : _zw.V.wid; jAttr['att'] = att;
                        jAttr['dtype'] = dataType; jAttr['flag'] = '';
                        jAttr['display'] = ''; jAttr['value'] = '<partinfo>' + vlu + '</partinfo>';

                        _zw.V.templine["attributes"].push(jAttr);
                    }
                } else {
                    srcAttr = _zw.V.process.attributes.find(function (element) { if (element.att === att) return true; });
                    $(this).find('.btn').each(function (idx) {
                        vId = $(this).attr("id").split('.');
                        var bInsert = (srcAttr && srcAttr.length > 0 && $(srcAttr.value).find('part[partid="' + vId[1] + '"][type="' + vId[0] + '"]').length > 0) ? false : true;
                        if (bInsert) {
                            vlu += '<part seq="' + (idx + 1) + '" partid="' + vId[1] + '" type="' + vId[0] + '" code="' + $(this).attr("code") + '" dc="' + $(this).attr("dc") + '">'
                                + '<pn>' + $(this).attr("pn") + '</pn><dn>' + $(this).text() + '</dn></part>';
                        }
                    });
                    if (vlu != '') {
                        var eAct = _zw.V.schema.find(function (element) { if (element.actid === att) return true; });
                        var szAtt = (eAct && eAct.review == "4") ? "cabinet" : "workitem";
                        if (eAct) {
                            if (eAct["bizrole"] == 'receive' || eAct["bizrole"] == 'distribution') dataType = 'A';
                            else if (eAct["bizrole"] == 'reference') dataType = 'R';
                            else dataType = '';
                        }
                        if (_zw.V.pwid != '') szAtt += '_' + _zw.V.pwid;
                        jAttr['actid'] = att; jAttr['att'] = szAtt; jAttr['dtype'] = dataType; jAttr['flag'] = '';
                        jAttr['display'] = ''; jAttr['value'] = '<partinfo>' + vlu + '</partinfo>';

                        _zw.V.templine["attributes"].push(jAttr);
                    }
                }
            });
        },
        "putDeleteLine": function (wid) {
            if (wid != '') { if (_zw.V.templine["deleted"] == '') { _zw.V.templine["deleted"] = wid; } else { _zw.V.templine["deleted"] += ',' + wid; } }
        },
        "setOrder": function (p, list, row) { //console.log(list)
            var rowPrev = null, vNo = null, vPrevNo = null;
            var curNo = '', preNo = '', orderNo = '';
            $(list.get().reverse()).each(function (idx) {
                if (rowPrev) {
                    curNo = $(this).find(' > div > div:nth-child(2)').text(); //console.log($(this).find(' > div > div:nth-child(2)').html())
                    preNo = rowPrev.find(' > div > div:nth-child(2)').text();

                    if ($(this).attr('actid') == rowPrev.attr('actid')) {
                        if (preNo.indexOf('.') < 0) orderNo = parseInt(preNo) + 1;
                        else {
                            vPrevNo = preNo.split('.'); orderNo = vPrevNo[0] + '.' + (parseInt(vPrevNo[1]) + 1);
                        }
                    } else {
                        if (curNo.indexOf('.') < 0) {
                            if (preNo.indexOf('.') >= 0) orderNo = parseInt(preNo.split('.')[0]) + 1;
                            else orderNo = parseInt(preNo) + 1;
                        } else {
                            if (preNo.indexOf('.') < 0) {
                                orderNo = (parseInt(preNo) + 1) + "." + 1;
                            } else {
                                vPreNo = preNo.split('.');
                                orderNo = (parseInt(vPreNo[0]) + 1) + "." + 1;
                            }
                        }
                    }
                    if ($(this).find(' > div > div:nth-child(2) span.custom-control-label').length > 0) $(this).find(' > div > div:nth-child(2) span.custom-control-label').text(orderNo);
                    else $(this).find(' > div > div:nth-child(2)').text(orderNo);
                }
                rowPrev = $(this);
            });
        },
        "template": function (cmd, s, v, cur, pfirst, sub) { //console.log(cmd + " : " + sub)
            var sCls = '', sCheck = '', bParallel = cur != null && cur.substep != '0' ? true : false;
            var sMarginTop = '', sTextAlign = '', sOrderNo = v["step"] + (parseInt(v["substep"]) > 0 ? '.' + v["substep"] : '');

            if (sub && sub.length > 0) {
                sCheck = '<button class="btn btn-outline-secondary zf-btn-xs" aria-expanded="false"><i class="fas fa-minus"></i></button>';
                sMarginTop = ' mt-1';

                if (cmd == 'reject' && v["state"] != '2' && v["viewstate"] != '6') { //v["wid"] == _zw.V.pwid
                    sCls = 'zf-sl-add';
                    sOrderNo = '<label class="custom-control custom-checkbox mb-0"><input type="checkbox" class="custom-control-input"><span class="custom-control-label">' + sOrderNo + '</span></label>';
                } else  sCls = 'zf-sl-read';

            } else {
                if (v["parent"] != '') {
                    sCheck = '<span class="fe-corner-down-right font-weight-bold text-secondary"></span>';
                    sTextAlign = ' text-right';

                    if (cmd == 'read') {
                        if (v["viewstate"] == '6') {
                            sCls = 'zf-sl-cancel';
                        } else {
                            if (v["completed"] == '' && v["partid"] != '') {
                                if (v["state"] == '2' && v["viewstate"] == '3') sCls = 'zf-sl-current';
                                else sCls = 'zf-sl-read';
                            } else {
                                if (v["state"] == '2' && v["signstatus"] == '3' && v["viewstate"] == '3' && v["partid"] != '') sCls = 'zf-sl-current';
                                else sCls = 'zf-sl-read';
                            }
                        }
                    } else if (cmd == 'reject') {
                        if (v["parent"] == _zw.V.pwid) {
                            if (v["completed"] == '' && v["partid"] != '') {
                                if (v["state"] == '2' && (v["wid"] == _zw.V.wid || v['actrole'] == '_redrafter')) sCls = 'zf-sl-current';
                                else sCls = 'zf-sl-read';
                            } else if (v["state"] == '2' && v["signstatus"] == '3' && v["wid"] == _zw.V.wid && v["partid"] != '') {
                                sCls = 'zf-sl-current';
                            } else {
                                if (v["partid"] == '' || v["actrole"] == '_redrafter' || v["actrole"] == '_re') sCls = 'zf-sl-read';
                                else {
                                    sCls = 'zf-sl-add';
                                    sOrderNo = '<label class="custom-control custom-checkbox mb-0"><input type="checkbox" class="custom-control-input"><span class="custom-control-label">' + sOrderNo + '</span></label>';
                                }
                            }
                        } else {
                            sCls = 'zf-sl-read';
                        }
                    } else {
                        if (v["completed"] == '' && v["partid"] != '') {
                            if (v["state"] == '2' && (v["wid"] == _zw.V.wid || v['actrole'] == '_redrafter')) {
                                sCls = 'zf-sl-current';
                            } else {
                                if (v["received"] == '' && v["parent"] == _zw.V.pwid && v["signkind"] != '3' && v["signkind"] != '4') {
                                    if (v["parttype"].substr(2, 1) == '' || v["parttype"].substr(2, 1) == 'g') sCls = 'zf-sl-read';
                                    else {
                                        sCls = 'zf-sl-add'; //sTextAlign = '';
                                        sOrderNo = '<label class="custom-control custom-checkbox mb-0"><input type="checkbox" class="custom-control-input"><span class="custom-control-label">' + sOrderNo + '</span></label>';
                                    }
                                } else {
                                    sCls = 'zf-sl-read';
                                }
                            }
                        } else {
                            if (v["state"] == '2' && v["wid"] == _zw.V.wid && v["completed"] != '' && v["partid"] != '') sCls = 'zf-sl-current';
                            else sCls = 'zf-sl-read';
                        }
                    }
                } else {
                    if (cmd == 'read') {
                        if (v["viewstate"] == '6') {
                            sCls = 'zf-sl-cancel';
                        } else {
                            if (v["completed"] == '' && v["partid"] != '') {
                                if (v["state"] == '2' && v["viewstate"] == '3') sCls = 'zf-sl-current';
                                else sCls = 'zf-sl-read';
                            } else {
                                if (v["state"] == '2' && v["signstatus"] == '3' && v["viewstate"] == '3' && v["partid"] != '') sCls = 'zf-sl-current';
                                else sCls = 'zf-sl-read';
                            }
                        }
                    } else if (cmd == 'reject') {
                        var sStep = pfirst != null ? pfirst["step"] : (cur != null ? cur["step"] : '0'); //console.log(sStep);
                        if (v["completed"] == '' && v["partid"] != '') {
                            if (v["state"] == '2' && v["wid"] == _zw.V.wid) sCls = 'zf-sl-current';
                            else sCls = 'zf-sl-read';
                        } else if (v["state"] == '2' && v["signstatus"] == '3' && v["wid"] == _zw.V.wid && v["partid"] != '') {
                            sCls = 'zf-sl-current';
                        } else {
                            
                            if (v["actrole"] == '_drafter' || v["actrole"] == '_re' || v["step"] == sStep) sCls = 'zf-sl-read';
                            else {
                                sCls = 'zf-sl-add';
                                sCheck = '<label class="custom-control custom-checkbox mb-0 ml-1"><input type="checkbox" class="custom-control-input"><span class="custom-control-label"></span></label>';
                            }
                        }
                    } else {
                        if (v["completed"] == '' && v["partid"] != '') {
                            if (v["state"] == '2' && v["wid"] == _zw.V.wid) {
                                sCls = 'zf-sl-current';
                            } else {
                                if (!bParallel && v["received"] == '' && v["signkind"] != '3' && v["signkind"] != '4') { //console.log(_zw.V.wid + " : " + _zw.V.pwid)
                                    if (v["parttype"].substr(2, 1) == '' || v["parttype"].substr(0, 3) == 'u_g') sCls = 'zf-sl-read';
                                    else if (_zw.V.pwid != '' && _zw.V.wid != _zw.V.pwid) sCls = 'zf-sl-read';
                                    else {
                                        sCls = 'zf-sl-add';
                                        sCheck = '<label class="custom-control custom-checkbox mb-0 ml-1"><input type="checkbox" class="custom-control-input"><span class="custom-control-label"></span></label>';
                                    }
                                } else {
                                    sCls = 'zf-sl-read';
                                }
                            }
                        } else {
                            if (v["state"] == '2' && v["wid"] == _zw.V.wid && v["completed"] != '' && v["partid"] != '') sCls = 'zf-sl-current';
                            else sCls = 'zf-sl-read';
                        }
                    }
                }
            }

            var sPartName = v["parttype"].substr(0, 1) == 'g' ? v["partname"] : v["part1"] + '.' + v["partname"];
            sPartName = '<a href="javascript:void(0)" data-toggle="popover" data-placement="bottom" title="">' + sPartName + (v["comment"] != '' ? '<i class="far fa-comment-dots text-info"></i>' : '') + '</a>';

            var sRole = '';
            if (v["parttype"].substr(0, 1) == 'g') sRole = _zw.parse.bizRole(v["bizrole"]);
            else {
                if (v["parent"] != '') sRole = _zw.parse.actRole(v["actrole"]);
                else {
                    if (v["bizrole"] == 'normal' || v["bizrole"] == 'receive' || v["bizrole"] == 'gwichaek' || (v["bizrole"] == 'application' && v["actrole"] == '_reviewer')) sRole = _zw.parse.actRole(v["actrole"]);
                    else sRole = _zw.parse.bizRole(v["bizrole"]);
                }
            }

            s = s.replace("{$class}", sCls).replace("{$check}", sCheck);
            s = s.replace("{$mode}", v["mode"]).replace("{$wid}", v["wid"]).replace("{$parent}", v["parent"]).replace("{$partid}", v["partid"]).replace("{$actid}", v["activityid"]);
            s = s.replace("{$step}", v["step"]).replace("{$substep}", v["substep"]).replace("{$seq}", v["seq"]).replace("{$state}", v["state"]).replace("{$signstatus}", v["signstatus"]).replace("{$signkind}", v["signkind"]);
            s = s.replace("{$bizrole}", v["bizrole"]).replace("{$actrole}", v["actrole"]).replace("{$parttype}", v["parttype"]).replace("{$deptcode}", v["deptcode"]).replace("{$part2}", v["part2"]).replace("{$part5}", v["part5"]);

            s = s.replace("{$margintop}", sMarginTop).replace("{$textalign}", sTextAlign).replace("{$order}", sOrderNo);
            s = s.replace("{$role}", sRole);
            s = s.replace("{$partname}", sPartName);
            s = s.replace("{$parsews}", _zw.parse.workItemState(v["state"]));
            s = s.replace("{$parsess}", _zw.parse.signStatus(v["signstatus"]));
            s = s.replace("{$parsesk}", _zw.parse.signKind(v["signkind"]));

            if (cmd != 'draft') {
                var dt = v["completed"] != '' ? v["completed"].substr(9, 5) : '';
                s = s.replace("{$dodt}", v["completed"]).replace("{$dodt2}", dt);

                dt = v["received"] != '' ? v["received"].substr(9, 5) : '';
                s = s.replace("{$rcvdt}", v["received"]).replace("{$rcvdt2}", dt);

                s = s.replace("{$inv}", v["interval"]).replace("{$inv}", v["interval"]);
                s = s.replace("{$cmnt}", _zw.ut.toBR(v["comment"]));
            }
            return s;
        },
        "template2": function (s, orderNo, parent, partId, actId, bizRole, actRole, partType, part2, part5, partName, dept, deptCode) {
            var sCheck = '', sTextAlign = '', sOrderNo = '';
            if (parent != '') {
                sCheck = '<span class="fe-corner-down-right font-weight-bold text-secondary"></span>';
                sTextAlign = ' text-right';
                sOrderNo = '<label class="custom-control custom-checkbox mb-0"><input type="checkbox" class="custom-control-input"><span class="custom-control-label">' + orderNo + '</span></label>';
            } else {
                sCheck = '<label class="custom-control custom-checkbox mb-0 ml-1"><input type="checkbox" class="custom-control-input"><span class="custom-control-label"></span></label>';
                sTextAlign = '';
                sOrderNo = orderNo;
            }

            var sPartName = partType.substr(0, 1) == 'g' ? partName : dept + '.' + partName;
            var sRole = '';
            if (partType.substr(0, 1) == 'g') sRole = _zw.parse.bizRole(bizRole);
            else {
                if (parent != '') sRole = _zw.parse.actRole(actRole);
                else {
                    if (bizRole == 'normal' || bizRole == 'receive' || bizRole == 'gwichaek' || (bizRole == 'application' && actRole == '_reviewer')) sRole = _zw.parse.actRole(actRole);
                    else sRole = _zw.parse.bizRole(bizRole);
                }
            }

            s = s.replace("{$class}", 'zf-sl-add').replace("{$check}", sCheck);
            s = s.replace("{$mode}", '1').replace("{$wid}", '').replace("{$parent}", parent).replace("{$partid}", partId).replace("{$actid}", actId);
            s = s.replace("{$step}", 0).replace("{$substep}", 0).replace("{$seq}", 0).replace("{$state}", 0).replace("{$signstatus}", 0).replace("{$signkind}", 0);
            s = s.replace("{$bizrole}", bizRole).replace("{$actrole}", actRole).replace("{$parttype}", partType).replace("{$deptcode}", deptCode).replace("{$part2}", part2).replace("{$part5}", part5);

            s = s.replace("{$margintop}", '').replace("{$textalign}", sTextAlign).replace("{$order}", sOrderNo);
            s = s.replace("{$role}", sRole);
            s = s.replace("{$partname}", sPartName);
            s = s.replace("{$parsews}", _zw.parse.workItemState(0));
            s = s.replace("{$parsess}", _zw.parse.signStatus(0));
            s = s.replace("{$parsesk}", _zw.parse.signKind(0));
            
            s = s.replace("{$dodt}", '').replace("{$dodt2}", '');
            s = s.replace("{$rcvdt}", '').replace("{$rcvdt2}", '');
            s = s.replace("{$inv}", '').replace("{$inv}", '').replace("{$cmnt}", '');

            return s;
        },
        "userInfo": function (p, multi) {
            p.find('.zf-sl .zf-sl-member input:checkbox').click(function () {
                if ($(this).prop('checked')) {
                    if (multi == 'n') {
                        p.find('.zf-sl .zf-sl-member input:checkbox[data-for!="' + $(this).attr('data-for') + '"]:checked').prop('checked', false);
                    }

                    var jUser = JSON.parse($(this).attr('data-attr'));
                    $.ajax({
                        type: "POST",
                        url: "/Organ/Plate",
                        data: '{M:"userinfo",urid:"' + jUser['id'] + '",grid:"' + jUser['grid'] + '"}',
                        success: function (res) {
                            if (res.substr(0, 2) == "OK") p.find('.zf-sl .zf-sl-info .table tbody').html(res.substr(2));
                            else bootbox.alert(res);
                        },
                        beforeSend: function () { } //로딩 X
                    });
                }
            });
        },
        "space": function (signLine) {
            if (signLine == null || signLine.length == 0) return false;
            var tbl = '', biz = '', nodes = null, p = null;

            $('#__FormView div.m .si-tbl').each(function () {
                tbl = $(this).attr("id"); biz = tbl.replace('__si_', '').replace('_R', '').toLowerCase();

                if (tbl == '__si_Complex') { //parent=''인 결재선만 표기
                    nodes = signLine.filter(function (element) { if (element.parent == '' && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                    if (nodes.length > 0) _zw.parse.signPart($(this), nodes, tbl);

                } else if (tbl == '__si_Normal') {
                    nodes = signLine.filter(function (element) { if (element.bizrole == biz && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                    if (nodes.length > 0) _zw.parse.signPart($(this), nodes, tbl);

                } else if (tbl == '__si_Receive' || tbl == '__si_Distribution' || tbl == '__si_Application_R') { //단일수신, 배포수신, 접수수신
                    p = signLine.filter(function (element) { if (element.bizrole == biz && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                    if (p.length > 0) {
                        if (_zw.V.biz == biz) {
                            if (_zw.V.act.indexOf('__') >= 0) nodes = signLine.filter(function (element) { if (element.bizrole == biz && element.parent == _zw.V.wid && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                            else nodes = signLine.filter(function (element) { if (element.bizrole == biz && element.parent == _zw.V.pwid && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                            if (nodes.length > 0) _zw.parse.signPart($(this), nodes, tbl);
                        } else {
                            if (p.length == 1) {
                                nodes = signLine.filter(function (element) { if (element.bizrole == biz && element.parent != '' && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                                if (nodes.length > 0) _zw.parse.signPart($(this), nodes, tbl);
                                else _zw.parse.signRcvPart($(this), p, tbl);
                            } else _zw.parse.signRcvPart($(this), p, tbl);
                        }
                    }

                } else if (tbl == '__si_Agree' || tbl == '__si_Application') {
                    nodes = signLine.filter(function (element) { if (element.bizrole == biz && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                    if (nodes.length > 0) _zw.parse.signSerialPart($(this), nodes, tbl);

                } else if (tbl == '__si_Last') {
                    nodes = signLine.filter(function (element) { if (element.bizrole == biz && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                    _zw.parse.signSerialPart($(this), nodes, tbl);

                } else if (tbl == '__si_Confirm') {
                    nodes = signLine.filter(function (element) { if (element.bizrole == biz && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                    _zw.parse.signEdgePart($(this), nodes, tbl);

                } else if (tbl == '__si_OnlyOne') { //하나의 결재칸
                    var br = $(this).attr('bizrole'), ar = $(this).attr('actrole');
                    nodes = signLine.filter(function (element) { if (element.bizrole == br && element.actrole == ar && element.partid != '' && element.viewstate != '6') return true; });
                    _zw.parse.signSinglePart($(this), nodes);

                } else if (tbl == '__si_Attr') { //2015-03-19 : BizRoe, ActRole을 지정
                    var br = $(this).attr('bizrole'), ar = $(this).attr('actrole');
                    nodes = signLine.filter(function (element) { if (element.bizrole == br && element.actrole == ar && element.partid != '' && element.viewstate != '6') return true; });
                    _zw.parse.signSerialPart($(this), nodes, tbl);

                } else if (tbl == '__si_Site') { //사이트별로 특정 프로세스에 맞게
                    nodes = signLine.filter(function (element) { if (element.bizrole == 'confirm' && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                    if (nodes.length > 0) _zw.parse.signPart($(this), nodes, tbl);

                } else if (tbl == '__si_Form') { //양식별
                    if (_zw.V.ft == 'NEWDEVELOPREQUEST') {
                        nodes = signLine.filter(function (element) { if ((element.bizrole == '등급부서' || element.bizrole == 'application' || element.bizrole == 'manage') && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                        if (nodes.length > 0) _zw.parse.signSerialPart($(this), nodes, '__si_Application', 'BR');

                    } else if (_zw.V.ft == 'NEWDEVELOPREQUESTINDUSTRY') { //신제품개발의뢰서(크레신산업)
                        nodes = signLine.filter(function (element) { if ((element.bizrole == 'agree' || element.bizrole == 'confirm' || element.bizrole == 'application' || element.bizrole == 'manage') && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                        if (nodes.length > 0) _zw.parse.signSerialPart($(this), nodes, '__si_Application', 'BR');

                    } else if (_zw.V.ft == 'LOSSREPORT' || _zw.V.ft == 'LOSSREPORTINDUSTRY') { //손실발생보고서(크레신산업)
                        nodes = signLine.filter(function (element) { if (element.bizrole == 'gwichaek' && element.actrole != '__r' && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                        if (nodes.length > 0) _zw.parse.signSerialPart($(this), nodes, tbl, '');

                    } else if (_zw.V.ft == 'LOSSREPORTINDUSTRY') { 
                        nodes = signLine.filter(function (element) { if (element.bizrole == 'gwichaek' && element.actrole != '__r' && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                        if (nodes.length > 0) _zw.parse.signSerialPart($(this), nodes, tbl, '');

                    } else if (_zw.V.ft == 'BIZTRIPPLAN') { //출장계획서(업무출장)
                        nodes = signLine.filter(function (element) { if (element.bizrole == 'normal' && element.actrole == '_approver' && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                        if (nodes.length > 0) _zw.parse.signSerialPart($(this), nodes, tbl, '');

                    } else if (_zw.V.ft == 'TOOLINGNEWDRAFT' || _zw.V.ft == 'TOOLINGINCREASEDRAFT') { //금형신작,증작기안
                        nodes = signLine.filter(function (element) { if (element.bizrole == '영업수신' && element.actrole != '__r' && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                        if (nodes.length == 0) nodes = signLine.filter(function (element) { if (element.bizrole == '영업수신' && element.actrole == '__r' && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                        if (nodes.length > 0) _zw.parse.signSerialPart($(this), nodes, tbl, '');
                    }
                } else if (tbl == '__si_Form2') { //2013-01-03 : 양식별
                    if (_zw.V.ft == 'NEWDEVELOPREQUEST') {
                        nodes = signLine.filter(function (element) { if ((element.bizrole == '생산지' || element.bizrole == 'confirm') && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                        if (nodes.length > 0) _zw.parse.signSerialPart($(this), nodes, '__si_Application', 'BR');

                    } else if (_zw.V.ft == 'BIZTRIPPLAN') { //출장계획서(업무출장)
                        nodes = signLine.filter(function (element) { if (element.bizrole == '동행승인' && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                        if (nodes.length > 0) _zw.parse.signSerialPart($(this), nodes, tbl, '');

                    } else if (_zw.V.ft == 'TOOLINGNEWDRAFT' || _zw.V.ft == 'TOOLINGINCREASEDRAFT') { //금형신작,증작기안
                        nodes = signLine.filter(function (element) { if (element.bizrole == '제작수신' && element.actrole != '__r' && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                        if (nodes.length == 0) nodes = signLine.filter(function (element) { if (element.bizrole == '제작수신' && element.actrole == '__r' && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                        if (nodes.length > 0) _zw.parse.signSerialPart($(this), nodes, tbl, '');
                    }
                }
            });
        },
        "make": function (cmd, j, cmnt) {
            var jSign = [], jAttr = [];

            if (cmd == 'reject' || cmd == 'back') {
                //var cur = {};
                //cur["wid"] = _zw.V.wid; cur["partid"] = _zw.V.partid; cur["completed"] = ''; cur["comment"] = cmnt;
                //j["current"] = cur;

                if (_zw.V.pwid != '' && _zw.V.partid.indexOf('__') >= 0) {
                    var ln = _zw.V.process.signline.find(function (element) { if (element.parent === _zw.V.pwid && element.actrole == _zw.V.curact && element.partid == _zw.V.current.urid) return true; }); //console.log(curln);
                    ln["mode"] = '1';
                    j["param"] = ln;
                }

            } else if (cmd == 'draft' || cmd == 'approval') {
                var signLine = _zw.V.templine && _zw.V.templine.signline.length > 0 ? _zw.V.templine.signline : _zw.V.process.signline; //console.log(signLine);
                var searchLine = null, tgt = null; node = null, sText = '';
                
                if (_zw.V.pwid != '') {
                    //상위가 있는 경우 상위 단계까지 담는다 -> 상위단계가 병렬인 경우 다른 병렬은 제외한다.
                    tgt = signLine.find(function (element) { if (element.wid === _zw.V.pwid) return true; }); //console.log(tgt)
                    searchLine = signLine.filter(function (element) { if (element.parent === tgt["parent"] && parseInt(element.step) >= parseInt(tgt["step"])) return true; });
                    
                    for (var i = 0; i < searchLine.length; i++) {
                        var srcln = searchLine[i], bInsert = true;
                        if (tgt["activityid"] == srcln["activityid"] && tgt["step"] == srcln["step"] && parseInt(tgt["substep"]) > 0) {
                            bInsert = tgt["wid"] == srcln["wid"] ? true : false;
                        }
                        //console.log(i.toString() + " : " + bInsert + " : " + srcln["partname"])
                        if (bInsert) {
                            var sMode = srcln["mode"];
                            if (srcln["wid"] != '') {
                                var temp = _zw.V.process.signline.find(function (element) { if (element.wid === srcln["wid"]) return true; });
                                if (srcln["step"] == temp["step"] && srcln["substep"] == temp["substep"]
                                    && srcln["seq"] == temp["seq"] && srcln["signkind"] == temp["signkind"]) {
                                    sMode = "0";
                                } else sMode = "3";

                                if (srcln["wid"] == tgt["wid"] && srcln["partid"] == _zw.V.partid) {
                                    sMode = "3"; sText = cmnt;
                                } else sText = '';
                            } else sText = '';

                            node = _zw.parse.signJson(sMode, srcln["wid"], srcln["parent"], srcln["step"], srcln["substep"], srcln["seq"]
                                , srcln["state"], srcln["signstatus"], srcln["signkind"], srcln["viewstate"]
                                , srcln["flag"], srcln["designator"], srcln["bizrole"], srcln["actrole"]
                                , srcln["activityid"], srcln["partid"], srcln["parttype"], srcln["deptcode"]
                                , srcln["competency"], srcln["point"], srcln["received"], srcln["view"]
                                , srcln["completed"], srcln["interval"], srcln["partname"], srcln["part1"], srcln["part2"]
                                , srcln["part3"], srcln["part4"], srcln["part5"], srcln["part6"]
                                , srcln["sign"], sText, srcln["reserved1"], srcln["reserved2"]);

                            jSign.push(node);
                        }
                    }
                }

                //현결재자 담기
                var curAct = _zw.V.schema.find(function (element) { if (element.actid === _zw.V.curactid) return true; }); //console.log(curAct);

                //if (_zw.V.act.indexOf('__') != -1) tgt = signLine.find(function (element) { if (element.bizrole == _zw.V.curbiz && element.actrole == _zw.V.curact) return true; });
                //else if (_zw.V.act != '' && _zw.V.wid != '') tgt = signLine.find(function (element) { if (element.wid === _zw.V.wid) return true; });
                //else tgt = signLine.find(function (element) { if (element.actrole == '_drafter' && element.step == '1') return true; });

                //22-07-15 위를 막고 아래 조건식으로 찾기 추가
                if (_zw.V.pwid != '') {
                    if (_zw.V.wid == _zw.V.pwid) tgt = signLine.find(function (element) { if (element.parent == _zw.V.pwid && element.actrole == _zw.V.curact) return true; }); //재기안자
                    else tgt = signLine.find(function (element) { if (element.wid == _zw.V.wid) return true; }); //상위부서 속하는 결재자
                } else {
                    if (_zw.V.wid != '') tgt = signLine.find(function (element) { if (element.wid == _zw.V.wid) return true; }); //상위부서 속하지 않는 결재자
                    else tgt = signLine.find(function (element) { if (element.bizrole == _zw.V.curbiz && element.actrole == _zw.V.curact) return true; }); //기안자
                }
                //console.log(tgt)
                searchLine = signLine.filter(function (element) { if (element.parent === tgt["parent"] && parseInt(element.step) >= parseInt(tgt["step"])) return true; });

                for (var i = 0; i < searchLine.length; i++) {
                    var srcln = searchLine[i], bInsert = true;
                    if (curAct != undefined && curAct["actid"] == srcln["activityid"] && curAct["progress"] == "parallel") {
                        bInsert = tgt["wid"] == srcln["wid"] ? true : false;
                    }
                    if (bInsert) {
                        var sMode = srcln["mode"];
                        if (srcln["wid"] != '') {
                            var temp = _zw.V.process.signline.find(function (element) { if (element.wid === srcln["wid"]) return true; });
                            if (srcln["step"] == temp["step"] && srcln["substep"] == temp["substep"]
                                && srcln["seq"] == temp["seq"] && srcln["signkind"] == temp["signkind"]) {
                                sMode = "0";
                            } else sMode = "3";

                            if (srcln["wid"] == tgt["wid"] && srcln["partid"] == _zw.V.partid) {
                                sMode = "3"; sText = cmnt;
                            } else sText = '';
                        } else {
                            if (cmd == 'draft' && srcln["actrole"] == '_drafter' && srcln["partid"] == _zw.V.partid) {
                                srcln["signstatus"] = "7"; sText = cmnt;
                            } else sText = '';
                        }
                        
                        node = _zw.parse.signJson(sMode, srcln["wid"], srcln["parent"], srcln["step"], srcln["substep"], srcln["seq"]
                            , srcln["state"], srcln["signstatus"], srcln["signkind"], srcln["viewstate"]
                            , srcln["flag"], srcln["designator"], srcln["bizrole"], srcln["actrole"]
                            , srcln["activityid"], srcln["partid"], srcln["parttype"], srcln["deptcode"]
                            , srcln["competency"], srcln["point"], srcln["received"], srcln["view"]
                            , srcln["completed"], srcln["interval"], srcln["partname"], srcln["part1"], srcln["part2"]
                            , srcln["part3"], srcln["part4"], srcln["part5"], srcln["part6"]
                            , srcln["sign"], sText, srcln["reserved1"], srcln["reserved2"]);

                        jSign.push(node);
                    }
                }

                var attrList = _zw.V.templine && _zw.V.templine.attributes.length > 0 ? _zw.V.templine.attributes : _zw.V.process.attributes;

                j["signline"] = jSign;
                j["attributes"] = attrList;
                j["deleted"] = _zw.V.templine && _zw.V.templine["deleted"] ? _zw.V.templine["deleted"] : '';
            }
            //console.log(j)
        },
        "validation": function (cmd) { //checkValidLine 결재선 유효성 검사 (return 값 = Y : 통과, N : 결재선창 띄우기, F : 양식필드 관련)
            if (_zw.V.schema.length == 0) return 'Y';
            if (cmd == 'draft') {
                if (_zw.V.templine == null || _zw.V.templine.signline.length == 0) return 'N';
            }

            var signLine = _zw.V.templine && _zw.V.templine.signline.length > 0 ? _zw.V.templine.signline : _zw.V.process.signline;
            if (signLine == null || signLine.length == 0) return 'N';

            var attrList = _zw.V.templine && _zw.V.templine.attributes.length > 0 ? _zw.V.templine.attributes : _zw.V.process.attributes;
            var curAct = _zw.V.schema.find(function (element) { if (element.actid === _zw.V.curactid) return true; }); //console.log(curAct);
            
            var schAct = null, curln = null, nextStep = null, parentStep = null, vPartType = null;
            var rt = 'Y', bCheck = false;

            if (curAct["parentactid"] != '') { //pwid != ''
                schAct = _zw.V.schema.filter(function (element) { if (element.random = 'N' && (element.parentactid == '' || (element.parentactid == curAct["parentactid"] && parseInt(element.step) >= parseInt(curAct["step"])))) return true; });
            } else { //pwid == ''
                schAct = _zw.V.schema.filter(function (element) { if (element.random = 'N' && element.parentactid == '' && parseInt(element.step) >= parseInt(curAct["step"])) return true; });
            }
            //console.log(signLine)
            if (schAct.length > 0) {
                curln = signLine.find(function (element) { if ((_zw.V.wid != '' && element.wid === _zw.V.wid) || (_zw.V.wid == '' && element.parent == '' && element.step == '1')) return true; }); //console.log(curln);
                //alert(_zw.V.act + " : " + curln["wid"])
                if (_zw.V.act.indexOf('__') != -1) {
                    nextStep = signLine.filter(function (element) { if (element.parent == curln["wid"] && element.viewstate != '6') return true; });
                    parentStep = signLine.filter(function (element) { if (element.parent == curln["parent"] && element.viewstate != '6' && parseInt(element.step) >= parseInt(curln["step"])) return true; });
                } else {
                    nextStep = signLine.filter(function (element) { if (element.parent == curln["parent"] && element.viewstate != '6' && parseInt(element.step) >= parseInt(curln["step"])) return true; });
                } //console.log(nextStep);

                var sConfirm = '';
                for (var i = 0; i < schAct.length; i++) {
                    vPartType = schAct[i]["parttype"].split('_');

                    if (vPartType[1] == "b" || vPartType[1] == "f" || vPartType[1] == "g") {
                        for (var j = nextStep.length - 1; j >= 0; j--) {
                            if (nextStep[j]["activityid"] == schAct[i]["actid"] && nextStep[j]["partid"] != '') { bCheck = true; break; }
                        }
                        if (_zw.V.act.indexOf('__') != -1 && parentStep) {
                            for (var j = parentStep.length - 1; j >= 0; j--) {
                                if (parentStep[j]["activityid"] == schAct[i]["actid"] && parentStep[j]["partid"] != '') { bCheck = true; break; }
                            }
                        }
                        if (!bCheck) {
                            if (schAct[i]["actrole"] == '_drafter' || schAct[i]["actrole"] == '_redrafter') { rt = 'N'; break; } //기안자, 재기안자 경우 결재선창을 바로 띄운다

                            sConfirm = "[" + _zw.parse.bizRole(schAct[i]["bizrole"]) + " : " + _zw.parse.actRole(schAct[i]["actrole"]) + "]";
                            if (schAct[i]["mandatory"] == 'Y') { bootbox.alert("필수항목 " + sConfirm + "를 지정하십시오!"); rt = 'N'; break; }
                        }
                        bCheck = false;
                    } else if (vPartType[1] == "h" && schAct[i]["mandatory"] == 'Y') {
                        attrList = attrList.find(function (element) { if (element.actid === schAct[i]["actid"]) return true; });
                        sConfirm = "[" + _zw.parse.bizRole(schAct[i]["bizrole"]) + " : " + _zw.parse.actRole(schAct[i]["actrole"]) + "]";
                        if (attrList.length == 0) { bootbox.alert("필수항목 " + sConfirm + "를 지정하십시오!"); rt = 'N'; break; }
                    }
                } //alert('rt => ' + rt)
                //2013-04-30 특수한 경우 체크
                if (rt == 'Y') rt = _zw.signline.validationSpc(signLine);
            }
            return rt;
        },
        "validationSpc": function (signLine) { //checkSpecialValidLine
            var p = null, p2 = null, c = null, c2 = null, c3 = null, c4 = null, n = null;

            if (_zw.V.ft == 'DRAFT' || _zw.V.ft == 'LEEVINDRAFT') { //크레신 - 일반기안
                if (_zw.V.biz != "confirm" && _zw.V.biz != "last") {
                    p = signLine.filter(function (element) { if (element.bizrole == 'confirm' && element.actrole == '_approver') return true; });
                    c = signLine.filter(function (element) { if (element.bizrole == 'agree' && element.actrole == '_approver') return true; });

                    if (_zw.V.act == '' || _zw.V.act.indexOf('__') != -1) { //2015-12-04
                        p2 = signLine.filter(function (element) { if (element.bizrole == 'last' && element.actrole == '_approver') return true; });
                        c2 = signLine.filter(function (element) { if (element.bizrole == '의견' && element.actrole == '_approver') return true; });
                        c3 = signLine.filter(function (element) { if (element.bizrole != '의견' && element.partid == '101370' && (element.actrole == '_reviewer' || element.actrole == '_approver')) return true; });
                        c4 = signLine.filter(function (element) { if (element.partid == '101559' || element.partid == '101534') return true; });

                        if (c3.length == 0) {
                            if (p2.length > 0 && c2.length == 0 && c4.length == 0) { bootbox.alert("최종승인권자는 회장님 전결 사항에만 지정 가능합니다.\n\n최종승인권자(회장님)가 지정되어 있는 경우 기획조정실장을 의견권자로 반드시 지정하시기 바랍니다"); return 'N'; }
                            else if (c2.length > 0 && p2.length == 0) { bootbox.alert("의견권자는 최종승인권자(회장님)가 지정되어 있는 경우 만 지정 가능합니다."); return 'N'; }
                        }
                    }

                    //if (p.length > 0 && c.length == 0) { bootbox.alert("확인자가(부문장) 지정되어 있는 경우 합의권자를(팀장) 반드시 지정하여야 합니다!"); return false; }

                    if (_zw.V.ft == 'DRAFT') {
                        if (c.length > 0) {
                            n = $('#__subtable1 .sub_table_row:first() input[type="text"]:first()');
                            if (n.length > 0 && $.trim(n.val()) == '') { bootbox.alert("합의권자가 지정되어 있는 경우 합의요청 관련사항을 입력하여야 합니다!", function () { n.focus(); }); return 'F'; }
                        }
                    }
                }
            } else if ((_zw.V.ft == 'SELLINGUC' && _zw.V.def.ver == '4') || (_zw.V.ft == 'EQUIPDRAFTD' && _zw.V.def.ver == '4')
                || (_zw.V.ft == 'EQUIPMAKEPURCHASE' && _zw.V.def.ver == '5') || _zw.V.ft == 'NEWOWNDEVREQUEST' || _zw.V.ft == 'UNITDEVPLAN') { //크레신 - 판매단가결정품의서,설비

                if (_zw.V.biz != "last") {
                    p2 = signLine.filter(function (element) { if (element.bizrole == 'last') return true; });
                    c2 = signLine.filter(function (element) { if (element.bizrole == '의견') return true; });
                    c4 = signLine.filter(function (element) { if (element.partid == '101559' || element.partid == '101534') return true; });

                    if (p2.length > 0 && c2.length == 0 && c4.length == 0) { bootbox.alert("최종승인권자는 회장님 전결 사항에만 지정 가능합니다.\n\n최종승인권자(회장님)가 지정되어 있는 경우 기획조정실장을 의견권자로 반드시 지정하시기 바랍니다"); return 'N'; }
                }

            } else if (_zw.V.ft == 'BIZTRIPPLAN') { //크레신-출장계획서(업무출장)
                if (_zw.V.act == '' && _zw.V.wid == '' && $('#__mainfield[name="COMPANIONYN"]').val() == 'Y') { //기안경우
                    p = signLine.filter(function (element) { if (element.bizrole == '동행자' && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                    if (p.length == 0) { bootbox.alert("동행자를 지정하십시오!"); return 'N'; }
                    else if (p.length > 7) { bootbox.alert("동행자는 7명까지 지정 할 수 있습니다!"); return 'N'; }
                }
            } else if (_zw.V.ft == 'TOOLINGNEWDRAFT' || _zw.V.ft == 'TOOLINGINCREASEDRAFT') { //금형신작, 증장 : 2014-04-22
                if (_zw.V.biz == "normal" && _zw.V.act == '_reviewer') {
                    p = signLine.filter(function (element) { if (element.bizrole == 'last' && element.actrole == '_approver') return true; });
                    var s = 0;
                    $('#__subtable1 tr.sub_table_row .ft-sub-sub').each(function () {
                        if ($(this).find('[name="WHOMONEY"]').val() == '당사') s += parseFloat(_zw.ut.empty($(this).find('[name="CONVPRODUCTCOSTSUM"]').val()));
                    });

                    if (s == 0) {
                        if (p.length > 0) { bootbox.alert("금형비부담이 [고객] 인 경우 최종승인권자를 지정 할 수 없습니다!"); return 'N'; }
                    } else if (s < 5000) {
                        if (p.length > 0) { bootbox.alert("당사 금형비 합계가 $5,000 미만 인 경우 최종승인권자를 지정 할 수 없습니다!"); return 'N'; }
                    } else if (s >= 5000) {
                        if (p.length == 0) { bootbox.alert("당사 금형비 합계가 $5,000 이상 인 경우 최종승인권자를 지정해야 합니다"); return 'N'; }
                    }
                }

            } else if (_zw.V.ft == 'PRODRELEASEREQ') { //자사제품출고요청서 : 2020-12-17
                if (_zw.V.mode == 'new') {
                    var rt = '';
                    $('#__subtable1 tr.sub_table_row').each(function () {
                        if ($(this).find('td [name="CUSTOMER"]').val() != '' && $(this).find('td [name="ITEMNO"]').val() != '') {//고객, 품번 있는 경우에
                            c2 = $(this).find('td [name="FONHAND"]'); c3 = $(this).find('td [name="RELCNT"]');
                            if (c2.val() == '' || c2.val() == '0') {
                                bootbox.alert('재고수량(F. On-hand)이 "0"인 경우 결재진행이 되지 않습니다!'); rt = 'F'; return false;
                            } else if (c3.val() == '' || c3.val() == '0') {
                                bootbox.alert('수량을 "0" 이상 입력하십시오!'); try { c3.focus(); } catch (e) { }; rt = 'F'; return false;
                            }
                        }
                    });
                    if (rt == 'F') return rt;
                }

            } else if (_zw.V.ft == 'CTCMINUTES') { //품평회회의록 : 21-11-24
                if (_zw.V.biz == "normal" && _zw.V.act == '_approver') {
                    if ($('#__mainfield[name="STEP"]').val() == 'PMP') {
                        p = signLine.find(function (element) { if (element.bizrole == 'confirm' && element.actrole == '_approver' && element.partid != '' && element.step != '0' && element.viewstate != '6') return true; });
                        if (p == undefined || p["partname"] != "엄이식") {
                            bootbox.alert("확인권자(엄이식 총괄)를 지정하십시오!"); return 'N';
                        }
                    }
                }
            } else if (_zw.V.ft == 'CANCELREQUEST') { //캔슬요청서 : 2023-05/30
                if (_zw.V.mode == 'new') {
                    if ($('#__mainfield[name="DOCCLASS"]').val() == '중개') {
                        p = signLine.filter(function (element) { if (element.bizrole == 'application' && element.actrole == '__r' && element.partid != '' && element.viewstate != '6') return true; });
                        if (p.length == 0) { bootbox.alert("접수처를 지정하십시오!"); return 'N'; }
                    }
                }
            }
            return 'Y';
        },
        "toFormBody": function (signLine) {
            var p = null, col = null, row = null, len = 0;
            if (_zw.V.ft == 'NEWOWNDEVREQUEST') { //자사신제품개발의뢰서
                if (_zw.V.biz == "등급부서" && _zw.V.act == '_approver') {
                    p = signLine.find(function (element) { if (element.bizrole == 'application' && element.actrole == '_approver' && element.partid != '') return true; });
                    if (!p) { bootbox.alert("필수항목 [접수(개발주관팀)] 누락!"); return false; }
                    $('#__mainfield[name="SUPERVISION"]').val(p["part1"]);
                    return true;
                }
            } else if (_zw.V.ft == "NEWDEVELOPREQUEST") {//OEM신제품개발의뢰서
                if (_zw.V.biz == "등급부서" && _zw.V.act == '_approver') {
                    p = signLine.find(function (element) { if (element.bizrole == 'application' && element.actrole == '_approver' && element.partid != '') return true; });
                    if (!p) { bootbox.alert("필수항목 [접수(개발주관팀)] 누락!"); return false; }
                    $('#__mainfield[name="SUPERVISION"]').val(p["part1"]);
                    return true;
                }
            } else if (_zw.V.ft == "CTCMINUTES") {//품평회회의록
                if (_zw.V.biz == "" && _zw.V.act == '') {
                    col = signLine.filter(function (element) { if (element.bizrole == 'receive' && element.actrole == '__r' && element.partid != '') return true; });
                    p = $('#__subtable5');
                    if (p.length > 0 && col.length > 0) {
                        len = p.find('tr.sub_table_row').length;
                        if (col.length > len) { for (var i = 0; i < col.length - len; i++) _zw.form.addRow('__subtable5'); }

                        for (var i = 0; i < col.length; i++) {
                            row = p.find('tr.sub_table_row')[i];
                            $(row).find('td :text[name="PTDP"]').val(col[col.length - i - 1]["partname"]);
                            $(row).find('td :hidden[name="PTDPID"]').val(col[col.length - i - 1]["partid"]);
                        }
                    }
                }
            } else if (_zw.V.ft == "CHANGEREQUEST") {//부품사양변경요청검토서
                if (_zw.V.biz == "" && _zw.V.act == '') {
                    col = signLine.filter(function (element) { if (element.actrole == '__r' && element.partid != '') return true; }); //console.log(col)
                    p = $('#__subtable1');
                    if (p.length  > 0 && col.length > 0) {
                        len = p.find('tr.sub_table_row').length;
                        if (col.length > len) { for (var i = 0; i < col.length - len; i++) _zw.form.addRow('__subtable1'); }

                        for (var i = 0; i < col.length; i++) {
                            row = p.find('tr.sub_table_row')[i];
                            $(row).find('td :text[name="PTDP"]').val(col[col.length - i - 1]["partname"]);
                            $(row).find('td :hidden[name="PTDPID"]').val(col[col.length - i - 1]["partid"]);
                        }
                    }
                }
            } else if (_zw.V.ft == "BEFORECHANGE") {//4M/1E변경사전회의진행서
                if (_zw.V.biz == "" && _zw.V.act == '') {
                    col = signLine.filter(function (element) { if (element.actrole == '__r' && element.partid != '') return true; });
                    p = $('#__subtable1');
                    if (p.length > 0 && col.length > 0) {
                        len = p.find('tr.sub_table_row').length;
                        if (col.length > len) { for (var i = 0; i < col.length - len; i++) _zw.form.addRow('__subtable1'); }

                        for (var i = 0; i < col.length; i++) {
                            row = p.find('tr.sub_table_row')[i];
                            $(row).find('td :text[name="PTDP"]').val(col[col.length - i - 1]["partname"]);
                            $(row).find('td :hidden[name="PTDPID"]').val(col[col.length - i - 1]["partid"]);
                        }
                    }
                }
            }
        }
    }

    _zw.form = {
        "addUser": function (sub) {
            var p = $('#' + sub), ihdr = parseInt(p.attr('header'));
            alert(ihdr)
        },
        "removeUser": function (sub) {
            var p = $('#' + sub), ihdr = parseInt(p.attr('header'));
            alert(ihdr)
        },
        "addRow": function (sub) {
            var p = $('#' + sub), ihdr = parseInt(p.attr('header')), iCnt = 0, tgtRow = null, newRow = null;
            p.find('tr.sub_table_row').each(function (idx, e) {
                //console.log(idx + " : " + e.rowIndex)
                if ($(this).find('input:checkbox[name="ROWSEQ"]').prop('checked')) {
                    iCnt++; if (iCnt == 1) tgtRow = $(this);
                }
                if (iCnt == 0) tgtRow = $(this);
            });
            //if (iCnt == 0) tgtRow = p.find('tr.sub_table_row:last-child');
            if (iCnt < 2) {
                newRow = tgtRow.clone(); _zw.form.resetField(newRow); tgtRow.after(newRow); _zw.form.orderRow(p);
                _zw.fn.input(newRow); _zw.ut.picker('date');
            }
        },
        "removeRow": function (sub) {
            var p = $('#' + sub), ihdr = parseInt(p.attr('header')), iCnt = 0;
            if (p.find('tr.sub_table_row').length > 1) {
                $(p.find('tr.sub_table_row').get().reverse()).each(function () {
                    if ($(this).find('input:checkbox[name="ROWSEQ"]').prop('checked')) {
                        $(this).remove(); iCnt++;
                    }
                }); //console.log(p.find('tr.sub_table_row').last())
                if (iCnt == 0) p.find('tr.sub_table_row').last().remove();
                _zw.form.orderRow(p);
                if (_zw.formEx.autoCalc) _zw.formEx.autoCalc(p);
            }
        },
        "copyRow": function (sub) {
            var p = $('#' + sub), ihdr = parseInt(p.attr('header')), iCnt = 0, tgtRow = null, newRow = null;
            p.find('tr.sub_table_row').each(function (idx, e) {
                if ($(this).find('input:checkbox[name="ROWSEQ"]').prop('checked')) {
                    iCnt++; if (iCnt == 1) tgtRow = $(this);
                }
                if (iCnt == 0) tgtRow = $(this);
            });
            if (iCnt < 2) {
                newRow = tgtRow.clone(); tgtRow.after(newRow); _zw.form.orderRow(p); _zw.fn.input(newRow); _zw.ut.picker('date');
                if (_zw.formEx.autoCalc) _zw.formEx.autoCalc(p);
            }
        },
        "orderRow": function (p) {
            //p.find('tr.sub_table_row input[name="ROWSEQ"]').each(function (idx, el) { //checkbox 제거
            //    $(this).val(idx + 1);
            //});

            p.find('tr.sub_table_row').each(function (idx, el) {
                //console.log($(this).find('td:first-child input[name="ROWSEQ"]'));
                var c = $(this).find('td:first-child input[name="ROWSEQ"]');
                if (c.length > 0) {
                    c.val(idx + 1);

                    $(this).find('td:gt(1) :checkbox, td:gt(1) :radio').each(function () {
                        var vId = $(this).attr('id');
                        if (vId && vId != undefined) {
                            vId = vId.split('.');
                            $(this).attr('id', vId[0] + '.' + (idx + 1) + '.' + vId[2]); //console.log($(this))

                            $(this).parent().find('label[for]').attr('for', vId[0] + '.' + (idx + 1) + '.' + vId[2])
                        }
                    });
                }
            });
        },
        "resetField": function (el) {
            el.find('input:text, input[type="hidden"], textarea, select').val('');
            el.find('input:checkbox, input:radio').prop('checked', false);
            el.find('select').attr('selectIndex', 0);
            //el.find('select').prop('selectIndex', 0);
            //console.log(el.find('input[type="hidden"]'));
        },
        "validation": function (cmd) {
            if (cmd != null && (cmd == "reject" || cmd == "back" || cmd == "reserve" || cmd == "pre")) return true; //2013-02-21 (지정)반려, 2014-02-20 선결인 경우 체크 제외
            if (cmd != null && cmd != "draft" && _zw.formEx.validation) return _zw.formEx.validation(cmd);
            if (_zw.V.def["validation"] == '') return true;

            var cFirstDel = String.fromCharCode(8), cSecondDel = String.fromCharCode(7);
            var vCheck = _zw.V.def["validation"].split(cSecondDel), vField = null, el = null; //console.log(vCheck);
            var sMsg = '필수항목 [$field] 누락!';
            var jSub = {};

            for (var i = 0; i < vCheck.length; i++) {
                if (vCheck[i].indexOf(cFirstDel) > 0) {
                    vField = vCheck[i].split(cFirstDel);
                    if (vField[0] == 'C') {
                        el = $('#' + vField[2] + '[name="__commonfield"]');
                        if ($.trim(el.val()) == '') { bootbox.alert(sMsg.replace('$field', vField[3]), function () { try { el.focus(); } catch { } }); return false; }

                    } else if (vField[0] == 'M') {
                        el = $('#__mainfield[name="' + vField[2] + '"]');
                        if (el && el.length > 0) {
                            var tag = el.prop('tagName').toLowerCase();
                            if (tag == "div" || tag == "span") {
                                return true;
                            } else if (tag == "input" && (el.is(":checkbox") || el.is(":radio"))) {
                                var b = false;
                                el.each(function () { if ($(this).prop('checked')) b = true; return false; });
                                if (!b) { bootbox.alert(sMsg.replace('$field', vField[3]), function () { try { el[0].focus(); } catch { } }); return false; }
                            } else if ($.trim(el.val()) == '') {
                                bootbox.alert(sMsg.replace('$field', vField[3]), function () { try { el.focus(); } catch { } }); return false;
                            }
                        }
                    } else {
                        if (!jSub[vField[0]]) jSub[vField[0]] = [];
                        jSub[vField[0]].push(vField);
                    }
                }
            } //for

            var bReturn = true; //console.log(jSub)
            for (var x in jSub) {
                $('#__subtable' + x.substr(1) + ' tr.sub_table_row').each(function (idx) {
                    var iData = 0;
                    if (idx > 0) { //둘째줄부터 입력필드가 있는 경우 체크
                        $(this).find(':text[name], :hidden[name]').each(function () { if ($(this).attr('name') != "" && $(this).attr('name') != 'ROWSEQ' && $.trim($(this).val()) != '') { iData++; return false; } });
                    } //console.log(idx + " : " + iData)
                    if (idx == 0 || iData > 0) { //첫줄 필수 체크
                        for (var i = 0; i < jSub[x].length; i++) {
                            var fld = jSub[x][i];
                            el = $(this).find('[name="' + fld[2] + '"]'); //console.log(el)
                            if (el && el.length > 0) {
                                var tag = el.prop('tagName').toLowerCase();
                                if (tag == "div" || tag == "span") {
                                    bReturn = true; return false;
                                } else if (tag == "input" && (el.is(":checkbox") || el.is(":radio"))) {
                                    var b = false;
                                    el.each(function () { if ($(this).prop('checked')) b = true; return false; });
                                    if (!b) {
                                        bootbox.alert(sMsg.replace('$field', fld[3]), function () { try { el[0].focus(); } catch { } });
                                        bReturn = false; return false;
                                    }
                                } else if ($.trim(el.val()) == '') {
                                    bootbox.alert(sMsg.replace('$field', fld[3]), function () { try { el.focus(); } catch { } });
                                    bReturn = false; return false;
                                }
                            }
                        }
                    }
                });
                if (!bReturn) return bReturn;}

            if (_zw.formEx.validation) {
                if (!_zw.formEx.validation(cmd)) return false;
            }
            return true;
        },
        "checkYN": function (ckb, el, fld) {
            $(':checkbox[name="' + ckb + '"]').each(function (idx, e) {
                if (el != e) { if (e.checked) e.checked = false; }
            });
            if (fld) {
                $('input[name="' + fld + '"]').val(fld != '' && el.checked ? el.value : '');
            }
            if (_zw.formEx.checkEvent) _zw.formEx.checkEvent(ckb, el, fld);
        },
        "checkTableYN": function (ckb, el, fld) {
            var p = el.parentNode, vlu = '';
            do { p = p.parentNode; } while (p.tagName.toLowerCase() != 'td');
            $(p).find('span :checkbox[name="' + ckb + '"]').each(function (idx, e) {
                if (el != e) { if (e.checked) e.checked = false; }
            });
            if (fld) {
                $(p).find('input:hidden[name="' + fld + '"]').val(fld != '' && el.checked ? el.value : '');
            }
            console.log($(p).find('input:hidden[name="' + fld + '"]').val());
            if (_zw.formEx.checkEvent) _zw.formEx.checkEvent(ckb, el, fld);
        },
        "view": function () {
            
        },
        "make": function (cmd, j) {
            if (cmd == 'reject' || cmd == 'back') {
                j["biz"] = {};
                j["biz"]["formid"] = _zw.V.def["formid"];
                j["biz"]["processid"] = _zw.V.def["processid"];
                j["biz"]["oid"] = _zw.V["oid"];
                j["biz"]["appid"] = _zw.V["appid"];

                j["doc"] = _zw.V.doc;
                j["form"] = { "maintable": {}, "subtables": {} };
                j["process"] = { "target": {}, "param": {} };
                j["attachlist"] = [];

            } else if (cmd == 'draft' || cmd == 'approval') {
                _zw.body.common(cmd, j);

                if (cmd == 'draft') {
                    _zw.body.main(j["form"]); //, ["REASON", "APPLICANT", "RECEIVEDATE", "LOSSYN", "LOSSAMOUNT"]
                    _zw.body.sub(j["form"]);
                } else {
                    if (_zw.formEx.make) _zw.formEx.make(j["form"]);
                }

                _zw.body.file(cmd, j["doc"], j["attachlist"], j["imglist"]);
            //console.log(j)
            }
        }
    }

    _zw.body = {
        "common": function (cmd, j) {
            j["companycode"] = _zw.V["companycode"];
            j["web"] = _zw.V["web"];
            j["domain"] = _zw.V["domain"];
            j["ct"] = _zw.V["ct"];
            j["xfalias"] = _zw.V["xfalias"];
            j["dnid"] = _zw.V["dnid"];
            //j["wid"] = _zw.V["wid"];
            //j["ss"] = _zw.V["ss"];
            //j["cmnt"] = _zw.V["cmnt"];
            //j["rd"] = _zw.V["rd"];
            j["boundary"] = _zw.V["boundary"];

            j["biz"] = {};
            j["biz"]["formid"] = _zw.V.def["formid"];
            j["biz"]["processid"] = _zw.V.def["processid"];
            j["biz"]["oid"] = _zw.V["oid"];
            j["biz"]["appid"] = _zw.V["appid"];
            j["biz"]["biz"] = _zw.V["biz"];
            j["biz"]["act"] = _zw.V["act"];
            j["biz"]["inherited"] = _zw.V["inherited"];
            j["biz"]["priority"] = _zw.V["priority"];
            j["biz"]["secret"] = _zw.V["secret"];
            j["biz"]["docstatus"] = _zw.V["docstatus"];
            j["biz"]["doclevel"] = _zw.V["doclevel"];
            j["biz"]["keepyear"] = _zw.V["keepyear"];
            j["biz"]["tms"] = _zw.V["tms"];
            j["biz"]["prevwork"] = _zw.V["prevwork"];
            j["biz"]["piname"] = cmd == 'draft' ? _zw.V.doc["docname"] + ' - ' + _zw.V.creator["user"] : _zw.V["piname"];
            j["biz"]["pos"] = _zw.V["pos"];

            if (cmd == 'draft') {
                j["doc"] = {};
                j["doc"]["docname"] = _zw.V.doc["docname"];
                j["doc"]["msgtype"] = _zw.V.doc["msgtype"];
                j["doc"]["docnumber"] = '';
                j["doc"]["doclevel"] = _zw.V.doc["doclevel"];
                j["doc"]["keepyear"] = _zw.V.doc["keepyear"];
                j["doc"]["subject"] = $('#Subject[name="__commonfield"]').length > 0 ? $('#Subject[name="__commonfield"]').val() : '';
                j["doc"]["credate"] = '';
                j["doc"]["pubdate"] = '';
                j["doc"]["expdate"] = '';
                //j["doc"]["attachcount"] = _zw.V.doc["attachcount"];
                //j["doc"]["attachsize"] = _zw.V.doc["attachsize"];
                j["doc"]["linkmsg"] = _zw.V.doc["linkmsg"];
                j["doc"]["transfer"] = _zw.V.doc["transfer"];

                _zw.body.externalKey(cmd, j["doc"], _zw.V.doc["key1"], _zw.V.doc["key2"]);

                if (_zw.V.creator["corp"] != null) {
                    j["doc"]["rsvd1"] = _zw.V.creator["corp"]["corpname"];
                    j["doc"]["rsvd2"] = _zw.V.creator["corp"]["domain"];
                } else {
                    j["doc"]["rsvd1"] = '';
                    j["doc"]["rsvd2"] = '';
                }

                j["creator"] = {};
                j["creator"]["urid"] = _zw.V.creator["urid"];
                j["creator"]["urcn"] = _zw.V.creator["urcn"];
                j["creator"]["user"] = _zw.V.creator["user"];
                j["creator"]["deptid"] = _zw.V.creator["deptid"];
                j["creator"]["deptcd"] = _zw.V.creator["deptcd"];
                j["creator"]["dept"] = _zw.V.creator["dept"];
                j["creator"]["empno"] = _zw.V.creator["empno"];
                j["creator"]["grade"] = _zw.V.creator["grade"];
                j["creator"]["phone"] = _zw.V.creator["phone"];
                j["creator"]["belong"] = _zw.V.creator["belong"];
                j["creator"]["indate"] = _zw.V.creator["indate"];

                j["category"] = _zw.V.category;
                j["linkeddoc"] = _zw.V.linkeddoc;

            } else {
                j["doc"] = _zw.V.doc;
            }

            j["attachlist"] = [];//_zw.V.attachlist;
            j["imglist"] = [];

            j["form"] = {};
            j["process"] = {};
        },
        "main": function (f, v) { //console.log($('#__FormView #__mainfield').length)
            var p = {}
            $('#__FormView #__mainfield').each(function () { //console.log($(this))
                var tag = $(this).prop('tagName').toLowerCase(), nm = $(this).attr('name');
                var b = nm == '' ? false : true;
                if (b && v && v.length > 0) {
                    var fld = v.find(function (element) { if (element == nm) return true; });
                    if (fld === undefined) b = false;
                    //console.log(fld + " : " + b)
                }
                if (b) {
                    //console.log($(this).attr('name') + " : " + $(this).val())
                    if (tag == "div" || tag == "span") {
                        p[nm] = $(this).html();
                    } else if (tag == "input") {
                        if ($(this).is(":checkbox") || $(this).is(":radio")) {
                            p[nm] = $(this).prop('checked') ? $(this).val() : '';
                        } else {
                            //p[nm] = $(this).val();
                            p[nm] = _zw.ut.dateVal($(this));
                        }
                    } else {
                        p[nm] = $(this).val();
                    }
                }
            });

            if (_zw.V.def["webeditor"] != '' && $('#' + _zw.T.editor.holder).length > 0) p["WEBEDITOR"] = DEXT5.getBodyValue();
            f["maintable"] = p;
        },
        "mainCompare": function (f, comp, v) {
            var p = {};
            $('#__FormView #__mainfield').each(function () { //console.log($(this))
                var tag = $(this).prop('tagName').toLowerCase(), nm = $(this).attr('name');
                var b = nm == '' ? false : true;
                if (b) {//v : 제외 필드
                    var fld = v && v.length > 0 && v.find(function (element) { if (element == nm) return true; });
                    b = fld === undefined ? true : false;
                }
                if (b) {
                    var org = _zw.V.form.maintable[nm];
                    if (tag == "div" || tag == "span") {
                        if (!comp || ((org == null && $(this).html() != '') || (org && org != $(this).html()))) p[nm] = $(this).html();
                    } else if (tag == "input") {
                        if (!comp || ((org == null && $(this).val() != '') || (org && org != $(this).val()))) {
                            if ($(this).is(":checkbox") || $(this).is(":radio")) {
                                p[nm] = $(this).prop('checked') ? $(this).val() : '';
                            } else if ($(this).hasClass('txtDate')) {
                                if (org == null || $(this).val() != org.substr(0, 10)) p[nm] = _zw.ut.dateVal($(this));
                            } else {
                                //p[nm] = $(this).val();
                                p[nm] = _zw.ut.dateVal($(this));
                            }
                        }
                    } else {
                        if (!comp || ((org == null && $(this).val() != '') || (org && org != $(this).val()))) p[nm] = $(this).val();
                    }
                }
            });

            //if (_zw.V.def["webeditor"] != '' && $('#' + _zw.T.editor.holder).length > 0) p["WEBEDITOR"] = DEXT5.getBodyValue();
            f["maintable"] = p;
        },
        "sub": function (f) { //console.log($('#__subtable1 tr.sub_table_row').html())
            var s = {};
            for (var i = 1; i <= parseInt(_zw.V.def["subtablecount"]); i++) {
                var prog = $('#__subtable' + i.toString()).attr('progdir');
                if (prog && prog != undefined && prog == 'col') {
                    s['subtable' + i.toString()] = _zw.body.subVer(f, i);
                } else {
                    var v = [];
                    $('#__subtable' + i.toString() + ' tr.sub_table_row').each(function () { //console.log($(this).html())
                        var iData = 0;
                        $(this).find('[name]').each(function () { if ($(this).attr('name') != "" && $(this).prop('tagName').toLowerCase() != 'checkbox' && $(this).attr('name') != 'ROWSEQ' && $.trim($(this).val()) != '') { iData++; return false; } }); //alert(iData)
                        if (iData > 0) { //ROWSEQ 이외 필드 값이 들어 있을 경우
                            var s = {};
                            $(this).find('[name]').each(function () {
                                var tag = $(this).prop('tagName').toLowerCase(), nm = $(this).attr('name'); //console.log(tag + " : " + nm + " : " + $(this).val())
                                if (nm != '') {
                                    if (tag == "div" || tag == "span") {
                                        s[nm] = $(this).html();
                                    } else if (tag == "input") {
                                        if (nm != 'ROWSEQ' && ($(this).is(":checkbox") || $(this).is(":radio"))) {
                                            s[nm] = $(this).prop('checked') ? $(this).val() : '';
                                        } else {
                                            //s[nm] = $(this).val();
                                            s[nm] = _zw.ut.dateVal($(this));
                                        }
                                    } else {
                                        //s[nm] = $(this).val();
                                        s[nm] = _zw.ut.dateVal($(this));
                                    }
                                }
                            });
                            v.push(s);
                        }
                    });
                    s['subtable' + i.toString()] = v;
                    v = null;
                }
            }
            f["subtables"] = s;
        },
        "subVer": function (f, cnt) {
            var len = $('#__subtable' + cnt.toString() + ' tr.sub_table_row').first().find('> td:not(.f-lbl-sub)').length;
            var v = [];
            for (var i = 0; i < len; i++) {
                var s = {};
                $('#__subtable' + cnt.toString() + ' tr.sub_table_row').each(function (idx) {
                    $(this).find('> td:not(.f-lbl-sub)').eq(i).find('[name]').each(function () {
                        var tag = $(this).prop('tagName').toLowerCase(), nm = $(this).attr('name'); //console.log(tag + " : " + nm + " : " + $(this).val())
                        if (nm != '' && nm != 'ROWSEQ') {
                            if (tag == "div" || tag == "span") {
                                s[nm] = $(this).html();
                            } else if (tag == "input") {
                                if ($(this).is(":checkbox") || $(this).is(":radio")) {
                                    s[nm] = $(this).prop('checked') ? $(this).val() : '';
                                } else {
                                    //s[nm] = $(this).val();
                                    s[nm] = _zw.ut.dateVal($(this));
                                }
                            } else {
                                //s[nm] = $(this).val();
                                s[nm] = _zw.ut.dateVal($(this));
                            }
                        }
                    });
                });
                s["ROWSEQ"] = i + 1;
                v.push(s);
            }
            //s['subtable' + cnt.toString()] = v;
            return v;
        },
        "subPart": function (f, subInfo) { //테이블구분^, 필드구분;
            var vSub = subInfo.split('^'), p = {}; //console.log(vSub)
            for (var i = 0; i < vSub.length; i++) {
                var fld = vSub[i].split(';');
                var v = [];
                $('#__subtable' + fld[0] + ' tr.sub_table_row').each(function () {
                    var s = {};
                    if ($(this).find('[name="ROWSEQ"]').length > 0) {
                        s["ROWSEQ"] = $(this).find('[name="ROWSEQ"]').val();
                        for (var x = 1; x < fld.length; x++) {
                            var node = $(this).find('[name="' + fld[x] + '"]');
                            if (node.length > 0) {
                                if (node.prop('tagName').toLowerCase() == 'div' || node.prop('tagName').toLowerCase() == 'span') {
                                    s[fld[x]] = node.html();
                                } else if (node.prop('tagName').toLowerCase() == 'input') {
                                    if (node.is(":checkbox") || node.is(":radio")) {
                                        s[fld[x]] = node.prop('checked') ? node.val() : '';
                                    } else {
                                        //s[fld[x]] = node.val();
                                        s[fld[x]] = _zw.ut.dateVal(node);
                                    }
                                } else {
                                    //s[fld[x]] = node.val();
                                    s[fld[x]] = _zw.ut.dateVal(node);
                                }
                            }
                        }
                        v.push(s);
                    }
                });
                p['subtable' + fld[0]] = v;
                v = null;
            }
            f["subtables"] = p;
        },
        "file": function (cmd, doc, fi, img) {
            var fileList = DEXT5UPLOAD.GetAllFileListForJson(); //console.log(fileList)
            var imgList = DEXT5.getImagesEx(); //console.log(imgList)

            if (fileList && fileList.webFile) {
                var webFile = fileList.webFile;
                for (var i = 0; i < webFile.originalName.length; i++) {
                    if (webFile.customValue[i] == '' || webFile.customValue[i] == '0') {//기존 첨부는 담지 않음
                        var v = {};
                        var idx = webFile.uploadPath[i].lastIndexOf('/');
                        var savedName = webFile.uploadPath[i].substr(idx + 1);
                        idx = savedName.lastIndexOf('.');
                        v["attachid"] = 0;
                        v["atttype"] = "O";
                        v["seq"] = webFile.order[i];
                        v["isfile"] = "Y";
                        v["filename"] = webFile.originalName[i];
                        v["savedname"] = savedName;
                        v["ext"] = savedName.substr(idx + 1);
                        v["size"] = webFile.size[i];
                        v["filepath"] = webFile.uploadPath[i];
                        v["storagefolder"] = "";

                        fi.push(v);
                    }
                }
            }

            doc["attachcount"] = DEXT5UPLOAD.GetTotalFileCount();
            doc["attachsize"] = DEXT5UPLOAD.GetTotalFileSize();

            //양식 필드내 직접 첨부된 파일 처리
            if (_zw.fu.fileList && _zw.fu.fileList.length > 0) {
                for (var i = 0; i < _zw.fu.fileList.length; i++) fi.push(_zw.fu.fileList[i]);
            }

            if (imgList) {
                var rgx = (location.origin + $('#upload_path').val()).toLowerCase();
                var vImg = imgList.split(_zw.T.uploader.da);
                for (var i = 0; i < vImg.length; i++) {
                    var vInfo = vImg[i].split(_zw.T.uploader.df); //console.log(location.host + " : " + vInfo[0] + " : " + rgx)
                    if (vInfo[0].toLowerCase().indexOf(rgx) != -1) {
                        var v = {};
                        var idx = vInfo[1].lastIndexOf('.');
                        v["attachid"] = 0;
                        v["atttype"] = "O";
                        v["seq"] = 0;
                        v["isfile"] = "N";
                        v["filename"] = vInfo[1];
                        v["savedname"] = vInfo[1];
                        v["ext"] = vInfo[1].substr(idx + 1);
                        v["size"] = "";
                        v["filepath"] = vInfo[0];
                        v["storagefolder"] = "";

                        //v["imgname"] = vInfo[1];
                        //v["imgpath"] = vInfo[0];
                        v["origin"] = location.origin; //console.log(v)
                        img.push(v);
                    }
                }
            }
        },
        "externalKey": function (cmd, doc, k1, k2) {
            k1 = k1 || '', k2 = k2 || '';

            if (_zw.V.ft == 'MONTHFAULTYGOODS' || _zw.V.ft == 'MONTHFAULTYGOODSCTISM' || _zw.V.ft == 'MONTHLOSSCHART') { //작업불량품발생기안, 작업불량품발생기안CT(ISM), 월손실비용발생현황
                doc["key1"] = $('#__mainfield[name="CORPORATION"]').val() + '-' + $('#__mainfield[name="STATSYEAR"]').val() + $('#__mainfield[name="STATSMONTH"]').val();
                doc["key2"] = k2;

            } else if (_zw.V.ft == 'BIZTRIPDAILYREPORT') { //출장계획서, 해외출장일보
                doc["key1"] = _zw.V.current.user + '-' + _zw.V.current.dept + '-' + $('#__mainfield[name="CORPORATION"]').val()
                doc["key2"] = k2;

            } else {
                doc["key1"] = k1;
                doc["key2"] = k2;

                var f1 = $('#__mainfield[name="MODELNAME"]'), f2 = $('#__mainfield[name="CUSTOMER"]'), f3 = $('#__mainfield[name="STEP"]');
                if (f1.length == 1) {
                    doc["key1"] = $.trim(f1.val());
                    if (f3.length == 1) doc["key2"] = $.trim(f3.val());
                }
            }
        }
    }

    //양식별로 선언(예:FORM_DRAFT.js)
    _zw.formEx = {
        //checkEvent(ckb, el, fld), autoCalc(p)
    }
});

function DEXT5UPLOAD_BeforeAddItem(uploadID, fileName, fileSize, idx, localPath, f) {//localPath -> drag 경우 ''
    console.log("check -> " + fileName + " : " + fileSize + " : " + idx);
    var v = DEXT5UPLOAD.GetAllFileListForJson();
    if (v) {
        for (var i = 0; i < v.webFile.originalName.length; i++) {
            if (fileName == v.webFile.originalName[i]) return false;
        }
    }
    return true;
}

function DEXT5UPLOAD_AfterAddItemEndTime() {
    console.log('transfer');
    // 파일 추가후 처리할 내용
    DEXT5UPLOAD.TransferEx();
}

function DEXT5UPLOAD_OnTransfer_Start() {
    console.log('start => ' + (new Date()))
    // 업로드 시작 후 처리할 내용
    return true;
}

function DEXT5UPLOAD_OnTransfer_Complete() {
    console.log('complete => ' + (new Date()) + " : " + DEXT5UPLOAD.GetTotalFileCount() + " : " + DEXT5UPLOAD.GetTotalFileSize());
    //console.log(DEXT5UPLOAD.GetNewUploadListForJson());
    //var attachlist = _zw.V.attachlist;
    var jsonNew = DEXT5UPLOAD.GetNewUploadListForJson();
    for (var i = 0; i < jsonNew.originalName.length; i++) {
        //var v = {};
        //v["attachid"] = 0;
        //v["atttype"] = "O";
        //v["seq"] = parseInt(jsonNew.order[i]);
        //v["isfile"] = "Y";
        //v["filename"] = jsonNew.originalName[i];
        //v["savedname"] = jsonNew.uploadName[i];
        //v["size"] = jsonNew.size[i];
        //v["ext"] = jsonNew.extension[i];
        //v["filepath"] = jsonNew.uploadPath[i].split(':')[1]; //vInfo[4].substr(1).replace(/\//gi, '\\');
        //v["storagefolder"] = "";

        //attachlist.push(v);

        DEXT5UPLOAD.SetUploadedFile(jsonNew.order[i] - 1, jsonNew.order[i] - 1, jsonNew.originalName[i], jsonNew.uploadPath[i].split(':')[1], jsonNew.size[i], '', _zw.T.uploader.id);
    }
    //_zw.V.doc["attachcount"] = DEXT5UPLOAD.GetTotalFileCount();
    //_zw.V.doc["attachsize"] = DEXT5UPLOAD.GetTotalFileSize();

    //console.log(_zw.V.attachlist)
}

function DEXT5UPLOAD_CustomAction(uploadID, cmd) {
    if (cmd == 'custom_remove') {
        // 파일 삭제 전 처리할 내용
        var fileList = DEXT5UPLOAD.GetSelectedAllFileListForText();
        var newFile = fileList.newFile, webFile = fileList.webFile;
        var sId = '';

        //if (newFile) {
        //    var vFile = newFile.split(_zw.T.uploader.df);
        //    for (var i = 0; i < vFile.length; i++) {
        //        var vInfo = vFile[i].split(_zw.T.uploader.da); console.log(vInfo)
        //    }
        //}

        if (webFile) {
            var vFile = webFile.split(_zw.T.uploader.df);
            for (var i = 0; i < vFile.length; i++) {
                var vInfo = vFile[i].split(_zw.T.uploader.da); //console.log(vInfo)
                if (i > 0) sId += ';';
                sId += vInfo[5];
            }
        }

        if (newFile || webFile) {
            var msg = '삭제 하시겠습니까?' + (sId != '' ? ' 기존 첨부파일은 복구되지 않습니다.' : '');
            bootbox.confirm(msg, function (rt) {
                if (rt) {
                    var bDelete = true;
                    if (sId != '') {
                        $.ajax({
                            type: "POST",
                            url: "/Common/DeleteAttach",
                            data: '{xf:"' + _zw.V.xfalias + '",appid:"' + _zw.V.appid + '",fdid:"' + _zw.V.fdid + '",tgtid:"' + sId + '"}',
                            async: false,
                            success: function (res) {
                                if (res == "OK") {
                                    //console.log('200=>' + res);
                                } else {
                                    bDelete = false; bootbox.alert(res);
                                }
                            }
                        });
                    }

                    //console.log('300=>' + bDelete.toString());
                    if (bDelete) DEXT5UPLOAD.DeleteSelectedFile();
                }
            });
        }

    } else if (cmd == 'custom_up') {
        DEXT5UPLOAD.MoveForwardFile();
    } else if (cmd == 'custom_down') {
        DEXT5UPLOAD.MoveBackwardFile();
    }
}

function DEXT5UPLOAD_OnError(uploadID, code, message, uploadedFileListObj) {
    //에러 발생 후 경고창 띄어줌
    alert("Error Code : " + code + "\nError Message : " + message);
}