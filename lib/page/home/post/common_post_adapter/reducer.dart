import 'package:fish_redux/fish_redux.dart';

Reducer<T> buildReducer<T extends MutableSource>() {
  return asReducer(
    <Object, Reducer<T>>{},
  );
}
