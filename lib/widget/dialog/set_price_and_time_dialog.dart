import 'package:cool_ui/cool_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/utils/navigator_util.dart';

//设置金币和时间view
class SetPriceAndTimeView extends StatefulWidget {
  final double currentCoin;

  final int currentDuration;

  final int totalDuration;

  SetPriceAndTimeView(this.currentCoin, this.currentDuration, this.totalDuration);

  @override
  State<StatefulWidget> createState() {
    return ConfigPriceAndCoinState();
  }
}

class ConfigPriceAndCoinState extends State<SetPriceAndTimeView> {
  double coinValue;
  double minCoinValue;
  double maxCoinValue;

  int currentDuration;
  int minDuration;
  int maxDuration;

  @override
  void initState() {
    super.initState();
    coinValue = widget.currentCoin;
    currentDuration = widget.currentDuration;
    minCoinValue = 0;
    maxCoinValue = 30.0;
    minDuration = 0;
    maxDuration = (widget.totalDuration ?? 0) == 0 ? 10 : widget.totalDuration;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: Dimens.pt12, bottom: Dimens.pt10),
                    child: Text(
                      Lang.SET_PRICE,
                      style: TextStyle(color: Color(0xff000000), fontSize: Dimens.pt14),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: Dimens.pt20),
                child: CupertinoPopoverButton(
                  barrierColor: Color.fromRGBO(255, 255, 255, 0),
                  popoverWidth: Dimens.pt280,
                  child: svgAssets(AssetsSvg.IC_VIDEO_BTN_RULE, width: Dimens.pt15, height: Dimens.pt14),
                  popoverColor: Color.fromRGBO(0, 0, 0, 112),
                  popoverBuild: (content) {
                    return Container(
                      color: Color.fromRGBO(0, 0, 0, 80),
                      child: Padding(
                        padding: EdgeInsets.all(Dimens.pt6),
                        child: Text(
                          Lang.VIDEO_RULE,
                          style: TextStyle(fontSize: Dimens.pt10, color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Container(
            width: Dimens.pt245,
            child: Padding(
              padding: EdgeInsets.only(left: (205 / maxCoinValue) * coinValue + 8, top: Dimens.pt10),
              child: Text(
                '${coinValue.toInt()}${Lang.GOLD_COIN}',
                style: TextStyle(fontSize: Dimens.pt10, color: Color(0xffC73D34)),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 0),
              child: Container(
                width: Dimens.pt220,
                child: SliderTheme(
                  //自定义风格
                  data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Color(0xffC85A49),
                      //进度条滑块����边颜色
                      inactiveTrackColor: Color(0xffECECEC),
                      //进度条滑块右边颜色0xffECECEC
                      // trackShape: RoundSliderTrackShape(radius: 10), //进度条形状,这边��定义两头显示圆角
                      thumbColor: Color(0xffC85A49),
                      //滑块颜色
                      overlayColor: Color(0xffC85A49),
                      //滑块拖拽时外圈的颜色
                      overlayShape: RoundSliderOverlayShape(
                        //可继承SliderComponentShape自定义形状
                        overlayRadius: 13, //滑块外圈大小
                      ),
                      thumbShape: RoundSliderThumbShape(
                        //可继承SliderComponentShape自定义形状
                        disabledThumbRadius: 12, //禁用是滑块大小
                        enabledThumbRadius: 12, //滑块大小
                      ),
                      inactiveTickMarkColor: Color(0xffC85A49),
                      tickMarkShape: RoundSliderTickMarkShape(
                        //继承SliderTickMarkShape可自定义��度形状
                        tickMarkRadius: 0, //刻度大小
                      ),
                      showValueIndicator: ShowValueIndicator.always,
                      //气泡显示的形式
                      valueIndicatorColor: Color(0xffC85A49),
                      //气泡颜色
                      valueIndicatorShape: SliderComponentShape.noThumb,
                      //气泡形状
                      valueIndicatorTextStyle: TextStyle(color: Colors.black),
                      //气泡里值的风格
                      trackHeight: 12 //进度条宽度

                      ),
                  child: Slider(
                    value: coinValue,
                    onChanged: (v) {
                      setState(() {
                        coinValue = v;
                      });
                    },
                    label: Lang.WORD_BUBBLE + ":$coinValue",
                    //气泡的值
                    divisions: maxCoinValue.toInt(),
                    //进度条上显示多少个刻度点
                    max: maxCoinValue,
                    min: minCoinValue,
                  ),
                ),
              )),
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: Dimens.pt20),
                    child: Text('$minCoinValue${Lang.GOLD_COIN}',
                        style: TextStyle(fontSize: Dimens.pt10, color: Color(0xffBDBDBD))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: Dimens.pt20),
                    child: Text(
                      '$maxCoinValue${Lang.GOLD_COIN}',
                      style: TextStyle(fontSize: Dimens.pt10, color: Color(0xffBDBDBD)),
                    ),
                  )
                ],
              ),
            ),
          ),
          Visibility(
              visible: false,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: Dimens.pt10),
                    child: Text(
                      Lang.SET_FREE_TIME,
                      style: TextStyle(fontSize: Dimens.pt14, color: Color(0xff000000)),
                    ),
                  ),
                  Container(
                    width: Dimens.pt245,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: (Dimens.pt12 + (205 / (maxDuration - 3) * currentDuration)), top: Dimens.pt0),
                      child: Text(
                        '$currentDuration${Lang.SECOND}',
                        style: TextStyle(fontSize: Dimens.pt10, color: Color(0xffC73D34)),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Container(
                        width: Dimens.pt220,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Color(0xffC85A49),
                              //进度条滑块左边颜色
                              inactiveTrackColor: Color(0xffECECEC),
                              //进度条滑块右边颜色0xffECECEC
                              // trackShape: RoundSliderTrackShape(radius: 10), //进度条形状,这边自定义两头显示圆角
                              thumbColor: Color(0xffC85A49),
                              //滑块颜色
                              overlayColor: Color(0xffC85A49),
                              //滑块拖拽时外圈的颜色
                              overlayShape: RoundSliderOverlayShape(
                                //可继承SliderComponentShape自定义形状
                                overlayRadius: 13, //滑块外圈大小
                              ),
                              thumbShape: RoundSliderThumbShape(
                                //可继承SliderComponentShape自定义形状
                                disabledThumbRadius: 12, //禁用是滑块大小
                                enabledThumbRadius: 12, //滑块大小
                              ),
                              inactiveTickMarkColor: Color(0xffC85A49),
                              tickMarkShape: RoundSliderTickMarkShape(
                                //继承SliderTickMarkShape可自定义刻度形状
                                tickMarkRadius: 0, //刻度大小
                              ),
                              showValueIndicator: ShowValueIndicator.always,
                              //气泡显示的形式
                              valueIndicatorColor: Color(0xffC85A49),
                              //气泡颜色
                              valueIndicatorShape: SliderComponentShape.noThumb,
                              //气泡形状
                              valueIndicatorTextStyle: TextStyle(color: Colors.black),
                              //气泡里值的风格
                              trackHeight: 12 //进度条宽度

                              ),
                          child: Slider(
                            value: currentDuration.toDouble(),
                            onChanged: (v) {
                              setState(() {
                                currentDuration = v.toInt();
                              });
                            },
                            label: Lang.WORD_BUBBLE + ":$currentDuration",
                            //气泡的值
                            divisions: maxDuration,
                            //进度条上显示多少个刻度点
                            max: maxDuration.toDouble(),
                            min: minDuration.toDouble(),
                          ),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: Dimens.pt24),
                            child: Text('$minDuration秒',
                                style: TextStyle(fontSize: Dimens.pt10, color: Color(0xffBDBDBD))),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: Dimens.pt24),
                            child: Text(
                              '$maxDuration${Lang.SECOND}',
                              style: TextStyle(fontSize: Dimens.pt10, color: Color(0xffBDBDBD)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          Padding(
            padding: EdgeInsets.only(top: Dimens.pt8),
            child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 0.2))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Center(
                    child: Text(
                      Lang.CANCEL,
                      style: TextStyle(color: Color(0xff000000), fontSize: Dimens.pt16),
                    ),
                  ),
                  onTap: () {
                    safePopPage();
                  },
                ),
              ),
              Container(
                height: Dimens.pt56,
                child: VerticalDivider(
                  color: Colors.black12,
                  width: 0.2,
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Center(
                    child: Text(
                      Lang.SURE,
                      style: coinValue >= 0
                          ? TextStyle(color: Colors.black, fontSize: Dimens.pt16)
                          : TextStyle(color: Colors.black38, fontSize: Dimens.pt16),
                    ),
                  ),
                  onTap: () {
                    if (coinValue >= 0) {
                      if (currentDuration < 3) {
                        currentDuration = 3;
                      }
                      safePopPage({'coin': coinValue.toInt(), 'second': currentDuration.toInt()});
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
