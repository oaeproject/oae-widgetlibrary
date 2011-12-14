$(function() {

    var screenshotTab = "#screenshot_tab";
    var reviewsTab = "#reviews_tab";
    var versionsTab = "#versions_tab";
    var widgetdetails = "#widgetdetails_";
    var widgetdetailsTabContentContent = ".widgetdetails_tabcontent_content";
    var widgetdetailsTabs = "#widgetdetails_container .wl-inpage-tab";
    var widgetdetails_main_screenshot = "#widgetdetails_main_screenshot";
    var widgetdetails_screenshots_thumbs = "#widgetdetails_screenshots_thumbs";
    var widgetdetails_screenshots_thumb_image = ".widgetdetails_screenshots_thumb img";

    var selectTabs = function(clickedTab){
        $(widgetdetailsTabs).removeClass("selected");
        $(clickedTab).addClass("selected");
    };

    var switchTabs = function(context){
        $(widgetdetailsTabContentContent).hide();
        $(widgetdetails + context).show();
    };

    var addBinding = function(){
        $(screenshotTab).live("click", function(){
            selectTabs(this);
            switchTabs("screenshots");
        });
        $(reviewsTab).live("click", function(){
            selectTabs(this);
            switchTabs("reviews");
        });
        $(versionsTab).live("click", function(){
            selectTabs(this);
            switchTabs("versions");
        });
        $( widgetdetails_screenshots_thumbs).on( "click", widgetdetails_screenshots_thumb_image + ":not(.selected)", function() {
            $( widgetdetails_main_screenshot ).attr( "src", $( this ).attr( "data-large-src" ));
            $( widgetdetails_screenshots_thumb_image + ".selected" ).removeClass( "selected" );
            $( this ).addClass( "selected" );
        });
    };

    var doInit = function(){
        addBinding();
    };

    doInit();
});