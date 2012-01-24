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
        },
        reset_errors: function() {
            $("span." + WL.wlError).hide();
            $("." + WL.wlError + ":not(span)").removeClass(WL.wlError);
        }
    };

    var lastSearchVal = "";
    var searchTimeout = false;
    var $lhnavigation_container = $( "#lhnavigation_container" );
    var $widget_list_container = $( "#widget_list_container" );
    var $searchbox_input = $( "#searchbox_input" );
    var $searchbox_remove = $( ".searchbox_remove" );

    var performsearch = function() {
        var $sort_by = $("#sort_by");
        var query = $searchbox_input.val();
        var $selection = $sort_by.find("option:selected");
        var sort_by = $selection.attr("data-sortby");
        var direction = $selection.attr("data-direction");
        $("#featured").remove();
        $.ajax({
            url: document.location,
            data: {
                q: query,
                s: sort_by,
                d: direction,
                page: 1
            },
            success: function( data ) {
                var $data = $( "<div/>" ).html( data );
                var lhnavigation_container = $data.find( "#lhnavigation_container" );
                var widget_list_container = $data.find( "#widget_list_container" );
                var featured = $data.find( "#featured" );

                $widget_list_container.html( widget_list_container ).before(featured);
                $lhnavigation_container.html( lhnavigation_container );
            }
        });
    };

    var livesearch = function(ev) {
        var val = $.trim( $searchbox_input.val() );

        if ( ev.which !== $.ui.keyCode.SHIFT && val !== lastSearchVal ) {
            if ( searchTimeout ) {
                clearTimeout( searchTimeout );
            }
            searchTimeout = setTimeout( function() {
                performsearch();
                lastSearchVal = val;
            }, 200 );
        }
    }

    var emptysearch = function() {
        $searchbox_input.val("");
        performsearch();
        return false;
    }

    var add_bindings = function() {
        $( ".wl-page-container" ).on( "change", "#sort_by", performsearch );
        $searchbox_remove.on( "click", $searchbox_input, emptysearch );
        $("#searchbox_input").on( "keyup", livesearch );
    };

    var init = function() {
        add_bindings();
    };
    init();
});
