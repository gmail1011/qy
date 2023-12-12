import 'dart:ui';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:encrypt/encrypt.dart' as AES;
import 'package:encrypt/encrypt.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/page/game_surface/GameSurface.dart';
import 'package:flutter_app/page/game_surface/overlay/overlay_tool_wrapper.dart';
import 'package:flutter_app/page/game_wallet/wallet_main/page.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/page/wallet/game_bill_detail/GameBillDetailPage.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/YYMarquee.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bean/GameBean.dart';
import 'bean/game_balance_entity.dart';
import 'game_page_state.dart';

Widget buildView(
    GamePageState state, Dispatch dispatch, ViewService viewService) {
  return GamePage();
}

class GamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GamePageState();
  }
}

class _GamePageState extends State<GamePage> {
  LoadingWidget loadingWidget;
  GameBalanceEntity gameBalanceEntity;
  GameBean gameBean;

  List<Bean> list = [];

  ///平台IP白名单
  String ipSafeAddress = "18.166.220.228";

  ///平台API地址
  String apiAdress = "https://www.walitest.com:7021/api/";

  ///代理ID
  String agentId = "139";

  ///API账号 密钥编号
  String apiAccount = "2zmvf";

  ///请求签名密钥
  String signKey = "t9z,!8z\$)p";

  ///参数加密秘钥    Base64: UHuClkdx0jo6VO6LLYn6eA== , 16进制: 507b82964771d23a3a54ee8b2d89fa78
  String aesKey = "UHuClkdx0jo6VO6LLYn6eA==";

  String Ping = "ping?";

  //密钥编号
  //String apiAccount = aesKey +  signKey;

  List<String> saveGameList = [];
  List<Bean> saveGameListHistory = [];

  String SaveGameList = "SaveGameList";

  StringBuffer stringBuffer = new StringBuffer();

  dynamic gameBalance;
  dynamic gameAnnouncement;

  List<AdsInfoBean> adsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveGameList = SpUtil.getStringList(SaveGameList, defValue: List<String>());

    loadingWidget = new LoadingWidget(
      title: "正在加载...",
    );

    initList();
    getData();
    getAdsList();
  }

  void initList() async {
    list.add(Bean("捕鱼", "assets/images/py.png", 1));
    list.add(Bean("斗地主", "assets/images/ddz.png", 2));
    list.add(Bean("炸金花", "assets/images/zjh.png", 3));
    list.add(Bean("百人牛牛", "assets/images/brnn.png", 4));
    list.add(Bean("抢庄牛牛", "assets/images/qznn.png", 5));
    list.add(Bean("二人麻将", "assets/images/ermj.png", 6));
    list.add(Bean("红黑大战", "assets/images/hhdz.png", 7));
    list.add(Bean("德州扑克", "assets/images/dzpk.png", 8));
    list.add(Bean("跑得快", "assets/images/pdk.png", 10));
    list.add(Bean("龙虎斗", "assets/images/lhdz.png", 12));
    list.add(Bean("奔驰宝马", "assets/images/bcbm.png", 18));
    list.add(Bean("飞禽走兽", "assets/images/fqzs.png", 19));
    list.add(Bean("黑杰克", "assets/images/hjk.png", 25));
    list.add(Bean("抢庄三公", "assets/images/qzsg.png", 26));
    list.add(Bean("抢庄牌九", "assets/images/qzpj.png", 28));
    list.add(Bean("二八杠", "assets/images/ebg.png", 29));
    list.add(Bean("多福多财", "assets/images/dfdc.png", 30));
    list.add(Bean("红包扫雷", "assets/images/hbsl.png", 31));
    list.add(Bean("经典牛牛", "assets/images/jdnn.png", 32));

    if (saveGameList.length > 0) {
      saveGameListHistory.clear();
      for (int i = 0; i < saveGameList.length; i++) {
        for (int j = 0; j < list.length; j++) {
          if (saveGameList[i] == list[j].name) {
            saveGameListHistory.add(list[j]);
          }
        }
      }
    }
  }

  void getData() async {
    await netManager.client.getFirstEnterGame();
    gameBalance = await netManager.client.getBalance();
    gameAnnouncement = await netManager.client.getGameAnnouncement();
    if (gameBalance != null && gameAnnouncement != null) {
      if ((gameAnnouncement["announcement"] as List).length > 0) {
        (gameAnnouncement["announcement"] as List).forEach((element) {
          stringBuffer.write(element);

          stringBuffer.write("      ");
        });
      }

      setState(() {});
    }
  }

  void getAdsList() async {
    adsList = await getAdsByType(AdsType.gamesLobby);
    setState(() {});
  }

  void _onFrameCallBack(Duration timeStamp) {
    OverlayToolWrapper.of(context).showFloating();
  }

  void _onFrameCallBackHide(Duration timeStamp) {
    OverlayToolWrapper.of(context).hideFloating();
  }

  /// 1.所有参数拼成一个字符串，每个参数格式为 ${参数名}=${参数值}，参数间用 & 分隔
  /// 目前所有接又的参数名、参数值都不会出现特殊符号，所以，均无需转义。 拼好的字符串如: name=Alice&text=Hello
  ///
  /// 2.将上步骤得到的字符串转为字节数组(UTF-8编码)，并进行 AES 加密。
  /// AES 为 AES-128。秘钥使用之前从后台获取的 aesKey 。加密使用 ECB 模式，不需要 IV。加密使用 PKCS#5/PKCS#7 Padding
  ///

  //AES加密
  dynamic aesEncrypt(plainText) {
    try {
      final key = AES.Key.fromUtf8(plainText);
      final encrypter = AES.Encrypter(AES.AES(key, mode: AES.AESMode.ecb));
      final text =
          "A set of high-level APIs over PointyCastle for two-way cryptography.";
      final encrypted = encrypter.encrypt(text);
      final decrypted = encrypter.decrypt(encrypted);

      print(decrypted);
      print(encrypted.base64);
    } catch (err) {
      print("aes encode error:$err");
      return plainText;
    }
  }

  static String generateAES(String data, String keyStr) {
    final plainText = data;
    final key = AES.Key.fromBase64(keyStr);
    //final iv = AES.IV.fromUtf8(ivStr);
    final encrypter = Encrypter(AES.AES(key, mode: AESMode.ecb));
    final encrypted = encrypter.encrypt(
      plainText,
    );
    final decrypted = encrypter.decrypt(
      encrypted,
    );

    print("解密后的数据    " +
        decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    print("加密后的数据    " + encrypted.base64); // R4PxiU3h8YoIRq

    return encrypted.base64;
  }

  /// 获取余额
  Future getBalance() async {
    var resp = await netManager.client.getBalance();
    gameBalanceEntity = GameBalanceEntity().fromJson(resp);
  }

  Future getGameUrl(String gameId) async {
    var resp = await netManager.client.getGameUrl(gameId);
    gameBean = GameBean.fromJson(resp);
    print("DFEF");
  }

  Widget operateItem(String title, String svg, Function onTap, bool isImg) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          (isImg ?? false)
              ? assetsImg(
                  svg,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                )
              : svgAssets(
                  svg,
                  width: 44,
                  height: 44,
                ),
          SizedBox(
            height: 6,
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List historyGameList() {
    return saveGameListHistory.map((i) => historyGameItem(i)).toList();
  }

  Widget historyGameItem(i) {
    return GestureDetector(
      onTap: () async {
        loadingWidget.show(context);

        saveGameList.clear();
        saveGameList =
            SpUtil.getStringList(SaveGameList, defValue: List<String>());
        Bean bean = i;
        bool isExisted = false;
        if (saveGameList.length > 0) {
          for (int i = 0; i < saveGameList.length; i++) {
            if (saveGameList[i] == bean.name) {
              isExisted = true;
            }
          }
        }

        if (!isExisted) {
          saveGameList.add(bean.name);
        }

        SpUtil.putStringList(SaveGameList, saveGameList);

        if (saveGameList.length > 0) {
          saveGameListHistory.clear();
          for (int i = 0; i < saveGameList.length; i++) {
            for (int j = 0; j < list.length; j++) {
              if (saveGameList[i] == list[j].name) {
                saveGameListHistory.add(list[j]);
              }
            }
          }
        }

        await getBalance();
        if (gameBalanceEntity.wlTransferable + gameBalanceEntity.wlBalance ==
            0) {
          showToast(msg: "游戏钱包余额不足，请先从App钱包划转至游戏钱包才能正常游戏呦～");
        }

        await getGameUrl(i.index.toString());
        loadingWidget.cancel();

        Config.isGameSurface = true;
        WidgetsBinding.instance.addPostFrameCallback(_onFrameCallBack);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return GameSurfacePage(gameBean.gameUrl);
        })).then((value) {
          Config.isGameSurface = false;
          WidgetsBinding.instance.addPostFrameCallback(_onFrameCallBackHide);
          AutoOrientation.portraitAutoMode();
          SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

          setState(() {});
        });
      },
      child: Container(
        width: 140,
        height: 88,
        margin: EdgeInsets.only(right: 12),
        child: Column(
          children: [
            ClipRRect(
              child: Stack(
                children: [
                  Image.asset(
                    i.url,
                    width: 140,
                    height: 78,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                i.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Config.gameBalanceEntity == null ||
              Config.gameBalanceEntity.wlTransferable == null
          ? Center(child: LoadingWidget())
          : getWidget(),
    );
  }

  Widget getWidget() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            /*Container(
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 6,top: 10),
                alignment: Alignment.centerLeft,
                child: saveGameListHistory.length ==  0 ? SizedBox.shrink() : Text("最近玩过",
                    style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w600))),
            saveGameListHistory.length ==  0 ? SizedBox.shrink() : Container(
              height: 94,
              margin: EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ListView.builder(
                itemCount: saveGameListHistory.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {

                      loadingWidget.show(context);

                      await getBalance();
                      if(gameBalanceEntity.wlTransferable + gameBalanceEntity.wlBalance  == 0){
                        showToast(msg: "游戏钱包余额不足，请先从App钱包划转至游戏钱包才能正常游戏呦～");
                      }

                      await getGameUrl(list[index].index.toString());
                      loadingWidget.cancel();

                      Config.isGameSurface = true;
                      WidgetsBinding.instance.addPostFrameCallback(_onFrameCallBack);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return GameSurfacePage(gameBean.gameUrl);
                          })).then((value) {
                        Config.isGameSurface = false;
                        WidgetsBinding.instance.addPostFrameCallback(_onFrameCallBackHide);
                        AutoOrientation.portraitAutoMode();
                        SystemChrome.setEnabledSystemUIOverlays(
                            SystemUiOverlay.values);

                        setState(() {

                        });
                      });


                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 6),
                      child: Column(
                        children: [
                          ClipRRect(
                            child: Stack(
                              children: [
                                Image.asset(
                                  saveGameListHistory[index].url,
                                  height: 76,
                                  width: 120,
                                ),
                              ],
                            ),
                            //borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              saveGameListHistory[index].name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: Color.fromRGBO(0, 0, 0, 1)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),*/
            (adsList?.length ?? 0) > 0
                ? Container(
                    margin: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AdsBannerWidget(
                        adsList,
                        width: 1.sw,
                        height: 126,
                        onItemClick: (index) {
                          var ad = adsList[index];
                          JRouter().handleAdsInfo(ad.href, id: ad.id);
                        },
                      ),
                    ),
                  )
                : Container(),
            // SliverToBoxAdapter(
            //   child: Container(
            //     height: 40.w,
            //     // width: ScreenUtil().screenWidth,
            //     color: AppColors.weiboJianPrimaryBackground,
            //     child: Row(
            //       children: [
            //         SizedBox(
            //           width: 18.w,
            //         ),
            //         Image.asset(
            //           "assets/weibo/lingdang.png",
            //           width: 16.w,
            //           height: 16.w,
            //         ),
            //         SizedBox(
            //           width: 10.w,
            //         ),
            //         Text("活动公告 : ",
            //             style: TextStyle(
            //               fontSize: 14.nsp,
            //               color: Colors.white,
            //             )),
            //         Expanded(
            //           child: Container(
            //             height: 40.w,
            //             padding: EdgeInsets.only(
            //               left: 6.w,
            //               right: 16.w,
            //             ),
            //             child: YYMarquee(
            //                 Text(stringBuffer.toString(),
            //                     style: TextStyle(
            //                       fontSize: 14.nsp,
            //                       color: Colors.white,
            //                     )),
            //                 200,
            //                 new Duration(seconds: 5),
            //                 230.0,
            //                 keyName: "community_recommend"),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Visibility(
              visible: stringBuffer.length == 0 ? false : true,
              child: Container(
                height: Dimens.pt36,
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                color: Color(0xFF1E1E1E),
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                    ),
                    Image.asset(
                      "assets/weibo/lingdang.png",
                      width: 16,
                      height: 16,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("公告 : ",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        )),
                    Expanded(
                      child: Container(
                        height: 40,
                        padding: EdgeInsets.only(
                          left: 6,
                          right: 16,
                        ),
                        child: YYMarquee(
                            Text(stringBuffer.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                )),
                            200,
                            new Duration(seconds: 5),
                            230.0,
                            keyName: "community_recommend"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: Dimens.pt105,
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 16),
              decoration: BoxDecoration(
                  // color: Colors.white,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.3),
                  //     spreadRadius: 0,
                  //     blurRadius: 8,
                  //     offset: Offset(0, 1), // changes position of shadow
                  //   ),
                  // ],
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFa770ef),
                      Color(0xFFcf8bf3),
                      Color(0xFFfdaa9b),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(Dimens.pt10))),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 12, top: 6),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "游戏余额 (元)",
                                style: TextStyle(
                                  fontSize: Dimens.pt16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          // GestureDetector(
                          //   onTap: () {
                          //     JRouter().go(PAGE_INITIAL_BIND_PHONE);
                          //   },
                          //   child: Container(
                          //       margin: EdgeInsets.only(top: 6, right: 12),
                          //       alignment: Alignment.centerLeft,
                          //       child: Text(
                          //         "綁定手機再送3金幣 >",
                          //         style: TextStyle(
                          //             fontSize: Dimens.pt12,
                          //             color: Color(0xFFFF0000),
                          //             fontWeight: FontWeight.bold),
                          //       )),
                          // ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12, top: 0),
                        child: Row(
                          children: [
                            svgAssets(
                              AssetsSvg.IC_GAME_GOLD,
                              width: 28,
                              height: 28,
                            ),
                            SizedBox(
                              width: Dimens.pt10,
                            ),
                            Text(
                              Config.gameBalanceEntity == null ||
                                      Config.gameBalanceEntity.wlTransferable ==
                                          null
                                  ? "0"
                                  : Config.gameBalanceEntity.wlTransferable
                                      ?.toString(),
                              style: TextStyle(
                                  fontSize: Dimens.pt32, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          GestureDetector(
                            onTap: () {
                              //账单
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return GameBillDetailPage();
                              }));
                            },
                            child: Container(
                                margin: EdgeInsets.only(right: 12, bottom: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "我的账单 >",
                                  style: TextStyle(
                                    fontSize: Dimens.pt12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (context) {
                      //         return RecentlyPlayPage(
                      //           list: saveGameListHistory,
                      //           buildContext: context,
                      //         );
                      //       },
                      //     )).then((value) {});
                      //   },
                      //   child: Container(
                      //       margin: EdgeInsets.only(left: 12, bottom: 10),
                      //       alignment: Alignment.centerLeft,
                      //       child: Text(
                      //         "最近玩過 >",
                      //         style: TextStyle(
                      //             fontSize: Dimens.pt12,
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.bold),
                      //       )),
                      // ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      JRouter().go(PAGE_PROMOTE_HOME);
                    },
                    child: Align(
                      alignment: Alignment.bottomRight,
                      // child: Image.asset(
                      //   "assets/images/quan_min_dai_li.png",
                      //   width: Dimens.pt76,
                      //   height: Dimens.pt60,
                      // ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 70,
              margin: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: operateItem("充值", AssetsSvg.IC_GAME_GOLD, () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return GameWalletPage().buildPage(null);
                      })).then((value) async {
                        await getBalance();

                        setState(() {});
                      });
                    }, false),
                  ),
                  Expanded(
                    child: operateItem("提现", AssetsSvg.IC_GAME_WALLET, () {
                      JRouter().go(PAGE_WITHDRAW_GAME).then((value) async {
                        await getBalance();

                        setState(() {});
                      });
                    }, false),
                  ),
                  Expanded(
                    child: operateItem("全民代理", AssetsSvg.IC_GAME_AGENT, () {
                    }, false),
                  ),
                  Expanded(
                    child: operateItem("活动", AssetsImages.IC_GAME_RULES, () {
                      JRouter().jumpPage(GAME_RULES);
                    }, true),
                  ),

                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) {
                  //       return GameWalletPage().buildPage(null);
                  //     })).then((value) async {
                  //       await getBalance();
                  //
                  //       setState(() {});
                  //     });
                  //   },
                  //   child: Container(
                  //     height: 60,
                  //     width: 160,
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //       color: Colors.orange,
                  //       borderRadius: BorderRadius.all(Radius.circular(10)),
                  //       image: DecorationImage(
                  //           fit: BoxFit.cover,
                  //           image: AssetImage("assets/images/game_charge.png")),
                  //     ),
                  //   ),
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) {
                  //       return GameWalletPage().buildPage(null);
                  //     })).then((value) async {
                  //       await getBalance();
                  //       setState(() {});
                  //     });
                  //   },
                  //   child: Container(
                  //     height: 60,
                  //     width: 160,
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //       color: Colors.pinkAccent,
                  //       borderRadius: BorderRadius.all(Radius.circular(10)),
                  //       image: DecorationImage(
                  //           fit: BoxFit.cover,
                  //           image: AssetImage("assets/images/game_tixian.png")),
                  //     ),
                  //   ),
                  // ),
                  /*GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return NewLoginPage().buildPage(null);
                          }));
                    },
                    child: Container(
                      height: 50,
                      width: 105,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        "注册",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            (saveGameListHistory?.length ?? 0) > 0
                ? Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 16, bottom: 10),
                    child: Text(
                      "最近玩过",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Container(),
            (saveGameListHistory?.length ?? 0) > 0
                ? Container(
                    height: 110,
                    margin: EdgeInsets.only(left: 16, right: 16),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: historyGameList(),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 16,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 16, bottom: 10),
              child: Text(
                "全部游戏",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 0,
                    childAspectRatio: 160 / 124),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      loadingWidget.show(context);

                      saveGameList.clear();
                      saveGameList = SpUtil.getStringList(SaveGameList,
                          defValue: List<String>());
                      Bean bean = list[index];
                      bool isExisted = false;
                      if (saveGameList.length > 0) {
                        for (int i = 0; i < saveGameList.length; i++) {
                          if (saveGameList[i] == bean.name) {
                            isExisted = true;
                          }
                        }
                      }

                      if (!isExisted) {
                        saveGameList.add(bean.name);
                      }

                      SpUtil.putStringList(SaveGameList, saveGameList);

                      if (saveGameList.length > 0) {
                        saveGameListHistory.clear();
                        for (int i = 0; i < saveGameList.length; i++) {
                          for (int j = 0; j < list.length; j++) {
                            if (saveGameList[i] == list[j].name) {
                              saveGameListHistory.add(list[j]);
                            }
                          }
                        }
                      }

                      await getBalance();
                      if (gameBalanceEntity.wlTransferable +
                              gameBalanceEntity.wlBalance ==
                          0) {
                        showToast(msg: "游戏钱包余额不足，请先从App钱包划转至游戏钱包才能正常游戏呦～");
                      }

                      await getGameUrl(list[index].index.toString());
                      loadingWidget.cancel();

                      Config.isGameSurface = true;
                      WidgetsBinding.instance
                          .addPostFrameCallback(_onFrameCallBack);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return GameSurfacePage(gameBean.gameUrl);
                      })).then((value) {
                        Config.isGameSurface = false;
                        WidgetsBinding.instance
                            .addPostFrameCallback(_onFrameCallBackHide);
                        AutoOrientation.portraitAutoMode();
                        SystemChrome.setEnabledSystemUIOverlays(
                            SystemUiOverlay.values);

                        setState(() {});
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 6),
                      child: Column(
                        children: [
                          ClipRRect(
                            child: Stack(
                              children: [
                                Image.asset(
                                  list[index].url,
                                  height: 90,
                                  width: 158,
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              list[index].name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Bean {
  String name;
  String url;
  int index;
  Bean(this.name, this.url, this.index);
}
