import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_base/utils/misc_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum PULL_REQUEST_CODE {
  REQUESTING, //请求中
  REQUEST_SUCCESS, //请求成功
  REQUEST_FAIL, //请求失败
  REQUEST_DATA_EMPTY, //数据为空
}

class PullRefreshView extends StatefulWidget {
  final PullRefreshController controller;
  final Widget child;
  final VoidCallback retryOnTap; //请求失败重试事件
  final VoidCallback onRefresh;
  final VoidCallback onLoading;
  final bool enablePullUp;
  final bool enablePullDown;
  final String noDataText;
  final String emptyText;

  const PullRefreshView({
    Key key,
    @required this.controller,
    @required this.child,
    this.retryOnTap,
    this.onRefresh,
    this.onLoading,
    this.enablePullUp = true,
    this.enablePullDown = true,
    this.noDataText = Lang.NO_MORE_DATA,
    this.emptyText = Lang.EMPTY_DATA,
  }) : super(key: key);

  @override
  _PullRefreshViewState createState() => _PullRefreshViewState();
}

class _PullRefreshViewState extends State<PullRefreshView> {
  VoidCallback listener;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.controller != null) {
      widget.controller.code.addListener(listener);
    }
  }

  @override
  void dispose() {
    widget.controller?.code?.removeListener(listener);
    super.dispose();
  }

  @override
  void initState() {
    listener = () {
      setState(() {});
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isFirstPage = widget.controller.isFirstPage;
    return Container(
      child: Stack(
        children: <Widget>[
          Visibility(
            visible: widget.controller.requestCode ==
                PULL_REQUEST_CODE.REQUEST_SUCCESS,
            child: SmartRefresher(
              enablePullDown: widget.enablePullDown,
              enablePullUp: widget.enablePullUp,
              header: WaterDropHeader(
                waterDropColor: AppColors.primaryRaised,
                complete: Text(Lang.REFRESH_SUCCESS,
                    style: TextStyle(
                        color: AppColors.primaryRaised,
                        fontSize: AppFontSize.fontSize14)),
                failed: Text(Lang.REFRESH_FAILED,
                    style: TextStyle(
                        color: AppColors.primaryRaised,
                        fontSize: AppFontSize.fontSize14)),
              ),
              footer: ClassicFooter(
                loadingText: Lang.LOADING,
                canLoadingText: Lang.RELEASE_LOAD_MORE,
                noDataText: Lang.NO_MORE_DATA,
                idleText: Lang.PULL_UP_LOAD_MORE,
                failedText: Lang.LOADING_FAILED,
                textStyle: TextStyle(
                    color: AppColors.primaryRaised,
                    fontSize: AppFontSize.fontSize14,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal),
              ),
              controller: widget.controller.refreshController,
              onRefresh: () {
                MiscUtil.vibrate();
                widget.onRefresh();
              },
              onLoading: () {
                MiscUtil.vibrate();
                widget.onLoading();
              },
              child: widget.child,
            ), //widget.child,
          ),
          //请求中
          Visibility(
            visible:
                widget.controller.requestCode == PULL_REQUEST_CODE.REQUESTING,
            child: Center(child: LoadingWidget()),
          ),

          ///无数据
          Visibility(
            visible: isFirstPage &&
                widget.controller.requestCode ==
                    PULL_REQUEST_CODE.REQUEST_DATA_EMPTY,
            child: GestureDetector(
              child: Center(
                child: CErrorWidget(
                  widget.emptyText,
                  retryOnTap: widget.retryOnTap == null
                      ? null
                      : () {
                          if (widget.retryOnTap != null) {
                            widget.controller.requesting();
                            widget.retryOnTap?.call();
                          }
                        },
                ),
              ),
            ),
          ),

          ///请求失败
          Visibility(
            visible: isFirstPage &&
                widget.controller.requestCode == PULL_REQUEST_CODE.REQUEST_FAIL,
            child: Center(
              child: CErrorWidget(
                Lang.REQUEST_FAILED,
                retryOnTap: widget.retryOnTap == null
                    ? null
                    : () {
                        if (widget.retryOnTap != null) {
                          widget.controller.requesting();
                          widget.retryOnTap?.call();
                        }
                      },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PullRefreshController {
  ValueNotifier<PULL_REQUEST_CODE> code;
  bool isFirstPage = false;
  RefreshController refreshController;

  PullRefreshController({bool isRequest = true}) {
    refreshController = RefreshController();
    if (isRequest) {
      code = ValueNotifier(PULL_REQUEST_CODE.REQUESTING);
    } else {
      code = ValueNotifier(PULL_REQUEST_CODE.REQUEST_SUCCESS);
    }
  }
  PULL_REQUEST_CODE get requestCode => code.value;

  //请求失败
  requestFail({@required bool isFirstPageNum}) {
    isFirstPage = isFirstPageNum;
    code?.value = isFirstPage
        ? PULL_REQUEST_CODE.REQUEST_FAIL
        : PULL_REQUEST_CODE.REQUEST_SUCCESS;
    if (refreshController.isRefresh) {
      refreshController.refreshFailed();
    }
    if (refreshController.isLoading) {
      refreshController.loadFailed();
    }
  }

  //请求成功
  requestSuccess({
    @required bool isFirstPageNum,
    bool hasMore = true,
    bool isEmpty = false,
  }) {
    isFirstPage = isFirstPageNum;
    if (refreshController.isRefresh) {
      refreshController.refreshCompleted(resetFooterState: true);
    }
    if (isFirstPage && isEmpty) {
      code?.value = PULL_REQUEST_CODE.REQUEST_DATA_EMPTY;
    } else {
      code?.value = PULL_REQUEST_CODE.REQUEST_SUCCESS;
      if (hasMore) {
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    }
  }

  //请求中
  requesting() {
    code?.value = PULL_REQUEST_CODE.REQUESTING;
  }
}
