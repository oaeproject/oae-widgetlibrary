$(function() {

    // Classes
    var wlError = "wl-error";

    // Reset all the errors on a new submit of the form
    $("#user_new").live("submit", function(){
        $("span." + wlError).text("").hide();
        $("label."  + wlError + ", input." + wlError + ", div." + wlError).removeClass(wlError);
        $("#check_username_result").removeClass("available unavailable").text("");
    });

    // Handle checking for the username availability
    $("#check_username").live("click", function() {
        var username = $.trim($("#user_username").val());
        if (username) {
            $.ajax({
                url: "/register/check_username/" + username,
                success: function(data) {
                    if (data) {
                        var text = username + " " + data.text,
                            classToAdd = "available";
                        if (data.user_found === true) {
                            classToAdd = "unavailable";
                        }
                        $("#check_username_result").removeClass("available unavailable").addClass(classToAdd).text(text);
                    }
                }
            });
        }
    });
});
