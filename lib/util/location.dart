import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

LocationData latlng2Position(LatLng latlng) {
  return LocationData.fromMap({
    'latitude': latlng.latitude,
    'longitude': latlng.longitude,
  });
}

LatLng position2LatLng(LocationData latlng) {
  return LatLng(latlng.latitude, latlng.longitude,);
}