$(function() {

    ///////////////
    // VARIABLES //
    ///////////////

    // Containers
    var newversionContainer = "#newversion_container";

    // Elements
    var newversionTriggerUploadNewButton = "#newversion_trigger_submitnew";


    ///////////////
    // UTILITIES //
    ///////////////

    /**
     * Initialize the modal dialog
     */
    var initializeJQM = function(){
        $(newversionContainer).jqm({
            modal: true,
            overlay: 20,
            toTop: true
        });
        $(newversionContainer).jqmShow();
    };


    ////////////////////
    // INITIALIZATION //
    ////////////////////

    /**
     * Add binding on various elements
     */
    var addBinding = function(){
        $(newversionTriggerUploadNewButton).live("click", function(){
            initializeJQM();
        });
    };

    addBinding();

});
