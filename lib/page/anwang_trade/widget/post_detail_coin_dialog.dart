import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

///单按钮布局（VIP升级弹窗、切换线路弹窗、交易提示弹窗）
class PostDetailCoinDialog extends StatelessWidget {
  final Function leftCallback;
  final int videoCoin;
  const PostDetailCoinDialog(
      {Key key,  this.leftCallback,this.videoCoin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:GestureDetector(
        child: Container(
          width: screen.screenWidth,
          height: screen.screenHeight,
          color: Color.fromRGBO(14, 20, 30, 0.6),
          child: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(100, 255, 239, 1),
                              Color.fromRGBO(0, 214, 190, 1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(19)),
                      ),
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //Image.asset("assets/weibo/post_detail_coin.png",width: 30,height: 30,),
                          Text("$videoCoin金币解锁继续",
                              style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 14,
                              )
                          )
                        ],
                      )),
                  onTap: (){
                    leftCallback?.call();
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
