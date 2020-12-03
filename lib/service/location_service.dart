import 'dart:async';
import 'dart:math' as math;
import 'package:Setel_Test_Assignment/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as PermissionHandler;

class LocationService extends ChangeNotifier {
  Location _geolocator;
  bool get permissionStatus => _permissionStatus;
  bool _permissionStatus = false;
  bool get enable => _enable;
  bool _enable = false;
  StreamSubscription _locationStreamSub;

  final log = getLogger('LocationService');

  LocationData _savedPosition;
  LocationData get savedPosition => _savedPosition;

  LocationService() {
    _geolocator = Location.instance;
    _geolocator.changeSettings(accuracy: LocationAccuracy.high);
    _init();
  }
  

  Future<void> _init() async {
    log.i('init');
    await requestPermision();
    log.i('Permission: $_permissionStatus');
    if(_permissionStatus) {
      _enable = await _geolocator.serviceEnabled();
      if(!_enable) {
        _enable = await _geolocator.requestService();
      }
      log.i('Enabled: $_enable');
      _locationStreamSub = _geolocator.onLocationChanged.listen((event) async {
        // log.i('(onLocationChanged) $event');
        if(!enable) {
          // detect service changes
          _enable = await _geolocator.serviceEnabled();
          _savedPosition = await _geolocator.getLocation();
          notifyListeners();
        }
      });
      if(enable) {
        _savedPosition = await _geolocator.getLocation();
        log.i(savedPosition);
      }
      notifyListeners();
    }
  }

  Future<LocationData> get position => _geolocator.getLocation();
  Stream<LocationData> get positionStream => _geolocator.onLocationChanged;

  Future<bool> requestPermision() async {
    var permission = await PermissionHandler.Permission.locationAlways.status;//await _geolocator.hasPermission();
    if(permission != PermissionStatus.granted && permission != PermissionStatus.grantedLimited) {
      // permission = await _geolocator.requestPermission();
      permission = await PermissionHandler.Permission.locationAlways.request();
    }
    log.i(permission);
    _permissionStatus = (permission == PermissionHandler.PermissionStatus.granted);
    return _permissionStatus;
  }

  void setLocation(LocationData location) {
    _savedPosition = location;
    notifyListeners();
  }

  static double getDistanceBetweenGPSPoints(LocationData from, LocationData to) {
    var p = math.pi / 180;
    var a = 0.5 -
        math.cos((to.latitude - from.latitude) * p) / 2 +
        math.cos(from.latitude * p) *
            math.cos(to.latitude * p) *
            (1 - math.cos((to.longitude - from.longitude) * p)) /
            2;
    double distance = 12742000 * math.asin(math.sqrt(a));
    return distance;
  }

  @override
  void dispose() {
    _locationStreamSub.cancel();
    super.dispose();
  }
}