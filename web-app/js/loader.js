function show_loader() {
    // add the overlay with loading image to the page
    var over = '<div id="loader-overlay">' +
        '<img id="loader" src="../images/gears.gif">' +
        '</div>';
    $(over).appendTo('body');
    window.scrollTo(0, 0);
    $('body').css('overflow', 'hidden');

    // click on the overlay to remove it
    //$('#overlay').click(function() {
    //    $(this).remove();
    //});
}

function hide_loader(){
    $('#loader-overlay').remove();
    $('body').css('overflow', 'auto');
}