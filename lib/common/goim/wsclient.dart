import 'dart:io';

import 'package:flutter_base/net/e_data.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

typedef void OnMessage(dynamic message);
typedef void OnOpen();
typedef void OnClose(int code, String reason);
typedef void OnError(err);

class WsOptions {
  final String url;
  final OnOpen onOpen;
  final OnMessage onMessage;
  final OnClose onClose;
  final OnError onError;
  final OnError onOpenError;
  final Duration connectTimeout;
  final Map<String, dynamic> headers;

  WsOptions(this.url,
      {this.onOpen,
      this.onMessage,
      this.onClose,
      this.onError,
      this.onOpenError,
      this.connectTimeout,
      this.headers})
      : assert(url != null);
}

class WsClient {
  static const defaultConnectTimeout = Duration(seconds: 10); //10s
  final WsOptions wsOptions;
  IOWebSocketChannel _chan;

  WsClient(this.wsOptions) : assert(wsOptions != null);

  void connect() {
    final timeout = wsOptions.connectTimeout ?? defaultConnectTimeout;
    print("connect()...${wsOptions.url}");
    WebSocket.connect(wsOptions.url, headers: wsOptions.headers)
        .timeout(timeout)
        .then((WebSocket ws) {
      syncCall(() => _onOpen());
      _chan = IOWebSocketChannel(ws);
      _chan.stream.listen(_onMessage,
          onDone: _onClose, onError: _onError, cancelOnError: true);
    }).catchError((err) {
      print("connect()...error-source:${wsOptions.url}");
      _onOpenError(err);
    });
  }

  _onOpen() => wsOptions.onOpen?.call();

  _onMessage(dynamic message) => wsOptions.onMessage?.call(message);

  _onClose() => wsOptions.onClose?.call(_chan.closeCode, _chan.closeReason);

  _onOpenError(error) => wsOptions.onOpenError?.call(error);

  _onError(error) => wsOptions.onError?.call(error);

  Future close() => _chan?.sink?.close(status.normalClosure);

  send(dynamic data) => _chan?.sink?.add(data);
}
