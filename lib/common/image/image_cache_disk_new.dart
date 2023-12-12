import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_base/utils/log.dart';
import 'package:path_provider/path_provider.dart';


class ImageCacheDisk {

  static Future<Uint8List> get(String path) async {
    var pathUrl = Uri.tryParse(path);
    String fileName = "";
    if (pathUrl?.path != null) {
      fileName = pathUrl?.path.replaceAll("/", "") ?? "";
    }
    if (fileName.isNotEmpty) {
      String filePath = "${await findSavePath()}/$fileName";
      var imageFile = File(filePath);
      if (imageFile.existsSync()) {
        return imageFile.readAsBytes();
      }
    }
    return null;
  }

  static void save(String path, List<int> fileData) async {
    try {
      if(fileData.length < 2048){
        return;
      }
      var pathUrl = Uri.tryParse(path);
      String fileName = "";
      if (pathUrl?.path != null) {
        fileName = pathUrl?.path.replaceAll("/", "") ?? "";
      }
      if (fileName.isNotEmpty) {
        String filePath = "${await findSavePath()}/$fileName";
        var imageFile = File(filePath);
        if (imageFile.existsSync()) {
          imageFile.deleteSync();
        }
        imageFile.writeAsBytes(fileData, mode: FileMode.write);
      }
    }catch(e){
      debugLog("图片存储失败");
      debugLog(e);
    }
  }

  static Future<String> findSavePath() async {
    final directory = Platform.isAndroid
        ? await getTemporaryDirectory()
        : await getTemporaryDirectory();

    String saveDir = '${directory.path}/cacheImage';
    Directory root = Directory(saveDir);
    if (!root.existsSync()) {
      debugLog(saveDir);
      await root.create();
    }
    return saveDir;
  }

  static Future emptyCache () async {

    //Directory imageCacheDir = Directory(await ImageCacheManager().getFilePath());

    try{
      final directory = Platform.isAndroid
          ? await getTemporaryDirectory()
          : await getTemporaryDirectory();
      String saveDir = '${directory.path}/cacheImage';
      Directory root = Directory(saveDir);

      if (root.existsSync()) {

        await root.delete(recursive: true);

        //showToast(msg: "磁盘图片缓存清理成功");
        // showToast(msg: "磁盘图片缓存清理成功");

      }
    }catch(e){
      debugLog(e);
    }
  }
}