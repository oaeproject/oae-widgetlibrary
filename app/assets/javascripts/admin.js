$(function() {

    var reject_widget = function() {
        $( "#admin_action_buttons" ).hide();
        $(".widget_confirmation").hide();
        $("#reject_confirm").show();
    };

    var finalize_rejection = function( widgetid ) {
        $.ajax({
            url: "/admin/widgets/reject/" + widgetid,
            type: "POST",
            success: function( data ) {
                console.log("rejected");
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
            url: "/admin/widgets/approve/" + widgetid,
            type: "POST",
            success: function( data ) {
                console.log("approved");
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
                    var widgetid = $( "#admin_actions" ).attr( "data-widgetid" );
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
