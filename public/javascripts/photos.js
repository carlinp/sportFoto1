/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function jqshowDetails( id ) {
    $("#photo-"+id+"-data").toggle("puff",{},500);
    $("#photo-"+id+"-image").toggle("puff",{},500);
    
}

function putToCart( url, id ) {
    $('#photo-'+id).hide("drop",{},500);

    $.ajax({
      url: url,
      success: function(data) {
        $('#cart').load(url+'../../../show');
        $('#cart-summary').load(url+'../../../summary');
        $("#cart").show();
      }
    });
}

function openPhotoDialog( url, id ) {

  $('#photo-dialog-'+id).dialog({
     autoOpen: true,
     width: 600,
     buttons: {
         "Bezár": function() {
             $(this).dialog('close');
         },
         "Kosárba": function() {
             putToCart(url, id);
             $(this).dialog('close');
         }
     }
  });

}

