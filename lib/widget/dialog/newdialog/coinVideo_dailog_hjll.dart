import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/new_page/recharge/recharge_gold_page.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

class CoinVideoDialogHjllView extends StatelessWidget {
  final String title;
  final String content;
  final String btnText;
  final Function callback;
  final VideoModel viewModel;

  const CoinVideoDialogHjllView(
      {Key key,
      this.title,
      this.content,
      this.btnText,
      this.callback,
      this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        child: Container(
          width: screen.screenWidth,
          height: screen.screenHeight,
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Container(
            width: screen.screenWidth - 60,
            height: (screen.screenWidth - 60) * (357 / 334),
            decoration: BoxDecoration(
                color: Color.fromRGBO(22, 30, 44, 1),
                borderRadius: BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(
                  image: AssetImage(
                    "assets/weibo/dialog_need_vip_or_coin_bg.png",
                  ),
                  fit: BoxFit.fill,
                )),
            child: Column(
              children: [
                SizedBox(
                  height: 160,
                ),
                Text(
                  "金币购买本视频结束精彩完整版！",
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1), fontSize: 14),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "${viewModel?.videoCoin()}金币",
                  style: TextStyle(
                      color: AppColors.primaryTextColor, fontSize: 14),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "可用金币 ${GlobalStore.getWallet().amount}金币",
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1), fontSize: 14),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 105,
                        height: 35,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            gradient: AppColors.linearBackGround,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Text(
                          (viewModel.videoCoin() >
                                  GlobalStore.getWallet().amount)
                              ? "前往充值"
                              : "立即购买",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                      onTap: () {
                        (viewModel.videoCoin() > GlobalStore.getWallet().amount)
                            ? Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                                return RechargeGoldPage();
                              }))
                            : safePopPage("buyNow");
                      },
                    ),
                    SizedBox(
                      width: 46,
                    ),
                    GestureDetector(
                      child: Container(
                        width: 105,
                        height: 35,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            gradient: AppColors.linearBackGround,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Text(
                          "做任务得VIP",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                      onTap: () {
                        safePopPage("toTaskPage");
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        onTap: () {
          safePopPage(false);
        },
      ),
    );
  }
}
