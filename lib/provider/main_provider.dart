import 'package:flutter/foundation.dart';

class MainProvider extends ChangeNotifier{
  bool _delayed = false;

  bool get delayed => _delayed;


  Future<void> delayTime() async {

    await Future.delayed(Duration(seconds: 5));

    _delayed = true;

    notifyListeners();

  }

}