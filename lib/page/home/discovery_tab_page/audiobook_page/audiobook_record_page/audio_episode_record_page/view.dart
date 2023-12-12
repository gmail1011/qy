import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/pull_refresh_view.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'state.dart';

Widget buildView(
    AudioEpisodeRecordState state, Dispatch dispatch, ViewService viewService) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
      child: PullRefreshView(
        controller: state.pullRefreshController,
        enablePullDown: false,
        enablePullUp: false,
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
                JRouter().go(AUDIO_NOVEL_PAGE, arguments: {
                  "id": item.id,
                  "episodeNumber": item.episodeNumber
                });
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
                              imageUrl: item.audioBook.cover ?? '',
                              fit: BoxFit.cover,
                              type: ImgType.audiobook,
                              height: double.infinity,
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "主播：${item.audioBook?.anchorInfo?.name ?? ''}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: Dimens.pt10,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        item?.episode?.name ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: AppFontSize.fontSize8,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "已播${(item.progress * 100).round().toInt()}%",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: AppFontSize.fontSize8,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
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
                                item.audioBook.title ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppFontSize.fontSize12,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        "${item.audioBook.totalEpisode ?? 0}集",
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
                                        "${item.audioBook.countBrowse ?? 0}",
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
      ));
}
