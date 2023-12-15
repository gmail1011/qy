import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/activity_response.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/richTextParsing/html_parser.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/screen.dart';

class ActivityDetailPage extends StatefulWidget {
  final String id;

  const ActivityDetailPage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ActivityDetailPageState();
  }
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  ActivityModel model;
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData(widget.id ?? "");
    });
  }

  void _loadData(String id) async {
    try {
      var response = await netManager.client.getTopicDetail(id);
      if (response is Map) {
        model = ActivityModel.fromJson(response as Map<String, dynamic>);
      }
    } catch (e) {
      debugLog(e);
    }
    model ??= ActivityModel();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCommonAppBar("活动详情"),
      body: _buildContent(),
      // bottomSheet: Container(
      //   height: 83,
      //   color: Color.fromRGBO(31, 31, 31, 1),
      //   padding: EdgeInsets.only(left: 16, right: 16),
      //   child: Row(
      //     children: [
      //       GestureDetector(
      //         child: Container(
      //           margin: EdgeInsets.only(bottom: 22),
      //           child: isSending
      //               ? SizedBox(
      //                   width: 32,
      //                   height: 32,
      //                   child: CupertinoTheme(
      //                     data: CupertinoThemeData(brightness: Brightness.dark),
      //                     child: CupertinoActivityIndicator(),
      //                   ),
      //                 )
      //               : Image.asset(
      //                   "assets/weibo/icon_msg_select_imag.png",
      //                   width: 32,
      //                   height: 32,
      //                 ),
      //         ),
      //         onTap: () async {},
      //       ),
      //       SizedBox(width: 8),
      //       Expanded(
      //         flex: 1,
      //         child: Container(
      //           //margin: EdgeInsets.only(top: Dimens.pt10, right: Dimens.pt10,),
      //           //constraints: BoxConstraints(maxHeight: 30.w,minHeight: 30.w),
      //           alignment: Alignment.centerLeft,
      //           height: 66,
      //           child: TextField(
      //             keyboardType: TextInputType.text,
      //             autofocus: false,
      //             autocorrect: true,
      //             onTap: () {},
      //             textInputAction: TextInputAction.done,
      //             cursorColor: Colors.white,
      //             textAlign: TextAlign.left,
      //             // controller: _textEditingController,
      //             // focusNode: _focusNode,
      //             onChanged: (text) {},
      //             onSubmitted: (text) {
      //               //_sendMessage();
      //             },
      //             maxLines: 1,
      //             maxLength: 120,
      //             buildCounter: (_, {currentLength, maxLength, isFocused}) => Container(
      //               height: 20,
      //               alignment: Alignment.centerRight,
      //               child: Text(
      //                 currentLength.toString() + "/" + maxLength.toString(),
      //                 style: TextStyle(color: Colors.white, fontSize: 12),
      //               ),
      //             ),
      //             style: TextStyle(color: Colors.white, fontSize: 16),
      //             decoration: InputDecoration(
      //               fillColor: Color.fromRGBO(44, 44, 44, 1),
      //               hintText: "请输入内容",
      //               hintStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10),
      //               contentPadding: EdgeInsets.fromLTRB(10, 10, 5, 10),
      //               filled: true,
      //               isCollapsed: true,
      //               border: OutlineInputBorder(
      //                   borderSide: BorderSide(color: Color.fromRGBO(44, 44, 44, 1)), borderRadius: BorderRadius.circular(26)),
      //               focusedBorder: OutlineInputBorder(
      //                 borderSide: BorderSide(color: Color.fromRGBO(44, 44, 44, 1)),
      //                 borderRadius: BorderRadius.circular(26),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //       SizedBox(width: 12),
      //       GestureDetector(
      //         onTap: () {},
      //         child: Container(
      //           margin: EdgeInsets.only(bottom: 22),
      //           child: isSending
      //               ? SizedBox(
      //                   width: 32,
      //                   height: 32,
      //                   child: CupertinoTheme(
      //                     data: CupertinoThemeData(brightness: Brightness.dark),
      //                     child: CupertinoActivityIndicator(),
      //                   ),
      //                 )
      //               : Image.asset(
      //                   "assets/weibo/images/icon_send_comment_two.png",
      //                   width: 32,
      //                   height: 32,
      //                 ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildContent() {
    if (model == null) {
      return LoadingCenterWidget();
    } else if (model?.id == null) {
      return CErrorWidget(
        "暂无数据",
        retryOnTap: () {
          model = null;
          setState(() {});
          _loadData(widget.id ?? "");
        },
      );
    } else {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 720 / 300,
                child: CustomNetworkImage(
                  imageUrl: model?.img,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                model.title,
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
                  ).parse(model?.content ?? ""),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 1,
                color: Colors.white.withOpacity(0.1),
              ),
              const SizedBox(height: 18),
              Container(
                height: (343 / 68) * (screen.screenWidth - 16*2) + 13,
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
        ),
      );
    }
  }
}
