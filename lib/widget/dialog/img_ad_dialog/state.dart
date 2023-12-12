import 'package:fish_redux/fish_redux.dart';

class ImgAdDialogState implements Cloneable<ImgAdDialogState> {
  @override
  ImgAdDialogState clone() {
    return ImgAdDialogState();
  }
}

ImgAdDialogState initState(Map<String, dynamic> args) {
  return ImgAdDialogState();
}
