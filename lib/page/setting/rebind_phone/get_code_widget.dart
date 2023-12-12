import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/setting/rebind_phone/state.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'action.dart';

// ignore: must_be_immutable
class GetCodeBtn extends StatefulWidget {
  RebindPhoneState state;
  Dispatch dispatch;

  GetCodeBtn(this.state, this.dispatch);

  @override
  State<StatefulWidget> createState() {
    return GetCodeBtnState();
  }
}

class GetCodeBtnState extends State<GetCodeBtn>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  bool isStartCountDown = false;

  bool hasClick = false;
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
        }
      });
    animationController.reverse();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: CustomEdgeInsets.fromLTRB(10, 4, 10, 4),
        child: Text(getVerifyCodeTip(),
            style: TextStyle(fontSize: Dimens.pt10, color: Colors.white)),
      ),
      onTap: () async {
        if (ClickUtil.isFastClick() || isStartCountDown) {
          return;
        }
        /*bool res = await parsePhoneNumber();
        if (!res) {
          showToast(msg: Lang.PHONE_NUMBER_ERROR, gravity: ToastGravity.CENTER);
          return;
        }*/
        if (isMaJiaAccount()) {
          widget.dispatch(RebindPhoneActionCreator.onGetSMSCode(true));
        } else {
          widget.dispatch(RebindPhoneActionCreator.getSMSCode(getFullPhone()));
        }
        isStartCountDown = true;
        setState(() {});
      },
    );
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

  bool isMaJiaAccount() {
    if (widget.state.phoneCode == "86" &&
        widget.state.phoneController.text
            .replaceAll(" ", "")
            .startsWith("122")) {
      return true;
    }
    return false;
  }

  String getFullPhone() {
    //拼接区号和手机号
    var resultMobile = widget.state.phoneCode ??
        "86" + widget.state.phoneController.text.replaceAll(" ", "");
    if (widget.state.phoneCode != null ||
        (widget.state.phoneCode?.isNotEmpty ?? false)) {
      resultMobile = "+" +
          widget.state.phoneCode.replaceAll(" ", "") +
          widget.state.phoneController.text.replaceAll(" ", "");
    }
    return resultMobile;
  }
}
