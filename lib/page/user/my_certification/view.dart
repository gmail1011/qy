import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';

import 'action.dart';
import 'state.dart';

///我的认证
Widget buildView(
    MyCertificationState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: getCommonAppBar("我的认证"),
      body: BaseRequestView(
        controller: state.requestController,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage(AssetsImages.BG_CERTTIFICATION),
                  width: screen.screenWidth,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 22, bottom: 20),
                  alignment: Alignment.center,
                  child: svgAssets(AssetsSvg.ICON_MY_CERTIFICATION_ICONS,
                      width: Dimens.pt130, height: Dimens.pt30),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _createCertificationItem(
                              AssetsImages.ICON_MY_CERTIFICATION_01, "大V标识"),
                          _createCertificationItem(
                              AssetsImages.ICON_MY_CERTIFICATION_02, "流量扶持"),
                          _createCertificationItem(
                              AssetsImages.ICON_MY_CERTIFICATION_03, "热播推荐"),
                          _createCertificationItem(
                              AssetsImages.ICON_MY_CERTIFICATION_04, "优先审核"),
                          _createCertificationItem(
                              AssetsImages.ICON_MY_CERTIFICATION_05, "快速提现"),
                        ],
                      ),
                      _buildPrivilegeDescriptionUI(),
                      SizedBox(height: Dimens.pt20),
                      Text(
                        "认证提示：",
                        style: TextStyle(
                            fontSize: Dimens.pt16,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: Dimens.pt5),
                      Text(
                        "1.大V认证需支付5000金币/年的认证服务费\n2.认证后需定期发布定期视频，否则将不显示大V图标，直至再次投稿\n3.平台不会主动私聊你进行认证，任何主动私聊提醒认证的都是骗子",
                        style: TextStyle(
                            fontSize: Dimens.pt13,
                            color: Colors.white.withOpacity(0.7),
                            height: 2.0,
                            fontWeight: FontWeight.w400),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: Dimens.pt30, bottom: Dimens.pt56),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            ///processingStatus //处理状态 0未提交 1:未处理 2:已处理 3:已拒绝
                            //1 审核中 2 认证成功 "立即认证"
                            commonSubmitButton(_getProcessingStatusName(state),
                                onTap: () {
                              int processingStatus =
                                  _getProcessingStatus(state);
                              if (processingStatus == 1) {
                                showToast(msg: "认证审核中~");
                                return;
                              }
                              if (processingStatus == 2) {
                                showToast(msg: "已认证~");
                                return;
                              }
                              dispatch(MyCertificationActionCreator.submit());
                            }),
                            const SizedBox(height: 16),
                            RichText(
                              text: TextSpan(
                                text: "审核结果会在",
                                style: TextStyle(
                                  fontSize: Dimens.pt12,
                                  color: AppColors.userPayTextColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: "15天内",
                                    style: TextStyle(
                                      fontSize: Dimens.pt12,
                                      color:
                                          AppColors.userCertificationTextColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "以站内消息形式进行通知",
                                    style: TextStyle(
                                        fontSize: Dimens.pt12,
                                        color: AppColors.userPayTextColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

///特权说明UI
Widget _buildPrivilegeDescriptionUI() {
  return Container(
    margin: EdgeInsets.only(top: 16),
    padding: EdgeInsets.only(top: 16, left: 16, right: 16),
    alignment: Alignment.topCenter,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.userMakeBgColor),
    child: Column(
      children: [
        Text(
          "大V特权说明",
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: Dimens.pt16,
          ),
        ),
        SizedBox(height: Dimens.pt16),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: _buildPrivilegeDescriptionItemUI("大V标识", "更加权威提高可信度")),
            Expanded(
                flex: 1,
                child:
                    _buildPrivilegeDescriptionItemUI("优质推荐", "首页/搜索页特殊推荐展示")),
          ],
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: _buildPrivilegeDescriptionItemUI("流量扶持", "更多推荐快速涨粉变现")),
            Expanded(
                flex: 1,
                child: _buildPrivilegeDescriptionItemUI("优先审核", "专属客服优先审核")),
          ],
        ),
        Row(
          children: [
            // Expanded(
            //     flex: 1,
            //     child: _buildPrivilegeDescriptionItemUI("更低费率", "10%更低费率快速提现",
            //         showLine: false)),
            Expanded(
                flex: 1,
                child: _buildPrivilegeDescriptionItemUI("专属客服", "专人对接优先解决")),
            Expanded(
                flex: 1,
                child: _buildPrivilegeDescriptionItemUI("线下活动", "平台赞助体验线下交友")),
          ],
        ),
      ],
    ),
  );
}

///设置特权菜单UI
Widget _buildPrivilegeDescriptionItemUI(String topStr, String bottomStr,
    {bool showLine = true}) {
  return Container(
    color: AppColors.userMakeBgColor,
    margin: EdgeInsets.only(
        top: Dimens.pt8, bottom: Dimens.pt8, right: Dimens.pt12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          topStr,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: Dimens.pt14,
          ),
        ),
        SizedBox(height: Dimens.pt12),
        Text(
          bottomStr,
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: Dimens.pt11,
          ),
        ),
        SizedBox(height: Dimens.pt16),
        Container(
          height: 0.5,
          color: showLine ? Colors.grey : Colors.transparent,
        ),
      ],
    ),
  );
}

///创建认证特权item
Widget _createCertificationItem(String imagePath, String desc) {
  return Container(
    child: Column(
      children: [
        Image(
            image: AssetImage(imagePath),
            width: Dimens.pt50,
            height: Dimens.pt50),
        const SizedBox(height: 9),
        Text(
          desc,
          style: TextStyle(color: Colors.white, fontSize: Dimens.pt12),
        ),
      ],
    ),
  );
}

///设置认证状态
int _getProcessingStatus(MyCertificationState state) {
  int processingStatus =
      state.userCertification?.officialcer?.processingStatus ?? 0;
  return processingStatus;
}

///processingStatus //处理状态 0未提交 1:未处理 2:已处理 3:已拒绝
//1 审核中 2 认证成功 "立即认证"
String _getProcessingStatusName(MyCertificationState state) {
  int processingStatus = _getProcessingStatus(state);
  if (processingStatus == 1) {
    return "认证审核中";
  } else if (processingStatus == 2) {
    return "已认证";
  }
  return "立即认证";
}
