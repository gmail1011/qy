import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WishlistState implements Cloneable<WishlistState> {
  TabController tabBarController =
      TabController(length: 3, vsync: ScrollableState());

  @override
  WishlistState clone() {
    return WishlistState()..tabBarController = tabBarController;
  }
}

WishlistState initState(Map<String, dynamic> args) {
  return WishlistState();
}
