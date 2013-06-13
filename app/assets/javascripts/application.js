//= require jquery-2.0.2
//= require jquery.ui.all
//= require jquery.remotipart
//= require jquery.autoellipsis
//= require jquery.validate
//= require jquery.history
//= require modernizr
//= require_self
//= require core/navigation
//= require core/useractions

$(function() {
    // Define a global object to toss some methods into
    WL = {
        wlError : "wl-error",
        wlLoading: ".wl-loading",
        show_errors: function(errors, controller_name, $form) {
            $.each(errors, function(key, error) {
                var error_message = error.title + " " + error.message;
                var inputelement = $("#" + controller_name + "_" + key, $form);
                // In some cases we aren't able to use the key name
                // since it is possible that it already exists elsewhere
                if (inputelement.length === 0){
                  inputelement = $("#" + controller_name + "_" + key + "_label", $form);
                }
                inputelement.addClass(WL.wlError);
                $("label[for='" + controller_name + "_" + key + "']", $form).addClass(WL.wlError);
                $("#" + controller_name + "_" +  key + "_error", $form).text(error_message).show();
            });
            $(WL.wlLoading).jqmHide();
            // Scroll to the first element that has an error on it
            $("html").scrollTop($("." + WL.wlError + ":visible:first").offset().top - 40);
        },
        reset_errors: function() {
            $("span." + WL.wlError).hide();
            $("." + WL.wlError + ":not(span)").removeClass(WL.wlError);
        },
        ellipsisize: function() {
            $(".wl-widget-ellipsis").ellipsis().parent().css({"visibility": "visible"});
        }
    };

    var readmore = function() {
        var $parentElement = $(this).parent();
        $parentElement.text($parentElement.attr("data-completetext"));
    };

    var addBindings = function() {
        $("body").on( "click", ".review_read_more", readmore );
        $("document").ready(function() {
            if (typeof prettyPrint !== "undefined" && $.isFunction(prettyPrint)) {
                prettyPrint();
            }
        });
    };

    var init = function() {
        addBindings();
        WL.ellipsisize();
    };
    init();

});
