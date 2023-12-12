import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/utils/log.dart';
import '../../../common/net2/net_manager.dart';
import '../../../model/city_detail_model.dart';

class WantWidgetPage extends StatefulWidget {
  final CityDetailModel cityDetailModel;

  WantWidgetPage(this.cityDetailModel);

  @override
  State<StatefulWidget> createState() {
    return WantGoState();
  }
}

class WantGoState extends State<WantWidgetPage> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: Dimens.pt0,
        child: RaisedButton(
          color: Color(0xff2c2f36),
          child: Row(
            children: <Widget>[
              svgAssets(widget.cityDetailModel?.isHaveCollect ?? false
                  ? AssetsSvg.COLLECTIONED
                  : AssetsSvg.NO_COLLECTION),
              Padding(
                padding: EdgeInsets.only(left: Dimens.pt5),
              ),
              Text(Lang.WANT_GO, style: TextStyle(color: Colors.white))
            ],
          ),
          onPressed: () {
            //改变状态
            if (!this.mounted) return;
            _onCityIsWant();
          },
        ));
  }

  void _onCityIsWant() async {
    if (widget.cityDetailModel == null) return;
    setState(() {
      widget.cityDetailModel.isHaveCollect =
          !widget.cityDetailModel.isHaveCollect;
    });
    // Map<String, dynamic> mapList = Map();
    // mapList['objID'] = widget.cityDetailModel.id;
    // mapList['type'] = "location";
    // mapList['isCollect'] = widget.cityDetailModel.isHaveCollect;
    String objID = widget.cityDetailModel.id;
    String type = 'location';
    bool isCollect = widget.cityDetailModel.isHaveCollect;
    try {
      await netManager.client.isWantGoCity(objID, type, isCollect);
    } catch (e) {
      l.d('isWantGoCity=', e.toString());
      //showToast(msg: e.toString());
      setState(() {
        if (widget.cityDetailModel == null ||
            widget.cityDetailModel.isHaveCollect == null) {
          return;
        }
        widget.cityDetailModel.isHaveCollect =
            !widget.cityDetailModel.isHaveCollect;
      });
    }
    // BaseResponse res = await isWantGoCity(mapList);
    // if (res.code == 200) {
    // } else {
    //   showToast(msg: res.msg);
    //   setState(() {
    //     if (widget.cityDetailModel == null ||
    //         widget.cityDetailModel.isHaveCollect == null) {
    //       return;
    //     }
    //     widget.cityDetailModel.isHaveCollect =
    //         !widget.cityDetailModel.isHaveCollect;
    //   });
    // }
  }
}
