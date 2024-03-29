//ECN업무처리계획서 메인, 리스트뷰
$(function () {
    _zw.fn.input($('#__FormView .m'));

    if ($('#__FormView [name="APVRSTATUS"]').val() != '7') {
        var bWrite = true;
        if ($('input[name="APVRID"]').val() == _zw.V.current.urid) {
            $('[name="SubWriteDate"]').each(function () {
                if ($(this).val() == 'N') {
                    bWrite = false; return false;
                }
            });
        }
        if (bWrite) $(':checkbox[name="ckbSTATUS"]').prop('disabled', false);
    }

    if (_zw.V.mode == "read") {
        $.ajax({
            type: "POST",
            url: "/Form/ViewCount",
            data: '{xf:"' + _zw.V.xfalias + '",mi:"' + _zw.V.appid + '",actor:"' + _zw.V.current["urid"] + '",fdid:"0",wi:"",wn:"0"}',
            success: function (res) {
                if (res != "OK") bootbox.alert(res);
                //else _zw.fn.reloadList();
            },
            beforeSend: function () {//pace.js 충돌
            }
        });
    }

    //_zw.fu.bind();

    $('.zf-menu .btn[data-zf-menu]').click(function () {
        var mn = $(this).attr('data-zf-menu');
        switch (mn) {
            case "register":
                //console.log($('#__subtable1[name]').length)
                if (!_zw.form.validation()) return false;
                _zw.fn.sendForm();
                break;
            default:
                break;
        }
        $(this).tooltip('hide');
    });

    _zw.fn.sendForm = function () {
        var jSend = {};
        jSend["M"] = 'editregisterformnotea';

        _zw.body.common(jSend);
        _zw.body.main(jSend["form"]);
        _zw.body.file(jSend);
        //console.log(jSend); return

        var szMsg = $(':checkbox[name="ckbSTATUS"]').prop('checked') ? '승인' : '저장';
        bootbox.confirm(szMsg + ' 하시겠습니까?', function (rt) {
            if (rt) {
                $.ajax({
                    type: "POST",
                    url: "/EA/Process",
                    data: JSON.stringify(jSend),
                    success: function (res) {
                        if (res == "OK") {
                            _zw.fn.reloadList(); window.close();
                        } else bootbox.alert(res);
                    },
                    beforeSend: function () { _zw.ut.ajaxLoader(true, 'Processing...'); }
                });
            }
        });
    }

    _zw.fn.onblur = function (e, v) {
    }

    _zw.fn.reloadList = function (opt) {
        try {
            if (opener != null) {
                if (opener._zw.fn.reloadList) {
                    opt = opt || 'ecnplan'; opener._zw.fn.reloadList(opt);
                } else if (opener._zw.fn.goSearch) {
                    opener._zw.fn.goSearch();
                } else opener.location.reload();
            }
        } catch (e) {
            //opener.location.reload();
        };
    }

    _zw.form = {
        "checkYN": function (ckb, el, fld) {
            $(':checkbox[name="' + ckb + '"]').each(function (idx, e) {
                if (el != e) { if (e.checked) e.checked = false; }
            });
            if (fld) {
                $('input[name="' + fld + '"]').val(fld != '' && el.checked ? el.value : '');
            }
            if (_zw.formEx.checkEvent) _zw.formEx.checkEvent(ckb, el, fld);
        },
        "validation": function () {
            var el, rt = true;
            if ($('input[name="APVRID"]').val() == _zw.V.current.urid) {
                el = $('textarea[name="NOTE"]');
                if ($.trim(el.val()) == '') { bootbox.alert('의견을 입력하십시오!', function () { try { el.focus(); } catch { } }); return false; }
            } else {
                $('input[name="PARTID"]').each(function (idx, e) {
                    if ($(this).val() == _zw.V.current.urid && $(this).next().next().val() == _zw.V.current.deptid) {
                        el = $(this).parent().parent().find('textarea[name="BIZPLAN"]');
                        if ($.trim(el.val()) == '') { bootbox.alert('업무계획을 입력하십시오!', function () { try { el.focus(); } catch { } }); rt = false; return false; }
                    }
                });
            }
            return rt;
        }
    }

    _zw.formEx = {
        "checkEvent": function (ckb, el, fld) {
        },
        "change": function () {
        }
    }

    _zw.body = {
        "common": function (j) {
            j["web"] = _zw.V["web"];
            j["root"] = _zw.V["root"];
            j["companycode"] = _zw.V["companycode"];
            j["domain"] = _zw.V["domain"];
            j["dnid"] = _zw.V["dnid"];
            j["oid"] = _zw.V["oid"];
            j["relid"] = _zw.V["relid"];
            j["appid"] = _zw.V["appid"];
            j["formid"] = _zw.V["formid"];
            j["xfalias"] = _zw.V["xfalias"];
            j["wnid"] = _zw.V["wnid"];
            j["boundary"] = _zw.V["boundary"];

            j["current"] = {};
            j["current"]["urid"] = _zw.V.current["urid"];
            j["current"]["urcn"] = _zw.V.current["urcn"];
            j["current"]["user"] = _zw.V.current["user"];
            j["current"]["deptid"] = _zw.V.current["deptid"];
            j["current"]["deptcd"] = _zw.V.current["deptcd"];
            j["current"]["dept"] = _zw.V.current["dept"];
            j["current"]["belong"] = _zw.V.current["belong"];
            j["current"]["indate"] = _zw.V.current["indate"];

            j["attachlist"] = [];
            j["form"] = {};
        },
        "main": function (f, v) {
            var p = {}, s = {}, v = []

            if ($('input[name="APVRID"]').val() == _zw.V.current.urid) {
                p["NOTE"] = $('textarea[name="NOTE"]').val();
                if ($('#WriteDate').val() == 'N') p["WTDT"] = '';
                p["MFDT"] = '';

                if ($(':checkbox[name="ckbSTATUS"]').prop('checked')) {
                    p["APVRSTATUS"] = '7';
                    p["CODT"] = '';
                }
            } else {
                $('input[name="PARTID"]').each(function (idx, e) {
                    if ($(this).val() == _zw.V.current.urid) {
                        var sub = {};
                        var row = $(this).parent().parent(); //console.log(row.html())
                        sub["SEQ"] = row.find('td [name="SEQ"]').val()
                        if (row.find('td [name="SubWriteDate"]').val() == 'N') p["WTDT"] = '';
                        sub["MFDT"] = '';
                        sub["BIZPLAN"] = row.find('textarea[name="BIZPLAN"]').val();

                        v.push(sub);
                    }
                });
                s['subtable1'] = v;
            }
            f["maintable"] = p;
            f["subtables"] = s;
        },
        "file": function (j) {
            var fileList = DEXT5UPLOAD.GetAllFileListForJson(); //console.log(fileList)
            var fi = j["attachlist"];

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
            j["attachcount"] = DEXT5UPLOAD.GetTotalFileCount();
            j["attachsize"] = DEXT5UPLOAD.GetTotalFileSize();

            if (_zw.fu.fileList && _zw.fu.fileList.length > 0) {
                for (var x in _zw.fu.fileList) {
                    fi.push(_zw.fu.fileList[x]);
                }
            }
        }
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
    var jsonNew = DEXT5UPLOAD.GetNewUploadListForJson();
    for (var i = 0; i < jsonNew.originalName.length; i++) {
        DEXT5UPLOAD.SetUploadedFile(jsonNew.order[i] - 1, jsonNew.order[i] - 1, jsonNew.originalName[i], jsonNew.uploadPath[i].split(':')[1], jsonNew.size[i], '', _zw.T.uploader.id);
    }
}

function DEXT5UPLOAD_CustomAction(uploadID, cmd) {
    if (cmd == 'custom_remove') {
        // 파일 삭제 전 처리할 내용
        var fileList = DEXT5UPLOAD.GetSelectedAllFileListForText();
        var newFile = fileList.newFile, webFile = fileList.webFile;
        var sId = '';

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