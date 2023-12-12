import 'package:flutter/material.dart';
import 'package:flutter_base/utils/dimens.dart';

///进度提示框
class WBLoadingDialog {
  static Map<BuildContext, WBLoadingDialog> _cache = Map();
  int _retain = 0;
  final OverlayEntry _entry;

  WBLoadingDialog(this._retain, this._entry);

  static void show(BuildContext context) {
    if (context == null) {
      return;
    }
    WBLoadingDialog loading = _cache[context];
    if (loading == null) {
      loading = WBLoadingDialog(0, _buildLoading(context));
    }
    loading._retain++;
    _cache[context] = loading;
  }

  static OverlayEntry _buildLoading(BuildContext context) {
    OverlayEntry entry = OverlayEntry(builder: (context) {
      return WillPopScope(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey.withAlpha(50),
          alignment: Alignment.center,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Colors.black.withAlpha(400),
                width: Dimens.pt80,
                height: Dimens.pt80,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: Dimens.pt28,
                        height: Dimens.pt28,
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.grey[400],
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                            strokeWidth: 2)),
                    SizedBox(height: Dimens.pt10),
                    Text(
                      '提交中...',
                      style: TextStyle(
                          fontSize: Dimens.pt12,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () async => Future.value(false),
      );
    });
    Overlay.of(context)?.insert(entry);
    return entry;
  }

  static void dismiss(BuildContext context) {
    if (context == null) {
      return;
    }
    WBLoadingDialog loading = _cache[context];
    if (loading != null) {
      loading._retain--;
      if (loading._retain <= 0) {
        loading._entry.remove();
        _cache[context] = null;
      }
    }
  }
}
