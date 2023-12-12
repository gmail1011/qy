import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/page/wallet/my_agent/view/agent_view.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'action.dart';
import 'state.dart';

///推广记录
Widget buildView(
    PromotionRecordState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: getCommonAppBar(Lang.PROMOTION_RECORD),
      body: BaseRequestView(
        controller: state.requestController,
        child: Container(
          padding: EdgeInsets.all(AppPaddings.appMargin),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                Lang.sprint(Lang.PROMOTION_TIME,
                    args: [state.total.toString()]),
                style: TextStyle(fontSize: Dimens.pt14, color: Colors.white),
              ),
              agentHLine2(height: 0.5),
              Flexible(
                child: pullYsRefresh(
                  refreshController: state.refreshController,
                  onLoading: () {
                    dispatch(PromotionRecordActionCreator.loadMoreData());
                  },
                  onRefresh: () {
                    dispatch(PromotionRecordActionCreator.loadData());
                  },
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return agentHLine2(height: 0.5);
                    },
                    itemCount: state.promotionList?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      var model = state.promotionList[index];
                      return Container(
                        height: Dimens.pt55,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // ClipOval(
                            //   child: CustomNetworkImage(
                            //     imageUrl:  "",
                            //     width: Dimens.pt55,
                            //     height: Dimens.pt55,
                            //     placeholder: assetsImg(
                            //         AssetsImages.USER_DEFAULT_AVATAR,
                            //         width: Dimens.pt55,
                            //         height: Dimens.pt55,
                            //         fit: BoxFit.fitWidth),
                            //   ),
                            // ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                model?.name ?? "",
                                style: TextStyle(
                                    fontSize: Dimens.pt14, color: Colors.white),
                              ),
                            ),
                            Text(
                              "注册时间：${DateTimeUtil.utcTurnYear2(model?.createAt ?? '')}",
                              style: TextStyle(
                                  fontSize: Dimens.pt12,
                                  height: 1.5,
                                  color: AppColors.userPayTextColor),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
