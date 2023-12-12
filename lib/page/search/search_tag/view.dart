/// 金币专区
import 'dart:io';

import 'package:fish_redux/fish_redux.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/flare.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/widget/dialog/no_permission_dialog.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/page/search/search_tag/action.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'state.dart';

Widget buildView(
    HotListState state, Dispatch dispatch, ViewService viewService) {
  ListAdapter listAdapter = viewService.buildAdapter();

  var headTag = Container(
//      color: Colors.green,
    child: Row(
      textDirection: TextDirection.ltr, //左对齐
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        CustomNetworkImage(
          imageUrl: state.bean.cover,
          placeholder: assetsImg(
            AssetsImages.IC_TAG_DEFAULT_HEAD,
            width: Dimens.pt115,
            height: Dimens.pt115,
            fit: BoxFit.cover,
          ),
          width: Dimens.pt115,
          height: Dimens.pt115,
        ),
        Padding(
          padding: EdgeInsets.only(left: Dimens.pt8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                state.bean.name,
                style: TextStyle(color: Colors.white),
              ),
              Text(
                state.bean.types == "goldCoinArea"
                    ? '${numCoverStr(state.topModel?.payCount ?? 0)}' +
                        Lang.GOLD_1
                    : '${numCoverStr(state.topModel?.playCount ?? 0)}' +
                        Lang.GOLD_2,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  return FullBg(
    child: Scaffold(
      appBar: AppBar(
        title: Text(state.bean.name), //T
        centerTitle: true, // ext
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            safePopPage();
          },
        ),
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SmartRefresher(
              enablePullDown: false,
              enablePullUp: true,
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  return state.topModel == null
                      ? Container()
                      : (state.topModel?.hasNext ?? false)
                          ? state.isShowLoading
                              ? Container(
                                  child: LoadingWidget(
                                    width: Dimens.pt35,
                                    height: Dimens.pt15,
                                  ),
                                )
                              : Container()
                          : Container();
                },
              ),
              onLoading: () async {
                if (state.topModel?.hasNext ?? false) {
                  state.isShowLoading = true;
                  state.pageNumber++;
                  dispatch(HotListActionCreator.onLoadMore());
                } else {
                  state.headerRefreshController.loadComplete();
                  state.isShowLoading = false;
                }
              },
              controller: state.headerRefreshController,
              child: CustomScrollView(
                controller: state.scrollController,
                physics: ScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: Dimens.pt15, left: Dimens.pt10),
                      child: headTag,
                    ),
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      childAspectRatio: 0.7, //子控件宽高比
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return listAdapter.itemBuilder(context, index);
                    }, childCount: listAdapter.itemCount),
                  ),
                ],
              ),
            ),

            ///加载中动画
            Offstage(
              offstage: state.requestComplete ? true : false,
              child: Container(
                width: Dimens.pt35,
                height: Dimens.pt35,
                child: FlareActor(
                  AssetsFlare.LOADING,
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "loading",
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: svgAssets(
            AssetsSvg.IC_TAG_ADD_VIDEO,
          ),
          onPressed: () async {
//            println(Lang.participate);
            Map<Permission, PermissionStatus> statuses = await [
              Permission.camera,
              Permission.microphone,
            ].request();
            if (statuses[Permission.camera].isGranted &&
                statuses[Permission.microphone].isGranted) {
              JRouter().go(VIDEO_PUBLISH);
            } else {
//拒绝或者没有权限
              if (Platform.isIOS) {
                if (!await Permission.camera.isGranted ||
                    !await Permission.camera.isGranted) {
                  //只要有一个权限没给，那么就提示ios用户手动去设置页面开启权限
                  bool val = await showDialog(
                      context: viewService.context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return NoPermissionDialog(msg: Lang.cancel);
                      });
                  if (val) {
                    //去设置页面设置
                    openAppSettings();
                  }
                }
              }
            }

//          JRouter().go(VIDEO_RECORDER);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ),
  );
}
