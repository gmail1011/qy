import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_sound/android_encoder.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';



/// Example app.
class SimpleRecorder extends StatefulWidget {
  final Function(String, bool, int) callback;

   SimpleRecorder({Key key, this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SimpleRecorderState();
  }
}

class _SimpleRecorderState extends State<SimpleRecorder> {
  int timerCount = 0;
  String get timerDesc {
    int minInt = timerCount ~/ 60;
    int secInt = timerCount % 60;
    return "${minInt.toString().padLeft(2, "0")}:${secInt.toString().padLeft(2, "0")}";
  }
  t_CODEC _codec = t_CODEC.CODEC_AAC;

  Timer timer;
  String audioRealPath;
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound;

  @override
  void initState() {
    flutterSound = FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      startRecorder();
    });
    super.initState();
  }



  void startRecorder() async{
    try {
      bool isAgree = await Permission.storage.request().isGranted;
      if(!isAgree){
        showToast(msg: "请打开存储权限");
        await openAppSettings();
        widget.callback?.call("", false, 0);
        return;
      }
      timer = Timer.periodic( Duration(seconds: 1), (timer) {
        timerCount++;
        if (timerCount > 60) {
          timer.cancel();
          widget.callback?.call(audioRealPath, false, 60);
        }
        setState(() {});
      });
      setState(() {});
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Directory tempDir = await getTemporaryDirectory();
      String path = await flutterSound.startRecorder(
        uri: '${tempDir.path}/$fileName.aac',
        codec: _codec,
      );
      print('startRecorder: $path');
      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(
            e.currentPosition.toInt(),
            isUtc: true);
        debugLog("r====: ${e.currentPosition.toInt()}");

      });
      _dbPeakSubscription = flutterSound.onRecorderDbPeakChanged.listen((value) {
            print("got update -> $value");
      });

      audioRealPath = path;
      setState(() {});

    } catch (err) {
      print ('startRecorder error: $err');
      audioRealPath = null;
      setState (() {});
    }
  }

  Future stopRecorder() async {
    try {
      String result = await flutterSound.stopRecorder();
      print ('stopRecorder result: $result');

      if ( _recorderSubscription != null ) {
        _recorderSubscription.cancel ();
        _recorderSubscription = null;
      }
      if ( _dbPeakSubscription != null ) {
        _dbPeakSubscription.cancel ();
        _dbPeakSubscription = null;
      }
    } catch ( err ) {
      print ('stopRecorder error: $err');
    }
    setState(() {});

  }


  void startPlayer() async{
    try {
      String path  = await flutterSound.startPlayer(audioRealPath ?? "");
      if (path == null) {
        print ('Error starting player');
        return;
      }
      await flutterSound.setVolume(1.0);

      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
      });
    } catch (err) {
      print('error: $err');
    }
    setState(() {} );
  }

  void stopPlayer() async {
    try {
      String result = await flutterSound.stopPlayer();
      print('stopPlayer: $result');
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }
    } catch (err) {
      print('error: $err');
    }
    this.setState(() {
      //this._isPlaying = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.callback?.call("", false, 0);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.3),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: ()  async{
                  timer?.cancel();
                  await stopRecorder();
                  if (timerCount < 2) {
                    showToast(msg: "语音时间太短, 发送已被取消");
                    widget.callback?.call("", false, 0);
                  } else {
                    widget.callback?.call(audioRealPath, true, timerCount);
                  }
                },
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                         SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                        Container(
                          margin:  EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color:  Color(0xffb74124).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Icon(
                                Icons.mic_none_rounded,
                                size: 32,
                                color: Colors.white,
                              ),
                               SizedBox(height: 8),
                              Text(
                                "点此发送",
                                style:  TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),
              ),
               SizedBox(height: 12),
              Text(
                timerDesc,
                style:  TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
               SizedBox(height: 8),
              InkWell(
                onTap: () async{
                  await stopRecorder();
                  timer?.cancel();
                  widget.callback?.call("", false, 0);
                },
                child: Container(
                  padding:  EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient:  LinearGradient(
                      colors: [
                        Color(0xFFFAF0E6),
                        Color(0xFFaaaaaa),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    border: Border.all(color: Colors.black),
                  ),
                  child:  Text(
                    "取消录制",
                    style:  TextStyle(color: Color(0xff666666), fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {

    super.dispose();
  }
}
