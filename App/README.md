# transitway
Transitway is an app that assists with public transport by providing accurate estimates as well as the exact location of transport. Transitway also processes payments to provide ticket and pass purchase service.

The app was developed with the Flutter framework, a cross-platform toolset created by Google. Flutter enables the development of high-performance mobile, web and desktop apps using the same code base. The app uses various technologies and libraries for its functionality:

- Flutter: The Flutter SDK provides UI components, tools, and APIs for developing native interfaces. It uses the Dart programming language and adopts a reactive and declarative model.

- Google Maps Flutter: The integration of Google maps into the application is done with the google_maps_flutter package. This Flutter plugin allows interactive map display, customization of markers, polylines and more. It also provides functionality for interacting with users and obtaining location data.

- Provider: The Provider library is used for state management in the application. It implements the Provider model, allowing data to be shared and updated in different parts of the application.

- Geolocator: The geolocator package is used to obtain the current location of the device. It provides a simple API to retrieve latitude, longitude and other location related information. Geolocator abstracts platform-specific location services, making it easy to access location data on both Android and iOS.

- Geocoding: The geocoding package is used to convert addresses to geographic coordinates and vice versa. It allows the app to perform geocoding and reverse geocoding operations required for functions such as location search and displaying markers on the map.

- Dart Streams: Flutter uses Dart's built-in Streams to manage asynchronous events and data streams. In the application, streams are used to retrieve position updates from the Geolocator package and update the map view accordingly.

Overall, the app combines the power of the Flutter UI tools with libraries such as google_maps_flutter, provider, geolocator and geocoding to create an interactive and feature-rich app for public transport. Using these technologies, the app provides functionality such as map display, route calculation, user location retrieval and location search, providing a seamless user experience across all platforms.
