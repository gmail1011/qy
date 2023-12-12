import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/model/reward_list_model.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    RewardLogState state, Dispatch dispatch, ViewService viewService) {
  Widget _itemBuilder(BuildContext context, int index) {
    RewardItem item = state.list[index];
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  color: Color.fromRGBO(90, 79, 89, 1),
                  height: index == 0 ? 1 : 0,
                ),
                Container(
                  padding: EdgeInsets.all(Dimens.pt16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              HeaderWidget(headPath: item.uPortrait, level: 0, headWidth: Dimens.pt36, headHeight: Dimens.pt36,),
                              Container(
                                margin: EdgeInsets.only(left: Dimens.pt8),
                                child: Text(
                                  item.uName,
                                  style: TextStyle(
                                    fontSize: Dimens.pt14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Dimens.pt10),
                            height: Dimens.pt44,
                            width: Dimens.pt220,
                            child: Text(
                              '${Lang.ADDITIONAL_MESSAGE}${item.msg}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: Dimens.pt10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Dimens.pt5),
                            width: Dimens.pt220,
                            child: Text(
                              '${Lang.REWARD_YOU}${item.publisherIncome}${Lang.GOLD_COIN}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: Dimens.pt10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          
                          Container(
                            margin: EdgeInsets.only(top: Dimens.pt5),
                            width: Dimens.pt220,
                            child: Text(
                              '${Lang.REWARD_DATE}${DateUtil.formatDate(DateTime.parse(item.createdAt),format:'yyyy-MM-dd HH:mm:ss')}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: Dimens.pt10,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.pt5),
                          color: Colors.transparent,
                        ),
                        child: ImageLoader.withP(
                          ImageType.IMAGE_NETWORK_HTTP,
                          address: item.videoCover,
                          width: Dimens.pt96,
                          height: Dimens.pt120 + Dimens.pt8,
                        ).load(),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(22, 25, 74, 1),
                      Colors.white,
                      Color.fromRGBO(22, 25, 74, 1),
                    ],
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  return FullBg(
    child: Scaffold(
      appBar: getCommonAppBar(Lang.GET_REWARD),
      body: pullYsRefresh(
        enablePullDown: false,
        refreshController: state.refreshController,
        onLoading: () => dispatch(RewardLogActionCreator.onLoadMore()),
        child: ListView.builder(
          itemBuilder: _itemBuilder,
          itemCount: state.list?.length ?? 0,
        ),
      ),
    ),
  );
}
