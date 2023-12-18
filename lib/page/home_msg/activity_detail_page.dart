import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/custom_network_image_new.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/tasks/multi_image_upload_task.dart';
import 'package:flutter_app/model/activity_response.dart';
import 'package:flutter_app/model/comment_model.dart';
import 'package:flutter_app/model/multi_image_model.dart';
import 'package:flutter_app/model/res/comment_list_res.dart';
import 'package:flutter_app/page/home_msg/view/activity_detail_view.dart';
import 'package:flutter_app/page/home_msg/view/chat_item_cell.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/richTextParsing/html_parser.dart';
import 'package:flutter_base/task_manager/task_manager.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ActivityDetailPage extends StatefulWidget {
  final String id;

  const ActivityDetailPage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ActivityDetailPageState();
  }
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  ActivityModel activityModel;
  bool isSending = false;
  RefreshController controller = RefreshController();
  List<CommentModel> commentList;
  int pageNumber = 1;
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      _loadUpdateData();
      await _loadData(widget.id ?? "");
      _getCommentList();
    });
  }

  void _loadUpdateData() async {
    try {
      var response = await netManager.client.getTopicUpdate(widget.id ?? "");
      debugLog(response);
    } catch (e) {
      debugLog(e);
    }
  }

  Future _loadData(String id) async {
    try {
      var response = await netManager.client.getTopicDetail(id);
      if (response is Map) {
        activityModel = ActivityModel.fromJson(response as Map<String, dynamic>);
      }
    } catch (e) {
      debugLog(e);
    }
    activityModel ??= ActivityModel()..id = widget.id;
    setState(() {});
  }

  Future _getCommentList({int page = 1, int size = 10}) async {
    String objID = activityModel?.id ?? "";
    String curTime = DateTimeUtil.format2utc(DateTime.now()) ?? "";
    try {
      CommentListRes commentListRes = await netManager.client.getCommentList(objID, curTime, page, size, objType: 1);
      commentList ??= [];
      pageNumber = page;
      if (page == 1) {
        commentList.clear();
      }
      if (commentListRes.hasNext ?? false) {
        controller.loadComplete();
      } else {
        controller.loadNoData();
      }
      commentList.addAll(commentListRes?.list ?? []);
      _handleMessageTimeDesc();
      setState(() {});
    } catch (e) {
      debugLog('getCommentList= ${e.toString()}');
      controller.loadComplete();
    }
    commentList ??= [];
    setState(() {});
  }

  void _handleMessageTimeDesc() {
    CommentModel preModel;
    for (int i = 0; i < (commentList?.length ?? 0); i++) {
      var model = commentList[i];
      model.createAtDesc ??= DateTimeUtil.utc4iso(model.createdAt);
      if (model.isShowTime == null) {
        if (model.createAtDesc == preModel?.createAtDesc) {
          model.isShowTime = false;
        } else {
          model.isShowTime = true;
        }
      }
      preModel = model;
    }
  }

  void _selectedImage() async {
    try {
      List<Media> mediaList = await ImagePickers.pickerPaths(
        uiConfig: UIConfig(uiThemeColor: AppColors.primaryColor),
        selectCount: 1,
        showCamera: false,
        cropConfig: CropConfig(enableCrop: false),
      );

      List<String> imagePaths = [];
      for (Media assetEntity in mediaList) {
        imagePaths.add(assetEntity.path);
      }
      if (imagePaths.isEmpty) {
        showToast(msg: "请选择图片");
        return;
      }
      _sendComment(imagePath: imagePaths.first);
    } catch (e) {
      l.e("pickImages-e", "$e");
    }
  }

  ///发表评论
  void _sendComment({String content, String imagePath}) async {
    String objID = activityModel?.id;
    int level = 1;
    try {
      isSending = true;
      setState(() {});
      _focusNode.unfocus();
      String imageUrl;
      if (imagePath?.isNotEmpty == true) {
        MultiImageModel multiImageModel = await taskManager.addTaskToQueue(MultiImageUploadTask([imagePath]));
        if (multiImageModel.filePath?.isNotEmpty != true) {
          isSending = false;
          setState(() {});
          showToast(msg: "图片上传失败");
          return;
        }
        imageUrl = multiImageModel.filePath.first;
      }
      CommentModel commentModel;
      if (imageUrl?.isNotEmpty == true) {
        commentModel = await netManager.client.sendComment(objID, level, "", objType: 1, image: imageUrl);
      } else {
        commentModel = await netManager.client.sendComment(objID, level, content, objType: 1);
      }
      commentList.insert(0, commentModel);
      if (content?.isNotEmpty == true) {
        _textEditingController.text = "";
      }
      _handleMessageTimeDesc();
      setState(() {});
    }  on DioError catch (e) {
      if(e.error is ApiException){
        showToast(msg: (e.error as ApiException).message?.toString() ?? "");
      }else {
        showToast(msg: e.toString());
      }
    }catch (e) {
      showToast(msg: e.toString());
    }
    isSending = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCommonAppBar(
        "",
        titleWidget: Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: CustomNetworkImageNew(
                width: 30,
                height: 30,
                imageUrl: activityModel?.publisher?.portrait ?? "",
                radius: 15,
              ),
            ),
            SizedBox(width: 6),
            Text(
              activityModel?.publisher?.name ?? "",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildContent()),
          _buildBottomMenu(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (activityModel == null) {
      return LoadingCenterWidget();
    } else if (activityModel?.id == null) {
      return CErrorWidget(
        "暂无数据",
        retryOnTap: () {
          activityModel = null;
          setState(() {});
          _loadData(widget.id ?? "");
        },
      );
    } else {
      return pullYsRefresh(
          refreshController: controller,
          enablePullDown: false,
          onLoading: () => _getCommentList(page: pageNumber + 1),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ActivityDetailView(activityModel: activityModel),
              ),
              _buildCommentView(),
            ],
          ));
    }
  }

  Widget _buildCommentView() {
    if (commentList == null) {
      return SliverToBoxAdapter(
        child: Container(
          height: 300,
          child: LoadingCenterWidget(),
        ),
      );
    } else if (commentList.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: 300,
          child: CErrorWidget(
            "暂无评论数据",
            retryOnTap: () {
              commentList = null;
              setState(() {});
              _getCommentList();
            },
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ChatItemCell(
            model: commentList[index],
          );
        },
        childCount: commentList?.length ?? 0,
      ),
    );
  }

  Widget _buildBottomMenu() {
    return Container(
      height: 83,
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
            onTap: _selectedImage,
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              height: 66,
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
                maxLines: 1,
                maxLength: 120,
                buildCounter: (_, {currentLength, maxLength, isFocused}) => Container(
                  height: 20,
                  alignment: Alignment.centerRight,
                  child: Text(
                    currentLength.toString() + "/" + maxLength.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                style: TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  fillColor: Color.fromRGBO(44, 44, 44, 1),
                  hintText: "请输入内容",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                  contentPadding: EdgeInsets.fromLTRB(10, 10, 5, 10),
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
              if (_textEditingController.text.isEmpty) {
                showToast(msg: "请输入内容");
                return;
              }
              _sendComment(content: _textEditingController.text);
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
    );
  }
}
