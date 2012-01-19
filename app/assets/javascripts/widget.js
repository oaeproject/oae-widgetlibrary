$(function() {

    var screenshotTab = "#screenshots";
    var reviewsTab = "#reviews";
    var versionsTab = "#versions";
    var write_review = "#write_review";
    var widgetdetails = "#widgetdetails_";
    var widgetdetailsTabContentContent = ".widgetdetails_tabcontent_content";
    var widgetdetailsTabs = "#widgetdetails_container .wl-inpage-tab";
    var widgetdetails_main_screenshot = "#widgetdetails_main_screenshot";
    var widgetdetails_screenshots_thumbs = "#widgetdetails_screenshots_thumbs";
    var widgetdetails_screenshots_thumb_image = ".widgetdetails_screenshots_thumb img";
    var widgetdetailsReviewsReviewWidget = "#widgetdetails_reviews_review_widget";
    var widget_details_rating_link = "#widget_details .wl-rating-container a";

    var wl_rating_container = ".wl-rating-container";
    var wl_rating_icon = ".wl-rating-icon";
    var wl_rating_input = ".wl-rating-input";
    var wl_rating_current = ".wl-rating-current";

    var selectTabs = function( clickedTab ) {
        $( widgetdetailsTabs ).removeClass( "selected" );
        $( clickedTab ).addClass( "selected" );
    };

    var switchTabs = function( context ) {
        $( widgetdetailsTabContentContent ).hide();
        $( widgetdetails + context ).show();
    };

    var checkHash = function() {
        var hash = window.location.hash;
        if( hash ){
          $( hash ).trigger( "click" );
        }
    };

    var addBinding = function() {
        $( screenshotTab ).live( "click", function() {
            selectTabs( this );
            switchTabs( "screenshots" );
        });
        $( reviewsTab  + ", " + write_review ).live( "click", function() {
            selectTabs( reviewsTab );
            switchTabs( "reviews" );
        });
        $( versionsTab ).live( "click", function() {
            selectTabs( this );
            switchTabs( "versions" );
        });
        $( widgetdetails_screenshots_thumbs).on( "click", widgetdetails_screenshots_thumb_image + ":not(.selected)", function() {
            $( widgetdetails_main_screenshot ).attr( "src", $( this ).attr( "data-large-src" ));
            $( widgetdetails_screenshots_thumb_image + ".selected" ).removeClass( "selected" );
            $( this ).addClass( "selected" );
        });

        $( widget_details_rating_link ).on( "click", function(){
            checkHash();
        });

        // Rating
        $( wl_rating_container ).on( "click", wl_rating_icon, function( e ) {
            e.preventDefault();
            var currentrating = $( e.target ).attr( "data-rating" );
            var $this = $( this );
            $( wl_rating_input, widgetdetailsReviewsReviewWidget ).val( currentrating );
            $this.find( wl_rating_current ).css({
                width: ( currentrating * 20 ) + "%"
            });
        });
    };

    var doInit = function() {
        addBinding();
        checkHash();
    };

    doInit();
});
