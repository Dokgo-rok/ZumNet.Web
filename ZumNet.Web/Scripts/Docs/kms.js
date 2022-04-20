//문서관리 리스트뷰

$(function () {
    $('#__CtDashboard a[data-zl-menu], .messages-sidebox a[data-zl-menu], .z-lv-tab a[data-zl-menu]').click(function () {
        var mn = $(this).attr("data-zl-menu"); //console.log(mn)

        if (mn.toLowerCase() == 'recent' || mn.toLowerCase() == 'temp' || mn.toLowerCase() == 'complete' || mn.toLowerCase() == 'approval') {
            _zw.V.mode = mn.toLowerCase(); _zw.V.ttl = $.trim($(this).text()); _zw.V.fdid = '0'; _zw.V.opnode = '';
            var url = mn.toLowerCase() == 'recent' ? '/Docs/Kms/List' : '/Docs/Kms/MyList';

            _zw.fn.initLv(_zw.V.fdid);
            var encQi = _zw.fn.getLvQuery();
            window.location.href = url + '?qi=' + encodeURIComponent(_zw.base64.encode(encQi));
        }
    });


    _zw.mu.writeMsg = function (xf) {
        _zw.V.mode = '';
        _zw.V.wnd = 'popup';
        _zw.V.appid = 0;
        _zw.V.xfalias = xf;

        var postData = _zw.fn.getAppQuery(_zw.V.fdid);
        var url = '/Docs/Kms/Write?qi=' + encodeURIComponent(_zw.base64.encode(postData));
        _zw.ut.openWnd(url, "popupform", 800, 800, "resize");
    }

    _zw.mu.editMsg = function (xf, m) { //alert(_zw.V.appid)
        m = m || '';
        _zw.V.mode = '';
        _zw.V.wnd = 'popup';
        _zw.V.xfalias = xf;

        if (m == 'temp') {
            var el = event.target, p = $(el).parent().parent();
            _zw.V.appid = p.attr('appid'); _zw.V.fdid = p.attr('fdid') != undefined ? p.attr('fdid') : _zw.V.fdid;
            _zw.V.lv.sort = 'CreateDate'; _zw.V.lv.sortdir = 'DESC';
        }

        var postData = _zw.fn.getAppQuery(_zw.V.fdid);
        var url = '/Docs/Kms/Edit?qi=' + encodeURIComponent(_zw.base64.encode(postData));
        _zw.ut.openWnd(url, "popupform", 800, 800, "resize");
    }

    _zw.mu.deleteMsg = function () {
        if (_zw.V.current.page.toLowerCase().indexOf('/list') > 0 || _zw.V.current.page.toLowerCase().indexOf('/mylist') > 0) {
            $('#__ListView input:checkbox:checked').each(function () {
                var p = $(this).parent().parent().parent();
                //console.log(p.attr('appid') + " : " + p.attr('auth') + " : " + $.trim(p.find('div:nth-child(3)').text()))
            });
            bootbox.alert('준비중!');

        } else {
            var bDeletable = true;
            if (_zw.V.app.coregcount > 0) {
                var v = _zw.V.app.coreglist.find(function (item) { return item.vewdate != ''; }); //console.log(v)
                if (v != null) bDeletable = false;
            }
            if (_zw.V.app.cmntcount > 0 || (_zw.V.app.replycount > 1 && parseInt(_zw.V.app.depth) == 0)) bDeletable = false;

            if (!bDeletable) {
                bootbox.alert('삭제할 수 없는 문서입니다!'); return false; //지식공유자 확인 또는 댓글 존재
            } else {
                bootbox.confirm("삭제 하시겠습니까?", function (rt) {
                    if (rt) {
                        $.ajax({
                            type: "POST",
                            url: "/Common/DeleteMsg",
                            data: '{xf:"' + _zw.V.xfalias + '",fdid:"' + _zw.V.fdid + '",mi:"' + _zw.V.appid + '",urid:"' + _zw.V.current.urid + '"}',
                            success: function (res) {
                                if (res == "OK") {
                                    bootbox.alert('삭제했습니다.', function () {
                                        window.close();
                                        if (opener) {
                                            if (opener._zw.mu.search) opener._zw.mu.search(opener._zw.V.lv.page);
                                            else opener.location.reload();
                                        }
                                    });
                                } else bootbox.alert(res);
                            }
                        });
                    }
                });
            }
        }
    }

    _zw.mu.registerMsg = function () {
        var fd = $('#__FormView input[data-for="SelectedFolder"]').val();
        if (fd == '' || fd == '0') {
            bootbox.alert("지식분류를 선택하세요!"); return;
        }

        var $subject = $('#txtSubject');
        if (!$.trim($subject.val())) {
            bootbox.alert("제목을 입력하세요.", function () { $subject.focus(); }); return;
        }

        if (DEXT5.isEmpty()) {
            bootbox.alert("작성된 내용이 없습니다. 내용을 입력하세요.", function () { DEXT5.setFocusToEditor(); }); return;
        }

        _zw.V.mode = "";
        bootbox.confirm("등록 하시겠습니까?", function (rt) {
            if (rt) { DEXT5UPLOAD.Transfer(); }
        });
    }

    _zw.mu.previewMsg = function () {

    }

    _zw.mu.saveMsg = function () {
        var $subject = $('#txtSubject');
        if (!$.trim($subject.val())) {
            bootbox.alert("제목을 입력하세요.", function () { $subject.focus(); }); return;
        }

        //var fd = $('#__FormView input[data-for="SelectedFolder"]').val();
        var msg = '';
        //if (fd != '' && fd != '0') msg = '지식분류는 저장되지 않습니다. ';

        _zw.V.mode = "save";
        bootbox.confirm(msg + "저장 하시겠습니까?", function (rt) {
            if (rt) { DEXT5UPLOAD.Transfer(); }
        });
    }

    _zw.mu.cancelMsg = function () {
        //history.back(); //<- 읽기 창에서 새글 갔다 오면 appid=0으로 돼 이후 수정, 답글 클릭시 오류 발생!!
        if (_zw.V.mode != 'reply' && _zw.V.current.page.toLowerCase() == '/docs/kms/write') {
            if (_zw.V.wnd == 'popup') window.close();
            else _zw.mu.goList();
        } else {
            if (history.length > 1) history.back();
            else window.close();
        }
    }

    _zw.mu.goList = function () {
        var postData = _zw.fn.getLvQuery();
        window.location.href = '/Docs/Kms/List?qi=' + encodeURIComponent(_zw.base64.encode(postData));
    }

    _zw.fn.orgSelect = function (p) {
        var vList = _zw.V.app.coreglist;
        p.find('.zf-org .zf-org-select input:checkbox[data-for]').each(function () {
            var jUser = JSON.parse($(this).attr('data-attr')); //console.log(jUser);
            var v = vList.find(function (item) { return item.acttype == '1' && item.actorid == jUser['id']; });
            if (!v && jUser['id'] != _zw.V.current.urid) {//없으면
                var j = {};
                j['acttype'] = '1'; //0:작성자, 1:공동등록자, 2:편집(수정)자-편집이벤트등록
                j['actorid'] = jUser['id']; j['actor'] = $(this).next().text(); j['actorcn'] = jUser['logonid']; j['actorgrade'] = jUser['grade'];
                j['actordept'] = jUser['grdn']; j['actordpid'] = jUser['grid']; j['actordpcd'] = jUser['gralias']; j['rsvd1'] = '';

                var s = $('.zf-coreg-template').html();
                s = s.replace("{$id}", jUser['id']);
                s = s.replace("{$coreg}", jUser['grdn'] + ' [' + jUser['grade'] + '] ' + $(this).next().text());
                $('ul[data-for="CoRegList"]').append(s);
                vList.push(j);
            }
        });
        p.find("button[data-dismiss='modal']").click(); 

        $('ul[data-for="CoRegList"] li[data-val] .btn').click(function () {
            var c = $(this).parent(), v = c.attr('data-val').split('_');
            var idx = vList.findIndex(function (item) { return item.acttype == v[1] && item.actorid == v[2]; });
            if (idx > -1) vList.splice(idx, 1);
            c.remove();

            //console.log(_zw.V.app.coreglist);
        });
    }

    _zw.fn.setCoRegState = function () {
        if (_zw.V.app.state == '7' && _zw.V.app.creurid != _zw.V.current.urid) {
            $.ajax({
                type: "POST",
                url: "/Docs/Kms/CoRegState",
                data: '{xf:"' + _zw.V.xfalias + '",fdid:"' + _zw.V.fdid + '",mi:"' + _zw.V.appid + '",urid:"' + _zw.V.current.urid + '"}',
                success: function (res) {
                    if (res == "OK") opener.location.reload();
                    else console.log(res);
                },
                beforeSend: function () { } //로딩 X
            });
        }
    }

    _zw.fn.loadList = function () {
        var postData = _zw.fn.getLvQuery(); //console.log(postData);
        var url = (_zw.V.mode == 'temp' || _zw.V.mode == 'complete' || _zw.V.mode == 'approval' ? '/Docs/Kms/MyList' : '/Docs/Kms/List')
                + '?qi=' + encodeURIComponent(_zw.base64.encode(postData)); //encodeURIComponent(postData);

        $.ajax({
            type: "POST",
            url: url,
            //data: _zw.fn.getLvQuery(),
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    history.pushState(null, null, url);

                    window.document.title = _zw.V.ttl;
                    $('.z-ttl span').html(_zw.V.ttl);

                    var v = res.substr(2).split(_zw.V.lv.boundary);
                    $('#__ListView').html(v[0]);
                    $('#__ListCount').html(v[1]);
                    $('#__ListMenu').html(v[2]);
                    $('#__ListViewPage').html(v[3]);

                    $('.pagination li a.page-link').click(function () {
                        _zw.mu.search($(this).attr('data-for'));
                    });

                    $('.z-lv-cnt select').change(function () {
                        _zw.fn.setLvCnt($(this).val());
                    });

                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.getLvQuery = function () {
        var j = {};
        j["M"] = _zw.V.mode;
        j["ct"] = _zw.V.ct;
        j["ctalias"] = _zw.V.ctalias;
        j["ot"] = _zw.V.ot;
        j["alias"] = _zw.V.alias;
        j["xfalias"] = _zw.V.xfalias;
        j["fdid"] = _zw.V.fdid;
        j["acl"] = _zw.V.current.acl;
        j["opnode"] = _zw.V.opnode;
        j["ft"] = _zw.V.ft;
        j["ttl"] = _zw.V.ttl;

        j["tgt"] = _zw.V.lv.tgt;
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

    _zw.fn.initLv = function (tgt) {
        $('.z-lv-date .start-date').val('');
        $('.z-lv-date .end-date').val('');
        $('.z-lv-search select').val('');
        $('.z-lv-search .search-text').val('');

        $('.z-lv-hdr a[data-val]').each(function () {
            $(this).find('i').removeClass();
        });

        var sCnt = _zw.ut.getCookie('docLvCount') || $('.z-lv-page select').val();

        _zw.V.lv.tgt = tgt;
        _zw.V.lv.page = '1';
        _zw.V.lv.count = sCnt == undefined || sCnt == '' ? '20' : sCnt;
        _zw.V.lv.sort = 'CreateDate';
        _zw.V.lv.sortdir = 'DESC';
        _zw.V.lv.search = '';
        _zw.V.lv.searchtext = '';
        _zw.V.lv.start = '';
        _zw.V.lv.end = '';
        _zw.V.lv.basesort = '';
    }

    _zw.fn.sendForm = function () {
        var fileList = DEXT5UPLOAD.GetNewUploadListForText(); //DEXT5UPLOAD.GetNewUploadListForJson();
        var imgList = DEXT5.getImagesEx(); //DEXT5.getImages();

        var jPost = _zw.V.app;
        jPost["ct"] = _zw.V.ct;
        jPost["xfalias"] = $('#__FormView input[data-for="SelectedXFAlias"]').val();
        jPost["fdid"] = $('#__FormView input[data-for="SelectedFolder"]').val();
        jPost["appid"] = _zw.V.appid;

        jPost["attachlist"] = []; //초기화
        if (fileList) {
            var vFile = fileList.split(_zw.T.uploader.df);
            for (var i = 0; i < vFile.length; i++) {
                var vInfo = vFile[i].split(_zw.T.uploader.da);
                var v = {};
                v["attachid"] = 0;
                v["seq"] = i + 1;
                v["isfile"] = "Y";
                v["filename"] = vInfo[0];
                v["savedname"] = vInfo[1];
                v["size"] = vInfo[2];
                v["ext"] = vInfo[7];
                v["filepath"] = vInfo[4].substr(1).replace(/\//gi, '\\');
                v["storagefolder"] = "";

                jPost["attachlist"].push(v);
            }

            jPost["attachcount"] = fileList.length;
            jPost["attachsize"] = DEXT5UPLOAD.GetTotalFileSize();
        }
        else {
            jPost["attachcount"] = 0;
        }

        jPost["imglist"] = []; //초기화
        if (imgList) {
            var rgx = (location.origin + $('#upload_path').val()).toLowerCase();
            var vImg = imgList.split(_zw.T.uploader.da);
            for (var i = 0; i < vImg.length; i++) {
                var vInfo = vImg[i].split(_zw.T.uploader.df);
                if (vInfo[0].toLowerCase().indexOf(rgx) != -1) {
                    var v = {};
                    v["imgname"] = vInfo[1];
                    v["imgpath"] = vInfo[0];
                    v["origin"] = location.origin;
                    jPost["imglist"].push(v);
                }
            }
        }
        //console.log(jPost["coreglist"]);
        //console.log(jPost["imglist"]);
        //return;

        jPost["coregcount"] = jPost["coreglist"].length;

        jPost["msg"] = "";
        jPost["inherited"] = "Y";
        jPost["priority"] = "N";
        jPost["state"] = ""; //0, 1, 7
        jPost["topline"] = "N";
        jPost["replymail"] = "N";

        jPost["creur"] = _zw.V.current.user;
        jPost["creurid"] = _zw.V.current.urid;
        jPost["creurcn"] = _zw.V.current.urcn;
        jPost["credept"] = _zw.V.current.dept;
        jPost["credpid"] = _zw.V.current.deptid;
        jPost["credpcd"] = _zw.V.current.deptcd;

        jPost["subject"] = $('#txtSubject').val();
        jPost["body"] = DEXT5.getBodyValue();
        jPost["bodytext"] = "";

        jPost["M"] = _zw.V.mode;

        //console.log(jPost); return

        $.ajax({
            type: "POST",
            url: "/Docs/Kms/Send",
            data: JSON.stringify(jPost),
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    //console.log(JSON.parse(res.substr(2)));
                    bootbox.alert(res.substr(2), function () {
                        if (_zw.V.wnd == 'popup') {
                            window.close(); opener.location.reload();
                        } else {
                            if (_zw.V.mode == 'save') window.location.href = 'Docs/Kms/TempSave?qi=' + _zw.base64.encode(_zw.fn.getLvQuery());
                            else _zw.mu.goList();
                        }
                    });

                } else bootbox.alert(res);
            }
        });
    }
});

function dext_editor_loaded_event() {
    // 에디터가 로드된 후 사용자의 css를 에디터에 적용시킵니다.
    DEXT5.setBodyValue(_zw.V.app.body, _zw.T.editor.id);
}

function DEXT5UPLOAD_AfterAddItemEndTime() {
    console.log('transfer')
    // 파일 추가후 처리할 내용
    //DEXT5UPLOAD.TransferEx();
}

function DEXT5UPLOAD_OnTransfer_Start() {
    // 업로드 시작 후 처리할 내용
    console.log('start => ' + (new Date()))
    return true;
}

function DEXT5UPLOAD_OnTransfer_Complete() {
    console.log('complete => ' + (new Date()) + " : " + DEXT5UPLOAD.GetTotalFileSize())

    _zw.fn.sendForm();
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
                var vInfo = vFile[i].split(_zw.T.uploader.da); console.log(vInfo)
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
    bootbox.alert("Error Code : " + code + "\nError Message : " + message);
}