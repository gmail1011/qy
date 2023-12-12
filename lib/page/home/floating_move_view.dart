import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_base/flutter_base.dart';


class FloatingMoveView extends StatefulWidget {
  final Function tapCallBack;

  const FloatingMoveView({
    Key key,
    this.tapCallBack,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FloatingMoveViewState();
  }
}

class _FloatingMoveViewState extends State<FloatingMoveView> {
  final _floatingGlobalKey = GlobalKey();
  AdsInfoBean _advertsInfo;
  double _bottom = 16;
  double _right = 16;
  double _width;
  double get _adSize => Dimens.pt80;
  double get width {
    if (_width == null) {
      var renderBox =
      _floatingGlobalKey.currentContext?.findRenderObject() as RenderBox;
      _width = renderBox.size.width ?? MediaQuery
          .of(context)
          .size
          .width;
      _height = renderBox.size.height ?? MediaQuery
          .of(context)
          .size
          .height;
    }
    return _width;
  }

  double _height;

  double get height {
    if (_height == null) {
      var renderBox =
      _floatingGlobalKey.currentContext?.findRenderObject() as RenderBox;
      _width = renderBox.size.width ?? MediaQuery
          .of(context)
          .size
          .width;
      _height = renderBox.size.height ?? MediaQuery
          .of(context)
          .size
          .height;
    }
    return _height;
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadAdData();
    });
  }

  void _loadAdData() async {
    List<AdsInfoBean> list = await getAdsByType(AdsType.homeFloating);
    if(list?.isNotEmpty == true){
      _advertsInfo = list.first;
    }
    setState(() {});
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _right -= details.delta.dx;
    _bottom -= details.delta.dy;
    if (_right > width - _adSize) {
      _right = width - _adSize;
    }
    if (_right < 0) _right = 0;
    if (_bottom > height - _adSize) {
      _bottom = height - _adSize;
    }
    if (_bottom < 0) _bottom = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_advertsInfo == null) {
      return const SizedBox();
    }
    return Container(
      key: _floatingGlobalKey,
      child: Stack(
        children: [
          Positioned(
            bottom: _bottom,
            right: _right,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: _adSize,
                width: _adSize,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) {
                    if (_advertsInfo != null) {
                      if (_advertsInfo.href.contains("game_page")) {
                        Navigator.of(FlutterBase.appContext).pop();
                        bus.emit(EventBusUtils.gamePage);
                      } else {
                        JRouter().handleAdsInfo(_advertsInfo.href, id: _advertsInfo.id).then((value) {
                          bus.emit(EventBusUtils.showActivityFloating);
                        });
                      }
                    }
                  },
                  onPanUpdate: (DragUpdateDetails details) {
                    _onPanUpdate(details);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: CustomNetworkImage(
                      imageUrl: _advertsInfo?.cover ?? "",
                      width: Dimens.pt80,
                      height: Dimens.pt80,
                      fit: BoxFit.cover,
                      type: ImgType.cover,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
