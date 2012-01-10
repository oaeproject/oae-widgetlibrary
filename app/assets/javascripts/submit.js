//= require submit/newversion

$(function() {
    // Classes
    var wlError = "wl-error";

    // Reset all the errors on a new submit of the form
    $("#new_version").on("submit", function(){
        $("span." + wlError).text("").hide();
        $("." + wlError + ":not(span)").removeClass(wlError);
    });
});
