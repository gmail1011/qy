import 'dart:io';

import 'package:path_provider/path_provider.dart';

final fileMgr = FileManager();

class FileManager {
  Future<String> getRootPath() async {
    // String dir = (await getTemporaryDirectory()).path;
    Directory tempDir = await getTemporaryDirectory();
    return tempDir.path;
  }

  ///创建文件夹
  Future<String> createDir(String path) async {
    try {
      String root = await getRootPath();
      String dirPath = root + '/' + path;
      var directory = Directory(dirPath);
      if (await directory.exists()) {
      } else {
        await directory.create();
      }
      return dirPath;
    } on FileSystemException {
      return '';
    }
  }

  ///创建文件
  Future<String> createFile(String path) async {
    try {
      String root = await getRootPath();
      String filePath = root + '/' + path;
      var file = File(filePath);
      if (await file.exists()) {
      } else {
        await file.create();
      }
      return filePath;
    } on FileSystemException {
      return '';
    }
  }

Future<List> getAllFileFromDir(String path) async{
  try {
    var directory =  Directory(path);
      if (await directory.exists()) {
        var fileArr = directory.listSync();
        return fileArr is List ? fileArr : List();
      } else {
        return List();
      }
    } on FileSystemException {
      return List();
    }
}
  ///判断当是什么手机
  bool isIosDevice() {
    if (Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }
}

class RootPath {
  static const String voice = '/voice_dir';
}
