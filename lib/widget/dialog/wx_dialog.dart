import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_base/utils/brower_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/text_util.dart';

///分享成功后 跳转微信
Future<String> showGoWXDialog(BuildContext context,
    {String title = "", String subTitle = ""}) {
  return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
              padding: EdgeInsets.all(16),
              width: Dimens.pt292,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Visibility(
                            visible: TextUtil.isNotEmpty(title),
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 25, right: 25),
                              child: Text(
                                title ?? "",
                                style: TextStyle(
                                    fontSize: Dimens.pt16,
                                    color: AppColors.mainTextColor33),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 16,
                            child: GestureDetector(
                              onTap: () {
                                safePopPage();
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      Visibility(
                        visible: TextUtil.isNotEmpty(subTitle),
                        child: Container(
                          margin: EdgeInsets.only(left: 25, right: 25, top: 20),
                          child: Text(
                            subTitle ?? "",
                            style: TextStyle(
                                fontSize: Dimens.pt16, color: Colors.black),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 25, right: 25, top: 20, bottom: 20),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onTap: () {
                                openWxFromBrowser();
                              },
                              child: Container(
                                height: Dimens.pt40,
                                width: Dimens.pt200,
                                alignment: Alignment.center,
                                color: AppColors.primaryRaised,
                                padding: const EdgeInsets.only(
                                    left: 4, right: 10, top: 4, bottom: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ImageLoader.withP(ImageType.IMAGE_SVG,
                                            address: AssetsSvg.SHARE_WX,
                                            width: 30,
                                            height: 30)
                                        .load(),
                                    Text(
                                      Lang.KEEP_SHARING,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimens.pt16),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
                  )
                ],
              )),
        );
      });
}
