import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/LoadingWidget.dart';
import 'package:flutter_base/flutter_base.dart';

import 'hot_video_detail_action.dart';
import 'hot_video_detail_state.dart';

Widget buildView(
    HotVideoDetailState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: CustomAppbar(
      title: "热门作品",
    ),
    body: state.commonPostResHotVideo == null ? LoadingWidget() : Container(
      child: GridView.builder(
              itemCount: state.commonPostResHotVideo.list.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, //横向数量
                crossAxisSpacing: 10, //间距
                mainAxisSpacing: 10, //行距
                childAspectRatio: Dimens.pt126 / Dimens.pt210,
              ),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: CustomNetworkImage(
                        imageUrl: state.commonPostResHotVideo.list[index].cover,
                        width: Dimens.pt126,
                        height: Dimens.pt190,
                      ),
                    ),

                    SizedBox(height: Dimens.pt6,),

                    Text(
                      state.commonPostResHotVideo.list[index].title,
                      style:
                          TextStyle(fontSize: Dimens.pt12, color: Colors.white),
                    ),
                  ],
                );
              },
            ),
    ),
  );
}
