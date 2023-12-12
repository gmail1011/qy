import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class loufengState implements Cloneable<loufengState> {
  InAppWebViewController webView;
  bool isLoading = true;
  bool isFirstLoad = true;
  @override
  loufengState clone() {
    return loufengState()
      ..webView = webView
      ..isFirstLoad = isFirstLoad
      ..isLoading = isLoading;
  }
}

loufengState initState(Map<String, dynamic> args) {
  return loufengState();
}
