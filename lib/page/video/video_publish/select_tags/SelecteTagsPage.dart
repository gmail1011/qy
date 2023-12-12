import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/search/search_view/search_appbar.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_topic_entity.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SelectTags extends StatefulWidget {
  List<SearchTopicDataList> checkSelectListTemp = [];

  SelectTags(this.checkSelectListTemp);

  @override
  State<StatefulWidget> createState() {
    return SelectTagsStatee();
  }
}

class SelectTagsBean {
  int index = -1;
  bool isSelected = false;
}

class SelectTagsStatee extends State<SelectTags> {
  TextEditingController textEditingController =
      new TextEditingController(text: "");

  List<SearchTopicDataList> checkSelectList = [];

  GlobalKey<SelectTagsStatee> navigatorKey = new GlobalKey<SelectTagsStatee>();

  int pageNumber = 1;
  int pageResultNumber = 1;
  int pageSize = 20;

  //PublishTagModel publishTagModel;

  SearchTopicData searchBeanData;
  SearchTopicData searchBeanDataResult;

  RefreshController refreshController = new RefreshController();
  RefreshController refreshResultController = new RefreshController();

  bool isSearchResult = false;

  @override
  void initState() {
    super.initState();

    if (widget.checkSelectListTemp.length != 0) {
      checkSelectList.addAll(widget.checkSelectListTemp);
      checkSelectList = checkSelectList?.toSet()?.toList();
    }

    initData();

    textEditingController.addListener(() {
      if (textEditingController.value.text == null ||
          textEditingController.value.text == "") {
        isSearchResult = false;

        ///全部设置为false
        searchBeanData?.xList?.forEach((element) {
          element?.isSelected = false;
        });
        ///重新判断设置
        checkSelectList?.forEach((element1) {
          searchBeanData?.xList?.forEach((element) {
            if (element?.name == element1?.name) {
              element?.isSelected = true;
            }
          });
        });

        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    refreshResultController?.dispose();
    refreshController?.dispose();
    textEditingController?.dispose();
    super.dispose();
  }

  void initData() async {
    List<String> keywords = [""];

    dynamic tags = await netManager.client
        .getSearchDataNew(pageNumber, pageSize, keywords, "tag");

    SearchTopicData searchBeanData1 = SearchTopicData().fromJson(tags);

    if (pageNumber == 1) {
      searchBeanData = searchBeanData1;
    } else {
      searchBeanData.xList.addAll(searchBeanData1.xList);
    }

    if (searchBeanData1.hasNext) {
      refreshController.loadComplete();
    } else {
      refreshController.loadNoData();
    }

    searchBeanData?.xList?.forEach((element) {
      checkSelectList?.forEach((element1) {
        if (element?.name == element1?.name) {
          element?.isSelected = true;
        }
      });
    });
    setState(() {});
  }

  void searchTags() async {
    isSearchResult = true;

    List<String> keywords = [textEditingController.text];

    dynamic tags = await netManager.client
        .getSearchDataNew(pageResultNumber, pageSize, keywords, "tag");

    SearchTopicData searchBeanData1 = SearchTopicData().fromJson(tags);

    if (pageResultNumber == 1) {
      searchBeanDataResult = searchBeanData1;
    } else {
      searchBeanDataResult?.xList?.addAll(searchBeanData1.xList);
    }

    if (searchBeanData1.hasNext) {
      refreshResultController?.loadComplete();
    } else {
      refreshResultController?.loadNoData();
    }

    searchBeanDataResult?.xList?.forEach((element) {
      checkSelectList?.forEach((element1) {
        if (element?.name == element1?.name) {
          element?.isSelected = true;
        }
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(checkSelectList);
          return true;
        },
        child: Theme(
          data: ThemeData(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            primaryColor: AppColors.weiboJianPrimaryBackground,
            backgroundColor: AppColors.weiboJianPrimaryBackground,
            buttonColor: AppColors.weiboJianPrimaryBackground,
            bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: AppColors.weiboBackgroundColor),
          ),
          child: Scaffold(
              backgroundColor: AppColors.weiboBackgroundColor,
              resizeToAvoidBottomInset: false,
              appBar: SearchAppBar(
                isSearchBtn: true,
                controller: textEditingController,
                autofocus: false,
                onSubmitted: (values) {
                  searchTags();
                },
                onBackPressed: () {
                  Navigator.of(context).pop(checkSelectList);
                },
              ),
              bottomSheet: Container(
                width: screen.screenWidth,
                height: 100.w,
                color: AppColors.weiboBackgroundColor,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(checkSelectList);
                  },
                  child: Container(
                      margin: EdgeInsets.only(
                        left: 95.w,
                        right: 95.w,
                      ),
                      child: Image.asset(
                        "assets/weibo/button_confirm.png",
                        width: 228.w,
                        height: 44.w,
                      )),
                ),
              ),
              body: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Offstage(
                    offstage: checkSelectList?.length == 0 ? true : false,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 41.w,
                        maxWidth:
                            (126 * (checkSelectList?.length ?? 0)).toDouble(),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 16.w, right: 16.w, bottom: 14.w, top: 22.w),
                        height: 41.w,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: checkSelectList?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 41.w,
                              width: 110.w,
                              margin: EdgeInsets.only(
                                right: 5.w,
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(126, 160, 190, 0.05),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "#" + checkSelectList[index].name,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 13.w),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (isSearchResult) {
                                        searchBeanDataResult?.xList
                                            ?.forEach((element) {
                                          if (element.id ==
                                              checkSelectList[index].id) {
                                            element.isSelected = false;
                                          }
                                        });
                                      } else {
                                        searchBeanData?.xList
                                            ?.forEach((element) {
                                          if (element.id ==
                                              checkSelectList[index].id) {
                                            element.isSelected = false;
                                          }
                                        });
                                      }

                                      ///判断不选中以后，最后移除
                                      checkSelectList.removeAt(index);
                                      setState(() {});
                                    },
                                    child: Image.asset(
                                      "assets/weibo/close.png",
                                      width: 22.w,
                                      height: 22.w,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  searchBeanData == null
                      ? Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                            top: 160,
                          ),
                          child: LoadingWidget(),
                        )
                      : Expanded(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 100.w),
                            child: !isSearchResult
                                ? _buildSearchTagsListViewUI()
                                : _builTagsResultListViewUI(),
                          ),
                        ),
                ],
              )),
        ),
      ),
    );
  }

  ///创建Tags结果列表UI
  _builTagsResultListViewUI() {
    return pullYsRefresh(
      refreshController: refreshResultController,
      enablePullDown: false,
      onRefresh: () {
        //pageNumber = 1;
        //initData();
      },
      onLoading: () {
        pageResultNumber += 1;
        searchTags();
      },
      child: ListView.builder(
        itemCount: searchBeanDataResult?.xList?.length ?? 0,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              bool isSelected =
                  !(searchBeanDataResult.xList[index].isSelected ?? false);
              if (checkSelectList.length >= 5 &&
                  !searchBeanDataResult.xList[index].isSelected) {
                showToast(msg: "最多选择5个标签");
              } else {
                searchBeanDataResult.xList[index].isSelected = isSelected;
                if (!isSelected) {
                  checkSelectList.removeWhere((element) =>
                      element.id == searchBeanDataResult.xList[index].id);
                } else {
                  if (checkSelectList.length >= 5) {
                    showToast(msg: "最多选择5个标签");
                  } else {
                    checkSelectList.add(searchBeanDataResult.xList[index]);
                  }
                }
                setState(() {});
              }
            },
            child: Container(
              color: Colors.transparent,
              margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 14.w),
              child: Row(
                children: [
                  Container(
                    height: 64.w,
                    width: 64.w,
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                      child: CustomNetworkImage(
                        fit: BoxFit.cover,
                        height: 64.w,
                        width: 64.w,
                        imageUrl: searchBeanDataResult.xList[index].coverImg,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 7.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "#" + searchBeanDataResult.xList[index].name,
                        style: TextStyle(color: Colors.white, fontSize: 17.w),
                      ),
                      SizedBox(
                        height: 13.w,
                      ),
                      Text(
                        "话题总播放次数：${getShowFansCountStr(searchBeanDataResult?.xList[index]?.playCount ?? 0)}",
                        style: TextStyle(
                            color: Color.fromRGBO(124, 135, 159, 1),
                            fontSize: 13.w),
                      ),
                    ],
                  ),
                  Spacer(),
                  Theme(
                    data: ThemeData(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      primaryColor: AppColors.weiboJianPrimaryBackground,
                      backgroundColor: AppColors.weiboJianPrimaryBackground,
                    ),
                    child: GFCheckbox(
                      // key: keyList[index],
                      onChanged: (value) {
                        if (checkSelectList.length >= 5 &&
                            !searchBeanDataResult.xList[index].isSelected) {
                          showToast(msg: "最多选择5个标签");
                        } else {
                          searchBeanDataResult.xList[index].isSelected = value;
                          if (!value) {
                            //checkSelectList.remove(searchBeanDataResult.xList[index]);

                            checkSelectList.removeWhere((element) =>
                                element.id ==
                                searchBeanDataResult.xList[index].id);
                          } else {
                            if (checkSelectList.length >= 5) {
                              showToast(msg: "最多选择5个标签");
                            } else {
                              checkSelectList
                                  .add(searchBeanDataResult.xList[index]);
                            }
                          }
                          setState(() {});
                        }
                      },
                      type: GFCheckboxType.circle,
                      value: searchBeanDataResult.xList[index].isSelected,
                      size: GFSize.SMALL,
                      activeBorderColor: Colors.black,
                      activeBgColor: AppColors.weiboColor,
                      inactiveBgColor: AppColors.weiboJianPrimaryBackground,
                      inactiveBorderColor: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ///创建列表UI
  _buildSearchTagsListViewUI() {
    return pullYsRefresh(
      refreshController: refreshController,
      enablePullDown: false,
      onRefresh: () {
        //pageNumber = 1;
        //initData();
      },
      onLoading: () {
        pageNumber += 1;
        initData();
      },
      child: ListView.builder(
        itemCount: searchBeanData?.xList?.length ?? 0,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              bool isSelected =
                  !(searchBeanData?.xList[index]?.isSelected ?? false);
              if (checkSelectList.length >= 5 &&
                  !searchBeanData.xList[index].isSelected) {
                showToast(msg: "最多选择5个标签");
              } else {
                searchBeanData.xList[index].isSelected = isSelected;
                if (!isSelected) {
                  checkSelectList.removeWhere((element) =>
                      element.id == searchBeanData.xList[index].id);
                } else {
                  if (checkSelectList.length >= 5) {
                    showToast(msg: "最多选择5个标签");
                  } else {
                    checkSelectList.add(searchBeanData.xList[index]);
                  }
                }
              }
              setState(() {});
            },
            child: Container(
              color: Colors.transparent,
              margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 14.w),
              child: Row(
                children: [
                  Container(
                    height: 64.w,
                    width: 64.w,
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                      child: CustomNetworkImage(
                        fit: BoxFit.cover,
                        height: 64.w,
                        width: 64.w,
                        imageUrl: searchBeanData.xList[index].coverImg,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 7.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "#" + searchBeanData.xList[index].name,
                        style: TextStyle(color: Colors.white, fontSize: 17.w),
                      ),
                      SizedBox(
                        height: 13.w,
                      ),
                      Text(
                        "话题总播放次数：${getShowFansCountStr(searchBeanData?.xList[index]?.playCount ?? 0)}",
                        style: TextStyle(
                            color: Color.fromRGBO(124, 135, 159, 1),
                            fontSize: 13.w),
                      ),
                    ],
                  ),
                  Spacer(),
                  Theme(
                    data: ThemeData(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      primaryColor: AppColors.weiboJianPrimaryBackground,
                      backgroundColor: AppColors.weiboJianPrimaryBackground,
                    ),
                    child: GFCheckbox(
                      // key: keyList[index],
                      onChanged: (value) {
                        if (checkSelectList.length >= 5 &&
                            !searchBeanData.xList[index].isSelected) {
                          showToast(msg: "最多选择5个标签");
                        } else {
                          searchBeanData.xList[index].isSelected = value;
                          if (!value) {
                            checkSelectList.removeWhere((element) =>
                                element.id == searchBeanData.xList[index].id);
                          } else {
                            if (checkSelectList.length >= 5) {
                              showToast(msg: "最多选择5个标签");
                            } else {
                              checkSelectList.add(searchBeanData.xList[index]);
                            }
                          }
                          setState(() {});
                        }
                      },
                      type: GFCheckboxType.circle,
                      value: searchBeanData.xList[index].isSelected,
                      size: GFSize.SMALL,
                      activeBorderColor: Colors.black,
                      activeBgColor: AppColors.weiboColor,
                      inactiveBorderColor: Colors.white.withOpacity(0.4),
                      inactiveBgColor: AppColors.weiboJianPrimaryBackground,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
