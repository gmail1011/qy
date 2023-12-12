part of 'view.dart';

/// 没有版本更新提示
Future<String> showNotUpgradeDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.only(top: Dimens.pt17),
          width: Dimens.pt284,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: CustomEdgeInsets.only(left: 26, right: 26),
                  child: Text(
                    Lang.TIP,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimens.pt18,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: Dimens.pt8, left: Dimens.pt26, right: Dimens.pt26),
                  child: Theme(
                    data: ThemeData(
                        primaryColor: Color(0xffD8D8D8),
                        hintColor: Color(0xffD8D8D8)),
                    child: Text(
                      Lang.NOT_UPGRADE,
                      style:
                          TextStyle(fontSize: Dimens.pt16, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: Dimens.pt30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: Dimens.pt40,
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Color(0xffD8D8D8),
                                          width: Dimens.pt1))),
                              child: FlatButton(
                                highlightColor: Color(0xffffffff),
                                child: Text(
                                  Lang.SURE,
                                ),
                                onPressed: () {
                                  safePopPage();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
