import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/page/user/member_centre_page/page.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/custom_picture_management.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'action.dart';
import 'state.dart';

///愿望工单-发布
Widget buildView(
    WishPublishState state, Dispatch dispatch, ViewService viewService) {
  return SingleChildScrollView(
    child: Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //输入文本
          Container(
            padding: EdgeInsets.only(left: 14, right: 14, bottom: 14),
            color: AppColors.userMakeBgColor,
            child: TextField(
              controller: state.editingController,
              cursorColor: Colors.white.withOpacity(0.5),
              style: TextStyle(
                wordSpacing: 1.5,
                height: 1.5,
                color: Colors.white,
                fontSize: Dimens.pt12,
              ),
              maxLength: 1000,
              maxLines: 5,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "请输入问题（至少三个字）～",
                hintStyle: TextStyle(
                  color: AppColors.publishTextColor,
                  fontSize: Dimens.pt12,
                ),
                counterStyle: TextStyle(
                  color: AppColors.publishTextColor,
                  fontSize: Dimens.pt12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          //问题列表
          Text(
            "一个好的提问：",
            style: TextStyle(
                fontSize: Dimens.pt14, color: Colors.white.withOpacity(0.9)),
          ),

          _getCommonQuestionText("* 问题是什么？你想得到什么帮助？"),
          _getCommonQuestionText("* 例：求片神宫寺奈绪 URE-067 义父～裕美的午后 ？"),
          _getCommonQuestionText("* 例：如图求此片的番号 ？"),

          const SizedBox(height: 20),
          //添加图片
          PictureMangeWidget(
            picList: state.localImagePathList,
            width: Dimens.pt90,
            height: Dimens.pt90,
            deleteItemCallback: (index) => dispatch(
              WishPublishActionCreator.deleteImage(index),
            ),
            addItemCallback: () => dispatch(
              WishPublishActionCreator.selectImage(),
            ),
          ),
          const SizedBox(height: 20),
          //悬赏金币设置
          Row(
            children: [
              Expanded(
                child: Text(
                  "悬赏金币设置",
                  style: TextStyle(
                      fontSize: Dimens.pt14,
                      color: Colors.white.withOpacity(0.9)),
                ),
              ),

              //设置金额
              GestureDetector(
                onTap: () => showSetPriceDialog(state, dispatch, viewService),
                child: _buildSetAmountUI(state),
              ),
            ],
          ),

          //发布按钮
          Container(
            margin: const EdgeInsets.only(top: 60, bottom: 36),
            alignment: Alignment.center,
            child: commonSubmitButton("立即发布",
                onTap: () =>
                    dispatch(WishPublishActionCreator.publistQuestion())),
          ),
        ],
      ),
    ),
  );
}

///设置金额UI
Widget _buildSetAmountUI(WishPublishState state) {
  return (state.setAmountValue == null || state.setAmountValue == "0")
      ? Text(
          "免费",
          style: TextStyle(fontSize: 18.nsp, color: Colors.white),
        )
      : Row(
          children: [
            svgAssets(AssetsSvg.ICON_WISH_LIST01,
                width: Dimens.pt13, height: Dimens.pt13),
            const SizedBox(width: 3),
            Text(
              state.setAmountValue ?? "0",
              style: TextStyle(fontSize: 18.nsp, color: Colors.white),
            ),
            const SizedBox(width: 5),
          ],
        );
}

///获取相同问题
_getCommonQuestionText(String content) {
  return Container(
    margin: const EdgeInsets.only(top: 6),
    child: Text(
      content,
      style: TextStyle(
          fontSize: Dimens.pt12, color: Colors.white.withOpacity(0.5)),
    ),
  );
}

///添加图片按钮
_getAddPictureButton(Function onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(top: 10, bottom: 27),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.publishBorderColor, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      width: Dimens.pt82,
      height: Dimens.pt82,
      child: Text(
        "+",
        style: TextStyle(
            fontSize: Dimens.pt46,
            color: Colors.white.withOpacity(0.6),
            fontWeight: FontWeight.w300),
      ),
    ),
  );
}

///展示设置金额对话框
void showSetPriceDialog(
    WishPublishState state, Dispatch dispatch, ViewService viewService) {
  int selectIndex = -1;

  showDialog(
      context: viewService.context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
          child: StatefulBuilder(builder: (context, states) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 242, 230, 1),
                      Color.fromRGBO(255, 255, 255, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.only(left: 16, right: 16),
                //height: 264.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 18),
                    Text(
                      "设定价格",
                      style:
                          TextStyle(fontSize: Dimens.pt16, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: (6 / 3) * 39 + 7,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 83 / 39),
                        itemCount: 5 + 1,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return index == 5
                              ? Container(
                                  width: Dimens.pt84,
                                  height: Dimens.pt39,
                                  //设置 child 居中
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(bottom: 6),
                                  //边框设置
                                  decoration: new BoxDecoration(
                                    //背景
                                    color: Colors.white,
                                    //设置四周圆角 角度
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    //设置四周边框
                                    border: new Border.all(
                                        width: 1,
                                        color: Color.fromRGBO(255, 118, 0, 1)),
                                  ),
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: Dimens.pt18),
                                    maxLength: 100,
                                    maxLines: 1,
                                    controller: state.printEditingController,
                                    decoration: InputDecoration(
                                      hintText: "其它金额",
                                      border: InputBorder.none,
                                      counterText: '',
                                      hintStyle: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: Dimens.pt12),
                                    ),
                                    onChanged: (value) {
                                      selectIndex = -1;
                                      states(() {
                                      });
                                    },
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    selectIndex = index;
                                    states(() {});
                                  },
                                  child: Container(
                                    width: Dimens.pt84,
                                    height: Dimens.pt39,
                                    //设置 child 居中
                                    alignment: Alignment.center,
                                    //边框设置
                                    decoration: index == selectIndex
                                        ? new BoxDecoration(
                                            //背景
                                            color:
                                                Color.fromRGBO(255, 118, 0, 1),
                                            //设置四周圆角 角度
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                          )
                                        : new BoxDecoration(
                                            //背景
                                            color: Colors.white,
                                            //设置四周圆角 角度
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                            //设置四周边框
                                            border: new Border.all(
                                                width: 1,
                                                color: Color.fromRGBO(
                                                    255, 118, 0, 1)),
                                          ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/weibo/coin_publish.png",
                                          width: Dimens.pt13,
                                          height: Dimens.pt13,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          "${state.amountArr[index] ?? ""}",
                                          style: TextStyle(
                                              fontSize: Dimens.pt18,
                                              color: index == selectIndex
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          "钱包余额： ${((GlobalStore.getWallet().amount ?? 0) + (GlobalStore.getWallet().income ?? 0))}",
                          style: TextStyle(
                              fontSize: Dimens.pt12,
                              color: Colors.black.withOpacity(0.6)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // 根据钱包余额切换UI
                    _buildConfirmUI(
                        dispatch,
                        context,
                        selectIndex == -1
                            ? "0"
                            : "${state.amountArr[selectIndex]}",
                        state),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }),
        );
      });
}

///确定按钮UI
Widget _buildConfirmUI(Dispatch dispatch, BuildContext context,
    String amountValue, WishPublishState state) {
  ///总金额
  int totalMoney = (GlobalStore.getWallet().amount ?? 0) +
      (GlobalStore.getWallet().income ?? 0);
  return (totalMoney ?? 0) > 0
      ? commonSubmitButton("确定", width: Dimens.pt166, height: Dimens.pt36,
          onTap: () {

        num amountNum = num.parse(amountValue) ?? 0;
          //优先选中
          if (amountNum > 0) {
            double amount = double.parse(amountValue);
            if (totalMoney < amount) {
              showToast(msg: "设置金额大于钱包余额");
              return;
            }
            safePopPage(context);
            dispatch(WishPublishActionCreator.setAmountValue(amountValue));
          } else {
            String amountEditValue = state.printEditingController.text.trim();
            if (amountEditValue.isNotEmpty) {
              double editAmount = double.parse(amountEditValue);
              if (totalMoney < editAmount) {
                showToast(msg: "设置金额大于钱包余额");
                return;
              }
              safePopPage(context);
              dispatch(
                  WishPublishActionCreator.setAmountValue(amountEditValue));
            }
          }
          state.printEditingController.clear();
        })
      : commonSubmitButton("余额不足，前去充值", height: Dimens.pt36, onTap: () {
          safePopPage(context);
          Config.payFromType = PayFormType.user;
          Gets.Get.to(() => MemberCentrePage().buildPage({"position": "1"}),
              opaque: false);
        });
}
