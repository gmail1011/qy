

class PostVideoLogic {

  static final List<Function(int,bool)> _playListernArr = [];

  static void addListener(Function(int,bool) item) {
    _playListernArr.add(item);
  }

  static void removeListener(Function(int,bool) item) {
    _playListernArr.remove(item);
  }

  static void pauseAll() {
    playingIndex = -1;
    for (var item in _playListernArr) {
      item(-1, false);
    }
  }
  static int  playingIndex = -1;
  static void play(int index) {
    playingIndex = index;
    for (var item in _playListernArr) {
      item(index, true);
    }
  }
}