import 'package:flutter/material.dart';

class AppColors {
  /// 无背景的一级字体颜色 #0xff333333
  static const Color mainTextColor33 = Color(0xFF333333);

  /// 无背景的二级字体颜色 #0xff666666
  static const Color subTextColor66 = Color(0xFF666666);

  /// 提示颜色，一般是输入框hint #0xFF999999
  static const Color tipTextColor99 = Color(0xFF999999);

  /// 金色button上的颜色 #0xFF917950
  static const Color textColorGoldRised = Color(0xFF917950);

  /// 有背景色的白色字体 white
  static const Color textColorWhite = Colors.white;

  /// 基本色，背景色 0xFF151515 0xFF191D26
  static const Color primaryColor = Color.fromRGBO(21, 21, 21, 1);

  static const Color primaryTextColor = Color(0xff3b85f7);


  // static const Color primaryColor = Colors.black;

  static const Color itemBgWhite = Colors.white;

  /// 背景色 #0xff12131C Color(0xFF191C61)
  /// scaffold背景色 #0xff12131C
  static Color backgroundColor = Color(0xff12131C);

  /// 视频的背景色 黑色
  static const Color videoBackgroundColor = Colors.black;

  static const Color mineBackgroundColor = Color(0xFF151515);
  static const Color lightBlack = Color(0xFF222222);

  // #0xFF3A3A44 disable color
  static const Color primaryDisable = Color(0xFF3A3A44);

  // #0xFF3A3A44 disable color
  static const Color divideColor = Color(0xFF3A3A44);

  /// 主板色，凸出部分/前景色，主凸板色#0xFFFF00A9
  //static const Color primaryRaised = Color(0xFFFF00A9);
  static const Color primaryRaised = Color.fromRGBO(245, 68, 4, 1);

  //static const Color primaryRaised = Color.fromRGBO(144, 185, 255, 1);

  /// 主板色，凸出部分/前景色，备用凸板色金色 #0xFFFFE0A9
  static const Color primaryRaisedGold = Color(0xFFFFE0A9);
  static const Color userDesTextColor = Color(0xFF777c88);
  static const Color userItemColor = Color(0xFF202020);
  static const Color userVipTextColor = Color(0xff724d1e);
  static const Color userVipSubTextColor = Color(0xFF8D5526);
  static const Color userPumpkinOrangeColor = Color(0xFFFF7600);
  static const Color userPayTextColor = Color(0xFFE3E3E3);
  static const Color userBoutiqueAppTextColor = Color(0xFF545663);
  static const Color userMakeBgColor = Color(0xFF1C1C1C);
  static const Color userMakeMoreTextColor = Color(0xFFFD7F10);
  static const Color userCertificationTextColor = Color(0xFFFD7F0F);
  static const Color userTaskCenterSubTextColor = Color(0xFF4E586E);
  static const Color userFavoriteTextColor = Color(0xFF313131);
  static const Color userVIPBgColor = Color(0xFF727272);
  static const Color userGoldCoinColor = Color(0xFFF6D85D);
  static const Color userWalletBgColor = Color.fromRGBO(36, 36, 36, 1);
  static const Color userVIPbackgroundColor = Color.fromRGBO(221, 165, 109, 1);

  /// 主板色，凸出部分/前景色带渐变，主凸板色 #0xFFF203FF-0xFFFF00A9
  static const primaryRaiseds = <Color>[
    Color.fromRGBO(245, 22, 78, 1),
    Color.fromRGBO(255, 101, 56, 1),
    Color.fromRGBO(245, 68, 4, 1)
  ];

  /// 主板色，凸出部分/前景色带渐变，备用凸板色 #0xFFFFF2D8-0xFFFFE0A9
  static const primaryRaisedGolds = <Color>[Color(0xFFFFF2D8), primaryRaisedGold];

  /// 背景渐变颜色#0xFF232764-#0xFF1F2255
  //static const primaryBgs = <Color>[Color(0xFF232764), Color(0xFF1F2255)];

  static const primaryBgs = <Color>[Colors.black, Colors.black];

  // 28%透明都黑色   #0x48000000
  static const Color black28 = Color(0x48000000);

  // 彩虹色色池
  static const rainbows = <Color>[
    // 红色
    Color(0xFFFF0000),
    // 橙色
    Color(0xFFFF7F00),
    // 黄色
    Color(0xFFFFFF00),
    // 绿色
    Color(0xFF00FF00),
    // 青色
    Color(0xFF00FFFF),
    // 蓝色
    Color(0xFF0000FF),
    // 紫色
    Color(0xFF8B00FF),
  ];
  static const red = <Color>[
    Color(0xFFF5164E),
    Color(0xFFFF6538),
    Color(0xFFF54404),
    // Colors.red[700]
  ];

  static const buttonBlue = <Color>[
    Color.fromRGBO(144, 185, 255, 1),
    Color.fromRGBO(137, 217, 255, 1),
  ];

  static const buttonWeiBo = <Color>[AppColors.primaryTextColor, AppColors.primaryTextColor,];

  static const buttonRed = <Color>[
    Color.fromRGBO(222, 173, 252, 1),
    Color.fromRGBO(246, 168, 200, 1),
  ];

  static const vipBackgroundColors = <Color>[
    Color(0xFFD17E21),
    Color(0xFFD69626),
  ];

  // static const vipSubmitBtnColors = <Color>[
  //   Color(0xFFFE7F0F),
  //   Color(0xFFEA8B25),
  // ];
  static const vipSubmitBtnColors = <Color>[AppColors.primaryTextColor, AppColors.primaryTextColor,];

  static const Color weiboJianPrimaryBackground = Color.fromRGBO(36, 36, 36, 1);
  static const Color weiboBackgroundColor = Color.fromRGBO(36, 36, 36, 1);
  static const Color weiboColor = primaryTextColor;
  static const linearColorPrimary = <Color>[
    Color.fromRGBO(255, 127, 15, 1),
    Color.fromRGBO(227, 136, 37, 1),
  ];
  static const linearColorPrimaryOpacity = <Color>[
    Color.fromRGBO(255, 127, 15, 0.5),
    Color.fromRGBO(227, 136, 37, 0.5),
  ];

  static const taskCenterLineColors = <Color>[
    Color(0xFFFF7F0F),
    Color(0xFFE38825),
  ];
  static const goldCoinTgColors = <Color>[
    Color(0xFFf7e661),
    Color(0xFFf5864b),
  ];

  // static const payBackgroundColors = <Color>[
  //   Color(0xFFffebd9),
  //   Color(0xFFffffff),
  // ];
  static const payBackgroundColors = <Color>[
    AppColors.primaryTextColor,
    Color.fromRGBO(255, 255, 255, 1),
  ];




  static LinearGradient linearBackGround =  LinearGradient(
    begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        AppColors.primaryTextColor,
        AppColors.primaryTextColor,
  ]);

  static const Color withdrawsubTextColor = Color(0xFF7EA0BE);
  static const Color publishTextColor = Color(0xFF5D6472);
  static const Color publishBorderColor = Color(0xFF2C303A);
  static const Color recommentSubTextColor = Color(0xFF7C879F);
  static const Color bandingPhoneBgTextColor = Color(0xFF1F1F1F);
  static const Color accountTextColor = Color(0xFFE57310);
  static const Color videoSubTextColor = Color(0xFF7F8A9B);
  static const Color videoFucTextColor = Color(0xFFA4AEC1);
  static const Color paySubTextColor = Color(0xFFA3A3A3);
  static const shareButtonBgColors = <Color>[
    Color(0xFFFAC790),
    Color(0xFFFBE1BE),
  ];
}
