import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

//中间文字的appBar
class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  final Widget leading;
  final String title;
  final List<Widget> actions;
  final VoidCallback backClick;
  final bool hideBackBtn;
  final Widget child;
  CustomAppbar({
    this.leading,
    this.title = '',
    this.actions,
    this.backClick,
    this.hideBackBtn = false,
    this.child,
  }) : super();

  @override
  State<StatefulWidget> createState() {
    return new _CustomAppbarState();
  }

  @override
  Size get preferredSize =>
      new Size.fromHeight(kToolbarHeight + screen.paddingTop);
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: ExactAssetImage(AssetsImages.APPBAR_BG),
          //         fit: BoxFit.fill)),
          height: kToolbarHeight + screen.paddingTop,
          padding: EdgeInsets.only(
            top: screen.paddingTop,
            right: AppPaddings.appMargin,
            left: AppPaddings.appMargin,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                left: 0,
                child: widget.leading ??
                    (widget.hideBackBtn
                        ? Container()
                        : GestureDetector(
                            child: Container(
                                width: kToolbarHeight,
                                height: kToolbarHeight,
                                color: Colors.transparent,
                                alignment: Alignment.centerLeft,
                                child: ImageLoader.withP(ImageType.IMAGE_SVG,
                                        address: AssetsSvg.BACK,
                                        width: 16,
                                        height: 16,
                                        fit: BoxFit.scaleDown)
                                    .load()),
                            onTap: () {
                              if (widget.backClick != null) {
                                widget.backClick();
                              } else {
                                if (Navigator.canPop(context)) {
                                  safePopPage();
                                }
                              }
                            },
                          )),
              ),
              Container(
                child: null != widget.child
                    ? widget.child
                    : Text(widget.title,
                        style: TextStyle(
                            fontSize: Dimens.pt17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
              ),
              Positioned(
                  right: 0,
                  child: Row(
                    children: widget.actions ?? [],
                  )),
            ],
          )),
    );
  }
}
