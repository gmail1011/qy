import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/common/image/image_manager_new.dart';
import 'package:flutter_base/local_server/video_cache_manager.dart';
import 'package:flutter_base/utils/file_util.dart';

///加载缓存 统计缓存大小
Future<String> loadCache() async {
  double total = 0;
  Directory videoCacheDir = Directory(await VideoCacheManager().getFilePath());
  if (await videoCacheDir.exists()) {
    total += await _getTotalSizeOfFilesInDir(videoCacheDir);
  }

  // Directory videoSubCacheDir =
  //     Directory(await VideoSubCacheManager().getFilePath());
  // if (await videoSubCacheDir.exists()) {
  //   total += await _getTotalSizeOfFilesInDir(videoSubCacheDir);
  // }

  Directory imageCacheDir = Directory(await ImageCacheManager().getFilePath());
  if (await imageCacheDir.exists()) {
    total += await _getTotalSizeOfFilesInDir(imageCacheDir);
  }
  return FileUtil.byteFmt(total.toInt());
}


Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
  if (file == null) return 0;
  if (file is File) {
    int length = await file.length();
    return double.parse(length.toString());
  }
  try {
    if (file is Directory) {
      double total = 0;
      final isExists = await file.exists();
      if (isExists) {
        final List<FileSystemEntity> children = file.listSync(recursive: true);
        if (children != null) {
          for (final FileSystemEntity child in children) {
            total += await _getTotalSizeOfFilesInDir(child);
          }
        }
      }
      return total;
    }
  } catch (e) {
    return 0;
  }
  return 0;
}

/// 清除缓存如果必要
/// [force] 强至清除
Future clearCacheIfNeed({bool force = false}) async {
  if (force) {
    await VideoCacheManager().emptyCache();
    // await VideoSubCacheManager().emptyCache();
    // CachedVideoStore().clean();
    await ImageCacheManager().emptyCache();
  } else {
    double total = 0;
    Directory videoCacheDir =
        Directory(await VideoCacheManager().getFilePath());
    if (await videoCacheDir.exists()) {
      total += await _getTotalSizeOfFilesInDir(videoCacheDir);
    }
    //ts流最大2M，应该是>1000个ts流
    if (total > 500 * MB_SIZE) {
      await VideoCacheManager().emptyCache();
    }
    total = 0;
    Directory imageCacheDir =
        Directory(await ImageCacheManager().getFilePath());
    if (await imageCacheDir.exists()) {
      total += await _getTotalSizeOfFilesInDir(imageCacheDir);
    }
    //按照100Kb一张图片的化，估计是5000张网络图片
    if (total > 500 * MB_SIZE) {
      await ImageCacheManager().emptyCache();
    }
  }
}


///递归方式删除目录
Future<Null> delDir(FileSystemEntity file) async {
  try {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await delDir(child);
      }
    }
    await file.delete();
  } catch (e) {}
}


clearAllCache() async {
  ImageManager.instance.clearBySize(maxSize: 30);
  PaintingBinding.instance.imageCache.clear();
  PaintingBinding.instance.imageCache.clearLiveImages();
  ImageCacheManager()?.store?.emptyMemoryCache();
  ImageCache()?.clearLiveImages();
  debugPrint(" ----------- PaintingBinding.instance.imageCache.clearLiveImages()");
}
