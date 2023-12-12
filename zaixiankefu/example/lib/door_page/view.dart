// import 'package:chat_online_customers/chat_widget/chat_core/network/connection/chat_data_manager.dart';
// import 'package:chat_online_customers/chat_widget/chat_core/network/connection/chat_data_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_model/userModel.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'state.dart';

Widget buildView(DoorState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      title: Text('入口'),
      actions: <Widget>[
        FloatingActionButton(
          onPressed: () {
            // Navigator.pushNamed(viewService.context, 'keyPage',arguments: {'id':"123"});
            // YYDialogDontTalk(viewService.context, "asldfaklsdfak");
          },
          child: Text('点我'),
        )
      ],
    ),
    body: Container(
      child: Center(
          child: RaisedButton(
        onPressed: () {
          KefuUserModel model = KefuUserModel(
              // getMsg: getMsg,
              // wss://thsc.eddxe.com/customer/im
              // http://183.61.126.215:9090/customer/im
              //https://ssbb.eddxe.com/customer/im?protoType=1&pType=201&appId=9189155602&sign=2b66bb0f4277ab5bc5180c74d3266540c08f69eed06afe1a8018df2007e53fb5034db6f90a3e7be356c6263f6e83d913c1cebdf13e8bbd8a15465abe65aabf53
              username: '张三',
              // avatar: 'https://ltimage.kk.khdhbnx.cn/image/vt/30/f0/y0/651fd0544f2d46c79c6a69a2173f7d41.jpg',
              //'https://ltapi1.qukfu.com/customer/im?pType=201&appId=8052152834&sign=768f4b49954493d4714c97021fddeab18f501304967defcd0bf60f478b46044cd61778787c842ad789c89811d0029ffedbcb8ad4363c34c87c0ab9281ecabfbd1805efc7314b868c143c8660a9b3249637f55d3933132df6579d18e3b82d8cba',//
              // connectUrl:'https://yhapi.pjphifp.cn/kefu/customer/im?sign=c2b691070094bff093a7a99741953d418811f9e31d79b6cb6245e535464a10d18e5fd260d15bd7b662964d417dd79814cd690a380d25780211947c00a1b2d148b47b5cb5529e093caf65af096b762d670ac35f6d5496e2d3558ec9d8bd24d30b0a39c350078445f7411e34d94b0b08a2a093da9cae40eafe9e607a29e6b6cbfc1fe5f7857d4e9de0cd8c87c11f615db97c5cfc1bf0275583184f1d1e22742830f0bd9b4d8e96582eb4ff2b2920238af2d1b67dedd8266a634a81383ac260776dc513c96faddeb5e0f5c7542a53ff6dfc&appId=5551867914&theme=theme1',
                 connectUrl: 'https://dspjs.hfuvdy.com/kefu/customer/im?sign=80291c85b1e91ab7aeff7a84883c27ae3864b7bcc06dc6589cb60556dea11a34fe63c0fedc319c0f98fb009c9d416a9f9e71ace9947fa1ec06dd9aa2924907214354d7b33390e15e198501dae0dc9e1676325f6fe8e1432b09daaa5b7a7e699b31e65a7711462dc31624f0fc678bf805e7ce1aff2a30440a4d53a4044b16c9424148ea4cfe15d78140184e382b2368071c5c979cc039696328301e742a152cd7383e88cdb4332c102618ef05b340a69890a0178849dd1a406a1502afb285059dc1bb291c8881171f3b88047e80ed743bbd631ea180e90e3bf613db60969c6f7e&appId=5440982520&theme=theme1',//'https://ssbb.eddxe.com/customer/im?protoType=1&pType=201&appId=7028499103&sign=301f901da3316162abb1995789e2e9f9c66178ee1599ce5bf539302810eb7394f495d022d040bcc0ba08b15333a1faed',//'wss://thsc.eddxe.com/customer/im?sign=346de818698fed14e44cc49a9a2d19a7243a809a261bb81485f99ac354e1f8ddc0800fb1fb821997af1a4ba290e7f6beb07d3e55a5b15e9db2ac6bd1cb1447635c727be5e58c4e36e9834980c18f10cb&appId=9189155602&protoType=1&pType=201', //'https://yhapi.pjphifp.cn/kefu/customer/im?sign=c2b691070094bff093a7a99741953d418811f9e31d79b6cb6245e535464a10d18e5fd260d15bd7b662964d417dd79814a2f8701a6d458abc96f06414d93b5375a3dc1578c9cb4c2999b8594beb4b79b0b389da2227463e430f65adbac39bc86dfaaeae8a809f327d1a4e36867ee58d58857f6463132848a17cbf3b90d3a48d38169a9aeeafbf74ac860e575ed834d6c1d2521c37b3acd2af33b649b60b7533e51dfc65004fc9f7850b84246616ea20b02863247bee13f01a757f4b725d572c844e829c52b17505fb46caf2b529af7fd5&appId=5551867914',
              baseUrl: 'https://ssbb.eddxe.com',//'http://183.61.126.215:9527',  //'http://192.168.3.123:9527',//'http://183.61.126.215:8080',//
              avatar: 'https://img95.699pic.com/photo/50046/5562.jpg_wh300.jpg',
              faqApi: '/api/faq/queryByAppId',
              faqHeadImgPath: '',
              checkConnectApi: '/api/play/unread',
              userId: '666666',
              );
          SocketManager().model = model;
          SocketManager().getMsg = getMsg;
          SocketManager().jumpToChatWidget(viewService.context);
          // Navigator.pushNamed(viewService.context, 'chatPage', arguments: model);
        },
        // KefuUserModel model = KefuUserModel(
        //     // getMsg: getMsg,
        //     username: '张三',
        //     // avatar: 'https://ltimage.kk.khdhbnx.cn/image/vt/30/f0/y0/651fd0544f2d46c79c6a69a2173f7d41.jpg',
        //     //'https://ltapi1.qukfu.com/customer/im?pType=201&appId=8052152834&sign=768f4b49954493d4714c97021fddeab18f501304967defcd0bf60f478b46044cd61778787c842ad789c89811d0029ffedbcb8ad4363c34c87c0ab9281ecabfbd1805efc7314b868c143c8660a9b3249637f55d3933132df6579d18e3b82d8cba',//
        //     connectUrl:
        //         'https://yhapi1.jnppbnd.cn/kefu/customer/im?sign=c2b691070094bff093a7a99741953d418811f9e31d79b6cb6245e535464a10d18e5fd260d15bd7b662964d417dd79814434c478d621c50804911e94362d78311ee79d057ca14189697bb3c836e04734843bd9736a967bf321f5499251cda9aa3af797ee9ceacbb00763fe8691091aea2605ad265a3981088dea923b71f399e06efcbf6752c261ecab0bcd7cbe21ee0ec6c70dc054daf1c7388dcef17b8fabe3e916cb6319ccc8e0fe159b518e4e422c1cb58f22d75ca01ea37a490bf7b2c9cba7795a9fbb109a896ae66648a814e8859&appId=9189155602&theme=theme1',
        //     baseUrl: 'https://yhapi1.jnppbnd.cn',
        //     avatar: 'https://img95.699pic.com/photo/50046/5562.jpg_wh300.jpg',
        //     faqApi: '/kefu/api/faq/queryByAppId',
        //     faqHeadImgPath: '',
        //     checkConnectApi: '/kefu/api/play/unread',
        //     // userId: '666666',
        //   );
        //   SocketManager().model = model;
        //   SocketManager().getMsg = getMsg;
        //   SocketManager().jumpToChatWidget(viewService.context);},
        child: Text('进入在线客服'),
      )),
    ),
  );
}

Future<List<Map>> faqRequest(int id) async {
  return [
    {"id": 12, "name": "绑定相关"},
    {"id": 13, "name": "账号相关"},
  ];
}

Future<Map> faqQuestionInfo(int id) async {
  return {
    'name': '账号相关',
    'data': [
      {'id': 12, 'name': '如何绑定账号？'},
      {'id': 13, 'name': '如何查看余额？'},
      {'id': 14, 'name': '如何解除绑定？'},
    ]
  };
}

Future<List<Map>> faqQuestionFullInfo(int id) async {
  return [
    {'id': 12, 'name': '未绑定账户的用户，点击绑定登录就可以绑定'},
    {'id': 13, 'name': '如何查看余额？'},
    {'id': 14, 'name': '如何解除绑定？'},
  ];
}

Future getMsg(int num) async {
  print('=====================msg=======item=++++++$num');
}

