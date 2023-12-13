import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MineAccountProfilePage extends StatefulWidget {
  bool isNeedAutoSaveCer;

  MineAccountProfilePage({this.isNeedAutoSaveCer = false});

  @override
  State<StatefulWidget> createState() {
    return _MineAccountProfilePageState();
  }
}

class _MineAccountProfilePageState extends State<MineAccountProfilePage> {
  UserInfoModel meInfo;
  WalletModelEntity wallet;
  ScrollController _controller = ScrollController();
  String _selfId;
  GlobalKey boundaryKey = new GlobalKey();

  String qrCodeStr;

  @override
  void initState() {
    super.initState();
    meInfo = GlobalStore.getMe();
    wallet = GlobalStore.getWallet();
    _initData();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (widget.isNeedAutoSaveCer) {
        _saveImage();
      }
    });
  }

  ///获取二维码数据
  void _initData() async {
    Future.delayed(Duration(milliseconds: 200), () async {
      try {
        var orCodeModel = await netManager.client.getQrCodeInfo();
        setState(() {
          qrCodeStr = orCodeModel.content;
        });
      } catch (e) {
        l.d('getQrCodeInfo===', e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
        child: Scaffold(
      appBar: CustomAppbar(title: "账号凭证"),
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
                    SizedBox(height: 20),
                    _codeView(),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 15, bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildBtn(
                            "保存账号凭证",
                            () {
                              ///保存图片分享
                              eagleClick(selfId(), sourceId: selfId(), label: "保存分享图片");
                              _saveImage();
                              AnalyticsEvent.clickToSharePromotionInSaveImageEvent();
                            },
                          ),
                        ],
                      ),
                    ),
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
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [
                AppColors.primaryTextColor,
                AppColors.primaryTextColor,
              ],
            ),
          ),
          child: Text(
            btnTxt,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _saveView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      margin: EdgeInsets.only(top: screen.paddingTop + kToolbarHeight),
      child: RepaintBoundary(
        key: boundaryKey,
        child: _codeView(),
      ),
    );
  }

  Widget _codeView() {
    return AspectRatio(
      aspectRatio: 343 / 571,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/hj_account_profile_bg.png"),
            fit: BoxFit.fill,
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 176,
              height: 176,
              margin: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/code_bg.png")),
              ),
              child: (qrCodeStr == null || qrCodeStr == "")
                  ? SizedBox()
                  : QrImage(
                backgroundColor: Colors.white,
                data: qrCodeStr,
                version: QrVersions.auto,
                size: 155,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "账号凭证",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "海角社区ID:",
                  style: TextStyle(color: Color(0xffacacac), fontSize: 14),
                ),
                Text(
                  "${GlobalStore.getMe().uid}",
                  style: TextStyle(color: AppColors.primaryTextColor, fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              "我的-账号凭证",
              style: TextStyle(color: Color(0xffacacac), fontSize: 14),
            ),
            SizedBox(height: 6),
            Text(
              "永久官网地址 ${Address.landUrl}",
              style: TextStyle(color: Color(0xffacacac), fontSize: 14),
            ),
            SizedBox(height: 32),
            // RichText(
            //   text: TextSpan(
            //     children: [
            //       TextSpan(
            //           style: const TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: 16.0),
            //           text: "我的推广码\t\t"),
            //       TextSpan(
            //           style: const TextStyle(color: const AppColors.primaryTextColor, fontWeight: FontWeight.w900, fontSize: 24.0),
            //           text: meInfo.promotionCode ?? ""),
            //     ],
            //   ),
            // ),
          ],
        ),
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
      if (suc) showToast(msg: "保存成功");
      if (widget.isNeedAutoSaveCer) {
        safePopPage(suc);
      }
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
