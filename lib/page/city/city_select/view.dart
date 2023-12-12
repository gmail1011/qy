import 'package:azlistview/azlistview.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/model/city_model.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    CitySelectState state, Dispatch dispatch, ViewService viewService) {
  var space = 0;
  var ps = screen.screenWidth / screen.screenHeight;
  if (ps >= 360.0 / 600.0) {
    if (state.recentCityList.length == 0) {
      space = Dimens.pt190.toInt();
    } else if (state.recentCityList.length > 0 &&
        state.recentCityList.length <= 3) {
      space = Dimens.pt230.toInt();
    } else if (state.recentCityList.length > 3) {
      space = Dimens.pt260.toInt();
    }
  } else {
    if (state.recentCityList.length == 0) {
      space = Dimens.pt180.toInt();
    } else if (state.recentCityList.length > 0 &&
        state.recentCityList.length <= 3) {
      space = Dimens.pt220.toInt();
    } else if (state.recentCityList.length > 3) {
      space = Dimens.pt260.toInt();
    }
  }

  return FullBg(
    child: Scaffold(
      appBar: getCommonAppBar(Lang.SWITCH_CITY),
      body: Container(
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    Dimens.pt13, Dimens.pt8, Dimens.pt17, Dimens.pt8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.pt14),
                    color: Color(0xff2e3138),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: Dimens.pt8,
                        right: Dimens.pt8,
                        top: Dimens.pt8,
                        bottom: Dimens.pt8),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.location_on,
                            color: Colors.red, size: Dimens.pt14),
                        Text(Lang.AUTO_LOCAL,
                            style: TextStyle(
                                color: Colors.white, fontSize: Dimens.pt12))
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () {
                dispatch(CitySelectActionCreator.onAutoLocation());
              },
            ),
            Expanded(
                flex: 1,
                child: AzListView(
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) return _buildHeader(state, dispatch);
                    var model = state.cityList[index];
                    return _buildListItem(model, state, dispatch);
                  },
                  susItemBuilder: (BuildContext context, int index) {
                    var model = state.cityList[index];
                    String tag = model.getSuspensionTag();

                    return _buildSusWidget(state, tag);
                  },
                  itemCount: state.cityList.length ?? 0,
                  data: state.cityList ?? [],
                  indexBarData:
                      SuspensionUtil.getTagIndexList(state.cityList ?? []),
                  indexBarOptions: IndexBarOptions(
                    needRebuild: true,
                    color: Colors.transparent,
                    downColor: Color(0xFFEEEEEE),
                  ),
                  susItemHeight: state.itemHeight,
                )),
          ],
        ),
      ),
    ),
  );
}

Widget _buildHeader(CitySelectState state, Dispatch dispatch) {
  return Padding(
      padding: EdgeInsets.fromLTRB(Dimens.pt13, Dimens.pt25, 0, 0),
      child: Column(
        children: <Widget>[
          ///历史访问
          state.recentCityList == null
              ? Container
              : state.recentCityList.isEmpty
                  ? Container()
                  : Row(
                      children: <Widget>[
                        svgAssets(AssetsSvg.ICON_HISTORY,
                            width: Dimens.pt11, height: Dimens.pt11),
                        Padding(
                          padding: EdgeInsets.only(left: Dimens.pt2),
                          child: Text(Lang.HISTORY,
                              style: TextStyle(
                                  color: Colors.white, fontSize: Dimens.pt12)),
                        )
                      ],
                    ),
          // 历史访问内容
          Container(
            padding: EdgeInsets.fromLTRB(0, Dimens.pt12, Dimens.pt22, 0),
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: Dimens.pt5,
              runSpacing: Dimens.pt3,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.center,
              direction: Axis.horizontal,
              textDirection: TextDirection.ltr,
              children: state.recentCityList.map((e) {
                return GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                    width: Dimens.pt104,
                    color: Color(0xff2e3138),
                    alignment: Alignment.center,
                    child: Text(
                      e.name,
                      style:
                          TextStyle(color: Colors.white, fontSize: Dimens.pt12),
                    ),
                  ),
                  onTap: () {
                    dispatch(CitySelectActionCreator.onClickHistory(
                        e.name + "_" + e.province));
                  },
                );
              }).toList(),
            ),
          ),

          Row(
            children: <Widget>[
              svgAssets(AssetsSvg.ICON_HOT_CITY,
                  width: Dimens.pt11, height: Dimens.pt13),
              Padding(
                padding: EdgeInsets.only(left: Dimens.pt2),
                child: Text(Lang.HOT_CITY,
                    style:
                        TextStyle(color: Colors.white, fontSize: Dimens.pt12)),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, Dimens.pt12, Dimens.pt15, 0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: Dimens.pt5,
                runSpacing: Dimens.pt3,
                children: state.hotCityList.map((e) {
                  return GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                      width: Dimens.pt104,
                      color: Color(0xff2e3138),
                      alignment: Alignment.center,
                      child: Text(
                        e.name,
                        style: TextStyle(
                            color: Colors.white, fontSize: Dimens.pt12),
                      ),
                    ),
                    onTap: () {
                      dispatch(CitySelectActionCreator.onClickCity(
                          e.name, e.province));
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ));
}

_buildSusWidget(CitySelectState state, String susTag) {
  if (susTag == null) {
    return Container();
  }
  susTag = (susTag == "★" ? Lang.HOT_CITY : susTag);
  return Container(
    height: 40.0,
    width: screen.screenWidth,
    padding: const EdgeInsets.only(left: 15.0),
    color: Colors.black,
    alignment: Alignment.centerLeft,
    child: Text(
      '$susTag',
      softWrap: false,
      style: TextStyle(
        fontSize: 14.0,
        color: Colors.white,
      ),
    ),
  );
}

_buildListItem(CityInfo model, CitySelectState state, Dispatch dispatch) {
  String susTag = model.getSuspensionTag();
  susTag = (susTag == "★" ? Lang.HOT_CITY : susTag);
  return Column(
    children: <Widget>[
      Offstage(
        offstage: !model.isShowSuspension,
        child: _buildSusWidget(state, susTag),
      ),
      SizedBox(
        height: 40.0,
        child: ListTile(
          title: Text(model.name, style: TextStyle(color: Colors.white)),
          onTap: () {
            dispatch(CitySelectActionCreator.onClickCity(
                model.name, model.province));
          },
        ),
      )
    ],
  );
}
