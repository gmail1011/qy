import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

///分享二维码对话框
class ShareVideoView extends StatefulWidget {
  final UserInfoModel userData;
  final VideoModel videoModel;
  final String topicName;
  final bool isLongVideo;
  final bool isFvVideo;
  final String titleDesc;
  final String contentDesc;

  ShareVideoView({
    this.userData,
    this.videoModel,
    this.topicName,
    this.isLongVideo = false,
    this.isFvVideo = false,
    this.titleDesc,
    this.contentDesc,
  });

  @override
  State<ShareVideoView> createState() => _ShareVideoDialog();
}

class _ShareVideoDialog extends State<ShareVideoView> with TickerProviderStateMixin {
  List<bool> checkedList = [];

  double videoWidth = 0;
  double videoHeight = 0;
  double sharePanelHeight;
  double coverHeight;
  double qrCodeHeight;

  @override
  void initState() {
    super.initState();
    sharePanelHeight = screen.screenHeight / 4 * 3;
    coverHeight = (sharePanelHeight - Dimens.pt40) / 2;
    qrCodeHeight = (sharePanelHeight - Dimens.pt40) / 5;
  }

  /// 复制链接
  void _onCopyLink() {
    Clipboard.setData(ClipboardData(text: widget.userData.promoteURL));
    showToast(msg: Lang.SHARE_TIP);

    /// 关闭界面
    safePopPage();
    //if (null != context) showGoWXDialog(context, title: Lang.SHARE_TIP);
  }

  /// 保存图片
  void _onSaveImg() async {
    //保存图片分享
    //执行缩小动画
    ///保存图片
    await _capturePngAndSaveToGallery();
    setState(() {});
    safePopPage();
    /*if (null != context)
      showGoWXDialog(context,
          title: Lang.SAVE_PHOTO_ALBUM, subTitle: Lang.SAVE_PHOTO_DETAILS);*/
  }

  GlobalKey<_ShareVideoDialog> globalKey = GlobalKey();

  /// 将组件转化为图片数据
  Future<void> _capturePngAndSaveToGallery() async {
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    await savePngDataToAblumn(byteData.buffer.asUint8List());
  }

  ///获取发布者名称
  String _getPublisherName() {
    if (widget.titleDesc?.isNotEmpty == true) {
      return widget.titleDesc;
    }
    if (widget.topicName != null) {
      return "#${widget.topicName}";
    }

    ///是否影视
    if (widget.isFvVideo ?? false) {
      return "";
    }
    if ((widget.videoModel?.publisher?.name ?? "").isNotEmpty) {
      return "@${widget.videoModel?.publisher?.name}";
    }
    return "@${widget.userData.name}";
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: Container(
        width: 1.sw,
        margin: EdgeInsets.only(left: 44, right: 44),
        padding: EdgeInsets.fromLTRB(16, 24, 16, 27),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xff2e2e2e),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeaderUI(),
            Container(
              height: 150,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomNetworkImage(
                    imageUrl: widget.videoModel?.cover,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: Image.asset(
                      "assets/images/share_player.png",
                      width: 25,
                      height: 28,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 12),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      padding: EdgeInsets.all(2),
                      color: Colors.white,
                      child: QrImage(
                        data: widget.userData.promoteURL,
                        padding: EdgeInsets.all(2),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "@${widget.videoModel?.publisher?.name}", //_getPublisherName(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            widget.contentDesc ?? "${widget.videoModel.title}",
                            softWrap: true,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: "每邀请",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  TextSpan(
                    text: "1人",
                    style: TextStyle(color: AppColors.primaryTextColor, fontSize: 12),
                  ),
                  TextSpan(
                    text: "送",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  TextSpan(
                    text: "1天",
                    style: TextStyle(color: AppColors.primaryTextColor, fontSize: 12),
                  ),
                  TextSpan(
                    text: "畅享观影\n",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  TextSpan(
                    text: "被邀请充值最高",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  TextSpan(
                    text: "返利76%",
                    style: TextStyle(color: AppColors.primaryTextColor, fontSize: 12),
                  ),
                ])),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _onCopyLink();
                        },
                        child: Container(
                          width: 100,
                          height: 38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(19),
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: Text(
                            "复制链接",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _onSaveImg();
                        },
                        child: Container(
                          width: 100,
                          height: 38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(19),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xffca452e),
                                Color(0xffca452e),
                              ],
                            ),
                          ),
                          child: Text(
                            "保存图片",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeaderUI() {
  return Container(
    width: 262.w,
    alignment: Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: AssetImage(AssetsImages.ICON_APP_LOGO),
              width: Dimens.pt45,
              height: Dimens.pt45,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("91猎奇",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    )),
                SizedBox(height: 3),
                Text(
                  "最大认证换妻平台",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        //每邀请1人送3天会员
        // 被邀请充值最高返利76%
      ],
    ),
  );
}
