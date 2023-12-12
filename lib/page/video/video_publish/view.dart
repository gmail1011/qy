import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/search/PostModuleModel.dart';
import 'package:flutter_app/page/hjll_community/hjll_post_community/HjllPostSelectModulePage.dart';
import 'package:flutter_app/page/video/video_publish/draw_left_widget.dart';
import 'package:flutter_app/page/video/video_publish/rule/RulePage.dart';
import 'package:flutter_app/page/video/video_publish/select_tags/SelecteTagsPage.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/custom_picture_management.dart';
import 'package:flutter_app/widget/custom_video_management.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;

import 'action.dart';
import 'state.dart';

Widget buildView(VideoAndPicturePublishState state, Dispatch dispatch, ViewService viewService) {
  return KeyboardDismissOnTap(
    child: WillPopScope(
      // onWillPop: () => dispatch(VideoPublishActionCreator.onPop()),
      child: Theme(
        //data: Theme.of(viewService.context).copyWith(canvasColor: AppColors.weiboJianPrimaryBackground),
        data: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          primaryColor: AppColors.weiboBackgroundColor,
          backgroundColor: AppColors.weiboBackgroundColor,
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColors.weiboBackgroundColor),
        ),
        child: Scaffold(
          backgroundColor: AppColors.weiboBackgroundColor,
          resizeToAvoidBottomInset: false,
          appBar: getCommonAppBar(
              // state.uploadType == UploadType.UPLOAD_IMG
              //     ? Lang.GRAPHIC
              //     : Lang.VIDEO,
              "发布帖子",
              centerTitle: true,
              onBack: () => dispatch(VideoPublishActionCreator.onPop()),
              actions: [
                Container(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      if (state.pageType == 0) {
                        dispatch(VideoPublishActionCreator.onUploadPicture(state.taskID));
                      } else if (state.pageType == 1) {
                        dispatch(VideoPublishActionCreator.onUploadVideo(state.taskID));
                      } else {
                        dispatch(VideoPublishActionCreator.onUploadPictureAndText(state.taskID));
                      }
                    },
                    child: Container(
                      width: 48,
                      height: 28,
                      margin: EdgeInsets.only(right: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryTextColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        "发布",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(viewService.context).requestFocus(FocusNode()),
            child: SingleChildScrollView(
              controller: state.scrollController,
              child: Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 100.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Gets.Get.to(() => HjllPostSelectModuelPage(), opaque: false).then((value) {
                          PostModuleModel postModuleModel = value;
                          dispatch(VideoPublishActionCreator.setPostModule(postModuleModel));
                        });
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xff202020),
                        ),
                        child: Row(
                          children: [
                            state.postModuleModel == null
                                ? Text("#选择 帖子模版", style: TextStyle(color: Colors.white))
                                : Text(
                                    "#${state.postModuleModel.name}",
                                    style: TextStyle(color: Color.fromRGBO(145, 151, 157, 1)),
                                  ),
                            Expanded(child: SizedBox()),
                            Image.asset(
                              "assets/images/right_arrow.png",
                              width: 19,
                              height: 19,
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xff202020),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextField(
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white, fontSize: Dimens.pt14),
                        maxLines: 1,
                        controller: state.textTitleController,
                        decoration: InputDecoration(
                          hintText: "请填写标题",
                          border: InputBorder.none,
                          counterStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(145, 151, 157, 1),
                          ),
                        ),
                      ),
                    ),
                    state.pageType != 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 11,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff202020),
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                                padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 6),
                                width: screen.screenWidth,
                                height: 150.w,
                                child: TextField(
                                  cursorColor: Colors.white,
                                  style: TextStyle(color: Colors.white, fontSize: Dimens.pt14),
                                  maxLength: 500,
                                  maxLines: 7,
                                  controller: state.textController,
                                  decoration: InputDecoration(
                                    hintText: "请输入内容",
                                    border: InputBorder.none,
                                    counter: SizedBox(),
                                    counterText: '500',
                                    //隐藏最大显示
                                    counterStyle: TextStyle(color: Color.fromRGBO(93, 100, 114, 1)),
                                    hintStyle: TextStyle(
                                      color: Color.fromRGBO(93, 100, 114, 1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                    state.uploadType == UploadType.UPLOAD_VIDEO
                        ? (Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 11,
                              ),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xff202020),
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.white,
                                  style: TextStyle(color: Colors.white, fontSize: Dimens.pt14),
                                  maxLines: 1,
                                  controller: state.textMoneyController,
                                  decoration: InputDecoration(
                                    hintText: "请设置解锁价格0~999金币，不设置则免费",
                                    border: InputBorder.none,
                                    counterStyle: TextStyle(color: Color.fromRGBO(93, 100, 114, 1)),
                                    hintStyle: TextStyle(
                                      color: Color.fromRGBO(93, 100, 114, 1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ))
                        : SizedBox(),
                    SizedBox(
                      height: 11,
                    ),
                    state.pageType != 1
                        ? PictureMangeWidget(
                            videoPath: state.uploadModel.videoLocalPath,
                            picList: state.uploadModel.localPicList,
                            uploadType: state.uploadType,
                            deleteItemCallback: (index) => dispatch(VideoPublishActionCreator.onDeleteItem(index)),
                            addItemCallback: () => dispatch(VideoPublishActionCreator.onSelectPicAndVideo()),
                            onSelectCover: () => dispatch(VideoPublishActionCreator.onSelectCover()),
                          )
                        : VideoUploadMangeWidget(
                            ///视频 图片弹框
                            videoPath: state.uploadModel.videoLocalPath,
                            videoCover: state.videoCover,
                            picList: state.uploadModel.localPicList,
                            uploadType: UploadType.UPLOAD_VIDEO,
                            deleteItemCallback: (index) => dispatch(VideoPublishActionCreator.onDeleteItem(index)),
                            deleteCoverCallback: (index) => dispatch(VideoPublishActionCreator.onDeleteVideoPicture(index)),
                            addItemCallback: () => dispatch(VideoPublishActionCreator.onSelectPicAndVideo()),
                            onSelectCover: () => dispatch(VideoPublishActionCreator.onSelectCover()),
                          ),

                    SizedBox(
                      height: 16.w,
                    ),

                    SizedBox(
                      height: 27.w,
                    ),

                    //_getFunctionList(),

                    // _getTagArea(),

                    // Expanded(child: Container())
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
