import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

/// 约炮banner点开视图
class YuePaoBannerPage extends Page<YuePaoBannerState, Map<String, dynamic>> {
  YuePaoBannerPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<YuePaoBannerState>(
                adapter: null,
                slots: <String, Dependent<YuePaoBannerState>>{
                }),
            middleware: <Middleware<YuePaoBannerState>>[
            ],);

}
