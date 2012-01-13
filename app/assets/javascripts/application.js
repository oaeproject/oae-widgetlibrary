//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery.remotipart
//= require modernizr
//= require jqmodal
//= require_self
//= require core/navigation
//= require core/useractions

$(function() {
    // Define a global object to toss some methods into
    WL = {
        wlError : "wl-error",
        show_errors: function(errors, controller_name, $form) {
            $.each(errors, function(key, error) {
                var error_message = error[0];
                if (key.indexOf("_content_type") !== -1) {
                  key = key.replace("_content_type", "");
                }
                if (key.indexOf(".") !== -1) {
                  key = key.replace(".", "_");
                  error_message = error[1];
                }
                nice_key = key.replace("_", " ");
                error_message = nice_key + " " + error_message;
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
        },
        reset_errors: function() {
            $("span." + WL.wlError).hide();
            $("." + WL.wlError + ":not(span)").removeClass(WL.wlError);
        }
    };

    var sort = function(e) {
        var $selection = $(e.target).find("option:selected");
        var sort_by = $selection.attr("data-sortby");
        var direction = $selection.attr("data-direction");
        $.ajax({
            url: document.location,
            data: {
                s: sort_by,
                d: direction,
                page: 1
            },
            success: function( data ) {
                var $data = $( "<div/>" ).html( data );
                var widgets = $data.find( "#widget_list" );
                $( "#widget_list" ).html( widgets );
            }
        });
    };

    var add_bindings = function() {
        $( ".wl-page-container" ).on( "change", "#sort_by", sort );
    };

    var init = function() {
        add_bindings();
    };
    init();
});
