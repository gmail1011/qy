import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/weibo_page/community_recommend/detail/community_detail_page.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WordRichText extends StatefulWidget {
  final VideoModel videoModel;
  final bool isBloggerPage;
  final String title;
  final String linkUrl;
  final int maxTextSize;
  final TextStyle textStyle;
  final bool isPost;
  final String randomTag;
  final LinearGradient linearGradient;

  final Function(String val1, LinearGradient val2) randomCallBack;  //随机完成之后，给到外部组件，进入详情使用

  const WordRichText({
    Key key,
    this.videoModel,
    this.isBloggerPage,
    this.maxTextSize,
    this.title,
    this.textStyle,
    this.isPost = false,
    this.linkUrl,
    this.randomTag,
    this.linearGradient,
    this.randomCallBack,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WordRichTextState();
  }
}

class _WordRichTextState extends State<WordRichText> {
  bool _expanded = false;
  bool hasExpanded = false;
  TapGestureRecognizer _expandTapGestureRecognizer;
  TapGestureRecognizer _expand2TapGestureRecognizer;
  TapGestureRecognizer _expand3TapGestureRecognizer;
  TapGestureRecognizer _linkTapGestureRecognizer;

  int get _maxSize => widget.maxTextSize ?? 100;
  VideoModel _realVideoModel;
  var text = "";
  LinearGradient  gradient =   LinearGradient(
    colors: [
    Color.fromRGBO(211, 31, 234, 1),
    Color.fromRGBO(255, 74, 74, 1),
    ]
  );

  VideoModel get realVideoModel {
    if (_realVideoModel == null) {
      if (widget.videoModel != null) {
        _realVideoModel = widget.videoModel;
      } else {
        _realVideoModel = VideoModel();
        _realVideoModel.title = widget.title ?? "";
        _realVideoModel.linkStr = widget.linkUrl ?? "";
      }
    }

    return _realVideoModel;
  }

  PostTitle get _postTitle => realVideoModel?.postTitle;

  @override
  void initState() {
    super.initState();
    if (realVideoModel.postTitle == null) {
      _parserPostTitle();
    }

    hasExpanded = (realVideoModel?.postTitle?.length ?? 0) > _maxSize;
    _expandTapGestureRecognizer = TapGestureRecognizer()
      ..onTapDown = _toggleExpanded;
    _expand2TapGestureRecognizer = TapGestureRecognizer()
      ..onTapDown = _toggleExpanded;
    _expand3TapGestureRecognizer = TapGestureRecognizer()
      ..onTapDown = _toggleExpanded;
    _linkTapGestureRecognizer = TapGestureRecognizer()
      ..onTapDown = _richTextEvent;

    // + min  表示生成一个最小数 min 到最大数之间的是数字
    if(Config.POST_TAG_RANDOM.length==0){
      Config.POST_TAG_RANDOM = ["精选"];
    }
    if(TextUtil.isEmpty(widget.randomTag) || widget.linearGradient==null){
      var count = Config.POST_TAG_RANDOM.length;
      var num = Random().nextInt(count) + 0;
      text  = Config.POST_TAG_RANDOM[num.floor()];
      var num1 = Random().nextInt(Config.gradientList.length) + 0;
      gradient  = Config.gradientList[num1.floor()];
      widget.randomCallBack?.call(text,gradient);
    }else{
      text = widget.randomTag;
      gradient = widget.linearGradient;
      widget.randomCallBack?.call(text,gradient);
    }

  }

  @override
  void dispose() {
    _expandTapGestureRecognizer.dispose();
    _expand2TapGestureRecognizer.dispose();
    _expand3TapGestureRecognizer.dispose();
    _linkTapGestureRecognizer.dispose();
    super.dispose();
  }

  String getSubString(String text, int start, int end){
    if(end + 1 >= text.length) return text;
    if(end < text.runes.length) {
      String targetText = String.fromCharCodes(
          text.runes.toList().sublist(start, end));
      return targetText;
    }
    return text;
  }
  void _parserPostTitle() {
    String originTitle = realVideoModel.title ?? "";
    String linkUrl = realVideoModel.linkStr ?? "";
    try {
      PostTitle postTitle = PostTitle(originTitle: originTitle, linkurl: linkUrl);
      List<String> linkArr = linkUrl.split("##");
      if (linkArr.length == 3) {
        Map<String, dynamic> linkInfo = jsonDecode(linkArr[1]);
        postTitle.jsonTxt = linkArr[1];
        postTitle.txt = linkInfo['txt'];
        postTitle.type = linkInfo['type'];
        postTitle.id = linkInfo['id'];
        List<String> titleArr = originTitle.split(linkInfo['txt']) ?? [];
        if(titleArr.length > 1){
          postTitle.isRich = true;
          postTitle.first = titleArr.first;
          titleArr.removeAt(0);
          postTitle.last = titleArr.join(linkInfo['txt']);
        }else{
          postTitle.isRich = false;
        }

      } else {
        postTitle.isRich = false;
      }
      realVideoModel.postTitle = postTitle;
    } catch (e) {
      debugLog("解析错误：$e");
    }
  }

  void _toggleExpanded(TapDownDetails detail) {
    _expanded = !_expanded;
    setState(() {});
  }

  void _richTextEvent(TapDownDetails detail) {
    if(realVideoModel.postTitle.type == 14 || realVideoModel.postTitle.type == 15){
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return CommunityDetailPage().buildPage(
              {"videoId": realVideoModel.postTitle?.id});
        }));
    }else {
      JRouter().go(realVideoModel.postTitle.linkUrl);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Text.rich(
        TextSpan(
            style: widget.textStyle ??
                TextStyle(
                  color: Colors.white,
                  fontSize: 16.nsp,
                ),
            children: [
              if (realVideoModel.isChoosen == true)
                WidgetSpan(
                  child: Container(
                    margin: EdgeInsets.only(right: 7),
                    padding:
                    EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                     decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    child: Text(
                      "$text",
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),
              if (hasExpanded == false)
                _buildContentTextPan()
              else ...[
                _buildContentTextPan(),
                TextSpan(
                  text: _expanded ? "...." : "... ",
                  style: TextStyle(
                      color: _expanded
                          ? (widget.isPost
                          ? AppColors.primaryColor
                          : Colors.transparent)
                          : Color(0xfff19a4d),
                      fontSize: 16.nsp),
                  recognizer: _expand2TapGestureRecognizer,
                ),
                if (_expanded && widget.isPost == true)
                  TextSpan(
                    text: "..",
                    style: TextStyle(
                        color: AppColors.primaryColor, fontSize: 16.nsp),
                    recognizer: _expand3TapGestureRecognizer,
                  ),
                TextSpan(
                  text: _expanded ? "收起" : "全文",
                  style: TextStyle(color: Color(0xfff19a4d), fontSize: 16.nsp),
                  recognizer: _expandTapGestureRecognizer,
                ),
              ],
            ]),
      ),
    );
  }


  TextSpan _buildContentTextPan() {
    if (_postTitle.isRich == true) {
      if (hasExpanded && !_expanded) {
        if (_postTitle.first.length >= _maxSize) {
          return TextSpan(
              text: getSubString(_postTitle.first, 0, max(_maxSize, 0)));
        } else if (_postTitle.first.length + _postTitle.txt.length >=
            _maxSize) {
          return TextSpan(
            children: [
              TextSpan(
                text: _postTitle.first,
              ),
              TextSpan(
                text: getSubString(_postTitle.txt, 0, max(_maxSize - _postTitle.first.length, 0)),
                style: TextStyle(color: Color(0xffaacaec)),
                recognizer: _linkTapGestureRecognizer,
              ),
            ],
          );
        } else {
          return TextSpan(
            children: [
              TextSpan(
                text: _postTitle.first,
              ),
              TextSpan(
                text: _postTitle.txt,
                style: TextStyle(color: Color(0xffaacaec)),
                recognizer: _linkTapGestureRecognizer,
              ),
              WidgetSpan(
                child: InkWell(
                  onTap: () => _richTextEvent(null),
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: 8,
                    height: 13,
                    child: Image.asset(
                      "assets/images/rich_search.png",
                      width: 8,
                    ),
                  ),
                ),
              ),
              TextSpan(
                text: getSubString(_postTitle.txt, 0, max(
                    _maxSize -
                        _postTitle.first.length -
                        _postTitle.txt.length,
                    0)),
                style: TextStyle(color: Color(0xffaacaec)),
                recognizer: _linkTapGestureRecognizer,
              ),
            ],
          );
        }
      } else {
        return TextSpan(children: [
          TextSpan(
            text: _postTitle.first,
          ),
          TextSpan(
            text: _postTitle.txt,
            style: TextStyle(color: Color(0xffaacaec)),
            recognizer: _linkTapGestureRecognizer,
          ),
          WidgetSpan(
            child: InkWell(
              onTap: () => _richTextEvent(null),
              child: Container(
                alignment: Alignment.topLeft,
                width: 8,
                height: 13,
                child: Image.asset(
                  "assets/images/rich_search.png",
                  width: 8,
                ),
              ),
            ),
          ),
          TextSpan(
            text: _postTitle.last,
          ),
        ]);
      }
    } else {
      if (hasExpanded) {
        return TextSpan(
          text: _expanded
              ? realVideoModel.postTitle.originTitle
              : getSubString(realVideoModel.postTitle.originTitle, 0, max(_maxSize, 0)),
        );
      } else {
        return TextSpan(
          text: realVideoModel.postTitle.originTitle,
        );
      }
    }
  }
}




