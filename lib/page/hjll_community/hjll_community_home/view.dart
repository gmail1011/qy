import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/hjll_community/hjll_community_child/page.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_page.dart';
import 'package:flutter_app/widget/HjllPublishPostViewWidget.dart';
import 'package:flutter_app/widget/HjllSearchAction.dart';
import 'package:flutter_app/widget/HjllSearchWIdget.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:get/route_manager.dart' as Gets;
import '../../../app.dart';
import 'state.dart';


///影视-长视频
Widget buildView(
    HjllCommunityHomeState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: Dimens.pt40,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title:HjllSearchWidget(),
        actions: [
          HjllSearchButton(isCommunity: true),
        ],
      ),
      body:Stack(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 12),
                color: Colors.black,
                child: commonTabBar(
                  TabBar(
                    controller: state.tabController,
                    tabs: Config.communityDataTags
                        .map(
                          (e) => Container(
                        alignment: Alignment.center,
                        height: Dimens.pt38,
                        child: Text(e.moduleName),
                      ),
                    ).toList(),
                    indicator: RoundUnderlineTabIndicator(
                      borderSide: BorderSide(color: Color(0xffca452e), width: 3),
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    unselectedLabelColor: Color.fromRGBO(153, 153, 153, 1),
                    unselectedLabelStyle: TextStyle(fontSize: Dimens.pt16),
                    labelColor: Color(0xffca452e),
                    isScrollable: true,
                    labelStyle: TextStyle(fontSize: Dimens.pt18),
                    labelPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              Expanded(child:  TabBarView(
                controller: state.tabController,
                children: Config.communityDataTags.map(
                      (e) =>  KeepAliveWidget(HjllCommunityChild().buildPage({"videoName": e.moduleName,"sectionID":e.id})),
                ).toList(),
              ),)
            ],
          ),
          Positioned(
           right: 17,
           bottom: 15,
           child: GestureDetector(
           onTap: (){
               return showModalBottomSheet(
                   context: viewService.context,
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.only(
                         topLeft: Radius.circular(Dimens.pt17),
                         topRight: Radius.circular(Dimens.pt17),
                       )),
                   isScrollControlled: true,
                   builder: (BuildContext context) {
                     return SizedBox(
                       height: screen.screenHeight * 0.21,
                       child: HjllPublishPostViewWidget(),
                     );
                   });
            },
            child: Image.asset("assets/weibo/ic_publish_post.png",width: 46,height: 46,),
          ))
        ],
      ),
    ),
  );
}
