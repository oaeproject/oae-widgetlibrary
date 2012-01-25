$(function() {

    var TITLE_BASE = 'Sakai OAE Widget Library - Browse';
    var DEFAULT_SORT = 'average_rating';
    var DEFAULT_DIR = 'desc';

    var History = window.History;

    var lastSearchVal = '';
    var lastPageSelected = 1;
    var searchTimeout = false;

    var $widget_list_container = $('#widget_list_container');

    $(window).on('statechange', function() {
        var State = History.getState();

        // Set the CSS of the browse overlay based on what the current
        // action is
        $('#browse_overlay').css({top: 60});
        if (State.data.sort) {
            var top = $('#sort_by').position().top + $('#sort_by').height() + 5;
            $('#browse_overlay').css({top: top});
        }

        $('#browse_overlay').css({height: '100%'});
        if (State.data.page) {
            var height = $('#browse').height() - ($('#browse').height() - $('.pagination').position().top) - parseInt($('#browse_overlay').css('top'), 10);
            $('#browse_overlay').css({height: height});
        }
        $('#browse_overlay').show();

        if (State.url !== document.location) {
            $.ajax({
                url: State.url,
                success: function(data) {
                    var isCurrentPage = !State.data.page || State.data.page == lastPageSelected;
                    var isCurrentSearch = !State.data.q || State.data.q === lastSearchVal;
                    if (isCurrentSearch && isCurrentPage) {
                        $('#browse_overlay').hide();
                        $('#browse_results').html(data);
                    }
                }
            });
        }
    });

    var doSearchAndSort = function(e) {
        var $selection = $('#sort_by option:selected');
        var sort_by = $selection.attr('data-sortby') || DEFAULT_SORT;
        var direction = $selection.attr('data-direction') || DEFAULT_DIR;
        var query = $.trim($('#searchbox_input').val());
        var url = '';
        var state = {
            s: sort_by,
            d: direction
        };
        if (sort_by !== DEFAULT_SORT || direction !== DEFAULT_DIR) {
            url += '&s=' + sort_by;
            url += '&d=' + direction;
        }
        if (query !== '') {
            url += '&q=' + query;
            state['q'] = query;
        }
        if (e) {
            state['sort'] = true;
        }
        if (url.length) {
            url = '?' + url.substring(1,url.length);
        } else {
            url = document.location.pathname;
        }
        History.pushState(state, document.title, url);
        return false;
    };

    var clearSearch = function(e) {
        if (e.clientX && $.trim($('#searchbox_input').val())) {
            $('#searchbox_input').val('');
            doSearchAndSort();
        }
        return false;
    };

    var liveSearch = function(e) {
        var val = $.trim($('#searchbox_input').val());
        if (e.which !== $.ui.keyCode.SHIFT && val !== lastSearchVal) {
            $('#browse_overlay').css({
                top: 60,
                height: '100%'
            });
            $('#browse_overlay').show();
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
        if (History.getState().data.page !== page) {
            state['page'] = page;
            lastPageSelected = page;
            History.pushState(state, document.title, url);
        }
        return false;
    };

    var handleNavigationClick = function() {
        $('#searchbox_input').val('');
        var url = $(this).attr('href');
        var title = TITLE_BASE;
        if (url !== '/browse') {
            title +=  ' - ' + $(this).text();
        }
        $('#lhnavigation_container .selected').removeClass('selected');
        $(this).parents('li').addClass('selected');
        var state = {
            category: url.replace('/browse', '')
        };
        History.pushState(state, title, url);
        return false;
    };

    var add_bindings = function() {
        $('.wl-page-container').on('change', '#sort_by', doSearchAndSort);
        $('#browse').on('click', '.searchbox_remove', clearSearch);
        $('#browse').on('keyup', '#searchbox_input', liveSearch);
        $('.browse #lhnavigation_container').on(
            'click',
            'a',
            handleNavigationClick);
        $('#browse').on('click', '.pagination a', handlePaginationClick);
    };

    var init = function() {
        add_bindings();
    };

    init();

});
