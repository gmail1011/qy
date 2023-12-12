import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/model/user/wish_list_entity.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/flutter_base.dart';

import 'action.dart';
import 'state.dart';

///愿望工单-问题
Widget buildView(
    WishQuestionState state, Dispatch dispatch, ViewService viewService) {
  return BaseRequestView(
    retryOnTap: () => dispatch(WishQuestionActionCreator.refreshData()),
    controller: state.requestController,
    child: pullYsRefresh(
      refreshController: state.refreshController,
      onRefresh: () => dispatch(WishQuestionActionCreator.refreshData()),
      onLoading: () => dispatch(WishQuestionActionCreator.loadMoreData()),
      child: ListView.builder(
          itemExtent: Dimens.pt88,
          padding: EdgeInsets.only(top: 8),
          itemBuilder: (BuildContext context, int index) {
            if (state.wishList == null) {
              return Container();
            }
            return _createQuestionListItem(state.wishList[index], state);
          },
          itemCount: state.wishList?.length ?? 0),
    ),
  );
}

///创建问题列表item
Widget _createQuestionListItem(
    WishListDataList wishListItem, WishQuestionState state) {
  return GestureDetector(
    onTap: () => JRouter().jumpPage(WISH_DETAILS_PAGE, args: {
      "wishId": wishListItem?.id,
      "isMyWish": state.questionType == 1
    }),
    child: Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.userMakeBgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              //有悬赏金额
              Visibility(
                visible: (wishListItem?.bountyGold ?? 0) > 0,
                child: Row(
                  children: [
                    svgAssets(AssetsSvg.ICON_WISH_LIST01,
                        width: Dimens.pt13, height: Dimens.pt13),
                    const SizedBox(width: 3),
                    Text(
                      "${wishListItem?.bountyGold ?? 0}",
                      style:
                          TextStyle(fontSize: Dimens.pt18, color: Colors.white),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              ),

              Expanded(
                child: Text(
                  "${wishListItem?.question ?? ""}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: Dimens.pt14, color: Colors.white),
                ),
              ),

              Visibility(
                visible: wishListItem?.isAdoption ?? false,
                child: svgAssets(AssetsSvg.ICON_QUESTION_COMPLETE,
                    width: Dimens.pt20, height: Dimens.pt20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              svgAssets(AssetsSvg.ICON_WISH_LIST02,
                  width: Dimens.pt13, height: Dimens.pt13),
              const SizedBox(width: 5),
              Text(
                formatTimeForQuestion(wishListItem?.createdAt ?? ""),
                maxLines: 1,
                style: TextStyle(
                    fontSize: Dimens.pt12,
                    color: Colors.white.withOpacity(0.5)),
              ),
              const SizedBox(width: 22),
              svgAssets(AssetsSvg.ICON_WISH_LIST03,
                  width: Dimens.pt13, height: Dimens.pt13),
              const SizedBox(width: 5),
              Text(
                "${wishListItem?.lookCount ?? 0}",
                maxLines: 1,
                style: TextStyle(
                    fontSize: Dimens.pt12,
                    color: Colors.white.withOpacity(0.5)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
