import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/tasks/multi_image_upload_task.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/multi_image_model.dart';
import 'package:flutter_app/new_page/recharge/recharge_gold_page.dart';
import 'package:flutter_app/new_page/recharge/recharge_vip_page.dart';
import 'package:flutter_app/new_page/welfare/SpecialWelfareHomePage.dart';
import 'package:flutter_app/page/anwang_trade/widget/double_btn_view.dart';
import 'package:flutter_app/page/bigImageSee/BIgImageVIewPage.dart';
import 'package:flutter_app/weibo_page/message/message_detail/MessageDetails.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/bubble_ui.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:image_pickers/image_pickers.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';

import '../message_list_entity.dart';

///消息详情UI
class MessageDetailPage extends StatefulWidget {
  final MessageListDataList _messageListDataList;

  MessageDetailPage(this._messageListDataList);

  @override
  State<StatefulWidget> createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  TextEditingController _textEditingController = new TextEditingController();
  StreamController<List<ListElement>> _listViewStreamController = StreamController.broadcast();
  RefreshController _refreshController = RefreshController();
  FocusNode _focusNode = new FocusNode();
  ScrollController _scrollController = ScrollController();

  int _pageNumber = 1;
  final int _pageSize = 15;
  List<ListElement> _messageList = [];

  var _inputText = '';
  bool _isClear = false;
  bool _isEmptyMessage = false;
  bool _isDataReq = true;
  List<String> remotePIcList;

  @override
  void initState() {
    super.initState();
    _refreshData();
    _inputText = _textEditingController?.text ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController?.clear();
    _textEditingController?.dispose();
    _focusNode?.dispose();
    _listViewStreamController?.close();
    _refreshController?.dispose();
    _scrollController?.dispose();
  }

  ///刷新数据
  void _refreshData() async {
    _pageNumber = 1;
    _isDataReq = true;
    _initData();
  }

  ///加载更多数据
  void _loadMoreData() async {
    l.e("_loadMoreData", "执行加载更多");
    if (_pageNumber * _pageSize <= _messageList?.length) {
      _pageNumber = _pageNumber + 1;
      _initData();
    } else {
      _refreshController?.loadNoData();
      setState(() {});
    }
  }

  ///请求数据
  void _initData() async {
    try {
      l.e("_initData", "请求数据");
      dynamic messageDetail = await netManager.client.getMessageDetail(_pageNumber, _pageSize, widget._messageListDataList?.sessionId);

      Data messageDetailData = Data.fromJson(messageDetail);
      _isDataReq = false;
      if ((messageDetailData?.list ?? []).isNotEmpty) {
        if (_pageNumber == 1) {
          _messageList.clear();
        }
        _messageList.addAll(messageDetailData?.list);

        //判断是否还有数据
        if (!(messageDetailData?.hasNext ?? false) && _pageNumber == 1) {
          _refreshController?.loadNoData();
        } else {
          _refreshController?.loadComplete();
        }
      } else {
        if (_pageNumber == 1) {
          _isEmptyMessage = true;
        } else {
          _refreshController?.loadNoData();
        }
      }
    } catch (e) {
      l.e("加载消息列表-error:", "$e");
      _refreshController?.loadFailed();
    }
    setState(() {});
  }

  bool isSending = false;

  ///发送私信-手动添加数据
  void _sendMessage() async {
    try {
      if (_textEditingController?.text == null || _textEditingController?.text == "") {
        showToast(msg: "请输入内容~");
        return;
      }
      if (isSending) return;
      isSending = true;
      setState(() {});
      await netManager.client.sendMessage(widget._messageListDataList?.userId, _textEditingController?.text);

      _messageList?.insert(
          0,
          new ListElement(
            sendUid: GlobalStore.getMe().uid,
            takeUid: widget._messageListDataList?.takeUid,
            content: _textEditingController?.text,
            sendAvatar: GlobalStore.getMe().portrait,
          ));

      _textEditingController?.clear();
      _listViewStreamController?.add(_messageList);

      if (_isEmptyMessage) {
        setState(() {});
        _isEmptyMessage = false;
      }

      ///回到新对话插入位置-底部
      Future.delayed(Duration(milliseconds: 300)).then((value) => _scrollController?.jumpTo(_scrollController?.position?.minScrollExtent));
    } on DioError catch (e) {
      var error = e.error;
      if (error is ApiException) {
        if (error.code == 8000) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return DoubleBtnDialogView(
                  title: "提示",
                  content: "金币不足,请先充值",
                  leftBtnText: "前往充值",
                  rightBtnText: "取消",
                  leftCallback: () async {
                    Gets.Get.to(RechargeGoldPage());
                  },
                );
              });
        }
      }

      l.e('postBuyNovel=', e.toString());
    } finally {
      isSending = false;
      setState(() {});
    }
  }

  ///发送私信-图片数据
  void _sendImageMessage() async {
    try {
      if (remotePIcList.isEmpty) {
        showToast(msg: "请选择图片~");
        return;
      }
      if (isSending) return;
      isSending = true;
      if (mounted) {
        setState(() {});
      }

      await netManager.client.sendImageMessage(widget._messageListDataList?.userId, remotePIcList);

      _textEditingController?.clear();
      _listViewStreamController?.add(_messageList);

      if (_isEmptyMessage) {
        setState(() {});
        _isEmptyMessage = false;
      }

      ///回到新对话插入位置-底部
      Future.delayed(Duration(milliseconds: 300)).then((value) => _scrollController?.jumpTo(_scrollController?.position?.minScrollExtent));
    } on DioError catch (e) {
      var error = e.error;
      if (error is ApiException && mounted) {
        if (error.code == 8000) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return DoubleBtnDialogView(
                  title: "提示",
                  content: "金币不足,请先充值",
                  leftBtnText: "前往充值",
                  rightBtnText: "做任务得VIP",
                  leftCallback: () async {
                    Gets.Get.to(RechargeGoldPage());
                  },
                  rightCallback: () {
                    //进入任务中心
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return SpecailWelfareViewTaskPage();
                    }));
                  },
                );
              });
        }
      }
      l.e('postBuyNovel=', e.toString());
    } finally {
      isSending = false;
    }
    if (mounted) {
      setState(() {});
    }
  }

  ///选择图片
  Future<List<String>> _pickImg(int needCount) async {
    try {
      List<Media> mediaList = await ImagePickers.pickerPaths(
        uiConfig: UIConfig(uiThemeColor: AppColors.primaryColor),
        selectCount: needCount,
        showCamera: false,
        cropConfig: CropConfig(enableCrop: false),
      );

      List<String> imagePaths = [];
      for (Media assetEntity in mediaList) {
        imagePaths.add(assetEntity.path);
      }
      return imagePaths ?? [];
    } catch (e) {
      l.e("pickImages-e", "$e");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Theme(
        data: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColors.weiboBackgroundColor),
        ),
        child: Scaffold(
          backgroundColor: AppColors.weiboBackgroundColor,
          appBar: AppBar(
            title: Text(
              widget._messageListDataList?.userName ?? "",
              style: TextStyle(color: Colors.white, fontSize: 20.w),
            ),
            centerTitle: true,
            backgroundColor: AppColors.weiboBackgroundColor,
            // actions: [
            //   Padding(
            //     padding: EdgeInsets.only(right: 14.w),
            //     child: GestureDetector(
            //       onTap: () {
            //         Map<String, dynamic> map = {
            //           // 'uid': widget._messageListDataList?.sendUid,
            //           'uid': widget._messageListDataList?.userId,
            //           'uniqueId': DateTime.now().toIso8601String(),
            //         };
            //         Gets.Get.to(() => BloggerPage(map), opaque: false);
            //       },
            //       child: UnconstrainedBox(
            //         child: SizedBox(
            //           width: 32.w,
            //           height: 32.w,
            //           child: ClipOval(
            //             child: CustomNetworkImage(
            //               fit: BoxFit.cover,
            //               width: 32.w,
            //               height: 32.w,
            //               //imageUrl: path.join(Address.baseImagePath, widget.messageListDataList.userAvatar),
            //               //imageUrl: "https://lh3.googleusercontent.com/600PPKMP-KL6EYfzdRj0KdD9p1nEXRYszSZvMG8H22rPSVJL_HOPM5zzBWVNCtXcVPZnjjCMf3wp5eoNRXG8msUQQADciCJAc3ifQBuuVgbtGw=w1200-h630-rj-pp-e365",
            //               imageUrl: widget._messageListDataList.userAvatar,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   )
            // ],
          ),
          body: (_isDataReq ?? false)
              ? LoadingWidget()
              : (_messageList ?? []).isEmpty
                  ? CErrorWidget("没有消息哦～")
                  : Container(
                      margin: EdgeInsets.only(bottom: 84.w),
                      child: StreamBuilder<List<ListElement>>(
                        initialData: _messageList,
                        stream: _listViewStreamController?.stream,
                        builder: (context, snapshot) {
                          return pullYsRefresh(
                            refreshController: _refreshController,
                            enablePullUp: true,
                            enablePullDown: false,
                            onLoading: () => _loadMoreData(),
                            cusFooter: ClassicFooter(
                              loadingText: Lang.LOADING,
                              canLoadingText: Lang.RELEASE_LOAD_MORE,
                              noDataText: _pageNumber > 1 ? "沒有更多消息了" : "",
                              idleText: "下拉加载更多消息",
                              failedText: Lang.LOADING_FAILED,
                              textStyle: TextStyle(
                                  color: AppColors.userPayTextColor,
                                  fontSize: AppFontSize.fontSize14,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal),
                            ),
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: _messageList?.length ?? 0,
                              reverse: true,
                              itemBuilder: (context, index) {
                                if ((_messageList ?? []).isEmpty) {
                                  return Container();
                                }

                                ///是否我的发言
                                bool isMine = _messageList[index]?.sendUid == GlobalStore.getMe().uid;
                                String content = _messageList[index]?.content;
                                String imageUrl;
                                if (_messageList[index]?.imgUrl != null && _messageList[index].imgUrl.length > 0) {
                                  imageUrl = _messageList[index]?.imgUrl[0];
                                }
                                String localUrl = _messageList[index]?.localUrl;
                                return isMine
                                    ? _buildMessageRightItemUI(
                                        content, imageUrl, localUrl, _messageList[index].sendAvatar, _messageList[index].sendUid)
                                    : _buildMessageLeftItemUI(
                                        content, imageUrl, localUrl, _messageList[index].sendAvatar, _messageList[index].sendUid);
                              },
                            ),
                          );
                        },
                      ),
                    ),
          bottomSheet: Container(
            height: 83.w,
            color: Color.fromRGBO(31, 31, 31, 1),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 22),
                    child: isSending
                        ? SizedBox(
                      width: 32,
                      height: 32,
                      child: CupertinoTheme(
                        data: CupertinoThemeData(brightness: Brightness.dark),
                        child: CupertinoActivityIndicator(),
                      ),
                    )
                        : Image.asset(
                      "assets/weibo/icon_msg_select_imag.png",
                      width: 32,
                      height: 32,
                    ),
                  ),
                  onTap: () async {
                    var list = await _pickImg(1);
                    _messageList?.insert(
                      0,
                      new ListElement(
                          sendUid: GlobalStore.getMe().uid, takeUid: widget._messageListDataList?.takeUid, imgUrl: null, localUrl: list[0]),
                    );
                    setState(() {});

                    ///上传多张图片
                    MultiImageModel multiImageModel =
                    await taskManager.addTaskToQueue(MultiImageUploadTask(list), (progress, {msg, isSuccess}) {});
                    remotePIcList = multiImageModel.filePath;
                    _sendImageMessage();
                  },
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Container(
                    //margin: EdgeInsets.only(top: Dimens.pt10, right: Dimens.pt10,),
                    //constraints: BoxConstraints(maxHeight: 30.w,minHeight: 30.w),
                    alignment: Alignment.centerLeft,
                    height: 66.w,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      autocorrect: true,
                      onTap: () {},
                      textInputAction: TextInputAction.done,
                      cursorColor: Colors.white,
                      textAlign: TextAlign.left,
                      controller: _textEditingController,
                      focusNode: _focusNode,
                      onChanged: (text) {},
                      onSubmitted: (text) {
                        _sendMessage();
                      },
                      maxLines: 1,
                      maxLength: 120,
                      buildCounter: (_, {currentLength, maxLength, isFocused}) => Container(
                        height: 20.w,
                        alignment: Alignment.centerRight,
                        child: Text(
                          "",//currentLength.toString() + "/" + maxLength.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 12.w),
                        ),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 16.w),
                      decoration: InputDecoration(
                        fillColor: Color.fromRGBO(44, 44, 44, 1),
                        hintText: "请输入内容【本次私信需要消费${Config.sendMsgPrice}金币】",
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10),
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 5, 10),

                        ///EdgeInsets.symmetric(vertical:2,horizontal: 10), //EdgeInsets.fromLTRB(10, 16, 10, 2), //EdgeInsets.symmetric(vertical:-16,horizontal: 10),
                        filled: true,
                        isCollapsed: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(44, 44, 44, 1)), borderRadius: BorderRadius.circular(26)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(44, 44, 44, 1)),
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    _sendMessage();
                    //focusNode.requestFocus();
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 22),
                    child: isSending
                        ? SizedBox(
                            width: 32,
                            height: 32,
                            child: CupertinoTheme(
                              data: CupertinoThemeData(brightness: Brightness.dark),
                              child: CupertinoActivityIndicator(),
                            ),
                          )
                        : Image.asset(
                            "assets/weibo/images/icon_send_comment_two.png",
                            width: 32,
                            height: 32,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///私信列表 UI-其他人的发言
Widget _buildMessageLeftItemUI(String content, String imageUrl, String localUrl, String headImage, int userId) => Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.only(bottom: 29.w, left: 16.w, right: 16.w),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          child: SizedBox(
            width: 40.w,
            height: 40.w,
            child: ClipOval(
              child: CustomNetworkImage(
                fit: BoxFit.cover,
                width: 40.w,
                height: 40.w,
                imageUrl: headImage,
              ),
            ),
          ),
          onTap: () {
            Map<String, dynamic> arguments = {
              'uid': userId,
              'uniqueId': DateTime.now().toIso8601String(),
            };
            Gets.Get.to(() => BloggerPage(arguments), opaque: false);
          },
        ),
        SizedBox(width: 2),
        Flexible(
          child: Bubble(
            borderRadius: (content == null || content == "") ? Radius.circular(4) : Radius.circular(12),
            padding: (content?.isNotEmpty == true)
                ? EdgeInsets.fromLTRB(14, 8, 14, 8)
                : EdgeInsets.fromLTRB(14, 0, 14, 8),
            color: content?.isNotEmpty == true ? Color(0xff333333) : Colors.transparent,
            direction: BubbleDirection.left,
            child: (content?.isNotEmpty != true)
                ? GestureDetector(
                    child: Container(
                      width: 260,
                      child: (localUrl == null || localUrl == "")
                          ? CachedNetworkImage(
                              imageUrl: path.join(Address.baseImagePath ?? '', imageUrl),
                              fit: BoxFit.fitWidth,
                              cacheManager: ImageCacheManager(),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.file(
                                File(localUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    onTap: () {
                      Gets.Get.to(() => BigImageViewPage(imageUrl: imageUrl), opaque: false);
                    },
                  )
                : Text(
                    content ?? "",
                    softWrap: true,
                    maxLines: 100,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
          ),
        ),
      ],
    ),);

///私信列表 UI- 我的发言
Widget _buildMessageRightItemUI(String content, String imageUrl, String localUrl, String headImage, int userId) => Container(
    alignment: Alignment.centerRight,
    margin: EdgeInsets.only(bottom: 29.w, left: 16.w, right: 16.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Bubble(
            borderRadius: (content == null || content == "") ? Radius.circular(4) : Radius.circular(12),
            padding: (content?.isNotEmpty == true)
                ? EdgeInsets.fromLTRB(14, 8, 14, 8)
                : EdgeInsets.fromLTRB(14, 0, 14, 8),
            color: AppColors.primaryTextColor,
            direction: BubbleDirection.right,
            child: (content == null || content == "")
                ? GestureDetector(
              onTap: () {
                // List<String> imageNetList = [];
                // imageNetList.add(path.join(
                //     Address.baseImagePath ?? '',
                //     imageUrl),);
                // List<String> imageLocalList = [];
                // imageLocalList.add(localUrl);
                // ImagePickers.previewImages((localUrl==null||localUrl=="")?imageNetList:imageLocalList, 0);
                // ImagePickers.previewImages(imageNetList,0);
                Gets.Get.to(() => BigImageViewPage(imageUrl: imageUrl), opaque: false);
              },
              child: Container(
                width: 260,
                child: (localUrl == null || localUrl == "")
                    ? CachedNetworkImage(
                  imageUrl: path.join(Address.baseImagePath ?? '', imageUrl),
                  fit: BoxFit.fitWidth,
                  cacheManager: ImageCacheManager(),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.file(
                    File(localUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
                : Text(
              content ?? "",
              softWrap: true,
              maxLines: 100,
              style: TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
            ),
          ),
        ),
        SizedBox(width: 2),
        GestureDetector(
          child: SizedBox(
            width: 40.w,
            height: 40.w,
            child: ClipOval(
              child: CustomNetworkImage(
                fit: BoxFit.cover,
                width: 40.w,
                height: 40.w,
                imageUrl: headImage,
              ),
            ),
          ),
          onTap: () {
            Map<String, dynamic> arguments = {
              'uid': userId,
              'uniqueId': DateTime.now().toIso8601String(),
            };
            Gets.Get.to(() => BloggerPage(arguments), opaque: false);
          },
        ),
      ],
    ),
);
