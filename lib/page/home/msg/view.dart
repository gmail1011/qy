import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/model/message/message_type_model.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';

import '../../../common/provider/msg_count_model.dart';
import 'state.dart';

Widget buildView(MsgState state, Dispatch dispatch, ViewService viewService) {
  /// 计算扩展行
  int extCount = (1 + ((state.adsBean == null) ? 0 : 1));
  return FullBg(
    child: Scaffold(
      appBar: getCommonAppBar(Lang.NAV_MSG), 
      // AppBar(
      //   title: Text(Lang.NAV_MSG),
      //   automaticallyImplyLeading: false,
      //   //文字title居中
      //   centerTitle: true,
      // ),
      body: Container(
        child: EasyRefresh.custom(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    // return Container();
                    return _getHeadLine(state, viewService);
                  } else if (index == 1 && extCount == 2) {
                    // return Container();
                    return _getAdLine(state, viewService);
                  } else {
                    return _getMessageLine(
                        state, viewService, index - extCount);
                  }
                },
                childCount: state.messageModelList == null
                    ? extCount
                    : (state.messageModelList.length + extCount),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _getMessageLine(MsgState state, ViewService viewService, int index) {
  return InkWell(
    onTap: () async {
      if (state.messageModelList[index].sender == 'ONLINE') {
        /*eagleClick(state.selfId(),
            sourceId: state.eagleId(viewService.context), label: "在线客服");*/
        csManager.openServices(viewService.context);
      } else {
        /*eagleClick(state.selfId(),
            sourceId: state.eagleId(viewService.context), label: "系统消息");*/
        Map<String, dynamic> map = {
          'title': state.messageModelList[index].title,
          'type': state.messageModelList[index].sender,
        };
        JRouter().go(PAGE_SYSTEM_MESSAGE, arguments: map);
      }
    },
    child: _getLineItem(state, index),
  );
}

///获取广告行
Widget _getAdLine(MsgState state, ViewService viewService) {
  if (state.adsBean != null) {
    return InkWell(
      onTap: () {
        /*eagleClick(state.selfId(),
            sourceId: state.eagleId(viewService.context), label: "广告");*/
        JRouter().handleAdsInfo(state.adsBean.href, id: state.adsBean.id);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(
            Dimens.pt16, Dimens.pt8, Dimens.pt16, Dimens.pt8),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimens.pt6),
            child: CustomNetworkImage(
              imageUrl: state.adsBean.cover,
              height: Dimens.pt125,
            )),
      ),
    );
  }
  return null;
}

Widget _getHeadLine(MsgState state, ViewService viewService) {
  return Container(
    margin: EdgeInsets.only(top: Dimens.pt10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        InkWell(
          onTap: () {
            /*eagleClick(state.selfId(),
                sourceId: state.eagleId(viewService.context), label: "粉丝");*/
            JRouter().go(PAGE_FANS);
          },
          child: Container(
            padding: _getItemMargin(),
            child: _getTopItem(AssetsSvg.MESSAGE_IC_FANS, Lang.FAN_ONE, state,
                state.messageTypeModel?.trendPreMap?.fans),
          ),
        ),
        InkWell(
          onTap: () {
            /*eagleClick(state.selfId(),
                sourceId: state.eagleId(viewService.context), label: "点赞");*/
            JRouter().go(PAGE_LAUD);
          },
          child: Container(
            padding: _getItemMargin(),
            child: _getTopItem(AssetsSvg.MESSAGE_IC_LIKE, Lang.LIKE, state,
                state.messageTypeModel?.trendPreMap?.like),
          ),
        ),
        InkWell(
          onTap: () {
            /*eagleClick(state.selfId(),
                sourceId: state.eagleId(viewService.context), label: "评论");*/
            JRouter().go(PAGE_COMMENT);
          },
          child: Container(
            padding: _getItemMargin(),
            child: _getTopItem(AssetsSvg.MESSAGE_IC_COMMENT, Lang.COMMENT,
                state, state.messageTypeModel?.trendPreMap?.comment),
          ),
        ),
        InkWell(
          onTap: () {
            //  eagleClick(state.selfId(),
            // sourceId: state.eagleId(viewService.context), label: "广告");
            showToast(msg: Lang.DEVELOPING);
          },
          child: Container(
            padding: _getItemMargin(),
            child: _getTopItem(
                AssetsSvg.MESSAGE_IC_INTERACTIVE,
                Lang.INTERACTIVE,
                state,
                state.messageTypeModel?.trendPreMap?.interactive),
          ),
        ),
      ],
    ),
  );
}

EdgeInsets _getItemMargin() {
  return EdgeInsets.fromLTRB(
    Dimens.pt16,
    Dimens.pt16,
    Dimens.pt18,
    Dimens.pt18,
  );
}

Widget _getTopItem(
    String image, String title, MsgState state, CountBean countBean) {
  return Column(
    children: <Widget>[
      Stack(
        children: <Widget>[
          svgAssets(
            image,
            width: Dimens.pt40,
            height: Dimens.pt40,
          ),
          _getHeadDotView(state, countBean),
        ],
      ),
      Container(
        margin: EdgeInsets.only(top: Dimens.pt16),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: Dimens.pt14,
          ),
        ),
      ),
    ],
  );
}

///头部dot
Widget _getHeadDotView(MsgState state, CountBean countBean) {
  if (state.messageTypeModel != null && countBean != null) {
    if ((countBean.count ?? 0) > 0) {
      return Positioned(
          right: Dimens.pt2,
          bottom: Dimens.pt2,
          child: ClipOval(
            child: Container(
              width: Dimens.pt7,
              height: Dimens.pt7,
              color: Colors.yellow,
            ),
          ));
    }
  }
  return Container();
}

///行点计数
Widget _getLineDotView(MsgState state, int newsCount) {
  // if (state.messageModelList != null && state.messageModelList.length > index) {
  if ((newsCount ?? 0) > 0) {
    return Container(
      margin: CustomEdgeInsets.only(top: 6, right: 6, left: 6),
      child: Stack(
        children: <Widget>[
          ClipOval(
            child: Container(
              width: Dimens.pt16,
              height: Dimens.pt16,
              color: Color(0xffffca00),
              alignment: Alignment.center,
              child: Text(
                getCount(newsCount),
                style: TextStyle(
                    color: AppColors.primaryColor, fontSize: Dimens.pt10),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // }
  return Container();
}

String getCount(int count) {
  if (count > 9) {
    return '9+';
  } else if (count > 0) {
    return count.toString();
  } else {
    return '';
  }
}

Widget _getIcon(MsgState state, int index) {
  if (state.messageModelList[index].sender == 'SYSTEM') {
    return svgAssets(
      AssetsSvg.MESSAGE_IC_SYSTEM_MESSAGE,
      width: Dimens.pt50,
      height: Dimens.pt50,
    );
  } else if (state.messageModelList[index].sender == 'ACTASST') {
    return svgAssets(
      AssetsSvg.MESSAGE_IC_ASSISTANT,
      width: Dimens.pt50,
      height: Dimens.pt50,
    );
  } else {
    return svgAssets(
      state.messageModelList[index].icon,
      width: Dimens.pt50,
      height: Dimens.pt50,
    );
  }
}

Widget _getLineItem(MsgState state, int index) {
  return Container(
      padding:
          EdgeInsets.fromLTRB(Dimens.pt16, Dimens.pt8, Dimens.pt16, Dimens.pt8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _getIcon(state, index),
              Container(
                margin: EdgeInsets.only(left: Dimens.pt11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: Dimens.pt220,
                      child: Text(
                        state.messageModelList[index].title ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimens.pt14,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: Dimens.pt6),
                      width: Dimens.pt220,
                      child: Text(
                        state.messageModelList[index].content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                DateTimeUtil.utc2MonthDay(
                    state.messageModelList[index].sendAt ?? ''),
                style:
                    TextStyle(color: Color(0x80ffffff), fontSize: Dimens.pt12),
              ),
              state.messageModelList[index].sender == 'ONLINE'
                  ? Consumer<MsgCountModel>(builder: (BuildContext context,
                      MsgCountModel msgCountModel, Widget child) {
                      return _getLineDotView(state, msgCountModel.countNum);
                    })
                  : _getLineDotView(
                      state, state.messageModelList[index].newsCount),
            ],
          ),
        ],
      ));
}
