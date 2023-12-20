import 'dart:async';
import 'package:chat_online_customers/chat_widget/chat_core/network/utils/file_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';

// ignore: non_constant_identifier_names
final sound_helper = Sound.create();

class Sound {
  FlutterSound _flutterSound;
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  StreamSubscription _playerSubscription;
  String _recorderTime;

  String get recorderTime => _recorderTime;
  bool get isPlaying => _flutterSound?.thePlayer?.playerState == PlayerState.isPlaying;
  bool  isRecording = false;

  Sound.create() {
    _flutterSound = FlutterSound();
    
    initializeDateFormatting();
  }

  // 返回录制文件的存放路径
  Future<String> startRecorder(ValueChanged time, {ValueChanged dbPeak}) async {

    var ret = '';
    // if (isRecording) {
    //   return ret;
    // }
    //
    // try {
    //   var d = DateTime.now();
    //   var name = d.millisecondsSinceEpoch.toString();
    //   var uri = await fileMgr.getRootPath() + '/' + '$name.aac';
    //   var path = await _flutterSound.startRecorder(
    //     uri: uri,
    //       codec: t_CODEC.CODEC_AAC);
    //   print('startRecorder: $path');
    //
    //   _recorderTime = '00:00';
    //   _recorderSubscription = _flutterSound.onRecorderStateChanged.listen((e) {
    //     // var date = DateTime.fromMillisecondsSinceEpoch(
    //     //     e.currentPosition.toInt(),
    //     //     isUtc: true);
    //
    //     // _recorderTime = DateFormat('ss', 'en_GB').format(date);
    //     // print('++++++++_recorderTime++++++++++++$_recorderTime');
    //     var da = DateTime.now();
    //     var difference = da.difference(d);
    //     if (time != null) {
    //       time(difference.inSeconds);
    //     }
    //   });
    //
    //   _dbPeakSubscription =
    //       _flutterSound.onRecorderDbPeakChanged.listen((value) {
    //     print("got update -> $value");
    //     if (time != null) {
    //       dbPeak(value);
    //     }
    //   });
    //
    //   ret = path;
    // } catch (err) {
    //   print('startRecorder error: $err');
    // }
    return ret;
  }

  void stopRecorder() async {
    try {
      var result="";
      if(isRecording){
       // result = await _flutterSound.stopRecorder();
      }

      print('stopRecorder: $result record_time: $_recorderTime');
      if (_recorderSubscription != null) {
        await _recorderSubscription.cancel();
        _recorderSubscription = null;
      }
      if (_dbPeakSubscription != null) {
        await _dbPeakSubscription.cancel();
        _dbPeakSubscription = null;
      }
    } catch (err) {
      print('stopRecorder error: $err');
    } finally {}
  }

   void startPlayer(String sound, [ValueChanged<double> onProgress]) async {
    if (isPlaying) {
      print('playing can\'t start new player');
      return;
    }

    var path = await _flutterSound.thePlayer.startPlayer(fromURI: sound);
    // await _flutterSound.setVolume(1.0);
    print('startPlayer()...: $path');

    // _playerSubscription = _flutterSound.thePlayer.onPlayerStateChanged.listen((status) {
    //   if (status == null) return;
    //   var currentPosition = status.currentPosition;
    //   var maxDuration = status.duration;
    //
    //   if (null != onProgress) {
    //     onProgress(currentPosition / maxDuration);
    //   }
    // });
  }

  Future<bool> stopPlayer() async {
    try {
      var result = await _flutterSound.thePlayer.stopPlayer();
    //  print('stopPlayer: $result');
      if (_playerSubscription != null) {
        await _playerSubscription.cancel();
        _playerSubscription = null;
      }
    } catch (err) {
      print('error: $err');
      return false;
    }
    return true;
  }

  void pausePlayer() async {
    var result = await _flutterSound.thePlayer.pausePlayer();
   // print('pausePlayer: $result');
  }

  void resumePlayer() async {
    var result = await _flutterSound.thePlayer.resumePlayer();
   // print('resumePlayer: $result');
  }

  void seekToPlayer(int milliSecs) async {
    var result = await _flutterSound.thePlayer.seekToPlayer(Duration(milliseconds: milliSecs));
   // print('seekToPlayer: $result');
  }
}
