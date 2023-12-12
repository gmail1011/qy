import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/pull_refresh_view.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    AudiobookDataListState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
    child: PullRefreshView(
      controller: state.pullRefreshController,
      emptyText: state.type == 6 ? Lang.SEARCH_EMPTY_DATA : Lang.EMPTY_DATA,
      retryOnTap: () {
        dispatch(AudiobookDataListActionCreator.loadData());
      },
      onLoading: () {
        dispatch(AudiobookDataListActionCreator.loadMoreData());
      },
      onRefresh: () {
        dispatch(AudiobookDataListActionCreator.loadData());
      },
      child: GridView.builder(
        padding: EdgeInsets.all(0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 10,
          childAspectRatio: 160 / 220,
        ),
        itemBuilder: (context, index) {
          var item = state.list[index];
          return GestureDetector(
            onTap: () {
              JRouter().go(AUDIO_NOVEL_PAGE, arguments: {"id": item.id});
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                color: Color(0xFF2F2F5F),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        children: [
                          CustomNetworkImage(
                            imageUrl: item.cover ?? '',
                            fit: BoxFit.cover,
                            type: ImgType.audiobook,
                            height: double.infinity,
                          ),
                          ((item?.contentSet?.length ?? 0) == 0
                                  ? false
                                  : ((item?.contentSet?.first
                                              ?.listenPermission ??
                                          0) ==
                                      1))
                              ? Positioned(
                                  right: 0,
                                  top: -2,
                                  child: svgAssets(AssetsSvg.XIAOSHUO_VIP,
                                      height: 20),
                                )
                              : Visibility(
                                  visible: state.type != 1,
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3)),
                                    child: Text(
                                      "主播：${item.anchor ?? ''}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: Dimens.pt10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.title ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppFontSize.fontSize12,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 4,
                                    ),
                                    svgAssets(AssetsSvg.XIAOSHUO_JISHU),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      "${item.totalEpisode ?? 0}集",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: Dimens.pt9,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    svgAssets(AssetsSvg.PLAYER_COUNT),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      "${item.countBrowse ?? 0}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: Dimens.pt9,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: state.list?.length ?? 0,
      ),
    ),
  );
}
