import 'package:flutter/cupertino.dart';
import 'package:flutter_app/assets/app_colors.dart';

///自定义阴影效果
class ShadowText extends StatelessWidget {
  //text
  final String content;
  final TextAlign textAlign;
  final int maxLines;
  final TextOverflow overflow;
  final bool softWrap;
  //style
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final bool shadow;

  final VoidCallback tabCallback;
  final EdgeInsets padding;

  ShadowText(
    this.content, {
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.tabCallback,
    this.padding,
    this.shadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tabCallback,
      child: Padding(
        padding: padding ?? EdgeInsets.all(0),
        child: Text(
          content,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          softWrap: softWrap,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            height: 1.5,
            fontWeight: FontWeight.normal,
            shadows: !shadow
                ? null
                : [
                    Shadow(
                        color: AppColors.tipTextColor99,
                        offset: Offset(1, 1),
                        blurRadius: 5)
                  ],
          ),
        ),
      ),
    );
  }
}
