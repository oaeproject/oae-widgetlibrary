/*!
 * Copyright 2012 Sakai Foundation (SF) Licensed under the
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

        // Cache the widget container
        var $rootel = $('#' + uid);

        /**
         * Initialize this <%= @file_name %> widget
         */
        var init = function() {
            var profile1 = {firstname: "John", lastname: "Doe", email: "john.doe@johndoe.com", gender: "male"};
            var profile2 = {firstname: "Jane", lastname: "Doe", email: "jane.doe@janedoe.com", gender: "female"};
            var profile3 = {firstname: "John", lastname: "Smith", email: "john.smith@johnsmith.com", gender: "male"};
            var profile4 = {firstname: "Ivan", lastname: "Petrov", email: "ivan.petrov@ivanpetrov.com", gender: "male"};
            var profile5 = {firstname: "Ivan", lastname: "Horvat", email: "ivan.Horvat@ivanhorvat.com", gender: "male"};
            var profile6 = {firstname: "Jan", lastname: "Novak", email: "jan.novak@jannovak.com", gender: "male"};
            var profile7 = {firstname: "Jens", lastname: "Hansen", email: "jens.hansen@jenshansen.com", gender: "male"};
            var profile8 = {firstname: "Jan", lastname: "Janssen", email: "jan.janssen@janjanssen.com", gender: "male"};
            var profile9 = {firstname: "Pieter", lastname: "Pietersen", email: "pieter.pietersen@pieterpietersen.com", gender: "male"};
            var profile10 = {firstname: "Jean", lastname: "Dupont", email: "jean.dupont@jeandupont.com", gender: "male"};
            var profile11 = {firstname: "Jane", lastname: "Smith", email: "jane.smith@janesmith.com", gender: "female"};
            var profile12 = {firstname: "Marjan", lastname: "Devos", email: "marjan.devos@marjandevos.com", gender: "female"};

            var profiles = [];

            profiles.push(profile1, profile2, profile3, profile4, profile5, profile6, profile7, profile8, profile9, profile10, profile11, profile12);

        	oae.api.util.template().render('#<%= @file_name %>-template', {"profiles": profiles}, $('#<%= @file_name %>-container'));
        };

        init();
    };
});
