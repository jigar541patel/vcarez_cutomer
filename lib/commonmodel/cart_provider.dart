import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  Future<int> getData() async {
    notifyListeners();
    return counter;
  }

  void setData(int intCounter) async {
    _counter = intCounter;
    notifyListeners();
    // return counter;
  }

  void addCounter() {
    _counter++;

    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    // _setPrefsItems();
    notifyListeners();
  }

  int getCounter() {
    // _getPrefsItems();
    return _counter;
  }
}
