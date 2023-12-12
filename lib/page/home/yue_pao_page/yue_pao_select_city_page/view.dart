import 'package:azlistview/azlistview.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/model/city_model.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    YuePaoSelectCityState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: GestureDetector(
      onTap: () {
        FocusScope.of(viewService.context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(Lang.SWITCH_CITY, style: TextStyle(color: Colors.white)),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                safePopPage();
              }),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              /// 搜索
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimens.pt16),
                child: Container(
                  height: Dimens.pt32,
                  // padding: EdgeInsets.symmetric(horizontal: Dimens.pt12),
                  decoration: BoxDecoration(
                    color: Color(0xff27254C),
                    borderRadius: BorderRadius.circular(Dimens.pt18),
                    border: Border.all(
                      color: Color(0xff979797),
                    ),
                  ),
                  child: TextField(
                    controller: state.editingController,
                    cursorColor: AppColors.primaryRaised,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimens.pt12,
                        height: 1.3),
                    maxLines: 1,
                    textInputAction: TextInputAction.search,
                    onChanged: (text) {
                      dispatch(YuePaoSelectCityActionCreator.search());
                    },
                    onSubmitted: (text) {
                      dispatch(YuePaoSelectCityActionCreator.search());
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      hintText: "搜索位置",
                      hintMaxLines: 5,
                      border: InputBorder.none,
                      counterText: "",
                      counterStyle: TextStyle(color: Colors.red),
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: Dimens.pt12),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AppPaddings.appMargin,
              ),
              _buildHeader(state, dispatch),
              Expanded(
                child: Visibility(
                  visible: (state.searchList?.length ?? 0) > 0,
                  child: AzListView(
                    data: state.searchList ?? 0,
                    itemBuilder: (context, index) {
                      var model = state.searchList[index];
                      return _buildListItem(model, state, dispatch);
                    },
                    // padding: EdgeInsets.zero,
                    itemCount: state.searchList.length ?? 0,
                    indexBarData:
                        SuspensionUtil.getTagIndexList(state.cityList ?? []),
                    susItemBuilder: (context, index) {
                      var model = state.searchList[index];
                      return _buildSusWidget(
                        state,
                        model.getSuspensionTag(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildHeader(YuePaoSelectCityState state, Dispatch dispatch) {
  return Visibility(
    visible: (state.hotCityList?.length ?? 0) > 0,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
      child: Column(
        children: <Widget>[
          /// 热门城市
          Row(
            children: <Widget>[
              svgAssets(AssetsSvg.ICON_HOT_CITY,
                  width: Dimens.pt11, height: Dimens.pt13),
              Padding(
                padding: EdgeInsets.only(left: Dimens.pt2),
                child: Text(Lang.HOT_CITY,
                    style:
                        TextStyle(color: Colors.white, fontSize: Dimens.pt12)),
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: AppPaddings.appMargin, bottom: AppPaddings.appMargin),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                childAspectRatio: 4),
            itemCount: (state.hotCityList?.length ?? 0) > 9
                ? 9
                : (state.hotCityList?.length ?? 0),
            itemBuilder: (context, index) {
              var e = state.hotCityList[index];
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
                  dispatch(YuePaoSelectCityActionCreator.onClickItem(e.name));
                },
              );
            },
          ),
        ],
      ),
    ),
  );
}

_buildSusWidget(
  YuePaoSelectCityState state,
  String susTag,
) {
  susTag = (susTag == "★" ? Lang.HOT_CITY : susTag);
  return Container(
    height: 40.0,
    width: screen.screenWidth,
    padding: EdgeInsets.only(left: AppPaddings.appMargin),
    color: Colors.black,
    alignment: Alignment.centerLeft,
    child: Text(
      '$susTag',
      softWrap: false,
      style: TextStyle(
        fontSize: AppFontSize.fontSize16,
        color: Colors.white,
      ),
    ),
  );
}

_buildListItem(CityInfo model, YuePaoSelectCityState state, Dispatch dispatch) {
  String susTag = model.getSuspensionTag();
  susTag = (susTag == "★" ? Lang.HOT_CITY : susTag);
  return Column(
    children: <Widget>[
      Offstage(
        offstage: model.isShowSuspension != true,
        child: _buildSusWidget(state, susTag),
      ),
      InkWell(
        onTap: () {
          dispatch(YuePaoSelectCityActionCreator.onClickItem(model.name));
        },
        child: Container(
          height: 40.0,
          width: screen.screenWidth,
          padding: EdgeInsets.only(left: AppPaddings.appMargin),
          color: Colors.transparent,
          alignment: Alignment.centerLeft,
          child: Text(
            model.name ?? '',
            softWrap: false,
            style: TextStyle(
              fontSize: AppFontSize.fontSize16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ],
  );
}
