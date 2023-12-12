import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/page/setting/setting_main/view.dart';
import 'package:flutter_app/page/user/edit_user_info/SwitchAvatarPage.dart';
import 'package:flutter_app/utils/cache_util.dart';
import 'package:flutter_app/utils/version_util.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/dialog/vip_level_dialog.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:get/route_manager.dart' as Gets;

import 'account_safe_page.dart';
import 'mine_update_nickname_page.dart';

///设置
class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  // 缓存大小
  String cacheSize;
  String tempPhoto = '';
  UserInfoModel meInfo;

  @override
  void initState() {
    super.initState();
    _loadCache();
    _loadUserInfo();
  }

  void _loadUserInfo() {
    meInfo = GlobalStore.getMe();
    if (mounted) {
      setState(() {});
    }
  }

  void _loadCache() async {
    cacheSize = await loadCache();
    if (mounted) {
      setState(() {});
    }
  }

  void _onGetVersion() async {
    var versionMap = await checkUpdate();
    if (versionMap != null) {
      if (!(versionMap['isNeedUpdate'] ?? false)) {
        showNotUpgradeDialog(context);
      } else {
        showUpgradeDialog(context, versionMap['newVersion'] ?? '', versionMap['versionBean']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.primaryColor,
        appBar: CustomAppbar(
          title: "编辑资料",
        ),
        body: Container(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 24),
                  //头像
                  GestureDetector(
                    onTap: () async {
                      await Gets.Get.to(() => SwitchAvatarPage(), opaque: false).then((value) => _loadUserInfo());
                    },
                    child: Column(
                      children: <Widget>[
                        //设置头像
                        ClipOval(child: getPortrait()),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Text(
                            "修改头像",
                            style: TextStyle(
                              color: Color(0xffbbbbbb),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _subItemView(
                    context: context,
                    title: "昵称",
                    subTitle: meInfo?.name ?? "",
                    onTap: () async {
                      if (!GlobalStore.isRechargeVIP()) {
                        showVipLevelDialog(context, Lang.VIP_LEVEL_DIALOG_MSG4);
                        return;
                      }
                      await Gets.Get.to(MineUpdateNamePage(), opaque: false).then((value) => _loadUserInfo());
                    },
                  ),
                  _subItemView(
                    context: context,
                    title: "账号安全",
                    subTitle: "",
                    onTap: () async {
                      Gets.Get.to(AccountSafePage(), opaque: false);
                    },
                  ),
                  _subItemView(
                    context: context,
                    title: "清除缓存",
                    subTitle: cacheSize ?? "",
                    onTap: () async {
                      await clearCacheIfNeed(force: true);
                      String _size = await loadCache();
                      setState(() {
                        cacheSize = _size;
                      });
                      showToast(msg: Lang.CLEAN_CACHE_SUCCESS);
                    },
                  ),
                  _subItemView(
                    context: context,
                    title: Lang.VERSION_UPGRADE,
                    subTitle: "${Lang.VERSION_NAME} v${Config.innerVersion}",
                    onTap: () => _onGetVersion(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 获取头像
  Widget getPortrait() {
    if (tempPhoto?.length != 0) {
      return Image.file(
        File(tempPhoto),
        width: 90,
        height: 90,
        fit: BoxFit.cover,
      );
    } else {
      return CustomNetworkImage(
          imageUrl: tempPhoto.length != 0 ? tempPhoto : (meInfo?.portrait ?? ''),
          type: ImgType.avatar,
          width: 90,
          height: 90,
          fit: BoxFit.cover);
    }
  }

  Widget _subItemView({
    @required BuildContext context,
    String title = '',
    String subTitle = '',
    VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          subTitle,
                          style: TextStyle(
                            color: Color(0xFFbbbbbb),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right, color: Color(0xFFbbbbbb), size: 20),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
