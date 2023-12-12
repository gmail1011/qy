import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/page/wallet/my_agent/gamePromotion_page/page.dart';
import 'package:flutter_app/page/wallet/my_agent/view/agent_view.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    GamePromotionState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: Dimens.pt100),
            child: Container(
              padding: EdgeInsets.only(
                  left: Dimens.pt16, right: Dimens.pt16, top: Dimens.pt16),
              child: Column(
                children: <Widget>[
                  createIncomeBalanceWidget(state, dispatch, viewService),
                  Padding(
                      padding: EdgeInsets.only(top: Dimens.pt16),
                      child: gameLine(Color(0xffffffff))),
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: AppPaddings.appMargin),
                    padding: EdgeInsets.all(AppPaddings.appMargin),
                    decoration: BoxDecoration(
                        color: Color(0xFF2F2F5F),
                        borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      children: [
                        createVideoIncomeWidget(state, dispatch, viewService),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Dimens.pt8, bottom: Dimens.pt8),
                    child: gameLine(Color(0xffffffff), height: 1),
                  ),
                  _buttonWidget(state, dispatch, viewService),
                  Padding(
                      padding: EdgeInsets.only(top: Dimens.pt16),
                      child: gameLine(Color(0xffffffff))),
                  _agentInstruction(),
                  _agentDetailed(),
                  // agentHLine(),
                  _descriptionView(state, dispatch, viewService),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: screen.paddingBottom,
            left: 0,
            child: GestureDetector(
              onTap: () {
                dispatch(GamePromotionActionCreator.onService());
              },
              child: svgAssets(
                AssetsSvg.VIP_MEMBER_CUSTOMER_SERVICE,
                width: Dimens.pt56,
                height: Dimens.pt56,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// balance
Widget createIncomeBalanceWidget(
    GamePromotionState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          Lang.INCOME_BALANCE,
          style: TextStyle(fontSize: Dimens.pt16, color: Colors.white),
        ),
        SizedBox(
          height: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(Dimens.pt5),
                width: Dimens.pt32,
                height: Dimens.pt32,
                child: svgAssets(
                  AssetsSvg.IC_GOLD,
                )),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: Dimens.pt10),
                child: Text(
                  "${state.userIncomeModel?.totalAmount ?? "0"}",
                  style: TextStyle(fontSize: Dimens.pt24, color: Colors.white),
                ),
              ),
            ),
            getLinearGradientBtn(
              Lang.WITHDRAW,
              onTap: () {
                dispatch(GamePromotionActionCreator.onWithdraw());
              },
            ),
          ],
        ),
      ],
    ),
  );
}

//video income
Widget createVideoIncomeWidget(
    GamePromotionState state, Dispatch dispatch, ViewService viewService) {
  return Row(
    children: [
      agentShowItemView(
        "成功推广数",
        "${state.gamePromotionData?.totalInvites ?? "0"}",
        alignment: Alignment.centerLeft,
      ),
      agentShowItemView(
        "昨日推广收益",
        "${state.gamePromotionData?.yesterdaylInviteAmount ?? "0.00"}",
        subValue: Lang.GOLD,
      ),
      agentShowItemView(
        "总推广收益",
        "${state.userIncomeModel?.totalIncomeAmount ?? "0.00"}",
        subValue: Lang.GOLD,
        alignment: Alignment.centerRight,
      ),
    ],
  );
}

//代理收益
Widget _buttonWidget(
    GamePromotionState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    padding: EdgeInsets.only(top: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _button(() {
          JRouter().jumpPage(PAGE_AGENT_GAME_RECORD);
        }, AssetsImages.IC_AGENT_JL, "收益明细"),
        _button(() {
          JRouter().jumpPage(PAGE_PROMOTION_RECORD);
        }, AssetsImages.IC_AGENT_MX, "推广记录"),
        _button(() {
          JRouter().jumpPage(PAGE_PERSONAL_CARD);
        }, AssetsImages.IC_AGENT_TG, "去推广"),
      ],
    ),
  );
}

Widget _agentInstruction() {
  return Column(
    children: [
      _titleView("代理说明"),
      Container(
        padding: EdgeInsets.only(
            top: Dimens.pt8,
            left: Dimens.pt8,
            right: Dimens.pt8,
            bottom: Dimens.pt16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.pt8),
            border: Border.all(color: Color(0xffECD6B2), width: Dimens.pt2)),
        child: Text("玩家通过扫描你的二维码或者链接下载APP，玩家充值或下注即可产生收益，推的越多赚的越多，收益达到200即可直接提现。",
            style: TextStyle(color: Colors.white, fontSize: Dimens.pt14)),
      )
    ],
  );
}

Widget _agentDetailed() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      _titleView("代理详解"),
      Container(
          padding: EdgeInsets.only(
              top: Dimens.pt8,
              left: Dimens.pt8,
              right: Dimens.pt8,
              bottom: Dimens.pt16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.pt8),
              border: Border.all(color: Color(0xffECD6B2), width: Dimens.pt2)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _subAgentDetailed("单日税收", "直推当日税收 + 下级代理当日税收(提成点位只升不降)"),
              Padding(
                padding: EdgeInsets.only(top: Dimens.pt8, bottom: Dimens.pt8),
                child: gameLine(Color(0xffFFFFEA47), height: 1),
              ),
              _subAgentDetailed("单日收益", "直推收益 + 下级代理收益"),
              Padding(
                padding: EdgeInsets.only(top: Dimens.pt8, bottom: Dimens.pt8),
                child: gameLine(Color(0xffFFFFEA47), height: 1),
              ),
              _subAgentDetailed("直推收益", "自己的返利百分比*直推税收"),
              Padding(
                padding: EdgeInsets.only(top: Dimens.pt8, bottom: Dimens.pt8),
                child: gameLine(Color(0xffFFFFEA47), height: 1),
              ),
              _subAgentDetailed("下次代理收益", "(自己的返利百分比-下级的返利百分比)*下级的税收"),
            ],
          ))
    ],
  );
}

Widget _subAgentDetailed(String title, String subTitle) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: Dimens.pt12,
            height: Dimens.pt12,
            decoration: BoxDecoration(
              color: Color(0xffECD6B2),
              borderRadius: BorderRadius.circular(Dimens.pt6),
            ),
          ),
          SizedBox(width: Dimens.pt8),
          Text(
            "$title",
            style: TextStyle(color: Color(0xffECD6B2), fontSize: Dimens.pt16),
          ),
        ],
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: Dimens.pt20, top: Dimens.pt4),
        child: Text("$subTitle",
            style: TextStyle(color: Colors.white, fontSize: Dimens.pt12),
            textAlign: TextAlign.start),
      )
    ],
  );
}

Widget _descriptionView(
    GamePromotionState state, Dispatch dispatch, ViewService viewService) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _titleView("直推返利"),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "单日税收",
            style: TextStyle(
              fontSize: Dimens.pt16,
              color: Color(0xffDCC8AA),
            ),
          ),
          Text(
            "返利百分比",
            style: TextStyle(
              fontSize: Dimens.pt16,
              color: Color(0xffDCC8AA),
            ),
          ),
          Text(
            "预估收益",
            style: TextStyle(
              fontSize: Dimens.pt16,
              color: Color(0xffDCC8AA),
            ),
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.only(top: Dimens.pt8, bottom: Dimens.pt8),
        child: gameLine(Color(0xffFFFFEA47), height: 1),
      ),
      _agentView("7万以上", "返利 26%", "18200"),
      Padding(
        padding: EdgeInsets.only(top: Dimens.pt8, bottom: Dimens.pt8),
        child: gameLine(Color(0xffFFFFEA47), height: 1),
      ),
      _agentView("6万～7万", "返利 24%", "14400"),
      Padding(
        padding: EdgeInsets.only(top: Dimens.pt8, bottom: Dimens.pt8),
        child: gameLine(Color(0xffFFFFEA47), height: 1),
      ),
      _agentView("5万～6万", "返利 23%", "11500"),
      Padding(
        padding: EdgeInsets.only(top: Dimens.pt8, bottom: Dimens.pt8),
        child: gameLine(Color(0xffFFFFEA47), height: 1),
      ),
      _agentView("4万～5万", "返利 22%", "8800"),
      Padding(
        padding: EdgeInsets.only(top: Dimens.pt8, bottom: Dimens.pt8),
        child: gameLine(Color(0xffFFFFEA47), height: 1),
      ),
      _agentView("3万～4万", "返利 21%", "6300"),
      Padding(
        padding: EdgeInsets.only(top: Dimens.pt8, bottom: Dimens.pt8),
        child: gameLine(Color(0xffFFFFEA47), height: 1),
      ),
      _agentView("2万～3万", "返利 20%", "4000"),
      Padding(
        padding: EdgeInsets.only(top: Dimens.pt8, bottom: Dimens.pt8),
        child: gameLine(Color(0xffFFFFEA47), height: 1),
      ),
      _agentView("1万～2万", "返利 19%", "1900"),
      Padding(
        padding: EdgeInsets.only(top: Dimens.pt8, bottom: Dimens.pt8),
        child: gameLine(Color(0xffFFFFEA47), height: 1),
      ),
      _agentView("1万以下", "返利 18%", "1799"),
      SizedBox(height: Dimens.pt16),
      gameLine(Color(0xffFFFFEA47)),
      SizedBox(height: Dimens.pt4),
      lowerRebate(),
      SizedBox(height: Dimens.pt16),
      Text(
        "一看即会，任何人都可参与，边吃瓜边赚钱",
        style: TextStyle(fontSize: Dimens.pt16, color: Colors.white),
      ),
      RichText(
        text: TextSpan(
          style: TextStyle(height: 1.5),
          children: [
            TextSpan(
              style: TextStyle(fontSize: Dimens.pt16),
              text: "终身享受利润分红，任何疑问请联系",
            ),
            TextSpan(
              style: TextStyle(fontSize: Dimens.pt16, color: Colors.red),
              text: "在线客服",
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  csManager.openServices(viewService.context);
                },
            ),
          ],
        ),
      ),
    ],
  );
}

Widget lowerRebate() {
  return Column(
    children: [
      _titleView("下级返利"),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "例如：",
            style: TextStyle(color: Colors.white, fontSize: Dimens.pt12),
          ),
          Text(
            "您的单日税收为75000，您的某下级代理的单日税收为12000，那么您得到该下级的返利百分比：26%-19%=7%。所得返利收益：7%*12000=840",
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimens.pt12,
            ),
          ),
          SizedBox(
            height: Dimens.pt8,
          ),
          Text(
            "注：自己和下级返利百分比相同的时候，下级代理的返利百分比会自动补1%",
            style: TextStyle(
                color: Color(0xffDCC8AA),
                fontSize: Dimens.pt12,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: Dimens.pt26,
          ),
        ],
      ),
      gameLine(Color(0xffffffff))
    ],
  );
}

Widget _button(VoidCallback callback, String imagePath, String title) {
  return GestureDetector(
    child: new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ImageLoader.withP(ImageType.IMAGE_ASSETS,
                address: imagePath, height: Dimens.pt60, width: Dimens.pt60)
            .load(),
        Container(height: Dimens.pt6),
        Text(title,
            style: TextStyle(color: Colors.white, fontSize: Dimens.pt14))
      ],
    ),
    onTap: callback,
  );
}

Widget _agentView(String title, String subTitle, String income) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: Dimens.pt12,
          color: Colors.white,
        ),
      ),
      Text(
        subTitle,
        style: TextStyle(
          fontSize: Dimens.pt12,
          color: Colors.white,
        ),
      ),
      Text(
        income,
        style: TextStyle(
          fontSize: Dimens.pt12,
          color: Colors.white,
        ),
      ),
    ],
  );
}

Widget _titleView(String title) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: AppPaddings.appMargin),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RotatedBox(
          quarterTurns: 2,
          child: ImageLoader.withP(
            ImageType.IMAGE_ASSETS,
            address: AssetsImages.IC_AGENT_TITLE,
            width: Dimens.pt80,
          ).load(),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimens.pt25),
          child: Text(
            title,
            style: TextStyle(
                color: Color(0xFFECD6B2),
                fontSize: Dimens.pt25,
                fontWeight: FontWeight.bold),
          ),
        ),
        ImageLoader.withP(
          ImageType.IMAGE_ASSETS,
          address: AssetsImages.IC_AGENT_TITLE,
          width: Dimens.pt80,
        ).load(),
      ],
    ),
  );
}
