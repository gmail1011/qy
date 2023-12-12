import 'package:flutter/cupertino.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';

typedef TabPicture = Function(int index);

///自定义九宫格图片
class CustomNinePicture extends StatelessWidget {

  ///是否需要高斯模糊
  final bool isGauss;

  final List<String> pictureList;

  final BorderRadius picRadius;

  CustomNinePicture({Key key, @required this.pictureList, this.isGauss = false, this.picRadius})
      : super(key: key) {
    assert(pictureList.length >= 1);
  }

  @override
  Widget build(BuildContext context) {
    double picWidth, picHeight;
    int rowItemCount;
    int len = pictureList.length;
    //只有一张图片时
    if (len == 1) {
      rowItemCount = 1;
      picWidth = Dimens.pt340;
      picHeight = Dimens.pt200;
    } else if (len == 2 || len == 4) {
      rowItemCount = 2;
      picWidth = (Dimens.pt360 - Dimens.pt4 * 3) / 2;
      picHeight = picWidth;
    } else {
      rowItemCount = 3;
      picWidth = (Dimens.pt360 - Dimens.pt4 * 3) / 3;
      picHeight = picWidth;
    }
    List<Widget> picWidgetList = [];
    for (int i = 0; i < len; i++) {
      String imgPath = pictureList[i];
      picWidgetList.add(getPictureItem(imgPath, i, picWidth, picHeight));
    }

    return GridView(
      padding: EdgeInsets.only(top: 0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: picWidth / picHeight,
        crossAxisCount: rowItemCount,
        mainAxisSpacing: Dimens.pt4,
        crossAxisSpacing: Dimens.pt5,//横轴三个子widget/宽高比为1时，子widget
      ),
      children: picWidgetList,
    );
  }

  ///获取图片ITEM
  Widget getPictureItem(String imgPath, int index, double picWidth, double picHeight) {
    return Container(
      width: picWidth,
      height: picHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: CustomNetworkImage(
          imageUrl: imgPath,
          fit: BoxFit.cover,
          type: ImgType.cover,
          isGauss: isGauss,
          width: picWidth,
          height: picHeight,
        ),
      ),
    );
  }
}
