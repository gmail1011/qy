import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'zuo_pin_state.dart';


Widget buildView(
    ZuoPinState state, Dispatch dispatch, ViewService viewService) {
  return state.entryVideoData == null
      ? Center(
    child: LoadingWidget(),
  )
      : Container(
    margin: EdgeInsets.only(left: AppPaddings.appMargin,right: AppPaddings.appMargin,),
    child: ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            Map<String, dynamic> arguments = {
              // 'uid': state.entryVideoData.members[index].id,
              'uniqueId': DateTime.now().toIso8601String(),
              // KEY_VIDEO_LIST_TYPE: VideoListType.NONE
            };
            await JRouter()
                .go(PAGE_VIDEO_USER_CENTER, arguments: arguments);
            autoPlayModel.startAvailblePlayer();
          },
          child: Container(
            margin: EdgeInsets.only(bottom: AppPaddings.appMargin,),
            child: Row(
              children: [
                index == 0
                    ? Image.asset(
                  "assets/images/one.png",
                  width: Dimens.pt40,
                  height: Dimens.pt52,
                )
                    : index == 1
                    ? Image.asset(
                  "assets/images/two.png",
                  width: Dimens.pt40,
                  height: Dimens.pt52,
                ) : index == 2
                    ? Image.asset(
                  "assets/images/three.png",
                  width: Dimens.pt40,
                  height: Dimens.pt52,
                )
                    : Container(
                  width: Dimens.pt40,
                  alignment: Alignment.center,
                  child: Text((index + 1).toString(),style: TextStyle(color: Colors.white,fontSize: Dimens.pt18),)
                  ,
                ),
                SizedBox(
                  width: Dimens.pt10,
                ),
                ClipOval(
                  child: CustomNetworkImage(
                    height: Dimens.pt40,
                    width: Dimens.pt40,
                    fit: BoxFit.cover,
                    imageUrl: state.entryVideoData.list[0].members[index].avatar,
                  ),
                ),
                SizedBox(
                  width: Dimens.pt20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.entryVideoData.list[0].members[index].name,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.white, fontSize: Dimens.pt14),
                    ),
                    SizedBox(
                      height: Dimens.pt4,
                    ),
                    Text(

                      state.entryVideoData.list[0].members[index].value + "部",



                        style: TextStyle(
                            color: Color.fromRGBO(255, 183, 68, 1), fontSize: Dimens.pt13)

                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      itemCount: state.entryVideoData.list[0].members.length,
    ),
  );
}
