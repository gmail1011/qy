// ignore_for_file: unrelated_type_equality_checks, constant_identifier_names

import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_base/utils/log.dart';

import 'image_cache_disk_new.dart';

class ImageCrypto {
  static Future<Uint8List> loadAndDecrypt(String path) async {
    BaseOptions options = BaseOptions(
      // connectTimeout: const Duration(seconds: 20),
      // receiveTimeout: const Duration(seconds: 60),
      connectTimeout: 20 * 1000,
      receiveTimeout: 60 * 1000,
      responseType: ResponseType.bytes,
    );
    var url = path;
    Response response;
    try {
      Uint8List imageBytes = await ImageCacheDisk.get(url);
      if (imageBytes == null) {
        response = await Dio(options).get(url);
        imageBytes = Uint8List.fromList(response.data);
        ImageCacheDisk.save(url, response.data);
      }
      var decodeData = decryptImage(imageBytes);
      if (!(url.contains('.gif') || url.contains('.GIF'))) {}
      return decodeData;
    } catch (error) {
      debugLog("图片加载失败：$error");
    } catch (e) {
      // debugLog("dio image error url: $url -> $e");
      return null;
    }
    return null;
  }

  static final List<Uint8List> _featuresList = [
    Uint8List.fromList([0xff, 0xd8, 0xff]), //jpg,jpeg
    Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]), //png
    Uint8List.fromList([0x47, 0x49, 0x46]), //gif
  ];

  /// 加密魔数头
  static const encryptMagicNumber = [0x88, 0xA8, 0x30, 0xCB, 0x10, 0x76];

  /// 加密密钥
  static const ENCRYPT_KEY = 0xA3;
  static const int _encryptedLen = 100; // //加密图片的数据长度
  static final Uint8List _decryptKey =
      Uint8List.fromList('2019ysapp7527'.codeUnits); //加密key

  static Uint8List decryptImage(Uint8List imgBytes) {
    if (imgBytes?.isNotEmpty != true) {
      return imgBytes;
    }
    var isAll = false;
    for (var i = 0; i < encryptMagicNumber.length; i++) {
      if (encryptMagicNumber[i] != imgBytes[i]) {
        continue;
      }
      isAll = true;
    }
    if (isAll) {
      imgBytes = xorBaseAllLength(imgBytes);
    } else {
      if (_isEncryptedImage(imgBytes)) {
        imgBytes = xorBaseLength(imgBytes, _decryptKey, _encryptedLen);
      }
    }
    return imgBytes;
  }

  static bool _isEncryptedImage(Uint8List imgBytes) {
    bool isDecrypted = false;
    int featuresLen = _featuresList.length;
    for (int i = 0; i < featuresLen; i++) {
      isDecrypted = false;
      for (int j = 0; j < _featuresList[i].length; j++) {
        if (_featuresList[i][j] != imgBytes[j]) {
          isDecrypted = true;
          break;
        }
      }
      if (isDecrypted) {
        continue;
      } else {
        break;
      }
    }
    return isDecrypted;
  }

  static Uint8List xorBaseAllLength(Uint8List src) {
    var index = -1;
    int maxInt = double.maxFinite.toInt();
    var dest = Uint8List.fromList(
      src
          .map((it) {
            index++;
            if (index < encryptMagicNumber.length &&
                it == encryptMagicNumber[index]) {
              return maxInt;
            }
            return it ^ ENCRYPT_KEY;
          })
          .where((element) => element != maxInt)
          .toList(),
    );

    return dest;
  }

  static Uint8List xorBaseLength(Uint8List src, Uint8List key, int length) {
    int srcLen = src.length;
    int keyLen = key.length;
    if (length > srcLen || length <= 0) {
      length = srcLen;
    }
    for (var i = 0; i < length; i += keyLen) {
      for (var j = 0; j < keyLen && i + j < length; j++) {
        src[i + j] ^= key[j];
      }
    }
    return src;
  }

  static Uint8List xor(Uint8List src, Uint8List key) {
    return xorBaseLength(src, key, src.length);
  }
}
