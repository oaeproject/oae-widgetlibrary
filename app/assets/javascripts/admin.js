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
        $('.language_remove_form').on('submit', function(ev) {
            var target = $(ev.target);
            var languageToRemove = target.find('button').attr('title').replace('Remove ','');
            var languageUsed = target.find('.language-used').val();
            var secondConfirmation = (languageUsed === 'true') ? true : false;
            var response1 = false;
            var response2 = true;
            response1 = confirm('Are you sure you want to remove the language \''+languageToRemove+'\'?');
            if (secondConfirmation === true) {
                response2 = confirm('The language \'' + languageToRemove + '\' is being used by widgets that have been submitted to the Widget Library. Are you sure you want to remove this language?');
            }
            return (response1 && response2);
        });
        $('#language_add_edit_form').on('submit', function(ev) {
            var fields = $(this).find('input[type=text]');
            var errorMsg = $(this).find('.admin-error-box');
            fields.removeClass('field-error');
            errorMsg.hide();
            fields.each(function() {
                if (this.value == "" || !this.value) {
                    $(this).addClass('field-error');
                    errorMsg.show();
                    ev.preventDefault();
                }
            });
        });
    };

    var init = function() {
        add_bindings();
    };

    init();

});
