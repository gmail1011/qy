import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class AVCommentaryDetailEntity with JsonConvert<AVCommentaryDetailEntity> {
	String id;
	String title;
	String desc;
	String videoInfo;
	int period;
	String cover;
	String sourceID;
	String sourceURL;
	int price;
	String createdAt;
	String graphic;
	bool isBuy;

	bool isLike;
	bool isFavorites;
	int readCount;
	int likeCount;
	int favoritesCount;
}
