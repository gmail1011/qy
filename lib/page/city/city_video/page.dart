import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/city/city_video/adapter/adapter.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///城市主页
class CityVideoPage extends Page<CityVideoState, Map<String, dynamic>> {
  CityVideoPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<CityVideoState>(
            adapter: NoneConn<CityVideoState>() + CityIndexAdapter(),
            slots: <String, Dependent<CityVideoState>>{},
          ),
          middleware: <Middleware<CityVideoState>>[],
        );
}
