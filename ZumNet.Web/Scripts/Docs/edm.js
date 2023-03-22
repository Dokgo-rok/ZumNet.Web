//문서관리 리스트뷰

$(function () {
    _zw.mu.writeMsg = function (xf) {
        _zw.V.mode = '';
        _zw.V.wnd = 'popup';
        _zw.V.appid = 0;
        _zw.V.xfalias = xf;

        var postData = _zw.fn.getAppQuery(_zw.V.fdid); //console.log(postData)
        var url = '/Docs/Edm/Write?qi=' + encodeURIComponent(_zw.base64.encode(postData));
        _zw.ut.openWnd(url, "newform_doc", 640, 600, "resize");
    }

    _zw.mu.editMsg = function (xf, m) { //alert(_zw.V.appid)
        bootbox.alert('준비중!'); return;
        m = m || '';
        _zw.V.mode = '';
        _zw.V.wnd = 'popup';
        _zw.V.xfalias = xf;

        if (m == 'temp') {
            var el = event.target, p = $(el).parent().parent();
            _zw.V.appid = p.attr('appid'); _zw.V.fdid = p.attr('fdid') != undefined ? p.attr('fdid') : _zw.V.fdid;
            _zw.V.lv.sort = 'CreateDate'; _zw.V.lv.sortdir = 'DESC';
        }
        
        var postData = _zw.fn.getAppQuery(_zw.V.fdid); console.log(postData)
        var url = '/Docs/Edm/Edit?qi=' + encodeURIComponent(_zw.base64.encode(postData));
        window.location.href = url;
    }

    _zw.mu.deleteMsg = function () {
        var el = event.target ? event.target : event.srcElement;
        bootbox.alert('준비중!')
    }

    _zw.mu.registerMsg = function () {
        if (DEXT5UPLOAD.GetTotalFileSize() == 0) {
            bootbox.alert("파일을 선택하세요!"); return;
        }

        var fd = $('#__FormView input[data-for="SelectedFolder"]').val();
        if (fd == '' || fd == '0') {
            bootbox.alert("문서분류를 선택하세요!"); return;
        }

        var $subject = $('#txtSubject');
        if (!$.trim($subject.val())) {
            bootbox.alert("제목을 입력하세요.", function () { $subject.focus(); }); return;
        }

        _zw.V.mode = "";
        bootbox.confirm("등록 하시겠습니까?", function (rt) {
            if (rt) { DEXT5UPLOAD.Transfer(); }
        });
    }

    _zw.mu.cancelMsg = function () {
        //history.back(); //<- 읽기 창에서 새글 갔다 오면 appid=0으로 돼 이후 수정, 답글 클릭시 오류 발생!!
        if (_zw.V.mode != 'reply' && _zw.V.current.page.toLowerCase() == '/docs/edm/write') {
            if (_zw.V.wnd == 'popup') window.close();
            else _zw.mu.goList();
        } else {
            if (history.length > 1) history.back();
            else window.close();
        }
    }

    _zw.mu.checkOut = function (fi) {
        var el = _zw.ut.eventBtn();
        var p = $('#popBlank'); p.html($('.zf-checkout-template').html()); _zw.ut.picker('date');
        p.on('hidden.bs.modal', function () { p.html(''); });
        p.modal();

        p.find('.modal-footer .btn[data-zm-menu="confirm"]').click(function () {
            var path = el.parent().parent().find('> div a').prop('href'); //window.open(path, 'ifrView');
            var f = _zw.V.app.attachlist.find(function (element) { if (element.attachid == fi) return true; });

            var d = p.find('.modal-body :text.datepicker');
            if (d.val() == '') {
                bootbox.alert('반납예정일을 기입하십시오!', function () { d.focus(); })
            } else {
                var dif = _zw.ut.diff('day', d.val(), _zw.V.current.date);
                if (dif && dif < 0) { bootbox.alert('반납예정일은 현재일 이후로 기입하십시오!', function () { d.val(''); d.focus(); }); return false; }

                var postData = {};
                postData['mi'] = _zw.V.appid;
                postData['fi'] = fi;
                postData['urid'] = _zw.V.current.urid;
                postData['exdt'] = d.val();
                postData['desc'] = '';
                postData['path'] = (f['filepath'].indexOf('\\') == 0 ? '' : '\\') + f['filepath'] + '\\' + f['savedname'];
                //console.log(postData['path']); return

                $.ajax({
                    type: "POST",
                    url: "/Docs/Edm/CheckOut",
                    data: JSON.stringify(postData),
                    success: function (res) {
                        if (res == "OK") {
                            window.open(path, 'ifrView'); 
                            if (opener && opener._zw.mu.refresh) opener._zw.mu.refresh();
                            window.location.reload();
                        } else {
                            if (res.substr(0, 2) == 'NE') bootbox.alert(res.substr(2));
                            else bootbox.alert(res);
                        } 
                    },
                    beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
                });
            }
        });
    }

    _zw.mu.checkIn = function (fi) {
        var p = $('#popBlank'); p.html($('.zf-checkin-template').html());
        p.on('hidden.bs.modal', function () { p.html(''); });

        var f = _zw.V.app.attachlist.find(function (element) { if (element.attachid == fi) return true; });
        p.find('.zf-upload [data-help="file"] div[data-for="name"]').html(f['filename']);
        _zw.fu.bind();

        p.find(".modal-dialog").css("max-width", "25rem");
        p.modal();

        p.find('.modal-body :radio[name="rdoState"]').change(function () {
            if ($(this).prop('checked') && $(this).val() == '1') {
                p.find('.modal-body :checkbox[name="ckbNewVer"]').prop('checked', true);
                //p.find('input[type="file"]').prop('disabled', false);
            } else {
                p.find('.modal-body :checkbox[name="ckbNewVer"]').prop('checked', false);
                //p.find('input[type="file"]').prop('disabled', true);
            }
        });

        p.find('.modal-footer .btn[data-zm-menu="confirm"]').click(function () {
            var rdoState = p.find('.modal-body :radio[name="rdoState"]:checked').val();
            if (rdoState == '1' && _zw.fu.fileList.length == 0) {
                bootbox.alert('반입 파일을 선택하십시오!'); return false;
            }

            var postData = {};
            postData['mi'] = _zw.V.appid;
            postData['xf'] = _zw.V.xfalias;
            postData['fi'] = fi
            postData['parentid'] = f['parentid'];
            postData['urid'] = _zw.V.current.urid;
            postData['deptid'] = _zw.V.current.deptid;
            postData['doclevel'] = f['doclevel'];
            postData['keepyear'] = f['keepyear'];

            if (rdoState == '1') {
                postData['ischange'] = 'Y';
                postData["attachid"] = _zw.fu.fileList[0]["attachid"];
                postData["atttype"] = _zw.fu.fileList[0]["atttype"];
                postData["seq"] = _zw.fu.fileList[0]["seq"];
                postData["isfile"] = _zw.fu.fileList[0]["isfile"];
                postData["filename"] = _zw.fu.fileList[0]["filename"];
                postData["savedname"] = _zw.fu.fileList[0]["savedname"];
                postData["ext"] = _zw.fu.fileList[0]["ext"];
                postData["size"] = _zw.fu.fileList[0]["size"];
                postData["filepath"] = _zw.fu.fileList[0]["filepath"];
                postData["storagefolder"] = _zw.fu.fileList[0]["storagefolder"];
                postData["autodel"] = 'N';
            } else {
                postData['ischange'] = 'N';
                postData["attachid"] = '';
                postData["atttype"] = '';
                postData["seq"] = '';
                postData["isfile"] = '';
                postData["filename"] = '';
                postData["savedname"] = '';
                postData["ext"] = '';
                postData["size"] = '';
                postData["filepath"] = '';
                postData["storagefolder"] = '';
                postData["autodel"] = '';
            }
            //console.log(postData); return

            $.ajax({
                type: "POST",
                url: "/Docs/Edm/CheckIn",
                data: JSON.stringify(postData),
                success: function (res) {
                    if (res == "OK") {
                        if (opener && opener._zw.mu.refresh) opener._zw.mu.refresh();
                        window.close();
                    } else bootbox.alert(res);
                },
                beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
            });
        });
    }

    _zw.mu.showFileVer = function (fi) {
        bootbox.alert('준비중!')
    }

    _zw.mu.goList = function () {
        var postData = _zw.fn.getLvQuery();
        window.location.href = '/Docs/Edm/List?qi=' + _zw.base64.encode(postData);
    }

    _zw.fn.loadList = function () {

        //var sJson = '{ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + _zw.V.ot + '",xfalias:"' + _zw.V.xfalias + '",permission:"' + _zw.V.current.acl + '",tgt:"' + _zw.V.lv.tgt
        //    + '",page:' + _zw.V.lv.page + ',count:' + _zw.V.lv.count + ',sort:"' + _zw.V.lv.sort + '",sortdir:"' + _zw.V.lv.sortdir + '",search:"' + _zw.V.lv.search
        //    + '",searchtext:"' + _zw.V.lv.searchtext + '",start:"' + _zw.V.lv.start + '",end:"' + _zw.V.lv.end + '",boundary:"' + _zw.V.lv.boundary + '"}';

        //var j = JSON.parse(sJson);
        //console.log(j.ctalias);

        var postData = _zw.fn.getLvQuery(); console.log(postData);
        var url = '/Docs/Edm/List?qi=' + encodeURIComponent(_zw.base64.encode(postData)); //encodeURIComponent(postData);
        //if (_zw.V.alias == "ea.form.report") url = '/Report?qi=' + encodeURIComponent(postData);
        //else url = '/Docs/Edm/List?qi=' + encodeURIComponent(postData); //_zw.base64.encode(postData);

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
        _zw.V.lv.sort = 'SeqID';
        _zw.V.lv.sortdir = 'DESC';
        _zw.V.lv.search = '';
        _zw.V.lv.searchtext = '';
        _zw.V.lv.start = '';
        _zw.V.lv.end = '';
        _zw.V.lv.basesort = '';
    }

    _zw.fn.sendForm = function () {
        var fileList = DEXT5UPLOAD.GetNewUploadListForText(); //DEXT5UPLOAD.GetNewUploadListForJson();

        var jPost = _zw.V.app;
        jPost["ct"] = _zw.V.ct;
        jPost["xfalias"] = $('#__FormView input[data-for="SelectedXFAlias"]').val();
        jPost["fdid"] = $('#__FormView input[data-for="SelectedFolder"]').val();
        jPost["appid"] = _zw.V.appid;

        jPost["attachlist"] = []; //초기화
        if (fileList) {
            var vFile = fileList.split(_zw.T.uploader.df);
            for (var i = 0; i < vFile.length; i++) {
                var vInfo = vFile[i].split(_zw.T.uploader.da); //console.log(vInfo)
                var v = {};
                v["attachid"] = 0;
                v["atttype"] = "O";
                v["seq"] = i + 1;
                v["isfile"] = "Y";
                v["filename"] = vInfo[0];
                v["savedname"] = vInfo[1];
                v["size"] = vInfo[2];
                v["ext"] = vInfo[7];
                v["filepath"] = vInfo[4].split(':')[1]; //vInfo[4].substr(1).replace(/\//gi, '\\');
                v["storagefolder"] = "";

                v["autodeleted"] = "N";

                jPost["attachlist"].push(v);
            }

            jPost["attachcount"] = vFile.length > 2 ? 2 : vFile.length;
            jPost["attachsize"] = DEXT5UPLOAD.GetTotalFileSize();
        }
        else {
            jPost["attachcount"] = 0;
        }
        //alert(vFile.length); return false;
        //console.log(jPost["imglist"]);
        //return;

        jPost["inherited"] = $('#_doc_acl :checkbox[data-for="acl"]').prop('checked') ? 'N' : 'Y';
        jPost["hasacl"] = 'N';

        jPost["doclevel"] = $('#ddlDocLevel').val();
        jPost["keepyear"] = $('#ddlKeepYear').val();
        jPost["doctype"] = 1;

        jPost["creur"] = _zw.V.current.user;
        jPost["creurid"] = _zw.V.current.urid;
        jPost["creurcn"] = _zw.V.current.urcn;
        jPost["credept"] = _zw.V.current.dept;
        jPost["credpid"] = _zw.V.current.deptid;
        jPost["credpcd"] = _zw.V.current.deptcd;

        jPost["subject"] = $('#txtSubject').val();
        jPost["body"] = $('#txtBody').val();
        jPost["rsvd1"] = $('#txtKeyword1').val();
        jPost["rsvd2"] = $('#txtKeyword2').val();

        jPost["M"] = _zw.V.mode;

        //console.log(jPost); return

        $.ajax({
            type: "POST",
            url: "/Docs/Edm/Send",
            data: JSON.stringify(jPost),
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    bootbox.alert(res.substr(2), function () {
                        window.close();
                        if (opener.__ListView && opener._zw.mu.goList) opener._zw.mu.goList();
                        else opener.location.reload();
                    });

                } else bootbox.alert(res);
            },
            beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
        });
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
    console.log('transfer')
    // 파일 추가후 처리할 내용
    //DEXT5UPLOAD.TransferEx();
    var v = DEXT5UPLOAD.GetNewUploadListForJson();
    if (v && (_zw.V.mode == '' || _zw.V.appid == '' || _zw.V.appid == '0')) {
        var fm = v.originalName[0];
        var pos = fm.lastIndexOf('.'); //alert(fm.substr(0, pos+1))
        $('#txtSubject').val(fm.substr(0, pos));
    }
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
    bootbox.alert("Error Code : " + code + "\nError Message : " + message);
}