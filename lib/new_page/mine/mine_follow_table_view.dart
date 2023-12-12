import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net/api.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/base_response.dart';
import 'package:flutter_app/model/res/watch_list_model.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_app/model/video_paged_list.dart';
import 'package:flutter_app/page/hjll_community/hjll_community_quanzi_detail/HjllCommunityQuanziDetailPage.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:pull_to_refresh/pull_to_refresh.dart';

///我的关注
class MineFollowTableView extends StatefulWidget {
  final int type; //1：用户 2：圈子
  MineFollowTableView(this.type);

  @override
  State<StatefulWidget> createState() {
    return _MineFollowTableViewState();
  }
}

class _MineFollowTableViewState extends State<MineFollowTableView> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List<WatchModel> followUserList = [];

  List<TagDetailModel> tagModelList = [];

  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadData(true);
  }

  var page = 1;

  void _loadData(bool isReload) {
    if (isReload)
      page = 1;
    else
      page += 1;
    if (widget.type == 1) {
      _getFollowUserData(page);
    } else {
      _loadTagData(page);
    }
  }

  void setReqControllerState(bool isCatch, bool dataIsEmpty) {
    if (isCatch) {
      if (page == 1) {
        refreshController.refreshFailed();
      } else {
        refreshController.loadFailed();
      }
      requestController.requestFail();
    } else {
      requestController.requestSuccess();
      if (page == 1 && dataIsEmpty) {
        requestController.requestDataEmpty();
      }
      if (page == 1) {
        refreshController.refreshCompleted();
      } else {
        refreshController.loadComplete();
        if (dataIsEmpty) {
          refreshController.loadNoData();
        }
      }
    }
  }

  _getFollowUserData(int pageNum) async {
    WatchlistModel model;
    try {
      model = await netManager.client.getFollowedUserList(pageNum);
    } catch (e) {
      setReqControllerState(true, false);
    }
    // 请求成功
    setReqControllerState(false, model?.list?.isEmpty);
    if (pageNum == 1) {
      model?.list?.forEach((it) {
        it.hasFollow = true;
      });
      followUserList.clear();
    } else {
      // 加载成功
      model?.list?.forEach((it) {
        it.hasFollow = true;
      });
    }
    followUserList.addAll(model?.list);

    if (followUserList.length < Config.PAGE_SIZE) refreshController.loadNoData();
    setState(() {});
  }

  ///请求话题列表
  void _loadTagData(int pageNumber) async {
    try {
      Map<String, dynamic> mapList = {};
      mapList['type'] = 'tag';
      mapList['pageNumber'] = pageNumber;
      mapList['pageSize'] = Config.PAGE_SIZE;
      mapList['uid'] = GlobalStore.getMe()?.uid ?? 0;
      BaseResponse res = await HttpManager().get(Address.MY_FAVORITE, params: mapList);
      if (res.code == 200) {
        PagedList list = PagedList.fromJson(res.data);

        List<TagDetailModel> modelList = TagDetailModel.toList(list.list);
        if (pageNumber == 1) {
          tagModelList?.clear();
        }
        if ((modelList ?? []).isNotEmpty) {
          tagModelList.addAll(modelList);
        }
        setReqControllerState(false, tagModelList.isEmpty);
        if (tagModelList.length < Config.PAGE_SIZE) refreshController.loadNoData();

        setState(() {});
      } else {
        setReqControllerState(true, false);
      }
    } catch (e) {
      setReqControllerState(true, false);
    }
  }

  void _onFollow(int index) async {
    try {
      var data = followUserList[index];
      await netManager.client.getFollow(data.uid, !data.hasFollow);
      setState(() {
        data.hasFollow = !data.hasFollow;
      });
    } catch (e) {
      l.e("mine_follw", "_onFollow()...error:$e");
    }
  }

  ///删除话题
  void _delCollectTag(int index, String tagID) async {
    try {
      await netManager.client.changeTagStatus(tagID, false, "tag");
      tagModelList.removeAt(index);
      setState(() {});
    } catch (e) {
      l.d("_delCollectTag-error", "$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
      child: BaseRequestView(
        controller: requestController,
        child: pullYsRefresh(
          refreshController: refreshController,
          onRefresh: () {
            Future.delayed(Duration(milliseconds: 1000), () {
              _loadData(true);
            });
          },
          onLoading: () {
            _loadData(false);
          },
          child: widget.type == 1
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: followUserList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = followUserList[index];
                    return _buildFollowUserView(index, item);
                  })
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: tagModelList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = tagModelList[index];
                    return _buildTopicView(index, item);

                    //var item = followUserList[index];
                    //return _buildFollowUserView(index, item);
                  }),

          /*GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 200 / 184),
                  itemCount: tagModelList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = tagModelList[index];
                    return _buildFollowCircleView(index, item);
                  }),*/
        ),
      ),
    );
  }

  Widget _buildFollowCircleView(int index, TagDetailModel item) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return HjllCommunityQuanziDetailPage(
            videoTagId: item.id,
            videoTagName: item.name,
          );
        }));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                  child: CustomNetworkImage(
                    imageUrl: item.coverImg,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned.fill(
                    child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xcc000000),
                    borderRadius: BorderRadius.all(
                      Radius.circular(2),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "${item.videoCount}帖子",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ))
              ],
            ),
            SizedBox(height: 12),
            GestureDetector(
                onTap: () {
                  _delCollectTag(index, item.id);
                },
                child: Container(
                  width: 82,
                  height: 26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                    gradient: AppColors.linearBackGround,
                  ),
                  child: Center(
                    child: Text(
                      "取消关注",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildFollowUserView(int index, WatchModel item) {
    return InkWell(
      onTap: () {
        Map<String, dynamic> arguments = {
          'uid': item.uid ?? 0,
          'uniqueId': DateTime.now().toIso8601String(),
        };
        Gets.Get.to(() => BloggerPage(arguments), opaque: false);
      },
      child: Container(
        width: screen.screenWidth - 20,
        height: 66,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xff242424),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderWidget(
              headPath: item?.portrait ?? "",
              level: (item?.superUser ?? false) ? 1 : 0,
              headWidth: 38,
              headHeight: 38,
              levelSize: 14,
              positionedSize: 0,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: 10,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ///user name
                          Container(
                            child: Text(
                              item == null ? Lang.UN_KNOWN : ((item?.name?.length ?? 0) > 9 ? item?.name?.substring(0, 9) : item?.name),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 16,
                                color: GlobalStore.isVIP() ? AppColors.primaryTextColor : Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              "帖子总数: " + getShowCountStr(item.works),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xffacbabf),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _onFollow(index);
                      },
                      child: Center(
                        child: Container(
                          width: 82,
                          height: 26,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            //gradient: AppColors.linearBackGround,
                            color: Color.fromRGBO(255, 255, 255, 0.1),
                          ),
                          child: item.hasFollow
                              ? Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/weibo/images/blue_star.png",
                                        width: 14,
                                        height: 14,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        "已关注",
                                        style: TextStyle(fontSize: 14, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "关注",
                                        style: TextStyle(fontSize: 14, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicView(int index, TagDetailModel item) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return HjllCommunityQuanziDetailPage(
            videoTagId: item.id,
            videoTagName: item.name,
          );
        }));
      },
      child: Container(
        width: screen.screenWidth - 20,
        height: 66,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xff242424),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderWidget(
              headPath: item?.coverImg ?? "",
              level: 0,
              headWidth: 38,
              headHeight: 38,
              levelSize: 14,
              positionedSize: 0,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: 10,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ///user name
                          Container(
                            child: Text(
                              item == null ? Lang.UN_KNOWN : ((item?.name?.length ?? 0) > 9 ? item?.name?.substring(0, 9) : item?.name),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 16,
                                color: GlobalStore.isVIP() ? AppColors.primaryTextColor : Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              "帖子总数: " + getShowCountStr(item.videoCount),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xffacbabf),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _delCollectTag(index, item.id);
                      },
                      child: Center(
                        child: Container(
                          width: 82,
                          height: 26,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            //gradient: AppColors.linearBackGround,
                            color: Color.fromRGBO(255, 255, 255, 0.1),
                          ),
                          child: item.hasCollected
                              ? Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/weibo/images/blue_star.png",
                                        width: 14,
                                        height: 14,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        "已关注",
                                        style: TextStyle(fontSize: 14, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "关注",
                                        style: TextStyle(fontSize: 14, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
