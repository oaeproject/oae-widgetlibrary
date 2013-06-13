$(function() {

    ///////////////
    // VARIABLES //
    ///////////////

    var createWidgetButton = "#widgetbuilder_create";
    var widgetBuilderForm = "#widgetbuilder_form";

    var to = false;


    ////////////////////
    // INITIALIZATION //
    ////////////////////

    $(widgetBuilderForm).validate();

    $(createWidgetButton).on("click", function(){
        $(widgetBuilderForm).submit();
    });

});
