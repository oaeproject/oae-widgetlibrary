$(function() {

    var DEFAULT_TAB = $("#widgetdetails_screenshots").length ?
                        'screenshots' : 'reviews';

    var History = window.History;

    var screenshotTab = '#screenshots';
    var reviewsTab = '#reviews';
    var versionsTab = '#versions';
    var write_review = '#write_review';
    var widgetdetails = '#widgetdetails_';
    var widgetdetailsTabContentContent = '.widgetdetails_tabcontent_content';
    var widgetdetailsTabs = '#widgetdetails_container .wl-inpage-tab';
    var widgetdetails_main_screenshot = '#widgetdetails_main_screenshot';
    var widgetdetails_screenshots_thumbs = '#widgetdetails_screenshots_thumbs';
    var widgetdetails_screenshots_thumb_image =
        '.widgetdetails_screenshots_thumb img';

    var widgetdetailsReviewsReviewWidget =
        '#widgetdetails_reviews_review_widget';

    var widget_details_rating_link = '#widget_details .wl-rating-container a';

    var wl_rating_container = '.wl-rating-container';
    var wl_rating_icon = '.wl-rating-icon';
    var wl_rating_input = '.wl-rating-input';
    var wl_rating_current = '.wl-rating-current';


    $(window).on('statechange', function() {
        var state = History.getState();
        var tab = state.data.tab;
        if (!tab) {
            tab = DEFAULT_TAB;
        }
        selectTab(tab, state.data.scroll);
    });

    var selectTab = function(which, scroll) {
        $(widgetdetailsTabs).removeClass('selected');
        $('#' + which).addClass('selected');
        $(widgetdetailsTabContentContent).hide();
        $(widgetdetails + which).show();
        if (scroll) {
            $('html').scrollTop($('#' + which).offset().top);
        }
    };

    var handleRatingClick = function(e) {
        e.preventDefault();
        var currentrating = $(e.target).attr('data-rating');
        var $this = $(this);
        $(wl_rating_input, widgetdetailsReviewsReviewWidget).val(currentrating);
        $this.find(wl_rating_current).css({
            width: (currentrating * 20) + '%'
        });
    };

    var changeScreenshot = function() {
        var $this = $(this);
        $(widgetdetails_main_screenshot).attr(
            'src', $this.attr('data-large-src')
        );

        $(widgetdetails_screenshots_thumb_image + '.selected')
            .removeClass('selected');

        $this.addClass('selected');
        return false;
    };

    var handleTabClick = function() {
        var state = {
            tab: $(this).attr('id')
        };
        // the reviews link doesn't have an id
        if (!state.tab || state.tab === 'write_review') {
            if (!state.tab) {
                state.scroll = true;
            }
            state.tab = 'reviews';
        }
        History.pushState(state, document.title, '?show=' + state.tab);
        return false;
    };

    var addBinding = function() {
        $(widgetdetailsTabs + ', ' + widget_details_rating_link).on(
            'click',
            handleTabClick);

        $(widgetdetails_screenshots_thumbs).on(
            'click',
            widgetdetails_screenshots_thumb_image + ':not(.selected)',
            changeScreenshot);

        $(wl_rating_container).on('click', wl_rating_icon, handleRatingClick);
        $(write_review).on('click', handleTabClick);
    };

    var doInit = function() {
        addBinding();
    };

    doInit();
});
