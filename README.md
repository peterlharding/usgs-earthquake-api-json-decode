#  Downloading USGS Data - Last Month's Earthquakes

Use this URL - https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson - to retrieve the data

I started this project as I had been working with the apple example - Loading and Displaying a Large Data Feed:

*  https://developer.apple.com/documentation/coredata/loading_and_displaying_a_large_data_feed

- for some time.  And I thought it would be neat to extend it to add map data. When I looked under the hood I discoverd that latitude and longitude were not being captured in the underlying CodeData database.  Do I started down the path of updating the application to store a large sub-set of the available data.  Of couse, not being expert at decoding JSON in SWift and not having done anything with CodeData, the learning curve was steep and so I decided to implement a few stages along the way.  As a consequence, this project is a sandbox which handles the API request and parses the returned JSON. 

Rather than do what the Apple example does and parse out only the feature component of the returned JSON, I decided to parse the entire returned payload and the extract each feature and merge the property and geometry data to build a chunk od data which could be used for mapping locations.

In the next example I plan to implement I will push this data into a CodeData store and then overlay a useful UI on it.

## More targetted Data

Here is a URL to target information for a particular period (in days):

* https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2022-07-03&endtime=2022-07-04


## Other Useful USGS API URLs

* https://earthquake.usgs.gov/earthquakes/eventpage/ak0228gox5ki
* https://earthquake.usgs.gov/fdsnws/event/1/query?eventid=ak0228gox5ki&format=geojson

