import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_app/common/goim/wsclient.dart';

_imPrint(Object o) {
  // l.d("im-client", "$o");
}

typedef Map<String, dynamic> AuthBuilder();
typedef void MessageHandler(Uint8List msg);

class GoIMClient {
  static const rawHeaderLen = 16;
  static const packetOffset = 0;
  static const headerOffset = 4; //4
  static const verOffset = 6; //2
  static const opOffset = 8; // 2
  static const seqOffset = 12; //4
  //https://github.com/Terry-Mao/goim/blob/master/docs/proto.md
  static const opHeartbeat = 2; // 客户端请求心跳
  static const opHeartbeatReply = 3; // 服务器心跳答复
  static const opSendMsg = 4;
  static const opSendMsgReply = 5; // 下行消息
  static const opDisconnectReply = 6;
  static const opAuth = 7; // auth认证
  static const opAuthReply = 8; // auth认证
  static const opRaw = 9;

  final String url;
  final Duration reconnectInterval;
  final Duration connectTimeout;
  final bool enableHeartbeatLog;
  final AuthBuilder authBuilder;
  final MessageHandler messageHandler;

  WsClient _wsClient;
  Timer _keepAliveTimer;
  bool _enableReconnect = true;
  bool _shutdown = false;

  GoIMClient(
    this.url, {
    this.authBuilder,
    this.messageHandler,
    this.connectTimeout: const Duration(seconds: 10),
    this.reconnectInterval: const Duration(seconds: 3),
    this.enableHeartbeatLog: true,
  })  : assert(authBuilder != null),
        assert(messageHandler != null),
        assert(connectTimeout != null),
        assert(connectTimeout != null),
        assert(enableHeartbeatLog is bool);

  void createConnect({bool isReConnect}) {
    if (isReConnect != true) _shutdown = false;
    _imPrint("createConnect()...url:$url");
//    assert(_wsClient == null);
    _wsClient = WsClient(WsOptions(url,
        connectTimeout: connectTimeout,
        onMessage: _onMessage,
        onOpenError: _onOpenError,
        onError: _onError,
        onClose: _onClose,
        onOpen: _onOpen,
        headers: authBuilder()))
      ..connect();
  }

  void _onOpen() {
    _imPrint("onOpen");
    Future.microtask(() => _sendAuth(authBuilder()));
  }

  _onOpenError(err) {
    _imPrint("onOpenError $err");
    if (_shutdown) return;
    if (_enableReconnect) _delayReConnect();
  }

  void close() {
    _imPrint("close request...");
    _shutdown = true;
    _cancelKeepAlive();
    _wsClient.close();
  }

  void _onClose(int code, String reason) {
    _wsClient = null;
    _imPrint("onClose $code, $reason");
    _cancelKeepAlive();
    if (_shutdown) return;
    if (_enableReconnect) _delayReConnect();
  }

  _onError(err) {
    _imPrint("onError $err");
  }

  //https://github.com/Terry-Mao/goim/blob/master/docs/proto.md
  _onMessage(dynamic message) {
    final data = message as Uint8List;
    final dataView = ByteData.view(data.buffer, data.offsetInBytes);
    final packetLen = dataView.getInt32(packetOffset);
    final headerLen = dataView.getUint16(headerOffset); //headerLen
    final ver = dataView.getUint16(verOffset);
    final op = dataView.getInt32(opOffset);
    final seq = dataView.getInt32(seqOffset);
    _imPrint("recv len:$packetLen,ver:$ver,op:$op,seq:$seq");
    switch (op) {
      case opAuthReply:
        _onAuthSuccess();
        break;
      case opHeartbeatReply:
        _onHeartbeatReply();
        break;
      case opRaw:
        for (var offset = rawHeaderLen;
            offset < data.lengthInBytes;
            offset += packetLen) {
          final packetLen = dataView.getInt32(offset);
          final headerLen = dataView.getInt16(offset + headerOffset);
          final ver = dataView.getInt16(offset + verOffset);
          final op = dataView.getInt32(offset + opOffset);
          final seq = dataView.getInt32(offset + seqOffset);
          final _ = op == seq; //avoid warning
          final bodyStart = offset + headerLen;
          final bodyEnd = offset + packetLen;
          final msgBody = data.sublist(bodyStart, bodyEnd);
          _messageReceived(ver, msgBody);
        }
        break;
      default:
        final bodyStart = headerLen;
        final bodyEnd = packetLen;
        final msgBody = data.sublist(bodyStart, bodyEnd);
        _messageReceived(ver, msgBody);
    }
  }

  void _sendData(int op, [Uint8List bodyBuf]) {
    int version = 1; //uint16
    int seq = 1;
    final bodyLen = bodyBuf?.length ?? 0;
    final packetLen = rawHeaderLen + bodyLen;

    final sendBytes = Uint8List(packetLen);
    final headerBytes = ByteData.view(sendBytes.buffer, 0, rawHeaderLen);
    headerBytes.setInt32(packetOffset, packetLen);
    headerBytes.setInt16(headerOffset, rawHeaderLen);
    headerBytes.setInt16(verOffset, version);
    headerBytes.setInt32(opOffset, op);
    headerBytes.setInt32(seqOffset, seq);
    if (bodyLen > 0) sendBytes.setRange(rawHeaderLen, packetLen, bodyBuf);

    _imPrint("_sendData len ${sendBytes.lengthInBytes}");
    _wsClient.send(sendBytes);
  }

  void _sendAuth(Map<String, dynamic> m) {
    final token = json.encode(m);
    _sendData(opAuth, utf8.encode(token));
  }

  void _onAuthSuccess() {
    _imPrint("auth success");
    _keepAlive();
  }

  void _keepAlive() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer =
        Timer.periodic(Duration(seconds: 30), (_) => _sendHeartbeatPing());
  }

  void _cancelKeepAlive() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;
  }

  void _sendHeartbeatPing() {
    if (enableHeartbeatLog) _imPrint("send heartbeat request");
    _sendData(opHeartbeat);
  }

  void _onHeartbeatReply() {
    if (enableHeartbeatLog) _imPrint("recv heartbeat reply");
  }

  void _messageReceived(int ver, Uint8List body) {
    this.messageHandler(body);
  }

  void _reConnect() {
    _imPrint("start reConnect...");
    createConnect(isReConnect: true);
  }

  void _delayReConnect() async {
    await Future.delayed(reconnectInterval);
    _reConnect();
  }
}

//Map<String, dynamic> authBuilder() {
//  return {
//    "appId": "20201159527",
//    "sign":
//        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NlcHRzIjpbMTAwMCwxMDAxLDEwMDJdLCJtaWQiOjEyNCwicGxhdGZvcm0iOiJ3ZWIiLCJyb29tX2lkIjoibGl2ZS8vMTAwMCIsInRpbWVzdGFtcCI6MTU3OTE1OTAxMn0.OTscgWVi1XKO-m2itoeqUJQbYJom5zY7wWAzbdJj1vg"
//  };
//}
//
//void messageHandler(Uint8List msg) {
//  try {
//    final s = utf8.decode(msg);
//    final Map<String, dynamic> j = json.decode(s);
//    final int op = j["op"];
//    final data = j["data"];
//    _imPrint("messageHandler op:$op data:$data");
//  } on FormatException catch (err) {
//    _imPrint("messageHandler format err $err");
//  } catch (err) {
//    _imPrint("messageHandler err $err");
//  }
//}
//
//void main() {
//  final url = "ws://20.20.81.167:3102/sub";
//  final client = GoIMClient(
//    url,
//    authBuilder: authBuilder,
//    messageHandler: messageHandler,
//  );
//  client.createConnect();
//}
