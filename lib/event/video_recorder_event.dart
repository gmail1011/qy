class VideoRecorderEvent {
  int isStartRecorder;///0:开始录制   1：停止录制  2：重新录制
  int timeTag;

  VideoRecorderEvent(this.isStartRecorder, this.timeTag);
}
