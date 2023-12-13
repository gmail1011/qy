import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/task_center_data.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/new_page/mine/mine_share_page.dart';
import 'package:flutter_app/new_page/recharge/recharge_gold_page.dart';
import 'package:flutter_app/new_page/recharge/recharge_vip_page.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/video/video_publish/page.dart';
import 'package:flutter_app/page/video/video_publish/state.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/community_recommend/detail/community_detail_page.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WelfareViewTask extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WelfareViewTaskState();
  }
}

class _WelfareViewTaskState extends State<WelfareViewTask> {
  UserInfoModel meInfo;
  WalletModelEntity wallet;

  int shareCount = 0;

  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();

  List<DailyTask> taskList = [];

  // @override
  // bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    meInfo = GlobalStore.getMe();
    wallet = GlobalStore.getWallet();
    _loadShareCount();
    _initTaskList();
  }

  ///初始化任务列表
  void _initTaskList() async {
    try {
      TaskCenterData result = await netManager.client.getMyTaskList();

      taskList.clear();
      refreshController.refreshCompleted();
      if (result.dailyTask.isEmpty && result.onceTask.isEmpty)
        requestController.requestDataEmpty();
      else {
        l.d('_initTaskList_count', result.dailyTask.length);

        if (result.onceTask != null)
          result.onceTask.forEach((element) {
            element.doType = 2;
          });
        taskList.addAll(result.onceTask ?? []);

        if (result.dailyTask != null)
          result.dailyTask.forEach((element) {
            element.doType = 1;
          });
        taskList.addAll(result.dailyTask ?? []);

        requestController.requestSuccess();
        setState(() {});
      }
    } catch (e) {
      l.d('getProxyBindRecord', e.toString());
      requestController?.requestFail();
    }
  }

  void _loadShareCount() async {
    try {
      var record = await netManager.client.getProxyBindRecord(1, 1);
      shareCount = record.total;
    } catch (e) {
      l.d('getProxyBindRecord', e.toString());
    }
  }

  void _doTask(String taskId, int type) async {
    try {
      await netManager.client.doTask(taskId, type);
      _initTaskList();
    } catch (e) {
      l.d('getProxyBindRecord', e.toString());
    }
  }

  void _receiveTask(String taskId, int type) async {
    try {
      await netManager.client.receiveTask(taskId, type);
      _initTaskList();
      wallet = await GlobalStore.refreshWallet();
      setState(() {});
    } catch (e) {
      l.d('getProxyBindRecord', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 16),
                  HeaderWidget(
                    headPath: meInfo?.portrait ?? "",
                    level: (meInfo?.superUser ?? false) ? 1 : 0,
                    headWidth: 54,
                    headHeight: 54,
                    levelSize: 14,
                    positionedSize: 0,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 1),
                          child: Text(
                            meInfo.name ?? "",
                            style: const TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: 16.0),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "剩余观看次数${meInfo.watchCount}",
                          style: const TextStyle(color: const Color(0xffacbabf), fontWeight: FontWeight.w400, fontSize: 14.0),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Gets.Get.to(() => RechargeVipPage(""), opaque: false);
            },
            child: Container(
              width: 298,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(31)),
                gradient: AppColors.linearBackGround,
              ),
              child: Center(
                child: Text(
                  "开通VIP  无限次数免费观看",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: BaseRequestView(
              controller: requestController,
              retryOnTap: _initTaskList,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                  ),
                ),
                child: pullYsRefresh(
                  refreshController: refreshController,
                  enablePullUp: false,
                  onRefresh: () async {
                    Future.delayed(Duration(milliseconds: 1000), () {
                      _initTaskList();
                    });
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(8, 22, 8, 0),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "福利任务\t\t",
                                      style: const TextStyle(color: const Color(0xff000000), fontWeight: FontWeight.w500, fontSize: 16.0),
                                    ),
                                    Text(
                                      "提示：若状态未更新 请下拉刷新哦～",
                                      style: const TextStyle(color: const Color(0xff3e5157), fontWeight: FontWeight.w300, fontSize: 12.0),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "邀请人数$shareCount人",
                                      style: const TextStyle(color: const Color(0xff666666), fontSize: 12.0),
                                    ),
                                    Text(
                                      "我的积分${wallet.integral}",
                                      style: const TextStyle(color: const Color(0xff666666), fontSize: 12.0),
                                    ),
                                    _buildTaskBtn("兑换VIP", 0, () {
                                      Gets.Get.to(() => RechargeVipPage(""), opaque: false);
                                    })
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          ListView.builder(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: taskList.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildTaskItem(taskList[index]);
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(DailyTask item) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: Color(0xfffafafa),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: CustomNetworkImage(
                        imageUrl: item.img,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 12, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 2),
                              child: Text(
                                item.title ?? "",
                                style: TextStyle(color: Color(0xff393639), fontWeight: FontWeight.w500, fontSize: 14.0),
                              ),
                            ),
                            Text(
                              item.desc,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: const Color(0xffaaaaaa), fontWeight: FontWeight.w400, fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildTaskBtn(_getTaskStatus(item.status), item.status, () {
                switch (item.status) {
                  case 0: //未完成
                    taskJump(item.link);
                    if (item.doType == 2) _doTask(item.id, item.doType);
                    break;
                  case 1: //待领取
                    _receiveTask(item.id, item.doType);
                }
                if (item.status != 2) AnalyticsEvent.clickActive(item.title, item.id);
              })
            ],
          ),
        ));
  }

  String _getTaskStatus(int status) {
    var tStatus = "去完成";
    switch (status) {
      case 0:
        tStatus = "去完成";
        break;
      case 1:
        tStatus = "待领取";
        break;
      case 2:
        tStatus = "已完成";
        break;
    }
    return tStatus;
  }

  Widget _buildTaskBtn(String btnTxt, int status, Function callClick) {
    return InkWell(
      onTap: () {
        callClick();
      },
      child: Container(
        width: 69,
        height: 28,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            gradient: LinearGradient(
              colors: status == 1
                  ? [
                      AppColors.primaryTextColor,
                      AppColors.primaryTextColor,
                    ]
                  : status == 2
                      ? [
                          Color.fromRGBO(150, 150, 150, 1),
                          Color.fromRGBO(150, 150, 150, 1),
                        ]
                      : [
                          AppColors.primaryTextColor,
                          AppColors.primaryTextColor,
                        ],
            )),
        child: Center(
          child: Text(
            btnTxt,
            style: TextStyle(
                color: status == 1 ? Color(0xff333333) : Colors.white.withOpacity(0.9), fontWeight: FontWeight.w500, fontSize: 12.0),
          ),
        ),
      ),
    );
  }

//{ label: "客服", value: "yinseinner://kefu" },
// { label: "社区", value: "yinseinner://community_page" },
// { label: "推广", value: "yinseinner://universal_agent" },
// { label: "会员", value: "yinseinner://vip_page" },
// { label: "钱包", value: "yinseinner://wallet_page" },
// { label: "发布", value: "yinseinner://publish_page" },
// { label: "视频详情", value: "yinseinner://video?id=" },
// { label: "帖子详情", value: "yinseinner://postInfo?id=" },
  void taskJump(String link) {
    if (link.contains("http"))
      launchUrl(link);
    else
      switch (link) {
        case "yinseinner://kefu":
          csManager.openServices(context);
          break;
        case "yinseinner://community_page":
          bus.emit(EventBusUtils.sheQu);
          break;
        case "yinseinner://universal_agent":
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
            return MineSharePage();
          }));
          break;
        case "yinseinner://vip_page":
          Gets.Get.to(() => RechargeVipPage(""), opaque: false);
          break;
        case "yinseinner://wallet_page":
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
            return RechargeGoldPage();
          }));
          break;
        case "yinseinner://publish_page":
          Map<String, dynamic> map = {
            'type': UploadType.UPLOAD_IMG,
            'pageType': 0,
          };
          Gets.Get.to(VideoAndPicturePublishPage().buildPage(map), opaque: false);

          break;
        case "yinseinner://binding_page":
          JRouter().go(PAGE_INITIAL_BIND_PHONE);
          break;
        default:
          if (link.contains("video?id=")) {
            String id = link.split("=").last;
            Map<String, dynamic> maps = Map();
            maps["videoId"] = id;
            Gets.Get.to(FilmTvVideoDetailPage().buildPage(maps), opaque: false);
          } else if (link.contains("postInfo?id=")) {
            String id = link.split("=").last;
            Gets.Get.to(CommunityDetailPage().buildPage({"videoId": id}), opaque: false);
          }
      }
  }
}
