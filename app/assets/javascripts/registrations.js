$(function() {

    var $register_loading = $("#register_loading");

    $register_loading.jqm({
        modal: true,
        overlay: 20,
        toTop: true
    });

    var showLoading = function(){
        $register_loading.css({
            "top": $("html").scrollTop() + 150
        });

        $register_loading.jqmShow();
    };

    // Reset all the errors on a new submit of the form
    $("#user_new, #user_edit").live("submit", function(){
        WL.reset_errors();
        $("#check_username_result").removeClass("available unavailable").text("");
        showLoading();
    });

    // Handle checking for the username availability
    $("#check_username").on("click", function() {
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
