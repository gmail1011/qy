import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/navigator_util.dart';

import 'state.dart';

Widget buildView(
    UploadRuleState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: getCommonAppBar(Lang.UPLOAD_NOTICE),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.only(left: Dimens.pt16, right: Dimens.pt16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(color: Colors.white30),
              SizedBox(height: Dimens.pt11),
              Row(
                children: [
                  Container(
                    width: Dimens.pt2,
                    height: Dimens.pt16,
                    color: AppColors.primaryRaised,
                  ),
                  SizedBox(width: Dimens.pt4),
                  Text(Lang.UPLOAD_RULE_TITLE,
                      style: TextStyle(
                          fontSize: Dimens.pt18, color: Colors.white)),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: Dimens.pt11),
                child: Text(
                  Lang.UPLOAD_RULE,
                  style: TextStyle(
                      fontSize: Dimens.pt12,
                      color: Colors.white54,
                      wordSpacing: 1,
                      height: 1.5),
                ),
              ),
              SizedBox(height: Dimens.pt34),
              Row(
                children: [
                  Container(
                    width: Dimens.pt2,
                    height: Dimens.pt16,
                    color: AppColors.primaryRaised,
                  ),
                  SizedBox(width: Dimens.pt4),
                  Text(Lang.VIDEO_REVIEW_TITLE,
                      style: TextStyle(
                          fontSize: Dimens.pt18, color: Colors.white)),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: Dimens.pt11),
                child: Text(
                  Lang.VIDEO_REVIEW_RULE
                      .replaceAll('%s', state.packageInfo?.appName ?? ''),
                  style: TextStyle(
                      fontSize: Dimens.pt12,
                      color: Colors.white54,
                      wordSpacing: 1,
                      height: 1.5),
                ),
              ),
              SizedBox(height: Dimens.pt34),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getCommonBtn(Lang.NOT_AGREE_AND_QUIT, enable: false,
                      onTap: () async {
                    await lightKV.setBool(Config.VIEW_UPLOAD_RULE, false);
                    safePopPage(false);
                  }),
                ],
              ),
              SizedBox(height: Dimens.pt34),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getCommonBtn(Lang.READ_AND_AGREE, onTap: () async {
                    await lightKV.setBool(Config.VIEW_UPLOAD_RULE, true);
                    safePopPage(true);
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
