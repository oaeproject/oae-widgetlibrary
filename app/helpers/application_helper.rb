# encoding: utf-8

module ApplicationHelper
  def country_options
    default = "United Kingdom"
    options_for_select(["Afghanistan", "Albania", "Algeria", "Andorra",
       "Angola", "Antigua and Barbuda", "Antilles", "Argentina", "Armenia",
       "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain",
       "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin",
       "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana",
       "Brazil", "British Virgin Islands", "Brunei", "Bulgaria", "Burkina-Faso",
       "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde",
       "Cayman Islands", "Central African Republic", "Chad", "Channel Islands",
       "Chile", "China", "Colombia", "Comoros", "Congo", "Cook Islands",
       "Costa Rica", "Croatia", "Cuba", "Cyprus", "Czech Republic",
       "Côte d'Ivoire", "Democratic Republic of the Congo", "Denmark",
       "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador",
       "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia",
       "Ethiopia", "Faeroes", "Falkland Islands", "Fiji", "Finland", "France",
       "French Guiana", "French Polynesia", "Gabon", "Gambia", "Georgia",
       "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada",
       "Guadeloupe", "Guatemala", "Guiana", "Guinea", "Guinea-Bissau", "Haiti",
       "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia",
       "Iran", "Iraq", "Ireland", "Isle of Man", "Israel", "Italy", "Jamaica",
       "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Kuwait",
       "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya",
       "Liechtenstein", "Lithuania", "Luxemburg", "Macao", "Macedonia",
       "Madagascar", "Malawi", "Malay States", "Malaysia", "Maldives", "Mali",
       "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius",
       "Mayotte", "Melanesia", "Mexico", "Micronesia", "Micronesia", "Monaco",
       "Mongolia", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia",
       "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia",
       "New Zealand", "Nicaragua", "Niger", "Nigeria", "North Korea",
       "Northern Mariana Islands", "Norway", "Oman", "Pakistan",
       "Palau Islands", "Palestine", "Panama", "Papua New Guinea", "Paraguay",
       "Peru", "Pitcairn Island", "Poland", "Polynesia", "Portugal",
       "Puerto Rico", "Qatar", "Republic of the Philippines", "Romania",
       "Russian Federation", "Rwanda", "Réunion", "Saint Christopher-Nevis",
       "Saint Helena", "Saint Lucia", "Saint Pierre and Miquelon",
       "Saint Vincent and the Grenadines", "Samoa", "Saudi Arabia", "Senegal",
       "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia",
       "Solomon Islands", "Somalia", "South Africa", "South Korea", "Spain",
       "Sri Lanka", "Sudan", "Surinam", "Svalbard", "Swaziland", "Sweden",
       "Switzerland", "Syria", "São Tomé e Principe", "Taiwan", "Tajikistan",
       "Tanzania", "Thailand", "Togo", "Tonga", "Trinidad and Tobago",
       "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands",
       "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom",
       "United States of America", "Uruguay", "Uzbekistan", "Vanuatu",
       "Vatican City", "Venezuela", "Vietnam", "Wallis and Futuna Islands",
       "Yemen Republic", "Yugoslavia", "Zambia", "Zimbabwe"], default)
  end

  def urlize(str)
    str.downcase.gsub(" ", "-").html_safe
  end

  def custom_ago(date)
    date.strftime("%e %B")
  end
end
