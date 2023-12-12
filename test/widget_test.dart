// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'dart:typed_data';

void main() {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
  // test("test", () {
  //   var m = MyState();
  //   print(m.selfId);
  //   print(m.originId);
  //   print(m.eagleId());
  // });
  test("testEncrypt", () {
    // final key = "sdflsdfslasdfll;asdf;'asdfasdfasdfhl;asdfhadksbfn";
    // final cipher = "j9yrAF6kHBOeWXuUajtQ9Iyhs82aR21Ympo6Qw==";
    // aesDecryptEx(cipher, key);
    final cipher =
        "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";
    // aesDecryptEx(cipher, "vEukA&w15z4VAD3kAY#fkL#rBnU!WDhN");
    aesDecryptEx(cipher, Config.encryptKey);
  });

  test("testTime", () {
    var serverTimeS = "2021-02-18T12:55:27.178Z";
    var _serverTime = DateTime.parse(serverTimeS);
    int _diffTimeInSeconds = DateTime.now().difference(_serverTime).inSeconds;
    print("diffSeconds:$_diffTimeInSeconds seconds");
    var cur = DateTime.now().add(Duration(seconds: -_diffTimeInSeconds));
    print("cur:$cur");
  });
}

String aesDecryptEx(String cipher, String key) {
  final t1 = DateTime.now();
  final nonceLen = 12;
  final cipherBytes = base64Decode(cipher);
  final nonce = cipherBytes.sublist(0, nonceLen);
  final largeShaRaw = List<int>()..addAll(utf8.encode(key))..addAll(nonce);
  final largeShaRawMid = largeShaRaw.length ~/ 2;
  final msgKeyLarge = sha256.convert(largeShaRaw).bytes;
  final msgKey = msgKeyLarge.sublist(8, 24);
  print(DateTime.now().difference(t1).inMilliseconds);

  final shaRawA = List<int>()
    ..addAll(msgKey)
    ..addAll(largeShaRaw.sublist(0, largeShaRawMid));
  final sha256a = sha256.convert(shaRawA).bytes;

  final shaRawB = List<int>()
    ..addAll(largeShaRaw.sublist(largeShaRawMid))
    ..addAll(msgKey);
  final sha256b = sha256.convert(shaRawB).bytes;

  final aesKey = List<int>()
    ..addAll(sha256a.sublist(0, 8))
    ..addAll(sha256b.sublist(8, 24))
    ..addAll(sha256a.sublist(24));

  final aesIV = List<int>()
    ..addAll(sha256b.sublist(0, 4))
    ..addAll(sha256a.sublist(12, 20))
    ..addAll(sha256b.sublist(28));
  print(DateTime.now().difference(t1).inMilliseconds);

  final encrypter =
      Encrypter(AES(Key(Uint8List.fromList(aesKey)), mode: AESMode.cbc));
  final decrypted = encrypter.decryptBytes(
      Encrypted(cipherBytes.sublist(nonceLen)),
      iv: IV(Uint8List.fromList(aesIV)));
  print(DateTime.now().difference(t1).inMilliseconds);
  print(decrypted);
  final text = Utf8Decoder().convert(decrypted);
  print(DateTime.now().difference(t1).inMilliseconds);

  // print(text);
  print(DateTime.now().difference(t1).inMilliseconds);
  return text;
}

class MyState with EagleHelper {
  @override
  String get originId => "test";
}
