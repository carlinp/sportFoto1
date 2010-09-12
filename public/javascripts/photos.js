    $(function(){
      $(".basket").button({
        icons: {
          primary: 'ui-icon-cart'
        }
      });
      $(".detail").button({
        icons: {
          primary: 'ui-icon-document'
        }
      });
      $("#searchbutton").button({
        icons: {
          primary: 'ui-icon-search'
        }
      });
      $("#search-tabs").tabs();

      $("#go").button({
          icons: {
              primary: 'ui-icon-search'
          }
      });



    });

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

function handleTimeSliderChange(e, ui) {
    var left = new Date(ui.values[0]);
    var right = new Date(ui.values[1]);
    $("#form_time_from").attr("value", ui.values[0]);
    $("#form_time_to").attr("value", ui.values[1]);
    $("#time-from").html(left.getUTCHours()+":"+left.getUTCMinutes());
    $("#time-to").html(right.getUTCHours()+":"+right.getUTCMinutes());
}

function handleTimeSliderSlide(e, ui) {
}


function initTimeSlider(time_min, time_max, act_min, act_max) {
      var min = Date.parse(time_min);
      var max = Date.parse(time_max);
      if (act_min==0) {
          act_min = min;
      }
      else {
        var left=new Date(act_min);
        $("#time-from").html(left.getUTCHours()+":"+left.getUTCMinutes());
      }
      if (act_max==0) {
          act_max = max;
      }
      else {
        var right=new Date(act_max);
        $("#time-to").html(right.getUTCHours()+":"+right.getUTCMinutes());
      }
      $("#time-slider").slider({
          range: true,
          animate: true,
          change: handleTimeSliderChange,
//          slide: handleTimeSliderChange,
          min: min,
          max: max,
          values: [act_min,act_max]
      });

}