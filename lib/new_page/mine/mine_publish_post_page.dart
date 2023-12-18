import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/new_page/recharge/income_record_page.dart';
import 'package:flutter_app/new_page/recharge/withdraw_page.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidgetForHjll.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///我发布的帖子
class MinePublishPostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MinePublishPostPageState();
  }
}

class _MinePublishPostPageState extends State<MinePublishPostPage> with TickerProviderStateMixin {
  List<VideoModel> videoList = [];

  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();
  WalletModelEntity wallet;

  @override
  void initState() {
    super.initState();
    wallet = GlobalStore.getWallet();
    _loadData(true);
  }

  var page = 1;

  void _loadData(bool isReload) {
    if (isReload)
      page = 1;
    else
      page += 1;
    getVideo();
  }

  void setReqControllerState(bool isCatch, bool dataIsEmpty, bool hasNext) {
    if (isCatch) {
      if (page == 1) {
        refreshController.refreshFailed();
      } else {
        refreshController.loadFailed();
      }

      requestController.requestFail();
    } else {
      requestController.requestSuccess();
      if (page == 1 && dataIsEmpty)
        requestController.requestDataEmpty();
      else {
        if (page == 1)
          refreshController.refreshCompleted();
        else {
          refreshController.loadComplete();
          if (dataIsEmpty) refreshController.loadNoData();
        }
        if (!hasNext) refreshController.loadNoData();
      }
    }
  }

  ///加载视频数据
  void getVideo() async {
    try {
      MineVideo videos = await netManager.client.getMineWorks(Config.PAGE_SIZE, page, "", "");
      if (page == 1) videoList.clear();
      if ((videos.list ?? []).isNotEmpty) {
        videoList.addAll(videos.list);
        setReqControllerState(false, false, videos.hasNext);
      } else {
        if (page == 1)
          setReqControllerState(false, true, false);
        else
          setReqControllerState(false, false, videos.hasNext);
      }
      setState(() {});
    } catch (e) {
      setReqControllerState(true, true, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        appBar: CustomAppbar(
          title: "我的帖子",
        ),
        body: Column(
          children: [
            // Container(
            //   height: 135,
            //   margin: EdgeInsets.symmetric(horizontal: 16),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.all(Radius.circular(4)),
            //     color: AppColors.primaryColor,
            //   ),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text("可提现收益：${wallet.income}金币",
            //           style: const TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: 16.0),
            //           textAlign: TextAlign.left),
            //       SizedBox(height: 20),
            //       Container(
            //           //padding: EdgeInsets.only(),
            //           child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceAround,
            //         children: [
            //           _buildBtn("立即提现", () {
            //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
            //               return WithdrawPage();
            //             }));
            //           }),
            //           _buildBtn("收益明细", () {
            //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
            //               return IncomeRecordPage();
            //             }));
            //           }),
            //         ],
            //       ))
            //     ],
            //   ),
            // ),
            Expanded(
              child: BaseRequestView(
                controller: requestController,
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: pullYsRefresh(
                      refreshController: refreshController,
                      onRefresh: () async {
                        Future.delayed(Duration(milliseconds: 1000), () {
                          _loadData(true);
                        });
                      },
                      onLoading: () => _loadData(false),
                      child: ListView.builder(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          shrinkWrap: true,
                          itemCount: videoList.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildPostItem(videoList[index]);
                          })),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBtn(String btnText, Function callClick) {
    return GestureDetector(
      onTap: () => callClick(),
      child: Container(
        width: 120,
        height: 35,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), gradient: AppColors.linearBackGround),
        child: Center(
          child: Text(
            btnText,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12.0),
          ),
        ),
      ),
    );
  }

  Widget _buildPostItem(VideoModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WordImageWidgetForHjll(
          videoModel: item,
          showTopInfo: false,
          hideTopUserInfo: true,
          isMyPublish: true,
        ),
      ],
    );
  }
}
