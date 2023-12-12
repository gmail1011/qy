import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Page;

import 'door_page/page.dart';

Widget createApp() {
  final AbstractRoutes routes = PageRoutes(
    pages: <String, Page<Object, dynamic>>{
    "mainindex": DoorPage()
    }
  );

  return MaterialApp(
    title: 'FishDemo',
    home: routes.buildPage("mainindex", null),
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    onGenerateRoute: (RouteSettings settings) {
      return MaterialPageRoute<Object>(builder: (BuildContext context) {
        return routes.buildPage(settings.name, settings.arguments);
      });
    },
  );
}
