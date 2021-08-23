//전자결재 메인, 리스트뷰

$(function () {

    $('#__LeftMenu .sidenav-toggle').click(function (e) {
        e.preventDefault();
        
        $(this).next().slideToggle(300, function() {
            $(this).parent().toggleClass('open');
        });
    });
    

});