import 'package:flutter/material.dart';
import 'package:flutter_app/new_page/mine/floating_cs_view.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/full_bg.dart';

///帮助反馈
class ImageViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageViewPageState();
  }
}

class _ImageViewPageState extends State<ImageViewPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
          appBar: CustomAppbar(title: ""),
          body: Stack(
            children: [
              PageView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.only(bottom: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "常见问题与反馈",
                        style: const TextStyle(
                            color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: 24.0),
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: questionList.map((e) => _getItem(context, e)).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _getItem(context, item) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            item["question"],
            style:
            const TextStyle(color: const Color(0xffc6c6c6), fontWeight: FontWeight.w700, fontSize: 16.0),
          ),
          SizedBox(height: 5),
          Text(
            item["answer"],
            style:
            const TextStyle(color: const Color(0xff808080), fontWeight: FontWeight.w400, fontSize: 14.0),
          ),
        ]));
  }
}
