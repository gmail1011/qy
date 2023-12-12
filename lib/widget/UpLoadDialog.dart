import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/tasks/video_upload_task.dart';
import 'package:flutter_app/page/video/video_publish/upload_video_model.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/task_manager/task_manager.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart' as Dio;

class UpLoadDialog extends StatefulWidget {
  String taskid;
  UploadVideoModel uploadModel;

  UpLoadDialog(
      this.taskid,
      this.uploadModel,
      );

  @override
  State<StatefulWidget> createState() => _UpLoadDialogDialogState();
}

class _UpLoadDialogDialogState extends State<UpLoadDialog> {
  bool isPublish = false;
  StreamController<double> _percentStreamController =
      StreamController.broadcast();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uploadVideo();
  }

  void uploadVideo() async{
    taskManager.addTaskToQueue(VideoUploadTask(
      widget.uploadModel,
      taskId: widget.taskid,
      updateListener: (values, {isSuccess, msg}) {
        // print("上传进度----------" + double.parse(values.toStringAsFixed(1)).toString());
        // print("isSuccess----------" + isSuccess.toString());

        if (msg == "上传失败") {
          safePopPage(false);
          return;
        }
        if(msg is Dio.DioError){
          safePopPage(msg);
          return;
        }
        if (mounted) {
          _percentStreamController.add(values);
        }
      },
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _percentStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      //height: 1.sh + 30.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.black.withOpacity(0.3),),
      child: _buildContent(context),
    );
  }


  Widget _buildContent(BuildContext context) {
    return WillPopScope(
            child: Container(
              child: StreamBuilder<double>(
                  initialData: 0.0,
                  stream: _percentStreamController.stream,
                  builder: (context, snapshot) {
                    //进度条有弧度
                    return CircularPercentIndicator(
                      radius: 95.0,
                      lineWidth: 6.0,
                      animation: true,
                      animateFromLastPercent: true,
                      percent: snapshot.data,
                      center: new Text(
                        (snapshot.data * 100).toStringAsFixed(0) + "%",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.white),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.5),
                      onAnimationEnd: () {
                        if (snapshot.data * 100 == 100) {
                          setState(() {
                           // widget.isUploadSuccess = true;

                            safePopPage(true);
                          });
                        }
                      },
                    );
                  }),
            ),
            onWillPop: () {
              return Future.value(false);
            });
  }


  _buildBar(context) => Row(
        children: <Widget>[
          Spacer(),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 30.h,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 10, top: 5),
              /*child:  Icon(
            Icons.close,
            color:Theme.of(context).primaryColor,
          ),*/
              child: SizedBox.shrink(),
            ),
          ),
        ],
      );
}
