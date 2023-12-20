// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:flutter_base/flutter_base.dart';
// import 'package:flutter_base/utils/toast_util.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
//
//
// /// Example app.
// class SimpleRecorder extends StatefulWidget {
//   final Function(String, bool, int) callback;
//
//    SimpleRecorder({Key key, this.callback}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() {
//     return _SimpleRecorderState();
//   }
// }
//
// class _SimpleRecorderState extends State<SimpleRecorder> {
//   int timerCount = 0;
//   int get maxSec => 10;
//   String get timerDesc {
//     int minInt = timerCount ~/ 60;
//     int secInt = timerCount % 60;
//     return "${minInt.toString().padLeft(2, "0")}:${secInt.toString().padLeft(2, "0")}";
//   }
//   Timer timer;
//   String get audioRealPath {
//     return "$_basePath/$fileName";
//   }
//   Codec _codec = Codec.pcm16WAV;
//   String fileName = 'tau_file.wav';
//   String _basePath = "";
//   FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
//   FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
//
//   @override
//   void initState() {
//     fileName = '${DateTime.now().millisecondsSinceEpoch}tau_file.wav';
//     _mPlayer.openAudioSession();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
//       statusInit();
//     });
//     super.initState();
//   }
//
//   void statusInit() async {
//     if(Platform.isIOS) {
//       Directory directory = await getTemporaryDirectory();
//       _basePath = directory.path;
//     }else {
//       final directory = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
//       _basePath = '${directory.path}/audioIM';
//     }
//     bool isAgree = await Permission.storage.request().isGranted;
//     if(!isAgree){
//       showToast(msg: "请打开存储权限");
//       await openAppSettings();
//       return;
//     }
//     String saveDir = _basePath;
//     Directory root = Directory(saveDir);
//
//     if (!root.existsSync()) {
//       await root.create();
//     }
//     await openTheRecorder();
//     await _mRecorder.startRecorder(
//       toFile: audioRealPath,
//       codec: _codec,
//     );
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       timerCount++;
//       if (timerCount > maxSec) {
//         timer.cancel();
//         widget.callback?.call(audioRealPath, false, maxSec);
//       }
//       setState(() {});
//     });
//     setState(() {});
//   }
//
//   Future<void> openTheRecorder() async {
//     if (!kIsWeb) {
//       var status = await Permission.microphone.request();
//       if (status != PermissionStatus.granted) {
//         throw RecordingPermissionException('Microphone permission not granted');
//       }
//     }
//     await _mRecorder.openAudioSession();
//   }
//
//   Future stopRecorder() async {
//     await _mRecorder.stopRecorder();
//   }
//
//   void startPlayer() async{
//     _mPlayer.startPlayer(fromURI: audioRealPath);
//   }
//
//   void stopPlayer() async {
//     _mPlayer.stopPlayer();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         widget.callback?.call("", false, 0);
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black.withOpacity(0.3),
//         body: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               InkWell(
//                 onTap: ()  async{
//                   timer?.cancel();
//                   await stopRecorder();
//                   if (timerCount < 2) {
//                     showToast(msg: "语音时间太短, 发送已被取消");
//                     widget.callback?.call("", false, 0);
//                   } else {
//                     widget.callback?.call(audioRealPath, true, timerCount);
//                   }
//                 },
//                 child: SizedBox(
//                     width: 100,
//                     height: 100,
//                     child: Stack(
//                       fit: StackFit.expand,
//                       children: [
//                          SizedBox(
//                           width: 100,
//                           height: 100,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                           ),
//                         ),
//                         Container(
//                           margin:  EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             color:  Color(0xffb74124).withOpacity(0.9),
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                                Icon(
//                                 Icons.mic_none_rounded,
//                                 size: 32,
//                                 color: Colors.white,
//                               ),
//                                SizedBox(height: 8),
//                               Text(
//                                 "点此发送",
//                                 style:  TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                 ),
//               ),
//                SizedBox(height: 12),
//               Text(
//                 timerDesc,
//                 style:  TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                 ),
//               ),
//                SizedBox(height: 8),
//               InkWell(
//                 onTap: () async{
//                   await stopRecorder();
//                   timer?.cancel();
//                   widget.callback?.call("", false, 0);
//                 },
//                 child: Container(
//                   padding:  EdgeInsets.fromLTRB(16, 8, 16, 8),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     gradient:  LinearGradient(
//                       colors: [
//                         Color(0xFFFAF0E6),
//                         Color(0xFFaaaaaa),
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                     border: Border.all(color: Colors.black),
//                   ),
//                   child:  Text(
//                     "取消录制",
//                     style:  TextStyle(color: Color(0xff666666), fontSize: 14),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _mPlayer.closeAudioSession();
//     _mPlayer = null;
//
//     _mRecorder.closeAudioSession();
//     _mRecorder = null;
//     super.dispose();
//   }
// }
