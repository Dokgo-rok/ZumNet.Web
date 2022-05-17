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
                var cmd = '';
                if (_zw.V.mode == 'new' || _zw.V.mode == 'edit' || _zw.V.mode == 'reuse') cmd = 'draft';
                else {
                    if (_zw.V.wid != '' && (_zw.V.partid.indexOf("__") >= 0 || (_zw.V.partid.indexOf("__") < 0 && _zw.V.partid == _zw.V.current.urid))) cmd = 'approval';
                    else cmd = 'read';
                }
                var jPost = {};
                jPost["M"] = cmd; jPost["multi"] = 'y'; jPost["boundary"] = _zw.V.boundary; jPost["xf"] = _zw.V.xfalias;
                jPost["fi"] = _zw.V.def.formid; jPost["def"] = _zw.V.def.processid; jPost["oi"] = _zw.V.oid
                jPost["wi"] = _zw.V.wid; jPost["appid"] = _zw.V.appid; jPost["tp"] = _zw.V.tp;

                if (cmd != 'draft') {
                    jPost["signline"] = _zw.V.process.signline; jPost["attributes"] = _zw.V.process.attributes;
                }

                _zw.signline.show(cmd, 'y', jPost);
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
        "show": function (m, multi, postData) {
            $.ajax({
                type: "POST",
                url: "/EA/Form/SignLine",
                data: JSON.stringify(postData),
                success: function (res) {
                    if (res.substr(0, 2) == "OK") {
                        var v = res.substr(2).split(_zw.V.boundary); //console.log(JSON.parse(v[1]))
                        var p = $('#popSignLine'); p.html(v[0]);

                        if (p.find('#orgmaptree').length > 0) new PerfectScrollbar(p.find('#orgmaptree')[0]);
                        if (p.find('#personline').length > 0) new PerfectScrollbar(p.find('#personline')[0]);
                        new PerfectScrollbar(p.find('.zf-sl .zf-sl-member .card-body')[0]);
                        new PerfectScrollbar(p.find('.zf-sl .zf-sl-line')[0]);

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
                                                p.find('.zf-sl .zf-sl-member .card-body').html(res.substr(2));
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
                                        p.find('.zf-sl .zf-sl-member .card-body').html(res.substr(2));
                                        _zw.signline.userInfo(p, multi);
                                    } else bootbox.alert(res);
                                },
                                beforeSend: function () { } //로딩 X
                            });
                            return false;
                        });

                        _zw.signline.userInfo(p, multi);

                        p.modal('show');
                    } else bootbox.alert(res);
                }
            });
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