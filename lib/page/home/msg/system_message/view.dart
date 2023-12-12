import 'package:fish_redux/fish_redux.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/flare.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/widget/common_widget/load_more_footer.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/model/message/message_model.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    SystemMessageState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          state.title ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        //文字title居中
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              dispatch(SystemMessageActionCreator.onBack());
            }),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              dispatch(SystemMessageActionCreator.onOpenService());
            },
            child: Text(
              Lang.CONTACT_CUSTOM_SERVICE,
              style: TextStyle(
                fontSize: Dimens.pt14,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16),
            child: EasyRefresh.custom(
              emptyWidget: state.messageModelList == null
                  ? null
                  : state.messageModelList.length == 0
                      ? CErrorWidget(Lang.YOU_HAVE_NOT_SYS_MSG)
                      : null,
              header: BallPulseHeader(),
              footer: LoadMoreFooter(hasNext: state.hasNext ?? false),
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _getLineItem(state.messageModelList[index],viewService);
                    },
                    childCount: state.messageModelList == null
                        ? 0
                        : state.messageModelList.length,
                  ),
                ),
              ],
            ),
          ),

          ///加载中动画
          Center(
            child: Offstage(
              offstage: (state.messageModelList == null) ? false : true,
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

Widget _getLineItem(MessageModel model,ViewService viewService) {
  return GestureDetector(
    onTap: (){


      if(model.title == "消费回馈"){
        Navigator.of(viewService.context).pop();
        Navigator.of(viewService.context).pop();
        JRouter().go(FU_LI_GUANG_CHANG_PAGE).then((value) {

        });
      }else if(model.title == "充值有礼"){
        Navigator.of(viewService.context).pop();
        Navigator.of(viewService.context).pop();

        JRouter().go(FU_LI_GUANG_CHANG_PAGE).then((value) {

        });
      }else{
        if(model.content.contains("yinseinner")){
          List<String> result = model.content.split("yinseinner:");
          result.forEach((element) {
            if(element.contains("//")){
              Config.isSystemConfigJump = true;
              JRouter().go(element.split("//")[1]);
            }
          });
        }
      }
    },
    child: Container(
        padding: CustomEdgeInsets.only(top: 16, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: CustomEdgeInsets.only(top: 4),
                  child: _getIcon(model),
                ),
                Container(
                  margin: EdgeInsets.only(left: Dimens.pt11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: Dimens.pt250,
                        child: Text(
                          model?.title ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimens.pt16,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: Dimens.pt6),
                        width: Dimens.pt250,
                        child: Text(
                          model?.content ?? "",
                          maxLines: 20,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0x80ffffff),
                            fontSize: Dimens.pt12,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: Dimens.pt6),
                        width: Dimens.pt260,
                        child: Text(
                          DateTimeUtil.utc2iso(model.sendAt ?? ''),
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
          ],
        )),
  );
}

Widget _getIcon(MessageModel model) {
  if (model.sender == 'SYSTEM') {
    return svgAssets(
      AssetsSvg.MESSAGE_IC_SYSTEM_MESSAGE,
      width: Dimens.pt50,
      height: Dimens.pt50,
    );
  } else if (model.sender == 'ACTASST') {
    return svgAssets(
      AssetsSvg.MESSAGE_IC_ASSISTANT,
      width: Dimens.pt50,
      height: Dimens.pt50,
    );
  } else {
    return svgAssets(
      model.icon,
      width: Dimens.pt50,
      height: Dimens.pt50,
    );
  }
}
