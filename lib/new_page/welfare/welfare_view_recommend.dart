import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/new_page/mine/mine_share_page.dart';
import 'package:flutter_app/new_page/mine/mine_share_record_page.dart';
import 'package:flutter_app/new_page/recharge/withdraw_page.dart';
import 'package:flutter_app/new_page/recharge/withdraw_record_page.dart';
import 'package:flutter_app/new_page/welfare/share_home_page.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/dialog/wx_dialog.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/route_manager.dart' as Gets;

class WelfareViewRecommend extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WelfareViewRecommendState();
  }
}

class _WelfareViewRecommendState extends State<WelfareViewRecommend> with AutomaticKeepAliveClientMixin {
  UserInfoModel meInfo;
  WalletModelEntity wallet;
  ScrollController _controller = ScrollController();
  String _selfId;
  GlobalKey boundaryKey = new GlobalKey();

  int total = 0;

  int sumday = 0;

  @override
  bool get wantKeepAlive => true;

  get page => null;

  @override
  void initState() {
    super.initState();
    meInfo = GlobalStore.getMe();
    wallet = GlobalStore.getWallet();
    _loadData();
  }

  void _loadData() async {
    try {

      var record = await netManager.client.getProxyBindRecord(1, 1);
      total = record.total;

      sumday = record.sumday;

      setState(() {});
    } catch (e) {
      l.e('getIncomeList', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FullBg(
        child: Scaffold(
          body: Stack(
            children: [
              _saveView(),
              Container(
                  color: AppColors.primaryColor,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    controller: _controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        SizedBox(height: 10),


                        Stack(

                          alignment: AlignmentDirectional.center,

                          children: [

                            Container(
                              width: 343,
                              height: 125,
                              color: Color.fromRGBO(255, 255, 255, 0.1),
                            ),


                            Positioned(
                                top: 12,
                                left: 0,
                                child: Image.asset("assets/images/blue_dot.png",width: 8,height: 22,)),


                            Positioned(
                                top: 14,
                                left: 18,
                                child: Text("收益总额",style: TextStyle(color: Colors.white,fontSize: 14),)),


                            Positioned(
                                top: 45,
                                left: 20,
                                child: Text(GlobalStore.getWallet().income.toString() ?? "0",style: TextStyle(color: Colors.white,fontSize: 32),)),



                            Positioned(
                                top: 90,
                                left: 20,
                                child: Text(GlobalStore.getWallet().income == null ? 0 : "可提现余额${GlobalStore.getWallet().income ~/ 10}元",style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 12),)),



                            Positioned(
                                top: 84,
                                right: 12,
                                child: GestureDetector(
                                  onTap: (){

                                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                      return WithdrawPage();
                                    }));

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: AppColors.linearBackGround,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),

                                    padding: EdgeInsets.only(left: 14,right: 14,top: 5,bottom: 5),
                                    child: Text("立即提现",style: TextStyle(color: Colors.black,fontSize: 12),),
                                  ),
                                )),



                          ],

                        ),


                        SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [

                            GestureDetector(
                              onTap: (){


                                Gets.Get.to(WithdrawRecordPage(),opaque: false);

                              },
                              child: Column(children: [

                                Image.asset('assets/images/zhangdanmingxi.png',width: 50,height: 50,),

                                SizedBox(height: 8),

                                Text(
                                  "账单明细",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w400, fontSize: 14.0),
                                ),

                              ],),
                            ),






                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                  return MineShareRecordPage();
                                }));
                              },
                              child: Column(children: [

                                Image.asset('assets/images/yaoqingjilu.png',width: 50,height: 50,),

                                SizedBox(height: 8),

                                Text(
                                  "邀请记录",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w400, fontSize: 14.0),
                                ),

                              ],),
                            ),







                            GestureDetector(
                              onTap: (){

                                Gets.Get.to(() => MineSharePage(), opaque: false);

                              },
                              child: Column(children: [

                                Image.asset('assets/images/fenxiangtuiguang.png',width: 50,height: 50,),

                                SizedBox(height: 8),

                                Text(
                                  "分享推广",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w400, fontSize: 14.0),
                                ),

                              ],),
                            ),


                          ],
                        ),


                        SizedBox(height: 16),

                        Text(
                          "分享领VIP",
                          style: const TextStyle(
                              color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: 14.0),
                        ),

                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            Container(
                              height: 60,
                              width: 156,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage("assets/images/grey_bg.png"),),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text(
                                    "推广人数",
                                    style: const TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.6), fontSize: 14.0),
                                  ),


                                  SizedBox(height: 3),

                                  Text(
                                    total.toString(),
                                    style: const TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1), fontSize: 14.0),
                                  ),


                                ],
                              ),
                            ),


                            SizedBox(width : 7),


                            Container(
                              height: 60,
                              width: 156,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage("assets/images/grey_bg.png"),),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text(
                                    "累计天数",
                                    style: const TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.6), fontSize: 14.0),
                                  ),


                                  SizedBox(height: 3),


                                  Text(
                                      sumday == null ? "0" : sumday.toString(),
                                    style: const TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1), fontSize: 14.0),
                                  ),


                                ],
                              ),
                            ),


                          ],
                        ),

                        SizedBox(height: 20),

                        Image.asset("assets/images/share_promote_word.png"),

                        SizedBox(height: 20),
                        _codeView(),

                        Container(
                          width: screen.screenWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /*Text(
                            "邀请步骤",
                            style: const TextStyle(
                                color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: 16.0),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "VIP限时特惠 畅看全场",
                            style: const TextStyle(
                                color: const Color(0xffffffff), fontWeight: FontWeight.w900, fontSize: 14.0),
                          ),*/
                              SizedBox(height: 15),
                              Image.asset(
                                "assets/images/hjll__share_img.png",
                                height: 445,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }

  Widget _buildBtn(String btnTxt, Function callClick) {
    return Expanded(
      child: InkWell(
        onTap: callClick,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: 35,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              gradient: AppColors.linearBackGround),
          child: Center(
            child: // 复制推广链接
            Text(btnTxt,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12.0),
                textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }

  Widget _saveView() {
    return Scaffold(
      body: RepaintBoundary(
        key: boundaryKey,
        child: Container(
          width: screen.screenWidth,
          padding: EdgeInsets.symmetric(horizontal: 16),
          margin: EdgeInsets.only(top: screen.paddingTop + kToolbarHeight),
          color: AppColors.primaryColor,
          child: _codeView(),
        ),
      ),
    );
  }

  Widget _codeView() {
    return Container(
      height: 520,
      child: Stack(
        children: [
          Image.asset(
            "assets/images/hjll__share_bg.png",
            height: 510,
            width: screen.screenWidth,
            fit: BoxFit.fill,
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 120,
                margin: EdgeInsets.only(left: 33),
                child: Row(
                  children: [

                    Image.asset("assets/images/ic_launcher.png",width: 60,height: 60,),


                    SizedBox(width: 8,),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("妻友社区",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontFamily: "FZZongYi-M05S",
                                fontSize: 22.0)),
                        SizedBox(height: 8),
                        Text("最大原创乱伦平台",
                            style: const TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14.0)),
                      ],
                    ),
                  ],
                ),
              )),
          Positioned(
              top: 120,
              child: Container(
                width: screen.screenWidth - 32,
                height: 270,
                child: Center(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0),
                              text: "累计邀请"),
                          TextSpan(
                              style: const TextStyle(
                                  color: const Color(0xff61d3be),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0),
                              text: "$total人")
                        ]),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryTextColor, width: 0.5),
                        ),
                        child: QrImage(
                          backgroundColor: Colors.white,
                          data: meInfo?.promoteURL,
                          version: QrVersions.auto,
                          size: 155,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                style: const TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0),
                                text: "我的推广码\t\t"),
                          ],
                        ),
                      ),


                      SizedBox(height: 10,),


                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                style: const TextStyle(
                                    color: const Color(0xff61d3be),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 30.0),
                                text: meInfo.promotionCode ?? ""),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),

          Positioned(
            bottom: 40,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 30,),
              width: screen.screenWidth - 80,
              height: 42,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBtn(
                    "保存图片",
                        () {
                      ///保存图片分享
                      eagleClick(selfId(), sourceId: selfId(), label: "保存分享图片");
                      _saveImage();
                      AnalyticsEvent.clickToSharePromotionInSaveImageEvent();
                    },
                  ),
                  _buildBtn(
                    "复制链接",
                        () {
                      ///复制分享链接到剪切板
                      eagleClick(selfId(), sourceId: selfId(), label: "保存分享链接");
                      Clipboard.setData(ClipboardData(text: meInfo?.promoteURL));
                      showToast(msg: Lang.SHARE_TIP);
                      AnalyticsEvent.clickToSharePromotionInCopyLink();
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///保存图片
  void _saveImage() async {
    Future.delayed(Duration(milliseconds: 20), () async {
      RenderRepaintBoundary boundary = boundaryKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      bool suc = await savePngDataToAblumn(byteData.buffer.asUint8List());
      if (suc) showGoWXDialog(context, title: Lang.SAVE_PHOTO_ALBUM, subTitle: Lang.SAVE_PHOTO_DETAILS);
    });
  }

  /// 自己的id uniqueId
  String selfId() {
    if (null == _selfId) {
      _selfId = this.runtimeType.toString();
    }
    return _selfId;
  }
}
