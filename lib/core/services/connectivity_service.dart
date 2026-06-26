import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../network/network.dart';

//connectivity service class -- it will check that connectivity is available or not

class ConnectivityService {
  final NetworkInfo _networkInfo;
  late final StreamController<bool> _connectionController;

  ConnectivityService(this._networkInfo) {
    _connectionController = StreamController<bool>.broadcast();
    _networkInfo.onConnectivityChanged.listen((results) {
      final isConnected = !results.contains(ConnectivityResult.none);
      _connectionController.add(isConnected);
    });
  }

  Future<bool> get isConnected => _networkInfo.isConnected;

  Stream<bool> get connectionStream => _connectionController.stream;

  void dispose() {
    _connectionController.close();
  }
}
