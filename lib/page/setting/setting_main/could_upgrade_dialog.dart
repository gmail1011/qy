part of 'view.dart';

/// 版本可更新提示
Future<String> showUpgradeDialog(
    BuildContext context, String version, CheckVersionBean versionBean) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: CustomEdgeInsets.only(top: 16),
          width: Dimens.pt284,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: CustomEdgeInsets.only(left: 21),
                child: Align(
                  alignment: Alignment.centerLeft,
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
              Padding(
                padding: CustomEdgeInsets.only(top: 8, left: 21, right: 16),
                child: Theme(
                  data: ThemeData(
                      primaryColor: Color(0xffD8D8D8),
                      hintColor: Color(0xffD8D8D8)),
                  child: Text(
                    Lang.COULD_UPGRADE.replaceAll('placeHolder', version),
                    style:
                        TextStyle(fontSize: Dimens.pt16, color: Colors.black),
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
                      padding: CustomEdgeInsets.only(top: 10),
                      child: Row(
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
                                    width: Dimens.pt1),
                              )),
                              child: FlatButton(
                                highlightColor: Color(0xffffffff),
                                child: Text(
                                  Lang.cancel,
                                ),
                                onPressed: () =>
                                    safePopPage(null),
                              ),
                            ),
                          ),
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
                                  Lang.UPDATE_TITLE,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return UpdateDialog(
                                            updateInfo: versionBean);
                                      }).then((onValue) {
                                    safePopPage(null);
                                  });
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
