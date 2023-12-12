import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

/// 需要vsync的从这里构建在componet中
/// 然后拿state.stfState
//  @override
// ComponentState<VideoItemState> createState() {
//   return SingleTickerProviderState<VideoItemState>();
// }
class SingleTickerProviderState<T> extends ComponentState<T>
    with SingleTickerProviderStateMixin {}
