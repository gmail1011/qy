import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/model/vote/VoteItemModel.dart';

class ActivityEntity with JsonConvert<ActivityEntity> {
	int code;
	ActivityData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class ActivityData with JsonConvert<ActivityData> {
	int total;
	@JSONField(name: "list")
	List<ActivityDataList> xList;
}

class ActivityDataList with JsonConvert<ActivityDataList> {
	String id;
	String title;
	String content;
	String cover;
	String href;
	int type;
	String time;
	bool isVote;
	VoteItemModel voteItemModel;
}
