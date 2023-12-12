import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/utils/navigator_util.dart';

/// 系统公告--图片公告
class RuleImageDialog extends StatelessWidget {
  final String cover;
  final double aspectRatio;
  RuleImageDialog({Key key, this.cover, this.aspectRatio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0x0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        // width: Dimens.pt300,
        height: Dimens.pt461,
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0x0),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    safePopPage(true);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    child: CustomNetworkImage(
                      placeholder: Container(
                        color: Color(0x0),
                      ),
                      imageUrl: cover,
                      width: Dimens.pt315,
                      height: Dimens.pt394,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Dimens.pt20),
            ),
            GestureDetector(
              onTap: () {
                safePopPage(false);
              },
              child: svgAssets(AssetsSvg.CLOSE_BTN,
                  width: Dimens.pt35, height: Dimens.pt35),
            )
          ],
        ),
      ),
    );
  }
}
