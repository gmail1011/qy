import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/user/member_centre_page/page.dart';

class CoinRechargeAlert extends StatefulWidget {
  final String coinCount;

  const CoinRechargeAlert({Key key, this.coinCount}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CoinRechargeAlertState();
  }

  static show(BuildContext context, {String coinCount}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CoinRechargeAlert(
          coinCount: coinCount,
        );
      },
    );
  }
}

class _CoinRechargeAlertState extends State<CoinRechargeAlert> {
  String get descText {
    return "余额不足，前往充值";
  }

  String get titleText {
    return "新建合集";
  }

  @override
  Widget build(BuildContext context) {
    double scale = MediaQuery.of(context).size.width / 428;
    if (scale > 1) scale = 1;
    if (scale < 0.88) scale = 0.88;
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 352 * scale,
            // height: 176 * scale,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 235, 217, 1),
                  Color.fromRGBO(255, 255, 255, 1),
                ],
              ),
              // image: DecorationImage(
              //   image: AssetImage("assets/images/alert_bg.png"),
              // ),
            ),
            child: Column(
              children: [
                SizedBox(height: 14 * scale),
                Text(
                  titleText,
                  style: TextStyle(
                      fontSize: 20 * scale,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff171717),
                      height: 1.2),
                ),
                SizedBox(height: 12 * scale),
                Container(
                  color: Color(0xffe6e6e6),
                  height: 1,
                ),
                SizedBox(height: 20 * scale),
                _buildCoinCountText(scale),
                SizedBox(height: 18 * scale),
                _buildDescText(scale),
                SizedBox(height: 18 * scale),
                _buildSimpleButton(scale),
                SizedBox(height: 28 * scale),
              ],
            ),
          ),
          SizedBox(height: 24),
          _buildCloseButton(),
        ],
      ),
    );
  }

  Widget _buildCoinCountText(double scale) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/weibo/video_buy_icon.png",
            width: 27,
            height: 27,
          ),
          SizedBox(width: 2),
          Text(
            widget.coinCount,
            style: TextStyle(
              color: Color(0xff151515),
              fontSize: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescText(double scale) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        descText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Color(0xff666666),
        ),
      ),
    );
  }

  Widget _buildSimpleButton(double scale) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return MemberCentrePage().buildPage({"position": "1"});
          },
        ));
      },
      child: Container(
        width: 164 * scale,
        height: 42 * scale,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(42 * scale / 2),
          gradient: LinearGradient(
            colors: [
              Color(0xffde8f3e),
              Color(0xffee8636),
            ],
          ),
        ),
        child: Text(
          "充值金币",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16 * scale,
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Image.asset(
        "assets/images/alert_white_close.png",
        height: 36,
        width: 36,
      ),
    );
  }
}
