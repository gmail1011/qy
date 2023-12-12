import 'package:fish_redux/fish_redux.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/flare.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/widget/common_widget/load_more_footer.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/model/message/laud_model.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(LaudState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: AppBar(
        title: Text(Lang.LIKE),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              safePopPage();
            }),
      ),
      body: Stack(
        children: <Widget>[
          Container(
              padding: CustomEdgeInsets.only(left: 16.0, right: 16),
              child: Container(
                child: EasyRefresh.custom(
                  emptyWidget: state.laudModelList == null
                      ? null
                      : state.laudModelList.length == 0
                          ? CErrorWidget(Lang.YOU_HAVE_NOT_LIKED)
                          : null,
                  header: BallPulseHeader(),
                  footer: LoadMoreFooter(hasNext: state.hasNext ?? false),
                  onRefresh: () async {},
                  onLoad: () async {
                    if (state.pageNumber * state.pageSize <=
                        state.laudModelList.length) {
                      state.pageNumber = state.pageNumber + 1;
                      dispatch(LaudActionCreator.loadLaudList());
                    }
                  },
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return InkWell(
                            onTap: () {
                              ///条目点击
                              Map<String, dynamic> map = Map();
                              map['playType'] = VideoPlayConfig.VIDEO_CITY_PLAY;
                              map['currentPosition'] = index;
                              map['type'] = 'video';
                              map['videoList'] = state.videoModelList;
                              JRouter().go(SUB_PLAY_LIST, arguments: map);
                            },
                            child: _getLineItem(state.laudModelList[index]),
                          );
                        },
                        childCount: state.laudModelList == null
                            ? 0
                            : state.laudModelList.length,
                      ),
                    ),
                  ],
                ),
              )),

          ///加载中动画
          Center(
            child: Offstage(
              offstage: (state.laudModelList == null) ? false : true,
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
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _getLineItem(LaudItem laudItem) {
  return Container(
      padding: CustomEdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipOval(
                child: CustomNetworkImage(
                  imageUrl: laudItem?.lPortrait ?? '',
                  type: ImgType.avatar,
                  width: Dimens.pt48,
                  height: Dimens.pt48,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: Dimens.pt11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: Dimens.pt150,
                      child: Text(
                        laudItem?.lName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimens.pt16,
                        ),
                      ),
                    ),
                    Container(
                      width: Dimens.pt150,
                      child: Text(
                        laudItem?.lType == 'video'
                            ? Lang.LIKED_YOUR_VIDEO
                            : Lang.LIKED_YOUR_COMMENT,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimens.pt12,
                        ),
                      ),
                    ),
                    Container(
                      width: Dimens.pt150,
                      margin: EdgeInsets.only(top: Dimens.pt6),
                      child: Text(
                        '${DateTimeUtil.utc2MonthDay(laudItem?.lTime ?? '')}',
                        style: TextStyle(
                          color: Color(0x80ffffff),
                          fontSize: Dimens.pt12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          CustomNetworkImage(
            imageUrl: laudItem?.video?.cover ?? '',
            width: Dimens.pt57,
            height: Dimens.pt57,
            fit: BoxFit.cover,
          )
        ],
      ));
}
