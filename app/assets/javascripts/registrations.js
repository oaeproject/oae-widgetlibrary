$(function() {

    // Classes
    var wlError = "wl-error";

    // Reset all the errors on a new submit of the form
    $("#user_new").live("submit", function(){
        $("span." + wlError).text("").hide();
        $("label."  + wlError + ", input." + wlError).removeClass(wlError);
        $("#check_username_result").removeClass("available unavailable").text("");
    });

    // Handle the return for the user registration form
    $("#user_new").live('ajax:success', function(xhr, data) {
        // If it is a success, just redirect to the URL returned
        if (data.success && data.url) {
            document.location = data.url;
        } else if (data.errors) {
            // otherwise, display the error labels
            $.each(data.errors, function(key, error) {
                $("#user_" + key).addClass(wlError);
                $("label[for='user_" + key + "']").addClass(wlError);
                if (key === "user_password") {
                    $("label[for='user_" + key + "_confirmation']").addClass(wlError);
                }
                $("#user_" +  key + "_error").text(error[0]).show();
                // Always reload the recaptcha
                Recaptcha.reload();
            });
        }
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