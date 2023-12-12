import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class GameBalanceEntity with JsonConvert<GameBalanceEntity> {
	int wlBalance;
	int wlTransferable;
	int balance;
}
