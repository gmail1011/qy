import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/new_page/welfare/SpecialWelfareHomePage.dart';
import 'package:flutter_app/new_page/welfare/SpecialWelfareViewRecommend.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 系统公告--文字公告
class SystemWordDialog extends StatelessWidget {
  SystemWordDialog({Key key, this.content, this.addr}) : super(key: key);
  final String content;
  final String addr;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0),
      insetPadding: EdgeInsets.only(left: 40.0, right: 40, top: 24.0, bottom: 100.0),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 340.w,
        height: 440.w,
        padding: EdgeInsets.fromLTRB(0, 24, 0, 27),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              Color(0xffca452e),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Text(
              "系统公告",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black,
                    Colors.black.withOpacity(0),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: SingleChildScrollView(
                  child: EasyRichText(
                    content,
                    patternList: [
                      EasyRichTextPattern(
                        targetString: EasyRegexPattern.webPattern,
                        urlType: 'web',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                      EasyRichTextPattern(
                        targetString: 'seisea.live',
                        urlType: 'web',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                      EasyRichTextPattern(
                        targetString: 'https://ptcc.in/sis66',
                        urlType: 'web',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                      EasyRichTextPattern(
                        targetString: 'https://ptcc.in/pfqipai',
                        urlType: 'web',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                      EasyRichTextPattern(
                        targetString: 'https://ptcc.in/pfqipai',
                        urlType: 'web',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                safePopPage();
                // safePopPage(true);
                // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                //   return SpecialWelfareViewRecommendPage();
                // })).then((value) => safePopPage());
              },
              child: Container(
                width: 196,
                height: 38,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    gradient: LinearGradient(colors: [
                      Color(0xffca452e),
                      Color(0xffca452e),
                    ])),
                alignment: Alignment.center,
                child: Text(
                  "我知道了",
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
              // child: Image.asset(
              //   "assets/weibo/announce_confirm.png",
              //   fit: BoxFit.contain,
              //   height: 38.w,
              //   width: 252.w,
              // ),
            ),

            /*Positioned(
            bottom: -20.w,
            child: GestureDetector(
              onTap: () {
                safePopPage(false);
              },
              child: svgAssets(AssetsSvg.CLOSE_BTN,
                  width: Dimens.pt35, height: Dimens.pt35),
            ),
          ),*/
          ],
        ),
      ),

      /*child: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: Dimens.pt130),
                  Container(
                    width: screen.screenWidth,
                    // height: Dimens.pt300,
                    padding: EdgeInsets.only(
                        top: 16, left: 16, right: 16, bottom: 16),
                    // margin: EdgeInsets.fromLTRB(0, 0, 0, Dimens.pt60),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(20)),
                        gradient: LinearGradient(colors: [AppColors.textColorWhite,AppColors.textColorWhite])),
                    child: Column(
                      children: [
                        Container(
                          height: Dimens.pt200,
                          // color: Colors.white,
                          child: SingleChildScrollView(
                            */ /*child: Text(
                              content,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Dimens.pt14,
                                  fontWeight: FontWeight.bold,
                                  height: 1.4),
                            ),*/ /*

                            child: EasyRichText(
                              content,
                              patternList: [

                                EasyRichTextPattern(
                                  targetString: EasyRegexPattern.webPattern,
                                  urlType: 'web',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                  ),
                                ),

                                EasyRichTextPattern(
                                  targetString: 'seisea.live',
                                  urlType: 'web',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                  ),
                                ),

                                EasyRichTextPattern(
                                  targetString: 'https://ptcc.in/sis66',
                                  urlType: 'web',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                  ),
                                ),

                                EasyRichTextPattern(
                                  targetString: 'https://ptcc.in/pfqipai',
                                  urlType: 'web',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                  ),
                                ),

                                EasyRichTextPattern(
                                  targetString: 'https://ptcc.in/pfqipai',
                                  urlType: 'web',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        agentHLine(needPadding: false),
                        SizedBox(height: 12),
                        getLinearGradientBtn(Lang.SYSTEM_DIALOG_2,
                            width: Dimens.pt200,
                            height: Dimens.pt36,
                            enableColors: AppColors.red,
                            textColor: AppColors.itemBgWhite,
                            horizontal: false,
                            fontSize: 16,
                            onTap: () {
                          safePopPage(true);
                        }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Dimens.pt20),
                  ),
                  GestureDetector(
                    onTap: () {
                      safePopPage(false);
                    },
                    child: svgAssets(AssetsSvg.CLOSE_BTN,
                        width: Dimens.pt35, height: Dimens.pt35),
                  )
                ],
              ),
              ImageLoader.withP(
                      (addr != "" && addr != null)
                          ? ImageType.IMAGE_NETWORK_HTTP
                          : ImageType.IMAGE_ASSETS,
                      address: (addr != "" && addr != null)
                          ? addr
                          : "assets/weibo/system_announce.webp",
                      width: screen.screenWidth,
                      height: Dimens.pt166,
                      fit: BoxFit.contain)
                  .load(),
            ],
          )
        ],
      ),*/
    );
  }
}
