import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/setting/mobile_login/action.dart';
import 'package:flutter_app/page/setting/mobile_login/state.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class GetCodeBtnWidget extends StatefulWidget {
  MobileLoginState state;
  Dispatch dispatch;
  GetCodeBtnWidget(this.state, this.dispatch);

  @override
  State<StatefulWidget> createState() {
    return GetCodeBtnWidgetState();
  }
}

class GetCodeBtnWidgetState extends State<GetCodeBtnWidget>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  bool isStartCountDown = false;
  bool hasClick = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: CustomEdgeInsets.fromLTRB(10, 4, 10, 4),
        child: Text(getVerifyCodeTip(),
            style: TextStyle(fontSize: Dimens.pt12, color: Color(0xffff7f0f))),
      ),
      onTap: () async {
        ///获取验证码
        if (ClickUtil.isFastClick() || isStartCountDown) {
          return;
        }

        /*bool res = await parsePhoneNumber();
        if (!res) {
          showToast(msg: Lang.PHONE_NUMBER_ERROR, gravity: ToastGravity.CENTER);
          return;
        }*/
        if (isMaJiaAccount()) {
          widget.dispatch(MobileLoginActionCreator.onGetSMSCode(true));
        } else {
          widget.dispatch(MobileLoginActionCreator.getSMSCode(getFullPhone()));
        }
        isStartCountDown = true;
        setState(() {});
      },
    );
  }

  bool isMaJiaAccount() {
    if (widget.state.areaCode == "86" &&
        widget.state.phoneController.text
            .replaceAll(" ", "")
            .startsWith("122")) {
      return true;
    }
    return false;
  }

  String getFullPhone() {
    //拼接区号和手机号
    var resultMobile = "+${widget.state.areaCode ?? 86}".replaceAll(" ", "") +
        widget.state.phoneController.text.replaceAll(" ", "");
    if (widget.state.areaCode != null ||
        (widget.state.areaCode?.isNotEmpty ?? false)) {
      resultMobile = "+" +
          widget.state.areaCode.replaceAll(" ", "") +
          widget.state.phoneController.text.replaceAll(" ", "");
    }
    return resultMobile;
  }

  //验证手机号是否正确
  Future<bool> parsePhoneNumber() async {
    if (isMaJiaAccount()) {
      return Future.value(true);
    }
    //拼接区号和手机号
    var resultMobile = getFullPhone();
    try {
      //验证手机号
      final parsed = await widget.state.phoneNumberMgr.parse(resultMobile);
      if (parsed != null) {
        return Future.value(true);
      }
    } catch (e) {
      return Future.value(false);
    }
    return Future.value(false);
  }

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(seconds: 60), vsync: this);
    animation = Tween(begin: 60.0, end: 0.0).animate(animationController)
      ..addListener(() {
        if (this.mounted == false) return;
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          isStartCountDown = false;
          setState(() {});
        }
      });
    animationController.reverse();

    super.initState();
  }

  String getVerifyCodeTip() {
    if (isStartCountDown) {
      if (animationController.status == AnimationStatus.dismissed) {
        animationController.forward();
      }
      if (animationController.status == AnimationStatus.completed) {
        animationController.reset();
        animationController.forward();
      }
      return '${animation.value.toInt()}s';
    } else {
      return Lang.GET_VERIFY_CODE;
    }
  }

  @override
  void dispose() {
    if (animationController == null) {
      return;
    }
    animationController.dispose();
    super.dispose();
  }
}
