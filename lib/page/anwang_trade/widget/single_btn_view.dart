import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

///单按钮布局（VIP升级弹窗、切换线路弹窗、交易提示弹窗）
class SingleBtnDialogView extends StatelessWidget {
  final String title;
  final String content;
  final String btnText;
  final Function callback;

  const SingleBtnDialogView(
      {Key key, this.title, this.content, this.btnText, this.callback})
      : super(key: key);

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
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 303,
                    height: 186,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(22, 30, 44, 1),
                            Color.fromRGBO(22, 30, 44, 1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Stack(
                      children: [
                        Positioned(
                            right: 5,
                            top: 10,
                            child: InkWell(
                              onTap: () => safePopPage(false),
                              child: Image.asset(
                                "assets/images/aw_dialog_close.png",
                                width: 12,
                                height: 12,
                              ),
                            )),
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
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: Text(
                                content,
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                height: 36,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: InkWell(
                                        onTap: () {
                                          safePopPage(false);
                                          callback();
                                        },
                                        child: Container(
                                          height: 36,
                                          width: 198,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                Color.fromRGBO(132, 164, 249, 1),
                                                Color(0xffca452e),
                                              ]),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.5))),
                                          child: Center(
                                            child: Text(
                                              btnText,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color:Color.fromRGBO(255, 255, 255, 1),
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
      ),

    );
  }
}
