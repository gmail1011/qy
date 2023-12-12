import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

class PostSuccessDialogHjllView extends StatelessWidget {
  final String title;
  final String content;
  final String btnText;
  final Function callback;

  const PostSuccessDialogHjllView({Key key, this.title, this.content, this.btnText, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        child: Container(
          width: screen.screenWidth,
          height: screen.screenHeight,
          color: Colors.transparent,
          child: Center(
            child: Container(
              margin: EdgeInsets.only(left: 33, right: 33),
              width: 357,
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xff2e2e2e),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "发布成功",
                    style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      "帖子发布后将在24小时内进行审核，您可在【我的】-【我的帖子】中进行查看",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 105,
                          height: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xffca452e),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Text(
                            "确定",
                            style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 12),
                          ),
                        ),
                        onTap: () {
                          Future.delayed(Duration(milliseconds: 100), () {
                            safePopPage("sure");
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          safePopPage(false);
        },
      ),
    );
  }
}
