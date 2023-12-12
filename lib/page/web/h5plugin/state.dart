import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class H5PluginState with EagleHelper implements Cloneable<H5PluginState> {
  String title;
  String url;
  FlutterWebviewPlugin flutterWebViewPlugin;

  @override
  H5PluginState clone() {
    return H5PluginState()
      ..url = url
      ..flutterWebViewPlugin = flutterWebViewPlugin
      ..title = title;
  }
}

H5PluginState initState(Map<String, dynamic> args) {
  return H5PluginState()
    ..flutterWebViewPlugin = FlutterWebviewPlugin()
    ..title = args["title"] ?? ""
    ..url = args["url"] ?? "";
}
