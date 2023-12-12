import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/setting/scan_qrcode/scan_camera_dialog.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:r_scan/r_scan.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    AccountSafeState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: AppBar(
        title: Text(Lang.ACCOUNT_AND_SAFE),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              dispatch(AccountSafeActionCreator.onBack());
            }),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(height: 1.0, indent: 0.0, color: Color(0x805a4f59)),
                InkWell(
                  onTap: () {
                    if (TextUtil.isNotEmpty(state.meInfo?.mobile)) {
                      JRouter().go(PAGE_REBIND_PHONE);
                    } else {
                      JRouter().go(PAGE_INITIAL_BIND_PHONE);
                    }
                  },
                  child:
                      _getItem(Lang.ACCOUNT_BIND_PHONE, state.meInfo?.mobile),
                ),
                InkWell(
                  onTap: () {
                    JRouter().go(PAGE_SWITCH_ACCOUNT);
                  },
                  child: _getItem(Lang.SWITCH_ACCOUNT, ''),
                ),
                InkWell(
                  onTap: () {
                    JRouter().go(PAGE_ACCOUNT_QR_CODE);
                  },
                  child: _getItem(Lang.ACCOUNT_COVERY, ''),
                ),
                InkWell(
                  onTap: () async {
                    WidgetsFlutterBinding.ensureInitialized();
                    rScanCameras = await availableRScanCameras();
                    RScanResult result = await Navigator.of(viewService.context)
                        .push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                RScanCameraDialog()));
                    if (result?.message != null) {
                      state.isShowLoading = true;
                      dispatch(AccountSafeActionCreator.refreshUI());
                      dispatch(
                          AccountSafeActionCreator.qrLogin(result.message));
                    }
                  },
                  child: _getItem(Lang.SCAN_LOGIN, ''),
                ),
              ],
            ),
            Center(
              child: state.isShowLoading ? LoadingWidget() : Container(),
            )
          ],
        ),
      ),
    ),
  );
}

Widget _getItem(String itemTitle, String itemValue) {
  return Container(
    padding: _getItemMargin(),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          itemTitle ?? '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: Dimens.pt2),
              child: Text(
                itemValue ?? '',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0x80ffffff),
                  fontSize: Dimens.pt12,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Color(0xff999999), size: 15),
          ],
        ),
      ],
    ),
  );
}

EdgeInsets _getItemMargin() {
  return EdgeInsets.fromLTRB(
    Dimens.pt16,
    Dimens.pt16,
    Dimens.pt18,
    Dimens.pt18,
  );
}
