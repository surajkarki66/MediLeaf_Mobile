import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:medileaf/services/connectivity_service.dart';

enum ConnectivityStatus { connected, disconnected }

class AppState with ChangeNotifier {
  ConnectivityStatus _connectivityStatus = ConnectivityStatus.disconnected;
  String? _modelStatus;

  String get modelStatus => _modelStatus!;

  set modelStatus(String status) {
    _modelStatus = status;
    notifyListeners();
  }

  AppState() {
    initConnectivity();
  }

  void initConnectivity() {
    final connectivityService = ConnectivityService();
    connectivityService.connectivityStream.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _connectivityStatus = ConnectivityStatus.disconnected;
      } else {
        _connectivityStatus = ConnectivityStatus.connected;
      }
      notifyListeners();
    });
  }

  ConnectivityStatus get connectivityStatus => _connectivityStatus;
}
