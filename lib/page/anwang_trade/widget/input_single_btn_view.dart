import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

///单按钮布局（VIP升级弹窗、切换线路弹窗、交易提示弹窗）
class InputSingleBtnDialogView extends StatelessWidget {
  final String title;
  final String btnText;
  final Function(String) callback;
  TextEditingController textControllerName = TextEditingController();

  InputSingleBtnDialogView(
      {Key key, this.title, this.btnText, this.callback})
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
          alignment: Alignment.center,
          child: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 314,
                    height: 197,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 235, 217, 1),
                              Color.fromRGBO(255, 255, 255, 1),
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
                                  color: Color.fromRGBO(23, 23, 23, 1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Color.fromRGBO(230, 230, 230, 1),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              height: 30,
                                width: 280,
                                child: TextField(
                                  controller: textControllerName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  // maxLength: 200,
                                  maxLines: 1,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    hintText: "列表名称",
                                    hintMaxLines: 1,
                                    border: InputBorder.none,
                                    counterText: "",
                                    counterStyle: TextStyle(color: Colors.black),
                                    hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: 18),
                                  ),
                                )
                            ),
                            Container(
                              width: 280,
                              height: 1,
                              color: Color.fromRGBO(0, 0, 0, 0.36),
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
                                          callback(textControllerName.text);
                                        },
                                        child: Container(
                                          height: 36,
                                          width: 198,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                Color.fromRGBO(254, 127, 15, 1),
                                                Color.fromRGBO(234, 139, 37, 1),
                                              ]),
                                              borderRadius: BorderRadius.all(Radius.circular(20.5))),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
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
