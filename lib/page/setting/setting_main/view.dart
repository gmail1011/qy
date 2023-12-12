import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/page/setting/you_hui_juan/YouHuiJuanPage.dart';
import 'package:flutter_app/widget/dialog/update_dialog.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/utils/cache_util.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'action.dart';
import 'edit_exchange_code_dialog.dart';
import 'edit_tui_guang_code_dialog.dart';
import 'state.dart';

part 'could_upgrade_dialog.dart';

part 'not_upgrade_dialog.dart';

Widget buildView(
    SettingState state, Dispatch dispatch, ViewService viewService) {

  dynamic tuiGuangCode = state.tuiGuangCode;

  return FullBg(
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(Lang.SETTING),
        //文字title居中
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              safePopPage();
            }),
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(height: 1.0, indent: 0.0, color: Color(0x805a4f59)),
                Divider(
                    height: Dimens.pt6, indent: 0.0, color: Colors.transparent),

                _subItemView(
                  context: viewService.context,
                  title: Lang.ACCOUNT_AND_SAFE,
                  imagePath: AssetsSvg.SETTING_IC_ACCOUNT_SAFE,
                  onTap: () {
                    JRouter().go(PAGE_ACCOUNT_SAFE);
                  },
                ),
                _subItemView(
                  context: viewService.context,
                  title: Lang.WALLET,
                  imagePath: AssetsSvg.SETTING_IC_WALLET,
                  onTap: () {
                  },
                ),
                _subItemView(
                  context: viewService.context,
                  title: Lang.MY_FAVORITE,
                  imagePath: AssetsSvg.SETTING_IC_FAVORITE,
                  onTap: () {
                    JRouter().go(PAGE_MY_FAVORITE);
                  },
                ),
                _subItemView(
                  context: viewService.context,
                  title: Lang.FEEDBACK,
                  imagePath: AssetsSvg.IC_FEEDBACK,
                  onTap: () {
                    JRouter().go(PAGE_FEEDBACK);
                  },
                ),
                _subItemView(
                  context: viewService.context,
                  imagePath: AssetsSvg.SETTING_IC_CLEAR_CACHE,
                  title: Lang.CLEAN_CACHE,
                  subTitle: state.cacheSize ?? "",
                  onTap: () async {
                    await clearCacheIfNeed(force: true);
                    String _size = await loadCache();
                    state.cacheSize = _size;
                    dispatch(SettingActionCreator.clearCacheSuccess());
                    showToast(msg: Lang.CLEAN_CACHE_SUCCESS);
                  },
                ),

                _subItemView(
                  context: viewService.context,
                  imagePath: AssetsSvg.SETTING_IC_UPGRADE,
                  title: Lang.VERSION_UPGRADE,
                  subTitle: "${Lang.VERSION_NAME} v${Config.innerVersion}",
                  onTap: () async {
                    dispatch(SettingActionCreator.onGetVersion());
                  },
                ),



                ///优惠券
                Container(
                  margin: EdgeInsets.only(left: Dimens.pt2),
                  child: _subItemView(
                    context: viewService.context,
                    imagePath: "assets/svg/youhuijuan.svg",
                    title: "優惠券",
                    onTap: () async {
                      Navigator.of(viewService.context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) => YouHuiJuanPage()));
                    },
                  ),
                ),



                ///兌換碼
                _subItemView(
                  context: viewService.context,
                  imagePath: AssetsSvg.DUI_HUAN_MA,
                  title: Lang.REDEMPTION_CODE,
                  onTap: () async {
                    String code = await showEditConvertDialog(
                        state, dispatch, viewService);
                    if (code != null) {
                      dispatch(SettingActionCreator.exChangeCode(code));
                    }
                  },
                ),


                ///推广码
                Container(
                  margin: EdgeInsets.only(left: Dimens.pt2),
                  child: _subItemView(
                    context: viewService.context,
                    imagePath: "assets/svg/tui_guang_ma.svg",
                    title: Lang.TUI_GUANG_MA,
                    subTitle: tuiGuangCode == null || tuiGuangCode.toString() == "0" ? "" : tuiGuangCode.toString(),
                    onTap: () async {
                      if(tuiGuangCode.toString() == "0"){
                        String code = await showEditTuiGuangCodeDialog(
                            state, dispatch, viewService);
                        if (code != null) {
                          dispatch(SettingActionCreator.tuiGuangCode(code));
                        }
                      }else{
                        showToast(msg: "您已綁定了推廣碼,不能重復綁定");
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _subItemView({
  @required BuildContext context,
  String title = '',
  String subTitle = '',
  String imagePath = '',
  VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    svgAssets(imagePath, color: Colors.white),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimens.pt14,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: Dimens.pt10),
                      child: Text(
                        subTitle,
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: Dimens.pt12,
                        ),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,
                        color: Color(0xff999999), size: 20),
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
