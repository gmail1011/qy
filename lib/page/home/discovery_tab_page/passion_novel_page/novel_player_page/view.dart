import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/home/discovery_tab_page/passion_novel_page/novel_player_page/action.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_svg/svg.dart';

import 'state.dart';

Widget buildView(
    NovelPlayerState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    backgroundColor: state.colorModel.bgColor,
    body: Stack(
      children: [
        GestureDetector(
          onTap: () {
            dispatch(NovelPlayerActionCreator.showAppBar(!state.isShowAppBar));
          },
          child: Container(
            padding: EdgeInsets.only(
              bottom: screen.paddingBottom,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: AppPaddings.appMargin - Dimens.pt2,
                      right: AppPaddings.appMargin - Dimens.pt2,
                      top: screen.paddingTop + Dimens.pt15,
                      bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    state.novelData?.title ?? '',
                    style: TextStyle(
                        fontSize: Dimens.pt12,
                        height: 1.5,
                        color: state.colorModel.textColor
                        // color: Colors.black.withOpacity(0.5),
                        ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.pt6),
                    child: BaseRequestView(
                      retryOnTap: () {
                        dispatch(NovelPlayerActionCreator.onLoadData());
                      },
                      controller: state.pullController,
                      child: DraggableScrollbar(
                        controller: state.controller,
                        scrollbarTimeToFade: Duration(milliseconds: 1000),
                        child: ListView.builder(
                          controller: state.controller,
                          itemCount: state.currentTextList.length,
                          // cacheExtent: ,
                          padding: EdgeInsets.symmetric(
                              horizontal: AppPaddings.appMargin - Dimens.pt6,
                              vertical: 0),
                          itemBuilder: (BuildContext context, int index) {
                            return Text(
                              '${state.currentTextList[index]}',
                              style: TextStyle(
                                fontSize: AppFontSize.fontSize16,
                                height: 2,
                                // color: Colors.black.withOpacity(0.5),
                                color: state.colorModel.textColor,
                              ),
                            );
                          },
                        ),
                        heightScrollThumb: 60,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        scrollThumbBuilder: (
                          Color backgroundColor,
                          Animation<double> thumbAnimation,
                          Animation<double> labelAnimation,
                          double height, {
                          BoxConstraints labelConstraints,
                          Text labelText,
                        }) {
                          return FadeTransition(
                            opacity: thumbAnimation,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: backgroundColor,
                              ),
                              height: height,
                              width: 6.0,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _topView(
              viewService.context,
              state,
              onCollect: () {
                dispatch(NovelPlayerActionCreator.onCollect());
              },
            ),
            if (state.tipArrowShow)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    dispatch(NovelPlayerActionCreator.changeTipArrow(false));
                  },
                  child: Container(
                    width: Dimens.pt360,
                    color: Colors.black26,
                    padding: EdgeInsets.symmetric(vertical: Dimens.pt60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SvgPicture.asset(AssetsSvg.NOVEL_ARROW_UP),
                        Text(
                          '上下滑动欣赏',
                          style: TextStyle(
                              fontSize: Dimens.pt40, color: Colors.white),
                        ),
                        SvgPicture.asset(AssetsSvg.NOVEL_ARROW_DOWN),
                      ],
                    ),
                  ),
                ),
              )
            else
              Expanded(child: Container()),
            _bottomView(viewService.context, state, (c) {
              dispatch(NovelPlayerActionCreator.changeColor(c));
            }),
          ],
        ),
      ],
    ),
  );
}

Widget _bottomView(BuildContext context, NovelPlayerState state,
    ValueChanged<ColorsModel> changeColor) {
  return Visibility(
    visible: state.isShowAppBar,
    child: Container(
      color: Color(0xFF07092E),
      height: 80 + screen.paddingBottom,
      padding: EdgeInsets.only(
        bottom: screen.paddingBottom,
        right: AppPaddings.appMargin,
        left: AppPaddings.appMargin,
      ),
      child: Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: state.bgColors
            .map(
              (e) => GestureDetector(
                onTap: () {
                  changeColor(e);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: Dimens.pt30,
                      decoration: BoxDecoration(
                          color: e.bgColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              offset: Offset(0, 0),
                              blurRadius: 6,
                            )
                          ]),
                    ),
                    Visibility(
                      visible: e.bgColor == state.colorModel.bgColor,
                      child: Icon(
                        Icons.check,
                        color: Colors.red,
                        size: Dimens.pt25,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      )),
    ),
  );
}

Widget _topView(BuildContext context, NovelPlayerState state,
    {VoidCallback onCollect}) {
  return Visibility(
    visible: state.isShowAppBar,
    child: Container(
      height: kToolbarHeight + screen.paddingTop,
      padding: EdgeInsets.only(
        top: screen.paddingTop,
        right: AppPaddings.appMargin,
        left: AppPaddings.appMargin,
      ),
      decoration: BoxDecoration(
        color: Color(0xFF07092E),
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            child: Container(
                padding: EdgeInsets.only(right: AppPaddings.appMargin),
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: ImageLoader.withP(ImageType.IMAGE_SVG,
                        address: AssetsSvg.BACK,
                        width: 16,
                        height: 16,
                        fit: BoxFit.scaleDown)
                    .load()),
            onTap: () {
              safePopPage(state.novelData?.countCollect);
            },
          ),
          Expanded(
            child: Container(
              child: Text(state.novelData?.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: Dimens.pt17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showReportErrSheet(context);
                },
                child: Container(
                  padding: EdgeInsets.only(left: AppPaddings.appMargin),
                  child: Text(
                    "报错",
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (onCollect != null) {
                    onCollect();
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(left: Dimens.pt40),
                  child: Text(
                    (state.novelData?.isCollect ?? false) ? "已收藏" : '收藏',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// 显示报错弹出
Future showReportErrSheet(BuildContext context) async {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(Dimens.pt6)),
        child: Container(
          padding: EdgeInsets.only(bottom: screen.paddingBottom),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            GestureDetector(
              onTap: () async {
                await netManager.client.reportErrFiction();
                showToast(msg: '操作成功！');
                safePopPage();
              },
              child: Container(
                alignment: Alignment.center,
                height: Dimens.pt52,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white),
                child: Text(
                  '文字乱码',
                  style: TextStyle(fontSize: Dimens.pt18),
                ),
              ),
            ),
            SizedBox(height: Dimens.pt10),
            GestureDetector(
              onTap: () {
                safePopPage();
              },
              child: Container(
                alignment: Alignment.center,
                height: Dimens.pt52,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white),
                child: Text(
                  '取消',
                  style: TextStyle(fontSize: Dimens.pt18),
                ),
              ),
            )
          ]),
        ),
      );
    },
  );
}
