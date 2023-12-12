import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';

enum REQUEST_CODE {
  REQUESTING, //请求中
  REQUEST_SUCCESS, //请求成功
  REQUEST_FAIL, //请求失败
  REQUEST_DATA_EMPTY, //数据为空
}

class BaseRequestView extends StatefulWidget {
  final BaseRequestController controller;
  final Widget child;
  final VoidCallback retryOnTap; //请求失败重试事件
  final Decoration decoration;

  const BaseRequestView(
      {Key key, @required this.controller, @required this.child, this.retryOnTap, this.decoration})
      : super(key: key);

  @override
  _BaseRequestViewState createState() => _BaseRequestViewState();
}

class _BaseRequestViewState extends State<BaseRequestView> {
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
    return Container(
      decoration:
          widget.decoration == null ? BoxDecoration(color: AppColors.primaryColor) : widget.decoration,
      child: Stack(
        children: <Widget>[
          ///请求成功
          Visibility(
            visible: widget.controller.requestCode == REQUEST_CODE.REQUEST_SUCCESS,
            child: widget.child,
          ),

          ///无数据
          Visibility(
            visible: widget.controller.requestCode == REQUEST_CODE.REQUEST_DATA_EMPTY,
            child: GestureDetector(
              child: Center(
                child: CErrorWidget(
                  Lang.EMPTY_DATA,
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
            visible: widget.controller.requestCode == REQUEST_CODE.REQUEST_FAIL,
            child: GestureDetector(
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
            ),
          ),

          ///请求中
          Visibility(
            visible: widget.controller.requestCode == REQUEST_CODE.REQUESTING,
            child: Center(child: LoadingWidget()),
          ),
        ],
      ),
    );
  }
}

class BaseRequestController {
  ValueNotifier<REQUEST_CODE> code = ValueNotifier(REQUEST_CODE.REQUESTING);

  BaseRequestController({bool isRequest = true}) {
    if (isRequest) {
      code = ValueNotifier(REQUEST_CODE.REQUESTING);
    } else {
      code = ValueNotifier(REQUEST_CODE.REQUEST_SUCCESS);
    }
  }

  REQUEST_CODE get requestCode => code.value;

  //请求失败
  requestFail() {
    code?.value = REQUEST_CODE.REQUEST_FAIL;
  }

  //请求成功
  requestSuccess() {
    code?.value = REQUEST_CODE.REQUEST_SUCCESS;
  }

  //数据为空
  requestDataEmpty() {
    code?.value = REQUEST_CODE.REQUEST_DATA_EMPTY;
  }

  //请求中
  requesting() {
    code?.value = REQUEST_CODE.REQUESTING;
  }
}
