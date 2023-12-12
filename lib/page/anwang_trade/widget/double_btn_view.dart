import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

///单按钮布局（VIP升级弹窗、切换线路弹窗、交易提示弹窗）
class DoubleBtnDialogView extends StatelessWidget {
  final String title;
  final String content;
  final String leftBtnText;
  final String rightBtnText;
  final Function leftCallback;
  final Function rightCallback;

  const DoubleBtnDialogView(
      {Key key, this.title, this.content, this.leftBtnText,this.rightBtnText, this.leftCallback,this.rightCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:GestureDetector(
        child: Container(
          width: screen.screenWidth,
          height: screen.screenHeight,
          color: Colors.transparent,
          child: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 314,
                    height: 210,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                           Color(0xff161e2c),
                            Color(0xff161e2c),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                title,
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Color.fromRGBO(230, 230, 230, 0.6),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: Text(
                                content,
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 43,
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: [
                                    SizedBox(width: 30,),
                                    Expanded(child:  InkWell(
                                      onTap: () {
                                        safePopPage(false);
                                        leftCallback();
                                      },
                                      child: Container(
                                        height: 36,
                                        width: 123,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              Color.fromRGBO(132, 164, 249, 1),
                                              Color(0xffca452e),
                                            ]),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.5))),
                                        child: Center(
                                          child: Text(
                                            leftBtnText,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromRGBO(255, 255, 255, 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),),
                                    SizedBox(width: 20,),
                                    Expanded(child: InkWell(
                                      onTap: () {
                                        safePopPage(false);
                                        rightCallback();
                                      },
                                      child: Container(
                                        height: 36,
                                        width: 123,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              Color.fromRGBO(132, 164, 249, 1),
                                              Color(0xffca452e),
                                            ]),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.5))),
                                        child: Center(
                                          child: Text(
                                            rightBtnText,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromRGBO(255, 255, 255, 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),),
                                    SizedBox(width: 30,),
                                  ],
                                ))
                          ],
                        )
                      ],
                 )),
                GestureDetector(
                  child: Container(
                    height: 54,
                    width: 314,
                    color: Colors.transparent,
                    alignment: Alignment.bottomCenter,
                    child: Image.asset("assets/images/alert_white_close.png",width: 33,height: 33,),
                  ),
                  onTap: (){
                    safePopPage(false);
                  },
                )
              ],
            )

          ),
        ),
        onTap: (){
          safePopPage(false);
        },
      )

    );
  }
}
