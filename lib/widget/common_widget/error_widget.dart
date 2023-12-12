import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_base/utils/dimens.dart';

class CErrorWidget extends StatefulWidget {
  final String errorMsg;
  final String errorMsg2;
  final VoidCallback retryOnTap;
  final Color txtColor;

  CErrorWidget(this.errorMsg, {this.errorMsg2, this.retryOnTap, this.txtColor});

  @override
  State<StatefulWidget> createState() {
    return CErrorWidgetState();
  }
}

class CErrorWidgetState extends State<CErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage(AssetsImages.ICON_NO_DATA),
              width: 213,
              height: 146,
            ),


            SizedBox(height: 12,),

            Text(widget.errorMsg,
                style: TextStyle(
                    color: widget.txtColor != null
                        ? widget.txtColor
                        : Colors.white)),
            (widget.errorMsg2 != null
                ? Text(widget.errorMsg2,
                    style: TextStyle(
                        color: widget.txtColor != null
                            ? widget.txtColor
                            : Colors.white))
                : Container()),
            Visibility(
              visible: widget.retryOnTap != null,
              child: InkWell(
                onTap: widget.retryOnTap,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    Lang.CLICK_RETRY,
                    style: TextStyle(color: AppColors.primaryTextColor),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
