$(function() {

    var reject_widget = function() {
        $( "#admin_action_buttons" ).hide();
        $(".widget_confirmation").hide();
        $("#reject_confirm").show();
    };

    var finalize_rejection = function( versionid ) {
        $.ajax({
            url: "/admin/widgets/declined/" + versionid,
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

    var finalize_approval = function( versionid ) {
        $.ajax({
            url: "/admin/widgets/accepted/" + versionid,
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
                    var versionid = $( "#admin_actions" ).attr( "data-versionid" );
                    if ( which === "approve" ) {
                        finalize_approval( versionid );
                    } else {
                        finalize_rejection( versionid );
                    }
                    break;
            }
        });
        $('ul.admin_userlist li input[type="checkbox"]').on('change', function() {
            $(this).parents('form:first').submit();
            return false;
        });
    };

    var init = function() {
        add_bindings();
    };

    init();

});
