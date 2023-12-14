import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/screen.dart';

///原创入住
class MineOriginalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MineOriginalPageState();
  }
}

class _MineOriginalPageState extends State<MineOriginalPage> {
  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        appBar: CustomAppbar(title: "官方招募"),
        body: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 28, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle("招募令"),
          SizedBox(height: 6),
          Container(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              "原创博主火热招募中",
              style: TextStyle(
                color: Color(0xff999999),
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.only(left: 8),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "认证博主发布"),
                  TextSpan(
                    text: "视频帖子",
                    style: TextStyle(
                      color: Color(0xffef8649),
                    ),
                  ),
                  TextSpan(text: "即可获得"),
                  TextSpan(
                    text: "70%收益分成。",
                    style: TextStyle(
                      color: Color(0xffef8649),
                    ),
                  ),
                  TextSpan(text: '\n持续获得收益 躺着也能赚钱'),

                ],
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 28),
          _buildTitle("添加官方管理"),
          SizedBox(height: 12),
          Container(
            margin: EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: Color(0xff242424),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildItemCell(0, "Telegram", "assets/images/icon_mine_tg.png"),
                _buildItemCell(1, "Potato", "assets/images/icon_mine_potato.png"),
              ],
            ),
          ),
          SizedBox(height: 28),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              "入驻说明",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              "1、平台不会通过个人任何入驻费用\n"
              "2、请与官方群管理或APP客服确认真实性\n"
              "3、更多问题请添加官方管理员咨询",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                height: 2.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title, {Color color}) {
    return SizedBox(
      height: 22,
      child: Row(
        children: [
          Container(
            height: 22,
            width: 8,
            decoration: BoxDecoration(
              color: color ?? AppColors.primaryTextColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCell(int index, String title, String imagePath) {
    return Container(
      height: 76,
      padding: EdgeInsets.fromLTRB(12, 18, 12, 18),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 40,
            height: 40,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  "立即加群，神秘福利等你领！",
                  style: TextStyle(
                    color: Color(0xff666666),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          InkWell(
            onTap: (){
              if(index == 0){
                launchUrl(Config.groupTelegram);
              }else {
                launchUrl(Config.groupTomato);
              }
            },
            child: Container(
              width: 72,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryTextColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                "立即加入",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
