$(function() {

    var TITLE_BASE = 'Sakai OAE Widget Library - Browse';
    var DEFAULT_SORT = 'average_rating';
    var DEFAULT_DIR = 'desc';

    var History = window.History;

    var lastSearchVal = '';
    var lastPageSelected = 1;
    var searchTimeout = false;

    var $widget_list_container = $('#widget_list_container');
    var $browse = $('#browse');
    var $browseOverlay = $('#browse_overlay');
    var $browseResults = $('#browse_results');
    var $lhnav = $('.browse #lhnavigation_container');
    var $searchboxInput = $('#searchbox_input');

    $(window).on('statechange', function() {
        var state = History.getState();
        var $sortBy = $('#sort_by');

        // Set the CSS of the browse overlay based on what the current
        // action is
        $browseOverlay.css({top: 60});
        if (state.data.sort) {
            var top = $sortBy.position().top + $sortBy.height() + 5;
            $browseOverlay.css({top: top});
        }

        $browseOverlay.css({height: '100%'});
        if (state.data.page) {
            var height = $browse.height() - ($browse.height() - $('.pagination').position().top) - parseInt($browseOverlay.css('top'), 10);
            $browseOverlay.css({height: height});
        }
        $browseOverlay.show();

        if (state.url !== document.location) {
            $.ajax({
                url: state.url,
                success: function(data) {
                    var isCurrentPage = !state.data.page || state.data.page === lastPageSelected;
                    var isCurrentSearch = !state.data.q || state.data.q === lastSearchVal;
                    if (isCurrentSearch && isCurrentPage) {
                        $browseOverlay.hide();
                        $browseResults.html(data);
                        WL.ellipsisize();
                    }
                }
            });
        }
    });

    var doSearchAndSort = function(e) {
        var $selection = $('#sort_by').find('option:selected');
        var sort_by = $selection.attr('data-sortby') || DEFAULT_SORT;
        var direction = $selection.attr('data-direction') || DEFAULT_DIR;
        var query = $.trim($searchboxInput.val());
        var url = '';
        var params = {};
        var state = {
            s: sort_by,
            d: direction
        };
        if (sort_by !== DEFAULT_SORT || direction !== DEFAULT_DIR) {
            params.s = sort_by;
            params.d = direction;
        }
        if (query !== '') {
            params.q = query;
            state.q = query;
        }
        if (e) {
            state.sort = true;
        }
        if (!$.isEmptyObject(params)) {
            url = "?" + $.param(params);
        } else {
            url = document.location.pathname;
        }
        History.pushState(state, document.title, url);
        return false;
    };

    var clearSearch = function(e) {
        // Need to check for e.clientX as hitting enter can also
        // trigger this function, which would be undesirable
        if (e.clientX && $.trim($searchboxInput.val())) {
            $searchboxInput.val('');
            doSearchAndSort();
        }
        return false;
    };

    var liveSearch = function(e) {
        var val = $.trim($searchboxInput.val());
        if (e.which !== $.ui.keyCode.SHIFT && val !== lastSearchVal) {
            $browseOverlay.css({
                top: 60,
                height: '100%'
            }).show();
            if (searchTimeout) {
                clearTimeout(searchTimeout);
            }
            searchTimeout = setTimeout(function() {
                doSearchAndSort();
                lastSearchVal = val;
            }, 200);
        }
    };

    var handlePaginationClick = function() {
        var url = $(this).attr('href');
        var state = History.getState();
        var page = $(this).attr('data-page');
        if (state.data.page !== page) {
            state.page = page;
            lastPageSelected = page;
            History.pushState(state, document.title, url);
        }
        return false;
    };

    var handleNavigationClick = function() {
        $searchboxInput.val('');
        var url = $(this).attr('href');
        var title = TITLE_BASE;
        if (url !== '/browse') {
            title +=  ' - ' + $(this).text();
        }
        $lhnav.find('.selected').removeClass('selected');
        $(this).parents('li').addClass('selected');
        var state = {
            category: url.replace('/browse', '')
        };
        History.pushState(state, title, url);
        return false;
    };

    var add_bindings = function() {
        $browse.on('change', '#sort_by', doSearchAndSort);
        $browse.on('click', '.searchbox_remove', clearSearch);
        $browse.on('keyup', '#searchbox_input', liveSearch);
        $lhnav.on('click', 'a', handleNavigationClick);
        $browse.on('click', '.pagination a', handlePaginationClick);
    };

    var init = function() {
        add_bindings();
    };

    init();

});
