//= require submit/newversion

$(function() {

    var $submit_loading = $("#submit_loading");

    $submit_loading.jqm({
        modal: true,
        overlay: 20,
        toTop: true
    });

    var showLoading = function(){
        $submit_loading.css({
            "top": $("html").scrollTop() + 150
        });

        $submit_loading.jqmShow();
    };

    $("#new_version").on("submit", function(){
        // Reset all the errors on a new submit of the form
        WL.reset_errors();
        showLoading();
    });
});
