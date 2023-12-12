import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class TaskCenterData with JsonConvert<TaskCenterData> {
  List<TaskCenterDataTaskList> taskList;
}

class TaskCenterDataTaskList with JsonConvert<TaskCenterDataTaskList> {
  String id;
  String title;
  String desc;
  List<int> userAward;
  int finishCondition;
  int finishValue;
  int status;
  int boonType;
  String image;
}
