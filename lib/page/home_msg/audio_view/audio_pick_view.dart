// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_app/page/home_msg/audio_view/simple_recorder.dart';

class AudioPickerView extends StatefulWidget {
  final Widget child;
  final Function(String, int) callback;

  const AudioPickerView({
    Key key,
    this.child,
    this.callback,
  }): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AudioPickerViewState();
  }
}

class _AudioPickerViewState extends State<AudioPickerView> {
  @override
  void initState() {
    super.initState();
  }

  void sendAudioMsg(String filePath, int timeCount) async {
    widget.callback?.call(filePath, timeCount);
  }

  void _pickerEvent() async {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleRecorder(
            callback: (filePath, isSend, seconds) {
              Navigator.pop(context);
              if (isSend == false && filePath.isNotEmpty) {
                _showAlert(filePath, seconds);
              } else if (filePath.isNotEmpty) {
                sendAudioMsg(filePath, seconds);
              }
            },
          );
        });
  }

  void _showAlert(String filePath, int timeCount) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Material(
          color: Colors.black.withOpacity(0.3),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 54),
                      child:  Text(
                        "已超过最长录音时间上限，录音已自动停止，需要发送吗",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                              ),
                              child:  Text(
                                "取消",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              sendAudioMsg(filePath, timeCount);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                              ),
                              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                              child:  Text(
                                "发送",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickerEvent,
      child: widget.child,
    );
  }
}
