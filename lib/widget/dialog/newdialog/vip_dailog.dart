//File:vip弹窗
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

class VipDialog extends StatelessWidget {
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 0),
              borderRadius: BorderRadius.circular(17),
            ),
            alignment: Alignment.topCenter,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: EdgeInsets.only(top: Dimens.pt43),
                  child: ImageLoader.withP(ImageType.IMAGE_ASSETS,
                          address: AssetsImages.BG_VIP_TOP,
                          width: screen.screenWidth,
                          height: Dimens.pt260,
                          fit: BoxFit.contain)
                      .load(),
                ),
                ImageLoader.withP(ImageType.IMAGE_ASSETS,
                        address: AssetsImages.ICON_VIP_TOP,
                        width: Dimens.pt100,
                        height: Dimens.pt85,
                        fit: BoxFit.cover)
                    .load(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: Dimens.pt120),
                    Container(
                      width: screen.screenWidth,
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, Dimens.pt4),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("需要会员权限才可以看哦～",
                              style: TextStyle(
                                  fontSize: Dimens.pt14,
                                  color: Color(0xff425453))),
                          SizedBox(height: Dimens.pt16),
                          Text(
                            "开通会员，无限观看",
                            style: TextStyle(
                                fontSize: Dimens.pt14, color: Colors.black),
                          ),
                          SizedBox(height: Dimens.pt26),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              commonSubmitButton(Lang.BUY_VIP,
                                  width: Dimens.pt250,
                                  height: Dimens.pt38,
                                  radius: Dimens.pt6, onTap: () {
                                safePopPage("toMemberCenter");
                              }),
                              getCommonShareButton(
                                Lang.SHARE_PROMOTE,
                                () {
                                  safePopPage("toPersonalCard");
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              safePopPage("cancel");
            },
            child: Image(
                image: AssetImage(AssetsImages.ICON_PAY_FOR_CANCEL),
                width: Dimens.pt34,
                height: Dimens.pt34),
          ),
        ],
      ),
    );
  }
}
