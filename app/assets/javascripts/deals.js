$(function(){
	$("#subscribe-form").submit(function(){
    var form_values = $(this).serialize(),
        that = this;
    $.ajax({
      url: $(this).attr('action'),
      type: "POST",
      data: form_values,
      // dataType: "JSON"
    }).done(function(result){
      if (result.code == 200) {
        // Success
        cancel_subscribe_errors();
        console.log($(that).find(".success"));
        $(that).find(".success").html("Thanks! Please check your email and click the link to confirm your subscription.");
      } else {
        // Error
        subscribe_error(result.message);
      }
      // console.log(result.code);
      // console.log(result.message);
      // console.log(result.status);
    }).fail(function(result){
        subscribe_error("<strong>Oh noes!</strong> There's been a server hiccup. Please try again... Still not working? <a href=\"http://eepurl.com/h5Ywg\" target=\"_blank\">Sign up here!</a>");
    });
    return false;
  });
  function subscribe_error(msg) {
    $(".control-group").addClass("error");
    $(".control-group").find(".btn").addClass("btn-danger").css("color", "white");
    $(".control-group").find(".errors").html(msg);
  }
  function cancel_subscribe_errors() {
    $(".control-group").removeClass("error");
    $(".control-group").find(".btn").removeClass("btn-danger");
    $(".control-group").find(".errors").html("");
  }
  $('#loading-indicator')
    // .hide()  // hide it initially.
    .ajaxStart(function() {
      $(this).show(); // show on any Ajax event.
    })
    .ajaxStop(function() {
      $(this).hide(); // hide it when it is done.
  });
});
