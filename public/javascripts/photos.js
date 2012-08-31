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
      var datePattern = new RegExp("([0-9]{4})-([0-9]{1,2})-([0-9]{1,2})");
      var timePattern = new RegExp("([0-9]{1,2}):([0-9]{1,2}):([0-9]{1,2})")

      var dateMin = datePattern.exec(time_min);
      var timeMin = timePattern.exec(time_min);
      var dateMax = datePattern.exec(time_max);
      var timeMax = timePattern.exec(time_max);

      var min = new Date(Date.UTC(dateMin[1], dateMin[2]-1, dateMin[3], timeMin[1], timeMin[2], 0, 0));
      var max = new Date(Date.UTC(dateMax[1], dateMax[2]-1, dateMax[3], timeMax[1], timeMax[2], 0, 0));
      //var min = Date.parse(dateMin+"T"+timeMin+"Z");
      //var max = Date.parse(dateMax+"T"+timeMax+"Z");
      if (act_min==0) {
          act_min = min.valueOf();
      }
      var left=new Date(act_min);
      $("#form_time_from").attr("value", act_min);
      $("#time-from").html(left.getUTCHours()+":"+left.getUTCMinutes());

      if (act_max==0) {
          act_max = max.valueOf();
      }
      var right=new Date(act_max);
      $("#form_time_to").attr("value", act_max);
      $("#time-to").html(right.getUTCHours()+":"+right.getUTCMinutes());

      $("#time-slider").slider({
          range: true,
          animate: true,
          change: handleTimeSliderChange,
//          slide: handleTimeSliderChange,
          min: min.valueOf(),
          max: max.valueOf(),
          values: [act_min,act_max]
      });

}