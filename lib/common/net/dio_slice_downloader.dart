import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:path/path.dart' as p;
import 'package:convert/convert.dart';

const String _rangeHeader = "Range";
const String _acceptsRangesHeader = "Accept-Ranges";
const String _etagHeader = "ETag";
const String _contentRangeHeader = "Content-Range";

const int _M = 1024 * 1024;
const int _sliceStep = 2 * _M;
const Duration _readSliceTimeout = Duration(seconds: 60);

class _Chunk {
  final Uint8List data;

  _Chunk(this.data);
}

class DLError extends Error {
  final Object err;

  DLError(this.err);

  String toString() => err?.toString();
}

//校对错误
class CheckSizeError extends DLError {
  CheckSizeError() : super("Check Size failed");
}

//网络错误
class NetworkError extends DLError {
  NetworkError(err) : super(err);
}

// 使用Dio.download时的错误
class DioDLError extends DLError {
  DioDLError(err) : super(err);
}

// 文件系统错误
class FileSystemError extends DLError {
  FileSystemError(err) : super(err);
}

_ddPrint(Object msg) => l.d("oldLog", "[Dio-Downloader] $msg");

class DioSliceDownloader {
  final DioCli cli;
  final String url;
  final String saveDirectory;
  final String dioSaveName;
  final ProgressCallback onReceiveProgress;
  final Map<String, dynamic> headers;
  final Queue<_Chunk> _cached = Queue();
  bool _isWriting = false;
  RandomAccessFile _raf;
  String _remoteETag;
  int _remoteTotalLength = 0;
  int _localInitSavedLength = 0;
  int _localCurrentSavedLength = 0;
  bool _remoteDownloadFinish = false;
  final Completer<String> _downloadCompleter = Completer();

  DioSliceDownloader(
      this.cli, this.url, this.headers, this.saveDirectory, this.dioSaveName,
      {this.onReceiveProgress})
      : assert(url != null),
        assert(saveDirectory != null),
        assert(dioSaveName != null);

  Map<String, dynamic> _fillRangeHeader(int start, int end) {
    final Map<String, dynamic> rangeHeader = {
      _rangeHeader: "bytes=$start-$end"
    };
    if (headers != null) rangeHeader.addAll(headers);
    return rangeHeader;
  }

  // 返回 true OR false， 表示是否支持分片下载
  Future<EData<bool>> _fetchRemoteTotalLength() async {
    final v = await cli.getHeader(url, headers: _fillRangeHeader(0, 0));
    if (v.err != null) return EData(v.err, null);
    final statusCode = v.data.statusCode;
    final remoteHeaders = v.data.headers;
    if (remoteHeaders == null) return EData(null, false); //不支持
    final acceptRanges = remoteHeaders[_acceptsRangesHeader];
    if (acceptRanges == null ||
        acceptRanges.isEmpty ||
        acceptRanges.first != "bytes") return EData(null, false);
    if (statusCode != HttpStatus.partialContent)
      return EData(null, false); //不支持
    final etags = remoteHeaders[_etagHeader];
    if (etags == null || etags.isEmpty)
      return EData(null, false); //没有etag 认为不支持
    final etag = etags.first;
    if (etag == null || etag.isEmpty) return EData(null, false); // etag为空，认为不支持
    final contentRangeHeaders = remoteHeaders[_contentRangeHeader];
    if (contentRangeHeaders == null || contentRangeHeaders.isEmpty)
      return EData(null, false); //不支持
    final contentRangeHeader = contentRangeHeaders.first;
    if (contentRangeHeader == null) return EData(null, false); //不支持
    final temp = contentRangeHeader.split("/");
    if (temp.length != 2) return EData(null, false); //不支持
    final totalLengthStr = temp[1];
    final totalLength = int.tryParse(totalLengthStr);
    if (totalLength == null || totalLength == 0)
      return EData(null, false); //不支持
    _remoteETag = hex.encode(utf8.encode(etag)); //etag中可能有 " 符号，这里统一处理下
    _remoteTotalLength = totalLength;
    _ddPrint("远端etag $etag, 标准化后的etag: $_remoteETag");
    return EData(null, true);
  }

  // 使用断点续传的文件名
  String _getETagSavePath() => p.join(saveDirectory, "$_remoteETag.apk");

  // 使用原始DIO下载的文件名
  String _getDioSavePath() => p.join(saveDirectory, dioSaveName);

  void _closeRAFSync() {
    if (_raf == null) return;
    _raf.closeSync();
    _raf = null;
  }

  _clearAndEnsureApkDirectorySync() {
    final dir = Directory(saveDirectory);
    if (dir.existsSync()) dir.deleteSync(recursive: true);
    dir.createSync(recursive: true);
  }

  int _getLocalCurrentLengthSync() {
    final file = File(_getETagSavePath());
    int length = 0;
    if (file.existsSync()) {
      length = file.lengthSync();
    } else {
      _clearAndEnsureApkDirectorySync();
    }
    _raf = file.openSync(mode: FileMode.writeOnlyAppend);
    return length;
  }

  void _completeDownload({String savePath, DLError error}) {
    syncCall(() => _closeRAFSync());
    if (_downloadCompleter.isCompleted) return;
    if (error == null) {
      assert(savePath != null || savePath != "");
      _downloadCompleter.complete(savePath);
    } else {
      _downloadCompleter.completeError(error);
    }
  }

  Future<String> download() async {
    _ddPrint("开始下载 $url");
    _fetchRemoteTotalLength().then((support) {
      if (support.err != null) {
        _ddPrint("获取远端大小失败 ${support.err}");
        _completeDownload(error: NetworkError(support.err));
        return;
      }
      if (support.data == true) {
        final mb = (_remoteTotalLength / _M).toStringAsFixed(2);
        _ddPrint(
            "远端支持断点下载 文件总大小:${_remoteTotalLength}B(${mb}MB) 文件标识:$_remoteETag");
        try {
          final localCurrentLength = _getLocalCurrentLengthSync();
          _localInitSavedLength = localCurrentLength;
          _localCurrentSavedLength = localCurrentLength;
          _ddPrint("获取本地文件大小成功 已下载:$_localCurrentSavedLength");
        } catch (e) {
          _ddPrint("获取本地文件大小失败 错误 $e");
          _completeDownload(error: FileSystemError(e));
          return;
        }
        _progress();
        if (_localCurrentSavedLength == _remoteTotalLength) {
          _ddPrint("本地文件大小和远端文件大小相等，直接完成下载");
          _completeDownload(savePath: _getETagSavePath());
        } else if (_localCurrentSavedLength > _remoteTotalLength) {
          _ddPrint("本地文件大小大于远端文件大小，清除本地目录");
          syncCall(() => _clearAndEnsureApkDirectorySync());
          _completeDownload(error: CheckSizeError());
        } else {
          _fetchSlice();
        }
      } else {
        _ddPrint("远端不支持断点下载 使用Dio直接下载 ${_getDioSavePath()}");
        //直接调用dio.
        final savePath = _getDioSavePath();
        Dio()
            .download(url, savePath, onReceiveProgress: onReceiveProgress)
            .then((_) {
          _completeDownload(savePath: savePath);
        }).catchError((err) {
          _completeDownload(error: DioDLError(err));
        });
      }
    });
    return _downloadCompleter.future;
  }

  void _progress() {
    if (onReceiveProgress == null) return;
    syncCall(
        () => onReceiveProgress(_localCurrentSavedLength, _remoteTotalLength));
  }

  Future _fetch(int rangeStart, int rangeEnd) async {
    final v = await cli.getStream(url,
        headers: _fillRangeHeader(rangeStart, rangeEnd));
    if (v.err != null) {
      _ddPrint("Dio fetch 获取失败 range:$rangeStart-$rangeEnd err: ${v.err}");
      return EData(v.err, null);
    }
    final completer = Completer();
    final stream = v.data.data.stream;
    stream.timeout(_readSliceTimeout, onTimeout: (sink) {
      sink.addError("Read Stream Timeout");
      sink.close();
    }).listen((data) {
      if (data != null && data.isNotEmpty) _cached.add(_Chunk(data));
      Future.microtask(() => _tryWrite());
    }, onDone: () {
      completer.complete();
    }, onError: (err) {
      _ddPrint("Dio fetch 获取流失败 range:$rangeStart-$rangeEnd err: $err");
      completer.completeError(err);
    }, cancelOnError: true);
    return completer.future;
  }

  void _fetchSlice() async {
    int currentStart = _localInitSavedLength;
    while (true) {
      if (_downloadCompleter.isCompleted) return;
      final start = currentStart;
      final end = start + _sliceStep;
      if (start >= _remoteTotalLength) {
        _ddPrint("片段下载起始位置已大于总长度, 网络下载完成");
        _remoteDownloadFinish = true;
        _tryWrite();
        break;
      }
      _ddPrint("开始下载 $start-$end, 总共$_remoteTotalLength");
      final v = await asyncCall(() => _fetch(start, end));
      if (v.err != null) {
        _ddPrint("错误下载 $start-$end, 总共$_remoteTotalLength err:${v.err}");
        _completeDownload(error: NetworkError(v.err));
        return;
      }
      currentStart = end + 1; //闭区间
    }
  }

  void _tryWrite() async {
    if (_isWriting || _cached.isEmpty || _downloadCompleter.isCompleted) return;
    _isWriting = true;
    final first = _cached.removeFirst();
    final list = List<int>.from(first.data);
    final writeRet = await asyncCall(() => _raf.writeFrom(list));
    if (writeRet.err != null) {
      _ddPrint("写入错误: ${writeRet.err}");
      _completeDownload(error: FileSystemError(writeRet.err));
    } else {
      _localCurrentSavedLength += first.data.length;
      //_ddPrint("写入大小 ${list.length} 当前实际大小:${_raf.lengthSync()} 内存计算大小: $_localCurrentSavedLength");
      if (_remoteDownloadFinish && _cached.isEmpty) {
        try {
          _ddPrint("写入完成 开始刷新磁盘缓存");
          _raf.flushSync();
          _ddPrint("刷新磁盘缓存完成，开始关闭RAF");
          _closeRAFSync();
          _ddPrint("关闭RAF完成，开始检查文件大小");
          //做最后的检查
          final localLength = File(_getETagSavePath()).lengthSync();
          if (localLength != _remoteTotalLength) {
            _ddPrint("检查文件大小失败 local:$localLength, Target:$_remoteTotalLength");
            _clearAndEnsureApkDirectorySync();
            _completeDownload(error: CheckSizeError());
          } else {
            _ddPrint("检查文件大小完成, 下载完成:${_getETagSavePath()} 大小: $localLength");
            _completeDownload(savePath: _getETagSavePath());
          }
        } catch (e) {
          _ddPrint("网络下载完成,磁盘刷新错误 $e");
          _completeDownload(error: FileSystemError(e));
        }
      }
      _progress();
    }
    _isWriting = false;
    _tryWrite();
  }
}

typedef OnRetry = void Function(int retryCount);

class DioSliceRetryDownloader {
  final DioCli cli;
  final String url;
  final Map<String, dynamic> headers;
  final String saveDirectory;
  final String dioSaveName;
  final ProgressCallback onReceiveProgress;
  final int retry;
  final Duration retryInterval;
  final OnRetry onRetry;

  DioSliceRetryDownloader(
      this.cli, this.url, this.headers, this.saveDirectory, this.dioSaveName,
      {this.onReceiveProgress,
      this.retry = 3,
      this.retryInterval = const Duration(seconds: 3),
      this.onRetry})
      : assert(url != null),
        assert(saveDirectory != null),
        assert(dioSaveName != null),
        assert(retry != null);

  Future<String> _download() {
    return DioSliceDownloader(this.cli, this.url, this.headers,
            this.saveDirectory, this.dioSaveName,
            onReceiveProgress: this.onReceiveProgress)
        .download();
  }

  Future<String> download() async {
    int tryCount = 0;
    while (true) {
      tryCount++;
      try {
        return await _download();
      } catch (e) {
        if (tryCount >= retry) rethrow;
        if (onRetry != null) syncCall(() => onRetry(tryCount));
        await Future.delayed(retryInterval);
      }
    }
  }
}
