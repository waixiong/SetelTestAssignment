import 'dart:async';
import 'package:Setel_Test_Assignment/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:wifi/wifi.dart';
import 'package:connectivity/connectivity.dart';
import 'package:permission_handler/permission_handler.dart';

class ConnectionService extends ChangeNotifier {
  String _currentSSID;
  StreamSubscription<ConnectivityResult> _subscription;
  final log = getLogger('ConnectionService');

  String get currentSSID => _currentSSID;

  ConnectionService() {
    init();
  }

  StreamController<String> _ssidStreamController = StreamController<String>.broadcast();
  Stream<String> get ssidStream => _ssidStreamController.stream;

  Future<void> init() async {
    log.i('init');
    var permission = await Permission.location.request();
    log.i("Permission: $permission");
    _currentSSID = await Wifi.ssid;
    log.i("Wifi: $_currentSSID");
    _currentSSID = _currentSSID == '<unknown ssid>'? null : _currentSSID;
    _ssidStreamController.add(_currentSSID);
    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if(result == ConnectivityResult.wifi) {
        _currentSSID = await Wifi.ssid;
        log.i(_currentSSID);
      } else {
        _currentSSID = null;
        log.i('No Wifi');
      }
      _ssidStreamController.add(_currentSSID);
      notifyListeners();
    });
    notifyListeners();
  }

  Future<List<WifiResult>> getWifiList() async {
    var wifiList = await Wifi.list('');
    return wifiList;
  }

  Future<void> connect2Wifi(String ssid, String password) async {
    var status = await Wifi.connection(ssid, password);
    _currentSSID = await Wifi.ssid;
    if(status == WifiState.error)
      throw("Can't connect to this wifi");
  }

  @override
  void dispose() {
    _subscription.cancel();
    _ssidStreamController.close();
    super.dispose();
  }
}