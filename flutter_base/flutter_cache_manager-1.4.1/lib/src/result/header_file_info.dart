import 'dart:io';
import 'file_info.dart';

class HeaderFileInfo extends FileInfo {
  /// tory new add
  Map<String, String> headers;
  HeaderFileInfo(
      File file, FileSource source, DateTime validTill, String originalUrl,
      [this.headers])
      : super(file, source, validTill, originalUrl);
}
