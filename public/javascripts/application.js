// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function handleSliderChange(e, ui) {
  var maxScroll = $("#cart-content-scroll").attr("scrollWidth") -
                  $("#cart-content-scroll").width();
  $("#cart-content-scroll").animate({scrollLeft: ui.value *
     (maxScroll / 100) }, 1000);
}

function handleSliderSlide(e, ui) {
var maxScroll = $("#cart-content-scroll").attr("scrollWidth") -
                  $("#cart-content-scroll").width();
  $("#cart-content-scroll").attr({scrollLeft: ui.value * (maxScroll / 100) });
}
