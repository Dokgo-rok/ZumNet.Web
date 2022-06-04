//전자결재 메인, 리스트뷰

$(function () {

    if (_zw.V.mode == "read") {
        $.ajax({
            type: "POST",
            url: "/Form/ViewCount",
            data: '{xf:"' + _zw.V.xfalias + '",mi:"' + _zw.V.appid + '",actor:"' + _zw.V.appid + '",fdid:"' + _zw.V.fdid + '",wi:"' + _zw.V.wid + '",wn:"' + _zw.V.wnid + '"}',
            success: function (res) {
                if (res != "OK") bootbox.alert(res);
            },
            beforeSend: function () {//pace.js 충돌
            }
        });
    }

    var sw = window.screen.availWidth, sh = window.screen.availHeight, w = $('#__FormView .m').outerWidth() + 100;
    //console.log(sw + " : " + sh + " : " + fw)
    if (sw < 860) {
        window.moveTo(1, 1); window.resizeTo(sw, sh);
    } else if (sw < w) {
        window.moveTo(1, 10); window.resizeTo(sw, sh - 20);
    } else {
        window.moveTo(sw / 2 - w / 2, 10); window.resizeTo(w < 900 ? 900 : w, sh - 20);
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
                break;

            case "preview":
                break;

            case "showHelp":
                console.log(DEXT5UPLOAD.GetAllFileListForJson());
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
                break;

            case "fileAttach":
                $('#popUploader').modal();
                break;

            case "signLine":
                var cmd = _zw.V.apvmode;
                //if (_zw.V.mode == 'new' || _zw.V.mode == 'edit' || _zw.V.mode == 'reuse') cmd = 'draft';
                //else {
                //    if (_zw.V.wid != '' && (_zw.V.partid.indexOf("__") >= 0 || (_zw.V.partid.indexOf("__") < 0 && _zw.V.partid == _zw.V.current.urid))) cmd = 'approval';
                //    else cmd = 'read';
                //}
                var jPost = {};
                jPost["M"] = cmd; jPost["multi"] = 'y'; jPost["boundary"] = _zw.V.boundary; jPost["xf"] = _zw.V.xfalias;
                jPost["fi"] = _zw.V.def.formid; jPost["def"] = _zw.V.def.processid; jPost["oi"] = _zw.V.oid
                jPost["wi"] = _zw.V.wid; jPost["appid"] = _zw.V.appid; jPost["tp"] = _zw.V.tp;

                if (cmd == 'approval' && _zw.V.curprogress == 'parallel') {//병렬이면서 결재자 하나 여부
                    var iCurPart = 0;
                    for (var i = 0; i < _zw.V.process.signline.length; i++) {
                        var n = _zw.V.process.signline[i];
                        if (n["activityid"] == _zw.V.curactid && n["viewstate"] != '6') iCurPart++;
                    }
                    jPost["curpart"] = iCurPart;
                    //jPost["signline"] = _zw.V.process.signline; jPost["attributes"] = _zw.V.process.attributes;
                }

                _zw.signline.open(cmd, 'y', jPost);
                break;

            case "draft":
                $('#popSignPlate').modal();
                break;

            default:
                break;
        }
        $(this).tooltip('hide');
    });

    _zw.signline = {
        "open": function (m, multi, postData) {
            var p = $('#popSignLine');
            if (p.find('.zf-sl').length > 0) { //console.log('1111')
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

                            if (p.find('#orgmaptree').length > 0) new PerfectScrollbar(p.find('#orgmaptree')[0]);
                            if (p.find('#personline').length > 0) new PerfectScrollbar(p.find('#personline')[0]);
                            new PerfectScrollbar(p.find('.zf-sl .zf-sl-member .card:first-child .card-body')[0]);
                            new PerfectScrollbar(p.find('.zf-sl .zf-sl-member .card:last-child .card-body')[0]);
                            new PerfectScrollbar(p.find('.zf-sl .zf-sl-list .card-body')[0]);

                            p.find('.nav-tabs-top a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                                var s = e.target.getAttribute('aria-controls');
                                if (s == 'personline') {
                                    p.find('.zf-sl .zf-sl-member .card:first-child').addClass('d-none');
                                    p.find('.zf-sl .zf-sl-member .card:last-child').removeClass('d-none');
                                } else {
                                    p.find('.zf-sl .zf-sl-member .card:first-child').removeClass('d-none');
                                    p.find('.zf-sl .zf-sl-member .card:last-child').addClass('d-none');
                                }
                                p.find('.zf-sl .zf-sl-member .card-body').html('');
                            });

                            $('#__OrgMapTree').jstree({
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

                            $('#__OrgMapSearch input[data-for]').keyup(function (e) {
                                if (e.which == 13) $('#__OrgSearch .btn-outline-success').click();
                            });

                            $('#__OrgMapSearch .btn-outline-success').click(function () {
                                var j = {}; j['M'] = 'search'; j['boundary'] = _zw.V.boundary;
                                if ($('#orgmapsearch').hasClass('active')) {//검색창 활성화 여부
                                    $('#__OrgMapSearch [data-for]').each(function () {
                                        j[$(this).attr('data-for')] = $(this).val();
                                    });
                                }
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
                                return false;
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
                                    if (tab == 'orgmaptree') {
                                        var selected = $('#__OrgMapTree').jstree('get_selected', true); console.log(selected)
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
                                }
                            });
                            
                            var jPart = JSON.parse(p.find('.zf-sl-template-part').text()); //console.log(jPart);
                            for (var i = 0; i < jPart.length; i++) _zw.V.process.signline.push(jPart[i]);

                            if (p.find('.zf-sl-template-attr').length > 0) {
                                var jAttr = JSON.parse(p.find('.zf-sl-template-attr').text());
                                for (var i = 0; i < jAttr.length; i++) _zw.V.process.attributes.push(jAttr[i]);
                                //console.log(_zw.V.process.attributes);
                            }

                            if (!_zw.V.templine) _zw.V["templine"] = JSON.parse('{"signline":[],"attributes":[],"deleted":""}');
                            //console.log(_zw.V.process["signline"]);

                            _zw.signline.render(p, m);
                            _zw.signline.userInfo(p, multi);

                            p.modal('show');
                        } else bootbox.alert(res);
                    }
                });
            }
        },
        "render": function (p, m) {
            var signLine = _zw.V.templine.signline.length > 0 ? _zw.V.templine.signline : _zw.V.process.signline;
            var attrList = _zw.V.templine.attributes.length > 0 ? _zw.V.templine.attributes : _zw.V.process.attributes;
            
            var ln = signLine.filter(function (element) {
                if (element.parent === '') return true;
            }); //console.log(ln);

            var curln = null;
            if (_zw.V.wid != '') {
                curln = signLine.find(function (element) {
                    if (element.wid === _zw.V.wid) return true;
                });
            }

            var temp = p.find('.zf-sl-template').html();
            for (var i = 0; i < ln.length; i++) {
                var sub = signLine.filter(function (element) {
                    if (element.parent != '' && element.parent === ln[i].wid) return true;
                }); //console.log(sub)

                p.find('.zf-sl-list .zf-sl-line').append(_zw.signline.template(m, temp, ln[i], curln, sub));

                if (sub && sub.length > 0) {
                    p.find('.zf-sl-list .zf-sl-line > li[wid="' + ln[i].wid + '"]').append('<ul class="zf-sl-subline pb-0"></ul>');
                    for (var j = 0; j < sub.length; j++) {
                        p.find('.zf-sl-list .zf-sl-line > li[wid="' + ln[i].wid + '"] .zf-sl-subline').append(_zw.signline.template(m, temp, sub[j], curln, null));
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

            p.find('.zf-sl .zf-sl-read .btn[aria-expanded]').click(function () {
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
                trigger: 'focus',
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
        "add": function (p, cmd, ot, act, info, nm) { console.log(info);
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
                else sHtml = _zw.signline.template2(temp, sOrderNo, pwid, info["id"], act["actid"], act["bizrole"], act["actrole"], act["parttype"], info["grade"], '', nm, info["grdn"], info["gralias"]);
                if (bClone) rowTarget.before(sHtml);
                else rowTarget.replaceWith(sHtml);

                _zw.signline.setOrder(p, p.find(query), rowTarget);
            }
        },
        "remove": function (p) {

        },
        "move": function (p, dir) {

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

                }

            } else if (att != null && (att == 'mail_dl' || att == 'xform_dl' || att == 'xform_cf')) {
                p.find('.zf-sl-attr a[href="#attList_' + att + '"]').tab('show');
                p.find('.zf-sl-attr #attList_' + att).children().each(function (idx, el) {
                    if (ot + '.' + partid == el.id) { bRt = false; return false;}
                });
            }
            return bRt;
        },
        "putDeleteLine": function (wid) {
            if (wid != '') { if (_zw.V.templine["deleted"] == '') { _zw.V.templine["deleted"] = wid; } else { _zw.V.templine["deleted"] += ',' + wid; } }
        },
        "setOrder": function (p, list, row) { //console.log(list)
            var rowPrev = null, vNo = null, vPrevNo = null;
            var curNo = '', preNo = '', orderNo = '';
            $(list.get().reverse()).each(function (idx) {
                if (rowPrev) {
                    curNo = $(this).find(' > div > div:nth-child(2)').text(); 
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
                    $(this).find(' > div > div:nth-child(2)').text(orderNo);
                }
                rowPrev = $(this);
            });
        },
        "template": function (cmd, s, v, cur, sub) {
            var sCls = '', sCheck = '', bParallel = cur != null && cur.substep != '0' ? true : false;
            var sMarginTop = '', sTextAlign = '', sOrderNo = v["step"] + (parseInt(v["substep"]) > 0 ? '.' + v["substep"] : '');

            if (sub && sub.length > 0) {
                sCls = 'zf-sl-read';
                sCheck = '<button class="btn btn-outline-secondary zf-btn-xs" aria-expanded="false"><i class="fas fa-minus"></i></button>';
                sMarginTop = ' mt-1';

            } else {
                if (v["parent"] != '') {
                    sCheck = '<span class="fe-corner-down-right font-weight-bold text-secondary"></span>';
                    sTextAlign = ' text-right';

                    if (v["completed"] == '' && v["partid"] != '') {
                        if (v["state"] == 2 && (v["wid"] == _zw.V.wid || v['actrole'] == '_redrafter')) {
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
                        if (v["state"] == 2 && v["wid"] == _zw.V.wid && v["completed"] != '' && v["partid"] != '') sCls = 'zf-sl-current';
                        else sCls = 'zf-sl-read';
                    }
                } else {
                    if (v["completed"] == '' && v["partid"] != '') {
                        if (v["state"] == 2 && v["wid"] == _zw.V.wid) {
                            sCls = 'zf-sl-current';
                        } else {
                            if (!bParallel && v["received"] == '' && v["signkind"] != '3' && v["signkind"] != '4') {
                                if (v["parttype"].substr(2, 1) == '' || v["parttype"].substr(0, 3) == 'u_g') sCls = 'zf-sl-read';
                                else if (_zw.V.wid != '' && _zw.V.pwid != '') sCls = 'zf-sl-read';
                                else {
                                    sCls = 'zf-sl-add';
                                    sCheck = '<label class="custom-control custom-checkbox mb-0 ml-1"><input type="checkbox" class="custom-control-input"><span class="custom-control-label"></span></label>';
                                }
                            } else {
                                sCls = 'zf-sl-read';
                            }
                        }
                    } else {
                        if (v["state"] == 2 && v["wid"] == _zw.V.wid && v["completed"] != '' && v["partid"] != '') sCls = 'zf-sl-current';
                        else sCls = 'zf-sl-read';
                    }
                }
            }

            var sPartName = v["parttype"].substr(0, 1) == 'g' ? v["partname"] : v["part1"] + '.' + v["partname"];
            sPartName = '<a href="javascript:void(0)" data-toggle="popover" data-placement="bottom" title="">' + sPartName + (v["comment"] != '' ? '<i class="far fa-comment-dots text-info"></i>' : '') + '</a>';

            var sRole = '';
            if (v["parttype"].substr(0, 1) == 'g') sRole = _zw.parse.bizRole(v["bizrole"]);
            else if (v["bizrole"] == 'normal' || v["bizrole"] == 'receive' || v["bizrole"] == 'gwichaek' || (v["bizrole"] == 'application' && v["actrole"] == '_reviewer')) sRole = _zw.parse.actRole(v["actrole"]);
            else sRole = _zw.parse.bizRole(v["bizrole"]);

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
            else if (bizRole == 'normal' || bizRole == 'receive' || bizRole == 'gwichaek' || (bizRole == 'application' && actRole == '_reviewer')) sRole = _zw.parse.actRole(actRole);
            else sRole = _zw.parse.bizRole(bizRole);

            s = s.replace("{$class}", 'zf-sl-add').replace("{$check}", sCheck);
            s = s.replace("{$mode}", '1').replace("{$wid}", '').replace("{$parent}", parent).replace("{$partid}", partId).replace("{$actid}", actId);
            s = s.replace("{$step}", 0).replace("{$substep}", 0).replace("{$seq}", 0).replace("{$state}", 0).replace("{$signstatus}", 0).replace("{$signkind}", 0);
            s = s.replace("{$bizrole}", bizRole).replace("{$actrole}", actRole).replace("{$parttype}", partType).replace("{$deptcode}", deptCode).replace("{$part2}", part2).replace("{$part5}", part5);

            s = s.replace("{$textalign}", sTextAlign).replace("{$order}", sOrderNo);
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
                newRow = tgtRow.clone(); _zw.form.resetField(newRow); tgtRow.after(newRow);
                _zw.form.orderRow(p);
            }
        },
        "removeRow": function (sub) {
            var p = $('#' + sub), ihdr = parseInt(p.attr('header')), iCnt = 0;
            if (p.find('tr.sub_table_row').length > 1) {
                $(p.find('tr.sub_table_row').get().reverse()).each(function () {
                    if ($(this).find('input:checkbox[name="ROWSEQ"]').prop('checked')) {
                        $(this).remove(); iCnt++;
                    }
                });
                if (iCnt == 0) p.find('tr.sub_table_row:last-child').remove();
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
                newRow = tgtRow.clone(); tgtRow.after(newRow);
                _zw.form.orderRow(p);
                if (_zw.formEx.autoCalc) _zw.formEx.autoCalc(p);
            }
        },
        "orderRow": function (p) {
            p.find('tr.sub_table_row input:checkbox[name="ROWSEQ"]').each(function (idx, el) {
                $(this).val(idx + 1);
            });
        },
        "resetField": function (el) {
            el.find('input:text, input:hidden').val('');
            el.find('input:checkbox, input:radio').prop('checked', false);
            el.find('select').attr('selectIndex', 0);
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
            if (_zw.formEx.checkEvent) _zw.formEx.checkEvent(ckb, el, fld);
        },
        "view": function () {
            
        }
    }

    //양식별로 선언(예:DRAFT.js)
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
    console.log('complete => ' + (new Date()) + " : " + DEXT5UPLOAD.GetTotalFileSize());
    //console.log(DEXT5UPLOAD.GetNewUploadListForJson());
    var jsonNew = DEXT5UPLOAD.GetNewUploadListForJson();
    for (var i = 0; i < jsonNew.originalName.length; i++) {
        DEXT5UPLOAD.SetUploadedFile(jsonNew.order[i] - 1, jsonNew.order[i] - 1, jsonNew.originalName[i], jsonNew.uploadPath[i].split(':')[1], jsonNew.size[i], '', _zw.T.uploader.id);
    }
}

function DEXT5UPLOAD_OnError(uploadID, code, message, uploadedFileListObj) {
    //에러 발생 후 경고창 띄어줌
    bootbox.alert("Error Code : " + code + "\nError Message : " + message);
}