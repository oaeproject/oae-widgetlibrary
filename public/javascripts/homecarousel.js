var homeCarouselContainer = "#widgetlibrary_carousel";
var homeCarousel = "#widgetlibrary_homecarousel";
var carouselChoice = ".carousel_choice";
var carouselChoiceArrow = ".carousel_choice_arrow";

var showSelectedArrow = function(){
    $(carouselChoice + ".current").find(carouselChoiceArrow).animate({"opacity":"show"}, 500);
};

var hidePrevArrow = function(){
    $(carouselChoiceArrow + ":visible").animate({"opacity":"hide"}, 500);
};

var addBinding = function(){
    $(homeCarousel).slides({
        preload: true,
        generateNextPrev: false,
        generatePagination: false,
        slideSpeed: 800,
        hoverPause: true,
        pause: 2500,
        play: 10000,
        animationStart: hidePrevArrow,
        animationComplete: showSelectedArrow
    });
    showSelectedArrow();
    $(homeCarousel).css("visibility", "visible");
};

$(document).ready(addBinding);