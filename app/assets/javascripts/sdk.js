//= require sdk/widgetbuilder

$(function() {

    var showVideoOverlay = function(){
        $("#videocontent_overlay_container").css("margin-left", $(window).width() / 2 - 325);
        $("#videocontent_overlay_container").css("margin-top", $(window).height() / 2 - 187);
        $("#videocontent_overlay").animate({opacity:'toggle'}, 500, function(){
            $("#videocontent_overlay_container").animate({opacity:'toggle'}, 500);
        });
    };

    var hideVideoOverlay = function(){
        $("#videocontent_overlay_container").animate({opacity:'toggle'}, 300, function(){
            $("#videocontent_overlay").animate({opacity:'toggle'}, 300);
        });
    };

    var addBinding = function(){
        $("#developer_videocontent_container").live("click", showVideoOverlay);
        $("#videocontent_overlay").live("click", hideVideoOverlay);
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
    };

    var init = function(){
        addBinding();
    };

    init();

});
