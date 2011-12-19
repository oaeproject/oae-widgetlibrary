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
};

var init = function(){
    addBinding();
};

init();