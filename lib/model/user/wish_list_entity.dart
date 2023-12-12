import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class WishListData with JsonConvert<WishListData> {
	bool hasNext;
	@JSONField(name: "list")
	List<WishListDataList> xList;
}

class WishListDataList with JsonConvert<WishListDataList> {
	String id;
	int uid;
	String question;
	List<dynamic> images;
	int bountyGold;
	int lookCount;
	String createdAt;
	bool isAdoption;
	String adoptionCmtId;
}
