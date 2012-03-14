//= require sdk/widgetbuilder

$(function() {

    // Disabling these for now
    // var showVideoOverlay = function(){
    //     $("#videocontent_overlay_container").css("margin-left", $(window).width() / 2 - 325);
    //     $("#videocontent_overlay_container").css("margin-top", $(window).height() / 2 - 187);
    //     $("#videocontent_overlay").animate({opacity:'toggle'}, 500, function(){
    //         $("#videocontent_overlay_container").animate({opacity:'toggle'}, 500);
    //     });
    // };
    //
    // var hideVideoOverlay = function(){
    //     $("#videocontent_overlay_container").animate({opacity:'toggle'}, 300, function(){
    //         $("#videocontent_overlay").animate({opacity:'toggle'}, 300);
    //     });
    // };

    var TITLE_BASE = 'Sakai OAE Widget Library - SDK';
    var History = window.History;
    var $lhnav = $(".wl-content-container #lhnavigation_container ul");

    var updateLhnav = function(state){
        $(".selected", $lhnav).removeClass("selected");
        $(".selected_parent", $lhnav).removeClass("selected_parent");
        $(".subnav", $lhnav).hide();

        var $toSelectElement = $("[href='" + state.data.section + "']");
        var $parentElement = $toSelectElement.closest(".subnav");

        // Check whether the element is a parent element or not
        if($parentElement.length){
            // it is a child element
            $toSelectElement.closest("li").addClass("selected");
            $parentElement.show().prev().addClass("selected_parent");
        } else {
            $toSelectElement.closest("li").addClass("selected").next().show();
        }
    };

    $(window).on('statechange', function() {
        var state = History.getState();
        // Update the left hand navigation
        updateLhnav(state);
        $.ajax({
            url: state.url,
            success: function(data) {
                var $containerResponse = $("<div />").html(data);
                var $sdkxhrContent = $containerResponse.find("#sdkxhr_content");
                $(".wl-content-container .widgetsdk_container").html($sdkxhrContent);
                prettyPrint();
            },
            error: function(){
                // If the ajax request wouldn't succeed, we'll reload the page
                window.location.reload();
            }
        });
    });

    var addBinding = function(){
        // $("#developer_videocontent_container").live("click", showVideoOverlay);
        // $("#videocontent_overlay").live("click", hideVideoOverlay);
        $(".expand_all_link").live("click", function(){
            var expanded = $(".expand_all_link").attr("data-expanded");
            if(expanded === "true"){
                $(".expand_all_link").attr("data-expanded", "false");
            }else{
                $(".expand_all_link").attr("data-expanded", "true");
            }
            $(this).children("span").toggle();
            $.each($(".expandable_container"), function(i, container){
                container = $(container);
                if(container.is(":visible") && expanded === "true"){
                    container.animate({'height': 'toggle', 'opacity': 'toggle'}, 500);
                    container.prevAll("h3").children("a").attr("data-expanded", false);
                    container.prevAll("h3").find("span").toggle();
                } else if(!container.is(":visible")  && expanded !== "true"){
                    container.animate({'height': 'toggle', 'opacity': 'toggle'}, 500);
                    container.prevAll("h3").children("a").attr("data-expanded", true);
                    container.prevAll("h3").find("span").toggle();
                }
            });
        });

        $(".expand_link").live("click", function(){
            $(this).children("span").toggle();
            var $container = $(this).parents(".wl-widget-item").children(".expandable_container");
            if ($container.is(":visible")){
                $container.prevAll("h3").children("a").attr("data-expanded", false);
                $container.animate({'height': 'toggle'}, 500);
            } else {
                $container.prevAll("h3").children("a").attr("data-expanded", true);
                $container.animate({'height': 'toggle'}, 500);
            }
        });

        $("body").on("click", '#lhnavigation_container a, .wl-content-container .wl-content-right-container a[href^="/sdk/"]', function(evt){
            // Disable the default click behavior
            evt.preventDefault();
            // Cache the this selector
            var $this = $(this);
            var url = $this.attr("href");
            var title = TITLE_BASE + ' - ' + $this.text();
            var state = {
                section: url
            };
            History.pushState(state, title, url);
        });

    };

    var init = function(){
        addBinding();
    };

    init();

});
