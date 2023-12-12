import 'package:flutter/cupertino.dart';
import 'package:flutter_app/new_page/welfare/SpecialWelfareView.dart';
import 'package:flutter_app/new_page/welfare/welfare_home_page.dart';
import 'package:flutter_app/page/search/search_page/page.dart';
import 'package:get/route_manager.dart' as Gets;

class HjllSearchButton extends StatelessWidget {
  final bool isCommunity;

  const HjllSearchButton({Key key, this.isCommunity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Gets.Get.to(() =>  SpecialWelfareViewPage(1), opaque: false);
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Image.asset(isCommunity == true ?  "assets/images/hjll_into_free_task_two.png" : "assets/weibo/hjll_into_free_task.png",width: 43,height: 32,),
      ),
    );
  }
}
