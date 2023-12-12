import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/model/user/mine_work_unit.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/new_page/recharge/recharge_gold_page.dart';
import 'package:flutter_app/new_page/welfare/SpecialWelfareHomePage.dart';
import 'package:flutter_app/page/MyLikeCollectListPage/MyVIdeoCollectDetailPage.dart';
import 'package:flutter_app/page/anwang_trade/widget/double_btn_view.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video/video_cell_widget.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/publish/works_manager/work_unit_detail_page.dart';
import 'package:flutter_app/page/user/member_centre_page/page.dart';
import 'package:flutter_app/page/video/video_list_model/recommend_list_model.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/message/message_detail/MessageDetailPage.dart';
import 'package:flutter_app/weibo_page/message/message_list_entity.dart';
import 'package:flutter_app/weibo_page/widget/MyFansPage.dart';
import 'package:flutter_app/weibo_page/widget/my_unit_table.dart';
import 'package:flutter_app/weibo_page/widget/reward_avatar_entity.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidget.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidgetForHjll.dart';
import 'package:flutter_app/widget/common_widget/LoadingWidget.dart'
    as Loadings;
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/dialog/alert_tool.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/dialog/newdialog/coinVideo_dailog_hjll.dart';
import 'package:flutter_app/widget/dialog/popup_view.dart';
import 'package:flutter_app/widget/dialog/vip_level_dialog.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/task_manager/dialog_task_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/route_manager.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'MyFollowPage.dart';
import 'ReportPage.dart';
import 'SwitchBackground.dart';

///个人主页
class BloggerPage extends StatefulWidget {
  Map<String, dynamic> arguments = new Map();

  final VoidCallback onTap;

  BloggerPage(this.arguments, {this.onTap}) : super();

  @override
  State<StatefulWidget> createState() {
    return BloggerPageState();
  }
}

class BloggerPageState extends State<BloggerPage> {
  GlobalKey _rightKey = GlobalKey();


  int uid;
  PublisherBean publisher;

  UserInfoModel userInfo;


  TextEditingController textEditingController = new TextEditingController();

  ///抖音
  List<VideoModel> videos;
  int videoPageNum = 1;
  int videoPageSize = 14;
  RefreshController refreshController = RefreshController();
  BaseRequestController baseRequestController = BaseRequestController();

  String backgroundImage;
  RewardAvatarData rewardAvatarData;
  bool initVideoData = true;
  bool isRecommandVideo = false;

  // 置顶参数
  String setTopVideoId = "";
  int setTopAction = 1;
  String setTopType = "SP";

  int setExtensionAction = 2;


  @override
  void initState() {
    super.initState();
    uid = widget.arguments['uid'];
    publisher = widget.arguments['publisher'];
    isRecommandVideo = false;
    if (uid == 0 &&
        (widget.arguments.containsKey("recommand") &&
            (widget.arguments["recommand"] ?? false))) {
      uid = recommendListModel.curItem()?.publisher?.uid;
      isRecommandVideo = true;
    }

    initData();
    GlobalStore.refreshWallet();
  }

  _refreshData() async{
    videoPageNum = 1;
    await getVideo(false);

  }

  _loadMoreData() async{
    videoPageNum += 1;
    await getVideo(false);
  }


  @override
  void dispose() {
    refreshController?.dispose();
    textEditingController?.dispose();
    super.dispose();
  }

  void initData() async {
    try {
      userInfo = await netManager.client.getUserInfo(uid);

      setState(() {});

      Future.delayed(Duration(milliseconds: 100), () {
        getVideo(true);
      });

    } catch (e) {
      //l.e("loadUser", "_onLoadUserInfo()...error:$e");
    }
  }

  ///加载视频数据
  void getVideo(bool initData) async {
    try {
      if (initData) {
        initVideoData = true;
      }
      MineVideo videoss = await netManager.client.getMineWorks(
        videoPageSize,
        videoPageNum,
        "SP",
        "new",
        (userInfo.uid == GlobalStore.getMe().uid) ? null : uid,
      );
      if(videoPageNum==1){
        videos = [];
      }
      if(videoss.list!=null){
        videos.addAll(videoss.list);
      }
      if(videoPageNum==1){
        refreshController.refreshCompleted();
      }else{
        refreshController.loadComplete();
      }
      if (!videoss.hasNext) {
        refreshController.loadNoData();
      }
      setState(() {
        initVideoData = false;
      });
    } catch (e) {
      //l.e("loadUser", "_onLoadUserInfo()...error:$e");
      setState(() {
        initVideoData = false;
      });
      if (initData) {
        refreshController.refreshFailed();
      } else {
        refreshController.loadFailed();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50,),
                GestureDetector(
                  child: Image.asset("assets/weibo/back_arrow.png",width: 30,height: 30,),
                  onTap: (){
                    safePopPage();
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    UnconstrainedBox(
                      child: (userInfo==null)?SizedBox():SizedBox(
                        width: 84,
                        height: 84,
                        child: ClipOval(
                          child: CustomNetworkImage(
                            fit: BoxFit.cover,
                            height: 84,
                            width: 84,
                            imageUrl: userInfo.portrait??"",
                          ),
                        ),
                      ),
                    ),
                    if (!GlobalStore.isMe(userInfo?.uid))
                      GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(top: 16),
                            height: 26,
                            padding: EdgeInsets.fromLTRB(10, 4, 8, 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                gradient: LinearGradient(colors: [
                                   Color(0xffca452e),
                                   Color(0xffca452e)
                                ])),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset("assets/images/message_white.png", width: 14),
                                const SizedBox(width: 6),
                                Text(
                                  "私信TA",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          onTap: () async {
                            Loadings.LoadingWidget loadings = new Loadings.LoadingWidget(
                              title: "正在加载...",
                            );
                            loadings.show(context);
                            dynamic videoss;
                            try {
                              videoss = await netManager.client.getSessionId(uid);
                              loadings.cancel();
                            } catch (e) {
                              debugLog(e);
                              loadings.cancel();
                              showToast(msg: "服务器错误");
                              return;
                            }

                            MessageListDataList message = new MessageListDataList();
                            message.userId = userInfo.uid;
                            message.takeUid = userInfo.uid;
                            message.userAvatar = userInfo.portrait;
                            message.sessionId = videoss;
                            message.userName = userInfo.name;
                            pushToPage(
                              MessageDetailPage(message),
                            );
                          }),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${userInfo?.name??""}",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 16),),
                        SizedBox(width: 13,),
                        ( userInfo?.isVip??false)
                            ? Container(
                          padding: EdgeInsets.only(left: 5,right: 5,top: 1,bottom: 1),
                          child: (userInfo?.vipLevel==1)?Text("月卡用户",style: TextStyle(color: Color.fromRGBO(102, 56, 0, 1),fontSize: 10),)
                              :(userInfo?.vipLevel==2)?Text("季卡用户",style: TextStyle(color: Color.fromRGBO(102, 56, 0, 1),fontSize: 10),)
                              :(userInfo?.vipLevel==3)?Text("年卡用户",style: TextStyle(color: Color.fromRGBO(102, 56, 0, 1),fontSize: 10),)
                              :Text("永久会员",style: TextStyle(color: Color.fromRGBO(102, 56, 0, 1)),),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(2)),
                              gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(238, 217, 180, 1),
                                    Color.fromRGBO(174, 138, 95, 1)
                                  ]
                              )
                          ),
                        ) : Container(),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${userInfo?.fansCountDesc??"0"}粉丝",style: TextStyle(color: Color(0xffc0c1d0),fontSize: 12),),
                        (publisher==null || publisher?.upTag == null || publisher.upTag == "")?SizedBox():  Text("${publisher.upTag }",style: TextStyle(color: Color(0xffc0c1d0),fontSize: 12),),
                        (publisher==null || publisher?.upTag == null || publisher.upTag == "")?SizedBox():Image.asset("assets/weibo/ic_uptag.png",width: 20,height: 20),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 88,
                  height: 32,
                  margin: EdgeInsets.only(left: 10, top: 16, bottom: 16),
                  alignment: Alignment.center,
                  child: Text("帖子(${userInfo?.collectionCount})",style: TextStyle(color: Color.fromRGBO(172, 186, 191, 1),fontSize: 12),),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                   color: Color.fromRGBO(32, 32, 32, 1),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: videos == null
              ? LoadingWidget()
              : pullYsRefresh(
            refreshController: refreshController,
            onLoading: () {
              _loadMoreData();
            },
            onRefresh: () {
              _refreshData();
            },
            child: ListView.builder(
              itemCount: (videos==null)?0:videos.length,
              itemBuilder: (context, index) {
                return WordImageWidgetForHjll(
                  videoModel:videos[index],
                  padding: EdgeInsets.only(left: 10, right: 10, top: 12),
                  showLeftLine: false,
                  showPostTimeText:true,
                  hideTopUserInfo: true,
                  showTopInfo: false,
                  isHaiJiaoLLDetail: false,
                  tagColor: Color(0xff74b7f1),
                );
              },
            ),

          ))
          ,
        ],
      ),
    );
  }
}

