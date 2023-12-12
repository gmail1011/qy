part of 'view.dart';

/// 编辑性别
Future<String> showEditGenderDialog(EditUserInfoState state, Dispatch dispatch,
    ViewService viewService, gender) {
  Widget _getItem(String text) {
    return Align(
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        width: double.infinity,
        height: Dimens.pt60,
        child: Text(
          text ?? '',
          style: TextStyle(
            color: Color(0xff363636),
            fontSize: Dimens.pt18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  return showModalBottomSheet(
      context: viewService.context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimens.pt17),
        topRight: Radius.circular(Dimens.pt17),
      )),
      builder: (BuildContext context) {
        return Container(
          width: Dimens.pt284,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: () => safePopPage('male'),
                  child: _getItem(Lang.MALE),
                ),
              ),
              Divider(
                height: Dimens.pt1,
                color: Color.fromRGBO(0, 0, 0, 0.2),
              ),
              Center(
                child: GestureDetector(
                  onTap: () => safePopPage('female'),
                  child: _getItem(Lang.FEMALE),
                ),
              ),
              Divider(
                height: Dimens.pt1,
                color: Color.fromRGBO(0, 0, 0, 0.2),
              ),
              Center(
                child: GestureDetector(
                  onTap: () => safePopPage(""),
                  child: _getItem("不显示"),
                ),
              ),
              Divider(
                height: Dimens.pt1,
                color: Color.fromRGBO(0, 0, 0, 0.2),
              ),
              Center(
                child: GestureDetector(
                  onTap: () => safePopPage(null),
                  child: _getItem(Lang.cancel),
                ),
              ),
            ],
          ),
        );
      });
}
