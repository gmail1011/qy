import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/game_page/bean/GameBean.dart';
import 'package:flutter_app/page/game_page/bean/game_balance_entity.dart';
import 'package:flutter_app/page/game_surface/GameSurface.dart';
import 'package:flutter_app/page/game_surface/overlay/overlay_tool_wrapper.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/LoadingWidget.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_svg/svg.dart';

import '../game_page_view.dart';

class RecentlyPlayPage extends StatefulWidget{

  List<Bean> list = [];
  BuildContext buildContext;

  /// Simple db test page.
  RecentlyPlayPage({Key key, this.list,this.buildContext}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RecentlyPlayPageState();
  }

}

class _RecentlyPlayPageState extends State<RecentlyPlayPage>{

  LoadingWidget loadingWidget;

  GameBalanceEntity gameBalanceEntity;

  GameBean gameBean;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadingWidget = new LoadingWidget(title: "正在加载...",);
  }

  /// 获取余额
  Future getBalance() async {
    var resp = await netManager.client.getBalance();
    gameBalanceEntity = GameBalanceEntity().fromJson(resp);
  }

  Future getGameUrl(String gameId) async{
    var resp = await netManager.client.getGameUrl(gameId);
    gameBean = GameBean.fromJson(resp);
    print("DFEF");
  }

  double getMaxHeight(){
    if(widget.list.length <= 12){
      return (124 * 6).toDouble();
    }else if(widget.list.length == 13 || widget.list.length == 14){
      return (124 * 7).toDouble();
    }else if(widget.list.length > 14){
      return (124 * 8).toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      //backgroundColor: Color.fromRGBO(21, 26, 81, 1),
      backgroundColor: Colors.white,
      /*appBar: CustomAppbar(
          title: "最近玩過",
        ),*/
      appBar: AppBar(
        //leading: SvgPicture.asset("assets/svg/back_black.svg",height: Dimens.pt10,width: Dimens.pt10,),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("最近玩過",style: TextStyle(color: Colors.black,fontSize: Dimens.pt20,fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: getMaxHeight(),
          ),
          child: Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            //color: Color.fromRGBO(21, 26, 81, 1),
            color: Colors.white,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 0,
                  childAspectRatio: 160 / 124),
              itemCount: widget.list.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: ()  async {

                    loadingWidget.show(context);

                    await getBalance();
                    if(gameBalanceEntity.wlTransferable + gameBalanceEntity.wlBalance  == 0){
                      showToast(msg: "游戏钱包余额不足，请先从App钱包划转至游戏钱包才能正常游戏呦～");
                    }

                    await getGameUrl(widget.list[index].index.toString());
                    loadingWidget.cancel();

                    Config.isGameSurface = true;
                    bus.emit(EventBusUtils.showFloating,true);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return GameSurfacePage(gameBean.gameUrl);
                        })).then((value) {
                      Config.isGameSurface = false;
                      bus.emit(EventBusUtils.closeFloating,true);
                      AutoOrientation.portraitAutoMode();
                      SystemChrome.setEnabledSystemUIOverlays(
                          SystemUiOverlay.values);

                      setState(() {

                      });
                    });

                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 6),
                    child: Column(
                      children: [
                        ClipRRect(
                          child: Stack(
                            children: [
                              Image.asset(widget.list[index].url),
                            ],
                          ),
                          borderRadius:
                          BorderRadius.all(Radius.circular(6)),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            widget.list[index].name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color.fromRGBO(0, 0, 0, 1)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

}