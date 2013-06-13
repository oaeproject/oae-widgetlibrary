/*!
 * Copyright 2013 Apereo Foundation (SF) Licensed under the
 * Educational Community License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License. You may
 * obtain a copy of the License at
 *
 *     http://www.osedu.org/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an "AS IS"
 * BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

define(['jquery', 'oae.core'], function($, oae) {

    return function(uid) {


        //////////////////////
        // WIDGET VARIABLES //
        //////////////////////

        // The widget container
        var $rootel = $('#' + uid);


        ///////////
        // VIEWS //
        ///////////

        /**
         * Says hi to the current user by rendering a template into the modal body
         */
        var sayHi = function() {
            oae.api.util.template().render($('#<%= @file_name %>-template', $rootel), null, $('.modal-body', $rootel));
        };


        /////////////
        // UTILITY //
        /////////////

        /**
         * Shows the modal dialog and calls the `sayHi` function.
         */
        var show<%= @file_name %>Modal = function() {
            $('#<%= @file_name %>-modal', $rootel).modal();
            sayHi();
        };


        ////////////////////
        // INITIALIZATION //
        ////////////////////

        /**
         * Sets up the Hello World widget
         */
        var setUp<%= @file_name %> = function() {
            // Bind to the <%= @file_name %> trigger event and show the modal dialog.
            $(document).on('oae.trigger.<%= @file_name %>', show<%= @file_name %>Modal);

            // Bind to the <%= @file_name %> click event and show the modal dialog.
            $(document).on('click', '.oae-trigger-<%= @file_name %>', show<%= @file_name %>Modal);
        };

        setUp<%= @file_name %>();
    };
});
