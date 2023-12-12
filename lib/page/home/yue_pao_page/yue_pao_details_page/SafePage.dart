import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';

class SafePage extends  StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SafePageState();
  }

}

class _SafePageState extends State<SafePage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FullBg(
      child: Scaffold(
        appBar: CustomAppbar(
          hideBackBtn: false,
          child: Text("防骗指南",style: TextStyle(fontSize: Dimens.pt18,color: Colors.white,fontWeight: FontWeight.w600),),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: Dimens.pt16,right: Dimens.pt16,top: Dimens.pt16,bottom: Dimens.pt30),
            //child: Image.asset("assets/images/safedetail.png"),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                SizedBox(height: Dimens.pt24,),
                // Image.asset("assets/images/fangpianzhinan.png",width: Dimens.pt200,height: Dimens.pt60,),

                Padding(
                  padding:  EdgeInsets.only(left: Dimens.pt16,right: Dimens.pt16,top: Dimens.pt20,),
                  child: Text(Config.lfCheatGuide ?? "",
                    style: TextStyle(fontSize: Dimens.pt15,color: Colors.black,fontWeight: FontWeight.bold),),
                ),

                SizedBox(height: Dimens.pt10,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Image.asset("assets/images/fangpianzhinanbottom.png",width: Dimens.pt200,height: Dimens.pt200,),
                  ],
                ),

                SizedBox(height: Dimens.pt20,),
              ],
            ),
          ),
        ),
      ),
    );
  }

}