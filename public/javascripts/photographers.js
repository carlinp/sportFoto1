
 $(function(){
    $('#tabs').tabs();
    $('button').button();
    $('#selectors').buttonset();
 });

 function setProgress( percent ) {
     $("#progressbar").progressbar({
        value: percent
    });
 }

 function loadPictures( path ) {
   $('#pictures').load(path);

 }

 function filter( what ) {
    $('.photo').hide();
    switch (what) {
        case 1:
            $('div[is_approved|=false]').show();
            break;
        case 2:
            $('div[has_price|=false]').show();
            break;
        case 3:
            toggleSold();
            break;
        case 4:
            toggleTagged();
            break;
        default:
            $('.photo').show();
    }
 }

 function toggleApproved() {
    var button = $('#button-approved');
    var checked = button[0].checked;
    $('div[is_approved|='+checked+']').show();
 }

 function togglePriced() {
    var button = $('#button-price');
    var checked = button[0].checked;
    $('div[has_price|='+checked+']').show();
 }

function toggleSold() {
    var button = $('#button-sold');
    var checked = button[0].checked;
    $('div[sold|='+checked+']').show();
}
function toggleTagged() {
    var button = $('#button-tagged');
    var checked = button[0].checked;
    $('div[has_startnumber|='+checked+']').show();
}