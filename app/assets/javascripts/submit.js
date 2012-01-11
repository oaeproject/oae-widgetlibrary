//= require submit/newversion

$(function() {
    // Reset all the errors on a new submit of the form
    $("#new_version").on("submit", WL.reset_errors);
});
