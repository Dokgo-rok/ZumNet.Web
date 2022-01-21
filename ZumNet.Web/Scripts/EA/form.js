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
    }

    //양식별로 선언(예:DRAFT.js)
    _zw.formEx = {
        //checkEvent(ckb, el, fld), autoCalc(p)
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