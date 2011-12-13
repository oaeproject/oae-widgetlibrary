var screenshotTab = "#screenshot_tab";
var reviewsTab = "#reviews_tab";
var versionsTab = "#versions_tab";
var widgetdetails = "#widgetdetails_";
var widgetdetailsTabContentContent = ".widgetdetails_tabcontent_content";
var widgetdetailsTabs = "#widgetdetails_container .wl-inpage-tab";

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
};

var doInit = function(){
    addBinding();
};

doInit();