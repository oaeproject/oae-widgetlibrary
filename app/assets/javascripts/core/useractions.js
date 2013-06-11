$(function() {

    ///////////////
    // VARIABLES //
    ///////////////

    // Containers
    var dropdownMenu = ".wl-dropdown-menu";
    var loginFieldsContainer = "#useractions_login_fields";
    var loginFieldsContainerInput = "#useractions_login_fields input";
    var loginFieldsContainerInputTextPassword = "#useractions_login_fields input[type=text], #useractions_login_fields input[type=password]";

    // Elements
    var signingInLabel = "#useractions_login_button_signing_in";
    var loginSubmitButton = "#useractions_login_button_login";
    var loginForm = "#useractions_login_form";
    var useractions_login_error = "#useractions_login_error";

    // Classes
    var formHasFocus = "form_has_focus";

    var formOpened = false;


    ///////////////
    // UTILITIES //
    ///////////////

    /**
     * Show or hide buttons and labels on login success/error
     * @param {Boolean} doLogin True or False coming out of the login action
     */
    var toggleLoginButtons = function(doLogin){
        if (doLogin){
            $(signingInLabel).show();
            $(loginSubmitButton).hide();
        } else {
            $(signingInLabel).hide();
            $(loginSubmitButton).show();
        }
    };

    ////////////////////
    // INITIALIZATION //
    ////////////////////

    /**
     * Remove Errors
     */
    var removeErrors = function() {
        $(useractions_login_error).hide();
        $(loginFieldsContainerInputTextPassword).removeClass(WL.wlError);
    };

    /**
     * Show Errors
     */
    var showErrors = function() {
        $(useractions_login_error).show();
        $(loginFieldsContainerInputTextPassword).addClass(WL.wlError);
    };

    /**
     * Add binding to various elements
     */
    var addBinding = function(){
        $(loginForm).on("submit", function(){
            removeErrors();
            toggleLoginButtons(true);
        });

        $(loginForm).on('ajax:success', function() {
            removeErrors();
            document.location = document.location;
        });

        $(loginForm).on('ajax:error', function() {
            showErrors();
            toggleLoginButtons(false);
        });

        $(dropdownMenu).hover(function(ev){
            if (ev.type === "mouseenter"){
                $(this).children(loginFieldsContainer).show();
                $(this).addClass("opened");
            } else {
                if (!$(this).hasClass(formHasFocus) && !formOpened){
                    $(this).children(loginFieldsContainer).hide();
                    $(this).removeClass("opened");
                }
            }
        });

        $(loginFieldsContainerInput).focus(function(){
            $(dropdownMenu).addClass(formHasFocus);
            formOpened = true;
        });

        $(loginFieldsContainerInput).blur(function(){
            $(dropdownMenu).removeClass(formHasFocus);
            if(!formOpened){
                $(loginFieldsContainer).hide();
                $(loginFieldsContainer).parent().removeClass("opened");
            }
            formOpened = false;
        });

        $("html").click(function(ev){
            if (!formOpened && !$(ev.target).parents(".wl-dropdown-menu").length) {
                formOpened = false;
                $(loginFieldsContainer).hide();
                $(loginFieldsContainer).parent().removeClass("opened");
            }
        });
    };

    addBinding();

});
