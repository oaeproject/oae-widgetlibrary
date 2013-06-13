# OAE Widgets

A widget is a modular set of functionality that can be re-used throughout the OAE. Every widget follows the same structure and configuration. The [widget template builder](http://oae-widgets.sakaiproject.org/sdk/developwidget/widgetbuilder) provides a skeleton framework for developers to build on.

## Getting to work with widgets
### Downloading the widget skeleton framework
Go to the [widget template builder](http://oae-widgets.sakaiproject.org/sdk/developwidget/widgetbuilder) and generate either an empty skeleton framework or an example `helloworld` widget. Once downloaded and unpacked the directory can be copied to the `3akai-ux/node_modules/oae-core` directory of your installation.

### Widget structure
Each widget consists of the following structure.

- widgetID/bundles
    - widgetID/bundles/default.properties
- widgetID/css
    - widgetID/css/widgetID.css
- widgetID/js
    - widgetID/js/widgetID.js
- widgetID/widgetID.html
- widgetID/manifest.json

#### manifest.json
The `manifest.json` file is the glue that pieces together all files in the widget.

```json
{
    "i18n": {
        "default": {
            "bundle": "bundles/default.properties"
        }
    },
    "triggers": {
        "selectors": [".oae-trigger-helloworld"],
        "events": ["oae.trigger.helloworld"]
    },
    "src": "helloworld.html"
}
```

##### `i18n`
The i18n object maps all translations that are available for the widget. In this example only the `default` language is active.

##### `triggers`
There are several ways to execute a widget.

- Load the widget on page load by adding it to the core HTML pages. `e.g. <div data-widget="helloworld"></div>`
- **Lazy load** the widget when a specific `event` has been sent out `e.g. oae.trigger.helloworld`. This event needs to be caught by the widget `e.g. $(document).on('oae.trigger.helloworld', sayHi)`.
- **Lazy load** the widget when a specific selector has been clicked `e.g. .oae-trigger-helloworld`. This click event needs to be caught by the widget `e.g. $(document).on('click', '.oae-trigger-helloworld', sayHi)`.

##### `src`
`src` links to the location of the HTML source code of the widget. The HTML is usually found in the same directory as the manifest file.

#### widgetID.html
Contains the HTML snippet for the widget and links to the CSS and JavaScript that needs to be included.

#### i18n bundles
Bundles are standard `.properties` files that contain translations specific to the widget. Frequently used words and sentences are consolidated in the bundles found at `/ui/bundles/`.

#### JavaScript
The `js` folder contains a single JavaScript file that handles all logic for the widget. The basic setup is simple. [RequireJS](http://requirejs.org/) is used to load dependencies for the widget (by default at least `jquery` and `oae.core`) and return a function that will be executed.

```javascript
define(['jquery', 'oae.core'], function($, oae) {
    return function(uid) {
        // JavaScript goes in here.
    };
});
```

#### CSS
The `css` folder contains a single CSS file that handles all styles specific for the widget. A lot of reusable components are already available throughout the system so most widget CSS files have a minimal amount of custom styles defined.

Every style definition should be prefixed with the widget container to scope the style change to the widget.

```css
#helloworld-container p {
    margin: 7px 0;
}
```
