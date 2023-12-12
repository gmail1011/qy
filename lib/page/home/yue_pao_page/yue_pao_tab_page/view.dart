import 'package:extended_tabs/extended_tabs.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/page/home/yue_pao_page/yue_pao_index_tab_view_page/page.dart';
import 'package:flutter_app/widget/YYMarquee.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'state.dart';

Widget buildView(
    YuePaoTabState state, Dispatch dispatch, ViewService viewService) {


  Widget bannerWidget = ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(6)),
    child: AdsBannerWidget(
      state.adsList,
      width: Dimens.pt360,
      //height: Dimens.pt250,
      height: Dimens.pt154,
      onItemClick: (index) {
        var ad = state.adsList[index];
        JRouter().handleAdsInfo(ad.href, id: ad.id);
        /*eagleClick(state.selfId(),
            sourceId: state.eagleId(viewService.context),
            label: "banner(${ad?.id ?? ""})");*/
      },
    ),
  );

  return NestedScrollView(
    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
      return <Widget>[

        SliverAppBar(
          //floating: true,
          // snap: true,
          pinned: false,
          // stretch: true,
          automaticallyImplyLeading: false,
          expandedHeight: Dimens.pt170,
          flexibleSpace: FlexibleSpaceBar(
            // title: contain,
            background: StatefulBuilder(
              builder: (contexts, setStates) {
                return Container(margin: EdgeInsets.only(left: Dimens.pt10,right: Dimens.pt10,top: Dimens.pt8,),child: bannerWidget);
              },
            ),
          ),
        ),

      ];
    },
    body: Column(
      children: [

        SizedBox(height: Dimens.pt6,),

        Container(
          height: Dimens.pt24,
          color: Color.fromRGBO(242, 210, 158, 1),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: Dimens.pt28,
                  right: Dimens.pt18,
                ),
                child: YYMarquee(
                    Text(
                        state.announce == null
                            ? " "
                            : state.announce.toString(),
                        style: TextStyle(
                          fontSize: Dimens.pt12,
                          color: Color.fromRGBO(
                              255, 0, 0, 1),
                        )),
                    200,
                    new Duration(seconds: 5),
                    230.0, keyName: "yue_pao"),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: Dimens.pt10,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    "assets/images/laba_vip.png",
                    width: Dimens.pt16,
                    height: Dimens.pt16,
                  ),
                ),
              ),
            ],
          ),
        ),


        Container(
          margin: EdgeInsets.only(
            top: Dimens.pt8,
            left: AppPaddings.appMargin,
            right: AppPaddings.appMargin,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(Dimens.pt4),
          ),
          height: Dimens.pt28,
          alignment: Alignment.centerLeft,
          child: TabBar(
            isScrollable: true,
            controller: state.tabController,
            tabs: Lang.YUE_PAO_TWO_TABS
                .map(
                  (e) => Text(
                e,
                style: TextStyle(fontSize: Dimens.pt12),
              ),
            )
                .toList(),
            indicator: RoundUnderlineTabIndicator(
              borderSide: BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
            labelPadding: EdgeInsets.symmetric(horizontal: Dimens.pt10),
          ),
        ),
        Expanded(
          child: ExtendedTabBarView(
            controller: state.tabController,
            children: [
              YuePaoIndexTabViewPage()
                  .buildPage({'pageTitle': state.pageTitle, 'pageType': 0}),
              YuePaoIndexTabViewPage()
                  .buildPage({'pageTitle': state.pageTitle, 'pageType': 1}),
            ],
          ),
        ),
      ],
    ),
  );
}
