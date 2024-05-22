import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'main.dart';
import 'modalclass.dart';

class mirrorWallProvider with ChangeNotifier {
  ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  SearchEngine? Engine = SearchEngine.Google;
  InAppWebViewController? webViewController;

  List<BookmarkModel> bookMarkList = [];

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = (await connectivity.checkConnectivity()) as ConnectivityResult;
    } on PlatformException catch (e) {
      return;
    }

    return updateConnectionStatus(result);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus = result;
    notifyListeners();
  }

  bookMarkADD(BookmarkModel DATA) {
    bookMarkList.add(DATA);
    notifyListeners();
  }

  deleteBookMark(index) {
    bookMarkList.removeAt(index);
    notifyListeners();
  }

  bookMarkUrl(index) {
    webViewController!.loadUrl(
        urlRequest: URLRequest(url: WebUri('${bookMarkList[index].bookmark}')));
    notifyListeners();
  }

  changeEngine(value) {
    Engine = value;
    notifyListeners();
  }
}
