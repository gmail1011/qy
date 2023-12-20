import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/new_page/mine/message_page.dart';
import 'package:flutter_app/new_page/mine/mine_exchange_code_input_page.dart';
import 'package:flutter_app/new_page/mine/mine_group_page.dart';
import 'package:flutter_app/new_page/mine/mine_invite_code_input_page.dart';
import 'package:flutter_app/new_page/mine/mine_original_page.dart';
import 'package:flutter_app/new_page/mine/mine_share_page.dart';
import 'package:flutter_app/new_page/mine/mine_suggest_page.dart';
import 'package:flutter_app/new_page/mine/setting_page.dart';
import 'package:flutter_app/new_page/msg/my_msg_page.dart';
import 'package:flutter_app/new_page/recharge/recharge_gold_page.dart';
import 'package:flutter_app/new_page/recharge/recharge_vip_page.dart';
import 'package:flutter_app/new_page/welfare/SpecialWelfareView.dart';
import 'package:flutter_app/page/ai/floating_ai_move_view.dart';
import 'package:flutter_app/page/home/mine/history/history_page.dart';
import 'package:flutter_app/page/home/mine/view.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/page/home/post/page/history/history_page.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/page_intro_helper.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'mine_account_profile_page.dart';
import 'mine_follow_page.dart';
import 'mine_help_page.dart';
import 'mine_publish_post_page.dart';
import 'mine_view_vp_page.dart';
import 'package:get/route_manager.dart' as Gets;

///我的
class MineHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MineHomePageState();
  }
}

class _MineHomePageState extends State<MineHomePage> with PageIntroHelper {
  WalletModelEntity wallet;

  UserInfoModel meInfo;
  RefreshController refreshController = RefreshController();
  ScrollController scrollController = new ScrollController();
  List<Menu> menu1 = [];
  List<Menu> menu2 = [];
  List<Menu> menu3 = [];
  List<AdsInfoBean> adsList = [];

  @override
  void initState() {
    super.initState();
    meInfo = GlobalStore.getMe();
    wallet = GlobalStore.getWallet();
    _initMenus();
    _initData();
    _getAdsList();
  }

  void _getAdsList() async {
    List<AdsInfoBean> list = await getAdsByType(AdsType.mineAds);
    setState(() {
      adsList = (list ?? []);
    });
  }

  void _initMenus() {
    menu1.add(Menu(
      "金币充值",
      "当前余额${wallet?.amount}",
      "assets/images/hj_mine_icon_gold1.png",
      () {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return RechargeGoldPage();
        })).then((value) => GlobalStore.refreshWallet());
      },
    ));
    menu1.add(Menu(
      "分享邀请",
      "邀请好友可领VIP",
      "assets/images/hj_mine_icon_share.png",
      () {

        Gets.Get.to(() => SpecialWelfareViewPage(0), opaque: false);

      },
    ));
    menu1.add(Menu(
      "推广赚佣金",
      "最高70%分成",
      "assets/images/hj_mine_icon_gold2.png",
      () {
        // bus.emit(EventBusUtils.flPage1);
        Gets.Get.to(() => SpecialWelfareViewPage(1), opaque: false);
      },
    ));

    menu2.add(Menu(
      "我的帖子",
      "",
      "assets/images/hj_mine_icon_post.png",
      () {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return MinePublishPostPage();
        }));
      },
    ));
    menu2.add(Menu(
      "我的收藏",
      "",
      "assets/images/hj_mine_icon_collect.png",
      () {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return MineViewVPPage(1);
        }));
      },
    ));
    menu2.add(Menu(
      "我的关注",
      "",
      "assets/images/hj_mine_icon_follow.png",
      () {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return MineFollowPage();
        }));
      },
    ));
    menu2.add(Menu(
      "官方招募",
      "",
      "assets/images/hj_mine_icon_publish.png",
      () {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return MineOriginalPage();
        }));
      },
    ));

    // menu3.add(Menu(
    //   "我的历史",
    //   "",
    //   "assets/images/hj_mine_icon_history.png",
    //       () {
    //     pushToPage(HistoryRecordPage(), context: context);
    //   },
    // ));
    menu3.add(Menu(
      "我的购买",
      "",
      "assets/images/hj_mine_icon_buy.png",
      () {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return MineViewVPPage(2);
        }));
      },
    ));
    menu3.add(Menu(
      "下载缓存",
      "",
      "assets/images/hj_mine_icon_cache.png",
      () {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return MineViewVPPage(3);
        }));
      },
    ));
    menu3.add(Menu(
      "填写邀请码",
      "",
      "assets/images/hj_mine_icon_invite_code.png",
      () {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return MineInviteCodeInputPage();
        }));
      },
    ));
    menu3.add(Menu(
      "填写兑换码",
      "",
      "assets/images/hj_mine_icon_exchange_code.png",
      () {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return MineExchangeCodeInputPage();
        }));
      },
    ));
    menu3.add(Menu(
      "帮助反馈",
      "",
      "assets/images/hj_mine_icon_feedback.png",
      () {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return MineHelpPage();
        }));
      },
    ));
    menu3.add(Menu(
      "意见反馈",
      "",
      "assets/images/icon_suggestion.png",
          () {

        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return MineSuggestPage();
        }));
      },
    ));
    menu3.add(Menu(
      "官方交流群",
      "",
      "assets/images/hj_mine_icon_group.png",
      () {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return MineGroupPage();
        }));
      },
    ));
  }

  void _initData() async {
    meInfo = await GlobalStore.updateUserInfo(null, true);
    wallet = await GlobalStore.refreshWallet();

    await Future.delayed(Duration(milliseconds: 500));
    //刷新成功
    refreshController?.refreshCompleted();
    var hasSaveQR = (await lightKV.getBool(Config.HAVE_SAVE_QR_CODE)) ?? false;
    // _showSaveQrDialog(context);

    if (!hasSaveQR) {
      _showSaveQrDialog(context);
    } else {
      if (!await hasEntered()) {
        setEntered(true);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  /// 首次进入二维码页面提示保存二维码
  Future _showSaveQrDialog(BuildContext ctx) async {
    var ret = await showConfirm(ctx,
        title: Lang.AVOID_ACCOUNT_LOSS,
        content: Lang.AVOID_ACCOUNT_LOSS_TIP,
        showCancelBtn: true,
        sureText: Lang.I_WANT_TO_SAVE,
        cancelText: Lang.I_ALREADY_SAVE);
    if (null != ret && ret) {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
        return MineAccountProfilePage();
      }));
    } else if (null != ret && !ret) {
      lightKV.setBool(Config.HAVE_SAVE_QR_CODE, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, screen.paddingTop + 8, 0, 0),
              child: pullYsRefresh(
                refreshController: refreshController,
                enablePullUp: false,
                enablePullDown: true,
                onRefresh: () async {
                  Future.delayed(Duration(milliseconds: 1000), () {
                    _initData();
                  });
                },
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                              //       return MyMsgPage();
                              //     }));
                              //   },
                              //   child: Container(
                              //     margin: EdgeInsets.symmetric(horizontal: 10),
                              //     child: Image.asset(
                              //       "assets/images/hj_mine_icon_message.png",
                              //       width: 24,
                              //       height: 24,
                              //     ),
                              //   ),
                              // ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                    return SettingPage();
                                  })).then((value) => _initData());
                                },
                                child: Container(
                                  child: Image.asset(
                                    "assets/images/hj_mine_icon_setting.png",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.only(right: 16),
                            child: Column(
                              children: [
                                _buildUserInfoUI(),
                                SizedBox(height: 10),
                                _buildVipInfoUI(),
                                SizedBox(height: 10),
                                _buildRechargeUI(menu1),
                                SizedBox(height: 10),
                                _buildH4XMenuUI(menu2),
                                SizedBox(height: 10),
                                _buildADSView(),
                                SizedBox(height: 10),
                                _buildVerticalMenuUI(menu3),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FloatingAiMoveView(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoUI() {
    return Container(
      height: 66,
      width: screen.screenWidth,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeaderWidget(
            headPath: meInfo?.portrait ?? "",
            level: (meInfo?.superUser ?? false) ? 1 : 0,
            headWidth: 66,
            headHeight: 66,
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
                          margin: EdgeInsets.only(top: 11),
                          child: Text(
                            meInfo == null
                                ? Lang.UN_KNOWN
                                : ((meInfo?.name?.length ?? 0) > 9 ? meInfo?.name?.substring(0, 9) : meInfo?.name),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 18,
                              color: GlobalStore.isVIP() ? Color.fromRGBO(246, 197, 89, 1) : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        ///user ID
                        Container(
                          margin: EdgeInsets.only(top: 11),
                          child: Text(
                            meInfo == null ? Lang.UN_KNOWN : "ID：${meInfo?.uid}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff949494),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                        return MineAccountProfilePage();
                      }));
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                      decoration: BoxDecoration(
                        color: Color(0xff1f1f1f),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        "账号凭证 >",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryTextColor
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVipInfoUI() {
    return InkWell(
      onTap: () {
        Gets.Get.to(() =>RechargeVipPage(""),opaque: false);
      },
      child: Container(
        height: 66,
        width: screen.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/hj_mine_bg_vip.png"),fit: BoxFit.fill)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            GlobalStore.isVIP() ? "当前${meInfo?.vipName}" : "VIP限时特惠  畅享全场",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            (GlobalStore.isVIP()
                    ? "会员有效期：${getVipStringFromTime(meInfo?.vipExpireDate, netManager.getFixedCurTime(), isChina: true)}"
                    : "开通VIP全场畅看 ") +
                "\t\t剩余可下载次数${wallet?.downloadCount ?? 0}",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xfff5c39c),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildRechargeUI(List<Menu> menus) {
    return Container(
      child: GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 0,
            childAspectRatio: 111 / 115,
          ),
          itemCount: menus.length,
          itemBuilder: (BuildContext context, int index) {
            var item = menus[index];

            return GestureDetector(
                onTap: () {
                  item.callClick();
                },
                child: Container(
                  padding: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage(item.background))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item.desc,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xffa0a0a0),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ));
          }),
    );
  }

  Widget _buildH4XMenuUI(List<Menu> menus) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff242424),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 0, mainAxisSpacing: 0, childAspectRatio: 1),
          itemCount: menus.length,
          itemBuilder: (BuildContext context, int index) {
            var item = menus[index];
            return GestureDetector(
                onTap: () {
                  item.callClick();
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        item.background,
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(height: 5),
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xffa0a0a0),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ));
          }),
    );
  }

  Widget _buildVerticalMenuUI(List<Menu> menus) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff242424),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: ListView.builder(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: menus.length,
          itemBuilder: (BuildContext context, int index) {
            var item = menus[index];
            return InkWell(
                onTap: () {
                  item.callClick();
                },
                child: Container(
                  height: 40,
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Image.asset(
                                item.background,
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 10),
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff999999),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          ">",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xffa0a0a0),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          }),
    );
  }

  Widget _buildADSView() {
    return Visibility(
      visible: ((adsList?.length ?? 0) != 0),
      child: AspectRatio(
        aspectRatio: 720 / 200,
        child: AdsBannerWidget(adsList, onItemClick: (index) {
          var ad = adsList[index];
          JRouter().handleAdsInfo(ad.href, id: ad.id);
        }),
      ),
    );
  }
}

class Menu {
  var title;
  var desc;
  var background;
  Function callClick;

  Menu(this.title, this.desc, this.background, this.callClick);
}
