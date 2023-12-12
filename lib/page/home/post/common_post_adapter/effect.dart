import 'package:fish_redux/fish_redux.dart';

Effect<T> buildEffect<T extends MutableSource>() {
  return combineEffects(<Object, Effect<T>>{});
}
