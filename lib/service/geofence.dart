import 'dart:async';
import 'package:Setel_Test_Assignment/locator.dart';
import 'package:Setel_Test_Assignment/logger.dart';
import 'package:Setel_Test_Assignment/service/connection_service.dart';
import 'package:Setel_Test_Assignment/service/location_service.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:wifi/wifi.dart';
import 'package:connectivity/connectivity.dart';

class GeofencingService extends ChangeNotifier {
  final LocationData centerPoint;
  final int radius;
  final String ssid;

  LocationData get currentLocation => _currentLocation;
  LocationData _currentLocation;
  String get currentSSID => _currentSSID;
  String _currentSSID;
  double get distance => _distance;
  double _distance;
  bool _inArea = true;
  bool get inArea => _inArea;

  StreamSubscription _locationStreamSub;
  StreamSubscription _wifiStateSub;

  GeofencingService({@required this.centerPoint, @required this.radius, this.ssid}) {
    _currentLocation = centerPoint;
    _currentSSID = ssid;
    _isInArea();
    _locationStreamSub = locator<LocationService>().positionStream.listen((event) {
      _currentLocation = event;
      _isInArea();
      notifyListeners();
    });
    _wifiStateSub = locator<ConnectionService>().ssidStream.listen((event) {
      _currentSSID = event;
      _isInArea();
      notifyListeners();
    });
  }

  bool _isInArea() {
    _distance = LocationService.getDistanceBetweenGPSPoints(centerPoint, _currentLocation);
    bool withinDistance = _distance <= radius;
    bool sameSSID = _currentSSID == ssid && ssid != null;
    _inArea = withinDistance || sameSSID;
    return withinDistance || sameSSID;
  }
}