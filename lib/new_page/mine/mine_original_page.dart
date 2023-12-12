import 'package:flutter/material.dart';
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
        appBar: CustomAppbar(title: "原创入驻"),
        body: Stack(
          children: [
            Image.asset(
              "assets/images/hj_go_in_to_bg.png",
              height: 643,
              fit: BoxFit.fill,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(top: 160,left: 40,right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          launchUrl(Config.groupTomato);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/icon_mine_potato.png", width: 40, height: 40),
                            SizedBox(height: 10),
                            Text(
                              "官方土豆群",
                              style: const TextStyle(
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          launchUrl(Config.groupTelegram);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/icon_mine_tg.png", width: 40, height: 40),
                            SizedBox(height: 10),
                            Text(
                              "官方飞机群",
                              style: const TextStyle(
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
