//전자결재 메인, 리스트뷰

$(function () {
    var sw = window.screen.availWidth, sh = window.screen.availHeight - 20, w = $('#__FormView .m').outerWidth() + 100;
    //console.log(sw + " : " + sh + " : " + fw)
    if (sw < 860 || sw < w) {
        window.moveTo(1, 10); window.resizeTo(sw, sh);
    } else {
        window.moveTo(sw / 2 - w / 2, 10); window.resizeTo(w, sh);
    }
});