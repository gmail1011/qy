import 'package:flutter/cupertino.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/page/search/search_page/page.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:get/route_manager.dart' as Gets;


class HjllSearchWidget extends StatelessWidget {

  HjllSearchWidget();

  @override
  Widget build(BuildContext context) {
     return GestureDetector(
        onTap: () {
          Gets.Get.to(() => SearchPage().buildPage(null), opaque: false);
        },
        child: Container(
          margin: EdgeInsets.only(left: 10,right: 16),
          alignment: Alignment.centerLeft,
          child: Container(
            width: 328,
            height: 36,
            decoration: BoxDecoration(
              color: Color.fromRGBO(20, 20, 20, 1),
              borderRadius: BorderRadius.circular(21),
            ),
            child: Row(
              children: [
                SizedBox(width: 17,),
                svgAssets(AssetsSvg.IC_SEARCH,
                    height: 17,
                    width: 17,
                    color: Color.fromRGBO(110, 110, 122, 1)),
                SizedBox(width: 10,),
                Text("输入你搜索的关键字",style: TextStyle(color: Color(0xff666666),fontSize: 14),),
              ],
            ),
          ),
        )
      );
  }
}
