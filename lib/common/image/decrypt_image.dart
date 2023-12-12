import 'dart:typed_data';

import 'package:flutter_base/local_server/local_server.dart';

List<Uint8List> _featuresList = [
  Uint8List.fromList([0xff, 0xd8, 0xff]), //jpg,jpeg
  Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]), //png
  Uint8List.fromList([0x47, 0x49, 0x46]), //gif
];

int _encryptedLen = 100; //加密图片的数据长度
Uint8List _decryptKey = Uint8List.fromList('2019ysapp7527'.codeUnits); //加密key

bool _isEncryptedImage(Uint8List imgBytes) {
  bool isDecrypted = false;
  int _featuresLen = _featuresList.length;
  for (int i = 0; i < _featuresLen; i++) {
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

Uint8List xorBaseAllLength(Uint8List src) {
  var index = -1;
  var dest = Uint8List.fromList(
    src
        .map((it) {
          index++;
          if (index < encryptMagicNumber.length &&
              it == encryptMagicNumber[index]) {
            return null;
          }
          return it ^ ENCRYPT_KEY;
        })
        .where((element) => element != null)
        .toList(),
  );

  return dest;
}

Uint8List xorBaseLength(Uint8List src, Uint8List key, int length) {
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

Uint8List xor(Uint8List src, Uint8List key) {
  return xorBaseLength(src, key, src.length);
}

Uint8List decryptImage(Uint8List imgBytes) {
  if (imgBytes == null || imgBytes.length == 0) {
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
