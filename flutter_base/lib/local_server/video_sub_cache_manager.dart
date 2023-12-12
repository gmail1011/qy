import 'package:flutter_base/local_server/dio_file_service.dart';
import 'package:flutter_base/utils/misc_util.dart';
import 'package:my_flutter_cache_manager/my_flutter_cache_manager.dart';
import 'package:path/path.dart' as path;

/// 视频缓存
class VideoSubCacheManager extends BaseCacheManager {
  static const key = "videoSubCache";

  static VideoSubCacheManager _instance;

  factory VideoSubCacheManager({FileService fileService}) {
    if (_instance == null) {
      _instance = VideoSubCacheManager._(fileService: fileService);
    }
    return _instance;
  }

  /// 这里可以构建一个文件fileFetch
  VideoSubCacheManager._({FileService fileService})
      : super(key,
            maxAgeCacheObject: Duration(days: 100),
            maxNrOfCacheObjects: 1000,
            fileService: DioFileService());

  /// 缓存存储路径
  Future<String> getFilePath() async {
    var dir = await MiscUtil.getCommonDir();
    return path.join(dir.path, key);
  }
}
