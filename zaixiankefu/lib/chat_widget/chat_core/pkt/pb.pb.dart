///
//  Generated code. Do not modify.
//  source: pb.proto
//
// @dart = 2.7
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class BaseMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BaseMessage', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'action', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  BaseMessage._() : super();
  factory BaseMessage({
    $core.int action,
    $core.List<$core.int> data,
  }) {
    final _result = create();
    if (action != null) {
      _result.action = action;
    }
    if (data != null) {
      _result.data = data;
    }
    return _result;
  }
  factory BaseMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BaseMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BaseMessage clone() => BaseMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BaseMessage copyWith(void Function(BaseMessage) updates) => super.copyWith((message) => updates(message as BaseMessage)) as BaseMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BaseMessage create() => BaseMessage._();
  BaseMessage createEmptyInstance() => create();
  static $pb.PbList<BaseMessage> createRepeated() => $pb.PbList<BaseMessage>();
  @$core.pragma('dart2js:noInline')
  static BaseMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BaseMessage>(create);
  static BaseMessage _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get action => $_getIZ(0);
  @$pb.TagNumber(1)
  set action($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAction() => $_has(0);
  @$pb.TagNumber(1)
  void clearAction() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);
}

class PlayerInfoFields extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PlayerInfoFields', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'platId', protoName: 'platId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'platName', protoName: 'platName')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId', protoName: 'sessionId')
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'avatar')
    ..hasRequiredFields = false
  ;

  PlayerInfoFields._() : super();
  factory PlayerInfoFields({
    $core.String id,
    $core.String username,
    $core.String platId,
    $core.String platName,
    $core.String sessionId,
    $fixnum.Int64 time,
    $core.String avatar,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (username != null) {
      _result.username = username;
    }
    if (platId != null) {
      _result.platId = platId;
    }
    if (platName != null) {
      _result.platName = platName;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (time != null) {
      _result.time = time;
    }
    if (avatar != null) {
      _result.avatar = avatar;
    }
    return _result;
  }
  factory PlayerInfoFields.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayerInfoFields.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlayerInfoFields clone() => PlayerInfoFields()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlayerInfoFields copyWith(void Function(PlayerInfoFields) updates) => super.copyWith((message) => updates(message as PlayerInfoFields)) as PlayerInfoFields; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerInfoFields create() => PlayerInfoFields._();
  PlayerInfoFields createEmptyInstance() => create();
  static $pb.PbList<PlayerInfoFields> createRepeated() => $pb.PbList<PlayerInfoFields>();
  @$core.pragma('dart2js:noInline')
  static PlayerInfoFields getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayerInfoFields>(create);
  static PlayerInfoFields _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get platId => $_getSZ(2);
  @$pb.TagNumber(3)
  set platId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPlatId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get platName => $_getSZ(3);
  @$pb.TagNumber(4)
  set platName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPlatName() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlatName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get sessionId => $_getSZ(4);
  @$pb.TagNumber(5)
  set sessionId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSessionId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSessionId() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get time => $_getI64(5);
  @$pb.TagNumber(6)
  set time($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearTime() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get avatar => $_getSZ(6);
  @$pb.TagNumber(7)
  set avatar($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasAvatar() => $_has(6);
  @$pb.TagNumber(7)
  void clearAvatar() => clearField(7);
}

class ServicerInfoFields extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ServicerInfoFields', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'avatar')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'declaration')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId', protoName: 'sessionId')
    ..hasRequiredFields = false
  ;

  ServicerInfoFields._() : super();
  factory ServicerInfoFields({
    $core.String id,
    $core.String username,
    $fixnum.Int64 time,
    $core.String avatar,
    $core.String declaration,
    $core.String sessionId,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (username != null) {
      _result.username = username;
    }
    if (time != null) {
      _result.time = time;
    }
    if (avatar != null) {
      _result.avatar = avatar;
    }
    if (declaration != null) {
      _result.declaration = declaration;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    return _result;
  }
  factory ServicerInfoFields.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServicerInfoFields.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServicerInfoFields clone() => ServicerInfoFields()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServicerInfoFields copyWith(void Function(ServicerInfoFields) updates) => super.copyWith((message) => updates(message as ServicerInfoFields)) as ServicerInfoFields; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ServicerInfoFields create() => ServicerInfoFields._();
  ServicerInfoFields createEmptyInstance() => create();
  static $pb.PbList<ServicerInfoFields> createRepeated() => $pb.PbList<ServicerInfoFields>();
  @$core.pragma('dart2js:noInline')
  static ServicerInfoFields getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServicerInfoFields>(create);
  static ServicerInfoFields _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get time => $_getI64(2);
  @$pb.TagNumber(3)
  set time($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearTime() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get avatar => $_getSZ(3);
  @$pb.TagNumber(4)
  set avatar($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAvatar() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvatar() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get declaration => $_getSZ(4);
  @$pb.TagNumber(5)
  set declaration($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDeclaration() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeclaration() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get sessionId => $_getSZ(5);
  @$pb.TagNumber(6)
  set sessionId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSessionId() => $_has(5);
  @$pb.TagNumber(6)
  void clearSessionId() => clearField(6);
}

class ChatFields extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ChatFields', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'text')
    ..pPS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'photo')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'targetId', protoName: 'targetId')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderId', protoName: 'senderId')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'messageId', protoName: 'messageId')
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isRead', $pb.PbFieldType.O3, protoName: 'isRead')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId', protoName: 'sessionId')
    ..a<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.O3)
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'duration')
    ..hasRequiredFields = false
  ;

  ChatFields._() : super();
  factory ChatFields({
    $fixnum.Int64 time,
    $core.String text,
    $core.Iterable<$core.String> photo,
    $core.String targetId,
    $core.String senderId,
    $core.String messageId,
    $core.int isRead,
    $core.String username,
    $core.String sessionId,
    $core.int type,
    $fixnum.Int64 duration,
  }) {
    final _result = create();
    if (time != null) {
      _result.time = time;
    }
    if (text != null) {
      _result.text = text;
    }
    if (photo != null) {
      _result.photo.addAll(photo);
    }
    if (targetId != null) {
      _result.targetId = targetId;
    }
    if (senderId != null) {
      _result.senderId = senderId;
    }
    if (messageId != null) {
      _result.messageId = messageId;
    }
    if (isRead != null) {
      _result.isRead = isRead;
    }
    if (username != null) {
      _result.username = username;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (type != null) {
      _result.type = type;
    }
    if (duration != null) {
      _result.duration = duration;
    }
    return _result;
  }
  factory ChatFields.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChatFields.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChatFields clone() => ChatFields()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChatFields copyWith(void Function(ChatFields) updates) => super.copyWith((message) => updates(message as ChatFields)) as ChatFields; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ChatFields create() => ChatFields._();
  ChatFields createEmptyInstance() => create();
  static $pb.PbList<ChatFields> createRepeated() => $pb.PbList<ChatFields>();
  @$core.pragma('dart2js:noInline')
  static ChatFields getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatFields>(create);
  static ChatFields _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get time => $_getI64(0);
  @$pb.TagNumber(1)
  set time($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.String> get photo => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get targetId => $_getSZ(3);
  @$pb.TagNumber(4)
  set targetId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTargetId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get senderId => $_getSZ(4);
  @$pb.TagNumber(5)
  set senderId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSenderId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSenderId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get messageId => $_getSZ(5);
  @$pb.TagNumber(6)
  set messageId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMessageId() => $_has(5);
  @$pb.TagNumber(6)
  void clearMessageId() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get isRead => $_getIZ(6);
  @$pb.TagNumber(7)
  set isRead($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasIsRead() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsRead() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get username => $_getSZ(7);
  @$pb.TagNumber(8)
  set username($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasUsername() => $_has(7);
  @$pb.TagNumber(8)
  void clearUsername() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get sessionId => $_getSZ(8);
  @$pb.TagNumber(9)
  set sessionId($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasSessionId() => $_has(8);
  @$pb.TagNumber(9)
  void clearSessionId() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get type => $_getIZ(9);
  @$pb.TagNumber(10)
  set type($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasType() => $_has(9);
  @$pb.TagNumber(10)
  void clearType() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get duration => $_getI64(10);
  @$pb.TagNumber(11)
  set duration($fixnum.Int64 v) { $_setInt64(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasDuration() => $_has(10);
  @$pb.TagNumber(11)
  void clearDuration() => clearField(11);
}

class ChatAudio extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ChatAudio', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'text')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'audio')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'targetId', protoName: 'targetId')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderId', protoName: 'senderId')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'messageId', protoName: 'messageId')
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isRead', $pb.PbFieldType.O3, protoName: 'isRead')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId', protoName: 'sessionId')
    ..a<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.O3)
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'duration')
    ..hasRequiredFields = false
  ;

  ChatAudio._() : super();
  factory ChatAudio({
    $fixnum.Int64 time,
    $core.String text,
    $core.String audio,
    $core.String targetId,
    $core.String senderId,
    $core.String messageId,
    $core.int isRead,
    $core.String username,
    $core.String sessionId,
    $core.int type,
    $fixnum.Int64 duration,
  }) {
    final _result = create();
    if (time != null) {
      _result.time = time;
    }
    if (text != null) {
      _result.text = text;
    }
    if (audio != null) {
      _result.audio = audio;
    }
    if (targetId != null) {
      _result.targetId = targetId;
    }
    if (senderId != null) {
      _result.senderId = senderId;
    }
    if (messageId != null) {
      _result.messageId = messageId;
    }
    if (isRead != null) {
      _result.isRead = isRead;
    }
    if (username != null) {
      _result.username = username;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (type != null) {
      _result.type = type;
    }
    if (duration != null) {
      _result.duration = duration;
    }
    return _result;
  }
  factory ChatAudio.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChatAudio.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChatAudio clone() => ChatAudio()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChatAudio copyWith(void Function(ChatAudio) updates) => super.copyWith((message) => updates(message as ChatAudio)) as ChatAudio; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ChatAudio create() => ChatAudio._();
  ChatAudio createEmptyInstance() => create();
  static $pb.PbList<ChatAudio> createRepeated() => $pb.PbList<ChatAudio>();
  @$core.pragma('dart2js:noInline')
  static ChatAudio getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatAudio>(create);
  static ChatAudio _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get time => $_getI64(0);
  @$pb.TagNumber(1)
  set time($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get audio => $_getSZ(2);
  @$pb.TagNumber(3)
  set audio($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAudio() => $_has(2);
  @$pb.TagNumber(3)
  void clearAudio() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get targetId => $_getSZ(3);
  @$pb.TagNumber(4)
  set targetId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTargetId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get senderId => $_getSZ(4);
  @$pb.TagNumber(5)
  set senderId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSenderId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSenderId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get messageId => $_getSZ(5);
  @$pb.TagNumber(6)
  set messageId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMessageId() => $_has(5);
  @$pb.TagNumber(6)
  void clearMessageId() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get isRead => $_getIZ(6);
  @$pb.TagNumber(7)
  set isRead($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasIsRead() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsRead() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get username => $_getSZ(7);
  @$pb.TagNumber(8)
  set username($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasUsername() => $_has(7);
  @$pb.TagNumber(8)
  void clearUsername() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get sessionId => $_getSZ(8);
  @$pb.TagNumber(9)
  set sessionId($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasSessionId() => $_has(8);
  @$pb.TagNumber(9)
  void clearSessionId() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get type => $_getIZ(9);
  @$pb.TagNumber(10)
  set type($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasType() => $_has(9);
  @$pb.TagNumber(10)
  void clearType() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get duration => $_getI64(10);
  @$pb.TagNumber(11)
  set duration($fixnum.Int64 v) { $_setInt64(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasDuration() => $_has(10);
  @$pb.TagNumber(11)
  void clearDuration() => clearField(11);
}

class ChatUserInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ChatUserInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'platName', protoName: 'platName')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'platId', protoName: 'platId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId', protoName: 'sessionId')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'avatar')
    ..aInt64(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time')
    ..pc<ChatFields>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'msgs', $pb.PbFieldType.PM, subBuilder: ChatFields.create)
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isFreezed', protoName: 'isFreezed')
    ..hasRequiredFields = false
  ;

  ChatUserInfo._() : super();
  factory ChatUserInfo({
    $core.String platName,
    $core.String platId,
    $core.String id,
    $core.String username,
    $core.String sessionId,
    $core.String avatar,
    $fixnum.Int64 time,
    $core.Iterable<ChatFields> msgs,
    $core.bool isFreezed,
  }) {
    final _result = create();
    if (platName != null) {
      _result.platName = platName;
    }
    if (platId != null) {
      _result.platId = platId;
    }
    if (id != null) {
      _result.id = id;
    }
    if (username != null) {
      _result.username = username;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (avatar != null) {
      _result.avatar = avatar;
    }
    if (time != null) {
      _result.time = time;
    }
    if (msgs != null) {
      _result.msgs.addAll(msgs);
    }
    if (isFreezed != null) {
      _result.isFreezed = isFreezed;
    }
    return _result;
  }
  factory ChatUserInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChatUserInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChatUserInfo clone() => ChatUserInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChatUserInfo copyWith(void Function(ChatUserInfo) updates) => super.copyWith((message) => updates(message as ChatUserInfo)) as ChatUserInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ChatUserInfo create() => ChatUserInfo._();
  ChatUserInfo createEmptyInstance() => create();
  static $pb.PbList<ChatUserInfo> createRepeated() => $pb.PbList<ChatUserInfo>();
  @$core.pragma('dart2js:noInline')
  static ChatUserInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatUserInfo>(create);
  static ChatUserInfo _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get platName => $_getSZ(0);
  @$pb.TagNumber(1)
  set platName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlatName() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlatName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get platId => $_getSZ(1);
  @$pb.TagNumber(2)
  set platId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlatId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get id => $_getSZ(2);
  @$pb.TagNumber(3)
  set id($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get username => $_getSZ(3);
  @$pb.TagNumber(4)
  set username($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUsername() => $_has(3);
  @$pb.TagNumber(4)
  void clearUsername() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get sessionId => $_getSZ(4);
  @$pb.TagNumber(5)
  set sessionId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSessionId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSessionId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get avatar => $_getSZ(5);
  @$pb.TagNumber(6)
  set avatar($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAvatar() => $_has(5);
  @$pb.TagNumber(6)
  void clearAvatar() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get time => $_getI64(6);
  @$pb.TagNumber(7)
  set time($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTime() => $_has(6);
  @$pb.TagNumber(7)
  void clearTime() => clearField(7);

  @$pb.TagNumber(8)
  $core.List<ChatFields> get msgs => $_getList(7);

  @$pb.TagNumber(9)
  $core.bool get isFreezed => $_getBF(8);
  @$pb.TagNumber(9)
  set isFreezed($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasIsFreezed() => $_has(8);
  @$pb.TagNumber(9)
  void clearIsFreezed() => clearField(9);
}

class ChatUserList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ChatUserList', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..pc<ChatUserInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'list', $pb.PbFieldType.PM, subBuilder: ChatUserInfo.create)
    ..hasRequiredFields = false
  ;

  ChatUserList._() : super();
  factory ChatUserList({
    $core.Iterable<ChatUserInfo> list,
  }) {
    final _result = create();
    if (list != null) {
      _result.list.addAll(list);
    }
    return _result;
  }
  factory ChatUserList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChatUserList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChatUserList clone() => ChatUserList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChatUserList copyWith(void Function(ChatUserList) updates) => super.copyWith((message) => updates(message as ChatUserList)) as ChatUserList; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ChatUserList create() => ChatUserList._();
  ChatUserList createEmptyInstance() => create();
  static $pb.PbList<ChatUserList> createRepeated() => $pb.PbList<ChatUserList>();
  @$core.pragma('dart2js:noInline')
  static ChatUserList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatUserList>(create);
  static ChatUserList _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ChatUserInfo> get list => $_getList(0);
}

class UpdateReadType extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateReadType', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderId', protoName: 'senderId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'targetId', protoName: 'targetId')
    ..pPS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'msgs')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId', protoName: 'sessionId')
    ..hasRequiredFields = false
  ;

  UpdateReadType._() : super();
  factory UpdateReadType({
    $core.String senderId,
    $core.String targetId,
    $core.Iterable<$core.String> msgs,
    $core.String sessionId,
  }) {
    final _result = create();
    if (senderId != null) {
      _result.senderId = senderId;
    }
    if (targetId != null) {
      _result.targetId = targetId;
    }
    if (msgs != null) {
      _result.msgs.addAll(msgs);
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    return _result;
  }
  factory UpdateReadType.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateReadType.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateReadType clone() => UpdateReadType()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateReadType copyWith(void Function(UpdateReadType) updates) => super.copyWith((message) => updates(message as UpdateReadType)) as UpdateReadType; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateReadType create() => UpdateReadType._();
  UpdateReadType createEmptyInstance() => create();
  static $pb.PbList<UpdateReadType> createRepeated() => $pb.PbList<UpdateReadType>();
  @$core.pragma('dart2js:noInline')
  static UpdateReadType getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateReadType>(create);
  static UpdateReadType _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get senderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set senderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSenderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSenderId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get targetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set targetId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetId() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.String> get msgs => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get sessionId => $_getSZ(3);
  @$pb.TagNumber(4)
  set sessionId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSessionId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSessionId() => clearField(4);
}

class HistoryMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HistoryMessage', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'platId', protoName: 'platId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentSessionId', protoName: 'currentSessionId')
    ..hasRequiredFields = false
  ;

  HistoryMessage._() : super();
  factory HistoryMessage({
    $core.String id,
    $core.String platId,
    $core.String currentSessionId,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (platId != null) {
      _result.platId = platId;
    }
    if (currentSessionId != null) {
      _result.currentSessionId = currentSessionId;
    }
    return _result;
  }
  factory HistoryMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HistoryMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HistoryMessage clone() => HistoryMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HistoryMessage copyWith(void Function(HistoryMessage) updates) => super.copyWith((message) => updates(message as HistoryMessage)) as HistoryMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HistoryMessage create() => HistoryMessage._();
  HistoryMessage createEmptyInstance() => create();
  static $pb.PbList<HistoryMessage> createRepeated() => $pb.PbList<HistoryMessage>();
  @$core.pragma('dart2js:noInline')
  static HistoryMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HistoryMessage>(create);
  static HistoryMessage _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get platId => $_getSZ(1);
  @$pb.TagNumber(2)
  set platId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlatId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get currentSessionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set currentSessionId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCurrentSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrentSessionId() => clearField(3);
}

class MessageList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MessageList', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId', protoName: 'sessionId')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time')
    ..pc<ChatFields>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'msgs', $pb.PbFieldType.PM, subBuilder: ChatFields.create)
    ..hasRequiredFields = false
  ;

  MessageList._() : super();
  factory MessageList({
    $core.String sessionId,
    $fixnum.Int64 time,
    $core.Iterable<ChatFields> msgs,
  }) {
    final _result = create();
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (time != null) {
      _result.time = time;
    }
    if (msgs != null) {
      _result.msgs.addAll(msgs);
    }
    return _result;
  }
  factory MessageList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MessageList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MessageList clone() => MessageList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MessageList copyWith(void Function(MessageList) updates) => super.copyWith((message) => updates(message as MessageList)) as MessageList; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MessageList create() => MessageList._();
  MessageList createEmptyInstance() => create();
  static $pb.PbList<MessageList> createRepeated() => $pb.PbList<MessageList>();
  @$core.pragma('dart2js:noInline')
  static MessageList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageList>(create);
  static MessageList _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get time => $_getI64(1);
  @$pb.TagNumber(2)
  set time($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTime() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<ChatFields> get msgs => $_getList(2);
}

class QueueInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueueInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'waitCount', $pb.PbFieldType.O3, protoName: 'waitCount')
    ..hasRequiredFields = false
  ;

  QueueInfo._() : super();
  factory QueueInfo({
    $core.int waitCount,
  }) {
    final _result = create();
    if (waitCount != null) {
      _result.waitCount = waitCount;
    }
    return _result;
  }
  factory QueueInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueueInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueueInfo clone() => QueueInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueueInfo copyWith(void Function(QueueInfo) updates) => super.copyWith((message) => updates(message as QueueInfo)) as QueueInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueueInfo create() => QueueInfo._();
  QueueInfo createEmptyInstance() => create();
  static $pb.PbList<QueueInfo> createRepeated() => $pb.PbList<QueueInfo>();
  @$core.pragma('dart2js:noInline')
  static QueueInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueueInfo>(create);
  static QueueInfo _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get waitCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set waitCount($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasWaitCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearWaitCount() => clearField(1);
}

class BannedUser extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BannedUser', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'date')
    ..hasRequiredFields = false
  ;

  BannedUser._() : super();
  factory BannedUser({
    $core.String date,
  }) {
    final _result = create();
    if (date != null) {
      _result.date = date;
    }
    return _result;
  }
  factory BannedUser.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BannedUser.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BannedUser clone() => BannedUser()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BannedUser copyWith(void Function(BannedUser) updates) => super.copyWith((message) => updates(message as BannedUser)) as BannedUser; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BannedUser create() => BannedUser._();
  BannedUser createEmptyInstance() => create();
  static $pb.PbList<BannedUser> createRepeated() => $pb.PbList<BannedUser>();
  @$core.pragma('dart2js:noInline')
  static BannedUser getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BannedUser>(create);
  static BannedUser _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get date => $_getSZ(0);
  @$pb.TagNumber(1)
  set date($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => clearField(1);
}

class EnterStatus extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EnterStatus', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderId', protoName: 'senderId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'targetId', protoName: 'targetId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'content')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId', protoName: 'sessionId')
    ..hasRequiredFields = false
  ;

  EnterStatus._() : super();
  factory EnterStatus({
    $core.String senderId,
    $core.String targetId,
    $core.String content,
    $core.String sessionId,
  }) {
    final _result = create();
    if (senderId != null) {
      _result.senderId = senderId;
    }
    if (targetId != null) {
      _result.targetId = targetId;
    }
    if (content != null) {
      _result.content = content;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    return _result;
  }
  factory EnterStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EnterStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EnterStatus clone() => EnterStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EnterStatus copyWith(void Function(EnterStatus) updates) => super.copyWith((message) => updates(message as EnterStatus)) as EnterStatus; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EnterStatus create() => EnterStatus._();
  EnterStatus createEmptyInstance() => create();
  static $pb.PbList<EnterStatus> createRepeated() => $pb.PbList<EnterStatus>();
  @$core.pragma('dart2js:noInline')
  static EnterStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EnterStatus>(create);
  static EnterStatus _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get senderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set senderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSenderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSenderId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get targetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set targetId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get content => $_getSZ(2);
  @$pb.TagNumber(3)
  set content($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get sessionId => $_getSZ(3);
  @$pb.TagNumber(4)
  set sessionId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSessionId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSessionId() => clearField(4);
}

class FreezePlayer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'FreezePlayer', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId', protoName: 'userId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'opUserId', protoName: 'opUserId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'reason')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  FreezePlayer._() : super();
  factory FreezePlayer({
    $fixnum.Int64 time,
    $core.String userId,
    $core.String opUserId,
    $core.String reason,
    $core.int type,
  }) {
    final _result = create();
    if (time != null) {
      _result.time = time;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    if (opUserId != null) {
      _result.opUserId = opUserId;
    }
    if (reason != null) {
      _result.reason = reason;
    }
    if (type != null) {
      _result.type = type;
    }
    return _result;
  }
  factory FreezePlayer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FreezePlayer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FreezePlayer clone() => FreezePlayer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FreezePlayer copyWith(void Function(FreezePlayer) updates) => super.copyWith((message) => updates(message as FreezePlayer)) as FreezePlayer; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FreezePlayer create() => FreezePlayer._();
  FreezePlayer createEmptyInstance() => create();
  static $pb.PbList<FreezePlayer> createRepeated() => $pb.PbList<FreezePlayer>();
  @$core.pragma('dart2js:noInline')
  static FreezePlayer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FreezePlayer>(create);
  static FreezePlayer _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get time => $_getI64(0);
  @$pb.TagNumber(1)
  set time($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get opUserId => $_getSZ(2);
  @$pb.TagNumber(3)
  set opUserId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOpUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOpUserId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get type => $_getIZ(4);
  @$pb.TagNumber(5)
  set type($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasType() => $_has(4);
  @$pb.TagNumber(5)
  void clearType() => clearField(5);
}

class EvaluateScore extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EvaluateScore', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId', protoName: 'sessionId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'content')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'score', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  EvaluateScore._() : super();
  factory EvaluateScore({
    $core.String sessionId,
    $core.String content,
    $core.int score,
  }) {
    final _result = create();
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (content != null) {
      _result.content = content;
    }
    if (score != null) {
      _result.score = score;
    }
    return _result;
  }
  factory EvaluateScore.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EvaluateScore.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EvaluateScore clone() => EvaluateScore()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EvaluateScore copyWith(void Function(EvaluateScore) updates) => super.copyWith((message) => updates(message as EvaluateScore)) as EvaluateScore; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EvaluateScore create() => EvaluateScore._();
  EvaluateScore createEmptyInstance() => create();
  static $pb.PbList<EvaluateScore> createRepeated() => $pb.PbList<EvaluateScore>();
  @$core.pragma('dart2js:noInline')
  static EvaluateScore getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EvaluateScore>(create);
  static EvaluateScore _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get content => $_getSZ(1);
  @$pb.TagNumber(2)
  set content($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get score => $_getIZ(2);
  @$pb.TagNumber(3)
  set score($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasScore() => $_has(2);
  @$pb.TagNumber(3)
  void clearScore() => clearField(3);
}

class RejectPlayer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RejectPlayer', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.O3)
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time')
    ..hasRequiredFields = false
  ;

  RejectPlayer._() : super();
  factory RejectPlayer({
    $core.int type,
    $fixnum.Int64 time,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (time != null) {
      _result.time = time;
    }
    return _result;
  }
  factory RejectPlayer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RejectPlayer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RejectPlayer clone() => RejectPlayer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RejectPlayer copyWith(void Function(RejectPlayer) updates) => super.copyWith((message) => updates(message as RejectPlayer)) as RejectPlayer; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RejectPlayer create() => RejectPlayer._();
  RejectPlayer createEmptyInstance() => create();
  static $pb.PbList<RejectPlayer> createRepeated() => $pb.PbList<RejectPlayer>();
  @$core.pragma('dart2js:noInline')
  static RejectPlayer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RejectPlayer>(create);
  static RejectPlayer _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get time => $_getI64(1);
  @$pb.TagNumber(2)
  set time($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTime() => clearField(2);
}

class PlayerInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PlayerInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'avatar')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'platId', protoName: 'platId')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'platName', protoName: 'platName')
    ..hasRequiredFields = false
  ;

  PlayerInfo._() : super();
  factory PlayerInfo({
    $core.String id,
    $core.String username,
    $core.String avatar,
    $core.String platId,
    $core.String platName,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (username != null) {
      _result.username = username;
    }
    if (avatar != null) {
      _result.avatar = avatar;
    }
    if (platId != null) {
      _result.platId = platId;
    }
    if (platName != null) {
      _result.platName = platName;
    }
    return _result;
  }
  factory PlayerInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayerInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlayerInfo clone() => PlayerInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlayerInfo copyWith(void Function(PlayerInfo) updates) => super.copyWith((message) => updates(message as PlayerInfo)) as PlayerInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerInfo create() => PlayerInfo._();
  PlayerInfo createEmptyInstance() => create();
  static $pb.PbList<PlayerInfo> createRepeated() => $pb.PbList<PlayerInfo>();
  @$core.pragma('dart2js:noInline')
  static PlayerInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayerInfo>(create);
  static PlayerInfo _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get avatar => $_getSZ(2);
  @$pb.TagNumber(3)
  set avatar($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAvatar() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvatar() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get platId => $_getSZ(3);
  @$pb.TagNumber(4)
  set platId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPlatId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlatId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get platName => $_getSZ(4);
  @$pb.TagNumber(5)
  set platName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPlatName() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlatName() => clearField(5);
}

class PlayerDisconnect extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PlayerDisconnect', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerId', protoName: 'playerId')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'platId', protoName: 'platId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'platName', protoName: 'platName')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerName', protoName: 'playerName')
    ..hasRequiredFields = false
  ;

  PlayerDisconnect._() : super();
  factory PlayerDisconnect({
    $core.String playerId,
    $fixnum.Int64 time,
    $core.String platId,
    $core.String platName,
    $core.String playerName,
  }) {
    final _result = create();
    if (playerId != null) {
      _result.playerId = playerId;
    }
    if (time != null) {
      _result.time = time;
    }
    if (platId != null) {
      _result.platId = platId;
    }
    if (platName != null) {
      _result.platName = platName;
    }
    if (playerName != null) {
      _result.playerName = playerName;
    }
    return _result;
  }
  factory PlayerDisconnect.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayerDisconnect.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlayerDisconnect clone() => PlayerDisconnect()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlayerDisconnect copyWith(void Function(PlayerDisconnect) updates) => super.copyWith((message) => updates(message as PlayerDisconnect)) as PlayerDisconnect; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerDisconnect create() => PlayerDisconnect._();
  PlayerDisconnect createEmptyInstance() => create();
  static $pb.PbList<PlayerDisconnect> createRepeated() => $pb.PbList<PlayerDisconnect>();
  @$core.pragma('dart2js:noInline')
  static PlayerDisconnect getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayerDisconnect>(create);
  static PlayerDisconnect _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set playerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayerId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get time => $_getI64(1);
  @$pb.TagNumber(2)
  set time($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTime() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get platId => $_getSZ(2);
  @$pb.TagNumber(3)
  set platId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPlatId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get platName => $_getSZ(3);
  @$pb.TagNumber(4)
  set platName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPlatName() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlatName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get playerName => $_getSZ(4);
  @$pb.TagNumber(5)
  set playerName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPlayerName() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlayerName() => clearField(5);
}

class PlayerChangRole extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PlayerChangRole', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerId', protoName: 'playerId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerName', protoName: 'playerName')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'platId', protoName: 'platId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'platName', protoName: 'platName')
    ..aInt64(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time')
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'oldPType', $pb.PbFieldType.O3, protoName: 'oldPType')
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentPType', $pb.PbFieldType.O3, protoName: 'currentPType')
    ..hasRequiredFields = false
  ;

  PlayerChangRole._() : super();
  factory PlayerChangRole({
    $core.String playerId,
    $core.String playerName,
    $core.String platId,
    $core.String platName,
    $fixnum.Int64 time,
    $core.int oldPType,
    $core.int currentPType,
  }) {
    final _result = create();
    if (playerId != null) {
      _result.playerId = playerId;
    }
    if (playerName != null) {
      _result.playerName = playerName;
    }
    if (platId != null) {
      _result.platId = platId;
    }
    if (platName != null) {
      _result.platName = platName;
    }
    if (time != null) {
      _result.time = time;
    }
    if (oldPType != null) {
      _result.oldPType = oldPType;
    }
    if (currentPType != null) {
      _result.currentPType = currentPType;
    }
    return _result;
  }
  factory PlayerChangRole.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayerChangRole.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlayerChangRole clone() => PlayerChangRole()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlayerChangRole copyWith(void Function(PlayerChangRole) updates) => super.copyWith((message) => updates(message as PlayerChangRole)) as PlayerChangRole; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerChangRole create() => PlayerChangRole._();
  PlayerChangRole createEmptyInstance() => create();
  static $pb.PbList<PlayerChangRole> createRepeated() => $pb.PbList<PlayerChangRole>();
  @$core.pragma('dart2js:noInline')
  static PlayerChangRole getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayerChangRole>(create);
  static PlayerChangRole _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set playerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayerId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get playerName => $_getSZ(1);
  @$pb.TagNumber(2)
  set playerName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlayerName() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get platId => $_getSZ(2);
  @$pb.TagNumber(3)
  set platId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPlatId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get platName => $_getSZ(3);
  @$pb.TagNumber(4)
  set platName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPlatName() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlatName() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get time => $_getI64(4);
  @$pb.TagNumber(5)
  set time($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearTime() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get oldPType => $_getIZ(5);
  @$pb.TagNumber(6)
  set oldPType($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasOldPType() => $_has(5);
  @$pb.TagNumber(6)
  void clearOldPType() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get currentPType => $_getIZ(6);
  @$pb.TagNumber(7)
  set currentPType($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCurrentPType() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrentPType() => clearField(7);
}

class Heartbeat extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Heartbeat', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time')
    ..hasRequiredFields = false
  ;

  Heartbeat._() : super();
  factory Heartbeat({
    $fixnum.Int64 time,
  }) {
    final _result = create();
    if (time != null) {
      _result.time = time;
    }
    return _result;
  }
  factory Heartbeat.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Heartbeat.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Heartbeat clone() => Heartbeat()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Heartbeat copyWith(void Function(Heartbeat) updates) => super.copyWith((message) => updates(message as Heartbeat)) as Heartbeat; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Heartbeat create() => Heartbeat._();
  Heartbeat createEmptyInstance() => create();
  static $pb.PbList<Heartbeat> createRepeated() => $pb.PbList<Heartbeat>();
  @$core.pragma('dart2js:noInline')
  static Heartbeat getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Heartbeat>(create);
  static Heartbeat _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get time => $_getI64(0);
  @$pb.TagNumber(1)
  set time($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => clearField(1);
}

class WaiterDisconnect extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WaiterDisconnect', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'waiterId', protoName: 'waiterId')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'notice')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'waiterName', protoName: 'waiterName')
    ..hasRequiredFields = false
  ;

  WaiterDisconnect._() : super();
  factory WaiterDisconnect({
    $core.String waiterId,
    $fixnum.Int64 time,
    $core.String notice,
    $core.String waiterName,
  }) {
    final _result = create();
    if (waiterId != null) {
      _result.waiterId = waiterId;
    }
    if (time != null) {
      _result.time = time;
    }
    if (notice != null) {
      _result.notice = notice;
    }
    if (waiterName != null) {
      _result.waiterName = waiterName;
    }
    return _result;
  }
  factory WaiterDisconnect.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WaiterDisconnect.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WaiterDisconnect clone() => WaiterDisconnect()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WaiterDisconnect copyWith(void Function(WaiterDisconnect) updates) => super.copyWith((message) => updates(message as WaiterDisconnect)) as WaiterDisconnect; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WaiterDisconnect create() => WaiterDisconnect._();
  WaiterDisconnect createEmptyInstance() => create();
  static $pb.PbList<WaiterDisconnect> createRepeated() => $pb.PbList<WaiterDisconnect>();
  @$core.pragma('dart2js:noInline')
  static WaiterDisconnect getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WaiterDisconnect>(create);
  static WaiterDisconnect _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get waiterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set waiterId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasWaiterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWaiterId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get time => $_getI64(1);
  @$pb.TagNumber(2)
  set time($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTime() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get notice => $_getSZ(2);
  @$pb.TagNumber(3)
  set notice($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNotice() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotice() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get waiterName => $_getSZ(3);
  @$pb.TagNumber(4)
  set waiterName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasWaiterName() => $_has(3);
  @$pb.TagNumber(4)
  void clearWaiterName() => clearField(4);
}

class ReLogin extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReLogin', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'platId', protoName: 'platId')
    ..hasRequiredFields = false
  ;

  ReLogin._() : super();
  factory ReLogin({
    $fixnum.Int64 time,
    $core.String id,
    $core.String name,
    $core.String platId,
  }) {
    final _result = create();
    if (time != null) {
      _result.time = time;
    }
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    if (platId != null) {
      _result.platId = platId;
    }
    return _result;
  }
  factory ReLogin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReLogin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReLogin clone() => ReLogin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReLogin copyWith(void Function(ReLogin) updates) => super.copyWith((message) => updates(message as ReLogin)) as ReLogin; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReLogin create() => ReLogin._();
  ReLogin createEmptyInstance() => create();
  static $pb.PbList<ReLogin> createRepeated() => $pb.PbList<ReLogin>();
  @$core.pragma('dart2js:noInline')
  static ReLogin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReLogin>(create);
  static ReLogin _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get time => $_getI64(0);
  @$pb.TagNumber(1)
  set time($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get platId => $_getSZ(3);
  @$pb.TagNumber(4)
  set platId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPlatId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlatId() => clearField(4);
}

class AppraiseTimeOut extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AppraiseTimeOut', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId', protoName: 'sessionId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderId', protoName: 'senderId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'targetId', protoName: 'targetId')
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time')
    ..aInt64(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timeDuration', protoName: 'timeDuration')
    ..hasRequiredFields = false
  ;

  AppraiseTimeOut._() : super();
  factory AppraiseTimeOut({
    $core.String sessionId,
    $core.String senderId,
    $core.String targetId,
    $fixnum.Int64 time,
    $fixnum.Int64 timeDuration,
  }) {
    final _result = create();
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (senderId != null) {
      _result.senderId = senderId;
    }
    if (targetId != null) {
      _result.targetId = targetId;
    }
    if (time != null) {
      _result.time = time;
    }
    if (timeDuration != null) {
      _result.timeDuration = timeDuration;
    }
    return _result;
  }
  factory AppraiseTimeOut.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppraiseTimeOut.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppraiseTimeOut clone() => AppraiseTimeOut()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppraiseTimeOut copyWith(void Function(AppraiseTimeOut) updates) => super.copyWith((message) => updates(message as AppraiseTimeOut)) as AppraiseTimeOut; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AppraiseTimeOut create() => AppraiseTimeOut._();
  AppraiseTimeOut createEmptyInstance() => create();
  static $pb.PbList<AppraiseTimeOut> createRepeated() => $pb.PbList<AppraiseTimeOut>();
  @$core.pragma('dart2js:noInline')
  static AppraiseTimeOut getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppraiseTimeOut>(create);
  static AppraiseTimeOut _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get senderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set senderId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSenderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSenderId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get targetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set targetId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTargetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetId() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get time => $_getI64(3);
  @$pb.TagNumber(4)
  set time($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearTime() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get timeDuration => $_getI64(4);
  @$pb.TagNumber(5)
  set timeDuration($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTimeDuration() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimeDuration() => clearField(5);
}

class ReleaseBanned extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReleaseBanned', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId', protoName: 'sessionId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'waiterId', protoName: 'waiterId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerId', protoName: 'playerId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'platId', protoName: 'platId')
    ..hasRequiredFields = false
  ;

  ReleaseBanned._() : super();
  factory ReleaseBanned({
    $core.String sessionId,
    $core.String waiterId,
    $core.String playerId,
    $core.String platId,
  }) {
    final _result = create();
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (waiterId != null) {
      _result.waiterId = waiterId;
    }
    if (playerId != null) {
      _result.playerId = playerId;
    }
    if (platId != null) {
      _result.platId = platId;
    }
    return _result;
  }
  factory ReleaseBanned.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReleaseBanned.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReleaseBanned clone() => ReleaseBanned()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReleaseBanned copyWith(void Function(ReleaseBanned) updates) => super.copyWith((message) => updates(message as ReleaseBanned)) as ReleaseBanned; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReleaseBanned create() => ReleaseBanned._();
  ReleaseBanned createEmptyInstance() => create();
  static $pb.PbList<ReleaseBanned> createRepeated() => $pb.PbList<ReleaseBanned>();
  @$core.pragma('dart2js:noInline')
  static ReleaseBanned getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReleaseBanned>(create);
  static ReleaseBanned _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get waiterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set waiterId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasWaiterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWaiterId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get playerId => $_getSZ(2);
  @$pb.TagNumber(3)
  set playerId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPlayerId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlayerId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get platId => $_getSZ(3);
  @$pb.TagNumber(4)
  set platId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPlatId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlatId() => clearField(4);
}

class CurrentSessionMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CurrentSessionMessage', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId', protoName: 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'platId', protoName: 'platId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentSessionId', protoName: 'currentSessionId')
    ..hasRequiredFields = false
  ;

  CurrentSessionMessage._() : super();
  factory CurrentSessionMessage({
    $core.String userId,
    $core.String platId,
    $core.String currentSessionId,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (platId != null) {
      _result.platId = platId;
    }
    if (currentSessionId != null) {
      _result.currentSessionId = currentSessionId;
    }
    return _result;
  }
  factory CurrentSessionMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CurrentSessionMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CurrentSessionMessage clone() => CurrentSessionMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CurrentSessionMessage copyWith(void Function(CurrentSessionMessage) updates) => super.copyWith((message) => updates(message as CurrentSessionMessage)) as CurrentSessionMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CurrentSessionMessage create() => CurrentSessionMessage._();
  CurrentSessionMessage createEmptyInstance() => create();
  static $pb.PbList<CurrentSessionMessage> createRepeated() => $pb.PbList<CurrentSessionMessage>();
  @$core.pragma('dart2js:noInline')
  static CurrentSessionMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CurrentSessionMessage>(create);
  static CurrentSessionMessage _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get platId => $_getSZ(1);
  @$pb.TagNumber(2)
  set platId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlatId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get currentSessionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set currentSessionId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCurrentSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrentSessionId() => clearField(3);
}

class AckReplyPacket extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AckReplyPacket', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pb'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'messageId', protoName: 'messageId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId', protoName: 'sessionId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'targetId', protoName: 'targetId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderId', protoName: 'senderId')
    ..hasRequiredFields = false
  ;

  AckReplyPacket._() : super();
  factory AckReplyPacket({
    $core.String messageId,
    $core.String sessionId,
    $core.String targetId,
    $core.String senderId,
  }) {
    final _result = create();
    if (messageId != null) {
      _result.messageId = messageId;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (targetId != null) {
      _result.targetId = targetId;
    }
    if (senderId != null) {
      _result.senderId = senderId;
    }
    return _result;
  }
  factory AckReplyPacket.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AckReplyPacket.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AckReplyPacket clone() => AckReplyPacket()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AckReplyPacket copyWith(void Function(AckReplyPacket) updates) => super.copyWith((message) => updates(message as AckReplyPacket)) as AckReplyPacket; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AckReplyPacket create() => AckReplyPacket._();
  AckReplyPacket createEmptyInstance() => create();
  static $pb.PbList<AckReplyPacket> createRepeated() => $pb.PbList<AckReplyPacket>();
  @$core.pragma('dart2js:noInline')
  static AckReplyPacket getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AckReplyPacket>(create);
  static AckReplyPacket _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get messageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set messageId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessageId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get targetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set targetId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTargetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get senderId => $_getSZ(3);
  @$pb.TagNumber(4)
  set senderId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSenderId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSenderId() => clearField(4);
}

