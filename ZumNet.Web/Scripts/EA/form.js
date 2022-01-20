//전자결재 메인, 리스트뷰

$(function () {
    var sw = window.screen.availWidth, sh = window.screen.availHeight, w = $('#__FormView .m').outerWidth() + 100;
    //console.log(sw + " : " + sh + " : " + fw)
    if (sw < 860) {
        window.moveTo(1, 1); window.resizeTo(sw, sh);
    } else if (sw < w) {
        window.moveTo(1, 10); window.resizeTo(sw, sh - 20);
    } else {
        window.moveTo(sw / 2 - w / 2, 10); window.resizeTo(w, sh - 20);
    }

    if ($('#__DextUpload').length > 0) {
        DEXT5UPLOAD.config.ButtonBarEdit = 'add,remove,remove_all';

        DEXT5UPLOAD.config.UploadHolder = "__DextUpload";
        new Dext5Upload(_zw.T.uploader.id);

        $('.btn[data-zf-menu="toggleUploader"]').click(function () {
            
        });
    }

    if ($('#__DextEditor').length > 0) {
        _zw.T.editor.top = $('.zf-editor').prev().outerHeight() + 8; //alert(posTop)
        $('#__DextEditor').css('top', _zw.T.editor.top + 'px');

        //DEXT5.config.ToSaveFilePathURL = "@sUploadPath";

        DEXT5.config.EditorHolder = "__DextEditor";
        //DEXT5.config.FocusInitObjId = "txtSubject";

        new Dext5editor(_zw.T.editor.id);

        $('.btn[data-zf-menu="toggleEditor"]').click(function () {

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