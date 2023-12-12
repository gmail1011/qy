import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///我的喜欢
class MyFavoritePage extends Page<MyFavoriteState, Map<String, dynamic>> {
  MyFavoritePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<MyFavoriteState>(
                adapter: null,
                slots: <String, Dependent<MyFavoriteState>>{
                }),
            middleware: <Middleware<MyFavoriteState>>[
            ],);

}
