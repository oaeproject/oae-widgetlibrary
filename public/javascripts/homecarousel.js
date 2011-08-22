var homeCarouselContainer = "#widgetlibrary_carousel";
var homeCarousel = "ul#widgetlibrary_homecarousel";
var homeCarouselNavItem = ".widgetlibrary_homecarousel_navitem";
var stopped = false;

var showSelectedArrow = function(index){
    $("#carousel_choice_arrow_" + (index.last)).animate({"opacity":"show"}, 500);
};

var handleArrows = function(index){
    $(".carousel_choice_arrow:visible").animate({"opacity":"hide"}, 500, showSelectedArrow(index));
};

var addNavigationBinding = function(carousel){

    $(homeCarouselContainer).css("visibility", "visible");

    $(homeCarouselNavItem).click(function(){
        var index = $(this).data("carousel-index");
        carousel.scroll(index);
        carousel.stopAuto();
        stopped = true;
    });

    carousel.clip.hover(function() {
        carousel.stopAuto();
    }, function() {
        if(!stopped){
            carousel.startAuto();
        }
    });

    carousel.clip.click(function() {
        stopped = true;
        carousel.stopAuto();
    });
};

var addBinding = function(){
    $(homeCarousel).jcarousel({
        auto: 10,
        animation: "slow",
        scroll: 1,
        wrap: 'last',
        initCallback: addNavigationBinding,
        itemVisibleInCallback: handleArrows 
    });
};

$(document).ready(addBinding);