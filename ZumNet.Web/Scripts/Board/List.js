//게시판 리스트뷰

$(function () {

    $('#ckbUsePopup').click(function () {
        if ($(this).prop('checked')) {
            $('#txtPopDate').prop('disabled', false); _zw.fn.input($('#txtPopDate')[0]);
        } else {
            $('#txtPopDate').val('').prop('disabled', true);
        }
    });

    _zw.mu.writeMsg = function (xf, m) {
        var el, p, postData, tgtPage, stdPage;
        m = m || '';

        postData = _zw.fn.getAppQuery(_zw.V.fdid);
        window.location.href = '/Board/Write?qi=' + _zw.base64.encode(postData);
    }

    _zw.mu.editMsg = function () {

    }

    _zw.mu.replyMsg = function () {

    }

    _zw.mu.deleteMsg = function () {

    }

    _zw.mu.registerMsg = function () {
        //var fp = $('#__FormView input[data-for="SelectedFolderPath"]').val();
        var fd = $('#__FormView input[data-for="SelectedFolder"]').val();
        var fxf = $('#__FormView input[data-for="SelectedXFAlias"]').val();
        if (fd == '' || fxf == '') {
            bootbox.alert("게시분류를 선택하세요!"); return;
        }

        var $subject = $('#txtSubject');
        if (!$.trim($subject.val())) {
            bootbox.alert("제목을 입력하세요.", function () { $subject.focus(); }); return;
        }

        if ($('#ckbUsePopup').prop('checked') && $.trim($('#txtPopDate').val()) == '') {
            bootbox.alert("팝업일을 입력하세요.", function () { $('#txtPopDate').focus(); }); return;
        }

        if (DEXT5.isEmpty()) {
            bootbox.alert("작성된 내용이 없습니다. 내용을 입력하세요.", function () { DEXT5.setFocusToEditor(); }); return;
        }

        _zw.V.mode = "";
        DEXT5UPLOAD.Transfer();
    }

    _zw.mu.previewMsg = function () {

    }

    _zw.mu.saveMsg = function () {
        var $subject = $('#txtSubject');
        if (!$.trim($subject.val())) {
            bootbox.alert("제목을 입력하세요.", function () { $subject.focus(); }); return;
        }

        _zw.V.mode = "save";
        DEXT5UPLOAD.Transfer();
    }

    _zw.mu.cancelMsg = function () {
        history.back();
    }

    _zw.mu.goList = function () {
        var postData = _zw.fn.getLvQuery();
        window.location.href = '/Board/List?qi=' + _zw.base64.encode(postData);
    }

    _zw.fn.loadList = function () {

        //var sJson = '{ct:"' + _zw.V.ct + '",ctalias:"' + _zw.V.ctalias + '",ot:"' + _zw.V.ot + '",xfalias:"' + _zw.V.xfalias + '",permission:"' + _zw.V.current.acl + '",tgt:"' + _zw.V.lv.tgt
        //    + '",page:' + _zw.V.lv.page + ',count:' + _zw.V.lv.count + ',sort:"' + _zw.V.lv.sort + '",sortdir:"' + _zw.V.lv.sortdir + '",search:"' + _zw.V.lv.search
        //    + '",searchtext:"' + _zw.V.lv.searchtext + '",start:"' + _zw.V.lv.start + '",end:"' + _zw.V.lv.end + '",boundary:"' + _zw.V.lv.boundary + '"}';

        //var j = JSON.parse(sJson);
        
        var postData = _zw.fn.getLvQuery(); //console.log(postData);
        var url = '/Board/List?qi=' + _zw.base64.encode(postData); //encodeURIComponent(postData);
        //if (_zw.V.alias == "ea.form.report") url = '/Report?qi=' + encodeURIComponent(postData);
        //else url = '/Board/List?qi=' + encodeURIComponent(postData); //_zw.base64.encode(postData);

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
                    $('#__ListPage').html(v[3]);

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
        //j["ttl"] = _zw.V.ttl;
        
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

        var sCnt = _zw.ut.getCookie('bbsLvCount') || $('.z-lv-page select').val();
        
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
        //console.log(fileList)

        var imgList = DEXT5.getImages();
        //console.log(imgList)

        var jPost = _zw.V.app;
        jPost["ct"] = _zw.V.ct;
        jPost["xfalias"] = $('#__FormView input[data-for="SelectedXFAlias"]').val();
        jPost["fdid"] = $('#__FormView input[data-for="SelectedFolder"]').val();
        jPost["appid"] = _zw.V.appid;

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
                v["filepath"] = vInfo[4];
                v["storagefolder"] = "";

                jPost["attachlist"].push(v);
            }
            jPost["attachcount"] = fileList.length;
            jPost["attachsize"] = DEXT5UPLOAD.GetTotalFileSize();
        }
        else {
            jPost["attachcount"] = 0;
        }
        jPost["msg"] = "";
        jPost["inherited"] = "Y";
        jPost["priority"] = (!$('#ckbPriority').prop("disabled") && $('#ckbPriority').prop('checked')) ? "Y" : "N";
        jPost["topline"] = (!$('#ckbTopLine').prop("disabled") && $('#ckbTopLine').prop('checked')) ? "Y" : "N";
        jPost["ispopup"] = (!$('#ckbUsePopup').prop("disabled") && $('#ckbUsePopup').prop('checked')) ? "Y" : "N";
        jPost["popdate"] = (!$('#ckbUsePopup').prop("disabled") && $('#ckbUsePopup').prop('checked') && $.trim($('#txtPopDate').val()) != '') ? $('#txtPopDate').val() : "";
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
        jPost["pwd"] = ""; //익명

        jPost["M"] = _zw.V.mode;

        $.ajax({
            type: "POST",
            url: "/Board/Send",
            data: JSON.stringify(jPost),
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    alert("OK");

                } else bootbox.alert(res);
            }
        });
    }
});

function dext_editor_loaded_event() {
    // 에디터가 로드된 후 사용자의 css를 에디터에 적용시킵니다.

}

function DEXT5UPLOAD_AfterAddItemEndTime() {
    console.log('transfer')
    // 파일 추가후 처리할 내용
    //DEXT5UPLOAD.TransferEx(G_UploadID);
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

function DEXT5UPLOAD_OnError(uploadID, code, message, uploadedFileListObj) {
    //에러 발생 후 경고창 띄어줌
    alert("Error Code : " + code + "\nError Message : " + message);
}