import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/local_store/cached_video_store.dart';
import 'package:flutter_app/page/setting/my_download/action.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/local_server/video_sub_cache_manager.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'state.dart';

Widget buildView(
    MyDownloadState state, Dispatch dispatch, ViewService viewService) {
  var list = state.list;

  // itemBuilder
  Widget _itemBuilder(BuildContext context, int i) {
    var item = list[i];
    return GestureDetector(
      onTap: () {
        Map<String, dynamic> map = Map();
        map['playType'] = VideoPlayConfig.VIDEO_CITY_PLAY;
        map['videoList'] = list;
        map["currentPosition"] = i;
        JRouter().go(SUB_PLAY_LIST, arguments: map);
      },
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.pt5),
          color: Colors.transparent,
        ),
        child: Stack(
          children: <Widget>[
            ImageLoader.withP(
              ImageType.IMAGE_NETWORK_HTTP,
              address: item.cover,
              width: Dimens.pt162,
              height: Dimens.pt216,
            ).load(),
            Positioned(
              bottom: 0,
              left: 0,
              height: Dimens.pt48,
              width: Dimens.pt162,
              child: Container(
                padding: EdgeInsets.only(
                  left: Dimens.pt13,
                  right: Dimens.pt13,
                  bottom: Dimens.pt10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0),
                      Color.fromRGBO(0, 0, 0, .6)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    ImageLoader.withP(
                      ImageType.IMAGE_SVG,
                      address: AssetsSvg.IC_LOVE,
                      width: Dimens.pt12,
                      height: Dimens.pt12,
                    ).load(),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: Dimens.pt4),
                        child: Text(
                          '${item.likeCount}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppFontSize.fontSize11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  return FullBg(
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: getCommonAppBar(Lang.MY_DOWNLOAD, actions: [
        Visibility(
            visible: (CachedVideoStore().getCachedVideoSync?.length ?? 0) > 0,
            child: GestureDetector(
              onTap: () async {
                bool isClear = await showConfirm(viewService.context,
                    content: Lang.CLEAR_ALL_VIDEO, showCancelBtn: true);
                if (isClear) {
                  await VideoSubCacheManager().emptyCache();
                  await CachedVideoStore().clean();
                  dispatch(MyDownloadActionCreator.beginUpdateList());
                }
              },
              child: Container(
                // color: Colors.red,
                width: 50,
                child: Icon(Icons.highlight_off, size: 30),
              ),
            ))
      ]),
      body: BaseRequestView(
        child: Container(
          padding: EdgeInsets.only(bottom: Dimens.pt32),
          // color: AppColors.primaryColor,
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              left: AppPaddings.appMargin,
              right: AppPaddings.appMargin,
              top: 10,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //横向数量
              crossAxisSpacing: 10, //间距
              mainAxisSpacing: 10, //行距
              childAspectRatio: 162 / 216, // 宽高比
            ),
            itemBuilder: _itemBuilder,
            itemCount: list.length,
          ),
        ),
        controller: state.requestController,
      ),
    ),
  );
}
