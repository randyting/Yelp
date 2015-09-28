## Yelp

This is a Yelp search app using the [Yelp API](http://developer.rottentomatoes.com/docs/read/JSON).

Time spent: 40 hours

### Features

#### Required

- [x] Search results page
   - [x] Table rows should be dynamic height according to the content height
   - [x] Custom cells should have the proper Auto Layout constraints
   - [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [x] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
   - [x] The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
   - [x] The filters table should be organized into sections as in the mock.
   - [x] You can use the default UISwitch for on/off states. Optional: implement a custom switch
   - [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
   - [x] Display some of the available Yelp categories (choose any 3-4 that you want).

#### Optional

- [x] Search results page
   - [x] Infinite scroll for restaurant results
   - [x] Implement map view of restaurant results
- [x] Filter page
   - [x] Radius filter should expand as in the real Yelp app
   - [x] Categories should show a subset of the full list with a "See All" row to expand. Category list is here: http://www.yelp.com/developers/documentation/category_list (Links to an external site.)
- [x] Implement the restaurant detail page.

#### Additional

- [x] Map uses reverse geocoding if coordinates are not available from Yelp API.
- [x] Flipping animation between map and list view.
- [x] Carousel display of information in business detail view.
- [x] List of categories grabbed directly from Yelp URL.
- [x] Filter settings persist until app is terminated.

### Notes
- App crashes when detail view for a restaurant with a accent mark in one of its characters because the Yelp API responds with an ID included an accented character.  The app crashes because a character with an accent mark placed in a URL is not a valid URL.  TODO: Figure out how to convert the ID.
- Carousel views do not have autoloyout constraints applied to them.  Flipping from horizontal to vertical or vice versa does not resize them while still in the business detail view.  TODO: Apply autolayout constraints programatically.
- FiltersViewController code is not clean semantically.  Could use some re-factoring.
- Yelp API returns reviewer information when requesting snippet information.  The intention was to show snippet image and snippet text instead of the restaurant's image and address.  Seems like a Yelp API issue.  Business detail parsing is not semantically correct because of this.  

### Walkthrough

###![Video Walkthrough](150927_Yelp_Walkthrough.gif)

Credits
---------
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [iconmonstr](http://iconmonstr.com/)
* [LiceCap](http://www.cockos.com/licecap/)
* [iCarousel](https://github.com/nicklockwood/iCarousel)
* [BDBOAuth1Manager](https://github.com/bdbergeron/BDBOAuth1Manager)

License
--------
This project is licensed under the terms of the MIT license.
