import 'package:connectivity_plus/connectivity_plus.dart';

/// Interface to check network connectivity
abstract class NetworkInfo {
  /// Returns true if the device is connected to the internet
  Future<bool> get isConnected;
}

/// Implementation of [NetworkInfo] using connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  /// Creates a new NetworkInfoImpl
  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
