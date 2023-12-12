import 'package:chips_choice/chips_choice.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/page/home/AVCommentary/a_v_commentary_page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/com/public_widget.dart';
import 'package:flutter_app/page/home/discovery_tab_page/passion_novel_page/page.dart';
import 'package:flutter_app/page/tag/video_topic/page.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    DiscoveryTabState state, Dispatch dispatch, ViewService viewService) {



  int getAge() {
    if (state.selectedAge == null || state.selectedAge == "全部") {
      return 0;
    } else if (state.selectedAge == "18-25") {
      return 1;
    } else if (state.selectedAge == "26-30") {
      return 2;
    } else if (state.selectedAge == "31以上") {
      return 3;
    }
  }


  int getMaxHeight() {
    if (state.selectedHeight == null || state.selectedHeight == "全部") {
      return 0;
    } else if (state.selectedHeight == "155cm-165cm") {
      return 1;
    } else if (state.selectedHeight == "166cm-175cm") {
      return 2;
    } else if (state.selectedHeight == "176cm以上") {
      return 3;
    }
  }


  int getBust() {
    if (state.selectedBust == null || state.selectedBust == "全部") {
      return 0;
    } else if (state.selectedBust == "C") {
      return 1;
    } else if (state.selectedBust == "D") {
      return 2;
    } else if (state.selectedBust == "E") {
      return 3;
    }else if (state.selectedBust == "F") {
      return 4;
    }
  }


  return FullBg(
      child: Scaffold(
        endDrawer: StatefulBuilder(
            builder: (contexts,setStates){
              return Container(
                color: Colors.white,
                child: MediaQuery.removePadding(
                    context: viewService.context,
                    removeRight: true,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Container(
                          width: Dimens.pt290,
                          height: MediaQuery.of(viewService.context).size.height,
                          color: Colors.white,
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: Dimens.pt44,
                                ),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16),
                                    child: Text(
                                      "年龄",
                                      style: TextStyle(
                                          fontSize: Dimens.pt14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    )),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: ChipsChoice<String>.single(
                                    wrapped: true,
                                    value: state.selectedAge,
                                    onChanged: (val) {
                                      state.selectedAge = val;
                                      setStates(() {

                                      });
                                    },
                                    choiceItems:
                                    C2Choice.listFrom<String, String>(
                                      source: state.ageOptions,
                                      value: (i, v) => v,
                                      label: (i, v) => v,
                                    ),
                                    choiceStyle: C2ChoiceStyle(
                                      color: Color.fromRGBO(151, 151, 151, 1),
                                      showCheckmark: false,
                                      labelStyle: TextStyle(
                                          fontSize: Dimens.pt12,
                                          color: Color.fromRGBO(
                                              142, 142, 142, 0.7)),
                                    ),
                                    choiceActiveStyle: C2ChoiceStyle(
                                      color: Colors.red,
                                      borderColor: Colors.red,
                                      showCheckmark: false,
                                      disabledColor: Colors.red,
                                      brightness: Brightness.dark,
                                      labelStyle: TextStyle(
                                          fontSize: Dimens.pt12, color: Colors.white),
                                    ),
                                  ),
                                ),
                                Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(
                                left: 16, right: 16),
                            child: Text(
                              "身高",
                              style: TextStyle(
                                  fontSize: Dimens.pt14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            )),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: ChipsChoice<String>.single(
                            wrapped: true,
                            value: state.selectedHeight,
                            onChanged: (val) {
                              state.selectedHeight = val;
                              setStates(() {

                              });
                            },
                            choiceItems:
                            C2Choice.listFrom<String, String>(
                              source: state.heightOptions,
                              value: (i, v) => v,
                              label: (i, v) => v,
                            ),
                            choiceStyle: C2ChoiceStyle(
                              color: Color.fromRGBO(151, 151, 151, 1),
                              showCheckmark: false,
                              labelStyle: TextStyle(
                                  fontSize: Dimens.pt12,
                                  color: Color.fromRGBO(
                                      142, 142, 142, 0.7)),
                            ),
                            choiceActiveStyle: C2ChoiceStyle(
                              color: Colors.red,
                              borderColor: Colors.red,
                              showCheckmark: false,
                              disabledColor: Colors.red,
                              brightness: Brightness.dark,
                              labelStyle: TextStyle(
                                  fontSize: Dimens.pt12, color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(
                                left: 16, right: 16),
                            child: Text(
                              "罩杯",
                              style: TextStyle(
                                  fontSize: Dimens.pt14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            )),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: ChipsChoice<String>.single(
                            wrapped: true,
                            value: state.selectedBust,
                            onChanged: (val) {
                              state.selectedBust = val;
                              setStates(() {

                              });
                            },
                            choiceItems:
                            C2Choice.listFrom<String, String>(
                              source: state.bustOptions,
                              value: (i, v) => v,
                              label: (i, v) => v,
                            ),
                            choiceStyle: C2ChoiceStyle(
                              color: Color.fromRGBO(151, 151, 151, 1),
                              showCheckmark: false,
                              labelStyle: TextStyle(
                                  fontSize: Dimens.pt12,
                                  color: Color.fromRGBO(
                                      142, 142, 142, 0.7)),
                            ),
                            choiceActiveStyle: C2ChoiceStyle(
                              color: Colors.red,
                              borderColor: Colors.red,
                              showCheckmark: false,
                              disabledColor: Colors.red,
                              brightness: Brightness.dark,
                              labelStyle: TextStyle(
                                  fontSize: Dimens.pt12, color: Colors.white),
                            ),
                          ),
                        ),
                              ],
                            ),
                          ),
                        ),
                  Positioned(
                  bottom: 6,
                  child: Container(
                    height: Dimens.pt60,
                    width: Dimens.pt280,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            state.selectedBust = "全部";
                            state.selectedHeight = "全部";
                            state.selectedAge = "全部";
                            setStates(() {

                            });

                           // QueryNakeChatBena bean = new QueryNakeChatBena(0,0,0);
                            //bus.emit(EventBusUtils.resetNakeChat,bean);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 16),
                            width: Dimens.pt110,
                            height: Dimens.pt30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(89, 86, 86, 1),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(18.5)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.5),
                                    offset: Offset(0.0, 6),
                                    blurRadius: 8,
                                    spreadRadius: 0)
                              ],
                            ),
                            child: Text(
                              "重置",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {

                            int age = getAge();
                            int height = getMaxHeight();
                            int bust = getBust();

                           // QueryNakeChatBena bean = new QueryNakeChatBena(age,height,bust);
                           // bus.emit(EventBusUtils.queryNakeChat,bean);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 16),
                            width: Dimens.pt110,
                            height: Dimens.pt30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(89, 86, 86, 1),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(18.5)),
                              gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(245, 22, 78, 1),
                                    Color.fromRGBO(255, 101, 56, 1),
                                    Color.fromRGBO(245, 68, 4, 1),
                                  ],
                                  stops: [
                                    0,
                                    1,
                                    1
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(
                                        248, 44, 44, 0.4),
                                    offset: Offset(0.0, 6),
                                    blurRadius: 8,
                                    spreadRadius: 0)
                              ],
                            ),
                            child: Text(
                              "确定",
                              style: TextStyle(
                                  fontSize: Dimens.pt12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                      ],
                    )),
              );
            }
        ),
    appBar: AppBar(
      toolbarHeight: Dimens.pt32,
      titleSpacing: 0,
      title: UnderLineTabBar(
        tabController: state.tabController,
        tabs: Lang.NOVEL_TABS,
        onTab: (index) {
          dispatch(DiscoveryTabActionCreator.onRefreshUI());
        },
      ),
      actions: [
        /// 搜索按钮
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(right: AppPaddings.appMargin),
              child: svgAssets(AssetsSvg.IC_SEARCH, height: Dimens.pt15)),
          onTap: () {
            dispatch(DiscoveryTabActionCreator.onSearchBtm());
          },
        ),

        /// 记录按钮
        Visibility(
          visible: state.index != 0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(right: AppPaddings.appMargin),
                child: svgAssets(AssetsSvg.RECORDING, height: Dimens.pt15)),
            onTap: () {
              dispatch(DiscoveryTabActionCreator.onRecordingBtm());
            },
          ),
        ),


        /// 筛选按钮
        Visibility(
          visible: state.index == 1 ? true : false,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(right: AppPaddings.appMargin),
                child: svgAssets("assets/svg/shaixuan.svg", height: Dimens.pt15)),
            onTap: () {
              bus.emit(EventBusUtils.openDrawer);
              //Scaffold.of(viewService.context).openEndDrawer();
            },
          ),
        ),
      ],
    ),
    body: Container(
      child: TabBarView(
        controller: state.tabController,
        children: [
          // DiscoveryPage().buildPage({
          //   'areaList': state.areaList,
          //   'findList': state.findList,
          // }),
          VideoTopicPage().buildPage(null),
          //NakeChatPage().buildPage(null),
          //NakeChatListPage(),
          AVCommentaryPage().buildPage(null),
          PassionNovelPage().buildPage(null),
          AudiobookPage().buildPage(null),
        ],
      ),
    ),
  ));


}



