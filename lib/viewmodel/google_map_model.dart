import 'package:Setel_Test_Assignment/service/location_service.dart';
import 'package:Setel_Test_Assignment/util/location.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../service/connection_service.dart';
import '../locator.dart';
import '../logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class GoogleMapModel extends BaseViewModel {
  LocationService _locationService = locator<LocationService>();
  final DialogService _dialogService = locator<DialogService>();
  final ConnectionService _conenction = locator<ConnectionService>();
  final log = getLogger('GoogleMapModel');

  LocationData get position => _position;
  LocationData _position;

  List<Marker> _allMarkers = [];
  GoogleMapController _mapController;

  List<Marker> get allMarkers => _allMarkers;
  String _address;
  String get address => _address;

  GoogleMapModel() {
    _position = _locationService.savedPosition;
    if(position == null) {
      getCurrentPosition();
    } else {
      setCurrentPosition(position);
    }
  }

  void moveCameraToMarker() {
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(position2LatLng(position), 17.0));
  }

  Future<void> getCurrentPosition() async {
    _position = await _locationService.position;

    setBusy(true);
    _allMarkers.clear();

    _allMarkers.add(
      Marker(
        markerId: MarkerId('SetPosition'),
        position: position2LatLng(position),
        onTap: () {
          _mapController
              .animateCamera(CameraUpdate.newLatLngZoom(position2LatLng(position), 17.0));
        },
        draggable: true,
        onDragEnd: (latlng) => _setCurrentPosition(latlng2Position(latlng))
      ),
    );
    setBusy(false);

    notifyListeners();
  }

  _setCurrentPosition(LocationData newPos) async {
    _position = newPos;
    notifyListeners();
  }

  Future<void> setCurrentPosition(LocationData position) async {
    setBusy(true);
    _allMarkers.clear();

    _allMarkers.add(
      Marker(
        markerId: MarkerId('SetPosition'),
        position: position2LatLng(position),
        onTap: () {
          _mapController
              .animateCamera(CameraUpdate.newLatLngZoom(position2LatLng(position), 17.0));
        },
        draggable: true,
        onDragEnd: (latlng) => _setCurrentPosition(latlng2Position(latlng))
      ),
    );
    setBusy(false);

    notifyListeners();
  }

  GoogleMapController setMapController(GoogleMapController mapController) {
    return _mapController = mapController;
  }

  Future<void> saveLocationData(BuildContext context) async {
    try {
      _locationService.setLocation(position);
      clearAllMarkers();
      Navigator.pop(context);
    } catch (e) {
      //
    }
  }

  void clearAllMarkers() {
    _allMarkers.clear();
  }
}
