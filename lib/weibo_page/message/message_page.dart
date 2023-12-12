import 'package:fish_redux/fish_redux.dart';

import 'message_effect.dart';
import 'message_reducer.dart';
import 'message_state.dart';
import 'message_view.dart';

class MessagePage extends Page<MessageState, Map<String, dynamic>> {
  MessagePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<MessageState>(
                adapter: null,
                slots: <String, Dependent<MessageState>>{
                }),
            middleware: <Middleware<MessageState>>[
            ],);

}
