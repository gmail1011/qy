import 'dart:async';
import 'dart:convert';

import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/model/audiobook_model.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/text_util.dart';

const _KEY_AUDIO_RECORD = "_key_audio_record${Config.DEBUG}";
const _MAX_CACHE_COUNT = 50;

// 本地有声小说记录
class LocalAudioStore {
  static LocalAudioStore _instance;
  factory LocalAudioStore() {
    if (_instance == null) {
      _instance = LocalAudioStore._();
    }
    return _instance;
  }
  LocalAudioStore._() {
    _loadDataInner();
  }

  Completer<List<AudioEpisodeRecord>> _loadCompleter;
//total 缓存列表
  List<AudioEpisodeRecord> _cachedAudios = [];

  /// 内部加载数据
  Future<List<AudioEpisodeRecord>> _loadDataInner() async {
    if (ArrayUtil.isNotEmpty(_cachedAudios)) return _cachedAudios;
    if (null == _loadCompleter) {
      _loadCompleter = Completer();
      () async {
        // await Future.delayed(Duration(microseconds: 500));
        var s = await lightKV.getString(_KEY_AUDIO_RECORD);
        try {
          if (TextUtil.isNotEmpty(s)) {
            _cachedAudios = (json.decode(s) as List)
                ?.map((it) => AudioEpisodeRecord.fromJson(it))
                ?.toList();
          }
        } catch (_) {}
        _loadCompleter?.complete(_cachedAudios);
        _loadCompleter = null;
      }();
    }
    return _loadCompleter.future;
  }

  ///内部保存数据
  Future<bool> _saveDataInner(List<AudioEpisodeRecord> datas) async {
    // if (ArrayUtil.isEmpty(datas)) return false;
    var s = json.encode(datas ?? []);
    return lightKV.setString(_KEY_AUDIO_RECORD, s);
  }

  /// 获取下载缓存
  Future<List<AudioEpisodeRecord>> getCachedAudios() async {
    var data = await _loadDataInner();
    return (data ?? []);
  }

  /// 保存播放记录
  /// [audioBook] 主书名
  /// [episode] 每一集
  /// [cur] 当前播放时长`秒`
  /// [duration] 音频总时长`秒`
  Future saveRecord(
      AudioBook audioBook, EpisodeModel episode, int cur, int duration) async {
    if (cur <= 0 || duration <= 0 || null == audioBook || null == episode)
      return;
    await _loadDataInner();
    var exist = _cachedAudios.firstWhere(
        (it) => (it.id == audioBook.id &&
            episode.episodeNumber == it.episodeNumber),
        orElse: () => null);
    if (null != exist) {
      _cachedAudios.remove(exist);
      exist.audioBook = audioBook;
      exist.episode = episode;
      exist.cur = cur;
      exist.duration = duration;
    } else {
      exist = AudioEpisodeRecord(audioBook, episode, cur, duration);
    }
    _cachedAudios.insert(0, exist);
    if (_cachedAudios.length >= _MAX_CACHE_COUNT) {
      _cachedAudios = _cachedAudios.sublist(0, _MAX_CACHE_COUNT);
    }
    _saveDataInner(_cachedAudios);
  }

  /// 获取播放记录
  Future<AudioEpisodeRecord> getRecord(String id, int episodeNumber) async {
    await _loadDataInner();
    var exist = _cachedAudios.firstWhere(
        (it) => (it.id == id && episodeNumber == it.episodeNumber),
        orElse: () => null);
    return exist;
  }
}

// 音频集数量记录
class AudioEpisodeRecord {
  // 主id
  String id;
  // 集数id
  int episodeNumber;
  //进度0.0 -1.0
  double get progress => cur / (duration <= 0 ? 1 : duration);
  // 当前播放时间`秒`
  int cur = 0;
  // 总时长`秒`
  int duration = 0;
  // 当前这一集的本信息；
  EpisodeModel episode;
  // 当前这一集的关联的父类信息
  AudioBook audioBook;
  AudioEpisodeRecord(this.audioBook, this.episode, this.cur, this.duration) {
    this.id = audioBook.id;
    this.episodeNumber = episode.episodeNumber;
  }
  AudioEpisodeRecord.fromJson(Map<String, dynamic> json) {
    episodeNumber = json['episodeNumber'];
    id = json['id'];
    cur = json['cur'];
    duration = json['duration'];
    episode =
        null != json['episode'] ? EpisodeModel.fromJson(json['episode']) : null;
    audioBook = null != json['audioBook']
        ? AudioBook.fromJson(json['audioBook'])
        : null;
  }
  Map<String, dynamic> toJson() {
    return {
      "episodeNumber": episodeNumber,
      "id": id,
      "cur": cur,
      "duration": duration,
      "episode": episode?.toJson(),
      "audioBook": audioBook?.toJson(),
    };
  }
}
