///////////////
// VARIABLES //
///////////////

// Containers
var dropdownMenu = ".wl-dropdown-menu";
var loginFieldsContainer = "#useractions_login_fields";
var loginFieldsContainerInput = "#useractions_login_fields input";

// Elements
var signingInLabel = "#useractions_login_button_signing_in";
var loginSubmitButton = "#useractions_login_button_login";
var loginForm = "#useractions_login_form";

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

/**
 * Log the user into the widget library
 */
var doLogin = function(){
    // Toggle login buttons if error occurs while logging in
    // toggleLoginButtons(success);
};


////////////////////
// INITIALIZATION //
////////////////////

/**
 * Add binding to various elements
 */
var addBinding = function(){
    $(loginForm).live("submit", function(){
        toggleLoginButtons(true);
        doLogin();
        return false;
    });

    $(dropdownMenu).live("hover", function(ev){
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

    $(loginFieldsContainerInput).live("focus", function(){
        $(dropdownMenu).addClass(formHasFocus);
        formOpened = true;
    });

    $(loginFieldsContainerInput).live("blur", function(){
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