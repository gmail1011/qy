import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/home/post/page/common_post/page.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;
import 'package:flutter_base/eagle/eagle_helper.dart';


class PayPostState with EagleHelper implements Cloneable<PayPostState> {

  int currentIndex = 0;

  List<Widget> pageList;

  List<String> tabList = [Lang.POST_PAY_UP, Lang.POST_PAY_WORK_ROOM];

  TabController vc;

  @override
  PayPostState clone() {
    return PayPostState()
      ..currentIndex = currentIndex
      ..pageList = pageList
      ..vc = vc
      ..tabList = tabList;
  }
}

PayPostState initState(Map<String, dynamic> args) {
  var type = args["type"];
  var vc = args["vc"];
  return PayPostState()
    ..vc = vc
    ..pageList =  [
      extended.NestedScrollViewInnerScrollPositionKeyWidget(
          Key('Tab30'),
        CommonPostPage().buildPage({"key":"Tab30","type":type,"subType":"0"}),
      ),

      extended.NestedScrollViewInnerScrollPositionKeyWidget(
          Key('Tab31'),
        CommonPostPage().buildPage({"key":"Tab31","type":type,"subType":"1"}),
      ),
  ]; 
}
