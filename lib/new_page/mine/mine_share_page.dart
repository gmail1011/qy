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
import 'package:flutter_app/new_page/mine/mine_share_record_page.dart';
import 'package:flutter_app/new_page/recharge/withdraw_page.dart';
import 'package:flutter_app/new_page/recharge/withdraw_record_page.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/dialog/wx_dialog.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/route_manager.dart' as Gets;

class MineSharePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MineSharePageState();
  }
}

class _MineSharePageState extends State<MineSharePage> with AutomaticKeepAliveClientMixin {
  UserInfoModel meInfo;
  WalletModelEntity wallet;
  ScrollController _controller = ScrollController();
  String _selfId;
  GlobalKey boundaryKey = new GlobalKey();

  int total = 0;

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
      appBar: CustomAppbar(
        title: "分享推广",
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return MineShareRecordPage();
              }));
            },
            child: Text(
              "邀请记录",
              style: const TextStyle(
                  color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: 12.0),
            ),
          )
        ],
      ),
      body: Container(
          color: AppColors.primaryColor,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            controller: _controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RepaintBoundary(
                  key: boundaryKey,
                  child: _codeView(),
                ),
                SizedBox(height: 28),
                Container(
                  alignment: Alignment.center,
                  height: 40,
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
                      SizedBox(width: 16),
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
                SizedBox(height: 28),
                Container(
                  width: screen.screenWidth,
                  child: Image.asset(
                    "assets/images/hjll__share_img.png",
                    height: 492,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 28),
              ],
            ),
          )),
    ),);
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
                        color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
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
      height: 372,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/hjll__share_bg.png",
            height: 372,
            width: screen.screenWidth,
            fit: BoxFit.fill,
          ),
          Container(
            padding: EdgeInsets.only(top: 124),
            child: Column(
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "累计邀请",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                      ),
                    ),
                    TextSpan(
                      style: const TextStyle(
                        color:  AppColors.primaryTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                      ),
                      text: "$total人",
                    )
                  ]),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryTextColor, width: 0.5),
                  ),
                  child: QrImage(
                    backgroundColor: Colors.white,
                    data: meInfo?.promoteURL,
                    version: QrVersions.auto,
                    size: 140,
                  ),
                ),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          text: "我的推广码\t\t"),
                      TextSpan(
                          style:  TextStyle(
                            color:  AppColors.primaryTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                          text: meInfo.promotionCode ?? ""),
                    ],
                  ),
                ),
              ],
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
