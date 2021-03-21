import 'package:connectivity/connectivity.dart';
import 'package:rxdart/rxdart.dart';

class NetworkingUtil {
  final networkStatus = PublishSubject<bool>();

  bool pushData = false;

  NetworkingUtil._private() {
    initLogic();
  }


  static final NetworkingUtil _instance = new NetworkingUtil._private();

  factory NetworkingUtil() => _instance;


  @override
  void initLogic() async {
    ConnectivityResult result = await (Connectivity().checkConnectivity());
    _getStatusFromResult(result);

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      switch (result) {
        case ConnectivityResult.mobile:
          networkStatus.add(true);
          pushData = false;
          break;
        case ConnectivityResult.wifi:
          networkStatus.add(true);
          pushData = false;
          break;
        case ConnectivityResult.none:
          if(!pushData){
            networkStatus.add(false);
            pushData = true;
          }
          break;
        default:
          if(!pushData){
            networkStatus.add(false);
            pushData = true;
          }
          break;
      }
    });
  }

  _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        networkStatus.add(true);
        pushData = false;
        break;
      case ConnectivityResult.wifi:
        networkStatus.add(true);
        pushData = false;
        break;
      case ConnectivityResult.none:
        if(!pushData){
          networkStatus.add(false);
          pushData = true;
        }
        break;
      default:
        if(!pushData){
          networkStatus.add(false);
          pushData = true;
        }
        break;
    }
  }
}