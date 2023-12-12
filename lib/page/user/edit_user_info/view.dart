import 'dart:io';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/page/user/edit_user_info/action.dart';
import 'package:flutter_app/page/user/edit_user_info/edit_nick/page.dart';
import 'package:flutter_app/page/user/edit_user_info/edit_summary/page.dart';
import 'package:flutter_app/page/user/edit_user_info/state.dart';
import 'package:flutter_app/page/user/other/service_rule.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_app/widget/dialog/vip_level_dialog.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:get/route_manager.dart' as Gets;

import 'SwitchAvatarPage.dart';

part 'set_gendar_dialog.dart';

Widget buildView(
    EditUserInfoState state, Dispatch dispatch, ViewService viewService) {
  /// 获取头像
  Widget getPortrait() {
    if (state.tempPhoto?.length != 0) {
      return Image.file(
        File(state.tempPhoto),
        width: Dimens.pt112,
        height: Dimens.pt112,
        fit: BoxFit.cover,
      );
    } else {
      return CustomNetworkImage(
          imageUrl: state.tempPhoto.length != 0
              ? state.tempPhoto
              : (state.meInfo?.portrait ?? ''),
          type: ImgType.avatar,
          width: Dimens.pt112,
          height: Dimens.pt112,
          fit: BoxFit.cover);
    }
  }

  EdgeInsets _getItemMargin() {
    return EdgeInsets.fromLTRB(
      Dimens.pt18,
      Dimens.pt10,
      Dimens.pt18,
      Dimens.pt11,
    );
  }

  Widget _getArrowIcon() {
    return Icon(Icons.arrow_forward_ios, color: Color(0xffe3e3e3), size: 15);
  }

  ///设置subTitle UI
  Widget _getSubTitileUI(String title) {
    return Container(
      margin: EdgeInsets.only(left: Dimens.pt19, bottom: Dimens.pt3),
      alignment: Alignment.centerLeft,
      child: Text(title,
          style: TextStyle(fontSize: Dimens.pt17, color: Colors.white)),
    );
  }

  Widget _getItemLine(String title, String value, {bool showArrow = true}) {
    return Container(
      padding: _getItemMargin(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Color(0x80ffffff),
              fontSize: Dimens.pt14,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: CustomEdgeInsets.only(right: 8, left: 20),
                child: Text(
                  ((value?.length ?? 0) > 15)
                      ? value.substring(0, 15) + '...'
                      : value,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimens.pt14,
                  ),
                ),
              ),
              Visibility(
                child: _getArrowIcon(),
                visible: showArrow,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 修改地区
  void editCity() async {
    final res = await JRouter().go(PAGE_CITY_SELECT);
    String cityAndProvince = res as String;
    if (cityAndProvince == null) {
      return;
    }
    List<String> str = cityAndProvince.split("_");
    var newCity = str[0].replaceAll("市", "");

    if (newCity == state.meInfo?.region || newCity == null) return;
    dispatch(EditUserInfoActionCreator.onEditCity(newCity));
  }

  ///编辑性别
  void editGender() async {
    String gender = await showEditGenderDialog(
        state, dispatch, viewService, state.meInfo?.gender);
    if (gender == null) {
    } else {
      dispatch(EditUserInfoActionCreator.onEditGender(gender));
    }
  }

  return FullBg(
    child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(Lang.EDIT_USER_INFO),
        leading: IconButton(
            icon: Icon(Icons.arrow_back), onPressed: () => safePopPage()),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              const SizedBox(height: 24),
              //头像
              GestureDetector(
                onTap: () async {
                  var result = await Gets.Get.to(() => SwitchAvatarPage(),
                      opaque: false);
                  l.e("修改头像返回结果", "$result");
                  dispatch(EditUserInfoActionCreator.onRefresh());
                },
                child: Column(
                  children: <Widget>[
                    //设置头像
                    ClipOval(child: getPortrait()),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Text(
                        Lang.UPDATE_HEAD,
                        style: TextStyle(
                            color: Color(0xff6f93b4),
                            fontSize: Dimens.pt12,
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                  height: Dimens.pt28, indent: 0.0, color: Colors.transparent),

              ///基础信息
              _getSubTitileUI("基础信息"),

              InkWell(
                child: _getItemLine(
                    Lang.NICK_NAME,
                    (GlobalStore.getMe()?.name?.isNotEmpty ?? false)
                        ? GlobalStore.getMe()?.name
                        : Lang.NOT_SET),
                onTap: () async {
                  if (!GlobalStore.isRechargeVIP()) {
                    showVipLevelDialog(
                        viewService.context, Lang.VIP_LEVEL_DIALOG_MSG4);
                    return;
                  }
                  var result = await Gets.Get.to(EditNickNamePage().buildPage({}),
                      opaque: false);
                  l.e("result:", "$result");
                  dispatch(EditUserInfoActionCreator.onRefresh());
                },
              ),
              InkWell(
                onTap: () {},
                child: _getItemLine(
                    Lang.ACCOUNT_ID, "${state.meInfo?.uid ?? "未知"}"),
              ),
              InkWell(
                onTap: () async {
                  if (!GlobalStore.isRechargeVIP()) {
                    showVipLevelDialog(
                        viewService.context, Lang.VIP_LEVEL_DIALOG_MSG5);
                    return;
                  }
                  var result = await Gets.Get.to(EditSummaryPage().buildPage({}));
                  l.e("result:", "$result");
                  dispatch(EditUserInfoActionCreator.onRefresh());
                },
                child: _getItemLine(
                    Lang.INTRODUCTION,
                    (state.meInfo?.summary?.isNotEmpty ?? false)
                        ? state.meInfo?.summary
                        : Lang.NOT_SET),
              ),
              InkWell(
                onTap: () => editGender(),
                child: _getItemLine(
                    Lang.SEX,
                    state.meInfo?.gender == 'male'
                        ? Lang.MALE
                        : state.meInfo?.gender == 'female'
                            ? Lang.FEMALE
                            : ""),
              ),

              InkWell(
                onTap: () => editCity(),
                child: _getItemLine(
                    Lang.AREA,
                    (state.meInfo?.region?.isNotEmpty ?? false)
                        ? state.meInfo?.region
                        : Lang.NOT_SET),
              ),

              SizedBox(height: 24),

              ///账号
              _getSubTitileUI("账号"),
              InkWell(
                onTap: () async {
                  await JRouter().go(PAGE_INITIAL_BIND_PHONE, arguments: {
                    "bindMobileTitle":
                        (state.meInfo?.mobile?.isNotEmpty ?? false)
                            ? "更换手机号"
                            : "绑定手机号",
                    "bindMobileType":
                        (state.meInfo?.mobile?.isNotEmpty ?? false) ? 1 : 0,
                  });
                  dispatch(EditUserInfoActionCreator.onRefresh());
                },
                child: _getItemLine(
                    "手机号",
                    (state.meInfo?.mobile?.isNotEmpty ?? false)
                        ? state.meInfo?.mobile
                        : ""),
              ),

              InkWell(
                onTap: () async {
                  await JRouter().go(PAGE_ACCOUNT_QR_CODE);
                  dispatch(EditUserInfoActionCreator.onRefresh());
                },
                child: _getItemLine("账号凭证", ""),
              ),
              InkWell(
                onTap: () async {
                  await JRouter().go(RECOVER_ACCOUNT);
                  dispatch(EditUserInfoActionCreator.onRefresh());
                },
                child: _getItemLine("找回账号", ""),
              ),

              SizedBox(height: 24),

              _getSubTitileUI("其他"),
              InkWell(
                onTap: () {
                  commonNotifyDialog(viewService.context, "确认匹配客服？",
                      onTapCallback: () {
                    csManager.openServices(viewService.context);
                  });
                },
                child: _getItemLine(Lang.CONTACT_CUSTOM_SERVICE, ""),
              ),

              InkWell(
                onTap: () => Gets.Get.to(
                    () => ServiceRule(title: "隐私政策", serviceType: 0),
                    opaque: false),
                child: _getItemLine("隐私政策", ""),
              ),
              InkWell(
                onTap: () => Gets.Get.to(
                    () => ServiceRule(title: "服务条款", serviceType: 1),
                    opaque: false),
                child: _getItemLine("服务条款", ""),
              ),
              InkWell(
                onTap: () => JRouter().go(ABOUT_APP),
                child: _getItemLine("关于APP", ""),
              ),
              InkWell(
                onTap: () =>
                    dispatch(EditUserInfoActionCreator.onClearCacheData()),
                child: _getItemLine("清除缓存", state.cacheSize ?? "",
                    showArrow: false),
              ),
              SizedBox(height: 24),
            ],
          )
        ],
      ),
    ),
  );
}
