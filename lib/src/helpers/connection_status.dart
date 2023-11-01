import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionStatusSingleton {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectionStatusSingleton _singleton =
      ConnectionStatusSingleton._internal();
  ConnectionStatusSingleton._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionStatusSingleton getInstance() => _singleton;

  //This tracks the current connection status
  bool hasConnection = false;

  //flutter_connectivity
  final Connectivity _connectivity = Connectivity();

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    // connectivity has changed its state
    checkConnection();
  }

  //The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    try {
      // var connectivityResult = await (Connectivity().checkConnectivity());
      // if (connectivityResult == ConnectivityResult.wifi ||
      //     connectivityResult == ConnectivityResult.mobile) {
      //   hasConnection = true;
      // } else {
      //   hasConnection = false;
      // }

      // ------ good approach to check connectivity --------
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (e) {
      print("Connection State Socket Exception: $e");
      hasConnection = false;
    }

    return hasConnection;
  }
}
