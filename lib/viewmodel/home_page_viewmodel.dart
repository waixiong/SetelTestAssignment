import 'dart:async';
import 'package:Setel_Test_Assignment/locator.dart';
import 'package:Setel_Test_Assignment/logger.dart';
import 'package:Setel_Test_Assignment/service/connection_service.dart';
import 'package:Setel_Test_Assignment/service/location_service.dart';
import 'package:Setel_Test_Assignment/util/router.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomePageViewModel extends BaseViewModel {
  LocationService _locationService = locator<LocationService>();
  ConnectionService _connection = locator<ConnectionService>();
  String get ssid => _connection.currentSSID;
  final log = getLogger('HomePageViewModel');
  
  StreamSubscription _wifiStream;
  // List<StreamSubscription> _serviceListeners = [];

  LocationData get position => _locationService.savedPosition;

  int _radius = 30; // in meters
  int get radius => _radius;

  init() {
    _locationService.addListener(() {
      log.i('_locationService notify');
      notifyListeners();
    });
    _connection.addListener(() {
      log.i('_connection notify');
      notifyListeners();
    });
    // _locationService.requestPermision();
    _wifiStream = _connection.ssidStream.listen((event) {
      notifyListeners();
    });
  }

  Future<void> changeGeoPosition() async {
    locator<NavigationService>().navigateTo(RouteName.map);
  }

  Future<void> changeWifi() async {
    locator<SnackbarService>().showSnackbar(message: 'Change your Wi-Fi through setting');
    // locator<NavigationService>().navigateTo(RouteName.wifi);
  }

  Future<void> changeRadius(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        TextEditingController _radiusValue = TextEditingController()..text = _radius.toString();
        GlobalKey<FormState> _formKey = GlobalKey<FormState>();
        return SimpleDialog(
          title: Text('Radius'),
          contentPadding: EdgeInsets.fromLTRB(10, 12, 10, 16),
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Radius in meters'
                ),
                controller: _radiusValue,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if(value.isEmpty) return 'Value must be a positive integers';
                  int r = int.tryParse(value);
                  if(r == null) return 'Value must be a positive integers';
                  if(r <= 0) return 'Value must be a positive integers';
                  return null;
                },
              ),
            ),
            Row(
              children: [
                Expanded(child: SizedBox(),),
                RaisedButton(
                  onPressed: () {
                    if(_formKey.currentState.validate()) {
                      _radius = int.tryParse(_radiusValue.text);
                      Navigator.of(context).pop();
                      notifyListeners();
                    }
                  },
                  child: Text('Apply Radius'),
                )
              ],
            )
          ],
        );
      }
    );
  }

  Future<void> startGeofence() async {
    if(!_locationService.permissionStatus) {
      return locator<SnackbarService>().showSnackbar(message: 'Location service permission is required for furthur action');
    }
    if(!_locationService.enable) {
      return locator<SnackbarService>().showSnackbar(message: 'Enable location service for furthur action');
    }
    if(position == null) {
      return locator<SnackbarService>().showSnackbar(message: 'Cannot obtain center point');
    }
    locator<NavigationService>().navigateTo(RouteName.geofence, arguments: GeofencingArguments(centerPoint: position, radius: _radius, ssid: ssid));
  }

  @override
  void dispose() {
    _wifiStream.cancel();
    super.dispose();
  }
}