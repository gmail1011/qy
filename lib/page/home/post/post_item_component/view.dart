import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/page/home/mine/mine_work/action.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'action.dart';
import 'post_item_widget.dart';
import 'state.dart';

Widget buildView(
    PostItemState state, Dispatch dispatch, ViewService viewService) {
  return InkResponse(
    highlightColor: Colors.transparent,
    radius: 0.0,
    child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.pt16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: Dimens.pt18),
              PostItemWidgets.createTopHeaderView(
                  state.type == "3" ? state.newVideoModel[0] : state.videoModel,
                  //state.videoModel,
                  onHeadClick: () {
                    if (state.postFrom == PostFrom.MINE) return;
                    if (!state.isHeadTapEnabled) return;
                    Map<String, dynamic> map = {
                      'uid': state.type == "3"
                          ? state.newVideoModel[0].publisher.uid
                          : state.videoModel.publisher.uid,
                      'uniqueId': state.uniqueId,
                    };
                    JRouter().go(PAGE_VIDEO_USER_CENTER, arguments: map);
                  }, onMoreClick: () {
                onMoreClick(state, dispatch, viewService);
              }),
              Visibility(
                child: PostItemWidgets.createTextLayout(
                    state.videoModel, state.isDidFullButton),
                visible: state.type != "3",
                //visible: true,
              ),
              state.type == "3"
                  ? Container(
                height: Dimens.pt200,
                child: MediaQuery.removePadding(
                  removeTop: true,
                  removeBottom: true,
                  context: viewService.context,
                  child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: Dimens.pt4,
                          crossAxisCount: 3,
                          childAspectRatio: 0.55),
                      itemCount: state.newVideoModel.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              height: Dimens.pt170,
                              padding: EdgeInsets.only(
                                  bottom: Dimens.pt2, top: Dimens.pt2),
                              child: state.newVideoModel[index].isImg()
                                  ? PostItemWidgets.createImageLayout(
                                  state.newVideoModel[index],
                                  needPay: () {
                                    dispatch(PostItemActionCreator
                                        .onBuyVideo());
                                  })
                                  : PostItemWidgets.createVideoLayout(
                                  state.newVideoModel[index],
                                  onItemClick: () {
                                    Config.liaoBaYuanChuangTempIndex =
                                        index;
                                    Config.newVideoModel =
                                        state.newVideoModel;
                                    dispatch(PostItemActionCreator
                                        .onItemClick(
                                      state.uniqueId,
                                    ));
                                  },
                                  onPlayClick: () => dispatch(
                                      PostItemActionCreator
                                          .onItemClick(
                                          state.uniqueId)),
                                  needPay: () {
                                    dispatch(PostItemActionCreator
                                        .onBuyVideo());
                                  }),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimens.pt4, bottom: Dimens.pt2),
                              child: Text(
                                state.newVideoModel[index].title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimens.pt12),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              )
                  : (state.videoModel.isImg()
                  ? PostItemWidgets.createImageLayout(state.videoModel,
                  needPay: () {
                    dispatch(PostItemActionCreator.onBuyVideo());
                  })
                  : PostItemWidgets.createVideoLayout(state.videoModel,
                  onItemClick: () => dispatch(
                      PostItemActionCreator.onItemClick(
                          state.uniqueId)),
                  onPlayClick: () => dispatch(
                      PostItemActionCreator.onItemClick(
                          state.uniqueId)),
                  needPay: () {
                    dispatch(PostItemActionCreator.onBuyVideo());
                  })),
              // ((state.videoModel?.comment?.content?.length ?? 0) > 0)
              //     ? _createHotCommend(state)
              //     : Container(),
              Visibility(
                  child: SizedBox(height: Dimens.pt8),
                  visible: state.type != "3"),
              Visibility(
                child: PostItemWidgets.getTagList(
                    state.type == "3"
                        ? state.newVideoModel[0]
                        : state.videoModel,
                    onTagClick: (index) => dispatch(
                        PostItemActionCreator.onTagClick(index, state))),
                visible: state.type != "3",
              ),
              Visibility(
                child: SizedBox(height: Dimens.pt10),
                visible: state.type != "3",
              ),
              Container(
                  color: AppColors.divideColor.withOpacity(0.2),
                  height: Dimens.pt1),
              SizedBox(height: Dimens.pt8),
              PostItemWidgets.createBottomView(
                  state.type == "3" ? state.newVideoModel[0] : state.videoModel,
                  onReward: () {
                    if (state.postFrom != PostFrom.MINE)
                      showRewardDialog(
                          viewService.context,
                          state.type == "3"
                              ? state.newVideoModel[0].id
                              : state.videoModel.id);
                  },
                  onLike: (status) {
                    var map = {"like": status, "uniqueId": state.uniqueId};
                    dispatch(PostItemActionCreator.onLike(map));
                  },
                  onComment: () =>
                      dispatch(PostItemActionCreator.onCommend(state.uniqueId)),
                  onShare: () => dispatch(PostItemActionCreator.onShare())),

              SizedBox(height: Dimens.pt12),
            ],
          ),
        ),
        Container(
            color: AppColors.divideColor.withOpacity(0.3), height: Dimens.pt8)
      ],
    ),
    onTap: () {
      if (state.type != "3") {
        dispatch(PostItemActionCreator.onItemClick(state.uniqueId));
      }
    },
  );
}

void onMoreClick(
    PostItemState state, Dispatch dispatch, ViewService viewService) {
  Map<String, dynamic> config = {};
  switch (state.postFrom) {
    case PostFrom.POST:
      var isFollowed = (state.type == "3"
              ? state.newVideoModel[0]?.publisher?.hasFollowed
              : state.videoModel?.publisher?.hasFollowed) ??
          false;
      config = {
        Lang.REWARD: () async {
          // safePopPage();
          await showRewardDialog(
              viewService.context,
              state.type == "3"
                  ? state.newVideoModel[0].id
                  : state.videoModel.id);
        },
        isFollowed ? Lang.NO_MINE_FOLLOW : Lang.MINE_FOLLOW: () {
          dispatch(PostItemActionCreator.onFollow(state.uniqueId));
        },
        ((state.type == "3"
                    ? state.newVideoModel[0]?.vidStatus?.hasCollected
                    : state.videoModel?.vidStatus?.hasCollected) ??
                false)
            ? Lang.CANCEL_COLLECT
            : Lang.COLLECT: () {
          dispatch(PostItemActionCreator.onCollect(state));
        },
        Lang.REPORT: () {
          showToast(msg: Lang.REPORT_SUCCESS);
          // DialogGlobal().openReportDialog(viewService.context, state.videoModel);
        },
      };
      break;
    case PostFrom.UC:
      config = {
        Lang.REWARD: () async {
          // safePopPage();
          await showRewardDialog(
              viewService.context,
              state.type == "3"
                  ? state.newVideoModel[0].id
                  : state.videoModel.id);
        },
        ((state.type == "3"
                    ? state.newVideoModel[0]?.vidStatus?.hasCollected
                    : state.videoModel?.vidStatus?.hasCollected) ??
                false)
            ? Lang.CANCEL_COLLECT
            : Lang.COLLECT: () {
          dispatch(PostItemActionCreator.onCollect(state));
        },
        Lang.REPORT: () {
          showToast(msg: Lang.REPORT_SUCCESS);
          // DialogGlobal()
          //     .openReportDialog(viewService.context, state.videoModel);
        },
      };
      break;
    case PostFrom.MINE:
      config = {
        Lang.DELETE: () {
          dispatch(MineWorkActionCreator.delWorkItem(
              state.type == "3" ? state.newVideoModel : state.videoModel));
        },
      };
      break;
    default:
  }
  showPostListDialog(
    viewService.context,
    config,
  );
}

/// follow handle
Widget _handleFollowBtn(
  PostItemState state,
  bool isFollowed,
  Dispatch dispatch,
) {
  if (!state.isShowFollowBtn) {
    return Container(
      width: Dimens.pt54,
      height: Dimens.pt24,
    );
  }
  return isFollowed
      ? Container(
          width: Dimens.pt54,
          height: Dimens.pt24,
          margin: EdgeInsets.only(right: Dimens.pt13),
          decoration: BoxDecoration(
              color: Color(0xFF585A64),
              borderRadius: BorderRadius.circular(Dimens.pt3)),
          child: Center(
              child: Text(
            Lang.HAS_FOLLOW,
            style: TextStyle(
                fontSize: Dimens.pt13, color: Colors.white.withAlpha(20)),
          )),
        )
      : GestureDetector(
          onTap: () {
            dispatch(PostItemActionCreator.onFollow(state.uniqueId));
          },
          child: Container(
            margin: EdgeInsets.only(right: Dimens.pt13),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xffC85A49), Color(0xff9A1F1F)]),
                borderRadius: BorderRadius.circular(Dimens.pt3)),
            width: Dimens.pt54,
            height: Dimens.pt24,
            child: Center(
                child: Text(
              Lang.FOLLOW,
              style: TextStyle(fontSize: Dimens.pt13, color: Colors.white),
            )),
          ),
        );
}
