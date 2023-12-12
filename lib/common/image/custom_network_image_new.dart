// ignore_for_file: depend_on_referenced_packages

import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_base/utils/log.dart';
import '../../assets/images.dart';
import 'package:path/path.dart' as path;

import 'image_manager_new.dart';

enum ImgTypeNew { avatar, cover, common, audiobook }

class CustomNetworkImageNew extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final Widget placeholder;
  final Widget errorWidget;
  final double width;
  final double height;
  final bool fullImg;
  final bool isGauss;

  final BorderRadius borderRadius;
  final double radius;
  final bool useQueue;
  final double placePadding;
  final Function(double,double) sizeCallback;
  const CustomNetworkImageNew({
    this.imageUrl,
    Key key,
    this.radius,
    this.fit,
    this.width,
    this.height,
    this.placeholder,
    this.borderRadius,
    this.useQueue = false,
    this.placePadding,
    this.fullImg = false,
    this.isGauss = false,
    this.errorWidget,
    this.sizeCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomNetworkImageNewState();
  }
}

class _CustomNetworkImageNewState extends State<CustomNetworkImageNew> {
  Uint8List _imageBase;
  bool _loadingFinish = false;
  bool get isGif => _realImageUrl.contains(".gif");
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadImage();
    });
  }

  @override
  void didUpdateWidget(covariant CustomNetworkImageNew oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl ||
        (_loadingFinish && _imageBase == null)) {
      _loadImage();
    }
  }

  String get _realImageUrl {
    if (widget.imageUrl?.isNotEmpty != true) {
      return "";
    }
    if (widget.imageUrl.startsWith("http") ||
        widget.imageUrl.startsWith("https")) {
      return widget.imageUrl;
    }

    ///需要大图且不高斯
    if (widget.fullImg == true && widget.isGauss == false) {
      var imgPath = path.join(Address.baseImagePath ?? "", widget.imageUrl);
      return imgPath;
    }
    String rootPath = path.join(Address.baseImagePath ?? "", "imageView/1");
    if (widget.width != null &&
        widget.height != null &&
        widget.fullImg == false &&
        widget.width?.isInfinite == false &&
        widget.width?.isNaN  == false &&
        widget.height?.isNaN  == false &&
        widget.height?.isInfinite  == false) {
      rootPath = path.join(rootPath, "w/${widget.width}/h/${widget.height}");
    }
    if (widget.isGauss == true) {
      rootPath = path.join(rootPath, "s/${Config.GAUSS_VALUE}");
    }
    rootPath = path.join(rootPath, widget.imageUrl);
    return rootPath;
  }

  _loadImage() async {
    _loadingFinish = false;
    if (widget.useQueue == true) {
      ImageManager.instance.loadImageInQueue(_realImageUrl,
          callback: (url, imageData) {
        _imageBase = imageData;
        if(_imageBase != null && widget.sizeCallback != null) {
          getImageSize(_imageBase);
        }
        if (mounted && _realImageUrl == url) {
          _loadingFinish = true;
          setState(() {});
        }
      });
    } else {
      try {
        _imageBase = await ImageManager.instance.loadImage(_realImageUrl);
        if(_imageBase != null && widget.sizeCallback != null) {
          getImageSize(_imageBase);
        }
        if (_imageBase != null && mounted) {
          _loadingFinish = true;
          setState(() {});
        }
      } catch (e) {
        debugLog(e.toString());
        _loadingFinish = true;
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  Future getImageSize(Uint8List bytes) async {
    final codec = await instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    widget.sizeCallback?.call(frame.image.width.toDouble(), frame.image.height.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    if (widget.borderRadius != null ||
        (widget.radius != null && widget.radius != 0)) {
      return ClipRRect(
        borderRadius:
            widget.borderRadius ?? BorderRadius.circular(widget.radius ?? 0),
        child: _buildImage(),
      );
    }
    return _buildImage();
  }

  Widget _buildImage() {
    return (_imageBase == null)
        ? Container(
            padding: EdgeInsets.all(widget.placePadding ?? 0),
            child: widget.placeholder ?? _buildPlaceHolder(),
          )
        :  _buildImageByType();
  }


  Widget _buildImageByType() {

      return Image.memory(
        _imageBase,
        width: widget.width,
        height: widget.height,
        gaplessPlayback: true,
        fit: widget.fit ?? BoxFit.cover,
        errorBuilder: (context, error, track) {
          return widget.errorWidget ??
              widget.placeholder ??
              _buildPlaceHolder();
        },
      );
  }

  Widget _buildPlaceHolder() {
    return Container(
      alignment: Alignment.center,
      color: Color(0xff151515),
      child: Image.asset("assets/weibo/loading_normal.png",width: 106,height:92,),
    );
  }

  @override
  void dispose() {
    //controller?.stop();
    //controller?.dispose();
    super.dispose();
  }
}
