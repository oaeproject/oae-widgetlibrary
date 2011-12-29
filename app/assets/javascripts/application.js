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
    var sort = function(e) {
        var $selection = $(e.target).find("option:selected");
        var sort_by = $selection.attr("data-sortby");
        var direction = $selection.attr("data-direction");
        $.ajax({
            url: document.location,
            data: {
                s: sort_by,
                d: direction
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
