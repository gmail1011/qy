import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'action.dart';
import 'state.dart';

///账号找回-绑定手机号找回
Widget buildView(
    RecoverMobileState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
      child: Scaffold(
    appBar: getCommonAppBar("账号找回"),
    body: Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            color: Color(0xff242424),
            width: screen.screenWidth,
            height: Dimens.pt44,
            padding: EdgeInsets.only(left: Dimens.pt16),
            child: Text(
              "请输入要找回的账号信息",
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: Dimens.pt14,
              ),
            ),
          ),
          _createDownUI(state, dispatch, viewService),
          Container(
            margin: EdgeInsets.only(left: Dimens.pt16, right: Dimens.pt16),
            height: 0.5,
            color: Colors.white.withOpacity(0.16),
          ),
          Container(
            margin: EdgeInsets.only(
                top: Dimens.pt16, left: Dimens.pt16, right: Dimens.pt16),
            child: TextField(
              controller: state.mobileEditingController,
              cursorColor: Colors.white.withOpacity(0.16),
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: Dimens.pt16,
              ),
              decoration: InputDecoration(
                hintText: "请输入已绑定手机号",
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: Dimens.pt16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.16),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.16),
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.16),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40, left: 16, right: 16),
            child:
                commonSubmitButton("下一步", width: screen.screenWidth, onTap: () {
              String mobile =
                  state.mobileEditingController.text?.toString()?.trim();
              if (mobile == null || "" == mobile) {
                showToast(msg: "绑定的手机号不能位空");
                return;
              }
              JRouter().go(PAGE_INITIAL_BIND_PHONE, arguments: {
                "bindMobileTitle": "更换绑定手机号",
                "bindMobileType": 2,
                "mobileNum": mobile,
              });
            }),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                svgAssets(AssetsSvg.ICON_DOWN_TAG, width: 18, height: 18),
                const SizedBox(width: 5),
                Text(
                  "已绑定手机号：是您用于登录的手机号",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: Dimens.pt14),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ));
}

///手机号
Widget _createMobileItem(Dispatch dispatch) {
  return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            dispatch(RecoverMobileActionCreator.updateMobileText(
                GlobalStore?.getMe()?.mobile ?? ""));

            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          child: Container(
            color: Colors.transparent,
            width: screen.screenWidth,
            margin: const EdgeInsets.only(left: 16, right: 16),
            height: 48,
            alignment: Alignment.centerLeft,
            child: Text(GlobalStore?.getMe()?.mobile ?? "",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: Dimens.pt15,
                    decoration: TextDecoration.none)),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            height: 0.5,
            color: Colors.white.withOpacity(0.16));
      },
      itemCount: (GlobalStore?.getMe()?.mobile ?? "").isEmpty ? 0 : 1);
}

///下拉菜单
Widget _createDownUI(
    RecoverMobileState state, Dispatch dispatch, ViewService viewService) {
  return Center(
    heightFactor: 1.0,
    child: Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      key: state.globalKey,
      height: 44,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            RenderBox renderBox =
                state.globalKey.currentContext.findRenderObject();
            Rect box = renderBox.localToGlobal(Offset.zero) & renderBox.size;
            print(box);
            Navigator.push(
                viewService.context,
                _DropDownMenuRoute(
                  position: box,
                  menuHeight: Dimens.pt150,
                  child: MediaQuery.removePadding(
                    removeTop: true,
                    context: viewService.context,
                    child: _createMobileItem(dispatch),
                  ),
                ));
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  "已绑定手机号",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              svgAssets(AssetsSvg.ICON_DOWN_ARROW, width: 12, height: 7),
            ],
          ),
        ),
      ),
    ),
  );
}

class _DropDownMenuRouteLayout extends SingleChildLayoutDelegate {
  final Rect position;
  final double menuHeight;

  _DropDownMenuRouteLayout({this.position, this.menuHeight});

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(Size(position.right - position.left, 300));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0, position.bottom);
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return true;
  }
}

class _DropDownMenuRoute extends PopupRoute {
  final Rect position;
  final double menuHeight;
  final Widget child;

  _DropDownMenuRoute({this.position, this.menuHeight, this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return CustomSingleChildLayout(
      delegate:
          _DropDownMenuRouteLayout(position: position, menuHeight: menuHeight),
      child: SizeTransition(
        sizeFactor: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
        child: Container(
          color: Color(0xff151515),
          height: menuHeight,
          child: child,
        ),
      ),
    );
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);
}
