$(function() {

    ///////////////
    // VARIABLES //
    ///////////////
    var createWidgetButton = "#widgetbuilder_create";

    var widgetLoadingDialog = "#widgetbuilder_widgetloading";
    var widgetDownloadWidgetDialog = "#widgetbuilder_downloadwidget";
    var widgetBuilderForm = "#widgetbuilder_form";

    var downloadWidgetButton = "#widgetbuilder_dodownloadwidget";

    var to = false;


    ///////////////
    // UTILITIES //
    ///////////////

    /**
     * Present the ZIP file to the user and show the final file name
     */
    var showDownloadZip = function(){
        $(widgetLoadingDialog).jqmHide();
        $("#widgetbuilder_built_name").text($("#widgetbuilder_title").val() + ".zip");
        $(widgetDownloadWidgetDialog).jqmShow();
    };

    /**
     * If a user cancels creation also cancel the timeout that shows the final ZIP document
     */
    var removeTimeout = function(hash){
        hash.o.remove();
        hash.w.hide();
        clearTimeout(to);
    };


    ////////////////////
    // INITIALIZATION //
    ////////////////////

    /**
     * Initialize the overlays that show progress and final ZIP file
     */
    var initializeOverlays = function(){
        $(widgetLoadingDialog).jqm({
            modal: true,
            overlay: 20,
            toTop: true,
            onHide: removeTimeout
        });

        $(widgetLoadingDialog).jqmShow();

        $(widgetDownloadWidgetDialog).jqm({
            modal: true,
            overlay: 20,
            toTop: true
        });

        to = setTimeout(showDownloadZip, 3000);
    };

    /**
     * Add binding to various elements
     */
    var addBinding = function(){
        $(createWidgetButton).live("click", function(){
            initializeOverlays();
        });

        $(downloadWidgetButton).live("click", function(){
            $(widgetBuilderForm).submit();
        });
    };

    var init = function(){
        addBinding();
    };

    init();

});
