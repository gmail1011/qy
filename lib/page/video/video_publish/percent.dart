class Percent {
  static double init = 0.4;
  static double video = 0.4;
  static double cover = 0.9;
  static double complete = 1.0;
}

///毫秒
class PercentDuration {
  static int init = 20000;
  static int video = 10000;
  static int cover = 2000;
  static int complete = 1000;
}

setPatchCount1Config() {
  PercentDuration.init = 20000;
}

resetDefaultPercentConfig() {
  PercentDuration.init = 20000;
}