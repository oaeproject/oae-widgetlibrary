$(function() {

    var reject_widget = function() {
        $( "#admin_action_buttons" ).hide();
        $(".widget_confirmation").hide();
        $("#reject_confirm").show();
    };

    var finalize_rejection = function( widgetid ) {
        $.ajax({
            url: "/admin/widgets/declined/" + widgetid,
            type: "POST",
            data: {
                notes: $("#reject_message").val()
            },
            success: function( data ) {
                document.location = document.location;
            }
        });
    };

    var approve_widget = function() {
        $( "#admin_action_buttons" ).hide();
        $(".widget_confirmation").hide();
        $("#approve_confirm").show();
    };

    var finalize_approval = function( widgetid ) {
        $.ajax({
            url: "/admin/widgets/accepted/" + widgetid,
            type: "POST",
            data: {
                notes: $("#approve_message").val()
            },
            success: function( data ) {
                document.location = document.location;
            }
        });
    };

    var add_bindings = function() {
        $( "#admin_actions" ).on( "click", "button[data-action]", function( e ) {
            var action = $( e.target ).attr( "data-action" );
            switch ( action ) {
                case "approve":
                    approve_widget();
                    break;
                case "reject":
                    reject_widget();
                    break;
                case "cancel":
                    $( "#admin_action_buttons" ).show();
                    $(".widget_confirmation").hide();
                    break;
                case "confirm":
                    var which = $( e.target ).attr( "data-which" );
                    var widgetid = $( "#admin_actions" ).attr( "data-versionid" );
                    if ( which === "approve" ) {
                        finalize_approval( widgetid );
                    } else {
                        finalize_rejection( widgetid );
                    }
                    break;
            }
        });
    };

    var init = function() {
        add_bindings();
    };

    init();

});
