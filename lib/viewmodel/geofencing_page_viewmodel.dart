import 'dart:async';
import 'package:Setel_Test_Assignment/locator.dart';
import 'package:Setel_Test_Assignment/logger.dart';
import 'package:Setel_Test_Assignment/service/geofence.dart';
import 'package:Setel_Test_Assignment/service/location_service.dart';
import 'package:Setel_Test_Assignment/util/router.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class GeofencingPageViewModel extends BaseViewModel {
  GeofencingService _geofencingService;
  final log = getLogger('GeofencingPageViewModel');
  
  GeofencingPageViewModel(LocationData centerPoint, int radius, String ssid) {
    _geofencingService = GeofencingService(centerPoint: centerPoint, radius: radius, ssid: ssid);
    _geofencingService.addListener(notifyListeners);
  }

  LocationData get location => _geofencingService.currentLocation;
  String get ssid => _geofencingService.currentSSID;
  double get distance => _geofencingService.distance;
  bool get inArea => _geofencingService.inArea;

  Future<bool> quitGeofence() async {
    var response = await locator<DialogService>().showConfirmationDialog(
      title: 'Quit Program',
      confirmationTitle: 'Quit',
      description: 'Are you sure you wanna quit?'
    );
    return response.confirmed;
  }

  @override
  void dispose() {
    _geofencingService.removeListener(notifyListeners);
    _geofencingService.dispose();
    super.dispose();
  }
}