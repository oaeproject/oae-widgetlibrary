//= require submit/newversion

$(function() {
    // Classes
    var wlError = "wl-error";

    // Reset all the errors on a new submit of the form
    $("#new_widget").live("submit", function(){
        $("span." + wlError).text("").hide();
        $("label."  + wlError + ", input." + wlError + ", div." + wlError).removeClass(wlError);
    });
});
