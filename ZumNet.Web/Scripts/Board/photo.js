//사진게시판 리스트뷰

$(function () {
    if ($('#__DextUpload').length > 0) {
        DEXT5UPLOAD.config.Views = 'thumbs';
        //DEXT5UPLOAD.config.ImgPreView = '1';
        DEXT5UPLOAD.config.Height = '280px';
        DEXT5UPLOAD.config.MaxTotalFileSize = '100MB';

        DEXT5UPLOAD.config.ButtonBarEdit = 'add,open,remove,remove_all';

        DEXT5UPLOAD.config.UploadHolder = "__DextUpload";
        new Dext5Upload(_zw.T.uploader.id);
    }

    _zw.fn.bindCtrl = function () {
        $('.z-lv-menu input:checkbox').click(function () {
            var b = $(this).prop('checked');
            $('#__ListView .card-footer input:checkbox').each(function () {
                $(this).prop('checked', b);
            });
        });

        //initPhotoSwipeFromDOM('#photoswipe-view');
        $('#blueimp-gallery-view').on('click', '.img-thumbnail', function (e) {
            e.preventDefault();

            var links = $('#blueimp-gallery-view').find('.img-thumbnail');

            window.blueimpGallery(links, {
                container: '#blueimp-gallery-view-container',
                carousel: true,
                hidePageScrollbars: true,
                disableScroll: true,
                index: this
            });
        });

        $('.pagination li a.page-link').click(function () {
            _zw.mu.search($(this).attr('data-for'));
        });

        $('.z-lv-cnt select').change(function () {
            _zw.fn.setLvCnt($(this).val());
        });
    }

    _zw.fn.bindCtrl();

    _zw.mu.uploadView = function (ab, fd, alias) { //앨범, 폴더, 폴더구분
        //ab : 추후
        //fd : 없는 경우 추후
        var p = $('#popUploader'); p.find('.btn[data-zm-menu="send"]').off('click');

        p.find('.btn[data-zm-menu="send"]').click(function () {
            bootbox.confirm("등록 하시겠습니까?", function (rt) {
                if (rt) {
                    _zw.V.app = {};
                    _zw.V.app["ct"] = _zw.V.ct;
                    _zw.V.app["xfalias"] = _zw.V.xfalias;
                    _zw.V.app["fdid"] = fd;
                    _zw.V.app["msg"] = alias; // alias == 'mold' || alias == 'model' || alias == 'part' ? alias : '';
                    _zw.V.app["inherited"] = "Y";

                    _zw.V.app["creur"] = _zw.V.current.user;
                    _zw.V.app["creurid"] = _zw.V.current.urid;
                    _zw.V.app["credept"] = _zw.V.current.dept;
                    _zw.V.app["credpid"] = _zw.V.current.deptid;

                    DEXT5UPLOAD.Transfer();
                }
            });
        });
        p.modal();
    }

    _zw.fn.sendPhoto = function () { //신규저장
        var fileList = DEXT5UPLOAD.GetNewUploadListForText();
        var jPost = _zw.V.app;
        jPost["attachlist"] = []; //초기화
        if (fileList) {
            var vFile = fileList.split(_zw.T.uploader.df);
            for (var i = 0; i < vFile.length; i++) {
                var vInfo = vFile[i].split(_zw.T.uploader.da);
                var v = {};
                v["attachid"] = 0;
                v["atttype"] = "O";
                v["seq"] = 0;
                v["isfile"] = "N";
                v["filename"] = vInfo[0];
                v["savedname"] = vInfo[1];
                v["size"] = vInfo[2];
                v["ext"] = vInfo[7];
                v["filepath"] = vInfo[4].split(':')[1];
                v["storagefolder"] = "";

                var iPos = vInfo[0].lastIndexOf('.');

                v["subject"] = vInfo[0].substr(0, iPos);
                v["memo"] = '';

                jPost["attachlist"].push(v);
            }

            jPost["attachcount"] = fileList.length;
            jPost["attachsize"] = DEXT5UPLOAD.GetTotalFileSize();
        }
        else {
            jPost["attachcount"] = 0;
        }
        console.log(jPost);

        jPost["M"] = '';

        $.ajax({
            type: "POST",
            url: "/Board/PhotoSend",
            data: JSON.stringify(jPost),
            success: function (res) {
                if (res.substr(0, 2) == "OK") {
                    DEXT5UPLOAD.DeleteAllFile(_zw.T.uploader.id);
                    $('#popUploader').modal('hide');

                    _zw.mu.refresh();

                } else bootbox.alert(res);
            }
        });
    }

    _zw.fn.viewPhoto = function (mi, fd, xf) {
        if (mi == null || mi == '' || parseInt(mi) == '0') return false;

        $.ajax({
            type: "POST",
            url: '/Board/PhotoInfo',
            data: '{M:"",ct:"' + _zw.V.ct + '",mi:"' + mi + '",xf:"' + xf + '",fd:"0",ur:"' + _zw.V.current.urid + '",operator:"' + _zw.V.current.operator + '",acl:"' + _zw.V.current.acl + '"}',
            success: function (res) {
                if (res.substr(0, 2) == 'OK') {
                    var p = $('#popBlank');
                    p.html(res.substr(2));

                    p.on('hidden.bs.modal', function (event) { p.html(''); p.attr('style', ''); })

                    p.find('.btn[data-zm-menu="save"]').click(function () {
                        bootbox.confirm("저장 하시겠습니까?", function (rt) {
                            if (rt) {
                                var jPost = {};
                                jPost["ct"] = _zw.V.ct;
                                jPost["xfalias"] = xf;
                                jPost["appid"] = mi;
                                jPost["fdid"] = fd;
                                jPost["urid"] = _zw.V.current.urid;
                                jPost["msg"] = p.find('.modal-body #txtMsgType').val();
                                jPost["subject"] = p.find('.modal-body #txtSubject').val();
                                jPost["memo"] = p.find('.modal-body #txtMemo').val();
                                jPost["attachid"] = p.find('.modal-body #txtImgID').val();;
                                jPost["M"] = 'title';
                                //console.log(jPost); return;

                                $.ajax({
                                    type: "POST",
                                    url: "/Board/PhotoSend",
                                    data: JSON.stringify(jPost),
                                    success: function (res) {
                                        if (res.substr(0, 2) == "OK") {
                                            p.modal('hide');
                                            _zw.mu.refresh();
                                        } else bootbox.alert(res);
                                    }
                                });
                            }
                        });
                    });

                    p.find('.btn[data-zm-menu="delete"]').click(function () {
                        bootbox.confirm("삭제 하시겠습니까?", function (rt) {
                            if (rt) {
                                $.ajax({
                                    type: "POST",
                                    url: "/Common/DeleteMsg",
                                    data: '{xf:"' + xf + '",fdid:"' + fd + '",mi:"' + mi + '",urid:"' + _zw.V.current.urid + '"}',
                                    success: function (res) {
                                        if (res == "OK") {
                                            p.modal('hide');
                                            _zw.mu.refresh();
                                        } else bootbox.alert(res);
                                    }
                                });
                            }
                        });
                    });
                    
                    p.modal();
                } else {
                    bootbox.alert(res);
                }
            }
        });
    }

    _zw.mu.deleteMsg = function () {
        if ($('#__ListView').length > 0) {
            if ($('#__ListView .card-footer input:checkbox:checked').length > 20) {
                bootbox.alert('삭제 가능한 최대 항목수는 20개입니다!', function () {
                    $('.z-lv-hdr input:checkbox').prop('checked', false);
                    $('#__ListView .card-footer input:checkbox:checked').prop('checked', false);
                });
                return false;
            }

            var post = {};  v = [];
            $('#__ListView .card-footer input:checkbox:checked').each(function () {
                var p = $(this).parent().parent().parent();
                //console.log(p.attr('appid') + " : " + p.attr('auth') + " : " + p.attr('cmnt') + " : " + $.trim($(this).parent().next().text()))

                var j = {};
                j["xf"] = p.attr('xf'); j["appid"] = p.attr('appid'); j["auth"] = p.attr('auth');
                j["acl"] = p.attr('acl'); j["cmnt"] = p.attr('cmnt'); j["ttl"] = $.trim($(this).parent().next().text());

                v.push(j);
            });
            post["urid"] = _zw.V.current.urid;
            post["operator"] = _zw.V.current.operator;
            post["fdid"] = _zw.V.fdid;
            post["tgt"] = v;

            console.log(post);

            bootbox.confirm("선택 항목을 삭제 하시겠습니까?", function (rt) {
                if (rt) {
                    $.ajax({
                        type: "POST",
                        url: "/Common/DeleteMsgBatch",
                        data: JSON.stringify(post),
                        success: function (res) {
                            if (res.substr(0, 2) == "OK") {
                                //var p = $('#popBlank');
                                //p.html(res.substr(2));
                                //p.on('hidden.bs.modal', function (event) { _zw.mu.refresh();  p.html(''); p.attr('style', ''); })
                                //p.modal();

                                bootbox.alert({ title: '삭제 목록', message: res.substr(2), callback: function () { _zw.mu.refresh(); } });

                            } else bootbox.alert(res);
                        }
                    });
                }
            });
        }
    }

    _zw.mu.goList = function () {
        var postData = _zw.fn.getLvQuery();
        window.location.href = '/Board/Photo?qi=' + _zw.base64.encode(postData);
    }

    _zw.fn.loadList = function () {
        var page = _zw.V.current.page; //.toLowerCase() == '/board/tempsave' ? _zw.V.current.page : '/Board/List';
        var postData = _zw.fn.getLvQuery(); //console.log(postData);
        var url = page + '?qi=' + encodeURIComponent(_zw.base64.encode(postData)); //encodeURIComponent(postData);

        $.ajax({
            type: "POST",
            url: url,
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

                    _zw.fn.bindCtrl();

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
        if ($('.z-lv-search select option').length > 1) $('.z-lv-search select').val(''); //console.log($('.z-lv-search select option').length)
        $('.z-lv-search .search-text').val('');

        $('.z-lv-hdr a[data-val]').each(function () {
            $(this).find('i').removeClass();
        });

        var sCnt = _zw.ut.getCookie('photoLvCount') || $('.z-lv-page select').val();
        var sSort = 'SeqID';

        _zw.V.lv.tgt = tgt;
        _zw.V.lv.page = '1';
        _zw.V.lv.count = sCnt == undefined || sCnt == '' ? '50' : sCnt;
        _zw.V.lv.sort = sSort;
        _zw.V.lv.sortdir = 'DESC';
        _zw.V.lv.search = '';
        _zw.V.lv.searchtext = '';
        _zw.V.lv.start = '';
        _zw.V.lv.end = '';
        _zw.V.lv.basesort = '';
    }
});

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

    _zw.fn.sendPhoto();
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