import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

///单按钮布局（VIP升级弹窗、切换线路弹窗、交易提示弹窗）
class VipDialogHjllView extends StatelessWidget {
  final String title;
  final String content;
  final String btnText;
  final Function callback;

  const VipDialogHjllView(
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
            child: Container(
                width: screen.screenWidth-60,
                height: (screen.screenWidth-60)*(357/334),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(22, 30, 44, 1),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  image: DecorationImage(
                    image: AssetImage("assets/weibo/dialog_need_vip_or_coin_bg.png"),
                    fit: BoxFit.fill,
                  )
                ),
                child: Column(
                  children: [
                    SizedBox(height: 160,),
                    Text("购买会员或者任务获得VIP解锁精彩完整版！",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize:14 ),),
                    SizedBox(height: 24,),
                    Text("VIP限时特惠 畅看全场",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize:14 ),),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Container(
                            width: 105,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(132, 164, 249, 1),
                                      AppColors.primaryTextColor,
                                    ]
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(4))
                            ),
                            child: Text("充值VIP",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 12),),
                          ),
                          onTap: (){
                              safePopPage("toMemberCenter");
                          },
                        ),
                        SizedBox(
                          width: 58,
                        ),
                        GestureDetector(
                          child: Container(
                            width: 105,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(132, 164, 249, 1),
                                      AppColors.primaryTextColor,
                                    ]
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(4))
                            ),
                            child: Text("做任务得VIP",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 12),),
                          ),
                          onTap: (){
                            safePopPage("toTaskPage");
                          },
                        ),
                      ],
                    )
                  ],
                ),
            ),
          ),
        ),
        onTap: (){
          safePopPage(false);
        },
      ),

    );
  }
}
