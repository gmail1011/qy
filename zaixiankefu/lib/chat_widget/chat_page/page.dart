
import 'package:chat_online_customers/chat_widget/chat_model/userModel.dart';
import 'package:chat_online_customers/chat_widget/chat_page/key_board_component/component.dart';
import 'package:chat_online_customers/chat_widget/chat_page/voice_component/component.dart';
import 'package:fish_redux/fish_redux.dart';

import 'List_component/component.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ChatPage extends Page<ChatState, KefuUserModel>  {
  ChatPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ChatState>(
                adapter: null,
                slots: <String, Dependent<ChatState>>{
                  'VoiceComponent':VoiceConnector() +  VoiceComponent(),
                  'ListComponent' : ListConnector() + ListComponent(),
                  'keyBoardComponent' : KeyBoardConnector() + KeyBoardComponent(),
                }),
            middleware: <Middleware<ChatState>>[
            ]);

}
