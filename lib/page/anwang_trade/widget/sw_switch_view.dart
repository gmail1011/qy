import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_base/flutter_base.dart';

///深网切换弹窗
class SWSwitchDialogView extends StatelessWidget {
  final Function cancelCallback;
  final Function callback;

  const SWSwitchDialogView({Key key, this.callback,this.cancelCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:GestureDetector(
          child:Container(
            width: screen.screenWidth,
            height: screen.screenHeight,
            color: Colors.transparent,
            child: Center(
              child: Container(
                  width: 303,
                  height: 235,
                  decoration: BoxDecoration(
                    color: Color(0xff222222),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                              width: 303,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.primaryTextColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8)),
                              ),
                              child: Center(
                                child: Text(
                                  "WARNING",
                                  style: TextStyle(
                                    color: Color(0xffffffff),
                                    fontSize: 24,
                                  ),
                                ),
                              )),
                          Container(
                            height: 1,
                            color: Color(0xff2e2e2e),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "该板块内容极度危险,心理承受弱者请自行离开,切记挑战自己好奇害死猫,请您确认还要继续吗?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  letterSpacing: 1.2,
                                  height: 1.4),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              height: 58,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: InkWell(
                                      onTap: () {
                                        safePopPage(false);
                                        cancelCallback();
                                      },
                                      child: Container(
                                        height: 41,
                                        decoration: BoxDecoration(
                                            color: Color(0xff3d3d3d),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.5))),
                                        child: Center(
                                          child: Text(
                                            "离开",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: InkWell(
                                      onTap: () {
                                        safePopPage(false);
                                        callback();
                                      },
                                      child: Container(
                                        height: 41,
                                        decoration: BoxDecoration(
                                            color: AppColors.primaryTextColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.5))),
                                        child: Center(
                                          child: Text(
                                            "确认",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      )
                    ],
                  )),
            ),
          ),
          onTap: (){
            safePopPage(false);
            cancelCallback();
          },
      )

    );
  }
}
