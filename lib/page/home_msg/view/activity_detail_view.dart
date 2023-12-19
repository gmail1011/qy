import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/model/activity_response.dart';
import 'package:flutter_app/widget/richTextParsing/html_parser.dart';
import 'package:flutter_base/utils/screen.dart';

class ActivityDetailView extends StatelessWidget {
  final ActivityModel activityModel;

  const ActivityDetailView({Key key, this.activityModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 600 / 800,
            child: activityModel?.image?.isNotEmpty == true
                ? CustomNetworkImage(
                    imageUrl: activityModel?.image?.first ?? "",
                  )
                : SizedBox(),
          ),
          const SizedBox(height: 16),
          Text(
            activityModel.title ?? "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),
          DefaultTextStyle(
            style: const TextStyle(color: Colors.white),
            child: Wrap(
              alignment: WrapAlignment.start,
              children: HtmlParser(
                width: screen.screenWidth - 16 * 2,
              ).parse(activityModel?.content ?? ""),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(height: 18),
          Container(
            height: (68 / 343) * (screen.screenWidth - 16 * 2) + 13,
            child: Stack(
              children: [
                Positioned(
                  top: 13,
                  left: 0,
                  right: 0,
                  child: AspectRatio(
                    aspectRatio: 343 / 68,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(12, 4, 12, 0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/bord_yellow_bg.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Text(
                        "群内禁止发送任何私人联系方式，请大家谨防诈骗，所有言论均是用户私人行为，平台不做任何担保。",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset(
                    "assets/images/imply_text.png",
                    width: 72,
                    height: 26,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
