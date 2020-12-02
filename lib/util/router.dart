import 'package:Setel_Test_Assignment/main.dart';
import 'package:Setel_Test_Assignment/view/screen/geofencing_page.dart';
import 'package:Setel_Test_Assignment/view/screen/google_map_page.dart';
import 'package:Setel_Test_Assignment/view/screen/undefined_page.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class GeofencingArguments {
  final LocationData centerPoint;
  final int radius;
  final String ssid;
  // final int selection;

  GeofencingArguments({@required this.centerPoint, @required this.radius, @required this.ssid});
}

// Route<dynamic> loginPage = MaterialPageRoute(builder: (context) => LoginScreen());

// handle all routing here
Route<dynamic> generateRoute(RouteSettings settings) {
  // ModalRoute.of(context).settings.arguments
  switch (settings.name) {
    case RouteName.wifi:
      return MaterialPageRoute(builder: (context) => MyHomePage(), settings: settings);
    case RouteName.map:
      return MaterialPageRoute(builder: (context) => GoogleMapPage(), settings: settings);
    case RouteName.geofence:
      GeofencingArguments args = settings.arguments as GeofencingArguments;
      return MaterialPageRoute(builder: (context) => GeofencingPage(centerPoint: args.centerPoint, radius: args.radius, ssid: args.ssid,), settings: settings);

    // default:
    //   throw UnsupportedError('Unknown route: ${settings.name}');

    default:
      return MaterialPageRoute(
        builder: (context) => UndefinedPage(
          name: settings.name,
        )
      );
  }
}

class RouteName {
  static const String wifi = '/wifi';
  static const String map = '/map';
  static const String geofence = '/geofence';
}